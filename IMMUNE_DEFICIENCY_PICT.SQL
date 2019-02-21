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


CREATE TABLE IF NOT EXISTS `immune_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `hiv_entry_point` varchar(100) DEFAULT NULL,
  `partner_status` varchar(100) DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `tb_at_screening` varchar(255) DEFAULT NULL,
  `prophylaxis_isoniazide` varchar(100) DEFAULT NULL,
  `prophylaxis_isoniazide_date` datetime DEFAULT NULL,
  `current_treatment_regimen` varchar(255) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(1) DEFAULT NULL,
  `partner_known_to_be_diagnosed_with_hiv` varchar(255) DEFAULT NULL,
  `partner_enrolled_on_ART` varchar(255) DEFAULT NULL,
  `date_of_diagnosis` datetime DEFAULT NULL,
  `date_of_ART_initiation` datetime DEFAULT NULL,
  `patient_status` varchar(225) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL,
  `last_clinic_visit` datetime DEFAULT NULL,
  `scheduled_clinic_visit` datetime DEFAULT NULL,
  `last_artpickup` datetime DEFAULT NULL,
  `scheduled_artpickp` datetime DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cvgaac_cv
-- ----------------------------
DROP TABLE IF EXISTS `immune_cv`;
CREATE TABLE `immune_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for cd4
-- ----------------------------
CREATE TABLE IF NOT EXISTS `immune_cd4_absulute` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `immune_cd4_percentage` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `immune_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `immune_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP PROCEDURE IF EXISTS `FillTCVGAACTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTIMMUNETable`(startDate date,endDate date,dataAvaliacao date, district varchar(100)) 

READS SQL DATA
begin

truncate table immune_patient;
truncate table immune_cv;
truncate table immune_cd4_absulute;
truncate table immune_cd4_percentage;
truncate table immune_art_pick_up;
truncate table immune_visit;

/*INSCRICAO*/
insert into immune_patient(patient_id, enrollment_date, location_id)
SELECT e.patient_id,min(encounter_datetime) data_abertura, e.location_id
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,7)
     AND e.encounter_datetime   BETWEEN startDate  AND endDate
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id;


update immune_patient,location
set immune_patient.health_facility=location.name
where immune_patient.location_id=location.location_id;

update immune_patient set urban='N';

update immune_patient set main='N';

if district='Quelimane' then
  update immune_patient set urban='Y'; 
end if;

if district='Namacurra' then
  update immune_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update immune_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update immune_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update immune_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update immune_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update immune_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update immune_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update immune_patient set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
  update immune_patient set main='Y' where location_id in (252);
end if;

/*Sexo*/
update immune_patient,person set immune_patient.sex=.person.gender
where  person_id=immune_patient.patient_id;

/*DATA DE NAICIMENTO*/
UPDATE immune_patient,
       person
SET immune_patient.date_of_birth=person.birthdate
WHERE immune_patient.patient_id=person.person_id;


/*UPDATE CODPROVENIENCIA*/
update immune_patient,
    (select   
        p.patient_id,
        case o.value_coded
        when 1595 then 'MEDICAL INPATIENT'
        when 1596 then 'EXTERNAL CONSULTATION'
        when 1414 then 'TB CLINIC - PNCT'
        when 1597 then 'VCT'
        when 1987 then 'VCT - YOUTH'
        when 1598 then 'PMTCT'
        when 1872 then 'CHILD AT RISK CLINIC'
        when 1275 then 'HEALTH CENTER HOSPITALS'
        when 1984 then 'HEALTH UNIT'
        when 1599 then 'PRIVATE PROVIDER'
        when 1932 then 'REFERRED BY A HEALTH PROFESSIONAL'
        when 1387 then 'LABORATORY'
        when 1386 then 'MOBILE CLINIC'
        when 1044 then 'PEDIATRIC TREATMENT'
        when 6304 then 'ATIP'
        when 1986 then 'SECONDARY SITE'
        when 6245 then 'VCT - COMMUNITY'
        when 1699 then 'HOME BASED CARE'
        when 2160 then 'MISSED VISIT'
        when 6288 then 'MATERNAL CHILD HEALTH'
        when 5484 then 'NUTRITIONAL SUPPORT'
        when 6155 then 'TRADITIONAL CLINICIAN'
        when 6303 then 'BASED GENDER VIOLENCE'
        when 6305 then 'COMMUNITY BASED ORGANIZATION'
        else null end as codProv
    from  patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=1594 and e.encounter_type in (5,7) and e.voided=0
    ) proveniencia
