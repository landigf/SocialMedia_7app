#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
ETL_posts.py

Estrazione → Trasformazione → Caricamento dei post (e commenti)
da MySQL (mysql.connector) a MongoDB (pymongo).

Prerequisiti:
  pip install mysql-connector-python pymongo

Uso:
  python ETL_posts.py
"""

import sys
from datetime import timezone
import mysql.connector
from mysql.connector import Error
import pymongo
from bson import ObjectId

# ─── CONFIGURAZIONE ──────────────────────────────────────────────────────────────

# all’inizio del file, subito dopo gli import
import MODIFYME

# MySQL
MYSQL_HOST     = MODIFYME.MYSQL_HOST
MYSQL_USER     = MODIFYME.MYSQL_USER
MYSQL_PASSWORD = MODIFYME.MYSQL_PASSWORD
MYSQL_DB       = MODIFYME.MYSQL_DB

# MongoDB
MONGO_URI  = MODIFYME.MONGO_URI
MONGO_DB   = MODIFYME.MONGO_DB
MONGO_COLL = MODIFYME.MONGO_COLL


# ─── CONNESSIONI ────────────────────────────────────────────────────────────────

def connetti_mysql():
    try:
        conn = mysql.connector.connect(
            host=MYSQL_HOST,
            database=MYSQL_DB,
            user=MYSQL_USER,
            password=MYSQL_PASSWORD
        )
        if conn.is_connected():
            return conn
    except Error as e:
        print("Errore durante la connessione a MySQL:", e)
        sys.exit(1)

def connetti_mongo():
    client = pymongo.MongoClient(MONGO_URI)
    return client[MONGO_DB][MONGO_COLL]

# ─── ETL ─────────────────────────────────────────────────────────────────────────

def extract_posts():
    """
    Estrae da MySQL:
      - tutti i post “principali” (ID_Autore_fonte IS NULL)
      - per ciascun post: tags, mentions, reactions
      - i commenti dalla stessa tabella POST (ID_Autore_fonte/Data_ora_fonte)
    """
    conn   = connetti_mysql()
    cursor = conn.cursor(dictionary=True)
    posts  = []

    # 1) Post principali
    cursor.execute("""
        SELECT ID_Autore, Data_ora, Contenuto, Sensibile, Modificato
          FROM POST
         WHERE ID_Autore_fonte IS NULL
    """)
    main_posts = cursor.fetchall()   # <-- fetchall() qui
    for p in main_posts:
        aid, dto = p["ID_Autore"], p["Data_ora"]
        doc = {
            "_id":           ObjectId(),
            "author":        {"id": aid},
            "content":       p["Contenuto"],
            "createdAt":     dto.replace(tzinfo=timezone.utc),
            "source":        None,
            "sensitive":     bool(p["Sensibile"]),
            "edited":        bool(p["Modificato"]),
            "tags":          [],
            "mentions":      [],
            "reactionsCount": 0,
            "reactions":      {},
            "comments":       []
        }

        # 2) Tags
        cursor.execute(
            "SELECT Label FROM POST_HAS_TAG WHERE ID_Autore=%s AND Data_ora=%s",
            (aid, dto)
        )
        tags = cursor.fetchall()      # <-- fetchall()
        doc["tags"] = [r["Label"] for r in tags]

        # 3) Mentions
        cursor.execute(
            "SELECT ID_Mentioned FROM MENZIONE WHERE ID_Autore=%s AND Data_ora_post=%s",
            (aid, dto)
        )
        mentions = cursor.fetchall() # <-- fetchall()
        doc["mentions"] = [r["ID_Mentioned"] for r in mentions]

        # 4) Reactions
        cursor.execute("""
            SELECT r.Label AS tipo, COUNT(*) AS cnt
              FROM FEEDBACK f
              JOIN REAZIONE r ON r.ID_Reazione = f.ID_Reazione
             WHERE f.ID_Autore=%s AND f.Data_ora_post=%s
             GROUP BY r.Label
        """, (aid, dto))
        reactions = cursor.fetchall() # <-- fetchall()
        reac = { r["tipo"]: r["cnt"] for r in reactions }
        doc["reactions"]      = reac
        doc["reactionsCount"] = sum(reac.values())

        # 5) Comments (post “figli”)
        cursor.execute("""
            SELECT c.ID_Autore    AS cuid,
                   u.Nickname     AS cnick,
                   c.Contenuto    AS ctext,
                   c.Data_ora     AS cdate
              FROM POST c
              JOIN UTENTE u ON u.ID_Utente = c.ID_Autore
             WHERE c.ID_Autore_fonte = %s
               AND c.Data_ora_fonte = %s
        """, (aid, dto))
        comments = cursor.fetchall()  # <-- fetchall()
        for c in comments:
            doc["comments"].append({
                "_id":       ObjectId(),
                "author":    {"id": c["cuid"], "nickname": c["cnick"]},
                "content":   c["ctext"],
                "createdAt": c["cdate"].replace(tzinfo=timezone.utc),
                "likesCount": 0   # estendi se serve
            })

        posts.append(doc)

    cursor.close()
    conn.close()
    return posts

def load_posts(docs):
    coll = connetti_mongo()
    coll.drop()
    coll.insert_many(docs)
    print(f"[MongoDB] Inseriti {len(docs)} documenti in {MONGO_DB}.{MONGO_COLL}")

# ─── MAIN ────────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    connetti_mysql();   print("[MySQL] OK")
    connetti_mongo();   print("[MongoDB] OK")

    print("[ETL] Estraggo i post da MySQL…")
    posts = extract_posts()
    print(f"[ETL] Trovati {len(posts)} post principali.")
    print("[ETL] Carico su MongoDB…")
    load_posts(posts)
    print("[ETL] 🎉 Operazione completata!")
