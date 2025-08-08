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
-- Table structure for table `tc_user_device`
--

DROP TABLE IF EXISTS `tc_user_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tc_user_device` (
  `userid` int(11) NOT NULL,
  `deviceid` int(11) NOT NULL,
  KEY `fk_user_device_deviceid` (`deviceid`),
  KEY `user_device_user_id` (`userid`),
  CONSTRAINT `fk_user_device_deviceid` FOREIGN KEY (`deviceid`) REFERENCES `tc_devices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_device_userid` FOREIGN KEY (`userid`) REFERENCES `tc_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tc_user_device`
--

LOCK TABLES `tc_user_device` WRITE;
/*!40000 ALTER TABLE `tc_user_device` DISABLE KEYS */;
INSERT INTO `tc_user_device` VALUES (1,2),(1,3),(1,4),(3,4),(1,6),(1,7),(6,7),(7,6),(1,10),(1,11),(8,10),(9,11),(1,12),(9,12),(1,13),(10,4),(10,6),(10,7),(10,10),(10,11),(10,12),(1,14),(11,14),(1,15),(1,16),(10,14),(10,15),(10,16),(13,15),(12,16),(1,17),(10,17),(1,18),(14,18),(10,18),(1,19),(1,21),(16,21),(10,21);
/*!40000 ALTER TABLE `tc_user_device` ENABLE KEYS */;
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
