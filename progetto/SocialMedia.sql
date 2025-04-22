CREATE TABLE Interazioni (
    ID_Utente INT,
    ID_Autore INT,
    Data_ora TIMESTAMP, -- data del post
    Data_ora_interazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Tipo_interazione ENUM('view', 'reaction', 'comment') NOT NULL,
    PRIMARY KEY (ID_Utente, ID_Autore, Data_ora, Data_ora_interazione, Tipo_interazione), -- ogni evento è unico
    FOREIGN KEY (ID_Utente) REFERENCES UTENTE(ID_Utente) ON DELETE CASCADE,
    FOREIGN KEY (ID_Autore, Data_ora) REFERENCES POST(ID_Autore, Data_ora) ON DELETE CASCADE
);
-- Esempi di popolamento della tabella Interazioni

-- Popolamento tabella Interazioni
-- script interazioni

SELECT * FROM Interazioni;

DELIMITER $$
CREATE TRIGGER trg_insert_comment_interaction
AFTER INSERT ON POST
FOR EACH ROW
BEGIN
  -- Verifica che il nuovo post sia una risposta a un altro post
  IF NEW.ID_Autore_fonte IS NOT NULL AND NEW.Data_ora_fonte IS NOT NULL THEN
    INSERT INTO Interazioni (
        ID_Utente,
        ID_Autore,
        Data_ora,
        Data_ora_interazione,
        Tipo_interazione
    ) VALUES (
        NEW.ID_Autore,           -- Chi commenta
        NEW.ID_Autore_fonte,     -- Autore del post originale
        NEW.Data_ora_fonte,      -- Timestamp del post originale
        NEW.Data_ora,            -- Timestamp del commento (il nuovo post)
        'comment'
    );
  END IF;
END$$
DELIMITER ;

-- trigger per le reazioni
DELIMITER $$
CREATE TRIGGER trg_insert_feedback_interaction
AFTER INSERT ON FEEDBACK
FOR EACH ROW
BEGIN
    INSERT INTO Interazioni (
        ID_Utente,
        ID_Autore,
        Data_ora,
        Data_ora_interazione,
        Tipo_interazione
    ) VALUES (
        NEW.ID_Utente,           -- Chi ha lasciato il feedback
        NEW.ID_Autore,           -- Autore del post
        NEW.Data_ora_post,       -- Data del post
        NEW.Data_ora,            -- Quando è stato lasciato il feedback
        'reaction'
    );
END$$
DELIMITER ;


-- *************************



-- Query
-- Inserimento reazione - Gennaro
INSERT INTO FEEDBACK (ID_Utente, ID_Autore, Data_ora_post, ID_Reazione, Data_ora)
			  VALUES (2, 1, '2023-03-01 08:15:00', 5, NOW());

-- Inserimento commento - Gennaro
INSERT INTO POST (ID_Autore, Data_ora, ID_Autore_fonte, Data_ora_fonte, Contenuto, Sensibile, Modificato)
VALUES (1, NOW(), 4, '2023-03-02 12:00:00', 'Buona fortuna ;)', 0, 0);
-- Elimina commento - Gennaro
DELETE FROM POST
WHERE ID_Autore = 4 AND Data_ora = '2023-03-02 12:00:00';


-- Feed - Gennaro
-- Mi serve una vista di amici di un utente
-- con n. di amici/gruppi in comune
/*
SELECT F1.ID_Sender Utente1, F1.ID_Followed Utente2
    FROM FOLLOW F1 JOIN FOLLOW F2 ON F1.ID_Sender=F2.ID_Followed AND F1.ID_Followed=F2.ID_Sender;
*/
CREATE VIEW Amici_V AS (
SELECT F1.ID_Sender Utente1, F1.ID_Followed Utente2
    FROM FOLLOW F1 JOIN FOLLOW F2 ON F1.ID_Sender=F2.ID_Followed AND F1.ID_Followed=F2.ID_Sender
    ORDER BY Utente1
);
SELECT * FROM Amici_V;

-- connessioni ternarie direttamente collegate
/*
SELECT A1.Utente1 AS Utente1, A1.Utente2 AS Utente2, A2.Utente2 AS AmicoDiAmico
FROM Amici_V A1 JOIN Amici_V A2 ON A1.Utente2=A2.Utente1 AND A2.Utente2 <> A1.Utente1
ORDER BY Utente1;
*/

-- creo la View AmiciDiAmici
CREATE VIEW AmiciDiAmici_V AS (
	SELECT A1.Utente1 AS Utente1, A1.Utente2 AS Utente2, A2.Utente2 AS AmicoDiAmico
	FROM Amici_V A1 LEFT JOIN Amici_V A2 ON A1.Utente2=A2.Utente1 AND A2.Utente2 <> A1.Utente1
	ORDER BY Utente1
);
SELECT * FROM AmiciDiAmici_V;

