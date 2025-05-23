CREATE TABLE NOTIFICA (
    ID_Notifica INT AUTO_INCREMENT PRIMARY KEY,
    ID_Destinatario INT NOT NULL,
    Tipo VARCHAR(50) NOT NULL, -- 'follow', 'commento', 'reazione', 'messaggio'
    Messaggio TEXT NOT NULL,
    Letta BOOLEAN DEFAULT FALSE,
    Data_ora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ID_Autore_post INT,
    Data_ora_post TIMESTAMP,
    FOREIGN KEY (ID_Destinatario) REFERENCES UTENTE(ID_Utente)
);