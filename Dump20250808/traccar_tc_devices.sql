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
-- Table structure for table `tc_devices`
--

DROP TABLE IF EXISTS `tc_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tc_devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `uniqueid` varchar(128) NOT NULL,
  `lastupdate` timestamp NULL DEFAULT NULL,
  `positionid` int(11) DEFAULT NULL,
  `groupid` int(11) DEFAULT NULL,
  `attributes` varchar(4000) DEFAULT NULL,
  `phone` varchar(128) DEFAULT NULL,
  `model` varchar(128) DEFAULT NULL,
  `contact` varchar(512) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `disabled` bit(1) DEFAULT b'0',
  `status` char(8) DEFAULT NULL,
  `expirationtime` timestamp NULL DEFAULT NULL,
  `motionstate` bit(1) DEFAULT b'0',
  `motiontime` timestamp NULL DEFAULT NULL,
  `motiondistance` double DEFAULT 0,
  `overspeedstate` bit(1) DEFAULT b'0',
  `overspeedtime` timestamp NULL DEFAULT NULL,
  `overspeedgeofenceid` int(11) DEFAULT 0,
  `motionstreak` bit(1) DEFAULT b'0',
  `calendarid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueid` (`uniqueid`),
  KEY `fk_devices_groupid` (`groupid`),
  KEY `idx_devices_uniqueid` (`uniqueid`),
  KEY `fk_devices_calendarid` (`calendarid`),
  CONSTRAINT `fk_devices_calendarid` FOREIGN KEY (`calendarid`) REFERENCES `tc_calendars` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_devices_groupid` FOREIGN KEY (`groupid`) REFERENCES `tc_groups` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tc_devices`
--

LOCK TABLES `tc_devices` WRITE;
/*!40000 ALTER TABLE `tc_devices` DISABLE KEYS */;
INSERT INTO `tc_devices` VALUES (2,'Philippe iPad','355820081806079','2025-01-18 20:48:45',4568,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0',NULL,0,_binary '\0',NULL,0,_binary '\0',NULL),(3,'Philippe Test1','Philippe-Test1','2024-10-29 01:36:21',3401,NULL,'{\"speedLimit\":15}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0','2024-10-14 20:41:09',65312.36833690763,_binary '\0',NULL,NULL,_binary '',NULL),(4,'Push-Aside V3, S24B000002','S24B000002','2025-08-07 18:02:02',65713,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '',NULL,0,_binary '\0',NULL,0,_binary '',NULL),(6,'Sweeper 1, City of Penticton, H24B000002','H24B000002','2024-10-09 01:21:54',3115,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '',NULL,0,_binary '\0',NULL,0,_binary '',NULL),(7,'Sweeper 1, Island Pathways (Salt Spring Island), H24A000001','H24A000001','2025-07-10 00:20:06',44684,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '',NULL,0,_binary '\0',NULL,0,_binary '',NULL),(10,'Sweeper 1, Oaks & Spokes (Raleigh), H24D000004','H24D000004','2025-05-25 21:19:24',20418,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '',NULL,0,_binary '\0',NULL,0,_binary '',NULL),(11,'Sweeper 1, Devou Good Foundation (Bellevue), H24D000005','H24D000005','2025-04-17 04:30:51',8990,NULL,'{}',NULL,NULL,NULL,'default',_binary '\0','offline',NULL,_binary '',NULL,0,_binary '\0',NULL,0,_binary '',NULL),(12,'Sweeper 2, Devou Good Foundation (Bellevue), H24D000006','H24D000006',NULL,NULL,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0',NULL,0,_binary '\0',NULL,0,_binary '\0',NULL),(13,'Cedric\'s phone','677354','2025-01-18 21:13:14',4570,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0',NULL,0,_binary '\0',NULL,0,_binary '\0',NULL),(14,'Sweeper 1, Kyle Sullivan, H25A000008','H25A000008','2025-07-03 02:42:48',44431,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0',NULL,0,_binary '\0',NULL,0,_binary '\0',NULL),(15,'Sweeper 1, Steve Smith, H25A000009','H25A000009','2025-08-04 01:21:49',61750,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '',NULL,0,_binary '\0',NULL,0,_binary '',NULL),(16,'Sweeper 1, Bike the Gorge, H25A000007','H25A000007','2025-08-05 02:16:05',65115,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0',NULL,0,_binary '\0',NULL,0,_binary '\0',NULL),(17,'Sweeper 1, Bike Lane Sweeper (Sunnyvale), H25A000010','H25A000010','2025-07-21 03:02:28',52165,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0','2025-07-21 03:02:28',1518650.985446337,_binary '\0',NULL,0,_binary '',NULL),(18,'Sweeper 1, Town of Carrboro, H-007-00011','H-007-00011','2025-08-01 18:16:59',56929,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0',NULL,0,_binary '\0',NULL,0,_binary '\0',NULL),(19,'Sweeper 2, BikeLoud PDX, S-003-00003','S-003-00003','2025-08-03 04:53:50',60313,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '\0',NULL,0,_binary '\0',NULL,0,_binary '\0',NULL),(21,'Sweeper 1, Tim Scudder, S-003-00004','S-003-00004','2025-08-08 02:55:06',65826,NULL,'{}',NULL,NULL,NULL,NULL,_binary '\0','offline',NULL,_binary '','2025-08-08 02:55:06',70799.33411969556,_binary '\0',NULL,0,_binary '\0',NULL);
/*!40000 ALTER TABLE `tc_devices` ENABLE KEYS */;
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
