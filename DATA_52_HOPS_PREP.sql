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
    `previous_art_enrollment` varchar(3) DEFAULT NULL,
    `previous_art_regimen_before_lftu` varchar(100) DEFAULT NULL,
    `art_regimen_initiation` varchar(100) DEFAULT NULL,
    `art_regimen_re_initiation` varchar(100) DEFAULT NULL,
    `enrollment_date` datetime DEFAULT NULL,
    `art_initiation_date` datetime DEFAULT NULL,
    `WHO_clinical_stage_at_art_initiation` varchar(4) DEFAULT NULL,
    `WHO_clinical_stage_at_art_initiation_date` datetime DEFAULT NULL,
    `previous_date_enrollment_tb` datetime DEFAULT NULL,
    `previous_tb_treatment` varchar(3) DEFAULT NULL,
    `current_enrollment_tb` varchar(100) DEFAULT NULL,
    `current_enrollment_tb_date` datetime DEFAULT NULL,
    `prep_enrollment_date` datetime DEFAULT NULL,
    `prep_initiation_date` datetime DEFAULT NULL,
    `height` double DEFAULT NULL,
    `date_height` date DEFAULT NULL,
    `weight_enr` double DEFAULT NULL,
    `date_weight_enr` date DEFAULT NULL,
    `weight_art` double DEFAULT NULL,
    `date_weight_art` date DEFAULT NULL,
    `bmi_enr` double DEFAULT NULL,
    `date_bmi_enr` datetime DEFAULT NULL,
    `bmi_art` double DEFAULT NULL,
    `date_bmi_art` datetime DEFAULT NULL,
    `hemoglobin_enr` double DEFAULT NULL,
    `date_hemoglobin_enr` datetime DEFAULT NULL,
    `hemoglobin_art` double DEFAULT NULL,
    `date_hemoglobin_art` datetime DEFAULT NULL,
    `blood_pressure_enrollment` int(11)  DEFAULT NULL,
    `alt_enrollment` varchar(100)  DEFAULT NULL,
    `alt_date` datetime  DEFAULT NULL,
    `creatinine_enrollment` varchar(100)  DEFAULT NULL,
    `creatinine_date` datetime  DEFAULT NULL,
    `alt_enrollment` varchar(100)  DEFAULT NULL,
    `patient_status_1_months` varchar(225) DEFAULT NULL,
    `patient_status_1_months_date_` datetime DEFAULT NULL,
    `patient_status_2_months` varchar(225) DEFAULT NULL,
    `patient_status_2_months_date_` datetime DEFAULT NULL,
    `patient_status_3_months` varchar(225) DEFAULT NULL,
    `patient_status_3_months_date_` datetime DEFAULT NULL,
    `patient_status_4_months` varchar(225) DEFAULT NULL,
    `patient_status_4_months_date_` datetime DEFAULT NULL,
    `patient_status_6_months` varchar(225) DEFAULT NULL,
    `patient_status_6_months_date_` datetime DEFAULT NULL,
    `ctx_date` datetime DEFAULT NULL,
    `patient_report_use_intravenous` varchar(100) DEFAULT NULL,
    `patient_report_use_tobacco` varchar(100) DEFAULT NULL,
    `patient_report_use_alcohol` varchar(100) DEFAULT NULL,
    `estimated_pregnant_date`datetime DEFAULT NULL,
    `initiation_familiy_planning_method`varchar(100) DEFAULT NULL,
    `initiation_familiy_planning_method_date`datetime DEFAULT NULL,
    `continuation_familiy_planning_method`varchar(100) DEFAULT NULL,
    `continuation_familiy_planning_method`datetime DEFAULT NULL,
    `patient_outcome_status`varchar(100) DEFAULT NULL,
    `patient_outcome_status_date`datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cd4
