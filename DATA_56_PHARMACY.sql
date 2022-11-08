SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `pharmacy_patient`;
CREATE TABLE  `pharmacy_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `partner_status_at_enrollment` varchar(100) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(10) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL, 
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `tb_at_screening` varchar(255) DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL, 
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`),
  KEY `height_date` (`height_date`),
  KEY `weight_date` (`weight_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `pharmacy_dispensation_therapeutic_line_posology`;
CREATE TABLE `pharmacy_dispensation_therapeutic_line_posology` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `dmc_type` varchar(100) DEFAULT NULL,
  `therapeutic_line` varchar(100) DEFAULT NULL,
  `posology` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_support_groups_visit`;
CREATE TABLE `dmc_support_groups_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_support_groups` varchar(100) DEFAULT NULL,
  `date_elegibbly_support_groups` datetime DEFAULT NULL,
  `type_support_groups` varchar(100) DEFAULT NULL,
  `value_support_groups` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;