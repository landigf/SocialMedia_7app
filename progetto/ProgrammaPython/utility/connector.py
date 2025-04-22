import mysql.connector
from mysql.connector import Error

def connetti_db():
    try:
        connessione = mysql.connector.connect(
            host='localhost',
            database='seven_app',
            user='root',
            password='******'
        )
        if connessione.is_connected():
            return connessione
    except Error as e:
        print('Errore durante la connessione al MySQL', e)

if __name__ == '__main__':
    print("Test collegamento al db: ", end='')
    if connetti_db():
        print("Successo")