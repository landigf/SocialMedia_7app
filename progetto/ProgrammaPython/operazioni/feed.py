from datetime import datetime, timedelta

def feed(conn, sessione):
    cursor = conn.cursor(dictionary=True)
    print(f"\n📲 Ecco il feed per @{sessione['username']}")
    sessione['post_id_map'] = {}

    try:
        query = "SELECT * FROM SmartFeed_V WHERE ID_Utente = %s ORDER BY PunteggioFinale DESC"
        cursor.execute(query, (sessione["ID_utente"],))
        posts = cursor.fetchall()

        if not posts:
            print("📭 Non ci sono nuovi post da mostrare.")
            posts = suggest_trending_posts(cursor, sessione)
            if not posts:
                return

        for idx, post in enumerate(posts, start=1):
            tempo = tempo_trascorso(post["Data_ora"])

            print(f"\n📌 Post [{idx}] di @{post['NicknameAutore']} ({tempo})")
            print(f"📝 {post['Contenuto']}")

            # Reazioni con emoji
            cursor.execute(
                """
                SELECT R.ID_Reazione, R.Label, COUNT(*) AS Conteggio
                FROM FEEDBACK F
                JOIN REAZIONE R ON F.ID_Reazione = R.ID_Reazione
                WHERE F.ID_Autore = %s AND F.Data_ora_post = %s
                GROUP BY R.ID_Reazione, R.Label
                """,
                (post["ID_Autore"], post["Data_ora"])
            )
            reazioni = cursor.fetchall()
            emoji_map = {
                1: "👍", 2: "❤️", 3: "😂", 4: "😮", 5: "😢", 6: "😡"
            }
            print("🎯 Reazioni:")
            if not reazioni:
                print("  Nessuna reazione.")
            else:
                for r in reazioni:
                    emoji = emoji_map.get(r["ID_Reazione"], "❓")
                    print(f"  {emoji} {r['Label']}: {r['Conteggio']}")

            print(f"💬 Commenti totali: {post['NumCommenti']}")

            # Mostra primo commento se presente
            cursor.execute(
                """
                SELECT Contenuto, ID_Autore, Data_ora
                FROM POST
                WHERE ID_Autore_fonte = %s AND Data_ora_fonte = %s
                ORDER BY Data_ora ASC
                LIMIT 1
                """,
                (post["ID_Autore"], post["Data_ora"])
            )
            commento = cursor.fetchone()
            if commento:
                print(f"🗨️ Primo commento di ID {commento['ID_Autore']}: {commento['Contenuto']}")
                if post["NumCommenti"] > 1:
                    print("🔽 Altri commenti disponibili...")

            # Mappa e registrazione visualizzazione
            sessione['post_id_map'][idx] = (post["ID_Autore"], post["Data_ora"])

            cursor.execute(
                """
                INSERT INTO Interazioni (ID_Utente, ID_Autore, Data_ora, Tipo_interazione)
                VALUES (%s, %s, %s, 'view')
                """,
                (sessione["ID_utente"], post["ID_Autore"], post["Data_ora"])
            )
            print("-" * 50)

        conn.commit()
        print("\n✅ Visualizzazioni registrate con successo.")
        return True

    except Exception as e:
        print("❌ Errore durante il caricamento del feed:", e)
        return False
    finally:
        cursor.close()



def suggest_trending_posts(cursor, sessione):
    scelta = input("Vuoi vedere i post più popolari tra tutti gli utenti? (s/n): ").strip().lower()
    if scelta == 's':
        cursor.execute(
            """
            SELECT 
                P.ID_Autore,
                P.Data_ora,
                P.Contenuto,
                UA.Nickname AS NicknameAutore,
                UA.Foto_profilo AS FotoProfiloAutore,

                IFNULL(E.NumReazioni, 0) AS NumReazioni,
                IFNULL(E.NumCommenti, 0) AS NumCommenti,

                SUM(SF.PunteggioFinale) AS PunteggioTotale

            FROM SmartFeed_V SF
            JOIN POST P ON SF.ID_Autore = P.ID_Autore AND SF.Data_ora = P.Data_ora
            JOIN UTENTE UA ON UA.ID_Utente = P.ID_Autore

            LEFT JOIN Post_Engagement_V E 
                ON E.ID_Autore = P.ID_Autore AND E.Data_ora = P.Data_ora

            WHERE NOT EXISTS (
                SELECT 1 FROM Interazioni I
                WHERE I.ID_Utente = %s 
                AND I.ID_Autore = P.ID_Autore 
                AND I.Data_ora = P.Data_ora
                AND I.Tipo_interazione = 'view'
            )
            AND P.ID_Autore != %s

            GROUP BY P.ID_Autore, P.Data_ora
            ORDER BY PunteggioTotale DESC
            LIMIT 10

            """,
            (sessione["ID_utente"], sessione["ID_utente"])
        )
        posts = cursor.fetchall()
        if not posts:
            print("📭 Nessun post popolare disponibile al momento.\n")
            return
        print("🔥 Ecco i post più popolari del momento:\n")
        return posts
    else:
        return





