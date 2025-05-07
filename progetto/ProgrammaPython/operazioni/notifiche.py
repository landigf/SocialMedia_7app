import mysql.connector

def crea_notifica(conn, id_destinatario: int, tipo: str, messaggio: str):
    """Inserisce una notifica per un utente."""
    cursor = conn.cursor()
    try:
        cursor.execute(
            """
            INSERT INTO NOTIFICA (ID_Destinatario, Tipo, Messaggio)
            VALUES (%s, %s, %s)
            """,
            (id_destinatario, tipo, messaggio)
        )
        conn.commit()
    except Exception as e:
        conn.rollback()
        print(f"❌ Errore creando notifica: {e}")
    finally:
        cursor.close()

def get_notifiche(conn, id_utente: int, solo_non_lette=True):
    """Restituisce la lista di notifiche."""
    cursor = conn.cursor(dictionary=True)
    try:
        q = (
            """
            SELECT ID_Notifica, Tipo, Messaggio, Data_ora
            FROM NOTIFICA
            WHERE ID_Destinatario = %s
            """
        )
        params = [id_utente]
        if solo_non_lette:
            q += " AND Letta = FALSE"
        q += " ORDER BY Data_ora DESC"
        cursor.execute(q, params)
        return cursor.fetchall()
    finally:
        cursor.close()

def marca_letto(conn, id_notifica: int):
    """Segna una notifica come letta."""
    cursor = conn.cursor()
    try:
        cursor.execute(
            """
            UPDATE NOTIFICA
            SET Letta = TRUE
            WHERE ID_Notifica = %s
            """,
            (id_notifica,)
        )
        conn.commit()
    finally:
        cursor.close()

def show_notifications(conn, sessione):
    """Stampa e gestisce le notifiche correnti."""
    id_u = sessione["ID_utente"]
    notifiche = get_notifiche(conn, id_u)
    if not notifiche:
        print("\n📭 Non ci sono nuove notifiche.")
        return

    print("\n🔔 Le tue notifiche:")
    for n in notifiche:
        nid, tipo, msg, dt = n["ID_Notifica"], n["Tipo"], n["Messaggio"], n["Data_ora"]
        print(f"[{dt}] ({tipo}) {msg}")
        if tipo == 'follow':
            resp = input("   → Vuoi ricambiare il follow? (s/n): ").strip().lower()
            if resp == 's':
                cursor = conn.cursor()
                try:
                    target_id = int(msg.split()[-1])
                    cursor.execute(
                        """
                        INSERT INTO FOLLOW (ID_Sender, ID_Followed, Data_ora)
                        VALUES (%s, %s, NOW())
                        ON DUPLICATE KEY UPDATE Data_ora = NOW()
                        """,
                        (id_u, target_id)
                    )
                    conn.commit()
                    print("   ✅ Follow reciproco inviato!")
                finally:
                    cursor.close()
        marca_letto(conn, nid)

    print("✅ Tutte le notifiche sono state marcate come lette.")


def check_new_notifications(conn, sessione):
    """Controlla e stampa eventuali nuove notifiche in tempo reale."""
    id_u = sessione.get("ID_utente")
    if not id_u:
        return
    notifiche = get_notifiche(conn, id_u)
    if notifiche:
        if len(notifiche) > 1:
            print(f"\n📣 Hai {len(notifiche)} nuove notifiche!"
                  f" Ecco i dettagli:")
        else:
            print(f"\n📣 Hai una nuova notifica!"
                  f" Ecco i dettagli:")
        for n in notifiche:
            print(f"\n📣 Nuova notifica: \"{n['Messaggio']}\"",end='')
        print("\n🔔 Per rivisualizzare le notifiche con calma, seleziona l'opzione 'mostra notifiche' nel menu principale.")
    else:
        print("\n📭 Non ci sono nuove notifiche.")