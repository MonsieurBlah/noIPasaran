CREATE DATABASE `brnrd_noipasaran` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `brnrd_noipasaran`;

CREATE TABLE IF NOT EXISTS `dns_servers` (
  `dns_server_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(36) NOT NULL,
  `primary_ip` varchar(15) NOT NULL,
  `secondary_ip` varchar(15) DEFAULT NULL,
  `location` varchar(45) NOT NULL,
  `is_isp` tinyint(1) DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `valid` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`dns_server_id`),
  UNIQUE KEY `dns_server_temp_id` (`dns_server_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=89 ;


CREATE TABLE IF NOT EXISTS `sites` (
  `site_id` int(11) NOT NULL AUTO_INCREMENT,
  `url` text NOT NULL,
  `ip` text NOT NULL,
  `hash` text NOT NULL,
  `haz_problem` tinyint(1) DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`site_id`),
  UNIQUE KEY `site_id` (`site_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=65 ;