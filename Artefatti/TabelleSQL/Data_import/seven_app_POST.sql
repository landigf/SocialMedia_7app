CREATE DATABASE  IF NOT EXISTS `seven_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `seven_app`;
-- MySQL dump 10.13  Distrib 8.0.41, for macos15 (arm64)
--
-- Host: localhost    Database: seven_app
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `POST`
--

DROP TABLE IF EXISTS `POST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POST` (
  `ID_Autore` int NOT NULL,
  `Data_ora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID_Autore_fonte` int DEFAULT NULL,
  `Data_ora_fonte` timestamp NULL DEFAULT NULL,
  `Contenuto` text NOT NULL,
  `Sensibile` tinyint(1) DEFAULT '0',
  `Modificato` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID_Autore`,`Data_ora`),
  KEY `ID_Autore_fonte` (`ID_Autore_fonte`,`Data_ora_fonte`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`ID_Autore`) REFERENCES `UTENTE` (`ID_Utente`) ON DELETE CASCADE,
  CONSTRAINT `post_ibfk_2` FOREIGN KEY (`ID_Autore_fonte`, `Data_ora_fonte`) REFERENCES `POST` (`ID_Autore`, `Data_ora`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POST`
--

LOCK TABLES `POST` WRITE;
/*!40000 ALTER TABLE `POST` DISABLE KEYS */;
INSERT INTO `POST` VALUES (1,'2023-03-01 07:15:00',NULL,NULL,'Buongiorno mondo! Oggi è una giornata perfetta per scattare foto. #fotografia #mattina',0,0),(1,'2025-04-12 12:49:47',4,'2023-03-02 11:00:00','Buona fortuna ;)',0,0),(2,'2023-03-01 08:30:00',NULL,NULL,'Ho appena finito di scrivere un nuovo algoritmo. Funziona perfettamente al primo tentativo! #programmazione #successo',0,0),(3,'2023-03-02 09:45:00',NULL,NULL,'Condivido questa mia nuova composizione musicale. Link nei commenti! #musica #compositore',0,0),(4,'2023-03-02 11:00:00',NULL,NULL,'Oggi primo giorno di tirocinio in ospedale. Emozionatissima! #medicina #futuromedico',0,0),(5,'2023-03-03 12:15:00',NULL,NULL,'Nuova illustrazione digitale appena completata. Cosa ne pensate? #arte #digitale',0,1),(6,'2023-03-03 13:30:00',NULL,NULL,'Sto lavorando a un nuovo romanzo. L ispirazione è arrivata! #scrittura #libri',0,0),(7,'2023-03-04 14:45:00',NULL,NULL,'Ricetta del giorno: risotto allo zafferano con seppie. Foto nei commenti! #cucina #foodblogger',0,0),(8,'2023-03-04 16:00:00',NULL,NULL,'Problemi con React Native. Qualcuno può aiutarmi? #programmazione #mobile',0,0),(9,'2023-03-05 17:15:00',NULL,NULL,'Scattata questa foto al tramonto. La luce era perfetta! #fotografia #paesaggio',0,0),(10,'2023-03-05 18:30:00',NULL,NULL,'Allenamento completato: 10km in 45 minuti! Nuovo record personale. #fitness #running',0,0),(11,'2023-03-06 19:45:00',NULL,NULL,'Prenotato il biglietto per il concerto dei Coldplay! Non vedo l ora. #musica #live',0,0),(12,'2023-03-06 21:00:00',NULL,NULL,'Ho appena aggiornato il mio PC gaming. Finalmente posso giocare in 4K! #gaming #tecnologia',0,0),(13,'2023-03-07 07:15:00',NULL,NULL,'Esame superato con 30 e lode! Tutto lo studio è valso la pena. #università #successo',0,0),(14,'2023-03-07 08:30:00',NULL,NULL,'Nuovo progetto di sviluppo web iniziato oggi. Idee innovative in arrivo! #webdesign #programmazione',0,0),(15,'2023-03-08 09:45:00',NULL,NULL,'Intervista esclusiva con un calciatore famoso in arrivo sul mio blog! #giornalismo #sport',0,0),(16,'2023-03-08 11:00:00',NULL,NULL,'Letto \"Il potere dell abitudine\". Consigliatissimo per chi vuole cambiare vita! #libri #crescita',0,0),(17,'2023-03-09 12:15:00',NULL,NULL,'Il mio nuovo articolo sull attivismo ambientale è online! Link in bio. #scrittura #ambiente',0,0),(18,'2023-03-09 13:30:00',NULL,NULL,'Oggi lezione di chitarra con i miei studenti più talentuosi. Adoro insegnare! #musica #insegnamento',0,0),(19,'2023-03-10 14:45:00',NULL,NULL,'Nuova collezione di abiti in arrivo sul mio negozio online! #moda #design',0,0),(20,'2023-03-10 16:00:00',NULL,NULL,'Problemi con il mio impianto idraulico. Consigli per un buon idraulico? #faiDate #casa',0,0),(21,'2023-03-11 17:15:00',NULL,NULL,'Aperto il mio nuovo ristorante! Venite a provare la nostra cucina. #food #imprenditore',0,0),(22,'2023-03-11 18:30:00',NULL,NULL,'Nuovo video sul mio canale YouTube: \"Come creare un portfolio digitale\". #contentcreator #youtube',0,0),(23,'2023-03-12 19:45:00',NULL,NULL,'Investimento riuscito nel settore tech. Il futuro è digitale! #finanza #tecnologia',0,0),(24,'2023-03-12 21:00:00',NULL,NULL,'Trovato questo gattino abbandonato. Ora fa parte della famiglia! #animali #adozione',1,0),(25,'2023-03-13 07:15:00',NULL,NULL,'Live streaming stasera alle 21:00 su Twitch. Giochiamo a Elden Ring! #gaming #streamer',0,0),(26,'2023-03-13 08:30:00',NULL,NULL,'La mia nuova mostra fotografica apre domani! Tutti invitati. #fotografia #arte',0,0),(27,'2023-03-14 09:45:00',NULL,NULL,'Pubblicato il mio primo romanzo fantasy! Link per l acquisto in bio. #scrittore #libri',0,0),(28,'2023-03-14 11:00:00',NULL,NULL,'Sfilata di moda ieri sera. Ero la modella di apertura! #moda #model',1,0),(29,'2023-03-15 12:15:00',NULL,NULL,'Progetto di ingegneria completato con successo. Team fantastico! #ingegneria #lavoro',0,0),(30,'2023-03-15 13:30:00',NULL,NULL,'Le ultime novità in arrivo nel mondo dell IA. Articolo completo sul mio blog. #tecnologia #AI',0,0),(31,'2023-03-16 14:45:00',NULL,NULL,'Concerto di beneficenza stasera. Tutti i fondi andranno alla ricerca sul cancro. #musica #beneficenza',0,0),(32,'2023-03-16 16:00:00',NULL,NULL,'Ricetta vegan del giorno: burger di lenticchie. Provatela! #vegan #cucina',0,0),(33,'2023-03-17 17:15:00',NULL,NULL,'Nuovo cortometraggio che ho diretto ora online! Link nei commenti. #cinema #regista',0,0),(34,'2023-03-17 18:30:00',NULL,NULL,'Lezione di yoga gratuita domani al parco. Portate il vostro tappetino! #yoga #benessere',0,0),(35,'2023-03-18 19:45:00',NULL,NULL,'Violento scontro tra tifosi allo stadio oggi. Ecco il mio reportage. #giornalismo #calcio',1,0),(36,'2023-03-18 21:00:00',NULL,NULL,'Mixology class domani sera. Impareremo a fare cocktail perfetti! #cocktail #mixology',0,0),(37,'2023-03-19 07:15:00',NULL,NULL,'Il mio nuovo progetto architettonico ha vinto un premio! #architettura #design',0,0),(38,'2023-03-19 08:30:00',NULL,NULL,'Adottato questo cucciolo oggi. Come dovrei chiamarlo? #animali #cane',0,0),(39,'2023-03-20 09:45:00',NULL,NULL,'Eclissi lunare ieri sera. Ecco le mie foto migliori! #astronomia #fotografia',0,0),(40,'2023-03-20 11:00:00',NULL,NULL,'Maratona cittadina completata in 3 ore e 45 minuti! #running #sport',0,0),(41,'2023-03-21 12:15:00',NULL,NULL,'Tutorial di acquerello per principianti ora sul mio canale. #arte #tutorial',0,0),(42,'2023-03-21 13:30:00',NULL,NULL,'Intervista con un sopravvissuto alla guerra. Storia toccante. #giornalismo #reportage',1,0),(43,'2023-03-22 14:45:00',NULL,NULL,'Mostra di street art nel quartiere. Alcune opere sono incredibili! #arte #streetart',0,0),(44,'2023-03-22 16:00:00',NULL,NULL,'Escursione in montagna oggi. Vista mozzafiato! #natura #escursionismo',0,0),(45,'2023-03-23 17:15:00',NULL,NULL,'Nuovo episodio del mio podcast online. Parliamo di finanza personale. #podcast #finanza',0,0),(46,'2023-03-23 18:30:00',NULL,NULL,'Workshop di ceramica domani. Posti ancora disponibili! #arte #ceramica',0,0),(47,'2023-03-24 19:45:00',NULL,NULL,'Foto notturne della città. La luce artificiale crea effetti incredibili. #fotografia #notte',0,0),(48,'2023-03-24 21:00:00',NULL,NULL,'Ricetta della nonna: torta di mele perfetta. Condivido i segreti! #cucina #dolci',0,0),(49,'2023-03-25 07:15:00',NULL,NULL,'Torneo di scacchi al circolo oggi. Sono arrivato secondo! #scacchi #giochi',0,0),(50,'2023-03-25 08:30:00',NULL,NULL,'Immersione subacquea oggi. Il mondo sottomarino è magico! #subacqueo #natura',0,0),(51,'2025-04-16 17:47:55',31,'2023-03-16 14:45:00','Ciaoooo',0,0),(51,'2025-04-16 17:50:58',32,'2023-03-16 16:00:00','Complimenti!',0,0),(51,'2025-04-16 17:54:13',50,'2023-03-25 08:30:00','Che figata !',0,0),(51,'2025-04-28 20:22:30',53,'2025-04-22 19:15:38','ciaoo',0,0),(51,'2025-05-06 20:14:04',53,'2025-04-28 20:27:44','ciaoo bi',0,0),(51,'2025-05-06 20:14:14',52,'2025-04-22 13:17:58','prova',0,0),(51,'2025-05-06 20:14:19',52,'2025-04-22 13:17:58','ciaoo',0,0),(51,'2025-05-06 20:24:47',53,'2025-05-06 20:24:16','prova sono gennaro',0,0),(51,'2025-05-06 22:48:17',53,'2025-05-06 20:24:16','ciaoo bi',0,0),(51,'2025-05-07 09:14:58',52,'2025-05-07 09:14:32','buong salvo',0,0),(51,'2025-05-13 09:15:08',NULL,NULL,'wfwfwefwef',0,0),(51,'2025-05-13 20:46:40',53,'2025-05-08 08:10:02','ciaoo',0,0),(51,'2025-05-22 07:16:22',NULL,NULL,'MongoDB > MySQL ? ?',0,0),(51,'2025-05-22 07:19:17',52,'2025-05-22 07:17:54','+2 voti all\'orale hahhhah',0,0),(52,'2025-04-22 13:17:58',51,'2025-04-16 17:47:55','furetto',0,0),(52,'2025-05-07 09:14:08',53,'2025-05-06 22:47:12','cio ellii sono salvo',0,0),(52,'2025-05-07 09:14:32',NULL,NULL,'sono salvo',0,0),(52,'2025-05-22 07:17:54',NULL,NULL,'Prof, sa dirci per caso quando riapre il bar??',0,0),(53,'2025-04-22 19:15:38',41,'2023-03-21 12:15:00','ciao bi',0,0),(53,'2025-04-28 20:27:44',51,'2025-04-16 17:54:13','ciaoo bi',0,0),(53,'2025-05-06 20:24:16',NULL,NULL,'prova sono elli',0,0),(53,'2025-05-06 21:54:37',10,'2023-03-05 18:30:00','bravo jack',0,0),(53,'2025-05-06 22:47:12',NULL,NULL,'assurddo',0,0),(53,'2025-05-06 22:47:24',53,'2025-05-06 22:47:12','io a me stessa',0,0),(53,'2025-05-07 09:15:39',52,'2025-05-07 09:14:32','ciao ragazzi',0,0),(53,'2025-05-07 09:16:14',NULL,NULL,'oleee',0,0),(53,'2025-05-07 20:54:10',54,'2025-05-07 20:47:29','ciao sei grande',0,0),(53,'2025-05-07 22:47:55',NULL,NULL,'buona sera',0,0),(53,'2025-05-08 08:10:02',NULL,NULL,'briciola ic sei ??\r\n☕️',0,0),(54,'2025-05-07 09:37:02',53,'2025-05-06 20:24:16','ciao elli',0,0),(54,'2025-05-07 20:47:29',NULL,NULL,'ciaoo sono nuovo',0,0),(54,'2025-05-07 22:53:07',53,'2025-05-07 22:47:55','seraa',0,0),(55,'2025-05-07 22:33:13',54,'2025-05-07 20:47:29','test',0,0),(56,'2025-05-08 08:08:48',53,'2025-05-06 20:24:16','mao',0,0),(56,'2025-05-08 08:09:22',53,'2025-05-07 22:47:55','a te du bu',0,0),(57,'2025-05-22 07:07:27',1,'2023-03-01 07:15:00','ciaooo',0,0);
/*!40000 ALTER TABLE `POST` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_insert_comment_interaction` AFTER INSERT ON `post` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-22  9:31:29
