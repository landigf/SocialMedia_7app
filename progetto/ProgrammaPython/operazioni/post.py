def create_post(conn, sessione):
    cursor = conn.cursor()
    try:
        print("\n📝 Crea un nuovo post")
        contenuto = input("Scrivi il contenuto del post:\n> ")
        sensibile = input("Il contenuto è sensibile? (s/n): ").strip().lower() == 's'

        cursor.execute("""
            INSERT INTO POST (ID_Autore, Data_ora, ID_Autore_fonte, Data_ora_fonte, Contenuto, Sensibile, Modificato)
            VALUES (%s, NOW(), NULL, NULL, %s, %s, 0)
        """, (sessione["ID_utente"], contenuto, sensibile))
        conn.commit()

        cursor.execute("SELECT MAX(Data_ora) AS ultima FROM POST WHERE ID_Autore = %s", (sessione["ID_utente"],))
        data_ora_post = cursor.fetchone()[0]

        # TAG
        tag_input = input("Aggiungi tag (separati da virgola, opzionale): ").strip()
        if tag_input:
            tag_list = [tag.strip().lower() for tag in tag_input.split(',')]
            for tag in tag_list:
                cursor.execute("""
                    INSERT INTO POST_HAS_TAG (Label, ID_Autore, Data_ora)
                    VALUES (%s, %s, %s)
                """, (tag, sessione["ID_utente"], data_ora_post))

        # MENZIONI
        menzioni_input = input("Vuoi menzionare qualcuno? Inserisci gli ID separati da virgola (opzionale): ").strip()
        if menzioni_input:
            id_list = [int(idm.strip()) for idm in menzioni_input.split(',') if idm.strip().isdigit()]
            for id_m in id_list:
                cursor.execute("""
                    INSERT INTO MENZIONE (ID_Autore, Data_ora_post, ID_Mentioned)
                    VALUES (%s, %s, %s)
                """, (sessione["ID_utente"], data_ora_post, id_m))

        conn.commit()
        print("✅ Post pubblicato con successo!")

    except Exception as e:
        print("❌ Errore durante la creazione del post:", e)
        conn.rollback()
    finally:
        cursor.close()


def delete_post(conn, sessione):
    if sessione["ID_post"] is None:
        print("⚠️ Nessun post selezionato.")
        return False

    id_autore, data_ora = sessione["ID_post"]
    if id_autore != sessione["ID_utente"]:
        print("❌ Non puoi eliminare un post che non ti appartiene.")
        return False

    cursor = conn.cursor()
    try:
        cursor.execute("""
            DELETE FROM POST
            WHERE ID_Autore = %s AND Data_ora = %s
        """, (id_autore, data_ora))
        conn.commit()
        return True
    except Exception as e:
        print("❌ Errore durante l’eliminazione del post:", e)
        conn.rollback()
        return False
    finally:
        cursor.close()


def modify_post(conn, sessione):
    if sessione["ID_post"] is None:
        print("⚠️ Nessun post selezionato.")
        return

    id_autore, data_ora = sessione["ID_post"]
    if id_autore != sessione["ID_utente"]:
        print("❌ Non puoi modificare un post che non ti appartiene.")
        return

    cursor = conn.cursor()
    try:
        nuovo_testo = input("✏️ Inserisci il nuovo contenuto del post:\n> ")
        cursor.execute("""
            UPDATE POST
            SET Contenuto = %s, Modificato = TRUE
            WHERE ID_Autore = %s AND Data_ora = %s
        """, (nuovo_testo, id_autore, data_ora))
        conn.commit()
        print("✅ Post aggiornato.")
    except Exception as e:
        print("❌ Errore durante la modifica del post:", e)
        conn.rollback()
    finally:
        cursor.close()


from operazioni.feed import tempo_trascorso

def show_user_posts(conn, sessione, id_utente):
    cursor = conn.cursor(dictionary=True)
    sessione["post_id_map"] = {}

    try:
        cursor.execute("""
            SELECT P.ID_Autore, P.Data_ora, P.Contenuto, U.Nickname
            FROM POST P
            JOIN UTENTE U ON P.ID_Autore = U.ID_Utente
            WHERE P.ID_Autore = %s AND P.ID_Autore_fonte IS NULL
            ORDER BY P.Data_ora DESC
        """, (id_utente,))
        posts = cursor.fetchall()

        if not posts:
            print("📭 Nessun post trovato.")
            return

        print(f"\n🗂️ Post pubblicati da @{posts[0]['Nickname']}:")
        for idx, post in enumerate(posts, start=1):
            sessione['post_id_map'][idx] = (post["ID_Autore"], post["Data_ora"])
            tempo = tempo_trascorso(post["Data_ora"])
            print(f"\n📌 Post [{idx}] - {tempo}")
            print(f"📝 {post['Contenuto']}")
            print("-" * 40)

    except Exception as e:
        print("❌ Errore nel caricamento dei post dell'utente:", e)
    finally:
        cursor.close()
