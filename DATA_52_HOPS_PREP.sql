SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `hops_prep` (
    `id` int(11) DEFAULT NULL AUTO_INCREMENT,
    `district`varchar(100) DEFAULT NULL,
    `health_facility`varchar(100) DEFAULT NULL,
    `nid`varchar(100) DEFAULT NULL,
    `family_name`varchar(100) DEFAULT NULL,
    `first_name`varchar(100) DEFAULT NULL,
    `location_id` int(11) DEFAULT NULL,
    `patient_id` int(11) DEFAULT NULL,
    `openmrs_gender` varchar(1) DEFAULT NULL,
    `openmrs_birth_date` datetime DEFAULT NULL,
    `previous_art_enrollment` varchar(3) DEFAULT NULL,
    `enrollment_date` datetime DEFAULT NULL,
    `art_initiation_date` datetime DEFAULT NULL,
    `WHO_clinical_stage_at_art_initiation` varchar(4) DEFAULT NULL,
    `WHO_clinical_stage_at_art_initiation_date` datetime DEFAULT NULL,
    `tb_active_last` varchar(3) DEFAULT NULL,
    `tb_treatment_last` varchar(100) DEFAULT NULL,
    `tb_at_screening` varchar(255) DEFAULT NULL,
    `prep_first_visit_date` datetime DEFAULT NULL,
    `prep_initiation_date` datetime DEFAULT NULL,
    `weight` double DEFAULT NULL,
    `weight_date` datetime DEFAULT NULL,
    `height` double DEFAULT NULL,
    `height_date` datetime DEFAULT NULL,
    `imc_ini`    decimal(5,2) DEFAULT NULL,
    `imc_date_ini` datetime DEFAULT NULL,
    `hemoglobin_ini`  decimal(5,2) DEFAULT NULL,
    `hemoglobin_date_ini` datetime DEFAULT NULL,
    `blood_pressure_SBP_ini` int(255) DEFAULT NULL,
    `blood_pressure_DBP_ini` int(255) DEFAULT NULL,
    `blood_pressure_date` datetime DEFAULT NULL,
    `patient_status_1_months` varchar(225) DEFAULT NULL,
    `patient_status_1_months_date` datetime DEFAULT NULL,
    `patient_status_2_months` varchar(225) DEFAULT NULL,
    `patient_status_2_months_date` datetime DEFAULT NULL,
    `patient_status_3_months` varchar(225) DEFAULT NULL,
    `patient_status_3_months_date` datetime DEFAULT NULL,
    `patient_status_4_months` varchar(225) DEFAULT NULL,
    `patient_status_4_months_date` datetime DEFAULT NULL,
    `patient_status_5_months` varchar(225) DEFAULT NULL,
    `patient_status_5_months_date` datetime DEFAULT NULL,
    `patient_status_6_months` varchar(225) DEFAULT NULL,
    `patient_status_6_months_date` datetime DEFAULT NULL,
    `last_clinic_visit` datetime DEFAULT NULL,
    `last_artpickup` datetime DEFAULT NULL,
    `scheduled_artpickp` datetime DEFAULT NULL,
    `tobacco_use` varchar(255) DEFAULT NULL,
    `alcohol_use` varchar(100) DEFAULT NULL,
    `intravenous_drug_use` varchar(100) DEFAULT NULL,
    `family_planning_first` varchar(50) DEFAULT NULL,
    `family_planning_date_first` varchar(50) DEFAULT NULL,
    `patient_status` varchar(100) DEFAULT NULL,
    `patient_status_date` datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cd4
-- ----------------------------
DROP TABLE IF EXISTS `hops_prep_cd4`;
CREATE TABLE IF NOT EXISTS `hops_prep_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_art_pick_up`;
CREATE TABLE IF NOT EXISTS `hops_prep_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
  `number_of_pills` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_art_pick_up_reception_art`;
CREATE TABLE IF NOT EXISTS `hops_prep_art_pick_up_reception_art` (
  `patient_id` int(11) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_type_of_dispensation_visit`;
CREATE TABLE `hops_prep_type_of_dispensation_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `type_dmc` varchar(100) DEFAULT NULL,
  `value_dmc` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_art_regimes`;
CREATE TABLE `hops_prep_art_regimes` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar (250) DEFAULT NULL,
  `regime_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `regime_date` (`regime_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_visit`;
CREATE TABLE IF NOT EXISTS `hops_prep_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `hops_prep_cv`;
CREATE TABLE `hops_prep_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  `request_id` varchar(30) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_start_tb_treatment`;
CREATE TABLE IF NOT EXISTS `hops_prep_start_tb_treatment` (
  `patient_id` int(11) DEFAULT NULL,
  `start_tb_treatment` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_end_tb_treatment`;
CREATE TABLE IF NOT EXISTS `hops_prep_end_tb_treatment` (
  `patient_id` int(11) DEFAULT NULL,
  `end_tb_treatment` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_clinic_visit`;
CREATE TABLE IF NOT EXISTS `hops_prep_clinic_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `prep_visit_date` datetime DEFAULT NULL,
  `next_prep_visit_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `hops_prep_alanine_transferase`;
CREATE TABLE `hops_prep_alanine_transferase` (
  `patient_id` int(11) DEFAULT NULL,
  `alanine_value` decimal(10,2) DEFAULT NULL,
  `alt_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_creatinine`;
CREATE TABLE `hops_prep_creatinine` (
  `patient_id` int(11) DEFAULT NULL,
  `creatinine_value` varchar(100)  DEFAULT NULL,
  `creatinine_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_ctx`;
CREATE TABLE `hops_prep_ctx` (
  `patient_id` int(11) DEFAULT NULL,
  `prescrition` varchar(100)  DEFAULT NULL,
  `prescrition_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_initial_situation`;
CREATE TABLE `hops_prep_initial_situation` (
  `patient_id` int(11) DEFAULT NULL,
  `prep_patient_situation` varchar(100)  DEFAULT NULL,
  `prep_patient_situation_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_clinical_visit`;
CREATE TABLE `hops_prep_clinical_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `clinical_visit_date` varchar(100)  DEFAULT NULL,
  `next_clinical_visit_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_pills_left`;
CREATE TABLE `hops_prep_pills_left` (
  `patient_id` int(11) DEFAULT NULL,
  `pills_left_over` decimal(10,2)  DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_drug_repeat_prescrition`;
CREATE TABLE `hops_prep_drug_repeat_prescrition` (
  `patient_id` int(11) DEFAULT NULL,
  `arv_prescribed` varchar(100)  DEFAULT NULL,
  `nr_bottles` decimal(10,2)  DEFAULT NULL,
  `clinical_visit_date` datetime DEFAULT NULL,
  `next_clinical_visit_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `hops_prep_family_planning`;
CREATE TABLE `hops_prep_family_planning` (
  `patient_id` int(11) DEFAULT NULL,
  `family_planning` varchar(100)  DEFAULT NULL,
  `family_planning_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `Fillhops_prep`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fillhops_prep`(startDate date,endDate date, district varchar(100)/*, location_id_parameter int(11)*/)
    READS SQL DATA
begin

truncate table hops_prep_cd4;
truncate table hops_prep_art_pick_up;
truncate table hops_prep_art_pick_up_reception_art;
truncate table hops_prep_art_regimes;
truncate table hops_prep_cv;
truncate table hops_prep_start_tb_treatment;
truncate table hops_prep_end_tb_treatment;
truncate table hops_prep_clinic_visit;
truncate table hops_prep_alanine_transferase;
truncate table hops_prep_creatinine;
truncate table hops_prep_ctx;
truncate table hops_prep_initial_situation;
truncate table hops_prep_clinical_visit;
truncate table hops_prep_pills_left;
truncate table hops_prep_drug_repeat_prescrition;
truncate table hops_prep_family_planning;

/*SET @location:=location_id_parameter;*/

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE hops_prep,
       patient_identifier
SET hops_prep.patient_id=patient_identifier.patient_id, hops_prep.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=hops_prep.nid;

/*Apagar todos fora desta localização*/
/*delete from hops_prep where location_id not in (@location);*/

/*DATA DE NASCIMENTO*/
UPDATE hops_prep,
       person
SET hops_prep.openmrs_birth_date=person.birthdate
WHERE hops_prep.patient_id=person.person_id;

/*FIRST NAME*/
UPDATE hops_prep,
       person_name
SET hops_prep.first_name=person_name.given_name
WHERE hops_prep.patient_id=person_name.person_id;


/*FAMILY NAME*/
UPDATE hops_prep,
       person_name
SET hops_prep.family_name=person_name.family_name
WHERE hops_prep.patient_id=person_name.person_id;


/*SEXO*/
UPDATE hops_prep,
       person
SET hops_prep.openmrs_gender=.person.gender
WHERE hops_prep.patient_id=person.person_id;


/*Previous Enrollment*/
UPDATE hops_prep,
       person
SET hops_prep.openmrs_gender=.person.gender
WHERE hops_prep.patient_id=person.person_id;


/*INICIO TARV*/
UPDATE hops_prep,
 (
  SELECT inicio_real.patient_id, if(inicio_real.data_inicio is not null, "YES","NO")  as estado FROM
 (
    SELECT patient_id,min(data_inicio) data_inicio
   FROM
     (
            /* Patients on ART who initiated the ARV DRUGS: ART Regimen Start Date */
                   Select  p.patient_id,min(e.encounter_datetime) data_inicio
                   from  hops_prep p
                       inner join person pe on pe.person_id = p.patient_id
                       inner join encounter e on p.patient_id=e.patient_id
                       inner join obs o on o.encounter_id=e.encounter_id
                   where   e.voided=0 and o.voided=0 and pe.voided=0  and
                       e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256
                   group by p.patient_id
                   union
            /* Patients on ART who have art start date: ART Start date */
                   Select  p.patient_id,min(value_datetime) data_inicio
                   from  hops_prep p
                       inner join person pe on pe.person_id = p.patient_id
                       inner join encounter e on p.patient_id=e.patient_id
                       inner join obs o on e.encounter_id=o.encounter_id
                   where   pe.voided = 0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9,53) and
                       o.concept_id=1190 and o.value_datetime is not null
                   group by p.patient_id
                   union
            /* Patients enrolled in ART Program: OpenMRS Program */
                   select  pg.patient_id,min(date_enrolled) data_inicio
                   from  hops_prep p
                     inner join person pe on pe.person_id = p.patient_id
                     inner join patient_program pg on p.patient_id=pg.patient_id
                   where   pg.voided=0  and pe.voided = 0 and program_id=2
                   group by pg.patient_id
                   union
            /*
             * Patients with first drugs pick up date set in Pharmacy: First ART Start Date
             */
                     SELECT  e.patient_id, MIN(e.encounter_datetime) AS data_inicio
                     FROM    hops_prep p
                         inner join person pe on pe.person_id = p.patient_id
                         inner join encounter e on p.patient_id=e.patient_id
                     WHERE   pe.voided = 0 and e.encounter_type=18 AND e.voided=0
                     GROUP BY  p.patient_id
                   union
            /* Patients with first drugs pick up date set: Recepcao Levantou ARV */
                   Select  p.patient_id,min(value_datetime) data_inicio
                   from  hops_prep p
                       inner join person pe on pe.person_id = p.patient_id
                       inner join encounter e on p.patient_id=e.patient_id
                       inner join obs o on e.encounter_id=o.encounter_id
                   where    pe.voided = 0 and e.voided=0 and o.voided=0 and e.encounter_type=52 and
                       o.concept_id=23866 and o.value_datetime is not null
                   group by p.patient_id
      ) inicio
   GROUP BY patient_id
   )inicio_real
)f
SET hops_prep.previous_art_enrollment=f.estado
WHERE hops_prep.patient_id=f.patient_id;


/*INSCRICAO*/
UPDATE hops_prep,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM hops_prep p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE e.encounter_type IN (5,7,53,80)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment
SET hops_prep.enrollment_date=enrollment.data_abertura
WHERE hops_prep.patient_id=enrollment.patient_id;

/*INICIO TARV*/
UPDATE hops_prep,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM hops_prep p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM hops_prep p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM hops_prep p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM hops_prep p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET hops_prep.art_initiation_date=inicio_real.data_inicio
WHERE hops_prep.patient_id=inicio_real.patient_id;

/*ESTADIO OMS AT ART INITIATION*/
update hops_prep,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set hops_prep.WHO_clinical_stage_at_art_initiation=stage.cod,
hops_prep.WHO_clinical_stage_at_art_initiation_date=stage.encounter_datetime
where hops_prep.patient_id=stage.patient_id 
and hops_prep.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/*Tb Active*/
update hops_prep,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
       else null end as cod
  from hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime
  and o.concept_id=23761) obs
set hops_prep.tb_active_last=obs.cod
where hops_prep.patient_id=obs.patient_id;

/*Tb Treatment*/
update hops_prep,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime,
      case o.value_coded
    when 1257 then 'CONTINUE REGIMEN'
    when 1107 then 'NONE'
    when 1256 then 'STARTDRUGS'
    when 1260 then 'STOPALL'
    when 1259 then 'CHANGE'
    when 981  then 'DOSINGCHANGE'
    when 1369 then 'TRANSFER FROM OTHER FACILITY'
    when 843  then 'REGIMEN FAILURE'
    when 1705 then 'RESTART'
    when 5622 then 'Other'
    when 2055 then 'TREATMENT AFTER DROP'
    when 1065 then 'Yes'
    when 1066 then 'No'
    when 1267 then 'COMPLETED'
       else null end as cod
  from hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime
  and o.concept_id=1268) obs
set hops_prep.tb_treatment_last=obs.cod
where hops_prep.patient_id=obs.patient_id;

/*TB Screening*/
update hops_prep,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id in(6257,23758)
  group by p.patient_id
)tb, obs
set hops_prep.tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where hops_prep.patient_id=obs.person_id 
and hops_prep.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id in(6257,23758) ;


/*Prep first visit*/
update hops_prep,encounter
set hops_prep.prep_first_visit_date=encounter.encounter_datetime 
where encounter.encounter_type=80 and hops_prep.patient_id=encounter.patient_id;

/*Prep Inicial*/
update hops_prep,obs
set hops_prep.prep_initiation_date=obs.value_datetime 
where obs.concept_id=165211 and hops_prep.patient_id=obs.person_id;

/*Peso*/
update hops_prep,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set hops_prep.weight=obs.value_numeric, hops_prep.weight_date=peso.encounter_datetime
where hops_prep.patient_id=obs.person_id 
and hops_prep.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update hops_prep,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set hops_prep.height=obs.value_numeric, hops_prep.height_date=altura.encounter_datetime
where hops_prep.patient_id=obs.person_id 
and hops_prep.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;

/* IMC*/
update hops_prep,
(select  p.patient_id,
	min(encounter_datetime) encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and  o.obs_datetime=e.encounter_datetime and o.concept_id=1342 and o.voided=0 and e.encounter_datetime 
group by p.patient_id
) imcdate

inner join

(
select e.encounter_id,obs.value_numeric,e.encounter_datetime,e.patient_id
from obs, encounter e, hops_prep p
where obs.encounter_id=e.encounter_id and p.patient_id=e.patient_id and obs.concept_id=1342 and e.voided=0 and obs.voided=0 
) enc

on enc.encounter_datetime=imcdate.encounter_datetime and
imcdate.patient_id=enc.patient_id
set hops_prep.imc_ini=enc.value_numeric, hops_prep.imc_date_ini=imcdate.encounter_datetime
where hops_prep.patient_id=imcdate.patient_id 
and hops_prep.patient_id=enc.patient_id;



/*HEMOGLOBINA NO ENROLLMENT */
update hops_prep,
(select  p.patient_id,
	min(encounter_datetime) encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and  o.obs_datetime=e.encounter_datetime and o.concept_id=1692 and o.voided=0 
group by p.patient_id
) hemodate

inner join

(
select e.encounter_id,obs.value_numeric,e.encounter_datetime,e.patient_id
from obs, encounter e, hops_prep p
where obs.encounter_id=e.encounter_id and p.patient_id=e.patient_id and obs.concept_id=1692 and e.voided=0 and obs.voided=0  
) hemo

on hemo.encounter_datetime=hemodate.encounter_datetime and
hemodate.patient_id=hemo.patient_id
set hops_prep.hemoglobin_ini=hemo.value_numeric, hops_prep.hemoglobin_date_ini=hemodate.encounter_datetime
where hops_prep.patient_id=hemodate.patient_id 
and hops_prep.patient_id=hemo.patient_id;


/*HEMOGLOBINA LAB 
update hops_prep,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=13 and o.obs_datetime=e.encounter_datetime and e.encounter_datetime between startDate and endDate 
      and o.concept_id=21
  group by p.patient_id
)hemoglobin_ini,
obs 
set  hops_prep.hemoglobin_ini=obs.value_numeric, hops_prep.hemoglobin_date_ini=hemoglobin_ini.encounter_datetime
where hops_prep.patient_id=obs.person_id
and hops_prep.patient_id=hemoglobin_ini.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin_ini.encounter_datetime
and obs.concept_id=21 and hops_prep.hemoglobin_ini is null;*/

/*BLOOD PRESSURE*/
update hops_prep,
(select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5085
  group by p.patient_id)sbp,obs
set hops_prep.blood_pressure_sbp_ini=obs.value_numeric, hops_prep.blood_pressure_date=sbp.encounter_datetime
where hops_prep.patient_id=obs.person_id 
and hops_prep.patient_id=sbp.patient_id 
and obs.voided=0 and obs.obs_datetime=sbp.encounter_datetime
and obs.concept_id=5085;


/*blood pressure*/
  update hops_prep,
(select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5086
  group by p.patient_id)dbp,obs
set hops_prep.blood_pressure_DBP_ini=obs.value_numeric, hops_prep.blood_pressure_date=dbp.encounter_datetime
where hops_prep.patient_id=obs.person_id 
and hops_prep.patient_id=dbp.patient_id 
and obs.voided=0 and obs.obs_datetime=dbp.encounter_datetime
and obs.concept_id=5086;


 /*ESTADO ACTUAL TARV 1 MES*/
update hops_prep,
   (select   pg.patient_id,ps.start_date,
        case ps.state
        when 6 then 'ACTIVE ON PROGRAM (SERVIÇO TARV-TRATAMENTO)'
					when 7 then 'TRASFERRED OUT (SERVIÇO TARV-TRATAMENTO)'
					when 8 then 'SUSPENDED (SERVIÇO TARV-TRATAMENTO)'
					when 9 then 'ART LTFU (SERVIÇO TARV-TRATAMENTO)'
					when 10 then 'DEAD (SERVIÇO TARV-TRATAMENTO)'
          when 29 then 'TRANSFER FROM OTHER FACILITY'
          when 75 then 'ACTIVE ON PROGRAM (PREP)'
          when 76 then 'TRANSFER FROM OTHER FACILITY (PREP)'
          when 77 then 'TRANSFERRED OUT TO ANOTHER FACILITY (PREP)'
          when 78 then 'PATIENT HAS DIED (PREP)'
          when 79 then 'EXIT - HIV POSITIVE TESTED (PREP)'
          when 80 then 'EXIT - NO MORE SUBSTANTIAL RISKS (PREP)'
          when 81 then 'EXIT- SIDE EFFECTS (PREP)'
          when 82 then 'EXIT - USER PREFERENCE (PREP)'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        	pg.program_id in (2,25) and ps.state in (6,7,8,9,10,29,75,76,77,78,79,80,81,82) and ps.end_date is null and  ps.start_date between case when art_initiation_date is null then enrollment_date else art_initiation_date end and DATE_ADD(case when art_initiation_date is null then enrollment_date else art_initiation_date end, INTERVAL 1 MONTH)
    
    ) out_state
set   hops_prep.patient_status_1_months=out_state.codeestado, hops_prep.patient_status_1_months_date=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 2 MES*/
update hops_prep,
   (select   pg.patient_id,ps.start_date,
        case ps.state
        when 6 then 'ACTIVE ON PROGRAM (SERVIÇO TARV-TRATAMENTO)'
					when 7 then 'TRASFERRED OUT (SERVIÇO TARV-TRATAMENTO)'
					when 8 then 'SUSPENDED (SERVIÇO TARV-TRATAMENTO)'
					when 9 then 'ART LTFU (SERVIÇO TARV-TRATAMENTO)'
					when 10 then 'DEAD (SERVIÇO TARV-TRATAMENTO)'
          when 29 then 'TRANSFER FROM OTHER FACILITY'
          when 75 then 'ACTIVE ON PROGRAM (PREP)'
          when 76 then 'TRANSFER FROM OTHER FACILITY (PREP)'
          when 77 then 'TRANSFERRED OUT TO ANOTHER FACILITY (PREP)'
          when 78 then 'PATIENT HAS DIED (PREP)'
          when 79 then 'EXIT - HIV POSITIVE TESTED (PREP)'
          when 80 then 'EXIT - NO MORE SUBSTANTIAL RISKS (PREP)'
          when 81 then 'EXIT- SIDE EFFECTS (PREP)'
          when 82 then 'EXIT - USER PREFERENCE (PREP)'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        	pg.program_id in (2,25) and ps.state in (6,7,8,9,10,29,75,76,77,78,79,80,81,82) and ps.end_date is null and  ps.start_date between    DATE_ADD(case when art_initiation_date is null then enrollment_date else art_initiation_date end, INTERVAL 1 MONTH) and DATE_ADD(case when art_initiation_date is null then enrollment_date else art_initiation_date end, INTERVAL 2 MONTH)
    ) out_state
set   hops_prep.patient_status_2_months=out_state.codeestado, hops_prep.patient_status_2_months_date=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 3 MES*/
update hops_prep,
   (select   pg.patient_id,ps.start_date,
        case ps.state
        when 6 then 'ACTIVE ON PROGRAM (SERVIÇO TARV-TRATAMENTO)'
					when 7 then 'TRASFERRED OUT (SERVIÇO TARV-TRATAMENTO)'
					when 8 then 'SUSPENDED (SERVIÇO TARV-TRATAMENTO)'
					when 9 then 'ART LTFU (SERVIÇO TARV-TRATAMENTO)'
					when 10 then 'DEAD (SERVIÇO TARV-TRATAMENTO)'         
          when 29 then 'TRANSFER FROM OTHER FACILITY'
          when 75 then 'ACTIVE ON PROGRAM (PREP)'
          when 76 then 'TRANSFER FROM OTHER FACILITY (PREP)'
          when 77 then 'TRANSFERRED OUT TO ANOTHER FACILITY (PREP)'
          when 78 then 'PATIENT HAS DIED (PREP)'
          when 79 then 'EXIT - HIV POSITIVE TESTED (PREP)'
          when 80 then 'EXIT - NO MORE SUBSTANTIAL RISKS (PREP)'
          when 81 then 'EXIT- SIDE EFFECTS (PREP)'
          when 82 then 'EXIT - USER PREFERENCE (PREP)'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        	pg.program_id in (2,25) and ps.state in (6,7,8,9,10,29,75,76,77,78,79,80,81,82) and ps.end_date is null and  ps.start_date between DATE_ADD(enrollment_date, INTERVAL 2 MONTH) and DATE_ADD(enrollment_date, INTERVAL 3 MONTH)
    ) out_state
set   hops_prep.patient_status_3_months=out_state.codeestado, hops_prep.patient_status_3_months_date=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 4 MES*/
update hops_prep,
   (select   pg.patient_id,ps.start_date,
        case ps.state
        when 6 then 'ACTIVE ON PROGRAM (SERVIÇO TARV-TRATAMENTO)'
					when 7 then 'TRASFERRED OUT (SERVIÇO TARV-TRATAMENTO)'
					when 8 then 'SUSPENDED (SERVIÇO TARV-TRATAMENTO)'
					when 9 then 'ART LTFU (SERVIÇO TARV-TRATAMENTO)'
					when 10 then 'DEAD (SERVIÇO TARV-TRATAMENTO)'
          when 29 then 'TRANSFER FROM OTHER FACILITY'
          when 75 then 'ACTIVE ON PROGRAM (PREP)'
          when 76 then 'TRANSFER FROM OTHER FACILITY (PREP)'
          when 77 then 'TRANSFERRED OUT TO ANOTHER FACILITY (PREP)'
          when 78 then 'PATIENT HAS DIED (PREP)'
          when 79 then 'EXIT - HIV POSITIVE TESTED (PREP)'
          when 80 then 'EXIT - NO MORE SUBSTANTIAL RISKS (PREP)'
          when 81 then 'EXIT- SIDE EFFECTS (PREP)'
          when 82 then 'EXIT - USER PREFERENCE (PREP)'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        	pg.program_id in (2,25) and ps.state in (6,7,8,9,10,29,75,76,77,78,79,80,81,82) and ps.end_date is null and  ps.start_date between DATE_ADD(enrollment_date, INTERVAL 3 MONTH) and DATE_ADD(enrollment_date, INTERVAL 4 MONTH)
    ) out_state
set   hops_prep.patient_status_4_months=out_state.codeestado, hops_prep.patient_status_4_months_date=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 5 MES*/
update hops_prep,
   (select   pg.patient_id,ps.start_date,
        case ps.state
        when 6 then 'ACTIVE ON PROGRAM (SERVIÇO TARV-TRATAMENTO)'
					when 7 then 'TRASFERRED OUT (SERVIÇO TARV-TRATAMENTO)'
					when 8 then 'SUSPENDED (SERVIÇO TARV-TRATAMENTO)'
					when 9 then 'ART LTFU (SERVIÇO TARV-TRATAMENTO)'
					when 10 then 'DEAD (SERVIÇO TARV-TRATAMENTO)'
          when 29 then 'TRANSFER FROM OTHER FACILITY'
          when 75 then 'ACTIVE ON PROGRAM (PREP)'
          when 76 then 'TRANSFER FROM OTHER FACILITY (PREP)'
          when 77 then 'TRANSFERRED OUT TO ANOTHER FACILITY (PREP)'
          when 78 then 'PATIENT HAS DIED (PREP)'
          when 79 then 'EXIT - HIV POSITIVE TESTED (PREP)'
          when 80 then 'EXIT - NO MORE SUBSTANTIAL RISKS (PREP)'
          when 81 then 'EXIT- SIDE EFFECTS (PREP)'
          when 82 then 'EXIT - USER PREFERENCE (PREP)'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        	pg.program_id in (2,25) and ps.state in (6,7,8,9,10,29,75,76,77,78,79,80,81,82) and ps.end_date is null and  ps.start_date between DATE_ADD(enrollment_date, INTERVAL 4 MONTH) and DATE_ADD(enrollment_date, INTERVAL 5 MONTH)
    ) out_state
set   hops_prep.patient_status_5_months=out_state.codeestado, hops_prep.patient_status_5_months_date=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 6 MESES*/
update hops_prep,
   (select   pg.patient_id,ps.start_date,
        case ps.state
        when 6 then 'ACTIVE ON PROGRAM (SERVIÇO TARV-TRATAMENTO)'
					when 7 then 'TRASFERRED OUT (SERVIÇO TARV-TRATAMENTO)'
					when 8 then 'SUSPENDED (SERVIÇO TARV-TRATAMENTO)'
					when 9 then 'ART LTFU (SERVIÇO TARV-TRATAMENTO)'
					when 10 then 'DEAD (SERVIÇO TARV-TRATAMENTO)'
          when 29 then 'TRANSFER FROM OTHER FACILITY'
          when 75 then 'ACTIVE ON PROGRAM (PREP)'
          when 76 then 'TRANSFER FROM OTHER FACILITY (PREP)'
          when 77 then 'TRANSFERRED OUT TO ANOTHER FACILITY (PREP)'
          when 78 then 'PATIENT HAS DIED (PREP)'
          when 79 then 'EXIT - HIV POSITIVE TESTED (PREP)'
          when 80 then 'EXIT - NO MORE SUBSTANTIAL RISKS (PREP)'
          when 81 then 'EXIT- SIDE EFFECTS (PREP)'
          when 82 then 'EXIT - USER PREFERENCE (PREP)'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        	pg.program_id in (2,25) and ps.state in (6,7,8,9,10,29,75,76,77,78,79,80,81,82) and ps.end_date is null and  ps.start_date between DATE_ADD(enrollment_date, INTERVAL 5 MONTH) and DATE_ADD(enrollment_date, INTERVAL 6 MONTH)
    ) out_state
set   hops_prep.patient_status_6_months=out_state.codeestado, hops_prep.patient_status_6_months_date=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

/*Use TOBACCO*/
update hops_prep,
( select  p.patient_id,
      encounter_datetime encounter_datetime,
      case o.value_coded
      when 1388 then 'TOBACCO USE'
       else null end as cod
  from hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and o.obs_datetime=e.encounter_datetime
  and o.concept_id=1389) obs
set hops_prep.tobacco_use=obs.cod
where hops_prep.patient_id=obs.patient_id;

/*Use ALCOHOL*/
update hops_prep,
( select  p.patient_id,
      encounter_datetime encounter_datetime,
      case o.value_coded
      when 1603 then 'ALCOHOL USE'
       else null end as cod
  from hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and o.obs_datetime=e.encounter_datetime
  and o.concept_id=1389) obs
set hops_prep.alcohol_use=obs.cod
where hops_prep.patient_id=obs.patient_id;

/*Use INTRAVENOUS DRUG USE*/
update hops_prep,
( select  p.patient_id,
      encounter_datetime encounter_datetime,
      case o.value_coded
      when 105 then 'INTRAVENOUS DRUG USE'
       else null end as cod
  from hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and o.obs_datetime=e.encounter_datetime
  and o.concept_id=1389) obs
set hops_prep.intravenous_drug_use=obs.cod
where hops_prep.patient_id=obs.patient_id;

/*Family planning*/
update hops_prep,
(
Select  p.patient_id,  min(encounter_datetime) encounter_datetime,  
case   o.value_coded     
        when 5279  then 'INJECTABLE CONTRACEPTIVES'
        when 5278  then 'DIAPHRAGM'
        when 5275  then 'INTRAUTERINE DEVICE'
        when 5622  then 'Other'
        when 5276  then 'FEMALE STERILIZATION'
        when 190   then 'CONDOMS'
        when 780   then 'ORAL CONTRACEPTION'
        when 5277  then 'NATURAL FAMILY PLANNING'
        when 1107  then 'NONE'
        when 23714 then 'VASECTOMY'
        when 23715 then 'LACTATIONAL AMENORRAY METHOD'
        when 21928 then 'Implant'
        else null end as value_cod
  from  hops_prep p
       inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=374
  group by p.patient_id)
  family,obs
set hops_prep.family_planning_first=family.value_cod, hops_prep.family_planning_date_first=family.encounter_datetime
where hops_prep.patient_id=obs.person_id 
and hops_prep.patient_id=family.patient_id 
and obs.voided=0 and obs.obs_datetime=family.encounter_datetime
and obs.concept_id=374;


/*Estado Actual TARV*/
update hops_prep,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
          when 6 then 'ACTIVE ON PROGRAM (SERVIÇO TARV-TRATAMENTO)'
					when 7 then 'TRASFERRED OUT (SERVIÇO TARV-TRATAMENTO)'
					when 8 then 'SUSPENDED (SERVIÇO TARV-TRATAMENTO)'
					when 9 then 'ART LTFU (SERVIÇO TARV-TRATAMENTO)'
					when 10 then 'DEAD (SERVIÇO TARV-TRATAMENTO)'
          when 29 then 'TRANSFER FROM OTHER FACILITY'
          when 75 then 'ACTIVE ON PROGRAM (PREP)'
          when 76 then 'TRANSFER FROM OTHER FACILITY (PREP)'
          when 77 then 'TRANSFERRED OUT TO ANOTHER FACILITY (PREP)'
          when 78 then 'PATIENT HAS DIED (PREP)'
          when 79 then 'EXIT - HIV POSITIVE TESTED (PREP)'
          when 80 then 'EXIT - NO MORE SUBSTANTIAL RISKS (PREP)'
          when 81 then 'EXIT- SIDE EFFECTS (PREP)'
          when 82 then 'EXIT - USER PREFERENCE (PREP)'
				else null end as codeestado
		from 	hops_prep p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id in (2,25) and ps.state in (6,7,8,9,10,29,75,76,77,78,79,80,81,82) and ps.end_date is null and 
				ps.start_date BETWEEN startDate AND endDate
		) saida
set 	hops_prep.patient_status=saida.codeestado,
hops_prep.patient_status_date=saida.start_date
where saida.patient_id=hops_prep.patient_id;

/*CD4*/
insert into hops_prep_cd4(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=5497 and e.encounter_datetime  < endDate ;

/*LAST CLINIC VISIT*/
update hops_prep,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime < endDate
  group by p.patient_id
)seguimento
set hops_prep.last_clinic_visit=seguimento.encounter_datetime
where hops_prep.patient_id=seguimento.patient_id;

/*NEXT CLINIC VISIT
update  hops_prep,obs
set   scheduled_clinic_visit=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_clinic_visit and 
    concept_id=5096 and voided=0;*/

    /*LAST ART PICKUP*/
update hops_prep,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type=18 and e.encounter_datetime < endDate
  group by p.patient_id
)levantamento
set hops_prep.last_artpickup=levantamento.encounter_datetime
where hops_prep.patient_id=levantamento.patient_id;

