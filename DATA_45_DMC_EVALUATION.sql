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
  `cv_first` decimal(12,2) DEFAULT NULL,
  `cv_first_date` datetime DEFAULT NULL,
  `partner_status_at_enrollment` varchar(100) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(1) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_at_art_initiation` varchar(4) DEFAULT NULL,
  `WHO_clinical_stage_at_art_initiation_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_prior_VL` varchar(4) DEFAULT NULL, /*MISSIN*/
  `WHO_clinical_stage_prior_VL_date` datetime DEFAULT NULL, /*MISSING*/
  `WHO_clinical_stage_last` varchar(4) DEFAULT NULL, 
  `WHO_clinical_stage_last_date` datetime DEFAULT NULL, 
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `weight_art_initiation` double DEFAULT NULL,
  `weight_art_initiation_date` datetime DEFAULT NULL,
  `height_art_initiation` double DEFAULT NULL,
  `height_art_initiation_date` datetime DEFAULT NULL,
  `weight_prior_VL` double DEFAULT NULL,/*MISSING*/
  `weight_prior_VL_date` datetime DEFAULT NULL,/*MISSING*/
  `height_prior_VL` double DEFAULT NULL,/*MISSING*/
  `height_prior_VL_date` datetime DEFAULT NULL,/*MISSING*/
  `weight_last` double DEFAULT NULL, 
  `weight_last_date` datetime DEFAULT NULL,
  `height_last` double DEFAULT NULL,
  `height_last_date` datetime DEFAULT NULL,
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `Date_cd4_cell_count_at_enrollment` datetime DEFAULT NULL,
  `CD4_result_at_enrollment` varchar(100) DEFAULT NULL, 
  `Date_CD4_cell_count_at_ART_initiation`  datetime DEFAULT NULL,
  `CD4_cell_count_at_ART_initiation` varchar(100) DEFAULT NULL,
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
  `who_stage`  varchar(4) DEFAULT NULL,
  `who_stage_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_weight`;
CREATE TABLE `dmc_weight` (
  `patient_id` int(11) DEFAULT NULL,
  `weight`  varchar(10) DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_height`;