def show_post(conn, id_autore, data_ora, sessione):
    cursor = conn.cursor(dictionary=True)
    try:
        # Recupera il post
        cursor.execute("""
            SELECT P.Contenuto, P.Data_ora, U.Nickname
            FROM POST P
            JOIN UTENTE U ON P.ID_Autore = U.ID_Utente
            WHERE P.ID_Autore = %s AND P.Data_ora = %s
        """, (id_autore, data_ora))
        post = cursor.fetchone()

        if not post:
            print("❌ Post non trovato.")
            return

        tempo = tempo_trascorso(post["Data_ora"])

        print("\n" + "=" * 50)
        print(f"📌 Post di @{post['Nickname']} pubblicato {tempo}")
        print(f"📝 {post['Contenuto']}")
        print("-" * 50)

        # Reazioni
        cursor.execute("""
            SELECT R.ID_Reazione, R.Label, COUNT(*) AS Conteggio
            FROM FEEDBACK F
            JOIN REAZIONE R ON F.ID_Reazione = R.ID_Reazione
            WHERE F.ID_Autore = %s AND F.Data_ora_post = %s
            GROUP BY R.ID_Reazione, R.Label
        """, (id_autore, data_ora))
        reazioni = cursor.fetchall()
        emoji_map = {
            1: "👍", 2: "❤️", 3: "😂", 4: "😮", 5: "😢", 6: "😡"
        }
        print("🎯 Reazioni:")
        if not reazioni:
            print("  Nessuna reazione.")
        else:
            for r in reazioni:
                emoji = emoji_map.get(r["ID_Reazione"], "❓")
                print(f"  {emoji} {r['Label']}: {r['Conteggio']}")

        # Commenti
        cursor.execute("""
            SELECT P.Contenuto, P.ID_Autore, P.Data_ora, U.Nickname
            FROM POST P
            JOIN UTENTE U ON P.ID_Autore = U.ID_Utente
            WHERE P.ID_Autore_fonte = %s AND P.Data_ora_fonte = %s
            ORDER BY P.Data_ora ASC
        """, (id_autore, data_ora))
        commenti = cursor.fetchall()

        print("\n💬 Commenti:")
        if not commenti:
            print("  Nessun commento.")
        else:
            for i, c in enumerate(commenti, start=1):
                tempo_c = tempo_trascorso(c["Data_ora"])
                print(f"{i}. 🗨️ @{c['Nickname']} ({tempo_c})")
                print(f"    {c['Contenuto']}")
                print("-" * 30)

        sessione["ID_post"] = (id_autore, data_ora)

    except Exception as e:
        print("❌ Errore durante la visualizzazione del post:", e)
    finally:
        cursor.close()


def react_post(conn, post_id_map, sessione):
    cursor = conn.cursor()
    try:
        post_scelto = int(input("Numero del post a cui reagire: "))
        if post_scelto not in post_id_map:
            print("❌ Numero post non valido.")
            return

        id_autore, data_ora = post_id_map[post_scelto]
        print("Scegli tipo di reazione:")
        print("1. 👍 Mi piace  2. ❤️ Amore  3. 😂 Divertente  4. 😮 Wow  5. 😢 Triste  6. 😡 Ira")
        id_reazione = int(input("Inserisci numero reazione: "))

        cursor.execute(
            "INSERT INTO FEEDBACK (ID_Utente, ID_Autore, Data_ora_post, ID_Reazione, Data_ora) "
            "VALUES (%s, %s, %s, %s, NOW())",
            (sessione["ID_utente"], id_autore, data_ora, id_reazione)
        )
        conn.commit()
        print("✅ Reazione salvata.")
        return post_id_map[post_scelto]
    except Exception as e:
        print("❌ Errore durante l'inserimento della reazione:", e)
    finally:
        cursor.close()


def comment_post(conn, post_id_map, sessione):
    cursor = conn.cursor()
    try:
        post_scelto = int(input("Numero del post da commentare: "))
        if post_scelto not in post_id_map:
            print("❌ Numero post non valido.")
            return

        id_autore, data_ora = post_id_map[post_scelto]
        testo = input("Scrivi il tuo commento: ")

        cursor.execute(
            "INSERT INTO POST (ID_Autore, Data_ora, ID_Autore_fonte, Data_ora_fonte, Contenuto, Sensibile, Modificato) "
            "VALUES (%s, NOW(), %s, %s, %s, 0, 0)",
            (sessione["ID_utente"], id_autore, data_ora, testo)
        )
        conn.commit()
        print("✅ Commento pubblicato.")
        return id_autore, data_ora
    except Exception as e:
        print("❌ Errore durante l'inserimento del commento:", e)
        return None, None
    finally:
        cursor.close()


def delete_comment(conn, sessione):
    cursor = conn.cursor()
    try:
        data_ora = input("Inserisci data/ora del commento da eliminare (formato 'YYYY-MM-DD HH:MM:SS'): ")

        cursor.execute(
            "DELETE FROM POST WHERE ID_Autore = %s AND Data_ora = %s",
            (sessione["ID_utente"], data_ora)
        )
        conn.commit()
        print("🗑️ Commento eliminato con successo.")
    except Exception as e:
        print("❌ Errore durante l'eliminazione:", e)
    finally:
        cursor.close()


def tempo_trascorso(data_ora_str):
    """Restituisce una stringa come '2 minuti fa', '3 giorni fa', ecc."""
    data_ora = datetime.strptime(str(data_ora_str), "%Y-%m-%d %H:%M:%S")
    now = datetime.now()
    diff = now - data_ora

    if diff < timedelta(minutes=1):
        return f"{diff.seconds} secondi fa"
    elif diff < timedelta(hours=1):
        minuti = diff.seconds // 60
        return f"{minuti} minuto{'i' if minuti > 1 else ''} fa"
    elif diff < timedelta(days=1):
        ore = diff.seconds // 3600
        return f"{ore} ora{'e' if ore > 1 else ''} fa"
    elif diff < timedelta(days=30):
        giorni = diff.days
        return f"{giorni} giorno{'i' if giorni > 1 else ''} fa"
    else:
        mesi = diff.days // 30
        return f"{mesi} mese{'i' if mesi > 1 else ''} fa"