-- Adminer 4.2.4 MySQL dump

SET NAMES utf8;
SET sql_mode = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = '+00:00';

CREATE DATABASE IF NOT EXISTS `Luna` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `Luna`;

DROP TABLE IF EXISTS `igloos`;
CREATE TABLE `igloos` (
  `ID` int(11) NOT NULL,
  `username` char(20) NOT NULL,
  `igloo` int(10) NOT NULL DEFAULT '1',
  `floor` int(10) NOT NULL DEFAULT '0',
  `music` int(10) NOT NULL DEFAULT '0',
  `furniture` longblob NOT NULL,
  `ownedFurns` longblob NOT NULL,
  `ownedIgloos` longblob NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `postcards`;
CREATE TABLE `postcards` (
  `postcardID` int(10) NOT NULL AUTO_INCREMENT,
  `recepient` int(10) NOT NULL,
  `mailerName` char(12) NOT NULL,
  `mailerID` int(10) NOT NULL,
  `notes` char(12) NOT NULL,
  `timestamp` int(8) NOT NULL,
  `postcardType` int(5) NOT NULL,
  `isRead` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`postcardID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `puffles`;
CREATE TABLE `puffles` (
  `puffleID` int(11) NOT NULL AUTO_INCREMENT,
  `ownerID` int(2) NOT NULL,
  `puffleName` char(10) NOT NULL,
  `puffleType` int(2) NOT NULL,
  `puffleEnergy` int(3) NOT NULL DEFAULT '100',
  `puffleHealth` int(3) NOT NULL DEFAULT '100',
  `puffleRest` int(3) NOT NULL DEFAULT '100',
  PRIMARY KEY (`puffleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `servers`;
CREATE TABLE `servers` (
  `servType` varchar(10) NOT NULL DEFAULT 'game',
  `servPort` int(5) NOT NULL,
  `servName` char(20) NOT NULL,
  `servIP` mediumblob NOT NULL,
  `curPop` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`servType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` char(20) NOT NULL,
  `nickname` char(20) NOT NULL,
  `password` char(32) NOT NULL,
  `spin` int(6) NOT NULL,
  `loginKey` char(32) NOT NULL,
  `ipAddr` mediumblob NOT NULL,
  `email` mediumblob NOT NULL,
  `age` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LastLogin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` int(1) NOT NULL DEFAULT '1',
  `bitMask` int(1) NOT NULL DEFAULT '1',
  `isBanned` varchar(10) NOT NULL DEFAULT '0',
  `banCount` int(1) NOT NULL DEFAULT '0',
  `invalidLogins` int(3) NOT NULL DEFAULT '0',
  `inventory` longtext NOT NULL,
  `head` int(10) NOT NULL DEFAULT '0',
  `face` int(10) NOT NULL DEFAULT '0',
  `neck` int(10) NOT NULL DEFAULT '0',
  `body` int(10) NOT NULL DEFAULT '0',
  `hand` int(10) NOT NULL DEFAULT '0',
  `feet` int(10) NOT NULL DEFAULT '0',
  `photo` int(10) NOT NULL DEFAULT '0',
  `flag` int(10) NOT NULL DEFAULT '0',
  `colour` mediumtext NOT NULL,
  `coins` int(11) NOT NULL,
  `isMuted` int(1) NOT NULL DEFAULT '0',
  `isStaff` int(1) NOT NULL DEFAULT '0',
  `isAdmin` int(1) NOT NULL DEFAULT '0',
  `rank` int(1) NOT NULL DEFAULT '1',
  `buddies` longblob NOT NULL,
  `ignored` longblob NOT NULL,
  `isEPF` int(1) NOT NULL DEFAULT '0',
  `fieldOPStatus` int(1) NOT NULL DEFAULT '0',
  `epfPoints` int(10) NOT NULL DEFAULT '20',
  `totalEPFPoints` int(10) NOT NULL DEFAULT '100',
  `stamps` longblob NOT NULL,
  `cover` longblob NOT NULL,
  `restamps` longblob NOT NULL,
  `nameglow` mediumblob NOT NULL,
  `namecolour` mediumblob NOT NULL,
  `bubbletext` mediumblob NOT NULL,
  `bubblecolour` mediumblob NOT NULL,
  `penguinglow` mediumblob NOT NULL,
  `snowballglow` mediumblob NOT NULL,
  `bubbleglow` mediumblob NOT NULL,
  `moodglow` mediumblob NOT NULL,
  `moodcolor` mediumblob NOT NULL,
  `ringcolour` mediumblob NOT NULL,
  `chatglow` mediumblob NOT NULL,
  `speed` int(3) NOT NULL DEFAULT '4',
  `mood` char(100) NOT NULL,
  `penguin_size` int(3) NOT NULL,
  `penguin_blend` mediumblob NOT NULL,
  `penguin_alpha` int(3) NOT NULL,
  `isCloneable` int(1) NOT NULL DEFAULT '1',
  `wow` int(1) NOT NULL DEFAULT '0',
  `transformation` mediumtext NOT NULL,
  `rotation` mediumtext NOT NULL,
  `hue` mediumtext NOT NULL,
  `card_music` mediumtext NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- 2016-03-01 19:24:13