# 7app – Terminal Social Media Prototype

> Progetto d’esame del corso di **Basi di Dati** (Laurea Triennale in Statistica per i Big Data)
>
> Autori: Cavallaro Matteo · Ferrandino Salvatore · Gravina Lorenzo · Landi Gennaro Francesco

---

## Indice

1. [Obiettivo](#obiettivo)
2. [Caratteristiche principali](#caratteristiche-principali)
3. [Architettura del progetto](#architettura-del-progetto)
4. [Prerequisiti](#prerequisiti)
5. [Setup passo‑passo](#setup-passo-passo)
6. [Avvio dell’applicazione](#avvio-dellapplicazione)
7. [Flusso di utilizzo](#flusso-di-utilizzo)
8. [Struttura del codice](#struttura-del-codice)
9. [Riferimenti](#riferimenti)

---

## Obiettivo

Realizzare un *proof‑of‑concept* di social network – denominato **7app** – che giri interamente su terminale e metta in pratica i concetti di progettazione, modellazione e interrogazione di database relazionali affrontati durante il corso.

L’attenzione è rivolta a:

* **modellazione E‑R**, normalizzazione e physical design su MySQL;
* gestione dello **stato dell’utente** e presentazione di operazioni dinamiche;
* implementazione modulare in **Python** con approccio MVC semplificato.

## Caratteristiche principali

| Macro‑funzione         | Cosa puoi fare                                             |
| ---------------------- | ---------------------------------------------------------- |
| Autenticazione         | Registrazione, login, logout (con hash SHA‑256)            |
| Feed (stile Instagram) | Scroll dei post, reazioni emoji, commenti, refresh         |
| Post personali         | Creazione, modifica, cancellazione, tagging, menzioni      |
| Messaggistica 1‑to‑1   | Elenco chat, apertura, invio messaggi, caricamento storico |
| Ricerca & Social graph | Ricerca utenti / gruppi, follow, join / leave group        |
| Profilo                | Visualizzazione/edizione profilo, friendlist, post utente  |
| Notifiche              | Notifiche follow e menzioni, alert in tempo reale          |

Tutte le query interagiscono con **procedure SQL** e **view** dedicate per ottimizzare le prestazioni e mantenere la logica business lato DB.

## Architettura del progetto

```text
┌── menu.py               # entry‑point, navigation loop
│
├── gestore_operazioni.py # dispatcher: stato → funzione corretta
│
└── operazioni/           # sub‑package con le feature isolate
    ├── auth.py           # login / register
    ├── feed.py           # smart feed & post view
    ├── post.py           # CRUD post, tag, menzioni
    ├── messaggi.py       # chat individuali & gruppi
    ├── profilo.py        # profilo utente & friendlist
    ├── search.py         # ricerca globale + follow/join
    └── notifiche.py      # notifiche + check realtime

utility/connector.py      # helper per connessione MySQL (DSN, pooling …)
requirements.txt          # dipendenze Python (solo mysql‑connector‑python per ora)
```

Il **dispatcher** centrale (`gestore_operazioni.do`) si occupa di:

1. validare l’operazione richiesta rispetto allo *state machine*;
2. passare il controllo alla funzione nel modulo appropriato;
3. mantenere in memoria i dati di sessione (utente, ultimo post aperto, ecc.).

Il database espone *view* come `SmartFeed_V` per il ranking dei post e *trigger* per coerenza/ notifiche.

## Prerequisiti

* Python ≥ 3.9
* MySQL ≥ 8.0 (o compatibile MariaDB) con:

  * **utf8mb4** di default
  * utente con permessi `CREATE`, `ALTER`, `SELECT`, `INSERT`, `UPDATE`, `DELETE`
* Librerie Python → `pip install -r requirements.txt`

> **Nota:** le credenziali DB si configurano nel file `utility/connector.py` oppure via variabili d’ambiente (`DB_HOST`, `DB_USER`, …).

## Setup passo‑passo

### Per Linux/Mac

```bash
# 1. Clona il repository
$ git clone https://github.com/<org>/7app.git && cd 7app

# 2. Crea un venv
$ python -m venv venv && source venv/bin/activate

# 3. Installa le dipendenze
$ pip install -r requirements.txt

# 4. Crea il database e importa lo schema
$ mysql -u root -p < sql/schema.sql

# 5. Popola dati dummy
$ mysql -u root -p < sql/sample_data.sql
```

### Per Windows

```cmd
# 1. Clona il repository
> git clone https://github.com/<org>/7app.git
> cd 7app

# 2. Crea un venv
> python -m venv venv
> venv\Scripts\activate

# 3. Installa le dipendenze
> pip install -r requirements.txt

# 4. Crea il database e importa lo schema
> mysql -u root -p -e "source sql/schema.sql"

# 5. (Opzionale) Popola dati dummy
> mysql -u root -p -e "source sql/sample_data.sql"
```

### Configurazione connessione MySQL

Prima di avviare l'applicazione, modifica il file `utility/connector.py` inserendo le tue credenziali MySQL:

```python
config = {
  'user': 'root',
  'password': 'your_password_here',
  'host': 'localhost',
  'database': 'seven_app',
}
```

## Avvio dell'applicazione

```bash
$ python menu.py
```


All’avvio comparirà un menù numerato. Le opzioni si adattano automaticamente allo **stato corrente** (non loggato, loggato, in feed, ecc.)

## Flusso di utilizzo

1. **Register** ↠ login.
2. Il sistema controlla eventuali **nuove notifiche**.
3. Naviga tra *Feed*, *Search*, *Messages*, oppure *Profile*.
4. Ogni sezione espone comandi contestuali (es. nel feed puoi "react" o "comment").
5. Torna al menù principale in qualsiasi momento con `return_on_menu`.

## Struttura del codice

| Cartella / file         | Ruolo                                     |
| ----------------------- | ----------------------------------------- |
| `menu.py`               | loop principale, rende dinamico il menù   |
| `gestore_operazioni.py` | Finite‑state dispatcher + session store   |
| `operazioni/`           | Feature modules                           |


## Riferimenti

* *Modern Database Management*, 12th ed. Hoffer et al.
* Slide ufficiali del corso (prof. Giuseppe Fenza)
* MySQL 8 Reference Manual