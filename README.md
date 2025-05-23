# Seven App – Guida Completa al Progetto

Struttura
```
/ (Root)
├── MODIFYME.py
├── Artefatti/
└── progetto/
```

---

## 📂 Struttura del Progetto

* **`MODIFYME.py`** (root): centralizza le credenziali MySQL e MongoDB.
* **`Artefatti/`**: documentazione di progetto

  * Modello relazionale, traccia d'esame, schemi SQL
  * **`mongoDB/`**: ETL su MongoDB e 4 query di esempio (leggi `README.md` al suo interno)
* **`progetto/`**: codice eseguibile

  * `README.md`: istruzioni di setup e utilizzo CLI/webapp
  * `menu.py`, `app.py`, `requirements.txt`

---

# ⚙️ Configurazione Iniziale

## 1. Importare il DB su MySQL (dati+schema)
La directory `Artefatti/TabelleSQL/Data_import` contiene sia i dati che lo schema del database da importare.

Per importare il database:
1. Apri MySQL Workbench
2. Vai su Server -> Data Import
3. Seleziona "Import from Self-Contained File" o "Import from Dump Project Folder" e naviga fino alla cartella `Data_import`
4. Clicca su "Refresh" per vedere le tabelle disponibili
5. Seleziona tutte le tabelle da importare
6. Clicca su "Start Import" per completare il processo

In caso di problemi, provare a seguire il video tutorial nella cartella dedicata.

## 2. Crea un virtual env e installa le dipendenze
### Su macOS/Linux
```bash
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

### Su Windows
```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

## 3. Apri **`MODIFYME.py`** (nella root) e sostituisci le seguenti righe con le tue credenziali:

   ```python
   # MODIFYME.py
   # MySQL
   MYSQL_HOST     = 'localhost'
   MYSQL_USER     = 'root'               # verifica
   MYSQL_PASSWORD = 'tua_password_mysql' # modifica
   MYSQL_DB       = 'seven_app'          # nome db, forse da modificare

   # MongoDB Atlas
   MONGO_USERNAME = 'tuo_user_atlas'     # modifica
   MONGO_PASSWORD = 'tua_password_atlas' # nome db, forse da modificare
   MONGO_URI      = 'mongodb+srv://<user>:<pass>@sevenapp.zbyc3hu.mongodb.net/seven_app_mongo?retryWrites=true&w=majority'
   MONGO_DB       = 'seven_app_mongo'    # modifica
   MONGO_COLL     = 'posts'
   ```


---

## 💻 Esecuzione Applicazione di Progetto

1. Vai nella directory dell’applicazione:

   ```bash
   cd progetto
   ```
2. Installa le dipendenze:

   ```bash
   pip install -r requirements.txt
   ```
3. Avvia l’interfaccia CLI:

   ```bash
   python menu.py
   ```
4. Avvia la webapp o il secondo script di test:

   ```bash
   python app.py
   ```
---

## 🚚 Esecuzione ETL e Analisi con MongoDB

1. Entra nella cartella dei MongoDB artefatti:

   ```bash
   cd Artefatti/mongoDB
   ```
2. Installa le dipendenze:

   ```bash
   pip install -r requirements.txt
   ```
3. Esegui l’ETL (estrazione, trasformazione, caricamento):

   ```bash
   python ETL_posts.py
   ```
4. Avvia lo script interattivo delle query:

   ```bash
   python run_queries_menu.py
   ```

---

## 📖 Altre Documentazioni

* **`Artefatti/`**: dettagli sul modello relazionale e sull’ETL MongoDB
* **`progetto/README.md`**: approfondimenti sul setup e utilizzo dell’applicazione