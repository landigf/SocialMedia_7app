def show_profile(conn, sessione, ID_utente):
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT Nickname, Nome, Foto_profilo, Data_di_nascita, Genere, Pronomi, 
                   Biografia, Telefono, Verificato, Link, Contenuti_sensibili, E_mail
            FROM UTENTE U
            JOIN UTENTE_CREDENZIALI C USING (ID_Utente)
            WHERE C.ID_Utente = %s
        """, (ID_utente,))
        user = cursor.fetchone()

        if not user:
            print("❌ Profilo non trovato.")
            return

        print(f"\n👤 Profilo di @{user['Nickname']}")
        print(f"🧾 Nome: {user['Nome']}")
        print(f"🖼️ Foto profilo: {user['Foto_profilo']}")
        print(f"🎂 Nato/a il: {user['Data_di_nascita']}")
        print(f"⚧️ Genere: {user['Genere']} - Pronomi: {user['Pronomi']}")
        print(f"🗣️ Bio: {user['Biografia']}")
        print(f"📧 Email: {user['E_mail']}")
        print(f"📱 Telefono: {user['Telefono']}")
        print(f"🌐 Link personale: {user['Link']}")
        print(f"🔒 Verificato: {'Sì' if user['Verificato'] else 'No'}")
        print(f"⚠️ Contenuti sensibili: {'Sì' if user['Contenuti_sensibili'] else 'No'}")
    except Exception as e:
        print("❌ Errore nel caricamento del profilo:", e)
    finally:
        cursor.close()


def edit_profile(conn, sessione):
    cursor = conn.cursor()
    try:
        nuovo_bio = input("✏️ Inserisci nuova bio: ")
        nuovo_link = input("🔗 Inserisci nuovo link (o lascia vuoto): ")

        cursor.execute("""
            UPDATE UTENTE
            SET Biografia = %s, Link = %s
            WHERE ID_Utente = %s
        """, (nuovo_bio, nuovo_link or None, sessione["ID_utente"]))

        conn.commit()
        print("✅ Profilo aggiornato con successo.")
    except Exception as e:
        print("❌ Errore durante l’aggiornamento:", e)
    finally:
        cursor.close()


def delete_profile(conn, sessione):
    cursor = conn.cursor()
    conferma = input("⚠️ Sei sicuro di voler eliminare DEFINITIVAMENTE il tuo profilo? (s/n): ").lower()
    if conferma != 's':
        print("❎ Operazione annullata.")
        return

    try:
        # Elimina prima credenziali
        cursor.execute("DELETE FROM UTENTE_CREDENZIALI WHERE ID_Utente = %s", (sessione["ID_utente"],))
        # Poi il profilo utente
        cursor.execute("DELETE FROM UTENTE WHERE ID_Utente = %s", (sessione["ID_utente"],))
        conn.commit()
        print("🗑️ Profilo eliminato.")
    except Exception as e:
        print("❌ Errore durante l’eliminazione del profilo:", e)
    finally:
        cursor.close()


def friendlist(conn, sessione):
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT U.Nickname, U.ID_Utente
            FROM FOLLOW F
            JOIN UTENTE U ON U.ID_Utente = F.ID_Followed
            WHERE F.ID_Sender = %s
            ORDER BY U.Nickname ASC
        """, (sessione["ID_utente"],))

        amici = cursor.fetchall()
        if not amici:
            print("👥 Nessun amico/follow trovato.")
            return

        print("\n👥 Utenti che segui:")
        for a in amici:
            print(f" - @{a['Nickname']} (ID: {a['ID_Utente']})")
    except Exception as e:
        print("❌ Errore nel recupero della friendlist:", e)
    finally:
        cursor.close()
