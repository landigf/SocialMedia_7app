import mysql.connector
import os
import sys
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, ROOT_DIR)
import MODIFYME

MYSQL_HOST     = MODIFYME.MYSQL_HOST
MYSQL_USER     = MODIFYME.MYSQL_USER
MYSQL_PASSWORD = MODIFYME.MYSQL_PASSWORD
MYSQL_DB       = MODIFYME.MYSQL_DB

def get_db_connection():
    return mysql.connector.connect(
        host=MYSQL_HOST,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DB
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

