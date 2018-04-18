SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `hops` (
  `id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `study_code`varchar(100) DEFAULT NULL,
  `old_nid`varchar(100) DEFAULT NULL,
  `new_nid`varchar(100) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
  `study_birth_date` datetime DEFAULT NULL,
  `study_age` int(11) DEFAULT NULL,
  `study_gender`varchar(1) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `openmrs_birth_date` datetime DEFAULT NULL,
  `openmrs_age` int(11) DEFAULT NULL,
  `openmrs_gender` varchar(1) DEFAULT NULL
  `previous_art_enrollment` varchar(1) DEFAULT NULL
  `previous_arv_regimen_before_patient_was_lftu` varchar(1) DEFAULT NULL
  `art_regimen` varchar(1) DEFAULT NULL
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `cd4_count` int(11) DEFAULT NULL,
  `first_viral_load_result` int(11)  DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `previous_tb_positive_screen` varchar(1) DEFAULT NULL
  `previous_date_of_enrollment_in_TB_services` datetime DEFAULT NULL,
  `previous_TB_treatment_completed` varchar(1) DEFAULT NULL
  `previous_date_TB_treatment_completed` datetime DEFAULT NULL,
  `current_enrollment_in_TB_services` varchar(1) DEFAULT NULL,
  `current_enrollment_in_TB_services` varchar(1) DEFAULT NULL,
  `enrollment_date_TB` datetime DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `height` double DEFAULT NULL,
  `imc`    double DEFAULT NULL,
  `hemoglobin` int(11)  DEFAULT NULL,
  `patient_status` varchar(1) DEFAULT NULL,
  `last_visit_date`  datetime DEFAULT NULL,
  `last_art_pick_up_date`  datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `next_artpick_up_date` datetime DEFAULT NULL
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


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



/*BUSCAR ID DO PACIENTE*/
update hops,patient_identifier
set hops.patient_id = patient_identifier.patient_id
where patient_identifier.identifier_type=2 and patient_identifier.identifier=hops.nid;

/*Data de Naicimento*/
update hops,person set hops.openmrs_birth_date=person.birthdate
where  hops.patient_id=person.person_id;

/*Sexo*/
update hops,person set hops.openmrs_gender=.person.gender
where  hosps.patient_id=person.person_id;



end
;;
DELIMITER ;