update  hops_prep,obs
set   scheduled_artpickp=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_artpickup and 
    concept_id=5096 and voided=0;

/*TB
insert into hops_prep_tb_investigation(patient_id,tb,tb_date)
Select distinct p.patient_id,
    case o.value_coded
             when 703 then 'POSITIVE'
             when 664 then 'NEGATIVE'
             else null end,
      o.obs_datetime
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=6277 and e.encounter_datetime  < endDate;*/

/*LEVANTAMENTO ARV*/
insert into hops_prep_art_pick_up(patient_id,regime,art_date)
  select distinct p.patient_id,
  case   o.value_coded     
             when 1651 then 'AZT+3TC+NVP'
        when 6324 then 'TDF+3TC+EFV'
        when 1703 then 'AZT+3TC+EFV'
        when 6243 then 'TDF+3TC+NVP'
        when 6103 then 'D4T+3TC+LPV/r'
        when 792  then 'D4T+3TC+NVP'
        when 1827 then 'D4T+3TC+EFV'
        when 6102 then 'D4T+3TC+ABC'
        when 6116 then 'AZT+3TC+ABC'
        when 6108 then 'TDF+3TC+LPV/r(2ª Linha)'
        when 6100 then 'AZT+3TC+LPV/r'
        when 6329 then 'TDF+3TC+RAL+DRV/r (3ª Linha)'
        when 6330 then 'AZT+3TC+RAL+DRV/r (3ª Linha)'
        when 6105 then 'ABC+3TC+NVP'
        when 6325 then 'D4T+3TC+ABC+LPV/r (2ª Linha)'
        when 6326 then 'AZT+3TC+ABC+LPV/r (2ª Linha)'
        when 6327 then 'D4T+3TC+ABC+EFV (2ª Linha)'
        when 6328 then 'AZT+3TC+ABC+EFV (2ª Linha)'
        when 6109 then 'AZT+DDI+LPV/r (2ª Linha)'
        when 6110 then 'D4T20+3TC+NVP'
        when 1702 then 'AZT+3TC+NFV'
        when 817  then 'AZT+3TC+ABC'
        when 6104 then 'ABC+3TC+EFV'
        when 6106 then 'ABC+3TC+LPV/r'
        when 6244 then 'AZT+3TC+RTV'
        when 1700 then 'AZT+DDl+NFV'
        when 633  then 'EFV'
        when 625  then 'D4T'
        when 631  then 'NVP'
        when 628  then '3TC'
        when 635  then 'NFV'
        when 797  then 'AZT'
        when 814  then 'ABC'
        when 6107 then 'TDF+AZT+3TC+LPV/r'
        when 6236 then 'D4T+DDI+RTV-IP'
        when 1701 then 'ABC+DDI+NFV'
        when 1311 then 'ABC+3TC+LPV/r (2ª Linha)'
        when 1313 then 'ABC+3TC+EFV (2ª Linha)'
        when 1314 then 'AZT+3TC+LPV (2ª Linha)'
        when 1315 then 'TDF+3TC+EFV (2ª Linha)'
        when 6114 then '3DFC'
        when 6115 then '2DFC+EFV'
        when 6233 then 'AZT+3TC+DDI+LPV'
        when 6234 then 'ABC+TDF+LPV'
        when 6242 then 'D4T+DDI+NVP'
        when 6118 then 'DDI50+ABC+LPV'
        when 23784 then 'TDF+3TC+DTG'
        when 23799 then 'TDF+3TC+DTG (2ª Linha)' 
        when 23786 then 'ABC+3TC+DTG'
        when 23790 then 'TDF+3TC+LPV/r+RTV'
        when 23791 then 'TDF+3TC+ATV/r'
        when 23792 then 'ABC+3TC+ATV/r'
        when 23793 then 'AZT+3TC+ATV/r'
        when 23795 then 'ABC+3TC+ATV/r+RAL'
        when 23796 then 'TDF+3TC+ATV/r+RAL'
        when 23801 then 'AZT+3TC+RAL'
        when 23802 then 'AZT+3TC+DRV/r'
        when 23815 then 'AZT+3TC+DTG'
        when 23797 then 'ABC+3TC++RAL+DRV/r'
        when 23798 then '3TC+RAL+DRV/r'
        when 23803 then 'AZT+3TC+RAL+DRV/r'
        when 23785 then 'TDF+3TC+DTG2'
        when 23800 then 'ABC+3TC+DTG (2ª Linha)'
        when 165261 then 'TDF+3TC+RAL'
        when 165262 then 'ABC+3TC+RAL' 
        when 165215 then 'TDF/FTC' 
        when 23787 then 'ABC+AZT+LPV/r'
        when 23789 then 'TDF+AZT+LPV/r'
        when 23788 then 'TDF+ABC+3TC+LPV/r'
        else null end,
        encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and e.encounter_datetime  < endDate;