set immune_patient.hiv_entry_point=proveniencia.codProv
where proveniencia.patient_id=immune_patient.patient_id;

/*IDADE NA INSCRICAO*/
update immune_patient,person set immune_patient.age_enrollment=round(datediff(immune_patient.enrollment_date,person.birthdate)/365)
where  person_id=immune_patient.patient_id;


/*ESTADO CIVIL*/
update immune_patient,obs
set immune_patient.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=immune_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*ESCOLARIDADE*/
update immune_patient,obs
set immune_patient.education= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=immune_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update immune_patient,obs
set immune_patient.occupation= obs.value_text
where obs.person_id=immune_patient.patient_id and obs.concept_id=1459 and voided=0;


/*ESTADO DO PARCEIRO*/
update immune_patient,obs
set immune_patient.partner_known_to_be_diagnosed_with_hiv= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=immune_patient.patient_id and obs.concept_id=1449 and obs.voided=0;  

/*PROCESSO DO PARCEIRO*/
update immune_patient,obs
set immune_patient.partner_enrolled_on_ART = obs.value_text
where obs.person_id=immune_patient.patient_id and obs.concept_id=1450 and voided=0;


/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update immune_patient,obs
set immune_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where immune_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=immune_patient.enrollment_date;

update immune_patient,obs
set immune_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where immune_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=immune_patient.enrollment_date and immune_patient.pregnancy_status_at_enrollment is null;


update immune_patient,patient_program
set immune_patient.pregnancy_status_at_enrollment= 'YES'
where immune_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;

/*ESTADIO OMS */
update immune_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage, obs
set immune_patient.WHO_clinical_stage_at_enrollment=if(obs.value_coded=1204,'I',if(obs.value_coded=1205,'II',if(obs.value_coded=1206,'III','IV')))
where immune_patient.patient_id=obs.person_id 
and immune_patient.patient_id=stage.patient_id 
and obs.voided=0 and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


 /*PESO AT TIME OF ART ENROLLMENT*/
update immune_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set immune_patient.weight_enrollment=obs.value_numeric, immune_patient.weight_date=peso.encounter_datetime
where immune_patient.patient_id=obs.person_id 
and immune_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update immune_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set immune_patient.height_enrollment=obs.value_numeric, immune_patient.height_date=altura.encounter_datetime
where immune_patient.patient_id=obs.person_id 
and immune_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*INICIO TARV*/
UPDATE immune_patient,
(SELECT patient_id, data_inicio FROM (SELECT patient_id, MIN(data_inicio) data_inicio
FROM (SELECT
  p.patient_id,
  MIN(e.encounter_datetime) data_inicio
FROM patient p
INNER JOIN encounter e
  ON p.patient_id = e.patient_id
INNER JOIN obs o
  ON o.encounter_id = e.encounter_id
WHERE e.voided = 0
AND o.voided = 0
AND p.voided = 0
AND e.encounter_type IN (18, 6, 9)
AND o.concept_id = 1255
AND o.value_coded = 1256
AND e.encounter_datetime <= dataAvaliacao
GROUP BY p.patient_id

UNION

SELECT p.patient_id, MIN(value_datetime) data_inicio
FROM patient p
INNER JOIN encounter e
  ON p.patient_id = e.patient_id
INNER JOIN obs o
  ON e.encounter_id = o.encounter_id
WHERE p.voided = 0
AND e.voided = 0
AND o.voided = 0
AND e.encounter_type IN (18, 6, 9)
AND o.concept_id = 1190
AND o.value_datetime IS NOT NULL
AND o.value_datetime <= dataAvaliacao
GROUP BY p.patient_id

UNION

SELECT pg.patient_id, date_enrolled data_inicio
FROM patient p
INNER JOIN patient_program pg
  ON p.patient_id = pg.patient_id
WHERE pg.voided = 0
AND p.voided = 0
AND program_id = 2
AND date_enrolled <= dataAvaliacao

UNION

SELECT e.patient_id, MIN(e.encounter_datetime) AS data_inicio
FROM patient p
INNER JOIN encounter e
  ON p.patient_id = e.patient_id
WHERE p.voided = 0
AND e.encounter_type = 18
AND e.voided = 0
AND e.encounter_datetime <= dataAvaliacao
GROUP BY p.patient_id) inicio
GROUP BY patient_id
) inicio1
)ua
set immune_patient.date_of_ART_initiation=ua.data_inicio
WHERE   data_inicio BETWEEN startDate AND endDate and ua.patient_id=immune_patient.patient_id;



