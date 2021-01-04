SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `dmc_patient`;
CREATE TABLE  `dmc_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `date_of_ART_initiation` datetime DEFAULT NULL, 
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `partner_status_at_enrollment` varchar(100) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(1) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_at_art_initiation` varchar(1) DEFAULT NULL,
  `WHO_clinical_stage_at_art_initiation_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_VL` varchar(1) DEFAULT NULL,
  `WHO_clinical_stage_VL_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_last` varchar(1) DEFAULT NULL,
  `WHO_clinical_stage_last_date` datetime DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `weight_art_initiation` double DEFAULT NULL,
  `weight_art_initiation_date` datetime DEFAULT NULL,
  `height_art_initiation` double DEFAULT NULL,
  `height_art_initiation_date` datetime DEFAULT NULL,
  `weight_VL` double DEFAULT NULL,
  `weight_VL_date` datetime DEFAULT NULL,
  `height_VL` double DEFAULT NULL,
  `height_VL_date` datetime DEFAULT NULL,
  `weight_last` double DEFAULT NULL,
  `weight_last_date` datetime DEFAULT NULL,
  `height_last` double DEFAULT NULL,
  `height_last_date` datetime DEFAULT NULL,
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `cd4_absulute_at_enrollment_date` datetime DEFAULT NULL,
  `cd4_at_enrollment` varchar(100) DEFAULT NULL, 
  `cd4_absulute_at_art_initiation_date`  datetime DEFAULT NULL,
  `cd4_at_art_initiation` varchar(100) DEFAULT NULL,
  `cd4_VL_date` datetime DEFAULT NULL,
  `cd4_VL` varchar(100) DEFAULT NULL,
  `cd4_last_date` datetime DEFAULT NULL,
  `cd4_last` varchar(100) DEFAULT NULL,
  `patient_status` varchar(225) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `enrolled_in_GAAC` varchar(100) DEFAULT NULL,
  `gaac_start_date`datetime DEFAULT NULL,
  `gaac_end_date` datetime DEFAULT NULL,
  `gaac_identifier` varchar(225) DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`),
  KEY `date_of_ART_initiation` (`date_of_ART_initiation`),
  KEY `gaac_start_date` (`gaac_start_date`),
  KEY `gaac_end_date` (`gaac_end_date`),
  KEY `height_date` (`height_date`),
  KEY `weight_date` (`weight_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dmc_visit`;
CREATE TABLE `dmc_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `next_visit_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_WHO_clinical_stage`;
CREATE TABLE `dmc_WHO_clinical_stage` (
  `patient_id` int(11) DEFAULT NULL,
  `who_stage`  varchar(1) DEFAULT NULL,
  `who_stage_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_weight`;
CREATE TABLE `dmc_weight` (
  `patient_id` int(11) DEFAULT NULL,
  `weight`  varchar(1) DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_height`;
CREATE TABLE `dmc_height` (
  `patient_id` int(11) DEFAULT NULL,
  `height`  varchar(1) DEFAULT NULL,
  `height_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_art_pick_up`;
CREATE TABLE IF NOT EXISTS `dmc_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dmc_cv_log`;
CREATE TABLE `dmc_cv_log` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dmc_cv_copies`;
CREATE TABLE `dmc_cv_copies` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_type_of_dispensation_visit`;
CREATE TABLE `dmc_type_of_dispensation_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `type_dmc` varchar(100) DEFAULT NULL,
  `value_dmc` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dmc_regimes`;
CREATE TABLE `dmc_regimes` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` decimal(12,2) DEFAULT NULL,
  `regime_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `regime_date` (`regime_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `dmc_support_groups_visit`;
CREATE TABLE `dmc_support_groups_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_support_groups` varchar(100) DEFAULT NULL,
  `date_elegibbly_support_groups` datetime DEFAULT NULL,
  `type_support_groups` varchar(100) DEFAULT NULL,
  `value_support_groups` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP PROCEDURE IF EXISTS `FillDMC`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillDMC`(startDate date,endDate date, district varchar(100))
    READS SQL DATA
begin

/*INSCRICAO*/
insert into dmc_patient(patient_id, enrollment_date, location_id)
SELECT e.patient_id,min(encounter_datetime) data_abertura, e.location_id
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,7,53)
     AND e.encounter_datetime   BETWEEN startDate  AND endDate
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id;


update dmc_patient,location
set dmc_patient.health_facility=location.name
where dmc_patient.location_id=location.location_id;


/*DATA DE NAICIMENTO*/
UPDATE dmc_patient,
       person
SET dmc_patient.date_of_birth=person.birthdate
WHERE dmc_patient.patient_id=person.person_id;

/*Sexo*/
update dmc_patient,person set dmc_patient.sex=.person.gender
where  person_id=dmc_patient.patient_id;


/*IDADE NA INSCRICAO*/
update dmc_patient,person set dmc_patient.age_enrollment=round(datediff(dmc_patient.enrollment_date,person.birthdate)/365)
where  person_id=dmc_patient.patient_id;


/*ESTADO CIVIL*/
update dmc_patient,obs
set dmc_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=dmc_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*Inicio TARV*/
update dmc_patient,
( 

        Select patient_id,min(data_inicio) data_inicio FROM 
        (

            SELECT p.patient_id,min(e.encounter_datetime) data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id  
            INNER JOIN obs o on o.encounter_id=e.encounter_id 
            WHERE e.voided=0 and o.voided=0 and p.voided=0 AND e.encounter_type in (18,6,9) and o.concept_id=1255 
            and o.value_coded=1256 AND e.encounter_datetime<=endDate  
            GROUP BY p.patient_id 
            UNION SELECT p.patient_id,min(value_datetime) data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id 
            INNER JOIN obs o on e.encounter_id=o.encounter_id 
            WHERE p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9,53) AND o.concept_id=1190 
            and o.value_datetime is not null and o.value_datetime<=endDate  
            group by p.patient_id 
            UNION 
            SELECT pg.patient_id,min(date_enrolled) data_inicio FROM patient p 
            INNER JOIN patient_program pg on p.patient_id=pg.patient_id 
            WHERE pg.voided=0 and p.voided=0 and program_id=2 AND date_enrolled<=endDate
            GROUP BY pg.patient_id 
            UNION 
            SELECT e.patient_id, MIN(e.encounter_datetime) AS data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id 
            WHERE p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=endDate  
            GROUP BY p.patient_id 
            UNION 
            SELECT p.patient_id,min(value_datetime) data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id 
            INNER JOIN obs o on e.encounter_id=o.encounter_id 
            WHERE p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type=52 and o.concept_id=23866 
            and o.value_datetime is not null and o.value_datetime<=endDate  
            group by p.patient_id
      ) inicio
    group by patient_id 
  
)inicio_real
set dmc_patient.date_of_ART_initiation=inicio_real.data_inicio
where dmc_patient.patient_id=inicio_real.patient_id;

end
;;
DELIMITER ;

