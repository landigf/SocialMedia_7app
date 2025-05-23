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
-- Table structure for table `POST_HAS_TAG`
--

DROP TABLE IF EXISTS `POST_HAS_TAG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POST_HAS_TAG` (
  `Label` varchar(50) NOT NULL,
  `ID_Autore` int NOT NULL,
  `Data_ora` timestamp NOT NULL,
  PRIMARY KEY (`Label`,`ID_Autore`,`Data_ora`),
  KEY `ID_Autore` (`ID_Autore`,`Data_ora`),
  CONSTRAINT `post_has_tag_ibfk_1` FOREIGN KEY (`ID_Autore`, `Data_ora`) REFERENCES `POST` (`ID_Autore`, `Data_ora`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POST_HAS_TAG`
--

LOCK TABLES `POST_HAS_TAG` WRITE;
/*!40000 ALTER TABLE `POST_HAS_TAG` DISABLE KEYS */;
INSERT INTO `POST_HAS_TAG` VALUES ('fotografia',1,'2023-03-01 07:15:00'),('mattina',1,'2023-03-01 07:15:00'),('programmazione',2,'2023-03-01 08:30:00'),('successo',2,'2023-03-01 08:30:00'),('compositore',3,'2023-03-02 09:45:00'),('musica',3,'2023-03-02 09:45:00'),('futuromedico',4,'2023-03-02 11:00:00'),('medicina',4,'2023-03-02 11:00:00'),('arte',5,'2023-03-03 12:15:00'),('digitale',5,'2023-03-03 12:15:00'),('libri',6,'2023-03-03 13:30:00'),('scrittura',6,'2023-03-03 13:30:00'),('cucina',7,'2023-03-04 14:45:00'),('foodblogger',7,'2023-03-04 14:45:00'),('mobile',8,'2023-03-04 16:00:00'),('programmazione',8,'2023-03-04 16:00:00'),('fotografia',9,'2023-03-05 17:15:00'),('paesaggio',9,'2023-03-05 17:15:00'),('fitness',10,'2023-03-05 18:30:00'),('running',10,'2023-03-05 18:30:00'),('live',11,'2023-03-06 19:45:00'),('musica',11,'2023-03-06 19:45:00'),('gaming',12,'2023-03-06 21:00:00'),('tecnologia',12,'2023-03-06 21:00:00'),('successo',13,'2023-03-07 07:15:00'),('università',13,'2023-03-07 07:15:00'),('programmazione',14,'2023-03-07 08:30:00'),('webdesign',14,'2023-03-07 08:30:00'),('giornalismo',15,'2023-03-08 09:45:00'),('sport',15,'2023-03-08 09:45:00'),('crescita',16,'2023-03-08 11:00:00'),('libri',16,'2023-03-08 11:00:00'),('ambiente',17,'2023-03-09 12:15:00'),('scrittura',17,'2023-03-09 12:15:00'),('insegnamento',18,'2023-03-09 13:30:00'),('musica',18,'2023-03-09 13:30:00'),('design',19,'2023-03-10 14:45:00'),('moda',19,'2023-03-10 14:45:00'),('casa',20,'2023-03-10 16:00:00'),('faiDate',20,'2023-03-10 16:00:00'),('food',21,'2023-03-11 17:15:00'),('imprenditore',21,'2023-03-11 17:15:00'),('contentcreator',22,'2023-03-11 18:30:00'),('youtube',22,'2023-03-11 18:30:00'),('finanza',23,'2023-03-12 19:45:00'),('tecnologia',23,'2023-03-12 19:45:00'),('adozione',24,'2023-03-12 21:00:00'),('animali',24,'2023-03-12 21:00:00'),('gaming',25,'2023-03-13 07:15:00'),('streamer',25,'2023-03-13 07:15:00');
/*!40000 ALTER TABLE `POST_HAS_TAG` ENABLE KEYS */;
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