/*PROXIMO LEVANTAMENTO*/
update hops_prep_art_pick_up,obs 
set  hops_prep_art_pick_up.next_art_date=obs.value_datetime
where   hops_prep_art_pick_up.patient_id=obs.person_id and
    hops_prep_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

/*ART NUMBER OF PILLS*/
update hops_prep_art_pick_up,obs 
set  hops_prep_art_pick_up.number_of_pills=obs.value_numeric
where   hops_prep_art_pick_up.patient_id=obs.person_id and
    hops_prep_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=1715 and 
    obs.voided=0;

    /*LEVANTAMENTO ARV RECEPTION*/
insert into hops_prep_art_pick_up_reception_art(patient_id,art_date)
  select distinct p.patient_id,
        o.value_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=52 and o.concept_id=23866  and e.voided=0 
  and p.patient_id=o.person_id and o.value_datetime <= endDate;


/*PROXIMO  ARV RECEPTION LEVANTAMENTO*/
update hops_prep_art_pick_up_reception_art,obs 
set  hops_prep_art_pick_up_reception_art.next_art_date=DATE_ADD(hops_prep_art_pick_up_reception_art.art_date, INTERVAL 30 DAY);


/*LEVANTAMENTO Regime*/
insert into hops_prep_art_regimes(patient_id,regime,regime_date)
  select distinct p.patient_id,
  case   o.value_coded     
                when 1651 then 'AZT+3TC+NVP'
        when 6324 then 'TDF+3TC+EFV'
        when 1703 then 'AZT+3TC+EFV'
        when 6243 then 'TDF+3TC+NVP'
        when 6103 then 'D4T+3TC+LPV/r'
        when 792  then 'D4T+3TC+NVP'
        when 1827 then 'D4T+3TC+EFV'
        when 6102 then 'D4T+3TC+ABC'
        when 6116 then 'AZT+3TC+ABC'
        when 6108 then 'TDF+3TC+LPV/r(2ª Linha)'
        when 6100 then 'AZT+3TC+LPV/r'
        when 6329 then 'TDF+3TC+RAL+DRV/r (3ª Linha)'
        when 6330 then 'AZT+3TC+RAL+DRV/r (3ª Linha)'
        when 6105 then 'ABC+3TC+NVP'
        when 6325 then 'D4T+3TC+ABC+LPV/r (2ª Linha)'
        when 6326 then 'AZT+3TC+ABC+LPV/r (2ª Linha)'
        when 6327 then 'D4T+3TC+ABC+EFV (2ª Linha)'
        when 6328 then 'AZT+3TC+ABC+EFV (2ª Linha)'
        when 6109 then 'AZT+DDI+LPV/r (2ª Linha)'
        when 6110 then 'D4T20+3TC+NVP'
        when 1702 then 'AZT+3TC+NFV'
        when 817  then 'AZT+3TC+ABC'
        when 6104 then 'ABC+3TC+EFV'
        when 6106 then 'ABC+3TC+LPV/r'
        when 6244 then 'AZT+3TC+RTV'
        when 1700 then 'AZT+DDl+NFV'
        when 633  then 'EFV'
        when 625  then 'D4T'
        when 631  then 'NVP'
        when 628  then '3TC'
        when 635  then 'NFV'
        when 797  then 'AZT'
        when 814  then 'ABC'
        when 6107 then 'TDF+AZT+3TC+LPV/r'
        when 6236 then 'D4T+DDI+RTV-IP'
        when 1701 then 'ABC+DDI+NFV'
        when 1311 then 'ABC+3TC+LPV/r (2ª Linha)'
        when 1313 then 'ABC+3TC+EFV (2ª Linha)'
        when 1314 then 'AZT+3TC+LPV (2ª Linha)'
        when 1315 then 'TDF+3TC+EFV (2ª Linha)'
        when 6114 then '3DFC'
        when 6115 then '2DFC+EFV'
        when 6233 then 'AZT+3TC+DDI+LPV'
        when 6234 then 'ABC+TDF+LPV'
        when 6242 then 'D4T+DDI+NVP'
        when 6118 then 'DDI50+ABC+LPV'
        when 23784 then 'TDF+3TC+DTG'
        when 23799 then 'TDF+3TC+DTG (2ª Linha)' 
        when 23786 then 'ABC+3TC+DTG'
        when 23790 then 'TDF+3TC+LPV/r+RTV'
        when 23791 then 'TDF+3TC+ATV/r'
        when 23792 then 'ABC+3TC+ATV/r'
        when 23793 then 'AZT+3TC+ATV/r'
        when 23795 then 'ABC+3TC+ATV/r+RAL'
        when 23796 then 'TDF+3TC+ATV/r+RAL'
        when 23801 then 'AZT+3TC+RAL'
        when 23802 then 'AZT+3TC+DRV/r'
        when 23815 then 'AZT+3TC+DTG'
        when 23797 then 'ABC+3TC++RAL+DRV/r'
        when 23798 then '3TC+RAL+DRV/r'
        when 23803 then 'AZT+3TC+RAL+DRV/r'
        when 23785 then 'TDF+3TC+DTG2'
        when 23800 then 'ABC+3TC+DTG (2ª Linha)'
        when 165261 then 'TDF+3TC+RAL'
        when 165262 then 'ABC+3TC+RAL' 
        when 165215 then 'TDF/FTC' 
        when 23787 then 'ABC+AZT+LPV/r'
        when 23789 then 'TDF+AZT+LPV/r'
        when 23788 then 'TDF+ABC+3TC+LPV/r'
        else null end,
        encounter_datetime
  from hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type in (6,53) and o.concept_id=1087  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; 



