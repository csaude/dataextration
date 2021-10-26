SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `hops_cpn` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `openmrs_gender`varchar(100) DEFAULT NULL,
  `date_of_delivery` datetime DEFAULT NULL,
  `family_planning` varchar(100) DEFAULT NULL
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_visit_cpn` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_visit_estimate_delivery` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_cpn_type_of_method`;
CREATE TABLE `hops_cpn_type_of_method` (
  `patient_id` int(11) DEFAULT NULL,
  `type_date` datetime DEFAULT NULL,
  `type_of_method` varchar(100) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_cpn_family_planning`;
CREATE TABLE `hops_cpn_family_planning` (
  `patient_id` int(11) DEFAULT NULL,
  `fp_date` datetime DEFAULT NULL,
  `fp` varchar(100) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `hops_cpn_status_each_consultation`;
CREATE TABLE `hops_cpn_status_each_consultation` (
  `patient_id` int(11) DEFAULT NULL,
  `patient__status_date` datetime DEFAULT NULL,
  `patient__status` varchar(100) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hosp_cpn_last_menstrual_period`;
CREATE TABLE `hosp_cpn_last_menstrual_period` (
  `patient_id` int(11) DEFAULT NULL,
  `hosp_cpn_last_menstrual_period_date` datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Procedure structure for HOPS CPN
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillHOPS`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHOPS`(startDate date,endDate date, district varchar(100))
    READS SQL DATA
begin

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE hops_cpn,
       patient_identifier
SET hops_cpn.patient_id=patient_identifier.patient_id, hops_cpn.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=hops_cpn.nid;

update hops_cpn,location
set hops_cpn.health_facility=location.name
where hops_cpn.location_id=location.location_id;

/*SEXO*/
UPDATE hops_cpn,
       person
SET hops_cpn.openmrs_gender=.person.gender
WHERE hops_cpn.patient_id=person.person_id;


/*VISITAS CPN*/
insert into hops_visit_cpn(patient_id,visit_date,source)
Select distinct p.patient_id,e.encounter_datetime,'FICHA CLINICA' 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on e.encounter_id=o.encounter_id
where e.voided=0 and e.encounter_type in (6,9) and o.concept_id in (1982,6332) and o.value_coded=1065 and o.voided=0 and e.encounter_datetime  < endDate;

/*VISITAS CPN*/
insert into hops_visit_cpn(patient_id,visit_date,source)
Select distinct p.patient_id,e.encounter_datetime,'FICHA RESUMO' 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on e.encounter_id=o.encounter_id
where e.voided=0 and e.encounter_type=53 and o.concept_id in (1982,6332) and o.value_coded=1065 and o.voided=0 and e.encounter_datetime  < endDate;

/*VISITAS DATA PREVISTA DO PARTO*/
insert into hops_visit_estimate_delivery(patient_id,visit_date,source)
Select distinct p.patient_id,o.value_datetime,'ADULTO: PROCESSO PARTE A - ANAMNESE' 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on e.encounter_id=o.encounter_id
where e.voided=0 and e.encounter_type=67 and o.concept_id=1600 and o.voided=0 and e.encounter_datetime  < endDate;

/*DATA DO PARTO*/
update hops_cpn,encounter,obs 
set hops_cpn.date_of_delivery=obs.value_datetime
where hops_cpn.patient_id=obs.person_id 
      and encounter.encounter_datetime=obs.obs_datetime 
      and encounter.encounter_type=67
      and obs.concept_id=5599


/*DMC DISPENSATION VISIT*/
update hops_cpn,
(
Select distinct p.patient_id,e.encounter_datetime 
from  dmc_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and o.voided=0 and e.encounter_type in (6,9) 
      and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=23725 
      and o.value_coded in(1256,1257,1267)
 )obs_planning
set hops_cpn.family_planning=case obs_planning.encounter_datetime when is not null then 'YES' else 'NO' end;


/*hops_cpn_type_of_method*/
insert into hops_cpn_type_of_method(patient_id,type_date,type_of_method,source)
  select distinct p.patient_id,e.encounter_datetime
  case  o.value_coded     
        when 1107  then 'NONE'
        when 190   then 'CONDOMS'
        when 780   then  'ORAL CONTRACEPTION'
        when 5279  then 'INJECTABLE CONTRACEPTIVES'
        when 21928 then 'IMPLANT'
        when 5275  then 'INTRAUTERINE DEVICE'
        when 5276  then 'FEMALE STERILIZATION'
        when 23714 then 'VASECTOMY'
        when 23714 then 'LACTATIONAL AMENORRAY METHOD'      
        else null end, "FICHA CLINICA"
  from hops_cpn p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where encounter_type=(6,9) and o.concept_id=374  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; 

  /*hops_cpn_family_planning*/
insert into hops_cpn_family_planning(patient_id,fp_date,source)
Select distinct p.patient_id,e.encounter_datetime,"FICHA CLINICA" 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;


update hops_cpn_family_planning,obs,encounter 
set  hops_cpn_family_planning.fp= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where  hops_cpn_family_planning.patient_id=obs.person_id and
    hops_cpn_family_planning.fp_date=obs.obs_datetime and 
    obs.concept_id=23725 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_cpn_family_planning.fp_date=encounter.encounter_datetime;


  /*hops_cpn_status_each_consultation*/
insert into hops_cpn_status_each_consultation(patient_id,patient__status_date,source)
Select distinct p.patient_id,e.encounter_datetime,"FICHA CLINICA" 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;


update hops_cpn_status_each_consultation,obs,encounter 
set  hops_cpn_status_each_consultation.patient__status= case obs.value_coded
             when 1709 then  'SUSPEND TREATMENT'
             when 1707 then  'DROPPED FROM TREATMENT'
             when 1705 then  'RESTART'
             when 1706 then  'TRANSFERRED OUT TO ANOTHER FACILITY'
             when 1366 then  'PATIENT HAS DIED'
             when 23903 then 'NEGATIVE DIAGNOSIS'
             else null end
where  hops_cpn_status_each_consultation.patient_id=obs.person_id and
    hops_cpn_status_each_consultation.patient__status_date=obs.obs_datetime and 
    obs.concept_id=6273 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_cpn_status_each_consultation.patient__status_date=encounter.encounter_datetime;


  /*hosp_cpn_last_menstrual_period*/
insert into hosp_cpn_last_menstrual_period(patient_id,hosp_cpn_last_menstrual_period_date,source)
Select distinct p.patient_id,o.value_datetime,"FICHA CLINICA" 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=1465;