CREATE TABLE `dmc_height` (
  `patient_id` int(11) DEFAULT NULL,
  `height`  varchar(10) DEFAULT NULL,
  `height_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_art_pick_up`;
CREATE TABLE IF NOT EXISTS `dmc_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dmc_cv`;
CREATE TABLE `dmc_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `copies_cv` decimal(12,2) DEFAULT NULL,
  `logs_cv` decimal(12,2) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL,
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
  `regime` varchar(100) DEFAULT NULL,
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

TRUNCATE TABLE dmc_patient;
TRUNCATE TABLE dmc_visit;
TRUNCATE TABLE dmc_WHO_clinical_stage;
TRUNCATE TABLE dmc_weight;
TRUNCATE TABLE dmc_height;
TRUNCATE TABLE dmc_art_pick_up;
TRUNCATE TABLE dmc_cv;
TRUNCATE TABLE dmc_type_of_dispensation_visit;
TRUNCATE TABLE dmc_regimes;
TRUNCATE TABLE dmc_support_groups_visit;

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

Update dmc_patient set dmc_patient.district=district;

update dmc_patient,location
set dmc_patient.health_facility=location.name
where dmc_patient.location_id=location.location_id;


/*DATA DE NASCIMENTO*/
UPDATE dmc_patient,
       person
SET dmc_patient.date_of_birth=person.birthdate
WHERE dmc_patient.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update dmc_patient,person set dmc_patient.age_enrollment=round(datediff(dmc_patient.enrollment_date,person.birthdate)/365)
where  person_id=dmc_patient.patient_id;

delete from dmc_patient where age_enrollment<15;

  /*Sexo*/
update dmc_patient,person set dmc_patient.sex=.person.gender
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

/*Carga Viral*/
update dmc_patient,
  ( Select  p.patient_id,o.value_numeric cv, min(e.encounter_datetime) data_carga
    from  patient p 
        inner join encounter e on p.patient_id=e.patient_id 
        inner join obs o on o.encounter_id=e.encounter_id
    where   e.voided=0 and o.voided=0 and
        e.encounter_type in (6,9,13,53) and o.concept_id=856 and o.obs_datetime between startDate and endDate
    group by p.patient_id
  ) cargaviral
set dmc_patient.cv_first=cargaviral.cv, dmc_patient.cv_first_date=cargaviral.data_carga
where dmc_patient.patient_id=cargaviral.patient_id;

/*ESTADIO OMS VL*/
update dmc_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from dmc_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime and e.encounter_datetime<=p.cv_first_date and p.cv_first_date is not null
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set dmc_patient.WHO_clinical_stage_prior_VL=stage.cod,
dmc_patient.WHO_clinical_stage_prior_VL_date=stage.encounter_datetime
where dmc_patient.patient_id=stage.patient_id 
and dmc_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;

/*PESO VL*/
update dmc_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  dmc_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089  and o.obs_datetime=e.encounter_datetime 
  and e.encounter_datetime<=p.cv_first_date and p.cv_first_date is not null
  and o.concept_id=5089
  group by p.patient_id
)peso,obs
set dmc_patient.weight_prior_VL=obs.value_numeric, dmc_patient.weight_prior_VL_date=peso.encounter_datetime
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA VL*/
update dmc_patient,
( select  p.patient_id as patient_id,
      max(encounter_datetime) encounter_datetime
      from  dmc_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.concept_id=5090 and o.obs_datetime=e.encounter_datetime  
  and e.encounter_datetime<=p.cv_first_date and p.cv_first_date is not null
  group by p.patient_id
)altura,obs
set dmc_patient.height_prior_VL=obs.value_numeric, dmc_patient.height_prior_VL_date=altura.encounter_datetime
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


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

/*ESCOLARIDADE*/
update dmc_patient,obs
set dmc_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=dmc_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update dmc_patient,obs
set dmc_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=dmc_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO DO PARCEIRO*/
update dmc_patient,obs
set dmc_patient.partner_status_at_enrollment= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=dmc_patient.patient_id and obs.concept_id=1449 and obs.voided=0; 

/*ESTADIO OMS AT ENROLLMENT*/
update dmc_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set dmc_patient.WHO_clinical_stage_at_enrollment=stage.cod,
dmc_patient.WHO_clinical_stage_at_enrollment_date=stage.encounter_datetime
where dmc_patient.patient_id=stage.patient_id 
and dmc_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;

/*ESTADIO OMS AT ART INITIATION*/
update dmc_patient,
( select  p.patient_id,
      encounter_datetime encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime
  and o.concept_id=5356
)stage,obs
set dmc_patient.WHO_clinical_stage_at_art_initiation=stage.cod,
dmc_patient.WHO_clinical_stage_at_art_initiation_date=stage.encounter_datetime
where dmc_patient.patient_id=stage.patient_id 
and stage.encounter_datetime=dmc_patient.date_of_ART_initiation
and dmc_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;

/*ESTADIO OMS AT ART EXTRACTION DATE*/
update dmc_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set dmc_patient.WHO_clinical_stage_last=stage.cod,
dmc_patient.WHO_clinical_stage_last_date=stage.encounter_datetime
where dmc_patient.patient_id=stage.patient_id 
and dmc_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/*PESO AT TIME OF ART ENROLLMENT*/
update dmc_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set dmc_patient.weight_enrollment=obs.value_numeric, dmc_patient.weight_date=peso.encounter_datetime
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update dmc_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set dmc_patient.height_enrollment=obs.value_numeric, dmc_patient.height_date=altura.encounter_datetime
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*PESO AT TIME OF ART INITIATION*/
update dmc_patient,
( select  p.patient_id,
      encounter_datetime encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089 
  
)peso,obs
set dmc_patient.weight_art_initiation=obs.value_numeric, dmc_patient.weight_art_initiation_date=peso.encounter_datetime  
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=peso.patient_id 
and peso.encounter_datetime=dmc_patient.date_of_ART_initiation
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;
  
/*ALTURA AT TIME OF ART INITIATION*/
update dmc_patient,
( select  p.patient_id as patient_id,
      encounter_datetime encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  
)altura,obs
set dmc_patient.height_art_initiation=obs.value_numeric, dmc_patient.height_art_initiation_date=altura.encounter_datetime
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=altura.patient_id 
and altura.encounter_datetime=dmc_patient.date_of_ART_initiation
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;

/*PESO AT TIME OF ART ENROLLMENT*/
update dmc_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set dmc_patient.weight_enrollment=obs.value_numeric, dmc_patient.weight_date=peso.encounter_datetime
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;


/*ALTURA AT TIME OF EXTRACTION*/
update dmc_patient,
( select  p.patient_id as patient_id,
      max(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set dmc_patient.height_last=obs.value_numeric, dmc_patient.height_last_date=altura.encounter_datetime
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*PESO AT TIME OF EXTRACTION*/
update dmc_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set dmc_patient.weight_last=obs.value_numeric, dmc_patient.weight_last_date=peso.encounter_datetime  
where dmc_patient.patient_id=obs.person_id 
and dmc_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*CD4 Enrollment*/
update dmc_patient,
(	select 	e.patient_id,
			min(encounter_datetime) encounter_datetime
	from 	dmc_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between p.enrollment_date and date_add(p.enrollment_date, interval 1 month) and o.concept_id=5497
	group by p.patient_id
)seguimento,obs
set dmc_patient.Date_cd4_cell_count_at_enrollment=seguimento.encounter_datetime,
dmc_patient.CD4_result_at_enrollment=obs.value_numeric
where dmc_patient.patient_id=seguimento.patient_id AND
dmc_patient.patient_id=obs.person_id 
and obs.voided=0 and obs.obs_datetime=seguimento.encounter_datetime
and obs.concept_id=5497;

/*update 	dmc_patient,obs 
set 	dmc_patient.CD4_result_at_enrollment=obs.value_numeric
where 	dmc_patient.patient_id=obs.person_id and obs.obs_datetime=dmc_patient.Date_cd4_cell_count_at_enrollment and obs.concept_id=5497 and obs.voided=0;*/


/*CD4 on ART Initiation*/
update dmc_patient,
(	select 	e.patient_id,

			max(encounter_datetime) encounter_datetime
	from 	dmc_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between date_add(p.date_of_ART_initiation, interval -6 month) and date_add(p.date_of_ART_initiation, interval 2 month) and o.concept_id=5497
	group by p.patient_id
)seguimento
set dmc_patient.Date_CD4_cell_count_at_ART_initiation=seguimento.encounter_datetime
where dmc_patient.patient_id=seguimento.patient_id;

update 	dmc_patient,obs 
set 	dmc_patient.CD4_cell_count_at_ART_initiation=obs.value_numeric
where 	dmc_patient.patient_id=obs.person_id and obs.obs_datetime=dmc_patient.date_of_ART_initiation and obs.concept_id=5497 and obs.voided=0;


/*PMC ENTRY AND EXIT DATE*/
update dmc_patient, patient_program
	set dmc_patient.pmtct_entry_date=date_enrolled
	where voided=0 and program_id=8 and dmc_patient.patient_id=patient_program.patient_id;

update dmc_patient, patient_program
	set dmc_patient.pmtct_exit_date=date_completed
	where voided=0 and program_id=8 and dmc_patient.patient_id=patient_program.patient_id;

/*CD4 on CV
update dmc_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	dmc_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between date_add(cv_first_date, interval -1 month) and date_add(cv_first_date, interval 2 month) and o.concept_id=5497
	group by p.patient_id
)seguimento
set dmc_patient.cd4_consultation_date=seguimento.encounter_datetime
where dmc_patient.patient_id=seguimento.patient_id;

update 	dmc_patient,obs 
set 	dmc_patient.cd4_consultation=obs.value_numeric
where 	dmc_patient.patient_id=obs.person_id and obs.obs_datetime=dmc_patient.cd4_consultation_date and obs.concept_id=5497 and obs.voided=0;
*/


/*Estado Actual TARV*/
update dmc_patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	patient p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
				ps.start_date<=endDate
		) saida
set 	dmc_patient.patient_status=saida.codeestado
/*dmc_patient.patient_status_date=saida.start_date*/
where saida.patient_id=dmc_patient.patient_id;

/*Enrollement in GAAC*/
update dmc_patient set dmc_patient.enrolled_in_GAAC='YES' where dmc_patient.patient_id in (select member_id from gaac_member);

/*GAAC START DATE*/
update dmc_patient,gaac_member set dmc_patient.gaac_start_date=gaac_member.start_date where gaac_member.member_id=dmc_patient.patient_id ;

/*GAAC END DATE*/
update dmc_patient,gaac_member set dmc_patient.gaac_end_date=gaac_member.end_date where gaac_member.member_id=dmc_patient.patient_id; 

  /*GAAC IDENTIFIER*/
update dmc_patient,gaac_member, gaac set dmc_patient.gaac_identifier=gaac.gaac_identifier where gaac_member.member_id=dmc_patient.patient_id and gaac_member.gaac_id=gaac.gaac_id; 

/*ESTADO ACTUAL DO STATUS DMC*/
update dmc_patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	patient p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
				ps.start_date<=endDate
		) saida
set 	dmc_patient.current_status_in_DMC=saida.codeestado
/*dmc_patient.patient_status_date=saida.start_date*/
where saida.patient_id=dmc_patient.patient_id;

/*VISITAS*/
insert into dmc_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  dmc_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/* PROXIMA VISITAS*/
update dmc_visit,obs 
set  dmc_visit.next_visit_date=obs.value_datetime
where   dmc_visit.patient_id=obs.person_id and
    dmc_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;
    

/*Clinical Stage*/
insert into dmc_WHO_clinical_stage (patient_id, who_stage,who_stage_date)
 select  p.patient_id,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod,
      encounter_datetime encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  AND p.patient_id IN (SELECT patient_id FROM dmc_patient)
  and o.concept_id=5356;


/*Weight*/
insert into dmc_weight (patient_id,Weight,weight_date)
  select  p.patient_id,
o.value_numeric,
      encounter_datetime encounter_datetime
  from  patient p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) AND p.patient_id 	in (select patient_id from dmc_patient)
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089;


/*Height*/
insert into dmc_height (patient_id, height, height_date)
select  p.patient_id as patient_id, o.value_numeric,
      encounter_datetime encounter_datetime
            from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  AND p.patient_id in (select patient_id from dmc_patient);


/*LEVANTAMENTO AMC_ART*/
insert into dmc_art_pick_up(patient_id,regime,art_date)
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
        when 6100 then 'AZT+3TC+LPV/r(2ª Linha)'
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
        else null end,
        encounter_datetime
  from dmc_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; /*por confirmar*/


/*PROXIMO LEVANTAMENTO*/
update dmc_art_pick_up,obs 
set  dmc_art_pick_up.next_art_date=obs.value_datetime
where   dmc_art_pick_up.patient_id=obs.person_id and
    dmc_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and obs.voided=0; /*por confirmar*/


/*DMC CARGA VIRAL LABORATORIO*/
insert into dmc_cv(patient_id,copies_cv,cv_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"LABORATORY"
from  dmc_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 
and o.concept_id=856 and o.obs_datetime < endDate;

/*DMC CARGA VIRAL SEGUIMENTO*/
insert into dmc_cv(patient_id,copies_cv,cv_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"FOLLOW_UP"
from  dmc_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=9
and o.concept_id=1518 and  o.obs_datetime < endDate;

/*DMC CARGA VIRAL LOGS*/
update dmc_cv,obs 
set  dmc_cv.logs_cv=obs.value_numeric
where  dmc_cv.patient_id=obs.person_id and
    dmc_cv.cv_date=obs.obs_datetime and 
    obs.concept_id=1518 and 
    obs.voided=0;


/*DMC DISPENSATION VISIT*/
insert into dmc_type_of_dispensation_visit(patient_id,date_elegibbly_dmc)
Select distinct p.patient_id,e.encounter_datetime 
from  dmc_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC*/
update dmc_type_of_dispensation_visit,obs,encounter 
set dmc_type_of_dispensation_visit.elegibbly_dmc=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  dmc_type_of_dispensation_visit.patient_id=obs.person_id and obs.concept_id=23765 and obs.voided=0 and
        obs.obs_datetime=dmc_type_of_dispensation_visit.date_elegibbly_dmc
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

/*PROXIMO GAAC*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="GAAC", 
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23724 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

    /*PROXIMO AF*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="AF",
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23725 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

        /*PROXIMO CA*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="CA",
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23726 and obs.voided=0
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

            /*PROXIMO PU*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="PU",
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and obs.concept_id=23727 and obs.voided=0 
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


            /*PROXIMO FR*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="FR",
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23729 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                /*PROXIMO DT*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="DT",
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23730 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                    /*PROXIMO DT*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="DC",
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23731 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


                    /*PROXIMO DS*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc="DS",
dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23888 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                        /*PROXIMO OUTRO*/
update dmc_type_of_dispensation_visit,obs,encounter 
set  dmc_type_of_dispensation_visit.type_dmc=obs.value_text
where   dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23732 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


/*LEVANTAMENTO Regime*/
insert into dmc_regimes(patient_id,regime,regime_date)
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
        when 6100 then 'AZT+3TC+LPV/r(2ª Linha)'
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
        else null end,
        encounter_datetime
  from dmc_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=6 and o.concept_id=1087  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; 


/*DMC DISPENSATION VISIT GROUP*/
insert into dmc_support_groups_visit(patient_id,date_elegibbly_support_groups)
Select distinct p.patient_id,e.encounter_datetime 
from  dmc_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC SUPPORT GROUP*/
update dmc_support_groups_visit,obs,encounter 
set dmc_support_groups_visit.elegibbly_support_groups=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  dmc_support_groups_visit.patient_id=obs.person_id and obs.concept_id=23764 and obs.voided=0 and
        obs.obs_datetime=dmc_support_groups_visit.date_elegibbly_support_groups
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

/*TYPE SUPPORT GROUP CRIANCAS REVELADAS*/
update dmc_support_groups_visit,obs,encounter 
set  dmc_support_groups_visit.type_support_groups="CR", 
dmc_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_support_groups_visit.patient_id=obs.person_id and
    dmc_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23753 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

/*TYPE SUPPORT GROUP PAIS E CUIDADORES*/
update dmc_support_groups_visit,obs,encounter 
set  dmc_support_groups_visit.type_support_groups="PC",
dmc_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_support_groups_visit.patient_id=obs.person_id and
    dmc_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23755 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;
 
 /*TYPE SUPPORT GROUP ADOLESCENTES RV*/
update dmc_support_groups_visit,obs,encounter 
set  dmc_support_groups_visit.type_support_groups="AR",
dmc_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_support_groups_visit.patient_id=obs.person_id and
    dmc_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23757 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

 /*TYPE SUPPORT GROUP MAE PARA MAE*/
update dmc_support_groups_visit,obs,encounter 
set  dmc_support_groups_visit.type_support_groups="MPM",
dmc_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   dmc_support_groups_visit.patient_id=obs.person_id and
    dmc_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23759 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

          
/*PROXIMO OUTRO DE APOIO*/
update dmc_support_groups_visit,obs,encounter 
set  dmc_support_groups_visit.type_support_groups=obs.value_text
where   dmc_support_groups_visit.patient_id=obs.person_id and
    dmc_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23772 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and dmc_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

/*URBAN AND MAIN*/
update dmc_patient set urban='N';
update dmc_patient set main='N';
if district='Quelimane' then
  update dmc_patient set urban='Y';
end if;
if district='Namacurra' then
  update dmc_patient set main='Y' where location_id=5;
end if;
if district='Maganja' then
  update dmc_patient set main='Y' where location_id=15;
end if;
if district='Pebane' then
  update dmc_patient set main='Y' where location_id=16;
end if;
if district='Gile' then
  update dmc_patient set main='Y' where location_id=6;
end if;
if district='Molocue' then
  update dmc_patient set main='Y' where location_id=3;
end if;
if district='Mocubela' then
  update dmc_patient set main='Y' where location_id=62;
end if;
if district='Inhassunge' then
  update dmc_patient set main='Y' where location_id=7;
end if;
if district='Ile' then
  update dmc_patient set main='Y' where location_id in (4,55);
end if;
if district='Namarroi' then
  update dmc_patient set main='Y' where location_id in (252);
end if;
if district='Mopeia' then
  update dmc_patient set main='Y' where location_id in (11);
end if;
if district='Morrumbala' then
  update dmc_patient set main='Y' where location_id in (13);
end if;
if district='Gurue' then
  update dmc_patient set main='Y' where location_id in (280);
end if;
if district='Mocuba' then
  update dmc_patient set main='Y' where location_id in (227);
end if;
if district='Nicoadala' then
  update dmc_patient set main='Y' where location_id in (277);
end if;
if district='Milange' then
  update dmc_patient set main='Y' where location_id in (281);
end if;

end
;;
DELIMITER ;