-- ----------------------------
CREATE TABLE IF NOT EXISTS `hops_prep_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_cv`;
CREATE TABLE `hops_prep_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hops_prep_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
  `number_of_pills` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_prep_art_pick_up_reception_art` (
  `patient_id` int(11) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_prep_art_regimes`;
CREATE TABLE `hops_prep_art_regimes` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` decimal(12,2) DEFAULT NULL,
  `regime_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `regime_date` (`regime_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_viral_results` (
  `patient_id` int(11) DEFAULT NULL,
  `viral_results_date`   datetime DEFAULT NULL,
  `sample_collection_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_prep_start_tb_treatment` (
  `patient_id` int(11) DEFAULT NULL,
  `start_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_prep_end_tb_treatment` (
  `patient_id` int(11) DEFAULT NULL,
  `end_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_prep_art_pick_ups` (
  `patient_id` int(11) DEFAULT NULL,
  `art_pick_up_date` datetime DEFAULT NULL,
  `next_art_scheduled_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_prep_art_clinic_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `art_visit_date` datetime DEFAULT NULL,
  `next_art_visit_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_prep_prep_pick_ups` (
  `patient_id` int(11) DEFAULT NULL,
  `prep_pick_up_date` datetime DEFAULT NULL,
  `next_prep_pick_up_date` datetime DEFAULT NULL,) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_prep_clinic_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `prep_visit_date` datetime DEFAULT NULL,
  `next_prep_visit_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `Fillhops_prep`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fillhops_prep`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

/*truncate table hops_prep_cd4;
truncate table hops_prep_visit;
truncate table hops_prep_cv;
truncate table hops_prep_tb_investigation;
truncate table hops_prep_start_tb_treatment;
truncate table hops_prep_end_tb_treatment;
truncate table hops_prep_art_regimes;
truncate table hops_prep_type_of_dispensation_visit;
truncate table hops_prep_art_pick_up;
truncate table hops_prep_art_pick_up_reception_art;*/

SET @location:=location_id_parameter;

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE hops_prep,
       patient_identifier
SET hops_prep.patient_id=patient_identifier.patient_id, hops_prep.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=hops_prep.nid;

/*Apagar todos fora desta localização*/
delete from hops_prep where location_id not in (@location);

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
                   from  patient p
                       inner join person pe on pe.person_id = p.patient_id
                       inner join encounter e on p.patient_id=e.patient_id
                       inner join obs o on o.encounter_id=e.encounter_id
                   where   e.voided=0 and o.voided=0 and p.voided=0 and pe.voided = 0 and
                       e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256
                   group by p.patient_id
                   union
            /* Patients on ART who have art start date: ART Start date */
                   Select  p.patient_id,min(value_datetime) data_inicio
                   from  patient p
                       inner join person pe on pe.person_id = p.patient_id
                       inner join encounter e on p.patient_id=e.patient_id
                       inner join obs o on e.encounter_id=o.encounter_id
                   where   p.voided=0 and pe.voided = 0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9,53) and
                       o.concept_id=1190 and o.value_datetime is not null
                   group by p.patient_id
                   union
            /* Patients enrolled in ART Program: OpenMRS Program */
                   select  pg.patient_id,min(date_enrolled) data_inicio
                   from  patient p
                     inner join person pe on pe.person_id = p.patient_id
                     inner join patient_program pg on p.patient_id=pg.patient_id
                   where   pg.voided=0 and p.voided=0 and pe.voided = 0 and program_id=2
                   group by pg.patient_id
                   union
            /*
             * Patients with first drugs pick up date set in Pharmacy: First ART Start Date
             */
                     SELECT  e.patient_id, MIN(e.encounter_datetime) AS data_inicio
                     FROM    patient p
                         inner join person pe on pe.person_id = p.patient_id
                         inner join encounter e on p.patient_id=e.patient_id
                     WHERE   p.voided=0 and pe.voided = 0 and e.encounter_type=18 AND e.voided=0
                     GROUP BY  p.patient_id
                   union
            /* Patients with first drugs pick up date set: Recepcao Levantou ARV */
                   Select  p.patient_id,min(value_datetime) data_inicio
                   from  patient p
                       inner join person pe on pe.person_id = p.patient_id
                       inner join encounter e on p.patient_id=e.patient_id
                       inner join obs o on e.encounter_id=o.encounter_id
                   where   p.voided=0 and pe.voided = 0 and e.voided=0 and o.voided=0 and e.encounter_type=52 and
                       o.concept_id=23866 and o.value_datetime is not null
                   group by p.patient_id
      ) inicio
   GROUP BY patient_id
   )inicio_real
)f
SET hops_prep.previous_art_enrollment=f.estado
WHERE hops_prep.patient_id=f.patient_id;


