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
-- Table structure for table `MESSAGGIO_INDIVIDUALE`
--

DROP TABLE IF EXISTS `MESSAGGIO_INDIVIDUALE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MESSAGGIO_INDIVIDUALE` (
  `ID_Sender` int NOT NULL,
  `ID_Ricevente` int NOT NULL,
  `Data_ora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Contenuto` text NOT NULL,
  PRIMARY KEY (`ID_Sender`,`ID_Ricevente`,`Data_ora`),
  KEY `ID_Ricevente` (`ID_Ricevente`),
  CONSTRAINT `messaggio_individuale_ibfk_1` FOREIGN KEY (`ID_Sender`) REFERENCES `UTENTE` (`ID_Utente`) ON DELETE CASCADE,
  CONSTRAINT `messaggio_individuale_ibfk_2` FOREIGN KEY (`ID_Ricevente`) REFERENCES `UTENTE` (`ID_Utente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MESSAGGIO_INDIVIDUALE`
--

LOCK TABLES `MESSAGGIO_INDIVIDUALE` WRITE;
/*!40000 ALTER TABLE `MESSAGGIO_INDIVIDUALE` DISABLE KEYS */;
INSERT INTO `MESSAGGIO_INDIVIDUALE` VALUES (1,2,'2023-03-01 09:15:00','Ciao Bob, hai visto l ultimo aggiornamento di Python?'),(2,1,'2023-03-01 09:30:00','Sì Alice, alcune feature interessanti! Dovremmo provarle.'),(3,4,'2023-03-02 10:45:00','Diana, ti va di uscire a fare foto questo weekend?'),(4,3,'2023-03-02 11:20:00','Volentieri Carlo! Ho trovato un posto perfetto.'),(5,6,'2023-03-03 12:30:00','Frank, hai quel libro che mi avevi consigliato?'),(6,5,'2023-03-03 13:15:00','Sì Eva, te lo porto domani all incontro.'),(7,8,'2023-03-04 14:40:00','Harry, hai esperienza con React Native?'),(8,7,'2023-03-04 15:25:00','Sì Gina, posso aiutarti con quel progetto.'),(9,10,'2023-03-05 16:50:00','Jack, quando ci vediamo per l allenamento?'),(10,9,'2023-03-05 17:35:00','Domani alle 7 al solito posto Iris!'),(11,12,'2023-03-06 18:20:00','Leo, hai prenotato i biglietti per il concerto?'),(12,11,'2023-03-06 19:05:00','Sì Kate, li ho presi oggi pomeriggio!'),(13,14,'2023-03-07 20:30:00','Nick, mi passi gli appunti di ieri?'),(14,13,'2023-03-07 21:15:00','Eccoli Mia, ti mando il file stasera.'),(15,16,'2023-03-08 07:40:00','Olivia, hai visto l ultimo articolo sul calciomercato?'),(16,15,'2023-03-08 08:25:00','Sì Paul, discutiamone a pranzo!'),(17,18,'2023-03-09 09:50:00','Quinn, hai tempo per rivedere il mio articolo?'),(18,17,'2023-03-09 10:35:00','Certo Rachel, mandamelo pure.'),(19,20,'2023-03-10 11:20:00','Sam, hai finito di preparare la lezione?'),(20,19,'2023-03-10 12:05:00','Quasi Tina, mancano solo gli esercizi.'),(21,22,'2023-03-11 13:30:00','Ugo, ci sei stasera alla cena?'),(22,21,'2023-03-11 14:15:00','Sì Vicky, arrivo direttamente dal lavoro.'),(23,24,'2023-03-12 15:40:00','Will, hai quel contatto dell editore?'),(24,23,'2023-03-12 16:25:00','Te lo mando ora Xena, controlla le email.'),(25,26,'2023-03-13 17:50:00','Yuri, giochiamo stasera online?'),(26,25,'2023-03-13 18:35:00','Certo Zoe, alle 21 va bene?'),(27,28,'2023-03-14 19:20:00','Adam, hai visto la nuova serie su Netflix?'),(28,27,'2023-03-14 20:05:00','Sì Bella, è fantastica! La finiremo stasera?'),(29,30,'2023-03-15 07:30:00','Carl, mi aiuti a sistemare il codice?'),(30,29,'2023-03-15 08:15:00','Certo Daisy, passi dopo le 11?'),(31,32,'2023-03-16 09:40:00','Eddie, prova il nuovo ristorante giapponese?'),(32,31,'2023-03-16 10:25:00','Sì Fiona, sushi eccezionale! Ci andiamo insieme?'),(33,34,'2023-03-17 11:50:00','George, hai finito il montaggio del video?'),(34,33,'2023-03-17 12:35:00','Quasi Hannah, manca solo la colonna sonora.'),(35,36,'2023-03-18 13:20:00','Ivan, mi consigli un antivirus?'),(36,35,'2023-03-18 14:05:00','Bitdefender è ottimo Jill, te lo installo io.'),(37,38,'2023-03-19 15:30:00','Kevin, hai notizie sulla conferenza?'),(38,37,'2023-03-19 16:15:00','Sì Lily, è stata posticipata a maggio.'),(39,40,'2023-03-20 17:40:00','Mike, controlli il mio piano di investimenti?'),(40,39,'2023-03-20 18:25:00','Certo Nina, passami i dettagli.'),(41,42,'2023-03-21 19:10:00','Oscar, hai prenotato l albergo per il viaggio?'),(42,41,'2023-03-21 19:55:00','Sì Paula, tutto confermato!'),(43,44,'2023-03-22 20:30:00','Quentin, quando ci mostri le nuove foto?'),(44,43,'2023-03-22 21:15:00','Domani Rose, sto finendo la selezione.'),(45,46,'2023-03-23 07:40:00','Steve, hai il contatto del tecnico del suono?'),(46,45,'2023-03-23 08:25:00','Te lo mando ora Tara, è molto bravo.'),(47,48,'2023-03-24 09:50:00','Ulysses, ci sei alla riunione di domani?'),(48,47,'2023-03-24 10:35:00','Sì Violet, arrivo direttamente dall aeroporto.'),(49,50,'2023-03-25 11:20:00','Walter, hai visto il mio ultimo articolo?'),(50,49,'2023-03-25 12:05:00','Bellissimo Xander, complimenti per lo stile!'),(51,52,'2025-05-07 09:15:23','ueue'),(51,52,'2025-05-13 20:47:04','eccomi'),(51,53,'2025-04-27 11:29:34','noo bicii eccomi arrivo cusa'),(51,53,'2025-05-06 22:58:22','assurdo'),(51,53,'2025-05-06 23:00:43','stupendo'),(52,51,'2025-04-27 10:22:51','ciaoo'),(52,51,'2025-04-27 10:27:11','uee'),(52,51,'2025-04-27 10:28:31','prova'),(52,51,'2025-04-27 10:46:50','ciaoo'),(52,51,'2025-04-27 10:51:11','ueee'),(52,51,'2025-04-27 10:53:00','ueeeeeee'),(52,51,'2025-04-28 20:41:16','ueueeee'),(52,51,'2025-05-07 09:14:41','salvo prova'),(52,53,'2025-04-27 10:35:42','ciaooo'),(52,53,'2025-04-27 10:49:24','ueue'),(53,51,'2025-04-27 11:28:33','ciao biciiii'),(53,51,'2025-04-27 11:28:50','pk nn mi rispondi'),(53,51,'2025-04-28 20:31:31','ciao biii fatto l\'unghiaa'),(53,51,'2025-04-28 20:37:12','cia bii fatto l\'ughietta stellina'),(53,51,'2025-05-07 23:00:29','bello'),(53,52,'2025-05-07 09:15:56','prova'),(53,52,'2025-05-07 23:00:44','lol'),(53,56,'2025-05-08 08:09:47','cia b'),(56,53,'2025-05-08 08:09:29','pappa'),(57,51,'2025-05-22 06:59:46','piacere'),(57,52,'2025-05-22 06:59:30','ciaooo');
/*!40000 ALTER TABLE `MESSAGGIO_INDIVIDUALE` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-22  9:31:29