/*CARGA VIRAL*/
insert into hops_prep_cv(patient_id,cv,cv_qualit,cv_date,request_id)
select valor.patient_id,valor.value_numeric,valor.value_cod,valor.obs_datetime,requisicao.value_text
from
(Select p.patient_id,
    o.value_numeric,
    case o.value_coded
    when 1306 then 'BEYOND DETECTABLE LIMIT'
    when 1304 then 'POOR SAMPLE QUALITY'
    when 23814 then 'UNDETECTABLE VIRAL LOAD'
    when 23907 then 'LESS THAN 40 COPIES/ML'
    when 23905 then 'LESS THAN 10 COPIES/ML'
    when 23904 then 'LESS THAN 839 COPIES/ML'
    when 23906 then 'LESS THAN 20 COPIES/ML'
    when 23908 then 'LESS THAN 400 COPIES/ML'
    when 165331 then 'LESS THAN'
     else null end as value_cod,
	o.obs_datetime,
    e.encounter_id
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (856,1305) and e.encounter_datetime  between startDate and endDate
)  valor 
left join
(
Select p.patient_id,
    o.value_numeric,
    o.obs_datetime,
    o.value_text,
    e.encounter_id
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (22771) and e.encounter_datetime  between startDate and endDate 
) requisicao on valor.encounter_id= requisicao.encounter_id
group by valor.patient_id,valor.value_numeric,valor.encounter_id; 

