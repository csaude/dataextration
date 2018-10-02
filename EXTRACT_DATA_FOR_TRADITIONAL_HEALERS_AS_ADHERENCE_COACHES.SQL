/*
Navicat MySQL Data Transfer

Source Server         : LocalServer
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : mobile_clinic_eval

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2016-06-30 08:32:57
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for art_pickup
-- ----------------------------

DROP TABLE IF EXISTS `patient`;

CREATE TABLE `patient` (
  `patient_id` int(11) DEFAULT NULL,
  `nid` varchar(255) DEFAULT NULL,
  `initial_names` varchar(255) DEFAULT NULL,
  `house_refrigerator` varchar(255) DEFAULT NULL,
  `house_electricity` varchar(255) DEFAULT NULL,
  `drink` varchar(255) DEFAULT NULL,
  `drugs` varchar(255) DEFAULT NULL,
  `smoking` varchar(255) DEFAULT NULL,
  `hiv_entry_point` varchar(255) DEFAULT NULL,
  `partner_known_to_be_diagnosed_with_HIV` varchar(255) DEFAULT NULL,
  `partner_enrolled_on_ART` varchar(255) DEFAULT NULL,
  `date_of_diagnosis` datetime DEFAULT NULL,
  `date_of_ART_initiation` datetime DEFAULT NULL,
  `current_treatment_regimen` varchar(255) DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `date_of_diagnosis_tb_co_infection` datetime DEFAULT NULL,
  `date_of_TB_medication_initiation`  datetime DEFAULT NULL,
  `date_of_TB_medication_completion`  datetime DEFAULT NULL,
  `TB_medication_completed` varchar(255) DEFAULT NULL,
  `known_to_have_died` varchar(255) DEFAULT NULL,
  `date_of_death`  datetime DEFAULT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for art_pickup
-- ----------------------------
DROP TABLE IF EXISTS `art_pickup`;
CREATE TABLE `art_pickup` (
  `patient_id` int(11) DEFAULT NULL,
  `art_pickup_date` datetime DEFAULT NULL,
  `scheduled_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of art_pickup
-- ----------------------------

-- ----------------------------
-- Table structure for cd4
-- ----------------------------
DROP TABLE IF EXISTS `cd4`;
CREATE TABLE `cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cvgaac_cv
-- ----------------------------
DROP TABLE IF EXISTS `viral_load`;
CREATE TABLE `viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
