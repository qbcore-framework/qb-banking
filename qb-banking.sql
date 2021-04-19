CREATE TABLE IF NOT EXISTS `banks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `coords` longtext DEFAULT NULL,
  `cashiercoords` longtext DEFAULT NULL,
  `beforevaults` longtext DEFAULT NULL,
  `vaults` longtext DEFAULT NULL,
  `vaultgate` longtext DEFAULT NULL,
  `finalgate` longtext DEFAULT NULL,
  `vg_spots` longtext DEFAULT NULL,
  `m_spots` longtext DEFAULT NULL,
  `bankOpen` tinyint(1) NOT NULL DEFAULT 1,
  `bankCooldown` int(11) NOT NULL DEFAULT 0,
  `bankType` enum('Small','Big','Paleto') NOT NULL DEFAULT 'Small',
  `moneyBags` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `record_id` bigint(255) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(250) DEFAULT NULL,
  `business` varchar(50) DEFAULT NULL,
  `businessid` int(11) DEFAULT NULL,
  `gangid` varchar(50) DEFAULT NULL,
  `amount` bigint(255) NOT NULL DEFAULT 0,
  `account_type` enum('Current','Savings','Business','Gang') NOT NULL DEFAULT 'Current',
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `citizenid` (`citizenid`),
  KEY `business` (`business`),
  KEY `businessid` (`businessid`),
  KEY `gangid` (`gangid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;