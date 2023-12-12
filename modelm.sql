-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 12, 2023 at 10:19 AM
-- Server version: 8.0.31
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `modelm`
--

-- --------------------------------------------------------

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
CREATE TABLE IF NOT EXISTS `content` (
  `contentID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `fileType` enum('mp3','mp4') NOT NULL,
  `path` varchar(99) NOT NULL,
  `duration` int DEFAULT NULL,
  PRIMARY KEY (`contentID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `content`
--

INSERT INTO `content` (`contentID`, `name`, `fileType`, `path`, `duration`) VALUES
(1, 'Bakuretsu Bakur', 'mp4', 'videos/Bakuretsu Bakuretsu Bakuretsu - La La La.mp4', 39),
(2, 'bear', 'mp4', 'videos/bear.mp4', 31),
(3, 'earth', 'mp4', 'videos/earth.mp4', 14),
(4, 'gojo vs n', 'mp4', 'videos/gojo vs n.mp4', 134),
(5, 'Hitori no Shita', 'mp4', 'videos/Hitori no Shita - The Outcast 3 - Fight Scene [4K].mp4', 74),
(6, 'Levi vs Kenny F', 'mp4', 'videos/Levi vs Kenny Fight Scene 4k _ Attack On Titan 4k.mp4', 332),
(7, 'Maki vs Miwa an', 'mp4', 'videos/Maki vs Miwa and Mai│Fight Scene│Jujutsu Kaisen Episode 17.mp4', 171),
(8, 'Live Stream', '', '', NULL),
(9, 'ni', 'mp4', 'videos/Bleach is God Tier.mp4', 2748);

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
CREATE TABLE IF NOT EXISTS `log` (
  `histID` int NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `fileID` int NOT NULL,
  `ifLive` enum('live','streamed') NOT NULL,
  PRIMARY KEY (`histID`),
  UNIQUE KEY `fileID` (`fileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `queue`
--

DROP TABLE IF EXISTS `queue`;
CREATE TABLE IF NOT EXISTS `queue` (
  `sched_ID` int NOT NULL AUTO_INCREMENT,
  `content_ID` int NOT NULL,
  `position` int NOT NULL,
  `liveDuration` int DEFAULT NULL,
  PRIMARY KEY (`sched_ID`),
  KEY `content` (`content_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `queue`
--

INSERT INTO `queue` (`sched_ID`, `content_ID`, `position`, `liveDuration`) VALUES
(46, 7, 1, NULL),
(47, 4, 2, NULL),
(48, 5, 3, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `record`
--

DROP TABLE IF EXISTS `record`;
CREATE TABLE IF NOT EXISTS `record` (
  `fileID` int NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`fileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `start_end_time`
--

DROP TABLE IF EXISTS `start_end_time`;
CREATE TABLE IF NOT EXISTS `start_end_time` (
  `startTime` time NOT NULL,
  `endTime` time NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `start_end_time`
--

INSERT INTO `start_end_time` (`startTime`, `endTime`) VALUES
('18:08:00', '18:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `role` enum('Manager','Admin') NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`, `fname`, `lname`, `role`) VALUES
('a', 'a', 'a', 'a', 'Manager'),
('admin', 'admin', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `user_logs`
--

DROP TABLE IF EXISTS `user_logs`;
CREATE TABLE IF NOT EXISTS `user_logs` (
  `session_id` varchar(50) NOT NULL,
  `username` varchar(100) NOT NULL,
  `login_time` timestamp NOT NULL,
  `logout_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_logs`
--

INSERT INTO `user_logs` (`session_id`, `username`, `login_time`, `logout_time`) VALUES
('65781ae998e89', 'a', '2023-12-12 08:33:45', '2023-12-12 08:34:00'),
('65781b89bb869', 'a', '2023-12-12 08:36:25', '2023-12-12 08:36:55'),
('65781bc48d988', 'a', '2023-12-12 08:37:24', '2023-12-12 08:37:31'),
('65782a416ddbc', 'a', '2023-12-12 09:39:13', '2023-12-12 09:40:07'),
('65782ab94f572', 'a', '2023-12-12 09:41:13', '2023-12-12 10:06:32'),
('657830af3ef7a', 'a', '2023-12-12 10:06:39', NULL);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `log`
--
ALTER TABLE `log`
  ADD CONSTRAINT `fileid` FOREIGN KEY (`fileID`) REFERENCES `record` (`fileID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `queue`
--
ALTER TABLE `queue`
  ADD CONSTRAINT `content` FOREIGN KEY (`content_ID`) REFERENCES `content` (`contentID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD CONSTRAINT `username` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
