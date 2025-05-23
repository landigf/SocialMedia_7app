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
-- Table structure for table `UTENTE`
--

DROP TABLE IF EXISTS `UTENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UTENTE` (
  `ID_Utente` int NOT NULL AUTO_INCREMENT,
  `Nickname` varchar(50) NOT NULL,
  `Nome` varchar(50) DEFAULT NULL,
  `Foto_profilo` text,
  `Data_di_nascita` date DEFAULT NULL,
  `Genere` varchar(15) DEFAULT NULL,
  `Pronomi` varchar(15) DEFAULT NULL,
  `Biografia` text,
  `Telefono` varchar(20) DEFAULT NULL,
  `Verificato` tinyint(1) DEFAULT '0',
  `Link` text,
  `Contenuti_sensibili` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID_Utente`),
  UNIQUE KEY `Nickname` (`Nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UTENTE`
--

LOCK TABLES `UTENTE` WRITE;
/*!40000 ALTER TABLE `UTENTE` DISABLE KEYS */;
INSERT INTO `UTENTE` VALUES (1,'alice22','Alice Bianchi','https://example.com/profiles/alice.jpg','1995-03-15','Femmina','lei/la','Appassionata di fotografia e viaggi','3456789012',1,'https://aliceportfolio.com',1),(2,'bob_tech','Roberto Rossi','https://example.com/profiles/bob.jpg','1990-07-22','Maschio','lui/lo','Sviluppatore software e gamer','3331234567',0,NULL,0),(3,'charlie_g','Carlo Verdi','https://example.com/profiles/charlie.jpg','1988-11-30','Maschio','lui/lo','Musicista e compositore','3476543210',0,'https://charlie-music.com',1),(4,'diana_s','Diana Santoro','https://example.com/profiles/diana.jpg','1993-05-18','Femmina','lei/la','Studentessa di medicina','3287654321',0,NULL,0),(5,'evan_art','Eva Neri','https://example.com/profiles/evan.jpg','1997-09-10','Non-binario','loro','Artista digitale e illustratore','3665432198',1,'https://evan-art.com',1),(6,'frank_w','Francesco White','https://example.com/profiles/frank.jpg','1985-12-05','Maschio','lui/lo','Scrittore e blogger','3409876543',0,'https://frankwrites.com',0),(7,'gina_p','Gina Pausini','https://example.com/profiles/gina.jpg','1992-02-28','Femmina','lei/la','Cuoca e food blogger','3334567890',1,'https://ginacooks.com',1),(8,'harry_s','Harrison Smith','https://example.com/profiles/harry.jpg','1998-08-15','Maschio','lui/lo','Studente di ingegneria','3298765432',0,NULL,0),(9,'iris_m','Iris Mariani','https://example.com/profiles/iris.jpg','1991-04-20','Femmina','lei/la','Fotografa professionista','3487654321',1,'https://irismariani.photo',1),(10,'jack_r','Jack Russo','https://example.com/profiles/jack.jpg','1987-10-12','Maschio','lui/lo','Personal trainer e nutrizionista','3345678901',0,'https://jackfitness.com',0),(11,'kate_b','Kate Brown','https://example.com/profiles/kate.jpg','1994-06-25','Femmina','lei/la','Viaggiatrice e influencer','3456789012',1,'https://katearound.com',1),(12,'leo_d','Leonardo De Luca','https://example.com/profiles/leo.jpg','1996-01-08','Maschio','lui/lo','Appassionato di tecnologia','3339876543',0,NULL,0),(13,'mia_c','Mia Conti','https://example.com/profiles/mia.jpg','1999-07-03','Femmina','lei/la','Studentessa universitaria','3287654321',0,NULL,1),(14,'nick_g','Nicola Greco','https://example.com/profiles/nick.jpg','1989-11-17','Maschio','lui/lo','Sviluppatore web freelance','3476543210',0,'https://nickdev.com',0),(15,'olivia_f','Olivia Ferrari','https://example.com/profiles/olivia.jpg','1993-09-22','Femmina','lei/la','Giornalista sportiva','3665432198',1,'https://oliviasports.com',1),(16,'paul_m','Paolo Moretti','https://example.com/profiles/paul.jpg','1986-04-14','Maschio','lui/lo','Architetto e designer','3409876543',0,'https://pauldesign.com',0),(17,'quinn_s','Quinn Santini','https://example.com/profiles/quinn.jpg','1997-12-30','Non-binario','loro','Attivista e scrittore','3334567890',0,'https://quinnwrites.com',1),(18,'rachel_g','Rachel Green','https://example.com/profiles/rachel.jpg','1990-02-11','Femmina','lei/la','Psicologa clinica','3298765432',0,NULL,0),(19,'sam_t','Samuele Trentini','https://example.com/profiles/sam.jpg','1995-08-07','Maschio','lui/lo','Musicista e insegnante','3487654321',0,'https://samuelmusic.com',0),(20,'tina_v','Tina Villa','https://example.com/profiles/tina.jpg','1992-05-19','Femmina','lei/la','Influencer di moda','3345678901',1,'https://tinastyle.com',1),(21,'ugo_b','Ugo Barbieri','https://example.com/profiles/ugo.jpg','1988-10-23','Maschio','lui/lo','Chef e ristoratore','3456789012',0,'https://ugocuisine.com',0),(22,'vicky_l','Vicky Lombardi','https://example.com/profiles/vicky.jpg','1996-03-28','Femmina','lei/la','Youtuber e content creator','3339876543',1,'https://vickyvlogs.com',1),(23,'will_c','William Costa','https://example.com/profiles/will.jpg','1991-07-16','Maschio','lui/lo','Imprenditore digitale','3287654321',0,'https://willenterprise.com',0),(24,'xena_k','Xena Kowalski','https://example.com/profiles/xena.jpg','1998-11-05','Femmina','lei/la','Studentessa di legge','3476543210',0,NULL,1),(25,'yuri_m','Yuri Martini','https://example.com/profiles/yuri.jpg','1994-01-29','Maschio','lui/lo','Gamer e streamer','3665432198',1,'https://yuristream.com',1),(26,'zoe_r','Zoe Romano','https://example.com/profiles/zoe.jpg','1993-09-12','Femmina','lei/la','Fotografa di matrimoni','3409876543',0,'https://zoephoto.com',0),(27,'adam_j','Adam Johnson','https://example.com/profiles/adam.jpg','1987-06-08','Maschio','lui/lo','Scrittore fantasy','3334567890',0,'https://adamfantasy.com',0),(28,'bella_p','Bella Parker','https://example.com/profiles/bella.jpg','1995-04-17','Femmina','lei/la','Modella e influencer','3298765432',1,'https://bellamodel.com',1),(29,'carl_s','Carl Smith','https://example.com/profiles/carl.jpg','1990-12-03','Maschio','lui/lo','Ingegnere meccanico','3487654321',0,NULL,0),(30,'daisy_m','Daisy Miller','https://example.com/profiles/daisy.jpg','1997-02-14','Femmina','lei/la','Fioraia e artista','3345678901',0,'https://daisyflowers.com',1),(31,'eddie_v','Eddie Valenti','https://example.com/profiles/eddie.jpg','1992-08-09','Maschio','lui/lo','Musicista jazz','3456789012',0,'https://eddieplaysjazz.com',0),(32,'fiona_g','Fiona Green','https://example.com/profiles/fiona.jpg','1989-05-26','Femmina','lei/la','Avvocato penalista','3339876543',1,'https://fionalaw.com',0),(33,'george_k','George King','https://example.com/profiles/george.jpg','1996-10-31','Maschio','lui/lo','Videomaker e regista','3287654321',0,'https://georgefilms.com',1),(34,'hannah_s','Hannah Scott','https://example.com/profiles/hannah.jpg','1994-07-22','Femmina','lei/la','Insegnante di yoga','3476543210',0,'https://hannahyoga.com',0),(35,'ivan_p','Ivan Petrov','https://example.com/profiles/ivan.jpg','1991-01-15','Maschio','lui/lo','Programmatore e hacker etico','3665432198',0,'https://ivansecurity.com',0),(36,'jill_w','Jill Wilson','https://example.com/profiles/jill.jpg','1998-03-08','Femmina','lei/la','Studentessa di medicina','3409876543',0,NULL,1),(37,'kevin_l','Kevin Lee','https://example.com/profiles/kevin.jpg','1993-11-19','Maschio','lui/lo','Giornalista investigativo','3334567890',1,'https://kevinreports.com',0),(38,'lily_c','Lily Chen','https://example.com/profiles/lily.jpg','1997-09-04','Femmina','lei/la','Artista digitale','3298765432',0,'https://lilydigitalart.com',1),(39,'mike_b','Mike Brown','https://example.com/profiles/mike.jpg','1988-04-27','Maschio','lui/lo','Personal finance coach','3487654321',0,'https://mikemoney.com',0),(40,'nina_s','Nina Sanchez','https://example.com/profiles/nina.jpg','1995-12-12','Femmina','lei/la','Modella e attrice','3345678901',1,'https://ninamodel.com',1),(41,'oscar_t','Oscar Taylor','https://example.com/profiles/oscar.jpg','1990-06-30','Maschio','lui/lo','Scrittore di viaggi','3456789012',0,'https://oscartravels.com',0),(42,'paula_r','Paula Rodriguez','https://example.com/profiles/paula.jpg','1994-02-23','Femmina','lei/la','Psicologa infantile','3339876543',0,'https://paulapsy.com',0),(43,'quentin_g','Quentin Garcia','https://example.com/profiles/quentin.jpg','1996-08-17','Maschio','lui/lo','Fotografo di strada','3287654321',0,'https://quentinstreet.com',1),(44,'rose_k','Rose Kim','https://example.com/profiles/rose.jpg','1992-05-09','Femmina','lei/la','Chef pasticcera','3476543210',1,'https://rosebakes.com',1),(45,'steve_m','Steve Martin','https://example.com/profiles/steve.jpg','1989-10-28','Maschio','lui/lo','Podcaster e comico','3665432198',0,'https://stevepodcast.com',0),(46,'tara_j','Tara Jones','https://example.com/profiles/tara.jpg','1997-03-14','Femmina','lei/la','Influencer fitness','3409876543',1,'https://tarafit.com',1),(47,'ulysses_c','Ulysses Carter','https://example.com/profiles/ulysses.jpg','1993-07-21','Maschio','lui/lo','Avventuriero e alpinista','3334567890',0,'https://ulyssesadventures.com',1),(48,'violet_p','Violet Parker','https://example.com/profiles/violet.jpg','1998-11-05','Femmina','lei/la','Studentessa di arte','3298765432',0,NULL,0),(49,'walter_b','Walter Brown','https://example.com/profiles/walter.jpg','1986-09-12','Maschio','lui/lo','Giornalista in pensione','3487654321',0,'https://walterwrites.com',0),(50,'xander_l','Xander Lee','https://example.com/profiles/xander.jpg','1995-04-03','Maschio','lui/lo','Sviluppatore di app','3345678901',0,'https://xanderdev.com',1),(51,'landigf','Gennaro Francesco Landi',NULL,'2004-02-05','Maschio','lui/lo','Studente di Statistica per i Big Data ad UniSa','+393421956235',0,'https://landigf.github.io/',0),(52,'salferra02','Salvatore Ferrandino',NULL,'2002-01-17','M','he/him','furetto','3349580939',0,'boh',0),(53,'elli','elli',NULL,'2004-02-12','f','lei/la','elli','elli',0,NULL,0),(54,'prova',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,0),(55,'test',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,0),(56,'briciola',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,0),(57,'Utente7app','Utente Test',NULL,'2004-02-12','Maschio','he/him','Utente per testare 7app','1234567880',0,NULL,0),(58,'lorenzo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,0);
/*!40000 ALTER TABLE `UTENTE` ENABLE KEYS */;
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
