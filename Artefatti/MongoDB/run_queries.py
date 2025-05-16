#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
run_queries_menu.py

Script interattivo per eseguire query su MongoDB:
1) Ultimi N post
2) Cerca post con contenuto contenente 'Stringa'
3) Cerca post con commenti contenenti 'Stringa'
4) Cerca post di un autore (ID)
"""

import os
import sys
from pymongo import MongoClient

# ─── CONFIGURAZIONE ──────────────────────────────────────────────────────────────
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, ROOT_DIR)
import MODIFYME

MONGO_USERNAME = MODIFYME.MONGO_USERNAME
MONGO_PASSWORD = MODIFYME.MONGO_PASSWORD
MONGO_URI = (
    f"mongodb+srv://{MONGO_USERNAME}:{MONGO_PASSWORD}"
    "@sevenapp.zbyc3hu.mongodb.net/seven_app_mongo"
    "?retryWrites=true&w=majority"
)
DB_NAME   = "seven_app_mongo"
COLL_NAME = "posts"

# ─── FUNZIONI QUERY ───────────────────────────────────────────────────────────────

def ultimi_n_post(n):
    pipeline = [
        {"$project": {
            "_id": 0,
            "authorId":       "$author.id",
            "content":        1,
            "commentsCount":  {"$size": {"$ifNull": ["$comments", []]}},
            "reactionsCount": 1,
            "createdAt":      1
        }},
        {"$sort": {"createdAt": -1}},
        {"$limit": n}
    ]
    for doc in collection.aggregate(pipeline):
        print(f"- ID Autore {doc['authorId']} | Commenti: {doc['commentsCount']} | Reazioni: {doc['reactionsCount']}")
        print(f"  {doc['content']!r} ({doc['createdAt']})\n")

def cerca_contenuto(substr):
    regex = {"$regex": substr, "$options": "i"}
    cursor = collection.find({"content": regex}).sort("createdAt", -1)
    for doc in cursor:
        print(f"- ID Autore {doc['author']['id']} | {doc['content']!r}")

def cerca_commenti(substr):
    pipeline = [
        {"$match": {"$text": {"$search": substr}}},
        {"$project": {
            "_id": 0,
            "postContent": "$content",
            "matchingComments": {"$filter": {
                "input": "$comments",
                "as":    "c",
                "cond": {"$regexMatch": {
                    "input": "$$c.content",
                    "regex": substr,
                    "options": "i"
                }}
            }}
        }}
    ]
    for doc in collection.aggregate(pipeline):
        print(f"Post: {doc['postContent']!r}")
        for c in doc["matchingComments"]:
            print(f"  • {c['content']!r}")
        print()

def cerca_autore(uid):
    cursor = collection.find({"author.id": uid}).sort("createdAt", -1)
    for doc in cursor:
        print(f"- {doc['content']!r} ({doc['createdAt']})")

# ─── MENU ────────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    client     = MongoClient(MONGO_URI)
    collection = client[DB_NAME][COLL_NAME]

    collection.create_index(
        [("comments.content", "text")],
        default_language="italian",
        name="idx_comments_it",
        background=True
    )
    while True:
        print("Seleziona un'operazione:")
        print("1) Ultimi N post")
        print("2) Cerca post con contenuto")
        print("3) Cerca post con commenti contenenti")
        print("4) Cerca post di un autore")
        print("0) Esci")
        print("")

        choice = input("Inserisci numero operazione (1-4): ").strip()

        if choice == "1":
            n = int(input("Quanti post vuoi vedere? ").strip())
            ultimi_n_post(n)

        elif choice == "2":
            s = input("Stringa da cercare nel contenuto: ").strip()
            cerca_contenuto(s)

        elif choice == "3":
            s = input("Stringa da cercare nei commenti: ").strip()
            cerca_commenti(s)

        elif choice == "4":
            uid = int(input("ID autore: ").strip())
            cerca_autore(uid)

        elif choice == "0":
            print("Ciao :)")
            sys.exit(0)

        else:
            print("Scelta non valida.")
        print("")
