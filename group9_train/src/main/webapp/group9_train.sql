-- MySQL dump 10.13  Distrib 8.0.40, for macos14 (arm64)
--
-- Host: localhost    Database: group9_train
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES (2,'Mayank','S','mayanks928@gmail.com','mayanks928','7NcYcNGWMxapfjrDQIyYNa2M8PPBvHA1J8MCZVNPda4=');
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employee` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `ssn` varchar(9) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `role` enum('Admin','CustomerRepresentative') NOT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `ssn` (`ssn`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee`
--

LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */;
INSERT INTO `Employee` VALUES (1,'123456789','admin','admin','Mayank','S','Admin'),(5,'345678912','peter','parker','Peter','Parker','CustomerRepresentative'),(7,'111111111','newcr','newcr','new','cr','CustomerRepresentative');
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Message`
--

DROP TABLE IF EXISTS `Message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Message` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL,
  `message_dateTime` datetime NOT NULL,
  `isCustomer` tinyint(1) NOT NULL,
  `session_id` int NOT NULL,
  PRIMARY KEY (`message_id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `Session` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Message`
--

LOCK TABLES `Message` WRITE;
/*!40000 ALTER TABLE `Message` DISABLE KEYS */;
/*!40000 ALTER TABLE `Message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservation`
--

DROP TABLE IF EXISTS `Reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservation` (
  `reservation_no` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  `payment_mode` varchar(20) NOT NULL,
  `reservedAt` datetime NOT NULL,
  `departure_from` int NOT NULL,
  `destination_at` int NOT NULL,
  `reservedForTransit` int NOT NULL,
  `isCancelled` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`reservation_no`),
  KEY `departure_from` (`departure_from`),
  KEY `destination_at` (`destination_at`),
  KEY `customer_id` (`customer_id`),
  KEY `reservedForTransit` (`reservedForTransit`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`departure_from`) REFERENCES `Station` (`station_id`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`destination_at`) REFERENCES `Station` (`station_id`),
  CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`),
  CONSTRAINT `reservation_ibfk_4` FOREIGN KEY (`reservedForTransit`) REFERENCES `Transit_Line` (`transit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservation`
--

LOCK TABLES `Reservation` WRITE;
/*!40000 ALTER TABLE `Reservation` DISABLE KEYS */;
INSERT INTO `Reservation` VALUES (1,2,5.60,'Paypal','2024-12-06 22:02:55',18,17,6,0),(2,2,52.33,'Debit Card','2024-12-06 22:07:36',41,15,3,0),(3,2,29.70,'Credit Card','2024-12-06 22:12:57',9,13,1,0),(4,2,9.00,'Credit Card','2024-12-06 22:15:44',9,13,1,1);
/*!40000 ALTER TABLE `Reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Session`
--

DROP TABLE IF EXISTS `Session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Session` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `relatedToReservation` int NOT NULL,
  `startDateTime` datetime NOT NULL,
  `endDateTime` datetime DEFAULT NULL,
  `resolutionStatus` tinyint(1) NOT NULL,
  `employeeSSN` varchar(9) NOT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employeeSSN` (`employeeSSN`),
  KEY `relatedToReservation` (`relatedToReservation`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`),
  CONSTRAINT `session_ibfk_2` FOREIGN KEY (`employeeSSN`) REFERENCES `Employee` (`ssn`),
  CONSTRAINT `session_ibfk_3` FOREIGN KEY (`relatedToReservation`) REFERENCES `Reservation` (`reservation_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session`
--

LOCK TABLES `Session` WRITE;
/*!40000 ALTER TABLE `Session` DISABLE KEYS */;
/*!40000 ALTER TABLE `Session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Station`
--

DROP TABLE IF EXISTS `Station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Station` (
  `station_id` int NOT NULL AUTO_INCREMENT,
  `station_name` varchar(50) NOT NULL,
  `city` varchar(30) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `station_name` (`station_name`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Station`
--

LOCK TABLES `Station` WRITE;
/*!40000 ALTER TABLE `Station` DISABLE KEYS */;
INSERT INTO `Station` VALUES (1,'Trenton Transit Center','Trenton','NJ'),(2,'Princeton Junction','West Windsor Township','NJ'),(3,'New Brunswick','New Brunswick','NJ'),(4,'Edison','Edison','NJ'),(5,'Newark Int’l Airport','Newark','NJ'),(6,'Newark Penn Station','Newark','NJ'),(7,'World Trade Center','New York','NY'),(8,'New York Penn Station','New York','NY'),(9,'ATLANTIC CITY','Atlantic City','NJ'),(10,'Lindenwold','Lindenwold','NJ'),(11,'Camden Transit Center-Broadway','Camden','NJ'),(12,'Cherry Hill','Cherry Hill','NJ'),(13,'Pennsauken Transit Center','Pennsauken','NJ'),(14,'PHILADELPHIA-30TH STREET','Philadelphia','PA'),(15,'NEW YORK','New York','NY'),(16,'Middletown','Middletown','NJ'),(17,'Long Branch','Long Branch','NJ'),(18,'Bradley Beach','Bradley Beach','NJ'),(19,'Manasquan','Manasquan','NJ'),(20,'Point Pleasant Beach','Point Pleasant Beach','NJ'),(21,'BAY HEAD','Bay Head','NJ'),(29,'Port Jervis','Port Jervis','NY'),(30,'Campbell Hall','Campbell Hall','NY'),(31,'Salisbury Mills','Salisbury Mills','NY'),(32,'Harriman','Harriman','NY'),(33,'Tuxedo','Tuxedo','NY'),(34,'Sloatsburg','Sloatsburg','NY'),(35,'Ridgewood','Ridgewood','NJ'),(36,'Paterson','Paterson','NJ'),(37,'Clifton','Clifton','NJ'),(38,'Lyndhurst','Lyndhurst','NJ'),(39,'Kingsland','Lyndhurst','NJ'),(40,'Mount Olive','Mount Olive','NJ'),(41,'Denville','Denville','NJ'),(42,'Mountain View','Mountain View','NJ'),(43,'MONTCLAIR STATE UNIV','Montclair','NJ'),(44,'Bay Street','Montclair','NJ'),(45,'Newark Broad Street','Newark','NJ'),(46,'HOBOKEN','Hoboken','NJ'),(73,'HIGH BRIDGE','High Bridge','NJ'),(74,'White House','White House Station','NJ'),(75,'RARITAN','Raritan','NJ'),(76,'Plainfield','Plainfield','NJ'),(77,'Westfield','Westfield','NJ'),(78,'Secaucus Junction','Secaucus','NJ'),(90,'Hackettstown','Hackettstown','NJ'),(91,'Dover','Dover','NJ'),(92,'Convent Station','Convent Station','NJ'),(93,'Far Hills','Far Hills','NJ'),(94,'Stirling','Stirling','NJ'),(95,'Summit','Summit','NJ'),(96,'South Orange','South Orange','NJ');
/*!40000 ALTER TABLE `Station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ticket`
--

DROP TABLE IF EXISTS `Ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ticket` (
  `reservation_no` int NOT NULL,
  `ticket_no` int NOT NULL,
  `fare` decimal(5,2) NOT NULL,
  `ticketType` enum('Regular','Child','Senior') NOT NULL,
  `activatedAt` datetime DEFAULT NULL,
  `isExpired` tinyint(1) NOT NULL,
  `isReturn` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`reservation_no`,`ticket_no`),
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`reservation_no`) REFERENCES `Reservation` (`reservation_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ticket`
--

LOCK TABLES `Ticket` WRITE;
/*!40000 ALTER TABLE `Ticket` DISABLE KEYS */;
INSERT INTO `Ticket` VALUES (1,1,1.60,'Senior',NULL,0,0),(1,2,1.60,'Senior',NULL,0,1),(1,3,1.20,'Child',NULL,0,0),(1,4,1.20,'Child',NULL,0,1),(2,1,6.83,'Child',NULL,0,0),(2,2,22.75,'Regular',NULL,0,0),(2,3,22.75,'Regular',NULL,0,1),(3,1,9.00,'Regular',NULL,0,0),(3,2,9.00,'Regular',NULL,0,0),(3,3,9.00,'Regular',NULL,0,1),(3,4,2.70,'Child',NULL,0,0),(4,1,9.00,'Regular',NULL,0,0);
/*!40000 ALTER TABLE `Ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Train`
--

DROP TABLE IF EXISTS `Train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Train` (
  `train_number` int NOT NULL,
  `isExpress` tinyint(1) NOT NULL,
  `directionToEnd` tinyint(1) NOT NULL,
  `transit_id` int NOT NULL,
  `start_time` time NOT NULL,
  PRIMARY KEY (`train_number`),
  KEY `transit_id` (`transit_id`),
  CONSTRAINT `train_ibfk_1` FOREIGN KEY (`transit_id`) REFERENCES `Transit_Line` (`transit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Train`
--

LOCK TABLES `Train` WRITE;
/*!40000 ALTER TABLE `Train` DISABLE KEYS */;
INSERT INTO `Train` VALUES (100,1,1,1,'00:18:00'),(104,0,0,1,'00:27:00'),(108,0,1,1,'00:42:00'),(112,0,1,1,'00:50:00'),(113,1,1,1,'00:51:00'),(114,0,1,1,'05:16:00'),(117,0,0,1,'05:30:00'),(118,1,1,1,'05:38:00'),(122,0,0,1,'07:01:00'),(127,0,0,1,'08:30:00'),(128,0,1,1,'08:38:00'),(132,0,0,1,'09:14:00'),(138,0,1,1,'10:08:00'),(139,0,1,1,'10:21:00'),(140,0,0,1,'10:28:00'),(141,0,0,1,'11:16:00'),(143,1,0,1,'11:28:00'),(144,0,1,1,'11:29:00'),(148,0,1,1,'12:12:00'),(149,0,1,1,'12:28:00'),(150,0,0,1,'12:36:00'),(153,0,1,1,'12:56:00'),(157,1,1,1,'14:39:00'),(158,1,0,1,'15:22:00'),(159,0,0,1,'15:41:00'),(162,0,1,1,'16:20:00'),(163,0,0,1,'16:41:00'),(164,0,0,1,'16:45:00'),(165,0,1,1,'17:28:00'),(168,0,1,1,'17:43:00'),(169,0,1,1,'18:01:00'),(170,0,1,1,'18:10:00'),(171,0,0,1,'18:24:00'),(172,1,1,1,'18:29:00'),(176,0,1,1,'19:09:00'),(177,0,1,1,'19:29:00'),(179,1,0,1,'19:34:00'),(180,0,1,1,'19:48:00'),(182,1,1,1,'20:10:00'),(183,0,0,1,'20:17:00'),(184,0,0,1,'20:20:00'),(186,0,1,1,'21:10:00'),(188,0,0,1,'21:54:00'),(191,1,1,1,'21:55:00'),(192,1,0,1,'22:16:00'),(194,0,0,1,'22:22:00'),(196,1,1,1,'22:39:00'),(197,0,0,1,'22:58:00'),(198,0,0,1,'23:08:00'),(199,0,1,1,'23:15:00'),(200,0,0,2,'00:17:00'),(201,0,1,2,'00:19:00'),(202,0,1,2,'00:34:00'),(203,0,1,2,'00:46:00'),(204,0,0,2,'00:46:00'),(206,1,0,2,'00:51:00'),(207,0,0,2,'00:54:00'),(211,0,1,2,'05:21:00'),(214,0,1,2,'06:05:00'),(217,0,0,2,'06:06:00'),(218,0,1,2,'07:25:00'),(222,0,0,2,'08:31:00'),(223,1,1,2,'09:37:00'),(224,0,1,2,'09:47:00'),(226,1,1,2,'09:52:00'),(227,0,0,2,'10:19:00'),(233,1,1,2,'11:40:00'),(235,0,1,2,'11:47:00'),(236,0,1,2,'12:47:00'),(237,0,1,2,'13:47:00'),(243,0,0,2,'13:47:00'),(244,0,0,2,'14:00:00'),(247,0,1,2,'14:26:00'),(250,0,0,2,'14:37:00'),(252,0,0,2,'15:14:00'),(254,0,0,2,'15:43:00'),(255,0,1,2,'16:22:00'),(256,0,1,2,'16:57:00'),(257,0,1,2,'17:09:00'),(261,0,1,2,'17:36:00'),(262,1,1,2,'17:36:00'),(264,0,0,2,'17:41:00'),(265,0,1,2,'17:49:00'),(266,0,1,2,'19:04:00'),(267,0,1,2,'19:39:00'),(268,0,1,2,'20:08:00'),(269,0,1,2,'20:19:00'),(270,0,1,2,'20:22:00'),(272,0,1,2,'20:36:00'),(273,0,0,2,'20:37:00'),(276,1,1,2,'20:56:00'),(278,1,0,2,'21:00:00'),(279,0,0,2,'21:07:00'),(280,1,1,2,'21:54:00'),(283,1,0,2,'21:56:00'),(284,0,1,2,'21:59:00'),(286,0,1,2,'22:04:00'),(289,0,0,2,'23:27:00'),(290,0,0,2,'23:41:00'),(291,1,0,2,'23:51:00'),(300,1,0,3,'00:00:00'),(304,1,1,3,'00:15:00'),(307,1,0,3,'00:16:00'),(310,1,0,3,'00:17:00'),(313,0,1,3,'00:23:00'),(318,0,1,3,'00:49:00'),(325,0,0,3,'05:11:00'),(326,1,0,3,'05:20:00'),(328,1,1,3,'05:26:00'),(329,0,0,3,'05:51:00'),(332,0,1,3,'06:32:00'),(334,0,1,3,'06:44:00'),(335,1,1,3,'08:48:00'),(336,1,0,3,'08:54:00'),(337,0,1,3,'09:51:00'),(340,0,1,3,'10:07:00'),(341,0,0,3,'10:46:00'),(343,0,1,3,'11:21:00'),(345,1,1,3,'11:27:00'),(347,1,0,3,'11:51:00'),(349,1,0,3,'12:23:00'),(351,0,1,3,'12:35:00'),(355,0,0,3,'12:39:00'),(356,0,0,3,'13:06:00'),(359,1,0,3,'13:15:00'),(362,0,1,3,'13:49:00'),(364,0,0,3,'14:27:00'),(365,0,0,3,'14:38:00'),(367,0,1,3,'15:31:00'),(369,0,0,3,'15:46:00'),(370,0,1,3,'16:13:00'),(371,1,0,3,'16:27:00'),(373,0,0,3,'16:30:00'),(374,0,1,3,'17:06:00'),(375,0,0,3,'17:18:00'),(379,0,1,3,'17:26:00'),(380,1,1,3,'17:30:00'),(382,0,0,3,'18:06:00'),(383,0,0,3,'18:21:00'),(384,0,1,3,'18:54:00'),(385,0,1,3,'19:23:00'),(387,0,0,3,'19:28:00'),(388,1,1,3,'19:33:00'),(389,0,0,3,'19:56:00'),(390,1,0,3,'20:01:00'),(391,0,1,3,'20:07:00'),(392,0,1,3,'21:44:00'),(393,0,0,3,'22:19:00'),(398,0,0,3,'22:22:00'),(399,0,1,3,'22:36:00'),(401,0,0,4,'00:11:00'),(402,0,1,4,'00:12:00'),(404,0,1,4,'00:14:00'),(406,0,1,4,'00:17:00'),(409,0,0,4,'00:19:00'),(410,1,1,4,'00:27:00'),(412,1,1,4,'00:28:00'),(414,0,1,4,'00:37:00'),(415,0,0,4,'00:37:00'),(418,0,1,4,'00:40:00'),(419,0,1,4,'00:48:00'),(423,0,1,4,'00:51:00'),(424,0,0,4,'05:07:00'),(425,0,0,4,'05:45:00'),(431,0,0,4,'05:54:00'),(433,1,0,4,'06:21:00'),(436,1,1,4,'06:30:00'),(438,0,0,4,'07:07:00'),(439,0,0,4,'08:24:00'),(442,0,0,4,'09:38:00'),(443,1,0,4,'09:43:00'),(444,0,1,4,'09:48:00'),(445,0,0,4,'10:15:00'),(446,1,1,4,'10:17:00'),(449,0,0,4,'11:21:00'),(454,0,0,4,'11:25:00'),(455,0,1,4,'11:34:00'),(458,0,0,4,'11:39:00'),(459,0,0,4,'11:48:00'),(460,0,0,4,'12:20:00'),(461,0,1,4,'12:51:00'),(464,0,1,4,'14:07:00'),(465,1,1,4,'14:25:00'),(466,0,0,4,'15:35:00'),(467,0,0,4,'15:38:00'),(469,0,0,4,'16:15:00'),(473,1,0,4,'17:07:00'),(475,1,1,4,'17:34:00'),(477,0,1,4,'18:13:00'),(479,0,1,4,'18:16:00'),(480,0,1,4,'18:49:00'),(482,1,0,4,'19:19:00'),(483,1,0,4,'21:24:00'),(484,0,0,4,'21:53:00'),(488,0,1,4,'21:56:00'),(491,0,1,4,'22:07:00'),(493,1,1,4,'22:18:00'),(494,0,1,4,'22:30:00'),(497,1,0,4,'22:52:00'),(498,1,1,4,'23:21:00'),(504,0,0,5,'00:00:00'),(506,1,0,5,'00:19:00'),(509,0,0,5,'00:27:00'),(511,0,0,5,'00:28:00'),(512,0,0,5,'00:30:00'),(513,1,1,5,'00:31:00'),(514,1,1,5,'00:40:00'),(515,0,1,5,'05:50:00'),(517,1,1,5,'06:05:00'),(519,1,1,5,'06:45:00'),(524,1,0,5,'09:58:00'),(525,1,0,5,'10:42:00'),(526,0,0,5,'11:10:00'),(527,0,1,5,'12:05:00'),(530,0,1,5,'12:13:00'),(531,1,1,5,'12:20:00'),(534,0,1,5,'12:26:00'),(536,1,0,5,'12:42:00'),(541,0,0,5,'12:55:00'),(543,0,0,5,'13:48:00'),(544,1,1,5,'13:53:00'),(546,0,1,5,'13:57:00'),(547,0,1,5,'13:57:00'),(548,0,0,5,'13:59:00'),(549,0,0,5,'14:02:00'),(551,0,0,5,'14:03:00'),(552,0,0,5,'14:37:00'),(554,0,1,5,'15:20:00'),(555,0,0,5,'15:30:00'),(556,0,1,5,'15:41:00'),(561,0,1,5,'15:56:00'),(563,0,0,5,'16:56:00'),(564,0,1,5,'17:15:00'),(565,1,0,5,'17:22:00'),(567,0,1,5,'17:32:00'),(568,0,1,5,'17:42:00'),(571,0,1,5,'18:00:00'),(575,0,0,5,'18:20:00'),(578,0,0,5,'18:55:00'),(580,0,1,5,'19:07:00'),(582,1,0,5,'19:57:00'),(583,0,1,5,'20:41:00'),(585,1,1,5,'21:05:00'),(586,0,0,5,'21:08:00'),(587,0,1,5,'21:14:00'),(588,0,0,5,'21:23:00'),(589,1,1,5,'21:38:00'),(593,0,0,5,'22:33:00'),(594,0,1,5,'23:22:00'),(595,0,1,5,'23:52:00'),(600,0,1,6,'00:25:00'),(601,0,0,6,'00:37:00'),(602,0,1,6,'00:49:00'),(603,1,1,6,'00:49:00'),(605,0,1,6,'00:50:00'),(606,1,1,6,'05:00:00'),(607,1,0,6,'05:27:00'),(608,1,0,6,'05:55:00'),(610,1,1,6,'06:30:00'),(611,0,1,6,'06:32:00'),(616,0,0,6,'07:27:00'),(619,1,0,6,'07:38:00'),(620,0,0,6,'07:48:00'),(621,0,0,6,'08:17:00'),(624,0,0,6,'09:02:00'),(625,1,0,6,'09:35:00'),(628,0,0,6,'10:44:00'),(629,0,1,6,'10:46:00'),(634,0,1,6,'11:11:00'),(635,1,0,6,'11:17:00'),(636,0,0,6,'11:19:00'),(638,0,1,6,'12:33:00'),(641,0,1,6,'12:52:00'),(644,1,1,6,'12:55:00'),(649,0,1,6,'12:58:00'),(650,1,0,6,'13:08:00'),(653,0,0,6,'13:17:00'),(654,0,1,6,'13:41:00'),(657,0,0,6,'13:43:00'),(658,0,1,6,'14:10:00'),(659,0,0,6,'15:07:00'),(663,0,1,6,'16:30:00'),(666,0,1,6,'16:57:00'),(668,1,0,6,'17:26:00'),(673,0,0,6,'17:38:00'),(674,0,1,6,'17:58:00'),(675,1,0,6,'18:15:00'),(677,1,1,6,'18:16:00'),(681,1,1,6,'18:19:00'),(682,1,1,6,'18:35:00'),(685,0,0,6,'19:14:00'),(687,0,0,6,'19:52:00'),(688,1,0,6,'20:32:00'),(689,0,1,6,'21:15:00'),(690,0,1,6,'21:49:00'),(691,0,1,6,'22:37:00'),(696,0,0,6,'22:49:00'),(697,0,1,6,'23:05:00'),(698,0,0,6,'23:13:00'),(699,1,0,6,'23:24:00'),(702,0,0,7,'00:03:00'),(703,0,1,7,'00:08:00'),(708,1,0,7,'00:15:00'),(709,0,0,7,'00:22:00'),(711,1,1,7,'00:32:00'),(716,0,1,7,'00:44:00'),(718,1,0,7,'00:49:00'),(721,0,1,7,'00:54:00'),(723,0,0,7,'05:02:00'),(724,0,0,7,'05:19:00'),(725,0,0,7,'05:24:00'),(726,0,0,7,'06:01:00'),(729,0,0,7,'06:32:00'),(730,0,0,7,'06:38:00'),(731,0,0,7,'06:59:00'),(733,0,0,7,'07:12:00'),(734,0,1,7,'08:11:00'),(735,0,1,7,'08:32:00'),(736,0,0,7,'08:45:00'),(738,0,1,7,'09:44:00'),(739,0,0,7,'10:13:00'),(740,0,1,7,'10:36:00'),(745,0,1,7,'10:51:00'),(747,0,1,7,'10:52:00'),(748,1,1,7,'11:19:00'),(749,0,0,7,'11:26:00'),(751,1,1,7,'11:58:00'),(752,0,1,7,'14:07:00'),(756,0,1,7,'14:15:00'),(758,0,0,7,'14:57:00'),(759,0,0,7,'15:24:00'),(764,0,1,7,'15:25:00'),(765,0,1,7,'15:48:00'),(766,0,0,7,'15:57:00'),(768,1,0,7,'16:41:00'),(769,0,0,7,'17:18:00'),(770,0,0,7,'17:46:00'),(771,0,1,7,'18:02:00'),(773,1,0,7,'18:39:00'),(778,0,1,7,'18:44:00'),(779,0,0,7,'18:49:00'),(780,0,1,7,'18:49:00'),(784,0,1,7,'19:12:00'),(785,0,1,7,'20:09:00'),(788,1,1,7,'21:46:00'),(790,0,1,7,'21:56:00'),(791,0,1,7,'22:04:00'),(792,1,1,7,'22:25:00'),(794,0,1,7,'22:53:00'),(796,0,0,7,'22:59:00');
/*!40000 ALTER TABLE `Train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transit_Line`
--

DROP TABLE IF EXISTS `Transit_Line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transit_Line` (
  `transit_id` int NOT NULL,
  `transit_name` varchar(50) NOT NULL,
  `fare` decimal(4,2) NOT NULL,
  PRIMARY KEY (`transit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transit_Line`
--

LOCK TABLES `Transit_Line` WRITE;
/*!40000 ALTER TABLE `Transit_Line` DISABLE KEYS */;
INSERT INTO `Transit_Line` VALUES (1,'Atlantic City',2.25),(2,'Main/Bergen County',2.00),(3,'Montclair- Boonton',3.25),(4,'Morris & Essex',2.75),(5,'Northeast Corridor',3.00),(6,'North Jersey Coast Line',4.00),(7,'Raritan Valley',2.75);
/*!40000 ALTER TABLE `Transit_Line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transit_Stop`
--

DROP TABLE IF EXISTS `Transit_Stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transit_Stop` (
  `transit_id` int NOT NULL,
  `stop_number` int NOT NULL,
  `station_id` int NOT NULL,
  `local_time_offset` int NOT NULL,
  `express_time_offset` int DEFAULT NULL,
  `isExpressStop` tinyint(1) NOT NULL,
  PRIMARY KEY (`transit_id`,`stop_number`),
  KEY `station_id` (`station_id`),
  CONSTRAINT `transit_stop_ibfk_1` FOREIGN KEY (`transit_id`) REFERENCES `Transit_Line` (`transit_id`),
  CONSTRAINT `transit_stop_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `Station` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transit_Stop`
--

LOCK TABLES `Transit_Stop` WRITE;
/*!40000 ALTER TABLE `Transit_Stop` DISABLE KEYS */;
INSERT INTO `Transit_Stop` VALUES (1,1,9,0,0,1),(1,2,10,8,8,1),(1,3,11,16,16,0),(1,4,12,25,20,1),(1,5,13,31,26,0),(1,6,14,37,27,1),(2,1,29,0,0,1),(2,2,30,8,8,1),(2,3,31,14,14,0),(2,4,32,20,17,1),(2,5,33,27,24,0),(2,6,34,35,28,1),(2,7,35,41,34,0),(2,8,36,48,37,1),(2,9,37,56,45,0),(2,10,38,64,48,1),(2,11,39,70,54,0),(2,12,78,78,62,1),(2,13,46,84,68,1),(2,14,15,92,76,1),(3,1,40,0,0,1),(3,2,41,8,8,1),(3,3,42,14,14,0),(3,4,43,20,17,1),(3,5,44,26,23,0),(3,6,45,34,26,1),(3,7,46,41,33,0),(3,8,78,47,39,1),(3,9,15,53,45,1),(4,1,90,0,0,1),(4,2,91,8,8,1),(4,3,92,16,16,0),(4,4,93,24,20,1),(4,5,94,32,28,0),(4,6,95,40,31,1),(4,7,96,46,37,0),(4,8,45,53,44,1),(4,9,46,62,53,1),(4,10,78,69,60,1),(4,11,15,76,67,1),(5,1,1,0,0,1),(5,2,2,9,9,1),(5,3,3,19,19,0),(5,4,4,25,20,1),(5,5,5,33,28,0),(5,6,6,41,32,1),(5,7,7,48,39,0),(5,8,8,58,46,1),(6,1,15,0,0,1),(6,2,78,8,8,1),(6,3,46,16,16,1),(6,4,16,24,24,1),(6,5,17,31,31,0),(6,6,18,39,36,1),(6,7,19,46,43,0),(6,8,20,53,47,1),(6,9,21,61,55,0),(7,1,73,0,0,1),(7,2,74,8,8,1),(7,3,75,15,15,0),(7,4,76,23,17,1),(7,5,77,30,24,0),(7,6,6,38,26,1),(7,7,78,45,33,1),(7,8,15,51,39,1),(7,9,46,58,46,1);
/*!40000 ALTER TABLE `Transit_Stop` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-07 23:17:29
