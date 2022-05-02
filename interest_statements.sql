CREATE TABLE IF NOT EXISTS `interest_statements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;