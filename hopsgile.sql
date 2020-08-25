/*
MySQL Data Transfer
Source Host: 10.0.0.23
Source Database: openmrs_gile
Target Host: 10.0.0.23
Target Database: openmrs_gile
Date: 8/20/2020 3:27:58 PM
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for hops
-- ----------------------------
DROP TABLE IF EXISTS `hops`;
CREATE TABLE `hops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `district` varchar(100) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `study_code` varchar(100) DEFAULT NULL,
  `nid` varchar(100) DEFAULT NULL,
  `study_first_name` varchar(100) DEFAULT NULL,
  `study_second_name` varchar(100) DEFAULT NULL,
  `family_name` varchar(100) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `openmrs_birth_date` datetime DEFAULT NULL,
  `openmrs_age` int(11) DEFAULT NULL,
  `openmrs_gender` varchar(1) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `last_clinic_visit` datetime DEFAULT NULL,
  `scheduled_clinic_visit` datetime DEFAULT NULL,
  `last_artpickup` datetime DEFAULT NULL,
  `scheduled_artpickp` datetime DEFAULT NULL,
  `first_viral_load_result` int(11) DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `imc` double DEFAULT NULL,
  `imc_date` datetime DEFAULT NULL,
  `hemoglobin` int(11) DEFAULT NULL,
  `hemoglobin_date` datetime DEFAULT NULL,
  `patient_status_6_months` varchar(225) DEFAULT NULL,
  `patient_status_6_months_date_` datetime DEFAULT NULL,
  `patient_status_12_months` varchar(225) DEFAULT NULL,
  `patient_status_12_months_date_` datetime DEFAULT NULL,
  `patient_status_18_months` varchar(225) DEFAULT NULL,
  `patient_status_18_months_date_` datetime DEFAULT NULL,
  `enrolled_in_GAAC` varchar(100) DEFAULT NULL,
  `gaac_start_date` datetime DEFAULT NULL,
  `gaac_end_date` datetime DEFAULT NULL,
  `gaac_identifier` varchar(225) DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `dmc_gaac` varchar(100) DEFAULT NULL,
  `dmc_AF` varchar(100) DEFAULT NULL,
  `dmc_CA` varchar(100) DEFAULT NULL,
  `dmc_PU` varchar(100) DEFAULT NULL,
  `dmc_FR` varchar(100) DEFAULT NULL,
  `dmc_DT` varchar(100) DEFAULT NULL,
  `dmc_DC` varchar(100) DEFAULT NULL,
  `dmc_DS` varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32773 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hops_art_pick_up
-- ----------------------------
DROP TABLE IF EXISTS `hops_art_pick_up`;
CREATE TABLE `hops_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hops_cd4
-- ----------------------------
DROP TABLE IF EXISTS `hops_cd4`;
CREATE TABLE `hops_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hops_cv
-- ----------------------------
DROP TABLE IF EXISTS `hops_cv`;
CREATE TABLE `hops_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hops_end_tb_tretment
-- ----------------------------
DROP TABLE IF EXISTS `hops_end_tb_tretment`;
CREATE TABLE `hops_end_tb_tretment` (
  `patient_id` int(11) DEFAULT NULL,
  `end_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hops_start_tb_tretment
-- ----------------------------
DROP TABLE IF EXISTS `hops_start_tb_tretment`;
CREATE TABLE `hops_start_tb_tretment` (
  `patient_id` int(11) DEFAULT NULL,
  `start_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hops_tb_investigation
-- ----------------------------
DROP TABLE IF EXISTS `hops_tb_investigation`;
CREATE TABLE `hops_tb_investigation` (
  `patient_id` int(11) DEFAULT NULL,
  `tb` varchar(255) DEFAULT NULL,
  `tb_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hops_visit
-- ----------------------------
DROP TABLE IF EXISTS `hops_visit`;
CREATE TABLE `hops_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `next_visit_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `hops` VALUES ('32768', null, 'HD Gile', null, '0104040701/2019/00383', null, null, 'Manuel', 'Noemia', '6', '14800', '1992-11-04 00:00:00', '27', 'F', '2019-11-25 00:00:00', '2019-10-21 00:00:00', '2020-04-29 00:00:00', '2020-05-27 00:00:00', '2020-04-29 00:00:00', '2020-05-27 00:00:00', '3122', '2020-05-20 00:00:00', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'YES', '2019-12-20 00:00:00', null, null, null, 'CONTINUE REGIMEN', null, null, null, null, 'N', 'Y');
INSERT INTO `hops` VALUES ('32769', null, 'HD Gile', null, '0104040701/2019/00384', null, null, 'Naicha', 'Alberto', '6', '14833', '1993-01-28 00:00:00', '27', 'M', '2019-12-02 00:00:00', '2019-10-21 00:00:00', '2020-02-19 00:00:00', '2020-03-19 00:00:00', '2020-04-22 00:00:00', '2020-05-21 00:00:00', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'NO', '2019-10-21 00:00:00', null, null, null, null, null, null, null, null, 'N', 'Y');
INSERT INTO `hops` VALUES ('32770', null, 'CS Muiane', null, '0104020101/2014/00297', null, null, 'Luis', 'Sergio', '54', '11205', '1981-01-01 00:00:00', '37', 'M', '2017-09-29 00:00:00', '2017-09-29 00:00:00', '2019-12-12 00:00:00', '2020-03-12 00:00:00', '2020-03-12 00:00:00', '2020-06-12 00:00:00', '-20', '2019-07-11 00:00:00', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'NO', '2019-10-11 00:00:00', null, null, null, null, 'CONTINUE REGIMEN', 'CONTINUE REGIMEN', null, null, 'N', 'N');
INSERT INTO `hops` VALUES ('32771', null, 'CS Muiane', null, '0104040901/2020/00123', null, null, 'Miguel', 'Catija', '54', '15511', '1990-01-01 00:00:00', '30', 'F', '2020-05-05 00:00:00', '2020-04-22 00:00:00', '2020-04-22 00:00:00', '2020-05-22 00:00:00', '2020-04-22 00:00:00', '2020-05-22 00:00:00', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'YES', '2020-04-22 00:00:00', null, null, null, 'START DRUGS', null, 'START DRUGS', null, null, 'N', 'N');
INSERT INTO `hops` VALUES ('32772', null, 'CS Muiane', null, '0104040901/2020/00145', null, null, 'Adelino', 'Nilza', '54', '15568', '2004-01-01 00:00:00', '16', 'F', '2020-05-21 00:00:00', '2020-05-20 00:00:00', '2020-06-17 00:00:00', '2020-09-15 00:00:00', '2020-06-17 00:00:00', '2020-09-15 00:00:00', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'YES', '2020-05-20 00:00:00', null, null, null, 'START DRUGS', null, 'START DRUGS', null, null, 'N', 'N');
INSERT INTO `hops_art_pick_up` VALUES ('14800', 'TDF+3TC+EFV', '2019-10-21 00:00:00', '2019-11-19 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14800', 'TDF+3TC+EFV', '2019-11-21 00:00:00', '2019-12-19 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14800', 'TDF+3TC+EFV', '2019-12-20 00:00:00', '2020-01-17 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14800', 'TDF+3TC+EFV', '2020-01-20 00:00:00', '2020-02-18 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14800', null, '2020-03-25 00:00:00', '2020-04-23 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14800', null, '2020-02-18 00:00:00', '2020-03-18 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14800', null, '2020-04-29 00:00:00', '2020-05-27 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14833', 'TDF+3TC+EFV', '2019-10-21 00:00:00', '2019-11-19 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14833', 'TDF+3TC+EFV', '2019-12-13 00:00:00', '2020-01-10 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14833', 'TDF+3TC+EFV', '2019-12-20 00:00:00', '2020-01-20 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14833', 'TDF+3TC+EFV', '2020-01-20 00:00:00', '2020-02-20 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14833', 'TDF+3TC+EFV', '2020-02-19 00:00:00', '2020-03-19 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14833', 'TDF+3TC+EFV', '2020-03-20 00:00:00', '2020-04-20 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('14833', null, '2020-04-22 00:00:00', '2020-05-21 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2017-09-29 00:00:00', '2017-10-30 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2017-11-02 00:00:00', '2017-12-02 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2017-12-01 00:00:00', '2017-12-29 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2017-12-29 00:00:00', '2018-01-29 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2018-03-01 00:00:00', '2018-04-01 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2018-04-02 00:00:00', '2018-05-02 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2018-05-02 00:00:00', '2018-06-02 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2018-08-03 00:00:00', '2018-09-03 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2018-09-03 00:00:00', '2018-10-03 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2018-10-03 00:00:00', '2018-11-02 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2018-12-03 00:00:00', '2019-01-03 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-01-04 00:00:00', '2019-02-05 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-02-01 00:00:00', '2019-03-01 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-04-03 00:00:00', '2019-05-03 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-05-13 00:00:00', '2019-06-13 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-06-13 00:00:00', '2019-07-12 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-07-11 00:00:00', '2019-08-12 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-08-12 00:00:00', '2019-09-12 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-09-12 00:00:00', '2019-10-11 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-10-11 00:00:00', '2019-11-11 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-11-11 00:00:00', '2019-12-11 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', 'TDF+3TC+EFV', '2019-12-12 00:00:00', '2020-03-12 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('11205', null, '2020-03-12 00:00:00', '2020-06-12 00:00:00');
INSERT INTO `hops_art_pick_up` VALUES ('15511', null, '2020-04-22 00:00:00', '2020-05-22 00:00:00');
INSERT INTO `hops_cd4` VALUES ('14833', '616', '2019-10-21 00:00:00', null);
INSERT INTO `hops_cd4` VALUES ('11205', '1039', '2017-11-03 00:00:00', null);
INSERT INTO `hops_cd4` VALUES ('11205', '477', '2019-01-08 00:00:00', null);
INSERT INTO `hops_cv` VALUES ('11205', '-20.00', '2019-07-11 00:00:00');
INSERT INTO `hops_visit` VALUES ('14800', '2019-10-21 00:00:00', '2019-11-19 00:00:00');
INSERT INTO `hops_visit` VALUES ('14800', '2019-11-21 00:00:00', '2019-12-19 00:00:00');
INSERT INTO `hops_visit` VALUES ('14800', '2019-12-20 00:00:00', '2020-01-17 00:00:00');
INSERT INTO `hops_visit` VALUES ('14800', '2020-01-20 00:00:00', '2020-02-18 00:00:00');
INSERT INTO `hops_visit` VALUES ('14800', '2020-03-25 00:00:00', '2020-04-23 00:00:00');
INSERT INTO `hops_visit` VALUES ('14800', '2020-04-29 00:00:00', '2020-05-27 00:00:00');
INSERT INTO `hops_visit` VALUES ('14833', '2019-10-21 00:00:00', '2019-11-19 00:00:00');
INSERT INTO `hops_visit` VALUES ('14833', '2020-02-19 00:00:00', '2020-03-19 00:00:00');
INSERT INTO `hops_visit` VALUES ('11205', '2017-09-29 00:00:00', null);
INSERT INTO `hops_visit` VALUES ('11205', '2017-11-02 00:00:00', null);
INSERT INTO `hops_visit` VALUES ('11205', '2017-12-01 00:00:00', null);
INSERT INTO `hops_visit` VALUES ('11205', '2017-12-29 00:00:00', '2018-01-29 00:00:00');
INSERT INTO `hops_visit` VALUES ('11205', '2018-03-01 00:00:00', '2018-04-01 00:00:00');
INSERT INTO `hops_visit` VALUES ('11205', '2018-04-02 00:00:00', '2018-09-02 00:00:00');
INSERT INTO `hops_visit` VALUES ('11205', '2019-01-04 00:00:00', '2019-06-04 00:00:00');
INSERT INTO `hops_visit` VALUES ('11205', '2019-06-13 00:00:00', '2019-12-12 00:00:00');
INSERT INTO `hops_visit` VALUES ('11205', '2019-10-11 00:00:00', '2019-12-11 00:00:00');
INSERT INTO `hops_visit` VALUES ('11205', '2019-12-12 00:00:00', '2020-06-12 00:00:00');
INSERT INTO `hops_visit` VALUES ('15511', '2020-04-22 00:00:00', '2020-05-20 00:00:00');
