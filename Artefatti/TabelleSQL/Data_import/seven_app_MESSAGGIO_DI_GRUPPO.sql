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
-- Table structure for table `MESSAGGIO_DI_GRUPPO`
--

DROP TABLE IF EXISTS `MESSAGGIO_DI_GRUPPO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MESSAGGIO_DI_GRUPPO` (
  `ID_Sender` int NOT NULL,
  `ID_Gruppo` int NOT NULL,
  `Data_ora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Contenuto` text NOT NULL,
  PRIMARY KEY (`ID_Sender`,`ID_Gruppo`,`Data_ora`),
  KEY `ID_Gruppo` (`ID_Gruppo`),
  CONSTRAINT `messaggio_di_gruppo_ibfk_1` FOREIGN KEY (`ID_Sender`) REFERENCES `UTENTE` (`ID_Utente`) ON DELETE CASCADE,
  CONSTRAINT `messaggio_di_gruppo_ibfk_2` FOREIGN KEY (`ID_Gruppo`) REFERENCES `GRUPPO` (`ID_Gruppo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MESSAGGIO_DI_GRUPPO`
--

LOCK TABLES `MESSAGGIO_DI_GRUPPO` WRITE;
/*!40000 ALTER TABLE `MESSAGGIO_DI_GRUPPO` DISABLE KEYS */;
INSERT INTO `MESSAGGIO_DI_GRUPPO` VALUES (1,1,'2023-03-10 09:15:00','Ciao a tutti! Sono nuovo nel gruppo e volevo presentarmi. Mi chiamo Alice e amo la fotografia paesaggistica.'),(2,1,'2023-03-10 09:30:00','Benvenuta Alice! Condividi con noi qualche tuo scatto quando vuoi.'),(3,1,'2023-03-10 10:45:00','Qualcuno ha esperienza con la fotografia notturna? Vorrei qualche consiglio.'),(4,2,'2023-03-11 08:20:00','Qual è il vostro linguaggio di programmazione preferito? Io adoro Python.'),(5,2,'2023-03-11 09:10:00','Python è ottimo! Io però preferisco JavaScript per lo sviluppo web.'),(6,3,'2023-03-12 13:30:00','Ragazzi, consigli per un viaggio low-cost in Europa?'),(7,3,'2023-03-12 14:45:00','Ti consiglio la Romania! Bellissima e economica.'),(8,4,'2023-03-13 17:20:00','Avete ricette veloci per cena? Ho ospiti all ultimo minuto!'),(9,4,'2023-03-13 18:05:00','Pasta al pesto con pomodorini è sempre un successo!'),(10,5,'2023-03-14 19:15:00','Conoscete band indie italiane emergenti?'),(11,5,'2023-03-14 20:30:00','Ti consiglio di ascoltare \"I Cani\", sono fantastici!'),(12,6,'2023-03-15 21:10:00','Qual è il miglior film di Kubrick secondo voi?'),(13,6,'2023-03-15 22:05:00','2001: Odissea nello spazio, senza dubbio!'),(14,7,'2023-03-16 06:30:00','Buongiorno! Qualcuno vuole condividere la sua routine mattutina?'),(15,7,'2023-03-16 07:45:00','Io faccio 20 minuti di yoga e poi una colazione proteica.'),(16,8,'2023-03-17 11:20:00','Sto cercando un libro avvincente, consigli?'),(17,8,'2023-03-17 12:15:00','\"Il nome della rosa\" di Eco è un capolavoro!'),(18,9,'2023-03-18 14:40:00','Quale tablet consigliate per il digital art?'),(19,9,'2023-03-18 15:50:00','iPad Pro con Apple Pencil è il top!'),(20,10,'2023-03-19 16:30:00','Come posso coltivare erbe aromatiche sul balcone?'),(21,10,'2023-03-19 17:20:00','Inizia con basilico e prezzemolo, sono facili!'),(22,11,'2023-03-20 18:10:00','Qualcuno ha esperienza con crowdfunding per startup?'),(23,11,'2023-03-20 19:25:00','Io ho usato Kickstarter con successo, chiedimi pure!'),(24,12,'2023-03-21 05:15:00','Meditate prima o dopo lo yoga?'),(25,12,'2023-03-21 06:30:00','Io preferisco dopo, quando sono già rilassato.'),(26,13,'2023-03-22 08:45:00','Condivido questa foto dalla Thailandia! Che ne pensate?'),(27,13,'2023-03-22 09:50:00','Fantastica composizione! I colori sono incredibili.'),(28,14,'2023-03-23 10:20:00','Come superate il blocco dello scrittore?'),(29,14,'2023-03-23 11:35:00','Fai una passeggiata e torna con mente fresca.'),(30,15,'2023-03-24 12:40:00','Quale tecnologia pensate rivoluzionerà il futuro?'),(31,15,'2023-03-24 13:55:00','L IA generativa sta già cambiando tutto!'),(32,16,'2023-03-25 14:30:00','Dove trovare vestiti sostenibili a prezzi accessibili?'),(33,16,'2023-03-25 15:45:00','Prova i mercatini dell usato, ottimi affari!'),(34,17,'2023-03-26 15:20:00','Qual è il vostro gioco preferito del momento?'),(35,17,'2023-03-26 16:35:00','Sto giocando a Elden Ring, è incredibile!'),(36,18,'2023-03-27 17:10:00','Ricetta per un cocktail estivo rinfrescante?'),(37,18,'2023-03-27 18:25:00','Mojito fatto in casa, semplice e delizioso!'),(38,19,'2023-03-28 19:00:00','Architettura moderna vs classica: preferenze?'),(39,19,'2023-03-28 20:15:00','Amo il contrasto tra le due, quando dialogano bene.'),(40,20,'2023-03-29 06:30:00','Ecco una foto del mio gatto che fa yoga con me!'),(41,20,'2023-03-29 07:45:00','Troppo carino! Il mio cane invece distrugge il tappetino.'),(42,21,'2023-03-30 08:20:00','Eventi astronomici da non perdere questo mese?'),(43,21,'2023-03-30 09:35:00','Il 15 c è una pioggia di meteoriti!'),(44,22,'2023-03-31 10:10:00','Qual è il vostro percorso running preferito in città?'),(45,22,'2023-03-31 11:25:00','Il parco centrale ha un bell anello di 5km perfetto.'),(46,23,'2023-04-01 12:00:00','Consigli per iniziare con gli acquerelli?'),(47,23,'2023-04-01 13:15:00','Inizia con carta di qualità e pochi colori base.'),(48,24,'2023-04-02 14:20:00','Ricette vegan facili per principianti?'),(49,24,'2023-04-02 15:35:00','Pasta e ceci è semplice, nutriente e deliziosa!'),(50,25,'2023-04-03 16:10:00','Come riparare uno scaffale traballante?'),(51,51,'2025-05-07 21:05:13','ciao raga'),(51,51,'2025-05-13 09:14:49','ciao'),(51,51,'2025-05-13 09:14:56','ddd'),(51,51,'2025-05-22 06:55:48','perché c\'era proprio il test di white ??'),(51,51,'2025-05-22 06:57:19','vabbè dai l\'importante è che è passata, almeno ora possiamo concentrarci sul progetto :)'),(52,51,'2025-05-22 06:54:59','Dai non male, aspetto con ansia i risultati'),(53,51,'2025-05-07 20:54:26','ciao grazie'),(53,51,'2025-05-07 22:32:14','test'),(53,51,'2025-05-08 08:07:45','prova'),(53,51,'2025-05-16 21:23:12','ciaoo'),(54,48,'2025-05-07 20:52:46','ciao ragazzi'),(54,51,'2025-05-07 20:53:10','Benvenuti'),(54,51,'2025-05-07 21:04:43','ciaooo'),(54,51,'2025-05-07 22:28:18','ueue'),(54,51,'2025-05-07 22:32:30','assurdooo'),(54,51,'2025-05-07 22:34:02','bellissimo'),(55,51,'2025-05-07 22:33:31','test'),(56,51,'2025-05-08 08:09:02','mao mao ?'),(57,51,'2025-05-22 06:53:41','com\'è andata la prova di modelli ? ?'),(57,51,'2025-05-22 06:54:00','speriamo bene ??'),(57,51,'2025-05-22 07:07:41',':))');
/*!40000 ALTER TABLE `MESSAGGIO_DI_GRUPPO` ENABLE KEYS */;
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
