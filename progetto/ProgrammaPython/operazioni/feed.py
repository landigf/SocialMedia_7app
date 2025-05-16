from datetime import datetime, timedelta

from operazioni.notifiche import crea_notifica

def feed(conn, sessione):
    cursor = conn.cursor(dictionary=True)
    print(f"\n📲 Ecco il feed per @{sessione['username']}")
    sessione['post_id_map'] = {}

    try:
        sql = """
            SELECT 
                P.ID_Autore,
                P.Data_ora,
                U.Nickname AS NicknameAutore,
                P.Contenuto,
                SUM(CASE WHEN FB.ID_Reazione=1 THEN 1 ELSE 0 END) AS R1,
                SUM(CASE WHEN FB.ID_Reazione=2 THEN 1 ELSE 0 END) AS R2,
                SUM(CASE WHEN FB.ID_Reazione=3 THEN 1 ELSE 0 END) AS R3, 
                SUM(CASE WHEN FB.ID_Reazione=4 THEN 1 ELSE 0 END) AS R4,
                SUM(CASE WHEN FB.ID_Reazione=5 THEN 1 ELSE 0 END) AS R5,
                SUM(CASE WHEN FB.ID_Reazione=6 THEN 1 ELSE 0 END) AS R6,
                MAX(CASE WHEN FB.ID_Utente = %(uid)s 
                    THEN FB.ID_Reazione END) AS MyReaction,
                MAX(V.PunteggioFinale) AS PunteggioFinale
            FROM SmartFeed_V V
            JOIN POST P ON P.ID_Autore = V.ID_Autore 
                      AND P.Data_ora = V.Data_ora
            JOIN UTENTE U ON U.ID_Utente = P.ID_Autore
            LEFT JOIN FEEDBACK FB ON FB.ID_Autore = P.ID_Autore
                                AND FB.Data_ora_post = P.Data_ora
            WHERE P.ID_Autore_fonte IS NULL
                AND V.ID_Utente = %(uid)s
                AND NOT EXISTS (
                    SELECT 1 
                    FROM Interazioni I
                    WHERE I.ID_Utente = %(uid)s
                    AND I.ID_Autore = P.ID_Autore
                    AND I.Data_ora = P.Data_ora
                    AND I.Tipo_interazione = 'view'
                )
            GROUP BY P.ID_Autore, P.Data_ora, U.Nickname, P.Contenuto
            ORDER BY PunteggioFinale DESC
            LIMIT 20
        """
        cursor.execute(sql, {'uid': sessione["ID_utente"]})
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

            # Mostra reazioni aggregate
            print("🎯 Reazioni:")
            reactions = {
                "👍": post["R1"], "❤️": post["R2"], "😂": post["R3"],
                "😮": post["R4"], "😢": post["R5"], "😡": post["R6"]
            }
            has_reactions = False
            for emoji, count in reactions.items():
                if count:
                    print(f"  {emoji}: {count}")
                    has_reactions = True
            if not has_reactions:
                print("  Nessuna reazione.")

            sessione['post_id_map'][idx] = (post["ID_Autore"], post["Data_ora"])

        # Salviamo le visualizzazioni alla fine
        view_rows = [(sessione["ID_utente"], p["ID_Autore"], p["Data_ora"]) 
                    for p in posts]
        if view_rows:
            cursor.executemany("""
                INSERT IGNORE INTO Interazioni
                    (ID_Utente, ID_Autore, Data_ora, Tipo_interazione)
                VALUES (%s, %s, %s, 'view')
            """, view_rows)
            conn.commit()

        print("\n✅ Feed caricato con successo.")
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
            SELECT *
            FROM SmartFeed_V
            WHERE ID_Utente = %s
            ORDER BY PunteggioFinale DESC
            LIMIT 10
            """,
            (sessione["ID_utente"],)
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
        id_autore, _ = post_id_map[post_scelto]
        crea_notifica(
            conn,
            id_autore,
            'reazione',
            f"@{sessione['username']} ha reagito al tuo post."
        )
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
        crea_notifica(
            conn,
            id_autore,
            'commento',
            f"@{sessione['username']} ha commentato il tuo post."
        )
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