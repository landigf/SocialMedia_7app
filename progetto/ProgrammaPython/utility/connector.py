import mysql.connector
import os
import sys
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, ROOT_DIR)
import MODIFYME

MYSQL_HOST     = MODIFYME.MYSQL_HOST
MYSQL_USER     = MODIFYME.MYSQL_USER
MYSQL_PASSWORD = MODIFYME.MYSQL_PASSWORD
MYSQL_DB       = MODIFYME.MYSQL_DB

def connetti_db():
    return mysql.connector.connect(
        host=MYSQL_HOST,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DB
)