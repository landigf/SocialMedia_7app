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
-- Table structure for table `UTENTE_CREDENZIALI`
--

DROP TABLE IF EXISTS `UTENTE_CREDENZIALI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UTENTE_CREDENZIALI` (
  `ID_Utente` int NOT NULL,
  `E_mail` varchar(50) NOT NULL,
  `Pass` varchar(255) NOT NULL,
  PRIMARY KEY (`ID_Utente`),
  UNIQUE KEY `E_mail` (`E_mail`),
  CONSTRAINT `utente_credenziali_ibfk_1` FOREIGN KEY (`ID_Utente`) REFERENCES `UTENTE` (`ID_Utente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UTENTE_CREDENZIALI`
--

LOCK TABLES `UTENTE_CREDENZIALI` WRITE;
/*!40000 ALTER TABLE `UTENTE_CREDENZIALI` DISABLE KEYS */;
INSERT INTO `UTENTE_CREDENZIALI` VALUES (1,'alice.bianchi@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(2,'bob.rossi@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(3,'charlie.verdi@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(4,'diana.santoro@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(5,'evan.neri@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(6,'frank.white@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(7,'gina.pausini@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(8,'harry.smith@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(9,'iris.mariani@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(10,'jack.russo@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(11,'kate.brown@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(12,'leo.deluca@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(13,'mia.conti@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(14,'nick.greco@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(15,'olivia.ferrari@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(16,'paul.moretti@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(17,'quinn.santini@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(18,'rachel.green@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(19,'sam.trentini@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(20,'tina.villa@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(21,'ugo.barbieri@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(22,'vicky.lombardi@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(23,'will.costa@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(24,'xena.kowalski@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(25,'yuri.martini@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(26,'zoe.romano@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(27,'adam.johnson@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(28,'bella.parker@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(29,'carl.smith@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(30,'daisy.miller@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(31,'eddie.valenti@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(32,'fiona.green@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(33,'george.king@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(34,'hannah.scott@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(35,'ivan.petrov@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(36,'jill.wilson@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(37,'kevin.lee@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(38,'lily.chen@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(39,'mike.brown@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(40,'nina.sanchez@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(41,'oscar.taylor@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(42,'paula.rodriguez@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(43,'quentin.garcia@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(44,'rose.kim@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(45,'steve.martin@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(46,'tara.jones@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(47,'ulysses.carter@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(48,'violet.parker@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(49,'walter.brown@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(50,'xander.lee@email.com','$2y$10$N9qo8uLOickgx2ZMRZoMy.MH/r7Vw0YREB0Xj2Z4D5A0Tf6Yjb.9a'),(51,'g.landi83@studenti.unisa.it','0c03d9594b747644d3bdfbc98e026ff63c82c5ba215e22f46ec76874ca639c28'),(52,'salfe@gmail.com','1c7d9020a9531a79b72d56f36aa0e6aa08521df69d0be877885c59955efe6393'),(53,'elli@gmail.com','0ac7f27b1888210ea9691084be536bd7cd7eaf0c8f7b615ca7c19bd65c0c4ec9'),(54,'prova@gmail.com','6258a5e0eb772911d4f92be5b5db0e14511edbe01d1d0ddd1d5a2cb9db9a56ba'),(55,'test@gmail.com','9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'),(56,'briciola@gmail.com','4c66e704cac4b49a27a40c6f9dd57a971fbf5203c8fdab2d17c1e37e1493b890'),(57,'Utente7app@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'),(58,'lorenzo@gmail.com','03fd72f81572805dd59f829b94fd8a6f82077fb435ca2b406d9595718e521afa');
/*!40000 ALTER TABLE `UTENTE_CREDENZIALI` ENABLE KEYS */;
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
