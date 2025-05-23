-- ==========================================
-- SEZIONE 1: RELAZIONI DI AMICIZIA E GRUPPI
-- ==========================================

-- 1.1. Vista degli amici reciproci
CREATE VIEW Amici_V AS
SELECT F1.ID_Sender AS Utente1, F1.ID_Followed AS Utente2
FROM FOLLOW F1
JOIN FOLLOW F2 ON F1.ID_Sender = F2.ID_Followed AND F1.ID_Followed = F2.ID_Sender
ORDER BY Utente1;

-- 1.2. Amici di amici
-- ********* QUESTA NON SERVE DA SOLA

CREATE VIEW AmiciDiAmici_V AS
SELECT A1.Utente1, A1.Utente2, A2.Utente2 AS AmicoDiAmico
FROM Amici_V A1
LEFT JOIN Amici_V A2 ON A1.Utente2 = A2.Utente1 AND A2.Utente2 <> A1.Utente1
ORDER BY A1.Utente1;

-- 1.3. Amici in comune
CREATE VIEW AmiciInComune_V AS
SELECT AA.Utente1, AA.Utente2, AA.AmicoDiAmico AS AmicoInComune
FROM AmiciDiAmici_V AA
LEFT JOIN Amici_V A ON AA.AmicoDiAmico = A.Utente1 AND AA.Utente1 = A.Utente2
ORDER BY AA.Utente1;

-- 1.4. Numero amici in comune
CREATE VIEW NumAmiciInComune_V AS
SELECT Utente1, Utente2, COUNT(AmicoInComune) AS NumAmiciInComune
FROM AmiciInComune_V
GROUP BY Utente1, Utente2
ORDER BY Utente1;

-- 1.5. Gruppi per utente
-- ********* QUESTA NON SERVE DA SOLA
CREATE VIEW GruppiPerUtente_V AS
SELECT G.ID_Utente, G.ID_Gruppo
FROM UTENTE U
JOIN GRUPPO_HAS_UTENTE G ON U.ID_Utente = G.ID_Utente
ORDER BY G.ID_Utente;

-- 1.6. Gruppi in comune tra utenti
CREATE VIEW GruppiInComune_V AS
SELECT G1.ID_Utente AS Utente1, G2.ID_Utente AS Utente2, G1.ID_Gruppo
FROM GruppiPerUtente_V G1
JOIN GruppiPerUtente_V G2 ON G1.ID_Gruppo = G2.ID_Gruppo AND G1.ID_Utente <> G2.ID_Utente
ORDER BY G1.ID_Utente, G2.ID_Utente;

-- 1.7. Numero gruppi in comune
CREATE VIEW NumGruppiInComune_V AS
SELECT G1.ID_Utente AS Utente1, G2.ID_Utente AS Utente2, COUNT(*) AS NumGruppiInComune
FROM GruppiPerUtente_V G1
JOIN GruppiPerUtente_V G2 ON G1.ID_Gruppo = G2.ID_Gruppo AND G1.ID_Utente <> G2.ID_Utente
GROUP BY G1.ID_Utente, G2.ID_Utente
ORDER BY G1.ID_Utente;

-- 1.8. Amici + gruppi in comune
-- ********* QUESTA NON SERVE DA SOLA MA SERVE PER SEMPLIFICARE LA QUERY FINALE DEL FEED
CREATE VIEW NumAmiciGruppiInComune_V AS
SELECT A.Utente1, A.Utente2, A.NumAmiciInComune, G.NumGruppiInComune
FROM NumAmiciInComune_V A
LEFT JOIN NumGruppiInComune_V G ON A.Utente1 = G.Utente1 AND A.Utente2 = G.Utente2
ORDER BY Utente1, Utente2;



-- ========================
-- SEZIONE 2: INTERAZIONI
-- ========================

-- 2.1. Vista combinata: amici, gruppi e interazioni
-- ********* QUESTA NON SERVE DA SOLA MA SERVE PER SEMPLIFICARE LA QUERY FINALE DEL FEED
CREATE OR REPLACE VIEW AmiciGruppiInterazioni_V AS
-- Prima parte: unione amici/gruppi + interazioni
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
    WHERE Interazioni.Tipo_interazione <> 'view'
    GROUP BY ID_Utente, ID_Autore
) AS I ON N.Utente1 = I.Utente1 AND N.Utente2 = I.Utente2

UNION

-- Seconda parte: coppie che hanno solo interazioni
SELECT 
    I.Utente1,
    I.Utente2,
    IFNULL(N.NumAmiciInComune, 0),
    IFNULL(N.NumGruppiInComune, 0),
    I.NumInterazioni
FROM (
    SELECT ID_Utente AS Utente1, ID_Autore AS Utente2, COUNT(*) AS NumInterazioni
    FROM Interazioni
    WHERE Interazioni.Tipo_interazione <> 'view'
    GROUP BY ID_Utente, ID_Autore
) AS I
LEFT JOIN NumAmiciGruppiInComune_V N
ON I.Utente1 = N.Utente1 AND I.Utente2 = N.Utente2;


-- ======================================
-- SEZIONE 3: PUNTEGGIO E RACCOMANDAZIONI
-- ======================================

