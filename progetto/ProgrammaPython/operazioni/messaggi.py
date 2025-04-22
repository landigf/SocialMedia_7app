def list_chats(conn, sessione):
    cursor = conn.cursor(dictionary=True)
    print(f"\n📨 Chat 1-to-1 per @{sessione['username']}")
    sessione["chat_id_map"] = {}

    try:
        query = """
        SELECT 
            CASE
                WHEN ID_Sender = %s THEN ID_Ricevente
                ELSE ID_Sender
            END AS Altro_ID,
            MAX(Data_ora) AS UltimoMessaggio,
            (SELECT Nickname FROM UTENTE WHERE ID_Utente = Altro_ID) AS NomeUtente
        FROM MESSAGGIO_INDIVIDUALE
        WHERE ID_Sender = %s OR ID_Ricevente = %s
        GROUP BY Altro_ID
        ORDER BY UltimoMessaggio DESC
        """
        cursor.execute(query, (sessione["ID_utente"], sessione["ID_utente"], sessione["ID_utente"]))
        chats = cursor.fetchall()

        if not chats:
            print("📭 Nessuna chat trovata.")
            return

        for i, chat in enumerate(chats, start=1):
            sessione["chat_id_map"][i] = chat["Altro_ID"]
            print(f"{i}. 🧑‍💬 Chat con @{chat['NomeUtente']}")
            print(f"   Ultimo messaggio alle: {chat['UltimoMessaggio']}")
            print("-" * 40)
    except Exception as e:
        print("❌ Errore durante il caricamento delle chat:", e)
    finally:
        cursor.close()


def open_chat(conn, sessione, limit=10):
    cursor = conn.cursor(dictionary=True)
    other_id = sessione["ID_chat"]
    try:
        query = """
        SELECT M.ID_Sender, U.Nickname, M.Contenuto, M.Data_ora
        FROM MESSAGGIO_INDIVIDUALE M
        JOIN UTENTE U ON M.ID_Sender = U.ID_Utente
        WHERE (M.ID_Sender = %s AND M.ID_Ricevente = %s)
           OR (M.ID_Sender = %s AND M.ID_Ricevente = %s)
        ORDER BY M.Data_ora DESC
        LIMIT %s
        """
        cursor.execute(query, (sessione["ID_utente"], other_id, other_id, sessione["ID_utente"], limit))
        messaggi = cursor.fetchall()[::-1]

        if not messaggi:
            print("📭 Nessun messaggio in questa chat.")
            return

        print(f"\n🗨️ Chat con @{messaggi[0]['Nickname'] if messaggi else '[utente]'}:")
        for m in messaggi:
            print(f"@{m['Nickname']} [{m['Data_ora']}]")
            print(f"  {m['Contenuto']}")
            print("-" * 40)
    except Exception as e:
        print("❌ Errore nell'apertura della chat:", e)
    finally:
        cursor.close()


def send_message(conn, sessione, other_id=None):
    if other_id is None:
        other_id = sessione["ID_chat"]
    if other_id is None:
        print("⚠️ Nessuna chat aperta.")
        return
    if sessione["ID_chat"] is None:
        print("⚠️ Apri una chat prima di inviare messaggi.")
        return

    cursor = conn.cursor()
    try:
        other_id = sessione["ID_chat"]
        testo = input("✉️ Scrivi il messaggio: ")
        cursor.execute(
            """
            INSERT INTO MESSAGGIO_INDIVIDUALE (ID_Sender, ID_Ricevente, Data_ora, Contenuto)
            VALUES (%s, %s, NOW(), %s)
            """,
            (sessione["ID_utente"], other_id, testo)
        )
        conn.commit()
        print("✅ Messaggio inviato.")
    except Exception as e:
        print("❌ Errore durante l'invio del messaggio:", e)
    finally:
        cursor.close()


def load_more_messages(conn, sessione):
    print("🔄 Caricamento di messaggi più vecchi non ancora implementato.")
