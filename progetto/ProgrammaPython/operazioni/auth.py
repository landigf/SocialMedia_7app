import getpass
import hashlib


def hash_password(password: str) -> str:
    # Hash base didattico (usa bcrypt in produzione reale)
    return hashlib.sha256(password.encode()).hexdigest()


def login(conn):
    cursor = conn.cursor(dictionary=True)
    print("\n🔐 Login")
    email = input("Email: ").strip()
    password = getpass.getpass("Password: ").strip()

    try:
        cursor.execute("""
            SELECT C.ID_Utente, C.E_mail, U.Nickname
            FROM UTENTE_CREDENZIALI C
            JOIN UTENTE U ON U.ID_Utente = C.ID_Utente
            WHERE C.E_mail = %s AND C.Pass = %s
        """, (email, hash_password(password)))
        user = cursor.fetchone()

        if user:
            print(f"✅ Login riuscito! Bentornato/a @{user['Nickname']}")
            return user["ID_Utente"], user["Nickname"]
        else:
            print("❌ Credenziali non valide.")
            return None, None
    except Exception as e:
        print("❌ Errore nel login:", e)
        return None, None
    finally:
        cursor.close()


def register(conn):
    cursor = conn.cursor()
    print("\n🆕 Registrazione a 7app")

    try:
        # --- Nickname ---
        while True:
            nickname = input("📛 Scegli il tuo nickname: ").strip()
            cursor.execute("SELECT COUNT(*) FROM UTENTE WHERE Nickname = %s", (nickname,))
            if cursor.fetchone()[0] > 0:
                print("❌ Questo nickname è già in uso. Riprova.")
            else:
                break

        # --- Email ---
        while True:
            email = input("📧 Inserisci la tua email: ").strip()
            cursor.execute("SELECT COUNT(*) FROM UTENTE_CREDENZIALI WHERE E_mail = %s", (email,))
            if cursor.fetchone()[0] > 0:
                print("❌ Questa email è già registrata. Riprova.")
            else:
                break

        # --- Altri dati ---
        nome = input("🧾 Nome completo: ").strip()
        telefono = input("📱 Numero di telefono: ").strip()

        # --- Scelta e conferma password ---
        while True:
            password = getpass.getpass("🔐 Crea una password: ").strip()
            conferma = getpass.getpass("🔁 Conferma la password: ").strip()
            if password == conferma:
                break
            print("❌ Le password non coincidono. Riprova.\n")

        data_nascita = input("🎂 Data di nascita (YYYY-MM-DD): ").strip()
        genere = input("⚧️ Genere (Maschio/Femmina/Altro): ").strip()
        pronomi = input("📣 Pronomi (es. lui/lo, lei/la, loro): ").strip()
        bio = input("✏️ Breve biografia (facoltativa): ").strip()
        link = input("🔗 Link al tuo sito o social (facoltativo): ").strip()

        # --- Contenuti Sensibili ---
        print("\n⚠️ Alcuni post su 7app possono contenere contenuti sensibili.")
        print("Se attivi questa opzione, eviterai di vedere post marcati come sensibili nel tuo feed.")
        scelta = input("Vuoi attivare il filtro contenuti sensibili? (s/n): ").strip().lower()
        contenuti_sensibili = True if scelta == 's' else False

        # --- Inserimento UTENTE ---
        cursor.execute("""
            INSERT INTO UTENTE (Nickname, Nome, Foto_profilo, Data_di_nascita, Genere, Pronomi,
                                Biografia, Telefono, Verificato, Link, Contenuti_sensibili)
            VALUES (%s, %s, NULL, %s, %s, %s, %s, %s, FALSE, %s, %s)
        """, (
            nickname, nome, data_nascita, genere, pronomi,
            bio or None, telefono, link or None, contenuti_sensibili
        ))
        id_utente = cursor.lastrowid

        # --- Inserimento CREDENZIALI ---
        cursor.execute("""
            INSERT INTO UTENTE_CREDENZIALI (ID_Utente, E_mail, Pass)
            VALUES (%s, %s, %s)
        """, (id_utente, email, hash_password(password)))

        conn.commit()
        print(f"\n✅ Registrazione completata! Benvenuto/a su 7app, @{nickname} 🎉")

    except Exception as e:
        print("\n\n❌ Errore durante la registrazione:", e, "\n\n")
        conn.rollback()
    finally:
        cursor.close()


if __name__ == '__main__':
    from perDebug.connector import connetti_db
    print("Test collegamento al db: ", end='')
    if connessione := connetti_db():
        print("✅ Successo")
        register(connessione)
        login(connessione)