/*VISITAS*/
insert into hops_prep_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime  < endDate;

/* PROXIMA VISITAS*/
update hops_prep_visit,obs 
set  hops_prep_visit.next_visit_date=obs.value_datetime
where   hops_prep_visit.patient_id=obs.person_id and
    hops_prep_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;


update hops_prep,location
set hops_prep.health_facility=location.name
where hops_prep.location_id=location.location_id;


/*TB start Date*/
insert into hops_prep_start_tb_treatment(patient_id,start_tb_treatment)
Select distinct p.patient_id, min(encounter_datetime) encounter_datetime
from  hops_prep p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=1113 and o.voided=0 and e.encounter_datetime  < endDate
  group by p.patient_id;


  /*TB end Date*/
insert into hops_prep_end_tb_treatment(patient_id,end_tb_treatment)
Select distinct p.patient_id, max(encounter_datetime) encounter_datetime
from  hops_prep p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=6120 and e.encounter_datetime  < endDate
  group by p.patient_id;



/*DMC DISPENSATION VISIT*/
insert into hops_prep_type_of_dispensation_visit(patient_id,date_elegibbly_dmc)
Select distinct p.patient_id,e.encounter_datetime 
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set hops_prep_type_of_dispensation_visit.elegibbly_dmc=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and obs.concept_id=23765 and obs.voided=0 and
        obs.obs_datetime=hops_prep_type_of_dispensation_visit.date_elegibbly_dmc
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