/*Data de Nascimento*/
update hops_prep,person set hops_prep.openmrs_age=round(datediff(hops_prep.art_initiation_date,person.birthdate)/365)
where  person_id=hops_prep.patient_id;

/*INSCRICAO*/
UPDATE hops_prep,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,
                              7,53)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment
SET hops_prep.enrollment_date=enrollment.data_abertura
WHERE hops_prep.patient_id=enrollment.patient_id;

/*ESTADIO OMS AT ART INITIATION*/
update hops_prep,
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
set hops_prep.WHO_clinical_stage_at_art_initiation=stage.cod,
hops_prep.WHO_clinical_stage_at_art_initiation_date=stage.encounter_datetime
where hops_prep.patient_id=stage.patient_id 
and stage.encounter_datetime=hops_prep.art_initiation_date
and hops_prep.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;

/*ALTURA*/
update hops_prep,
	(	select 	person_id,max(obs_datetime) data_peso
		from 	openmrs.obs
		where 	voided=0 and concept_id=5090 and 
				obs_datetime between dataInicial and dataFinal
		group by person_id
	) altura
set hops_prep.date_height=altura.data_peso
where hops_prep.id=altura.person_id;

update hops_prep,openmrs.obs
set hops_prep.height=obs.value_numeric
where hops_prep.id=obs.person_id and hops_prep.date_height=obs.obs_datetime and obs.voided=0 and obs.concept_id=5090;

/*Peso Na Abertura de Processo*/
update 	hops_prep,openmrs.obs 
set 	hops_prep.weight_enr=obs.value_numeric,
		hops_prep.date_weight_enr=obs.obs_datetime
where 	hops_prep.id=obs.person_id and obs.obs_datetime=hops_prep.date_first_followup and obs.concept_id=5089 and obs.voided=0;

