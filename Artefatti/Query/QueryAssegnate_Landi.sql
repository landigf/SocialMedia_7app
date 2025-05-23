-- Query
-- Inserimento reazione
INSERT INTO FEEDBACK (ID_Utente, ID_Autore, Data_ora_post, ID_Reazione, Data_ora)
			  VALUES (2, 1, '2023-03-01 08:15:00', 5, NOW());

-- Inserimento commento
INSERT INTO POST (ID_Autore, Data_ora, ID_Autore_fonte, Data_ora_fonte, Contenuto, Sensibile, Modificato)
VALUES (1, NOW(), 4, '2023-03-02 12:00:00', 'Buona fortuna ;)', 0, 0);

-- Elimina commento
DELETE FROM POST
WHERE ID_Autore = 4 AND Data_ora = '2023-03-02 12:00:00';