-- ora mi serve la vista amici in comune - proprità transitiva
/*
SELECT AA.Utente1, AA.Utente2, AA.AmicoDiAmico AS AmicoInComune
FROM AmiciDiAmici_V AA JOIN Amici_V A ON AA.AmicoDiAmico=A.Utente1 AND AA.Utente1=A.Utente2
ORDER BY AA.Utente1;
*/
CREATE VIEW AmiciInComune_V AS (
	SELECT AA.Utente1, AA.Utente2, AA.AmicoDiAmico AS AmicoInComune
	FROM AmiciDiAmici_V AA LEFT JOIN Amici_V A ON AA.AmicoDiAmico=A.Utente1 AND AA.Utente1=A.Utente2
	ORDER BY AA.Utente1
);
SELECT * FROM AmiciInComune_V;

/*
Es. ottengo il numero di amici in comune per ogni utente
SELECT Utente1, Utente2, COUNT(*) AS NumAmiciInComune
FROM AmiciInComune_V
GROUP BY Utente1, Utente2
ORDER BY Utente1;
*/
CREATE VIEW NumAmiciInComune_V AS (
	SELECT Utente1, Utente2, COUNT(AmicoInComune) AS NumAmiciInComune
	FROM AmiciInComune_V
	GROUP BY Utente1, Utente2
	ORDER BY Utente1
);
SELECT * FROM NumAmiciInComune_V;

/*
Es. mi serve il numero di amici in comune tra gli utenti 3 e 10

SELECT COUNT(*) AS NumAmiciInComune
FROM AmiciInComune_V
WHERE Utente1=3 AND Utente2=10
GROUP BY Utente1, Utente2;
*/


/* ***************************************** */
-- CREO GRUPPI IN COMUNE COME AMICI IN COMUNE
/*
SELECT U.ID_Utente, G.ID_Gruppo
FROM UTENTE U JOIN GRUPPO_HAS_UTENTE G ON U.ID_Utente=G.ID_Utente
ORDER BY U.ID_Utente;
*/
CREATE VIEW GuppiPerUtente_V AS (
	SELECT U.ID_Utente, G.ID_Gruppo
	FROM UTENTE U JOIN GRUPPO_HAS_UTENTE G ON U.ID_Utente=G.ID_Utente
	ORDER BY U.ID_Utente
);
SELECT * FROM GuppiPerUtente_V;

CREATE VIEW GruppiInComune_V AS (
	SELECT G1.ID_Utente AS Utente1, G2.ID_Utente AS Utente2, G1.ID_Gruppo
	FROM GuppiPerUtente_V G1 JOIN GuppiPerUtente_V G2 ON G1.ID_Gruppo=G2.ID_Gruppo AND G1.ID_Utente<>G2.ID_Utente
	ORDER BY G1.ID_Utente, G2.ID_Utente
);
SELECT * FROM GruppiInComune_V;
-- Es. mostra tutti i gruppi in comune tra Utenti 13 e 15
SELECT Utente1, Utente2, ID_Gruppo
FROM GruppiInComune_V
WHERE Utente1=13 AND Utente2=15;

/*
SELECT G1.ID_Utente AS Utente1, G2.ID_Utente AS Utente2, COUNT(*) NumGruppiInComune
FROM GuppiPerUtente_V G1 JOIN GuppiPerUtente_V G2 ON G1.ID_Gruppo=G2.ID_Gruppo AND G1.ID_Utente<>G2.ID_Utente
GROUP BY G1.ID_Utente, G2.ID_Utente
ORDER BY G1.ID_Utente;
*/
CREATE VIEW NumGruppiInComune_V AS (
	SELECT G1.ID_Utente AS Utente1, G2.ID_Utente AS Utente2, COUNT(*) NumGruppiInComune
	FROM GuppiPerUtente_V G1 JOIN GuppiPerUtente_V G2 ON G1.ID_Gruppo=G2.ID_Gruppo AND G1.ID_Utente<>G2.ID_Utente
	GROUP BY G1.ID_Utente, G2.ID_Utente
	ORDER BY G1.ID_Utente
);
SELECT * FROM NumGruppiInComune_V;



-- creiamo in fatto che conta il numero di interazioni


/* **************************************** */
-- Mi serve una vista di amici di un utente
-- con n. di amici/gruppi in comune
CREATE VIEW NumAmiciGruppiInComune_V AS (
	SELECT A.Utente1, A.Utente2, A.NumAmiciInComune, G.NumGruppiInComune
	FROM NumAmiciInComune_V A LEFT JOIN NumGruppiInComune_V G ON A.Utente1=G.Utente1 AND A.Utente2=G.Utente2
	ORDER BY Utente1, Utente2
);
SELECT * FROM NumAmiciGruppiInComune_V;




