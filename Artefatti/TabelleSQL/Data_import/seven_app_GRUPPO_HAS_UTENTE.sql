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
-- Table structure for table `GRUPPO_HAS_UTENTE`
--

DROP TABLE IF EXISTS `GRUPPO_HAS_UTENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GRUPPO_HAS_UTENTE` (
  `ID_Gruppo` int NOT NULL,
  `ID_Utente` int NOT NULL,
  `Amministratore` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID_Gruppo`,`ID_Utente`),
  KEY `ID_Utente` (`ID_Utente`),
  CONSTRAINT `gruppo_has_utente_ibfk_1` FOREIGN KEY (`ID_Gruppo`) REFERENCES `GRUPPO` (`ID_Gruppo`) ON DELETE CASCADE,
  CONSTRAINT `gruppo_has_utente_ibfk_2` FOREIGN KEY (`ID_Utente`) REFERENCES `UTENTE` (`ID_Utente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GRUPPO_HAS_UTENTE`
--

LOCK TABLES `GRUPPO_HAS_UTENTE` WRITE;
/*!40000 ALTER TABLE `GRUPPO_HAS_UTENTE` DISABLE KEYS */;
INSERT INTO `GRUPPO_HAS_UTENTE` VALUES (1,1,1),(1,2,0),(1,3,0),(1,4,0),(1,5,0),(1,6,0),(1,7,0),(1,8,0),(1,9,0),(1,10,0),(1,11,0),(1,12,0),(2,4,1),(2,5,0),(2,6,0),(2,7,0),(2,8,0),(2,9,0),(2,10,0),(2,11,0),(2,12,0),(2,13,0),(2,14,0),(2,15,0),(2,16,0),(3,6,1),(3,7,0),(3,8,0),(3,9,0),(3,10,0),(3,11,0),(3,12,0),(3,13,0),(3,14,0),(4,8,1),(4,9,0),(4,10,0),(4,11,0),(4,12,0),(4,13,0),(4,14,0),(4,15,0),(5,10,1),(5,11,0),(5,12,0),(5,13,0),(5,14,0),(5,15,0),(5,16,0),(5,17,0),(5,18,0),(5,19,0),(6,12,1),(6,13,0),(6,14,0),(6,15,0),(6,16,0),(6,17,0),(6,18,0),(7,14,1),(7,15,0),(7,16,0),(7,17,0),(7,18,0),(7,19,0),(7,20,0),(7,21,0),(7,22,0),(7,23,0),(7,24,0),(8,16,1),(8,17,0),(8,18,0),(8,19,0),(8,20,0),(8,21,0),(8,22,0),(8,23,0),(8,24,0),(9,18,1),(9,19,0),(9,20,0),(9,21,0),(9,22,0),(9,23,0),(9,24,0),(9,25,0),(10,20,1),(10,21,0),(10,22,0),(10,23,0),(10,24,0),(10,25,0),(11,22,1),(11,23,0),(11,24,0),(11,25,0),(11,26,0),(11,27,0),(11,28,0),(11,29,0),(11,30,0),(11,31,0),(11,32,0),(11,33,0),(11,34,0),(12,24,1),(12,25,0),(12,26,0),(12,27,0),(12,28,0),(12,29,0),(12,30,0),(12,31,0),(12,32,0),(12,33,0),(13,26,1),(13,27,0),(13,28,0),(13,29,0),(13,30,0),(13,31,0),(13,32,0),(13,33,0),(14,28,1),(14,29,0),(14,30,0),(14,31,0),(14,32,0),(14,33,0),(14,34,0),(15,30,1),(15,31,0),(15,32,0),(15,33,0),(15,34,0),(15,35,0),(15,36,0),(15,37,0),(15,38,0),(15,39,0),(15,40,0),(15,41,0),(15,42,0),(15,43,0),(15,44,0),(15,45,0),(16,32,1),(16,33,0),(16,34,0),(16,35,0),(16,36,0),(16,37,0),(16,38,0),(16,39,0),(16,40,0),(17,34,1),(17,35,0),(17,36,0),(17,37,0),(17,38,0),(17,39,0),(17,40,0),(17,41,0),(17,42,0),(17,43,0),(17,44,0),(17,45,0),(17,46,0),(18,36,1),(18,37,0),(18,38,0),(18,39,0),(18,40,0),(18,41,0),(18,42,0),(19,38,1),(19,39,0),(19,40,0),(19,41,0),(19,42,0),(19,43,0),(20,40,1),(20,41,0),(20,42,0),(20,43,0),(20,44,0),(20,45,0),(20,46,0),(20,47,0),(20,48,0),(20,49,0),(20,50,0),(21,42,1),(21,43,0),(22,44,1),(22,45,0),(23,46,1),(23,47,0),(24,48,1),(24,49,0),(25,50,1),(48,54,0),(51,51,0),(51,52,0),(51,53,0),(51,54,1),(51,55,0),(51,56,0),(51,57,0);
/*!40000 ALTER TABLE `GRUPPO_HAS_UTENTE` ENABLE KEYS */;
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
