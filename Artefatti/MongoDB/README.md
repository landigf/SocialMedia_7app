# Analisi Social Media con MongoDB

## Configurazione ed Esecuzione

1. Prima, installa le dipendenze necessarie:
```bash
pip install -r requirements.txt
```

2. Esegui il processo ETL per estrarre e caricare i dati:
```bash
python ETL_posts.py
```

### Esecuzione ETL

Lo script ETL_posts.py estrae tutti i post da MySQL, li trasforma in documenti MongoDB (includendo tag, menzioni, reazioni e commenti) e li carica nella collezione posts.

Output atteso:
```
[MySQL] OK 
[MongoDB] OK
[ETL] Estraggo i post da MySQL…
[ETL] Trovati XX post principali.
[ETL] Carico su MongoDB…
[MongoDB] Inseriti XX documenti in seven_app_mongo.posts
[ETL] 🎉 Operazione completata!
```

3. Esegui le query di analisi:
```bash
python run_queries.py
```

### Analisi Interattiva

Lo script run_queries_menu.py fornisce un menu interattivo per eseguire diverse query:

- Ultimi N post: mostra i post più recenti con conteggio commenti e reazioni
- Cerca post con contenuto: trova post che contengono una data stringa nel campo content
- Cerca commenti contenenti: ricerca nei commenti la stringa specificata (attraverso indice text)
- Cerca post di un autore: filtra i post per author.id

Esegui:
```bash
python run_queries_menu.py
```
Segui le istruzioni a schermo per selezionare l'operazione e inserire il parametro richiesto.

## Descrizione dei File

- `ETL_posts.py`: Gestisce il processo Extract-Transform-Load per i dati social media
- `run_queries.py`: Contiene le query MongoDB per l'analisi dei dati
- `requirements.txt`: Elenca tutte le dipendenze Python necessarie per il progetto