/*PROXIMO GAAC*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="GAAC", 
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23724 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

    /*PROXIMO AF*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="AF",
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23725 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

        /*PROXIMO CA*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="CA",
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23726 and obs.voided=0
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

            /*PROXIMO PU*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="PU",
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and obs.concept_id=23727 and obs.voided=0 
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


            /*PROXIMO FR*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="FR",
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23729 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                /*PROXIMO DT*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="DT",
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23730 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                    /*PROXIMO DT*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="DC",
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23731 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


                    /*PROXIMO DS*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc="DS",
hops_prep_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23888 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                        /*PROXIMO OUTRO*/
update hops_prep_type_of_dispensation_visit,obs,encounter 
set  hops_prep_type_of_dispensation_visit.type_dmc=obs.value_text
where   hops_prep_type_of_dispensation_visit.patient_id=obs.person_id and
    hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23732 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_prep_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;



/*ALT */
insert into hops_prep_alanine_transferase(patient_id,alanine_value,alt_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0  and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=654
GROUP BY p.patient_id;

/*CREATININE*/
insert into hops_prep_creatinine(patient_id,creatinine_value,creatinine_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=790
GROUP BY p.patient_id;

/*CTX*/
insert into hops_prep_ctx(patient_id,prescrition,prescrition_date)
Select distinct p.patient_id,
    case o.value_coded
    when 1065 then "CLOTRIMAZOLE"
	else null end,
    o.obs_datetime
from  hops_prep p  
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=6 and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=6121;


/*PREP PATIENT INICIAL SITUATION*/
insert into hops_prep_initial_situation(patient_id,prep_patient_situation,prep_patient_situation_date)
  select distinct p.patient_id,
  case   o.value_coded     
        when 1256 then 'START FIRST TIME PREP'
        when 1705 then 'RESTART PREP'
        when 1257 then 'CONTINUE REGIMEN PREP'
        else null end,
        encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=80 and o.concept_id=165296  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and e.encounter_datetime  < endDate;


/*VISITAS SEGUIMENTO PREP*/
insert into hops_prep_clinical_visit(patient_id,clinical_visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type=81 and e.encounter_datetime BETWEEN startDate AND endDate;

/*PROXIMA VISITAS SEGUIMENTO PREP*/
update hops_prep_clinical_visit,obs 
set  hops_prep_clinical_visit.next_clinical_visit_date=obs.value_datetime
where   hops_prep_clinical_visit.patient_id=obs.person_id and
    hops_prep_clinical_visit.clinical_visit_date=obs.obs_datetime and 
    obs.concept_id=165228 and 
    obs.voided=0;

/*PREP stock drug */
insert into hops_prep_pills_left(patient_id,pills_left_over,visit_date)
  select distinct p.patient_id, o.value_numeric, e.encounter_datetime
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=81 and o.concept_id=1713  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and e.encounter_datetime  < endDate;


/*PREP DRUG REPEAT PRESCRITION*/
insert into hops_prep_drug_repeat_prescrition(patient_id,arv_prescribed,clinical_visit_date,nr_bottles,next_clinical_visit_date)
  select valor.patient_id, valor.value_cod, valor.encounter_datetime,requisicao.value_numeric, nextvisit.value_datetime
  from
  (Select p.patient_id,
  case   o.value_coded     
        when 165214 then 'TDF/3TC'
        when 165215 then 'TDF/FTC'
        when 165216 then 'OTHER DRUG PREP'
        when 165224 then 'SEM PRESCRICAO'
        else null end as value_cod,
	e.encounter_datetime,
    e.encounter_id
  from  hops_prep p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   encounter_type=81 and o.concept_id=165213  and e.voided=0 
  and p.patient_id=o.person_id 
)  valor 
left join
(
Select p.patient_id,
    o.value_coded,
    e.encounter_datetime,
    o.value_numeric,
    e.encounter_id
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=81 and o.concept_id in (165217) 
) requisicao on valor.encounter_id= requisicao.encounter_id
left join
(Select p.patient_id,
    o.value_coded,
    e.encounter_datetime,
    o.value_numeric,
    e.encounter_id,
    o.value_datetime
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=81 and o.concept_id in (165228) 
) nextvisit on valor.encounter_id= nextvisit.encounter_id;


/*family planning*/
insert into hops_prep_family_planning(patient_id,family_planning,family_planning_date)
Select  p.patient_id,   
case   o.value_coded     
        when 5279  then 'INJECTABLE CONTRACEPTIVES'
        when 5278  then 'DIAPHRAGM'
        when 5275  then 'INTRAUTERINE DEVICE'
        when 5622  then 'Other'
        when 5276  then 'FEMALE STERILIZATION'
        when 190   then 'CONDOMS'
        when 780   then 'ORAL CONTRACEPTION'
        when 5277  then 'NATURAL FAMILY PLANNING'
        when 1107  then 'NONE'
        when 23714 then 'VASECTOMY'
        when 23715 then 'LACTATIONAL AMENORRAY METHOD'
        when 21928 then 'Implant'
        else null end as value_cod, encounter_datetime
  from  hops_prep p
       inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=374 and e.encounter_datetime  < endDate;

/* Urban and Main*/
update hops_prep set urban='N';

update hops_prep set main='N';

if district='Quelimane' then
  update hops_prep set urban='Y'; 
end if;

if district='Namacurra' then
  update hops_prep set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update hops_prep set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update hops_prep set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update hops_prep set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update hops_prep set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update hops_prep set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update hops_prep set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update hops_prep set main='Y' where location_id in (4,55); 
end if;

end
;;
DELIMITER ;