/*Peso no inicio de TARV*/
update hops_prep,
(	select 	e.hops_prep_id,
			max(encounter_datetime) encounter_datetime
	from 	hops_prep p
			inner join openmrs.encounter e on p.id=e.hops_prep_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=5089 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set hops_prep.date_weight_art=seguimento.encounter_datetime
where hops_prep.id=seguimento.hops_prep_id;

update 	hops_prep,openmrs.obs 
set 	hops_prep.weight_art=obs.value_numeric
where 	hops_prep.id=obs.person_id and obs.obs_datetime=hops_prep.date_weight_art and obs.concept_id=5089 and obs.voided=0;

/*IMC Na Abertura de Processo*/
update 	hops_prep,openmrs.obs 
set 	hops_prep.bmi_enr=obs.value_numeric,
		hops_prep.date_bmi_enr=obs.obs_datetime
where 	hops_prep.id=obs.person_id and obs.obs_datetime=hops_prep.date_first_followup and obs.concept_id=1342 and obs.voided=0;

/*PRIMEIRO HEMOGLOBINA*/
update hops_prep,
(	select 	e.hops_prep_id,
			min(encounter_datetime) encounter_datetime
	from 	hops_prep p
			inner join openmrs.encounter e on p.id=e.hops_prep_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between dataInicial and dataFinal and o.concept_id=21
	group by p.id
)seguimento
set hops_prep.date_hemoglobin_enr=seguimento.encounter_datetime
where hops_prep.id=seguimento.hops_prep_id;

update 	hops_prep,openmrs.obs 
set 	hops_prep.hemoglobin_enr=obs.value_numeric
where 	hops_prep.id=obs.person_id and obs.obs_datetime=hops_prep.date_hemoglobin_enr and obs.concept_id=21 and obs.voided=0;


/*HEMOGLOBINA NO INICIO DE TARV*/
update hops_prep,
(	select 	e.hops_prep_id,
			max(encounter_datetime) encounter_datetime
	from 	hops_prep p
			inner join openmrs.encounter e on p.id=e.hops_prep_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=21 and p.date_art_initiation is not null
	group by p.id
)seguimento
set hops_prep.date_hemoglobin_art=seguimento.encounter_datetime
where hops_prep.id=seguimento.hops_prep_id;

update 	hops_prep,openmrs.obs 
set 	hops_prep.hemoglobin_art=obs.value_numeric
where 	hops_prep.id=obs.person_id and obs.obs_datetime=hops_prep.date_hemoglobin_art and obs.concept_id=21 and obs.voided=0;

/*IMC no inicio de TARV*/
update hops_prep,
(	select 	e.hops_prep_id,
			max(encounter_datetime) encounter_datetime
	from 	hops_prep p
			inner join openmrs.encounter e on p.id=e.hops_prep_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=1342 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set hops_prep.date_bmi_art=seguimento.encounter_datetime
where hops_prep.id=seguimento.hops_prep_id;

update 	hops_prep,openmrs.obs 
set 	hops_prep.bmi_art=obs.value_numeric
where 	hops_prep.id=obs.person_id and obs.obs_datetime=hops_prep.date_bmi_art and obs.concept_id=1342 and obs.voided=0;

/*BLOOD PRESSURE AT FIRST ANC VISIT*/
update hops_prep,
(
Select cpn.patient_id, cpn.data_cpn, case obs.value_coded 
when 1065 then 'YES'
when 1066 then 'NO' 
when 1118 then 'NOT DONE'  
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in (11)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=6379 
)updateBP
set hops_prep.blood_pressure_enrollment=updateBP.cod
where hops_prep.patient_id=updateBP.patient_id;


 /*ESTADO ACTUAL TARV 6 MESES*/
update hops_prep,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 6 MONTH)
    ) out_state
set   hops_prep.patient_status_6_months=out_state.codeestado, hops_prep.patient_status_6_months_date_=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 12 MESES*/
update hops_prep,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 12 MONTH)
    ) out_state
set   hops_prep.patient_status_12_months=out_state.codeestado, hops_prep.patient_status_12_months_date_=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 12 MESES*/
update hops_prep,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  hops_prep p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 18 MONTH)
    ) out_state
set   hops_prep.patient_status_18_months=out_state.codeestado, hops_prep.patient_status_18_months_date_=out_state.start_date
where hops_prep.patient_id=out_state.patient_id;


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

/*CARGA VIRAL*/
insert into hops_prep_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  hops_prep p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and e.encounter_datetime  < endDate;



/*NEXT CLINIC VISIT*/
update  hops_prep,obs
set   scheduled_clinic_visit=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_clinic_visit and 
    concept_id=5096 and voided=0;

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

/*TB*/
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
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=6277 and e.encounter_datetime  < endDate;

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
  where   encounter_type=6 and o.concept_id=1087  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; 


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



update hops_prep set hops_prep.enrolled_in_GAAC='YES' where hops_prep.patient_id in (select member_id from gaac_member);

/*GAAC START DATE*/
update hops_prep,gaac_member set hops_prep.gaac_start_date=gaac_member.start_date where gaac_member.member_id=hops_prep.patient_id ;

/*GAAC END DATE*/
update hops_prep,gaac_member set hops_prep.gaac_end_date=gaac_member.end_date where gaac_member.member_id=hops_prep.patient_id; 

  /*GAAC END DATE*/
update hops_prep,gaac_member, gaac set hops_prep.gaac_identifier=gaac.gaac_identifier where gaac_member.member_id=hops_prep.patient_id and gaac_member.gaac_id=gaac.gaac_id; 


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