update immune_patient, patient_program
  set immune_patient.pmtct_entry_date=date_enrolled
  where voided=0 and program_id=8 and immune_patient.patient_id=patient_program.patient_id;


update immune_patient, patient_program
  set immune_patient.pmtct_exit_date=date_completed
  where voided=0 and program_id=8 and immune_patient.patient_id=patient_program.patient_id;


    /*TB DIAGNOSTIC*/   
update immune_patient,
    (select p.patient_id,
         e.encounter_datetime,
        case o.value_coded
        when 664 then 'NEGATIVE'
        when 703 then 'POSITIVE'
        else null end as cod
    from  immune_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=6277 and e.encounter_type in (6,9) and e.voided=0 AND o.obs_datetime  between startDate AND endDate 
    ) tb
set immune_patient.tb_co_infection= tb.cod
where tb.patient_id=immune_patient.patient_id;

/*TB */
update immune_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=6257
  group by p.patient_id
)tb, obs
set immune_patient.tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where immune_patient.patient_id=obs.person_id 
and immune_patient.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id=6257 ;


update immune_patient,(
Select  p.patient_id,min(o.obs_datetime) datainh,case o.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as code
    from  immune_patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (13,6,9) and  o.concept_id=6122 
    group by p.patient_id ) seg  
set immune_patient.prophylaxis_isoniazide=seg.code, immune_patient.prophylaxis_isoniazide_date=seg.datainh
where seg.patient_id=immune_patient.patient_id;



/*VISITAS*/
insert into immune_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  immune_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime <  dataAvaliacao;

/* PROXIMA VISITAS*/
update immune_visit,obs 
set  immune_visit.next_visit_date=obs.value_datetime
where   immune_visit.patient_id=obs.person_id and
    immune_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;

    /*LEVANTAMENTO ARV*/
insert into immune_art_pick_up(patient_id,regime,art_date)
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
  from  immune_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime  and o.obs_datetime  < dataAvaliacao;

/*PROXIMO LEVANTAMENTO*/
update immune_art_pick_up,obs 
set  immune_art_pick_up.next_art_date=obs.value_datetime
where   immune_art_pick_up.patient_id=obs.person_id and
    immune_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

    /*CD4*/
insert into immune_cd4_absulute(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  immune_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497   and o.obs_datetime  < dataAvaliacao;

    /*CD4*/
insert into immune_cd4_percentage(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  immune_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=730   and o.obs_datetime  < dataAvaliacao;

/*CARGA VIRAL*/
insert into immune_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  immune_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and o.obs_datetime  < dataAvaliacao;

 /*ESTADO ACTUAL TARV*/
update immune_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  immune_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null 
    ) out_state
set   immune_patient.patient_status=out_state.codeestado, immune_patient.patient_status_date=out_state.start_date
where immune_patient.patient_id=out_state.patient_id;

    /*LAST CLINIC VISIT*/
update immune_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  immune_patient p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime  < dataAvaliacao
  group by p.patient_id
)seguimento
set immune_patient.last_clinic_visit=seguimento.encounter_datetime
where immune_patient.patient_id=seguimento.patient_id;


/*NEXT CLINIC VISIT*/
update  immune_patient,obs
set   scheduled_clinic_visit=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_clinic_visit and 
    concept_id=5096 and voided=0;


    /*LAST ART PICKUP*/
update immune_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  immune_patient p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type=18 and e.encounter_datetime  < dataAvaliacao
  group by p.patient_id
)levantamento
set immune_patient.last_artpickup=levantamento.encounter_datetime
where immune_patient.patient_id=levantamento.patient_id;


/*NEXT ART PICKUP*/
update  immune_patient,obs
set   scheduled_artpickp=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_artpickup and 
    concept_id=5096 and voided=0;


          /*REGIME*/   
update immune_patient,
(
    select  max_fila.patient_id,
        case o.value_coded     
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
        else null end as code
    from
    (
        select  p.patient_id,
                max(e.encounter_datetime) datafila
        from    immune_patient p 
                inner join encounter e on p.patient_id=e.patient_id
        where   e.encounter_type=18 and e.voided=0  and e.encounter_datetime < dataAvaliacao
                GROUP by e.patient_id
    ) max_fila
    inner join obs o on o.person_id=max_fila.patient_id and o.obs_datetime=max_fila.datafila
    where o.voided=0 and o.concept_id=1088
) fila 
set immune_patient.current_treatment_regimen=fila.code
where fila.patient_id=immune_patient.patient_id;


end
;;
DELIMITER ;



