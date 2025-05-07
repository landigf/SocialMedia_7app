import mysql.connector
from operazioni.notifiche import crea_notifica

def search_users(conn, sessione):
    cursor = conn.cursor(dictionary=True)
    try:
        pattern = input("🔍 Inserisci parte del nickname o nome dell'utente: ").strip()
        cursor.execute("""
            SELECT ID_Utente, Nickname, Nome, Foto_profilo
            FROM UTENTE
            WHERE (Nickname LIKE %s OR Nome LIKE %s)
              AND ID_Utente != %s
            ORDER BY Nickname ASC
        """, (f"%{pattern}%", f"%{pattern}%", sessione["ID_utente"]))

        risultati = cursor.fetchall()
        if not risultati:
            print("🙅‍♀️ Nessun utente trovato.")
            return

        print("\n📋 Risultati utenti:")
        for utente in risultati:
            print(f"@{utente['Nickname']} ({utente['Nome']}) - ID: {utente['ID_Utente']}")
            print(f"🖼️ Foto: {utente['Foto_profilo']}")
            print("-" * 30)
    except Exception as e:
        print("❌ Errore nella ricerca utenti:", e)
    finally:
        cursor.close()


def follow_user(conn, sessione):
    cursor = conn.cursor()
    try:
        id_target = int(input("Inserisci l'ID dell'utente da seguire: "))
        cursor.execute(
            """
            INSERT INTO FOLLOW (ID_Sender, ID_Followed, Data_ora)
            VALUES (%s, %s, NOW())
            ON DUPLICATE KEY UPDATE Data_ora = NOW()
            """,
            (sessione["ID_utente"], id_target)
        )
        conn.commit()
        print("✅ Ora segui questo utente.")
        crea_notifica(
            conn,
            id_target,
            'follow',
            f"@{sessione['username']} ha iniziato a seguirti. {sessione['ID_utente']}"
        )
    except Exception as e:
        print("❌ Errore durante il follow:", e)
    finally:
        cursor.close()


def search_groups(conn, sessione):
    cursor = conn.cursor(dictionary=True)
    try:
        parola = input("🔍 Cerca gruppi per nome o descrizione: ").strip()
        cursor.execute("""
            SELECT ID_Gruppo, Nome, Foto_gruppo, Descrizione
            FROM GRUPPO
            WHERE Nome LIKE %s OR Descrizione LIKE %s
            ORDER BY Nome ASC
        """, (f"%{parola}%", f"%{parola}%"))
        gruppi = cursor.fetchall()

        if not gruppi:
            print("😞 Nessun gruppo trovato.")
            return

        print("\n👥 Risultati gruppi:")
        for g in gruppi:
            print(f"📛 {g['Nome']} - ID: {g['ID_Gruppo']}")
            print(f"🖼️ {g['Foto_gruppo']}")
            print(f"📄 {g['Descrizione']}")
            print("-" * 40)
    except Exception as e:
        print("❌ Errore nella ricerca gruppi:", e)
    finally:
        cursor.close()


def join_group(conn, sessione):
    cursor = conn.cursor()
    try:
        id_gruppo = int(input("🆔 Inserisci ID del gruppo a cui vuoi unirti: "))
        cursor.execute("""
            INSERT IGNORE INTO GRUPPO_HAS_UTENTE (ID_Gruppo, ID_Utente, Admin)
            VALUES (%s, %s, FALSE)
        """, (id_gruppo, sessione["ID_utente"]))
        conn.commit()
        print("✅ Ti sei unito al gruppo.")
    except Exception as e:
        print("❌ Errore durante l’unione al gruppo:", e)
    finally:
        cursor.close()


def cerca_utenti(conn, ID_utente_corrente, termine_ricerca):
    """
    Cerca utenti per nickname simile a termine_ricerca.
    Ritorna una lista di dict con ID_Utente, Nickname, StatoAmicizia.
    """
    cursor = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT u.ID_Utente, u.Nickname,
                   CASE WHEN f.ID_Sender IS NOT NULL THEN '✅ Amico' ELSE '❌ Non amico' END AS StatoAmicizia
            FROM utente u
            LEFT JOIN follow f ON f.ID_Sender = %s AND f.ID_Followed = u.ID_Utente
            WHERE u.Nickname LIKE %s AND u.ID_Utente != %s
            ORDER BY u.Nickname
            LIMIT 10
        """
        cursor.execute(query, (ID_utente_corrente, f"%{termine_ricerca}%", ID_utente_corrente))
        risultati = cursor.fetchall()
        return risultati
    except mysql.connector.Error as err:
        print(f"❌ Errore nella ricerca utenti: {err}")
        return []
    finally:
        cursor.close()