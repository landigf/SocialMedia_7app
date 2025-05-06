import mysql.connector

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="root1234",
        database="seven_app",
        auth_plugin='mysql_native_password'
    )

def create_notification(conn, destinatario_id: int,
                        tipo: str, messaggio: str,
                        id_autore_post=None, data_ora_post=None):
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO NOTIFICA
              (ID_Destinatario, Tipo, Messaggio,
               ID_Autore_post,  Data_ora_post,
               Letta, Data_ora)
        VALUES (%s, %s, %s, %s, %s, 0, NOW())
        """,
        (destinatario_id, tipo, messaggio,
         id_autore_post,  data_ora_post)
    )
    conn.commit()
    cur.close()
