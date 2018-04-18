SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `hops` (
  `id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `study_code`varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
  `study_birth_date` datetime DEFAULT NULL,
  `study_age` int(11) DEFAULT NULL,
  `study_gender`varchar(100) DEFAULT NULL,
  `openmrs_birth_date` datetime DEFAULT NULL,
  `openmrs_age` int(11) DEFAULT NULL,
  `openmrs_gender` varchar(100) DEFAULT NULL
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

----------------------------
-- Procedure structure for FillRate
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillHOPS`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHOPS`(startDate date,endDate)
    READS SQL DATA
begin
truncate table hops;