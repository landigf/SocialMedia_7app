import mysql.connector
from typing import Dict
from operazioni.notifiche import crea_notifica

def list_chats(conn: mysql.connector.connection.MySQLConnection, sessione: Dict) -> None:
    ID_utente = sessione["ID_utente"]
    query_individuali = """
    SELECT 
        CASE 
            WHEN mi.ID_Sender = %s THEN mi.ID_Ricevente
            ELSE mi.ID_Sender
        END as other_user_id,
        u.Nickname, 
        MAX(mi.Data_ora) as ultimo_messaggio
    FROM messaggio_individuale mi
    JOIN utente u ON (mi.ID_Sender = u.ID_Utente OR mi.ID_Ricevente = u.ID_Utente)
    WHERE (mi.ID_Sender = %s OR mi.ID_Ricevente = %s)
    AND u.ID_Utente != %s
    GROUP BY other_user_id, u.Nickname
    ORDER BY ultimo_messaggio DESC
    LIMIT 10
    """
    query_gruppi = """
    SELECT g.ID_Gruppo, g.Nome, MAX(mg.Data_ora) as ultimo_messaggio
    FROM messaggio_di_gruppo mg
    JOIN gruppo g ON mg.ID_Gruppo = g.ID_Gruppo
    JOIN gruppo_has_utente ghu ON g.ID_Gruppo = ghu.ID_Gruppo
    WHERE ghu.ID_Utente = %s
    GROUP BY g.ID_Gruppo, g.Nome
    ORDER BY ultimo_messaggio DESC
    LIMIT 10
    """
    cursor = conn.cursor(dictionary=True)
    chat_id_map = {}
    counter = 0
    try:
        cursor.execute(query_individuali, (ID_utente, ID_utente, ID_utente, ID_utente))
        chat_individuali = cursor.fetchall()
        cursor.execute(query_gruppi, (ID_utente,))
        chat_gruppi = cursor.fetchall()
        print("\n--- CHAT INDIVIDUALI ---")
        for chat in chat_individuali:
            counter += 1
            chat_id_map[counter] = ('user', chat['other_user_id'])
            print(f"{counter}. {chat['Nickname']} - Ultimo messaggio: {chat['ultimo_messaggio']}")
        print("\n--- CHAT DI GRUPPO ---")
        for chat in chat_gruppi:
            counter += 1
            chat_id_map[counter] = ('group', chat['ID_Gruppo'])
            print(f"{counter}. {chat['Nome']} - Ultimo messaggio: {chat['ultimo_messaggio']}")
        sessione["chat_id_map"] = chat_id_map
    except mysql.connector.Error as err:
        print(f"Errore durante il recupero delle chat: {err}")
        sessione["chat_id_map"] = None
    finally:
        cursor.close()

def open_chat(conn: mysql.connector.connection.MySQLConnection, sessione: Dict) -> None:
    chat_type, chat_id = sessione["chat_id_map"][sessione["selected_chat_id"]]
    sessione["ID_chat"] = chat_id
    sessione["current_chat_type"] = chat_type
    if chat_type == 'group':
        _load_group_chat(conn, sessione, chat_id, sessione["ID_utente"])
    else:
        _load_individual_chat(conn, sessione, chat_id, sessione["ID_utente"])

def load_individual_chat(conn: mysql.connector.connection.MySQLConnection, sessione: Dict) -> None:
    _load_individual_chat(conn, sessione, sessione["ID_chat"], sessione["ID_utente"])

def load_group_chat(conn: mysql.connector.connection.MySQLConnection, sessione: Dict) -> None:
    _load_group_chat(conn, sessione, sessione["ID_chat"], sessione["ID_utente"])

def _load_individual_chat(conn, sessione, other_user_id, current_user_id):
    query = """
    SELECT mi.ID_Sender, u.Nickname, mi.Contenuto, mi.Data_ora
    FROM messaggio_individuale mi
    JOIN utente u ON mi.ID_Sender = u.ID_Utente
    WHERE (mi.ID_Sender = %s AND mi.ID_Ricevente = %s)
       OR (mi.ID_Sender = %s AND mi.ID_Ricevente = %s)
    ORDER BY mi.Data_ora
    LIMIT 50
    """
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(query, (current_user_id, other_user_id, other_user_id, current_user_id))
        messaggi = cursor.fetchall()
        cursor.execute("SELECT Nickname FROM utente WHERE ID_Utente = %s", (other_user_id,))
        other_nickname = cursor.fetchone()['Nickname']
        print(f"\n--- CHAT PRIVATA CON {other_nickname} ---")
        for msg in messaggi:
            sender = "Tu" if msg['ID_Sender'] == current_user_id else other_nickname
            print(f"[{msg['Data_ora']}] {sender}: {msg['Contenuto']}")
    except mysql.connector.Error as err:
        print(f"Errore durante il recupero dei messaggi: {err}")
        raise
    finally:
        cursor.close()

