SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `community_arv_patient`;
CREATE TABLE  `community_arv_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `partner_status_at_enrollment` varchar(100) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(10) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `art_regimen` varchar(255) DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL,
  `tb_at_screening` varchar(255) DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`),
  KEY `height_date` (`height_date`),
  KEY `weight_date` (`weight_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `community_arv_WHO_clinical_stage`;
CREATE TABLE `community_arv_WHO_clinical_stage` (
  `patient_id` int(11) DEFAULT NULL,
  `who_stage`  varchar(4) DEFAULT NULL,
  `who_stage_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_art_pick_up`;
CREATE TABLE IF NOT EXISTS `community_arv_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_weight`;
CREATE TABLE `community_arv_weight` (
  `patient_id` int(11) DEFAULT NULL,
  `weight`  varchar(10) DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_height`;
CREATE TABLE `community_arv_height` (
  `patient_id` int(11) DEFAULT NULL,
  `height`  varchar(10) DEFAULT NULL,
  `height_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_cv`;
CREATE TABLE `community_arv_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `copies_cv` decimal(12,2) DEFAULT NULL,
  `logs_cv` decimal(12,2) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_cd4_absolute`;
CREATE TABLE `community_arv_cd4_absolute` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_cd4_percentage`;
CREATE TABLE `community_arv_cd4_percentage` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_visit`;
CREATE TABLE `community_arv_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `next_visit_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `visit_date` (`visit_date`),
  KEY `next_visit_date` (`next_visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_posology`;
CREATE TABLE `community_arv_posology` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `dmc_type` varchar(100) DEFAULT NULL,
  `therapeutic_line` varchar(100) DEFAULT NULL,
  `posology` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP PROCEDURE IF EXISTS `FillCOMMARV`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillMCH`(startDate date,endDate date, district varchar(100)/*, location_id_parameter int(11)*/)
    READS SQL DATA
begin

TRUNCATE TABLE community_arv_WHO_clinical_stage;
TRUNCATE TABLE community_arv_art_pick_up;
TRUNCATE TABLE community_arv_weight;
TRUNCATE TABLE community_arv_height;
TRUNCATE TABLE community_arv_cv;
TRUNCATE TABLE community_arv_cd4_absolute;
TRUNCATE TABLE community_arv_cd4_percentage;
TRUNCATE TABLE community_arv_visit;
TRUNCATE TABLE community_arv_posology;

/*SET @location:=location_id_parameter;*/

/*INSCRICAO*/
insert into community_arv_patient(patient_id, enrollment_date, location_id)
        SELECT preTarvFinal.patient_id,preTarvFinal.initialDate,preTarvFinal.location FROM
         
         (   
             SELECT preTarv.patient_id, MIN(preTarv.initialDate) initialDate,preTarv.location as location FROM 
             ( 
             SELECT p.patient_id,min(o.value_datetime) AS initialDate,e.location_id as location FROM patient p  
             
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type=53 
             AND o.value_datetime IS NOT NULL AND o.concept_id=23808 AND o.value_datetime<=endDate
             GROUP BY p.patient_id 
             UNION 
             SELECT p.patient_id,min(e.encounter_datetime) AS initialDate,e.location_id as location FROM patient p 
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type IN(5,7) 
             AND e.encounter_datetime<=endDate 
             GROUP BY p.patient_id 
             UNION 
             SELECT pg.patient_id, MIN(pg.date_enrolled) AS initialDate,pg.location_id as location FROM patient p 
             INNER JOIN patient_program pg on pg.patient_id=p.patient_id 
             WHERE pg.program_id=1  AND pg.voided=0 AND pg.date_enrolled<=endDate  GROUP BY patient_id 
              ) preTarv 
             GROUP BY preTarv.patient_id
        ) 
      preTarvFinal where preTarvFinal.initialDate BETWEEN startDate AND endDate
      GROUP BY preTarvFinal.patient_id;


Update community_arv_patient set community_arv_patient.district=district;

update community_arv_patient,location
set community_arv_patient.health_facility=location.name
where community_arv_patient.location_id=location.location_id;

/*Apagar todos fora desta localização*/
/*delete from community_arv_patient where location_id not in (@location);*/

/*DATA DE NASCIMENTO*/
UPDATE community_arv_patient,
       person
SET community_arv_patient.date_of_birth=person.birthdate
WHERE community_arv_patient.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update community_arv_patient,person set community_arv_patient.age_enrollment=round(datediff(community_arv_patient.enrollment_date,person.birthdate)/365)
where  person_id=community_arv_patient.patient_id;

/*delete from community_arv_patient where age_enrollment<15;
delete from community_arv_patient where age_enrollment>49;*/

  /*Sexo*/
update community_arv_patient,person set community_arv_patient.sex=.person.gender
where  person.person_id=community_arv_patient.patient_id;

/*ESTADO CIVIL*/
update community_arv_patient,obs
set community_arv_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update community_arv_patient,obs
set community_arv_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where community_arv_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=community_arv_patient.enrollment_date;

update community_arv_patient,obs
set community_arv_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where community_arv_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=community_arv_patient.enrollment_date and community_arv_patient.pregnancy_status_at_enrollment is null;

update community_arv_patient,patient_program
set community_arv_patient.pregnancy_status_at_enrollment= 'YES'
where community_arv_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;

/*ESCOLARIDADE*/
update community_arv_patient,obs
set community_arv_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
             else null end
          
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update community_arv_patient,obs
set community_arv_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO DO PARCEIRO*/
update community_arv_patient,obs
set community_arv_patient.partner_status_at_enrollment= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1449 and obs.voided=0; 

/*ESTADIO OMS AT ENROLLMENT*/
update community_arv_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from community_arv_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set community_arv_patient.WHO_clinical_stage_at_enrollment=stage.cod,
community_arv_patient.WHO_clinical_stage_at_enrollment_date=stage.encounter_datetime
where community_arv_patient.patient_id=stage.patient_id 
and community_arv_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;