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
-- Table structure for table `GRUPPO`
--

DROP TABLE IF EXISTS `GRUPPO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GRUPPO` (
  `ID_Gruppo` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `Foto_gruppo` text,
  `Descrizione` text,
  PRIMARY KEY (`ID_Gruppo`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GRUPPO`
--

LOCK TABLES `GRUPPO` WRITE;
/*!40000 ALTER TABLE `GRUPPO` DISABLE KEYS */;
INSERT INTO `GRUPPO` VALUES (1,'Fotografia Amatoriale','https://example.com/groups/photography.jpg','Gruppo per appassionati di fotografia'),(2,'Programmatori Italiani','https://example.com/groups/programmers.jpg','Condividi e impara con altri programmatori'),(3,'Viaggiatori Instancabili','https://example.com/groups/travel.jpg','Racconti e consigli di viaggio'),(4,'Cucina Creativa','https://example.com/groups/cooking.jpg','Ricette e tecniche di cucina'),(5,'Musica Indipendente','https://example.com/groups/music.jpg','Scopri nuovi artisti e band indipendenti'),(6,'Cinema Classico','https://example.com/groups/movies.jpg','Appassionati di cinema d autore'),(7,'Fitness a Casa','https://example.com/groups/fitness.jpg','Allenamenti e consigli per restare in forma'),(8,'Libri da Leggere','https://example.com/groups/books.jpg','Recensioni e consigli di lettura'),(9,'Arte Digitale','https://example.com/groups/digitalart.jpg','Mostra e discuti opere d arte digitale'),(10,'Giardinaggio Urbano','https://example.com/groups/gardening.jpg','Coltiva il tuo spazio verde in città'),(11,'Startup Italia','https://example.com/groups/startup.jpg','Per aspiranti imprenditori e innovatori'),(12,'Yoga e Meditazione','https://example.com/groups/yoga.jpg','Pratica e condividi il tuo percorso yoga'),(13,'Fotografia di Viaggio','https://example.com/groups/travelphoto.jpg','Le migliori foto dai tuoi viaggi'),(14,'Scrittura Creativa','https://example.com/groups/writing.jpg','Esercizi e consigli per scrittori'),(15,'Tecnologia Futuristica','https://example.com/groups/tech.jpg','Le ultime novità nel mondo tech'),(16,'Moda Sostenibile','https://example.com/groups/fashion.jpg','Moda etica e sostenibile'),(17,'Gaming Italiano','https://example.com/groups/gaming.jpg','Per tutti gli appassionati di videogiochi'),(18,'Cocktail e Mixology','https://example.com/groups/cocktails.jpg','Ricette e tecniche per cocktail perfetti'),(19,'Architettura Moderna','https://example.com/groups/architecture.jpg','Discussioni su design e architettura'),(20,'Animali Domestici','https://example.com/groups/pets.jpg','Condividi foto e storie dei tuoi animali'),(21,'Astronomia Amatoriale','https://example.com/groups/astronomy.jpg','Osservazioni e curiosità astronomiche'),(22,'Running Urbano','https://example.com/groups/running.jpg','Percorsi e consigli per corridori urbani'),(23,'Pittura ad Acquerello','https://example.com/groups/watercolor.jpg','Tecniche e tutorial per acquerellisti'),(24,'Vegan Lifestyle','https://example.com/groups/vegan.jpg','Ricette e consigli per una vita vegan'),(25,'Fai da Te','https://example.com/groups/diy.jpg','Progetti e riparazioni fai da te'),(26,'Fotografia Naturalistica','https://example.com/groups/naturephoto.jpg','La bellezza della natura attraverso l obiettivo'),(27,'Lingue Straniere','https://example.com/groups/languages.jpg','Impara e pratica lingue straniere'),(28,'Bicicletta in Città','https://example.com/groups/biking.jpg','Ciclisti urbani e percorsi cittadini'),(29,'Finanza Personale','https://example.com/groups/finance.jpg','Gestione del budget e investimenti'),(30,'Teatro e Drammaturgia','https://example.com/groups/theater.jpg','Appassionati di teatro e recitazione'),(31,'Fotografia Ritrattistica','https://example.com/groups/portrait.jpg','Tecniche per ritratti perfetti'),(32,'Caffè Speciali','https://example.com/groups/coffee.jpg','Degustazione e preparazione del caffè'),(33,'Arte di Strada','https://example.com/groups/streetart.jpg','Graffiti e arte urbana nel mondo'),(34,'Escursionismo','https://example.com/groups/hiking.jpg','Percorsi e attrezzatura per escursionisti'),(35,'Videomaking','https://example.com/groups/videomaking.jpg','Tecniche e consigli per video creator'),(36,'Ceramica Artistica','https://example.com/groups/ceramics.jpg','Lavorazione della ceramica e tecniche'),(37,'Fotografia Notturna','https://example.com/groups/nightphoto.jpg','Scatti e tecniche per foto notturne'),(38,'Medicina Naturale','https://example.com/groups/naturalmedicine.jpg','Rimedi e terapie naturali'),(39,'Scacchi','https://example.com/groups/chess.jpg','Tornei e strategie per giocatori di scacchi'),(40,'Fotografia Subacquea','https://example.com/groups/underwater.jpg','Il mondo sottomarino attraverso la fotografia'),(41,'Calligrafia','https://example.com/groups/calligraphy.jpg','L arte della bella scrittura'),(42,'Minimalismo','https://example.com/groups/minimalism.jpg','Vivere con meno e meglio'),(43,'Tatuaggi Artistici','https://example.com/groups/tattoos.jpg','Idee e artisti del tatuaggio'),(44,'Fotografia di Moda','https://example.com/groups/fashionphoto.jpg','Backstage e tecniche per fotografia di moda'),(45,'Vino e Degustazione','https://example.com/groups/wine.jpg','Degustazioni e abbinamenti con il vino'),(46,'Droni e Fotografia Aerea','https://example.com/groups/drones.jpg','Piloti di droni e fotografia aerea'),(47,'Arte Concettuale','https://example.com/groups/conceptualart.jpg','Discussioni su arte concettuale e contemporanea'),(48,'Birdwatching','https://example.com/groups/birdwatching.jpg','Osservazione e riconoscimento degli uccelli'),(49,'Fotografia Analogica','https://example.com/groups/filmphoto.jpg','La magia della fotografia su pellicola'),(50,'Arte Terapia','https://example.com/groups/arttherapy.jpg','L uso dell arte come strumento terapeutico'),(51,'UniSa',NULL,'Gruppo Unisa');
/*!40000 ALTER TABLE `GRUPPO` ENABLE KEYS */;
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