def _load_group_chat(conn: mysql.connector.connection.MySQLConnection, 
                    sessione: Dict, group_id: int, current_user_id: int) -> None:
    """
    Carica i messaggi di una chat di gruppo
    """
    # Prima verifica che l'utente sia membro del gruppo
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT 1 FROM gruppo_has_utente WHERE ID_Gruppo = %s AND ID_Utente = %s", 
                      (group_id, current_user_id))
        if not cursor.fetchone():
            print("Non sei membro di questo gruppo!")
            return
    finally:
        cursor.close()
    
    # Recupera i messaggi del gruppo
    query = """
    SELECT mg.ID_Sender, u.Nickname, mg.Contenuto, mg.Data_ora
    FROM messaggio_di_gruppo mg
    JOIN utente u ON mg.ID_Sender = u.ID_Utente
    WHERE mg.ID_Gruppo = %s
    ORDER BY mg.Data_ora DESC
    LIMIT 20
    """
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(query, (group_id,))
        messaggi = cursor.fetchall()
        
        # Recupera il nome del gruppo
        cursor.execute("SELECT Nome FROM gruppo WHERE ID_Gruppo = %s", (group_id,))
        group_name = cursor.fetchone()['Nome']
        
        print(f"\n--- GRUPPO {group_name} ---")
        for msg in reversed(messaggi):  # Mostra i messaggi dal più vecchio al più recente
            sender = "Tu" if msg['ID_Sender'] == current_user_id else msg['Nickname']
            print(f"[{msg['Data_ora']}] {sender}: {msg['Contenuto']}")
            
    except mysql.connector.Error as err:
        print(f"Errore durante il recupero dei messaggi: {err}")
    finally:
        cursor.close()

def send_message(conn, sessione, contenuto, recipient_id, chat_type=None):
    ID_utente = sessione["ID_utente"]
    is_group = (chat_type == 'group') if chat_type else _is_group_chat(conn, recipient_id)
    if is_group:
        query = "INSERT INTO messaggio_di_gruppo (ID_Sender, ID_Gruppo, Data_ora, Contenuto) VALUES (%s, %s, NOW(), %s)"
    else:
        query = "INSERT INTO messaggio_individuale (ID_Sender, ID_Ricevente, Data_ora, Contenuto) VALUES (%s, %s, NOW(), %s)"
    cursor = conn.cursor()
    try:
        cursor.execute(query, (ID_utente, recipient_id, contenuto))
        conn.commit()
        # notifica
        if is_group:
            cursor2 = conn.cursor()
            cursor2.execute("SELECT ID_Utente FROM gruppo_has_utente WHERE ID_Gruppo=%s AND ID_Utente!=%s",
                            (recipient_id, ID_utente))
            membri = cursor2.fetchall()
            cursor2.close()
            for (m,) in membri:
                crea_notifica(conn, m, 'message',
                             f"@{sessione['username']} ha scritto nel gruppo {recipient_id}.")
        else:
            crea_notifica(conn, recipient_id, 'message',
                         f"@{sessione['username']} ti ha inviato un messaggio.")
        # reload chat
        if 'ID_chat' in sessione and sessione["ID_chat"] == recipient_id:
            if is_group:
                _load_group_chat(conn, sessione, recipient_id, ID_utente)
            else:
                _load_individual_chat(conn, sessione, recipient_id, ID_utente)
        return True
    except mysql.connector.Error as err:
        conn.rollback()
        raise err
    finally:
        cursor.close()

def delete_last_message(conn, sessione):
    ID_utente = sessione["ID_utente"]
    chat_id = sessione["ID_chat"]
    is_group = sessione.get("current_chat_type") == "group"
    if is_group:
        query = "DELETE FROM messaggio_di_gruppo WHERE ID_Sender = %s AND ID_Gruppo = %s ORDER BY Data_ora DESC LIMIT 1"
    else:
        query = "DELETE FROM messaggio_individuale WHERE ID_Sender = %s AND ID_Ricevente = %s ORDER BY Data_ora DESC LIMIT 1"
    cursor = conn.cursor()
    cursor.execute(query, (ID_utente, chat_id))
    conn.commit()
    if cursor.rowcount > 0:
        print("✅ Messaggio eliminato con successo!")
        open_chat(conn, sessione)
    else:
        print("⚠️ Nessun messaggio trovato da eliminare")
    cursor.close()

