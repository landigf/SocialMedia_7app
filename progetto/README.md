# Progetto Social Media 7App

Questo modulo contiene l'implementazione della parte applicativa del progetto 7App, suddivisa in due componenti principali:

```
progetto/
├── ProgrammaPython/    # CLI (Command-Line Interface)
│   ├── menu.py         # Menu interattivo per comandi da terminale
│   ├── app.py          # Script di test e funzionalità extra CLI
│   └── requirements.txt
└── WebApp/             # Interfaccia Web
    ├── app.py          # Server (es. Flask/FastAPI/Django)
    ├── static/         # Risorse statiche (CSS, JS, immagini)
    ├── templates/      # Template HTML
    └── requirements.txt
```

---

## 📦 Prerequisiti

* **Python 3.8+**
* Virtual environment (opzionale ma consigliato)
* Database MySQL e MongoDB configurati (vedi `MODIFYME.py` nella root)

---

## ⚙️ Configurazione iniziale

1. Posizionatevi nella directory del progetto:

   ```bash
   cd progetto
   ```
2. Copiate il file di configurazione `MODIFYME.py` dalla root (se non già presente):

   ```bash
   cp ../MODIFYME.py .
   ```
3. Aprite `MODIFYME.py` e inserisci le credenziali per MySQL e MongoDB.
4. Attiva un virtual environment:

   ```bash
   python3 -m venv venv
   source venv/bin/activate   # Linux/macOS
   venv\Scripts\activate    # Windows PowerShell
   ```

---

## 🛠️ Installazione delle dipendenze

Per ciascuna delle due componenti:

### ProgrammaPython (CLI)

```bash
cd ProgrammaPython
pip install -r requirements.txt
```

### WebApp

```bash
cd WebApp
pip install -r requirements.txt
```

---

## 🖥️ Utilizzo

### 1) ProgrammaPython (CLI)

Avviate il menu interattivo:

```bash
python menu.py
```

Seguite le istruzioni a schermo per:

* Visualizzare gli ultimi post
* Cercare post per contenuto o autore
* Esplorare commenti e reazioni

Per testare funzionalità aggiuntive o script di utilità:

```bash
python app.py
```

### 2) WebApp

Avvia il server web:

```bash
python app.py
```

Di default il server è in ascolto su `http://localhost:8000` (o porta configurata nel file). Apri il browser e naviga all’indirizzo per:

* Visualizzare la home dei post
* Pubblicare nuovi post tramite form
* Visualizzare dettagli e commenti in modalità grafica

---

## 🔍 Architettura e flusso

1. **ProgrammaPython** e **WebApp** condividono gli stessi moduli di accesso ai database (MySQL/MongoDB) e la stessa logica di business.
2. I comandi CLI invocano funzioni che possono essere successivamente esportate come API REST nella WebApp.
3. L’integrazione con MongoDB avviene in background tramite lo script ETL (`ETL_posts.py`) presente in `Artefatti/mongoDB/`.

---

## 📚 Ulteriori risorse

* Consultate `Artefatti/` per la documentazione del modello relazionale e dello schema MongoDB.
* Nella cartella `Artefatti/mongoDB/` trovate l’ETL e gli script di query descritte nel progetto.

---

Buon testing :D