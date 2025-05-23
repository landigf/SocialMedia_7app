# query messaggistica

# Mostrare chat individuali - da ora in poi, suppongo che 1 sia il mio ID utente

SELECT 
        CASE 
            WHEN mi.ID_Sender = 1 THEN mi.ID_Ricevente
            ELSE mi.ID_Sender
        END as other_user_id, # seleziono l'ID dell'altro utente con un CASE
        u.Nickname, 
        MAX(mi.Data_ora) as ultimo_messaggio
    FROM messaggio_individuale mi
    JOIN utente u ON (mi.ID_Sender = u.ID_Utente OR mi.ID_Ricevente = u.ID_Utente)
    WHERE (mi.ID_Sender = 1 OR mi.ID_Ricevente = 1) 
    AND u.ID_Utente != 1 # escludo i messaggi inviati a sé stessi
    GROUP BY other_user_id, u.Nickname
    ORDER BY ultimo_messaggio DESC
    LIMIT 10;
    
# Mostrare chat di gruppo

SELECT g.ID_Gruppo, g.Nome, MAX(mg.Data_ora) as ultimo_messaggio
    FROM messaggio_di_gruppo mg
    JOIN gruppo g ON mg.ID_Gruppo = g.ID_Gruppo
    JOIN gruppo_has_utente ghu ON g.ID_Gruppo = ghu.ID_Gruppo
    WHERE ghu.ID_Utente = 1
    GROUP BY g.ID_Gruppo, g.Nome
    ORDER BY ultimo_messaggio DESC
    LIMIT 10;
    

# Caricare messaggi chat individuale - esempio, mostriamo la chat tra gli utenti 1 e 2

SELECT mi.ID_Sender, u.Nickname, mi.Contenuto, mi.Data_ora
    FROM messaggio_individuale mi
    JOIN utente u ON mi.ID_Sender = u.ID_Utente
    WHERE (mi.ID_Sender = 1 AND mi.ID_Ricevente = 2)
       OR (mi.ID_Sender = 2 AND mi.ID_Ricevente = 1)
    ORDER BY mi.Data_ora
    LIMIT 50;
    
# Caricare messaggi chat di gruppo - esempio, i messaggi nel gruppo 1

SELECT mg.ID_Sender, u.Nickname, mg.Contenuto, mg.Data_ora
    FROM messaggio_di_gruppo mg
    JOIN utente u ON mg.ID_Sender = u.ID_Utente
    WHERE mg.ID_Gruppo = 1
    ORDER BY mg.Data_ora DESC
    LIMIT 20;
    
    
# Invio messaggio di gruppo

INSERT INTO messaggio_di_gruppo (ID_Sender, ID_Gruppo, Data_ora, Contenuto) VALUES (1, 1, NOW(), "random");

# Invio messaggio individuale

INSERT INTO messaggio_individuale (ID_Sender, ID_Ricevente, Data_ora, Contenuto) VALUES (1, 2, NOW(), "random");

# Eliminazione ultimo messaggio di gruppo

DELETE FROM messaggio_di_gruppo WHERE ID_Sender = 1 AND ID_Gruppo = 1 ORDER BY Data_ora DESC LIMIT 1;

# Eliminazione ultimo messaggio individuale

DELETE FROM messaggio_individuale WHERE ID_Sender = 1 AND ID_Ricevente = 2 ORDER BY Data_ora DESC LIMIT 1;

# Modifica ultimo messaggio di gruppo

UPDATE messaggio_di_gruppo SET Contenuto = "modifica"
WHERE ID_Sender = 1 AND ID_Gruppo = 1 ORDER BY Data_ora DESC LIMIT 1;

# Modifica ultimo messaggio individuale

UPDATE messaggio_individuale SET Contenuto = "modifica"
WHERE ID_Sender = 1 AND ID_Ricevente = 2 ORDER BY Data_ora DESC LIMIT 1;

# Creazione gruppo

INSERT INTO gruppo (Nome, Descrizione, Foto_gruppo) VALUES ("random", "random", "foto");

# Inserimento primo utente - è anche amministratore

INSERT INTO gruppo_has_utente (ID_Gruppo, ID_Utente, Amministratore) VALUES ((SELECT MAX(ID_Gruppo) FROM gruppo), 1, 1);

# Mostrare i membri di un gruppo

SELECT u.ID_Utente, u.Nickname, ghu.Amministratore
    FROM gruppo_has_utente ghu
    JOIN utente u ON ghu.ID_Utente = u.ID_Utente
    WHERE ghu.ID_Gruppo = 1
    ORDER BY ghu.Amministratore DESC, u.Nickname;
    
