# Progetto Social Media 7App

## Struttura del progetto

In questo repository è presente la directory `ProgrammaPython` per provare l'interfaccia a riga di comando (CLI). È inoltre disponibile una `WebApp` per interagire con l'applicazione tramite browser.

## Configurazione

Prima di eseguire l'applicazione, è necessario modificare il file `connector.py` per inserire la propria password per la connessione a MySQL:

```python
# Esempio di modifica in connector.py
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="INSERISCI_QUI_LA_TUA_PASSWORD",
    database="social_media_db"
)
```

Assicurati di salvare le modifiche prima di avviare l'applicazione.