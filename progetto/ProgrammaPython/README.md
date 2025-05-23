# 7App – Terminal Social Media Prototype

> **Progetto d’esame** del corso di *Basi di Dati* (Laurea Triennale in Statistica per i Big Data)
>
> **Autori**: Cavallaro Matteo · Ferrandino Salvatore · Gravina Lorenzo · Landi Gennaro Francesco

---

## Indice

1. [Obiettivo](#obiettivo)
2. [Caratteristiche principali](#caratteristiche-principali)
3. [Architettura del progetto](#architettura-del-progetto)
4. [Prerequisiti](#prerequisiti)
5. [Setup passo‑passo](#setup-passo‑passo)
6. [Avvio dell’applicazione](#avvio-dellapplicazione)
7. [Flusso di utilizzo](#flusso-di-utilizzo)
8. [Struttura del codice](#struttura-del-codice)
9. [Riferimenti](#riferimenti)

---

## Obiettivo

Realizzare un *proof‑of‑concept* di social network (7App) interamente da terminale, applicando i concetti di progettazione, modellazione e interrogazione di database relazionali affrontati nel corso.

Attention:

* **Modellazione E‑R**, normalizzazione e design fisico su MySQL
* Gestione dello **stato dell’utente** e menu dinamici
* Implementazione modulare in **Python** (pattern MVC semplificato)

---

## Caratteristiche principali

| Macro‑funzione     | Descrizione                                          |
| ------------------ | ---------------------------------------------------- |
| **Autenticazione** | Registrazione, login/logout con hash SHA‑256         |
| **Feed**           | Scroll dei post, like/react emoji, commenti, refresh |
| **CRUD Post**      | Creazione, modifica, cancellazione, tag, menzioni    |
| **Messaggistica**  | Chat 1‑to‑1 e gruppi, storico e invio messaggi       |
| **Social Graph**   | Ricerca utenti/gruppi, follow, join/leave group      |
| **Profilo**        | Visualizzazione e modifica profilo, lista amici      |
| **Notifiche**      | Alert su follow e menzioni in tempo reale            |

Tutte le interazioni avvengono tramite **stored procedure**, **view** e **trigger** in MySQL per ottimizzare performance e coerenza.

---

## Architettura del progetto

```text
progetto/ProgrammaPython/
├── menu.py               # entry‑point, loop interattivo
├── gestore_operazioni.py # dispatcher: stato utente → funzione
├── operazioni/           # feature modules
│   ├── auth.py           # login/register
│   ├── feed.py           # visualizzazione feed
│   ├── post.py           # CRUD post, tag, menzioni
│   ├── messaggi.py      # chat 1‑to‑1 e gruppi
│   ├── profilo.py       # profilo utente, friendlist
│   ├── search.py        # ricerca utenti/gruppi, follow/join
│   └── notifiche.py     # notifiche realtime
├── utility/connector.py  # helper connessione MySQL
└── requirements.txt      # dipendenze Python
```

**Flow**: `menu.py` → `gestore_operazioni.do()` → modulo operazione → database MySQL.

---

## Prerequisiti

* Python 3.8+
* MySQL 8+ con schema `seven_app` importato
* Virtual environment (consigliato)

---

## Setup passo‑passo

### 1. Configurazione credenziali

Modifica `utility/connector.py`:

```python
config = {
  'user':     'root',
  'password': 'tuo_password_mysql',
  'host':     'localhost',
  'database': 'seven_app',
}
```

### 2. Virtual Environment & Dipendenze

Per Linux/macOS:

```bash
cd progetto/ProgrammaPython
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

Per Windows (PowerShell):

```ps1
cd progetto\ProgrammaPython
python -m venv venv; .\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 3. Creazione e popolazione del DB

```bash
# Import schema e dati di esempio
mysql -u root -p < sql/schema.sql
mysql -u root -p < sql/sample_data.sql
```

---

## Avvio dell'applicazione

Da dentro `progetto/ProgrammaPython`:

```bash
python menu.py
```

Verrà mostrato un menù numerato. Le voci variano in base allo stato (ospite/loggato).

---

## Flusso di utilizzo

1. **Register** → **Login**
2. Controllo nuovi **notifiche**
3. Naviga tra **Feed**, **Search**, **Messages**, **Profile**
4. Ogni sezione propone comandi contestuali (es. `react`, `comment`)
5. Digitando `exit` o `back` torni al menù principale

---

## Struttura del codice

| File                    | Descrizione                             |
| ----------------------- | --------------------------------------- |
| `menu.py`               | Main loop, gestione input utente        |
| `gestore_operazioni.py` | State machine e dispatcher operazioni   |
| `operazioni/*.py`       | Moduli funzionali (auth, feed, post…)   |
| `utility/connector.py`  | Configurazione e pool di connessioni DB |


---

*Buona valutazione!*
