import mysql.connector

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="root1234",
        database="seven_app",
        auth_plugin='mysql_native_password'
    )

def create_notification(conn, destinatario_id: int, tipo: str, messaggio: str,
                        id_target: int | None = None, data_ora_post: str | None = None):
    """
    id_target:
        - per 'post'  → ID_Autore_post   (profilo autore) + data_ora_post   != None
        - per 'follow'→ ID profilo da aprire
        - per 'message' individuale→ ID profilo da aprire
        - per 'message' group      → ID gruppo (chat di gruppo)
    """
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO NOTIFICA
              (ID_Destinatario, Tipo, Messaggio,
               ID_Autore_post,  Data_ora_post,
               Letta, Data_ora)
        VALUES (%s, %s, %s, %s, %s, 0, NOW())
    """, (destinatario_id, tipo, messaggio, id_target, data_ora_post))
    conn.commit()
    cur.close()

