SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `satisfaction` (
  `id` int(11) DEFAULT NULL  AUTO_INCREMENT,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `source_of_referral`varchar(100) DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `residence`varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `date_of_first_HIV_positive_test_result` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `enrolled_in_GAAC` varchar(100) DEFAULT NULL,
  `gaac_start_date`datetime DEFAULT NULL,
  `gaac_end_date` datetime DEFAULT NULL,
  `gaac_identifier` varchar(225) DEFAULT NULL,
  `hemoglobin` int(11)  DEFAULT NULL,
  `hemoglobin_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `bmi_enrollment` decimal(10,0) DEFAULT NULL,
  `bmi_art_date` datetime DEFAULT NULL,
  `tb_co_infection_status` varchar(5) DEFAULT NULL,
   PRIMARY KEY (id)
 
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for pmtct entry
-- ----------------------------
CREATE TABLE IF NOT EXISTS `satisfaction_pmtct_entry` (
  `patient_id` int(11) DEFAULT NULL,
  `pmtct_date` datetime  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for pmtct exit
-- ----------------------------
CREATE TABLE IF NOT EXISTS `satisfaction_pmtct_exit` (
  `patient_id` int(11) DEFAULT NULL,
  `pmtct_date` datetime  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `satisfaction_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `satisfaction_cv`;
CREATE TABLE `satisfaction_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `satisfaction_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `art_date` (`art_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `satisfaction_hemoglobin` (
  `patient_id` int(11) DEFAULT NULL,
  `hemoglobin` varchar(255) DEFAULT NULL,
  `date_hemoglobin` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `satisfaction_height` (
  `patient_id` int(11) DEFAULT NULL,
  `height` varchar(255) DEFAULT NULL,
  `date_height` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `satisfaction_weight` (
  `patient_id` int(11) DEFAULT NULL,
  `weight` varchar(255) DEFAULT NULL,
  `date_weight` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `satisfaction_tb_investigation` (
  `patient_id` int(11) DEFAULT NULL,
  `tb` varchar(255) DEFAULT NULL,
  `tb_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `satisfaction_start_tb_tretment` (
  `patient_id` int(11) DEFAULT NULL,
  `start_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `satisfaction_end_tb_tretment` (
  `patient_id` int(11) DEFAULT NULL,
  `end_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP PROCEDURE IF EXISTS `FillSATISFACTION`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillSATISFACTION`(startDate date,endDate date, district varchar(100))

READS SQL DATA
begin

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE satisfaction,
       patient_identifier
SET satisfaction.patient_id=patient_identifier.patient_id, satisfaction.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=satisfaction.nid;

  /*DATA DE NAICIMENTO*/
UPDATE satisfaction, person SET satisfaction.birth_date=person.birthdate WHERE satisfaction.patient_id=person.person_id;


/*SEXO*/
update satisfaction,person set satisfaction.sex=.person.gender where  person_id=satisfaction.patient_id;


/*ESTADO CIVIL*/
update satisfaction,obs
set satisfaction.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=satisfaction.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*ESCOLARIDADE*/
update satisfaction,obs
set satisfaction.education= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=satisfaction.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update satisfaction,obs
set satisfaction.occupation= obs.value_text
where obs.person_id=satisfaction.patient_id and obs.concept_id=1459 and voided=0;

  /*UPDATE CODPROVENIENCIA*/
update satisfaction,
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
set satisfaction.source_of_referral=proveniencia.codProv
where proveniencia.patient_id=satisfaction.patient_id;

/*Bairro*/
update satisfaction,person_address 
set satisfaction.residence=person_address.address5
where  person_id=satisfaction.patient_id;

update satisfaction,obs set satisfaction.date_of_first_HIV_positive_test_result=obs.obs_datetime
where obs.person_id=satisfaction.patient_id and obs.concept_id=6123 and voided=0;


/*INSCRICAO*/
UPDATE satisfaction,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,7)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment

SET satisfaction.enrollment_date=enrollment.data_abertura
WHERE satisfaction.patient_id=enrollment.patient_id;

/*IDADE*/
update satisfaction,person set satisfaction.age_enrollment=round(datediff(satisfaction.enrollment_date,person.birthdate)/365)
where  person_id=satisfaction.patient_id;


/*INICIO TARV*/
update satisfaction,
  (select patient_id,min(data_inicio) data_inicio
    from
    (
      Select  p.patient_id, min(e.encounter_datetime) data_inicio
      from  patient p 
          inner join encounter e on p.patient_id=e.patient_id 
          inner join obs o on o.encounter_id=e.encounter_id
      where   e.voided=0 and o.voided=0 and  
          e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256  
      group by p.patient_id
      
      union
    
      Select p.patient_id, min(value_datetime) data_inicio
      from  patient p
          inner join encounter e on p.patient_id=e.patient_id
          inner join obs o on e.encounter_id=o.encounter_id
      where   e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and 
          o.concept_id=1190 and o.value_datetime is not null 
      group by p.patient_id
      
      union
      
      select  p.patient_id, date_enrolled as data_inicio
      from  patient p inner join patient_program pg on p.patient_id=pg.patient_id
      where  pg.voided=0 and program_id=2 and pg.location_id=5
    ) inicio
    group by patient_id
  )inicio_real 
set satisfaction.art_initiation_date=inicio_real.data_inicio
where satisfaction.patient_id=inicio_real.patient_id;


/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update satisfaction,obs
set satisfaction.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where satisfaction.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=satisfaction.enrollment_date;

update satisfaction,obs
set satisfaction.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where satisfaction.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=satisfaction.enrollment_date and satisfaction.pregnancy_status_at_enrollment is null;


update satisfaction,patient_program
set satisfaction.pregnancy_status_at_enrollment= 'YES'
where satisfaction.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;


update satisfaction set satisfaction.enrolled_in_GAAC='YES' where satisfaction.patient_id in (select member_id from gaac_member);

/*GAAC START DATE*/
update satisfaction,gaac_member set satisfaction.gaac_start_date=gaac_member.start_date where gaac_member.member_id=satisfaction.patient_id ;

/*GAAC END DATE*/
update satisfaction,gaac_member set satisfaction.gaac_end_date=gaac_member.end_date where gaac_member.member_id=satisfaction.patient_id; 

  /*GAAC END DATE*/
update satisfaction,gaac_member, gaac set satisfaction.gaac_identifier=gaac.gaac_identifier where gaac_member.member_id=satisfaction.patient_id and gaac_member.gaac_id=gaac.gaac_id; 


/*HEMOGLOBINA SEGUIMENTO */
update satisfaction,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime
      and o.concept_id=1692 
  group by p.patient_id
)hemoglobin,obs 
set  satisfaction.hemoglobin=obs.value_numeric, satisfaction.hemoglobin_date=hemoglobin.encounter_datetime
where satisfaction.patient_id=obs.person_id 
and satisfaction.patient_id=hemoglobin.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin.encounter_datetime
 and obs.concept_id=1692;


/*HEMOGLOBINA LAB */
update satisfaction,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=13 and o.obs_datetime=e.encounter_datetime 
      and o.concept_id=21
  group by p.patient_id
)hemoglobin,obs 
set  satisfaction.hemoglobin=obs.value_numeric, satisfaction.hemoglobin_date=hemoglobin.encounter_datetime
where satisfaction.patient_id=obs.person_id 
and satisfaction.patient_id=hemoglobin.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin.encounter_datetime
and obs.concept_id=21 and satisfaction.hemoglobin is null;


/*Peso*/
update satisfaction,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089 
  group by p.patient_id
)peso,obs
set satisfaction.weight_enrollment=obs.value_numeric, satisfaction.weight_date=peso.encounter_datetime
where satisfaction.patient_id=obs.person_id 
and satisfaction.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*Altura*/
update satisfaction,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090
  group by p.patient_id
)altura,obs
set satisfaction.height_enrollment=obs.value_numeric, satisfaction.height_date=altura.encounter_datetime
where satisfaction.patient_id=obs.person_id 
and satisfaction.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


update  satisfaction,obs 
set   satisfaction.bmi_enrollment=obs.value_numeric
where  satisfaction.patient_id=obs.person_id and obs.obs_datetime=satisfaction.bmi_art_date and obs.concept_id=1342 and obs.voided=0;


/*TB PULMONARAT TIME OF ART ENROLLMENT*/
update satisfaction,obs
set satisfaction.tb_co_infection_status= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=satisfaction.patient_id and obs.concept_id=42 and voided=0;


/*TB EXTRA PULMONAR AT TIME OF ART ENROLLMENT */
update satisfaction,obs
set satisfaction.tb_co_infection_status= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=satisfaction.patient_id and obs.concept_id=5042 and 
 voided=0 AND satisfaction.tb_co_infection_status is null ;


     /*LEVANTAMENTO ARV*/
insert into satisfaction_art_pick_up(patient_id,regime,art_date)
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
  from  satisfaction p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 and e.encounter_datetime  < endDate
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime;

/*PROXIMO LEVANTAMENTO*/
update satisfaction_art_pick_up,obs 
set  satisfaction_art_pick_up.next_art_date=obs.value_datetime
where   satisfaction_art_pick_up.patient_id=obs.person_id and
    satisfaction_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

    /*CD4*/
insert into satisfaction_cd4(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  satisfaction p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id 
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497 and e.encounter_datetime  < endDate;

/*CARGA VIRAL*/
insert into satisfaction_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  satisfaction p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and e.encounter_datetime  < endDate;


insert into satisfaction_pmtct_entry(patient_id,pmtct_date)
Select distinct p.patient_id,pg.date_enrolled
from  satisfaction p 
    inner join patient_program pg on pg.patient_id=p.patient_id 
where pg.program_id=8;

insert into satisfaction_pmtct_exit(patient_id,pmtct_date)
Select distinct p.patient_id,pg.date_completed
from  satisfaction p 
    inner join patient_program pg on pg.patient_id=p.patient_id 
where pg.program_id=8;

/*TB*/
insert into satisfaction_tb_investigation(patient_id,tb,tb_date)
Select distinct p.patient_id,
    case o.value_coded
             when 703 then 'POSITIVE'
             when 664 then 'NEGATIVE'
             else null end,
      o.obs_datetime
from  satisfaction p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=6277 and e.encounter_datetime  < endDate;


/*TB start Date*/
insert into satisfaction_start_tb_tretment(patient_id,start_tb_treatment)
Select distinct p.patient_id, min(encounter_datetime) encounter_datetime
from  satisfaction p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=1113 and o.voided=0 and e.encounter_datetime  < endDate
  group by p.patient_id;


  /*TB end Date*/
insert into satisfaction_end_tb_tretment(patient_id,end_tb_treatment)
Select distinct p.patient_id, max(encounter_datetime) encounter_datetime
from  satisfaction p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=6120 and e.encounter_datetime  < endDate
  group by p.patient_id;


insert into satisfaction_hemoglobin(patient_id,hemoglobin,date_hemoglobin)
Select distinct p.patient_id, o.value_numeric, e.encounter_datetime
from  satisfaction p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=1992 and o.voided=0 and e.encounter_datetime  < endDate
  group by p.patient_id;

insert into satisfaction_weight(patient_id,weight,date_weight)
Select distinct p.patient_id, o.value_numeric, e.encounter_datetime
from  satisfaction p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=5089 and o.voided=0 and e.encounter_datetime  < endDate
  group by p.patient_id;

insert into satisfaction_height(patient_id,height,date_height)
Select distinct p.patient_id, o.value_numeric, e.encounter_datetime
from  satisfaction p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=5090 and o.voided=0 and e.encounter_datetime  < endDate
  group by p.patient_id;

update satisfaction,location
set satisfaction.health_facility=location.name
where satisfaction.location_id=location.location_id;

update satisfaction set urban='N';

update satisfaction set main='N';

if district='Quelimane' then
  update satisfaction set urban='Y'; 
end if;

if district='Namacurra' then
  update satisfaction set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update satisfaction set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update satisfaction set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update satisfaction set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update satisfaction set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update satisfaction set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update satisfaction set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update satisfaction set main='Y' where location_id in (4,55); 
end if;


end
;;
DELIMITER ;
