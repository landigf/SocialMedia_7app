# 1. Crea un virtual env e installa le dipendenze
## Su macOS/Linux
```bash
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

## Su Windows
```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

# 2. Modifica la password MySQL
Se avete già modificato il file `MODIFYME.py` nella cartella principale, puoi saltare questo passaggio.

Aprite il file `helper.py` e modifica la password di MySQL nella funzione `get_db_connection()`:

```python
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="root1234",  # Cambia con la tua password
        database="seven_app"
    )
```

# 3. Avvia l'app
```bash
python app.py
```
