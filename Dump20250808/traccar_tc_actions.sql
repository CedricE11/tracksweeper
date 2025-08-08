-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: mail.cognoquest.org    Database: traccar
-- ------------------------------------------------------
-- Server version	5.5.5-10.5.22-MariaDB

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
-- Table structure for table `tc_actions`
--

DROP TABLE IF EXISTS `tc_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tc_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `actiontime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `address` varchar(48) DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `actiontype` varchar(32) NOT NULL,
  `objecttype` varchar(32) DEFAULT NULL,
  `objectid` int(11) DEFAULT NULL,
  `attributes` varchar(4000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tc_actions`
--

LOCK TABLES `tc_actions` WRITE;
/*!40000 ALTER TABLE `tc_actions` DISABLE KEYS */;
INSERT INTO `tc_actions` VALUES (1,'2025-08-07 14:03:56','142.120.168.24',1,'login',NULL,NULL,'{}'),(2,'2025-08-07 17:04:00','142.120.168.24',1,'login',NULL,NULL,'{}'),(3,'2025-08-07 18:02:38','154.20.209.4',1,'login',NULL,NULL,'{}'),(4,'2025-08-07 18:02:47','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-08-07 03:00\",\"to\":\"2025-08-08 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(5,'2025-08-07 18:03:20','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2025-08-07 03:00\",\"to\":\"2025-08-08 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(6,'2025-08-07 18:36:28','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-06-13 20:00\",\"to\":\"2025-06-14 19:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(7,'2025-08-07 18:36:30','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2025-06-13 20:00\",\"to\":\"2025-06-14 19:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(8,'2025-08-07 18:37:00','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-06-13 09:02\",\"to\":\"2025-06-15 10:02\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(9,'2025-08-07 18:39:20','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(10,'2025-08-07 18:39:31','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(11,'2025-08-07 21:49:04','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(12,'2025-08-07 21:49:11','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(13,'2025-08-07 22:01:16','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(14,'2025-08-07 22:01:19','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(15,'2025-08-07 22:04:49','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(16,'2025-08-07 22:04:53','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2024-12-31 19:00\",\"to\":\"2025-12-31 18:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(17,'2025-08-08 02:38:36','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-01-01 03:00\",\"to\":\"2025-08-07 13:03\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(18,'2025-08-08 02:38:56','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-01-01 03:00\",\"to\":\"2025-01-19 13:03\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(19,'2025-08-08 02:39:44','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2025-01-01 03:00\",\"to\":\"2025-01-19 13:03\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(20,'2025-08-08 02:40:22','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-01-01 03:00\",\"to\":\"2025-01-19 13:03\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(21,'2025-08-08 02:40:31','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"trips\",\"from\":\"2025-01-01 03:00\",\"to\":\"2025-01-19 13:03\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(22,'2025-08-08 02:40:35','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-01-11 15:12\",\"to\":\"2025-01-11 15:15\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(23,'2025-08-08 02:41:09','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-01-11 15:15\",\"to\":\"2025-01-11 15:16\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(24,'2025-08-08 02:41:12','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-01-11 15:12\",\"to\":\"2025-01-11 15:15\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(25,'2025-08-08 02:58:21','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2025-01-01 03:00\",\"to\":\"2025-01-19 13:03\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(26,'2025-08-08 03:52:22','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(27,'2025-08-08 03:52:32','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(28,'2025-08-08 04:00:41','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(29,'2025-08-08 04:00:50','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"trips\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(30,'2025-08-08 04:00:51','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-07-19 15:11\",\"to\":\"2025-07-19 15:13\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(31,'2025-08-08 04:00:54','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-07-19 15:13\",\"to\":\"2025-07-19 15:17\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(32,'2025-08-08 04:00:57','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-07-19 15:17\",\"to\":\"2025-07-19 15:20\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(33,'2025-08-08 04:01:10','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"combined\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(34,'2025-08-08 04:03:22','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"route\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(35,'2025-08-08 04:03:30','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"trips\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(36,'2025-08-08 04:04:15','154.20.209.4',1,'report',NULL,NULL,'{\"type\":\"events\",\"from\":\"2025-07-01 03:00\",\"to\":\"2025-08-01 02:59\",\"devices\":\"[4]\",\"groups\":\"[]\"}'),(37,'2025-08-08 13:45:09','192.168.14.1',1,'login',NULL,NULL,'{}');
/*!40000 ALTER TABLE `tc_actions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-08  9:20:00
