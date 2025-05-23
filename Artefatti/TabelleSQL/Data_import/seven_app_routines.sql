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
-- Temporary view structure for view `amiciincomune_v`
--

DROP TABLE IF EXISTS `amiciincomune_v`;
/*!50001 DROP VIEW IF EXISTS `amiciincomune_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `amiciincomune_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `AmicoInComune`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `numamicigruppiincomune_v`
--

DROP TABLE IF EXISTS `numamicigruppiincomune_v`;
/*!50001 DROP VIEW IF EXISTS `numamicigruppiincomune_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `numamicigruppiincomune_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `NumAmiciInComune`,
 1 AS `NumGruppiInComune`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `amicigruppiinterazioni_v`
--

DROP TABLE IF EXISTS `amicigruppiinterazioni_v`;
/*!50001 DROP VIEW IF EXISTS `amicigruppiinterazioni_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `amicigruppiinterazioni_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `NumAmiciInComune`,
 1 AS `NumGruppiInComune`,
 1 AS `NumInterazioni`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `amicidiamici_v`
--

DROP TABLE IF EXISTS `amicidiamici_v`;
/*!50001 DROP VIEW IF EXISTS `amicidiamici_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `amicidiamici_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `AmicoDiAmico`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `amici_v`
--

DROP TABLE IF EXISTS `amici_v`;
/*!50001 DROP VIEW IF EXISTS `amici_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `amici_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `smartfeed_v`
--

DROP TABLE IF EXISTS `smartfeed_v`;
/*!50001 DROP VIEW IF EXISTS `smartfeed_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `smartfeed_v` AS SELECT 
 1 AS `ID_Utente`,
 1 AS `ID_Autore`,
 1 AS `Data_ora`,
 1 AS `Contenuto`,
 1 AS `NicknameAutore`,
 1 AS `FotoProfiloAutore`,
 1 AS `NumReazioni`,
 1 AS `NumCommenti`,
 1 AS `PunteggioAmicizia`,
 1 AS `PunteggioRecenza`,
 1 AS `BoostFollower`,
 1 AS `PunteggioFinale`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `topamici_v`
--

DROP TABLE IF EXISTS `topamici_v`;
/*!50001 DROP VIEW IF EXISTS `topamici_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `topamici_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `NumAmiciInComune`,
 1 AS `NumGruppiInComune`,
 1 AS `NumInterazioni`,
 1 AS `Punteggio`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `numgruppiincomune_v`
--

DROP TABLE IF EXISTS `numgruppiincomune_v`;
/*!50001 DROP VIEW IF EXISTS `numgruppiincomune_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `numgruppiincomune_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `NumGruppiInComune`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `gruppiincomune_v`
--

DROP TABLE IF EXISTS `gruppiincomune_v`;
/*!50001 DROP VIEW IF EXISTS `gruppiincomune_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gruppiincomune_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `ID_Gruppo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `numamiciincomune_v`
--

DROP TABLE IF EXISTS `numamiciincomune_v`;
/*!50001 DROP VIEW IF EXISTS `numamiciincomune_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `numamiciincomune_v` AS SELECT 
 1 AS `Utente1`,
 1 AS `Utente2`,
 1 AS `NumAmiciInComune`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `guppiperutente_v`
--

DROP TABLE IF EXISTS `guppiperutente_v`;
/*!50001 DROP VIEW IF EXISTS `guppiperutente_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `guppiperutente_v` AS SELECT 
 1 AS `ID_Utente`,
 1 AS `ID_Gruppo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `post_engagement_v`
--

DROP TABLE IF EXISTS `post_engagement_v`;
/*!50001 DROP VIEW IF EXISTS `post_engagement_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `post_engagement_v` AS SELECT 
 1 AS `ID_Autore`,
 1 AS `Data_ora`,
 1 AS `NumReazioni`,
 1 AS `NumCommenti`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `amiciincomune_v`
--

/*!50001 DROP VIEW IF EXISTS `amiciincomune_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `amiciincomune_v` AS select `aa`.`Utente1` AS `Utente1`,`aa`.`Utente2` AS `Utente2`,`aa`.`AmicoDiAmico` AS `AmicoInComune` from (`amicidiamici_v` `AA` left join `amici_v` `A` on(((`aa`.`AmicoDiAmico` = `a`.`Utente1`) and (`aa`.`Utente1` = `a`.`Utente2`)))) order by `aa`.`Utente1` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `numamicigruppiincomune_v`
--

/*!50001 DROP VIEW IF EXISTS `numamicigruppiincomune_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `numamicigruppiincomune_v` AS select `a`.`Utente1` AS `Utente1`,`a`.`Utente2` AS `Utente2`,`a`.`NumAmiciInComune` AS `NumAmiciInComune`,`g`.`NumGruppiInComune` AS `NumGruppiInComune` from (`numamiciincomune_v` `A` left join `numgruppiincomune_v` `G` on(((`a`.`Utente1` = `g`.`Utente1`) and (`a`.`Utente2` = `g`.`Utente2`)))) order by `a`.`Utente1`,`a`.`Utente2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `amicigruppiinterazioni_v`
--

/*!50001 DROP VIEW IF EXISTS `amicigruppiinterazioni_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `amicigruppiinterazioni_v` AS select `n`.`Utente1` AS `Utente1`,`n`.`Utente2` AS `Utente2`,ifnull(`n`.`NumAmiciInComune`,0) AS `NumAmiciInComune`,ifnull(`n`.`NumGruppiInComune`,0) AS `NumGruppiInComune`,ifnull(`i`.`NumInterazioni`,0) AS `NumInterazioni` from (`numamicigruppiincomune_v` `N` left join (select `interazioni`.`ID_Utente` AS `Utente1`,`interazioni`.`ID_Autore` AS `Utente2`,count(0) AS `NumInterazioni` from `interazioni` group by `interazioni`.`ID_Utente`,`interazioni`.`ID_Autore`) `I` on(((`n`.`Utente1` = `i`.`Utente1`) and (`n`.`Utente2` = `i`.`Utente2`)))) union select `i`.`Utente1` AS `Utente1`,`i`.`Utente2` AS `Utente2`,ifnull(`n`.`NumAmiciInComune`,0) AS `IFNULL(N.NumAmiciInComune, 0)`,ifnull(`n`.`NumGruppiInComune`,0) AS `IFNULL(N.NumGruppiInComune, 0)`,ifnull(`i`.`NumInterazioni`,0) AS `IFNULL(I.NumInterazioni, 0)` from ((select `interazioni`.`ID_Utente` AS `Utente1`,`interazioni`.`ID_Autore` AS `Utente2`,count(0) AS `NumInterazioni` from `interazioni` group by `interazioni`.`ID_Utente`,`interazioni`.`ID_Autore`) `I` left join `numamicigruppiincomune_v` `N` on(((`i`.`Utente1` = `n`.`Utente1`) and (`i`.`Utente2` = `n`.`Utente2`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `amicidiamici_v`
--

/*!50001 DROP VIEW IF EXISTS `amicidiamici_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `amicidiamici_v` AS select `a1`.`Utente1` AS `Utente1`,`a1`.`Utente2` AS `Utente2`,`a2`.`Utente2` AS `AmicoDiAmico` from (`amici_v` `A1` left join `amici_v` `A2` on(((`a1`.`Utente2` = `a2`.`Utente1`) and (`a2`.`Utente2` <> `a1`.`Utente1`)))) order by `a1`.`Utente1` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `amici_v`
--

/*!50001 DROP VIEW IF EXISTS `amici_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `amici_v` AS select `F1`.`ID_Sender` AS `Utente1`,`F1`.`ID_Followed` AS `Utente2` from (`follow` `F1` join `follow` `F2` on(((`F1`.`ID_Sender` = `F2`.`ID_Followed`) and (`F1`.`ID_Followed` = `F2`.`ID_Sender`)))) order by `F1`.`ID_Sender` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `smartfeed_v`
--

/*!50001 DROP VIEW IF EXISTS `smartfeed_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `smartfeed_v` AS select `F`.`ID_Sender` AS `ID_Utente`,`P`.`ID_Autore` AS `ID_Autore`,`P`.`Data_ora` AS `Data_ora`,`P`.`Contenuto` AS `Contenuto`,`UA`.`Nickname` AS `NicknameAutore`,`UA`.`Foto_profilo` AS `FotoProfiloAutore`,ifnull(`e`.`NumReazioni`,0) AS `NumReazioni`,ifnull(`e`.`NumCommenti`,0) AS `NumCommenti`,`t`.`Punteggio` AS `PunteggioAmicizia`,(1 / greatest(timestampdiff(HOUR,`P`.`Data_ora`,now()),1)) AS `PunteggioRecenza`,(case when (timestampdiff(DAY,`F`.`Data_ora`,now()) <= 7) then 1.5 when (timestampdiff(DAY,`F`.`Data_ora`,now()) <= 30) then 1.2 else 1 end) AS `BoostFollower`,(((((0.36 * ifnull(`t`.`Punteggio`,0)) + (0.12 * ifnull(`e`.`NumReazioni`,0))) + (0.12 * ifnull(`e`.`NumCommenti`,0))) + (0.40 * (1 / greatest(timestampdiff(HOUR,`P`.`Data_ora`,now()),1)))) * (case when (timestampdiff(DAY,`F`.`Data_ora`,now()) <= 7) then 1.5 when (timestampdiff(DAY,`F`.`Data_ora`,now()) <= 30) then 1.2 else 1 end)) AS `PunteggioFinale` from ((((((`follow` `F` join `post` `P` on((`F`.`ID_Followed` = `P`.`ID_Autore`))) join `utente` `U` on((`U`.`ID_Utente` = `F`.`ID_Sender`))) join `utente` `UA` on((`UA`.`ID_Utente` = `P`.`ID_Autore`))) left join `interazioni` `I` on(((`I`.`ID_Utente` = `F`.`ID_Sender`) and (`I`.`ID_Autore` = `P`.`ID_Autore`) and (`I`.`Data_ora` = `P`.`Data_ora`) and (`I`.`Tipo_interazione` = 'view')))) left join `post_engagement_v` `E` on(((`P`.`ID_Autore` = `e`.`ID_Autore`) and (`P`.`Data_ora` = `e`.`Data_ora`)))) left join `topamici_v` `T` on(((`F`.`ID_Sender` = `t`.`Utente1`) and (`P`.`ID_Autore` = `t`.`Utente2`)))) where ((`P`.`ID_Autore_fonte` is null) and (`I`.`ID_Utente` is null) and ((`P`.`Sensibile` = false) or ((`P`.`Sensibile` = true) and (`U`.`Contenuti_sensibili` = true)))) order by `F`.`ID_Sender`,(((((0.36 * ifnull(`t`.`Punteggio`,0)) + (0.12 * ifnull(`e`.`NumReazioni`,0))) + (0.12 * ifnull(`e`.`NumCommenti`,0))) + (0.40 * (1 / greatest(timestampdiff(HOUR,`P`.`Data_ora`,now()),1)))) * (case when (timestampdiff(DAY,`F`.`Data_ora`,now()) <= 7) then 1.5 when (timestampdiff(DAY,`F`.`Data_ora`,now()) <= 30) then 1.2 else 1 end)) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `topamici_v`
--

/*!50001 DROP VIEW IF EXISTS `topamici_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `topamici_v` AS select `amicigruppiinterazioni_v`.`Utente1` AS `Utente1`,`amicigruppiinterazioni_v`.`Utente2` AS `Utente2`,`amicigruppiinterazioni_v`.`NumAmiciInComune` AS `NumAmiciInComune`,`amicigruppiinterazioni_v`.`NumGruppiInComune` AS `NumGruppiInComune`,`amicigruppiinterazioni_v`.`NumInterazioni` AS `NumInterazioni`,(((0.5 * `amicigruppiinterazioni_v`.`NumAmiciInComune`) + (0.3 * `amicigruppiinterazioni_v`.`NumGruppiInComune`)) + (0.2 * `amicigruppiinterazioni_v`.`NumInterazioni`)) AS `Punteggio` from `amicigruppiinterazioni_v` order by `amicigruppiinterazioni_v`.`Utente1`,(((0.5 * `amicigruppiinterazioni_v`.`NumAmiciInComune`) + (0.3 * `amicigruppiinterazioni_v`.`NumGruppiInComune`)) + (0.2 * `amicigruppiinterazioni_v`.`NumInterazioni`)) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `numgruppiincomune_v`
--

/*!50001 DROP VIEW IF EXISTS `numgruppiincomune_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `numgruppiincomune_v` AS select `g1`.`ID_Utente` AS `Utente1`,`g2`.`ID_Utente` AS `Utente2`,count(0) AS `NumGruppiInComune` from (`guppiperutente_v` `G1` join `guppiperutente_v` `G2` on(((`g1`.`ID_Gruppo` = `g2`.`ID_Gruppo`) and (`g1`.`ID_Utente` <> `g2`.`ID_Utente`)))) group by `g1`.`ID_Utente`,`g2`.`ID_Utente` order by `g1`.`ID_Utente` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `gruppiincomune_v`
--

/*!50001 DROP VIEW IF EXISTS `gruppiincomune_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gruppiincomune_v` AS select `g1`.`ID_Utente` AS `Utente1`,`g2`.`ID_Utente` AS `Utente2`,`g1`.`ID_Gruppo` AS `ID_Gruppo` from (`guppiperutente_v` `G1` join `guppiperutente_v` `G2` on(((`g1`.`ID_Gruppo` = `g2`.`ID_Gruppo`) and (`g1`.`ID_Utente` <> `g2`.`ID_Utente`)))) order by `g1`.`ID_Utente`,`g2`.`ID_Utente` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `numamiciincomune_v`
--

/*!50001 DROP VIEW IF EXISTS `numamiciincomune_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `numamiciincomune_v` AS select `amiciincomune_v`.`Utente1` AS `Utente1`,`amiciincomune_v`.`Utente2` AS `Utente2`,count(`amiciincomune_v`.`AmicoInComune`) AS `NumAmiciInComune` from `amiciincomune_v` group by `amiciincomune_v`.`Utente1`,`amiciincomune_v`.`Utente2` order by `amiciincomune_v`.`Utente1` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `guppiperutente_v`
--

/*!50001 DROP VIEW IF EXISTS `guppiperutente_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `guppiperutente_v` AS select `U`.`ID_Utente` AS `ID_Utente`,`G`.`ID_Gruppo` AS `ID_Gruppo` from (`utente` `U` join `gruppo_has_utente` `G` on((`U`.`ID_Utente` = `G`.`ID_Utente`))) order by `U`.`ID_Utente` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `post_engagement_v`
--

/*!50001 DROP VIEW IF EXISTS `post_engagement_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `post_engagement_v` AS select `interazioni`.`ID_Autore` AS `ID_Autore`,`interazioni`.`Data_ora` AS `Data_ora`,sum((`interazioni`.`Tipo_interazione` = 'reaction')) AS `NumReazioni`,sum((`interazioni`.`Tipo_interazione` = 'comment')) AS `NumCommenti` from `interazioni` group by `interazioni`.`ID_Autore`,`interazioni`.`Data_ora` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping events for database 'seven_app'
--

--
-- Dumping routines for database 'seven_app'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-22  9:31:29