def edit_last_message(conn, sessione, nuovo_contenuto):
    ID_utente = sessione["ID_utente"]
    chat_id = sessione["ID_chat"]
    is_group = sessione.get("current_chat_type") == "group"
    if is_group:
        query = """UPDATE messaggio_di_gruppo SET Contenuto = %s
                   WHERE ID_Sender = %s AND ID_Gruppo = %s ORDER BY Data_ora DESC LIMIT 1"""
    else:
        query = """UPDATE messaggio_individuale SET Contenuto = %s
                   WHERE ID_Sender = %s AND ID_Ricevente = %s ORDER BY Data_ora DESC LIMIT 1"""
    cursor = conn.cursor()
    cursor.execute(query, (nuovo_contenuto, ID_utente, chat_id))
    conn.commit()
    success = cursor.rowcount > 0
    cursor.close()
    if success:
        open_chat(conn, sessione)
    return success

def create_group(conn: mysql.connector.connection.MySQLConnection, sessione: Dict) -> None:
    """
    Crea un nuovo gruppo e rende l'utente corrente amministratore
    """
    ID_utente = sessione["ID_utente"]
    
    nome = input("Inserisci il nome del gruppo: ")
    descrizione = input("Inserisci una descrizione per il gruppo: ")
    foto = input("Inserisci l'URL di una foto per il gruppo: ")
    
    cursor = conn.cursor()
    try:
        # Crea il gruppo
        cursor.execute(
            "INSERT INTO gruppo (Nome, Descrizione, Foto_gruppo) VALUES (%s, %s, %s)",
            (nome, descrizione, foto)
        )
        group_id = cursor.lastrowid
        
        # Aggiungi l'utente come amministratore
        cursor.execute(
            "INSERT INTO gruppo_has_utente (ID_Gruppo, ID_Utente, Amministratore) VALUES (%s, %s, 1)",
            (group_id, ID_utente)
        )
        
        conn.commit()
        print(f"✅ Gruppo '{nome}' creato con successo! (ID: {group_id})")
        
    except mysql.connector.Error as err:
        print(f"Errore durante la creazione del gruppo: {err}")
        conn.rollback()
    finally:
        cursor.close()

def group_members(conn: mysql.connector.connection.MySQLConnection, sessione: Dict) -> None:
    """
    Mostra i membri di un gruppo
    """
    # Se siamo in una chat di gruppo, usa quel gruppo
    group_id = sessione.get("ID_chat")
    
    if group_id is None:
        try:
            group_id = int(input("Inserisci l'ID del gruppo di cui vuoi vedere i membri: "))
        except ValueError:
            print("ID gruppo non valido!")
            return
    
    query = """
    SELECT u.ID_Utente, u.Nickname, ghu.Amministratore
    FROM gruppo_has_utente ghu
    JOIN utente u ON ghu.ID_Utente = u.ID_Utente
    WHERE ghu.ID_Gruppo = %s
    ORDER BY ghu.Amministratore DESC, u.Nickname
    """
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(query, (group_id,))
        membri = cursor.fetchall()
        
        print("\n--- MEMBRI DEL GRUPPO ---")
        for membro in membri:
            ruolo = "Amministratore" if membro['Amministratore'] else "Membro"
            print(f"{membro['Nickname']} (ID: {membro['ID_Utente']}) - {ruolo}")
            
    except mysql.connector.Error as err:
        print(f"Errore durante il recupero dei membri del gruppo: {err}")
    finally:
        cursor.close()

def _is_group_chat(conn, chat_id):
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT 1 FROM gruppo WHERE ID_Gruppo = %s", (chat_id,))
        return cursor.fetchone() is not None
    finally:
        cursor.close()

def leave_group(conn, sessione):
    chat_id = sessione["ID_chat"]
    if chat_id is None:
        print("⚠️ Non sei in una chat di gruppo.")
        return
    # Verifica se l'ID chat è un gruppo
    if (_is_group_chat(conn, chat_id)):
        cursor = conn.cursor()
        try:
            cursor.execute("DELETE FROM gruppo_has_utente WHERE ID_Gruppo = %s AND ID_Utente = %s", (chat_id, sessione["ID_utente"]))
            conn.commit()
            print("✅ Uscito dal gruppo con successo!")
        except mysql.connector.Error as err:
            print(f"Errore durante l'uscita dal gruppo: {err}")
            conn.rollback()
        finally:
            cursor.close()