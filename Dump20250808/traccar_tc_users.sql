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
-- Table structure for table `tc_users`
--

DROP TABLE IF EXISTS `tc_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tc_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `hashedpassword` varchar(128) DEFAULT NULL,
  `salt` varchar(128) DEFAULT NULL,
  `readonly` bit(1) NOT NULL DEFAULT b'0',
  `administrator` bit(1) DEFAULT NULL,
  `map` varchar(128) DEFAULT NULL,
  `latitude` double NOT NULL DEFAULT 0,
  `longitude` double NOT NULL DEFAULT 0,
  `zoom` int(11) NOT NULL DEFAULT 0,
  `attributes` varchar(4000) DEFAULT NULL,
  `coordinateformat` varchar(128) DEFAULT NULL,
  `disabled` bit(1) DEFAULT b'0',
  `expirationtime` timestamp NULL DEFAULT NULL,
  `devicelimit` int(11) DEFAULT -1,
  `userlimit` int(11) DEFAULT 0,
  `devicereadonly` bit(1) DEFAULT b'0',
  `phone` varchar(128) DEFAULT NULL,
  `limitcommands` bit(1) DEFAULT b'0',
  `login` varchar(128) DEFAULT NULL,
  `poilayer` varchar(512) DEFAULT NULL,
  `disablereports` bit(1) DEFAULT b'0',
  `fixedemail` bit(1) DEFAULT b'0',
  `totpkey` varchar(64) DEFAULT NULL,
  `temporary` bit(1) DEFAULT b'0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_users_email` (`email`),
  KEY `idx_users_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tc_users`
--

LOCK TABLES `tc_users` WRITE;
/*!40000 ALTER TABLE `tc_users` DISABLE KEYS */;
INSERT INTO `tc_users` VALUES (1,'Philippe Eveleigh','trac@cognoquest.com','f0d4cc95ddd10d62cb4e5b3c3981f1500099b4b66452e74e','04393ef220577db752d73f6e88682ceab4b041880980ae47',_binary '\0',_binary '',NULL,0,0,0,'{\"notificationTokens\":\"fpv3juIEQAGuA9aNPPz3Ib:APA91bHCjaOnE3INvRrhd97VkyGkC3-q_mOadkOUtx_SBQcTUWC5HFTzgcJYDAMSxXuICa75zTbhEDRf5JtTrDAW4qHItQUm9HtvXHow56wmWzzH2Iejus3hGwSIiFUska4iANPTk5zB\",\"speedUnit\":\"kmh\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(3,'Cedric Eveleigh','cedric@bikelanesweeper.com','b4b0949adda8aa4be1d28eda08dd06a32c0d274fc19a0a58','e55d4595865a86bb2b15783b6ebe37e8cdaa3872478eb567',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"kmh\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(6,'Island Pathways','admin@islandpathways.ca','1fb3c1920217f99931ef4c1f9e5b7b7ca615c94551e73f61','3489e39c180795b6ff2b8ca9a59797406e32ca11e7eaedd9',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"kmh\",\"timezone\":\"Etc/GMT-7\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(7,'City of Penticton','scott.boyko@penticton.ca','a21adf69122159ef033b4ac156fc1783c09552d941921860','2fda907f535fbac37fb8c4e091701c7e8cb0968fc3af1ffe',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"kmh\",\"timezone\":\"Etc/GMT-7\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(8,'Oaks & Spokes','jared@oaksandspokes.com','2df28d28bbaa283af68970c96051597262f989464a0e8054','998ea14a38a412866d3b70402d3de6ff1f6ee42cafc04723',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\",\"timezone\":\"Etc/GMT-4\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(9,'Devou Good Foundation','jodylrobinson41073@gmail.com','846759ce31a18be689b618802606f7b773c763bbf0f3dbeb','645c04d74aca16e1c7d5f45b1acc2ba8de5410e340e048e6',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(10,'Pierre Lermant','pierre@bikelanesweeper.com','bd91cdcc0578a31ce201c268f304ea921e24bafcef28764c','c07d950c5dbff5c595aa4a620c7c4e837e9416015faa6e74',_binary '\0',_binary '',NULL,43.012759,-101.180302,4,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(11,'Kyle Sullivan','kyle@sosufamily.net','73145723aa937684aaea3fb7c96aef81a7126a4fc0267f3e','8fcc9ea1f822308bc6fe9f3d6ed59eca29d5227ac59e008c',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\",\"timezone\":\"America/Los_Angeles\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(12,'Ben DeJarnette','ben@bikethegorge.org','b83d8a18aaacd591050b1499b8d51d8537b8e5e54a52df09','116d2a94c662df3eb8686bf9ec8606c344f90c13e77b6688',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\",\"timezone\":\"America/Los_Angeles\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(13,'Steve Smith','copmatcinvolunteer@gmail.com','f737b49759bb389de60d6f3340a68c796f2a4e2de8a2f3ba','8a8b9b3c63661d357b13c2f4987382ac19bdd8fc73d25abb',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\",\"timezone\":\"America/Los_Angeles\",\"mapboxAccessToken\":\"\",\"activeMapStyles\":\",locationIqStreets,osm,openTopoMap,carto,googleSatellite\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(14,'Town of Carrboro','sblank@carrboronc.gov','7e29284e4b0ac01080490707cb35a0e0d6b6f5519466aa9c','f5cdb09298bba0b5a02881c87ed896d4462059c1e77f60a7',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\",\"timezone\":\"Etc/GMT-4\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(15,'BikeLoud PDX','kielij@gmail.com','40d8cba5f5f5ff146c8cbcc94ee20522dcaeea38dbc8589e','5210a2f7e680a610394bfd0efb620f4340ae39325d6beb83',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\",\"timezone\":\"Etc/GMT-7\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0'),(16,'Tim Scudder','timothy@scudder.net','790ae32787d868666f53dcd72dab60dc34bd19c6c652c4a9','665c431e266ed6e5a6382d6ad88f93ac62b8cc77cc2e2456',_binary '\0',_binary '\0',NULL,0,0,0,'{\"speedUnit\":\"mph\",\"distanceUnit\":\"mi\",\"altitudeUnit\":\"ft\",\"volumeUnit\":\"usGal\",\"timezone\":\"Etc/GMT-7\"}',NULL,_binary '\0',NULL,-1,0,_binary '\0',NULL,_binary '\0',NULL,NULL,_binary '\0',_binary '\0',NULL,_binary '\0');
/*!40000 ALTER TABLE `tc_users` ENABLE KEYS */;
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