CREATE OR REPLACE VIEW AmiciGruppiInterazioni_V AS
-- Prima parte: coppie da amici/gruppi con join su interazioni
SELECT 
    N.Utente1,
    N.Utente2,
    IFNULL(N.NumAmiciInComune, 0) AS NumAmiciInComune,
    IFNULL(N.NumGruppiInComune, 0) AS NumGruppiInComune,
    IFNULL(I.NumInterazioni, 0) AS NumInterazioni
FROM NumAmiciGruppiInComune_V N
LEFT JOIN (
    SELECT ID_Utente AS Utente1, ID_Autore AS Utente2, COUNT(*) AS NumInterazioni
    FROM Interazioni
    GROUP BY ID_Utente, ID_Autore
) AS I
ON N.Utente1 = I.Utente1 AND N.Utente2 = I.Utente2

UNION
-- Seconda parte: coppie con interazioni ma non in amici/gruppi
SELECT 
    I.Utente1,
    I.Utente2,
    IFNULL(N.NumAmiciInComune, 0),
    IFNULL(N.NumGruppiInComune, 0),
    IFNULL(I.NumInterazioni, 0)
FROM (
    SELECT ID_Utente AS Utente1, ID_Autore AS Utente2, COUNT(*) AS NumInterazioni
    FROM Interazioni
    GROUP BY ID_Utente, ID_Autore
) AS I
LEFT JOIN NumAmiciGruppiInComune_V N
ON I.Utente1 = N.Utente1 AND I.Utente2 = N.Utente2;

SELECT * FROM amicigruppiinterazioni_v;


-- modifica aggiungendo anche le INTERAZIONI *******
-- Conta numero di Interazioni tra Utente1 e Utente2 negli ultimi n giorni
/*
SELECT ID_Utente AS Utente1, ID_Autore AS Utente2, COUNT(*) AS NumInterazioni
FROM Interazioni
WHERE Data_ora_interazione > NOW() - INTERVAL 30 DAY
GROUP BY ID_Utente, ID_Autore
ORDER BY ID_Utente, NumInterazioni;
*/
--


/*
SELECT ID_Utente AS Utente1, ID_Autore AS Utente2, COUNT(*) AS NumInterazioni
FROM Interazioni
WHERE Data_ora_interazione > NOW() - INTERVAL 30 DAY
GROUP BY ID_Utente, ID_Autore
ORDER BY ID_Utente, NumInterazioni;
*/




/* **************************************** */
-- Costruisco la top amici di un Utente
-- Policy: Punteggio = 0.5 * NumAmiciInComune + 0.25 * NumGruppiInComune + 0.25 * NumInterazioni
CREATE OR REPLACE VIEW TopAmici_V AS
SELECT 
    Utente1,
    Utente2,
    NumAmiciInComune,
    NumGruppiInComune,
    NumInterazioni,
    0.5 * NumAmiciInComune + 0.3 * NumGruppiInComune + 0.2 * NumInterazioni AS Punteggio
FROM 
    AmiciGruppiInterazioni_V
ORDER BY 
    Utente1, Punteggio DESC;
    
SELECT * FROM TopAmici_v;



-- Consiglia Amici ad un utente
SELECT T1.Utente1, T2.Utente2, SUM(T1.Punteggio + T2.Punteggio) AS Punteggio
FROM TopAmici_V T1 JOIN TopAmici_V T2 ON T1.Utente2=T2.Utente1 AND T1.Utente1<>T2.Utente2
WHERE T2.Utente2 NOT IN (SELECT A.Utente2 FROM Amici_V A WHERE A.Utente1=T1.Utente1)
GROUP BY T1.Utente1, T2.Utente2
ORDER BY T1.Utente1, Punteggio DESC;



-- Top Utenti --- utile per raccomandazioni ad utenti nuovi
SELECT Utente2 AS ID_Utente, SUM(Punteggio) AS PunteggioTot
FROM TopAmici_V
GROUP BY Utente2
ORDER BY PunteggioTot DESC;


/* **************************************** */
-- CREAZIONE DEL FEED
-- Recupero i post dei miei seguiti
-- Li ordino per data pubblicazione
-- poi ci penso se mettere qualche algoritmo
SELECT F.ID_Sender AS ID_Utente, P.ID_Autore, P.Data_ora
FROM FOLLOW F JOIN POST P ON F.ID_Followed=P.ID_Autore
ORDER BY ID_Utente, Data_ora DESC;



