-- MySQL dump 10.13  Distrib 5.7.36, for Linux (x86_64)
--
-- Host: localhost    Database: ciss_db
-- ------------------------------------------------------
-- Server version	5.7.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ciss_check_in`
--

DROP TABLE IF EXISTS `ciss_check_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ciss_check_in` (
  `check_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '签到记录唯一id',
  `check_time` datetime NOT NULL COMMENT '签到记录',
  `check_user_id` varchar(40) NOT NULL COMMENT '签到的用户id',
  PRIMARY KEY (`check_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='签到记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciss_check_in`
--

LOCK TABLES `ciss_check_in` WRITE;
/*!40000 ALTER TABLE `ciss_check_in` DISABLE KEYS */;
/*!40000 ALTER TABLE `ciss_check_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `ciss_ip_num_24_hour`
--

DROP TABLE IF EXISTS `ciss_ip_num_24_hour`;
/*!50001 DROP VIEW IF EXISTS `ciss_ip_num_24_hour`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `ciss_ip_num_24_hour` AS SELECT 
 1 AS `visit_ip`,
 1 AS `num`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ciss_ip_visit`
--

DROP TABLE IF EXISTS `ciss_ip_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ciss_ip_visit` (
  `visit_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '访问记录唯一id',
  `visit_time` datetime NOT NULL COMMENT '访问时间',
  `visit_ip` varchar(20) DEFAULT NULL COMMENT 'IP地址',
  PRIMARY KEY (`visit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='IP访问记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciss_ip_visit`
--

LOCK TABLES `ciss_ip_visit` WRITE;
/*!40000 ALTER TABLE `ciss_ip_visit` DISABLE KEYS */;
/*!40000 ALTER TABLE `ciss_ip_visit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ciss_user`
--

DROP TABLE IF EXISTS `ciss_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ciss_user` (
  `user_id` varchar(40) NOT NULL COMMENT '用户唯一id',
  `user_name` varchar(20) NOT NULL COMMENT '用户名',
  `user_passwd` varchar(70) NOT NULL COMMENT '密码',
  `user_last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='账户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciss_user`
--

LOCK TABLES `ciss_user` WRITE;
/*!40000 ALTER TABLE `ciss_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `ciss_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `ciss_ip_num_24_hour`
--

/*!50001 DROP VIEW IF EXISTS `ciss_ip_num_24_hour`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ciss_ip_num_24_hour` AS select `ciss_ip_visit`.`visit_ip` AS `visit_ip`,count(1) AS `num` from `ciss_ip_visit` where (`ciss_ip_visit`.`visit_time` >= (now() - interval 24 hour)) group by `ciss_ip_visit`.`visit_ip` order by `num` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-13 11:42:11
