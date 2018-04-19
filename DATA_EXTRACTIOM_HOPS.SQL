SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `hops` (
  `id` int(11) DEFAULT NULL,
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
  `openmrs_gender` varchar(1) DEFAULT NULL,
  `previous_art_enrollment` varchar(1) DEFAULT NULL,
  `previous_arv_regimen_before_patient_was_lftu` varchar(1) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `cd4_count` int(11) DEFAULT NULL,
  `first_viral_load_result` int(11)  DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `previous_tb_positive_screen` varchar(1) DEFAULT NULL,
  `previous_date_of_enrollment_in_TB_services` datetime DEFAULT NULL,
  `previous_TB_treatment_completed` varchar(1) DEFAULT NULL,
  `previous_date_TB_treatment_completed` datetime DEFAULT NULL,
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
  `next_art_pick_up_date` datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL
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


CREATE TABLE `art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `art` double DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*BUSCAR ID DO PACIENTE*/
UPDATE hops,
       patient_identifier
SET hops.patient_id = patient_identifier.patient_id
WHERE patient_identifier.identifier_type=2
  AND patient_identifier.identifier=hops.new_nid;

/*DATA DE NAICIMENTO*/
UPDATE hops,
       person
SET hops.openmrs_birth_date=person.birthdate
WHERE hops.patient_id=person.person_id;

/*SEXO*/
UPDATE hops,
       person
SET hops.openmrs_gender=.person.gender
WHERE hops.patient_id=person.person_id;

/*INSCRICAO*/
UPDATE hops,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,
                              7)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment
SET hops.enrollment_date=enrollment.data_abertura
WHERE hops.patient_id=enrollment.patient_id;

/*INICIO TARV*/
UPDATE hops,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND p.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE p.voided=0
        AND e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND p.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE p.voided=0
        AND e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id) inicio
   GROUP BY patient_id)inicio_real
SET hops.art_initiation_date=inicio_real.data_inicio
WHERE hops.patient_id=inicio_real.patient_id;

end
;;
DELIMITER ;