SELECT 
    F.ID_Sender AS ID_Utente,
    P.ID_Autore,
    P.Data_ora
FROM 
    FOLLOW F
JOIN 
    POST P ON F.ID_Followed = P.ID_Autore
JOIN 
    UTENTE U ON U.ID_Utente = F.ID_Sender
LEFT JOIN 
    Interazioni I ON I.ID_Utente = F.ID_Sender 
                  AND I.ID_Autore = P.ID_Autore 
                  AND I.Data_ora = P.Data_ora
                  AND I.Tipo_interazione = 'view'
WHERE 
    I.ID_Utente IS NULL -- non ha visualizzato
    AND (
        P.Sensibile = FALSE -- post non sensibile
        OR (P.Sensibile = TRUE AND U.Contenuti_sensibili = TRUE) -- oppure utente ha abilitato visione
    )
ORDER BY 
    F.ID_Sender, P.Data_ora DESC;


-- SMART FEED
CREATE OR REPLACE VIEW Post_Engagement_V AS
SELECT 
    ID_Autore,
    Data_ora,
    SUM(Tipo_interazione = 'reaction') AS NumReazioni,
    SUM(Tipo_interazione = 'comment') AS NumCommenti
FROM Interazioni
GROUP BY ID_Autore, Data_ora;
SELECT * FROM post_engagement_v;


CREATE OR REPLACE VIEW SmartFeed_V AS
SELECT 
    F.ID_Sender AS ID_Utente,
    P.ID_Autore,
    P.Data_ora,
    P.Contenuto,
    
    UA.Nickname AS NicknameAutore,
    UA.Foto_profilo AS FotoProfiloAutore,

    IFNULL(E.NumReazioni, 0) AS NumReazioni,
    IFNULL(E.NumCommenti, 0) AS NumCommenti,

    T.Punteggio AS PunteggioAmicizia,

    1 / GREATEST(TIMESTAMPDIFF(HOUR, P.Data_ora, NOW()), 1) AS PunteggioRecenza,

    (
        0.35 * IFNULL(T.Punteggio, 0) +
        0.25 * IFNULL(E.NumReazioni, 0) +
        0.25 * IFNULL(E.NumCommenti, 0) +
        0.15 * (1 / GREATEST(TIMESTAMPDIFF(HOUR, P.Data_ora, NOW()), 1))
    ) AS PunteggioFinale

FROM FOLLOW F
JOIN POST P ON F.ID_Followed = P.ID_Autore
JOIN UTENTE U ON U.ID_Utente = F.ID_Sender
JOIN UTENTE UA ON UA.ID_Utente = P.ID_Autore

LEFT JOIN Interazioni I 
    ON I.ID_Utente = F.ID_Sender 
    AND I.ID_Autore = P.ID_Autore 
    AND I.Data_ora = P.Data_ora
    AND I.Tipo_interazione = 'view'

LEFT JOIN Post_Engagement_V E 
    ON P.ID_Autore = E.ID_Autore AND P.Data_ora = E.Data_ora

LEFT JOIN TopAmici_V T 
    ON F.ID_Sender = T.Utente1 AND P.ID_Autore = T.Utente2

WHERE 
    I.ID_Utente IS NULL
    AND (
        P.Sensibile = FALSE 
        OR (P.Sensibile = TRUE AND U.Contenuti_sensibili = TRUE)
    )

ORDER BY 
    F.ID_Sender, PunteggioFinale DESC;


SELECT * FROM SmartFeed_V;


-- Select top trending posts per utente 1
SELECT 
P.ID_Autore,
P.Data_ora,
P.Contenuto,
UA.Nickname AS NicknameAutore,
UA.Foto_profilo AS FotoProfiloAutore,

IFNULL(E.NumReazioni, 0) AS NumReazioni,
IFNULL(E.NumCommenti, 0) AS NumCommenti,

SUM(SF.PunteggioFinale) AS PunteggioTotale

FROM SmartFeed_V SF
JOIN POST P ON SF.ID_Autore = P.ID_Autore AND SF.Data_ora = P.Data_ora
JOIN UTENTE UA ON UA.ID_Utente = P.ID_Autore

LEFT JOIN Post_Engagement_V E 
ON E.ID_Autore = P.ID_Autore AND E.Data_ora = P.Data_ora

WHERE NOT EXISTS (
SELECT 1 FROM Interazioni I
WHERE I.ID_Utente = 1
AND I.ID_Autore = P.ID_Autore 
AND I.Data_ora = P.Data_ora
AND I.Tipo_interazione = 'view'
)
AND P.ID_Autore != 1

GROUP BY P.ID_Autore, P.Data_ora
ORDER BY PunteggioTotale DESC
LIMIT 10