-- 3.1. Top amici con punteggio calcolato
-- ********* QUESTA NON SERVE DA SOLA
CREATE OR REPLACE VIEW TopAmici_V AS
SELECT 
    Utente1,
    Utente2,
    NumAmiciInComune,
    NumGruppiInComune,
    NumInterazioni,
    0.5 * NumAmiciInComune + 0.3 * NumGruppiInComune + 0.2 * NumInterazioni AS Punteggio
FROM AmiciGruppiInterazioni_V
ORDER BY Utente1, Punteggio DESC;

-- 3.2. Suggerimenti amici (collaborative filtering)
SELECT T1.Utente1, T2.Utente2, SUM(T1.Punteggio + T2.Punteggio) AS Punteggio
FROM TopAmici_V T1
JOIN TopAmici_V T2 ON T1.Utente2 = T2.Utente1 AND T1.Utente1 <> T2.Utente2
WHERE T2.Utente2 NOT IN (
    SELECT A.Utente2 FROM Amici_V A WHERE A.Utente1 = T1.Utente1
)
GROUP BY T1.Utente1, T2.Utente2
ORDER BY T1.Utente1, Punteggio DESC;

-- 3.3. Top utenti globali in base al punteggio ricevuto
SELECT Utente2 AS ID_Utente, SUM(Punteggio) AS PunteggioTot
FROM TopAmici_V
GROUP BY Utente2
ORDER BY PunteggioTot DESC;



-- ========================
-- SEZIONE 4: FEED E SMART FEED
-- ========================

-- 4.1. Feed cronologico semplice (post dai seguiti)
SELECT 
    F.ID_Sender AS ID_Utente,
    P.ID_Autore,
    P.Data_ora
FROM FOLLOW F
JOIN POST P ON F.ID_Followed = P.ID_Autore
ORDER BY ID_Utente, P.Data_ora DESC;

-- 4.2. Feed filtrato: solo post non visualizzati, con gestione contenuti sensibili
SELECT 
    F.ID_Sender AS ID_Utente,
    P.ID_Autore,
    P.Data_ora
FROM FOLLOW F
JOIN POST P ON F.ID_Followed = P.ID_Autore
JOIN UTENTE U ON U.ID_Utente = F.ID_Sender
LEFT JOIN Interazioni I ON I.ID_Utente = F.ID_Sender 
                       AND I.ID_Autore = P.ID_Autore 
                       AND I.Data_ora = P.Data_ora
                       AND I.Tipo_interazione = 'view'
WHERE 
    I.ID_Utente IS NULL AND 
    (P.Sensibile = FALSE OR (P.Sensibile = TRUE AND U.Contenuti_sensibili = TRUE))
ORDER BY F.ID_Sender, P.Data_ora DESC;

-- 4.3. Vista con numero di reazioni e commenti per ogni post
-- ********* QUESTA NON SERVE DA SOLA
CREATE OR REPLACE VIEW Post_Engagement_V AS
SELECT 
    ID_Autore,
    Data_ora,
    SUM(Tipo_interazione = 'reaction') AS NumReazioni,
    SUM(Tipo_interazione = 'comment') AS NumCommenti
FROM Interazioni
GROUP BY ID_Autore, Data_ora;

-- 4.4. SmartFeed con calcolo del punteggio finale per ranking dei post
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
    
    CASE 
        WHEN TIMESTAMPDIFF(DAY, F.Data_ora, NOW()) <= 7 THEN 1.5
        WHEN TIMESTAMPDIFF(DAY, F.Data_ora, NOW()) <= 30 THEN 1.2
        ELSE 1
    END AS BoostFollower,

    (
        (0.36 * IFNULL(T.Punteggio, 0) +
        0.12 * IFNULL(E.NumReazioni, 0) +
        0.12 * IFNULL(E.NumCommenti, 0) +
        0.40 * (1 / GREATEST(TIMESTAMPDIFF(HOUR, P.Data_ora, NOW()), 1)))
        *
        CASE 
            WHEN TIMESTAMPDIFF(DAY, F.Data_ora, NOW()) <= 7 THEN 1.5
            WHEN TIMESTAMPDIFF(DAY, F.Data_ora, NOW()) <= 30 THEN 1.2
            ELSE 1
        END
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
	P.ID_Autore_fonte IS NULL
    AND I.ID_Utente IS NULL 
    AND (P.Sensibile = FALSE OR (P.Sensibile = TRUE AND U.Contenuti_sensibili = TRUE))
ORDER BY 
    F.ID_Sender, PunteggioFinale DESC;


-- 4.5. TOP n POST (trending post)|| Utile per utenti nuovi
SELECT
	P.ID_Autore,
	P.Data_ora,
	U.Nickname                       AS NicknameAutore,
	P.Contenuto,
	MAX(V.NumCommenti)               AS NumCommenti,
	MAX(V.PunteggioFinale)           AS PunteggioFinale
FROM SmartFeed_V V
JOIN POST   P ON P.ID_Autore = V.ID_Autore
			AND P.Data_ora  = V.Data_ora
JOIN UTENTE U ON U.ID_Utente = P.ID_Autore
WHERE P.ID_Autore_fonte IS NULL          -- esclude commenti
GROUP BY
	P.ID_Autore,
	P.Data_ora,
	U.Nickname,
	P.Contenuto
ORDER BY PunteggioFinale DESC
LIMIT 20;

