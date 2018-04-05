DROP TABLE IF EXISTS `patient`;

CREATE TABLE `patient` (
  `patient_id` int(11) DEFAULT NULL,
  `nid` varchar(255) DEFAULT NULL,
  `initial_names` varchar(255) DEFAULT NULL,
  `date_of_enrollment` datetime DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `community_bairro` varchar(255) DEFAULT NULL,
  `community_celula` varchar(255) DEFAULT NULL,
  `community_ponto_referencia` varchar(255) DEFAULT NULL,
  `community_localidade` varchar(255) DEFAULT NULL,
  `profession` varchar(255) DEFAULT NULL,
  `marital_status` varchar(255) DEFAULT NULL,
  `children` int(11) DEFAULT NULL,
  `children_tested` int(11) DEFAULT NULL,
  `children_hiv` int(11) DEFAULT NULL,
  `home_electricity` varchar(255) DEFAULT NULL,
  `home_refrigerator` varchar(255) DEFAULT NULL,
  `hiv_entry_point` varchar(255) DEFAULT NULL,
  `partner_known_to_be_diagnosed_with_hiv` varchar(255) DEFAULT NULL,
  `partner_enrolled_on_art` varchar(255) DEFAULT NULL,
  `problems_at_first_home_visit_q30` varchar(255) DEFAULT NULL,
  `problems_at_first_home_visit_q31` varchar(255) DEFAULT NULL,
  `date_of_diagnosis` datetime DEFAULT  NULL,
  `date_of_art_initiation` datetime DEFAULT  NULL,
  `current_treatment_regimen` varchar(255) DEFAULT NULL,
  `tb_diagnostic` varchar(255) DEFAULT NULL,
  `tb_start_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `art_pickup`;
CREATE TABLE `art_pickup` (
  `patient_id` int(11) DEFAULT NULL,
  `art_pickup_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cd4`;
CREATE TABLE `cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `viral_load`;
CREATE TABLE `viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `viral_load` double DEFAULT NULL,
  `viral_load_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pp_messages_delivered`;
CREATE TABLE `pp_messages_delivered` (
  `patient_id` int(11) DEFAULT NULL,
  `message` varchar(100) DEFAULT NULL,
  `message_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP PROCEDURE IF EXISTS `ImportPatientData`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ImportPatientData`
    READS SQL DATA
begin

/*Insercao de data de abertura de processo*/
update patient,openmrs.encounter
set patient.date_of_enrollment= encounter.encounter_datetime
where  patient.patient_id=encounter.patient_id and encounter.encounter_type in(5,7) and encounter.voided=0;

/*Sexo*/
update patient,openmrs.person set patient.sex=openmrs.person.gender
where  person_id=patient.patient_id

/*Data de Naicimento*/
update patient,openmrs.person set patient.date_of_birth=openmrs.person.birthdate
where  person_id=patient.patient_id

/*PROFISSAO*/
update patient,openmrs.obs
set patient.profession = obs.value_text
where obs.person_id=patient_id and obs.concept_id=1459 and voided=0;

/*Bairro*/
update patient,openmrs.person_address 
set patient.community_bairro=openmrs.person_address.address5
where  person_id=patient.patient_id;

/*Celula*/
update patient,openmrs.person_address 
  set patient.community_celula=openmrs.person_address.address3
where  person_id=patient.patient_id;

/*Ponto de referencia*/
update patient,openmrs.person_address 
  set patient.community_ponto_referencia=openmrs.person_address.address1
where  person_id=patient.patient_id;


/*Localidade*/
update patient,openmrs.person_address 
  set patient.community_localidade=openmrs.person_address.address6
where  person_id=patient.patient_id;

/*ESTADO CIVIL*/
update patient,openmrs.obs
set patient.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=patient.patient_id and obs.concept_id=1054 and obs.voided=0;  

/*NUMERO DE Filhos*/
update patient,openmrs.obs
  set patient.children= obs.value_numeric
where obs.person_id=patient.patient_id and obs.concept_id=5573 and obs.voided=0;

/*NUMERO DE Filhos Testados*/
update patient,openmrs.obs
  set patient.children_tested= obs.value_numeric
where obs.person_id=patient.patient_id and obs.concept_id=1452 and obs.voided=0;

/*NUMERO DE Filhos HIV*/
update patient,openmrs.obs
  set patient.children_hiv= obs.value_numeric
where obs.person_id=patient.patient_id and obs.concept_id=1453 and obs.voided=0;

/*ELECTRICIDADE*/
update patient,openmrs.obs
set patient.home_electricity= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=patient.patient_id and obs.concept_id=5609 and voided=0;

/*GELEIRA*/
update patient,openmrs.obs
set patient.home_refrigerator= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=patient.patient_id and obs.concept_id=1455 and voided=0;

/*Update CodProveniencia*/
update patient,
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
        inner join openmrs.encounter e on e.patient_id=p.patient_id
        inner join openmrs.obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=1594 and e.encounter_type in (5,7) and e.voided=0
    ) proveniencia
set patient.hiv_entry_point=proveniencia.codProv
where proveniencia.patient_id=patient.patient_id;

/*Estado do Parceiro*/
update patient,openmrs.obs
set patient.partner_known_to_be_diagnosed_with_hiv= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=patient.patient_id and obs.concept_id=1449 and obs.voided=0;  

/*Data do diagnostico HIV*/
update patient,
  ( Select  p.patient_id,
        o.value_datetime
    from  patient p 
        inner join openmrs.encounter e on p.patient_id=e.patient_id 
        inner join openmrs.obs o on o.encounter_id=e.encounter_id
    where   e.voided=0 and o.voided=0 and
        e.encounter_type in (5,7) and o.concept_id=6123 and o.value_datetime between '2016-02-02' AND '2017-09-30' and e.location_id=5
  ) diagnostico
set   patient.date_of_diagnosis=diagnostico.value_datetime
where   patient.patient_id=diagnostico.patient_id;

/*Inicio TARV*/
update patient,
  (select patient_id,min(data_inicio) data_inicio
    from
    (
      Select  p.patient_id, min(e.encounter_datetime) data_inicio
      from  patient p 
          inner join openmrs.encounter e on p.patient_id=e.patient_id 
          inner join openmrs.obs o on o.encounter_id=e.encounter_id
      where   e.voided=0 and o.voided=0 and  
          e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 
          and e.encounter_datetime between '2016-02-02' AND '2017-09-30'  and e.location_id=5
      group by p.patient_id
      
      union
    
      Select p.patient_id, min(value_datetime) data_inicio
      from  patient p
          inner join openmrs.encounter e on p.patient_id=e.patient_id
          inner join openmrs.obs o on e.encounter_id=o.encounter_id
      where   e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and 
          o.concept_id=1190 and o.value_datetime is not null and 
          o.value_datetime between '2016-02-02' AND '2017-09-30'  and e.location_id=5
      group by p.patient_id
      
      union
      
      select  p.patient_id, date_enrolled as data_inicio
      from  patient p inner join openmrs.patient_program pg on p.patient_id=pg.patient_id
      where  pg.voided=0 and program_id=2 
      and    pg.date_enrolled between '2016-02-02' AND '2017-09-30'  and pg.location_id=5
    ) inicio
    group by patient_id
  )inicio_real 
set patient.date_of_art_initiation=inicio_real.data_inicio
where patient.patient_id=inicio_real.patient_id;


/*LEVANTAMENTO ARV*/
insert into art_pickup(patient_id,art_pickup_date,uuid)
select p.patient_id,e.encounter_datetime, uuid()
from patient p inner join openmrs.encounter e on p.patient_id=e.patient_id
where e.encounter_type=18 and e.encounter_datetime between '2016-02-02' AND '2017-09-20' and e.location_id=5

/*CD4*/   
insert into cd4(patient_id,cd4,cd4_date,uuid)
select  p.patient_id,o.value_numeric,o.obs_datetime, uuid()
from  patient p
    inner join openmrs.encounter e on p.patient_id=e.patient_id
    inner join openmrs.obs o on o.encounter_id=e.encounter_id
where   e.encounter_datetime  between '2016-02-02' AND '2017-09-20' and 
    e.encounter_type=13 and o.voided=0 and e.voided=0 and o.concept_id=5497 and e.location_id=5;

    /*Viral Load*/   
insert into viral_load(patient_id,viral_load,viral_load_date,uuid)
select p.patient_id,o.value_numeric,o.obs_datetime, uuid()
from  patient p
    inner join openmrs.encounter e on p.patient_id=e.patient_id
    inner join openmrs.obs o on o.encounter_id=e.encounter_id
where e.encounter_datetime  between '2016-02-02' AND '2017-09-20' and 
      e.encounter_type=13 and o.voided=0 and e.voided=0 and o.concept_id=856 and e.location_id=5;


  /*TB diagnostic*/   
update patient,
    (select p.patient_id,
         e.encounter_datetime,
        case o.value_coded
        when 664 then 'NEGATIVE'
        when 703 then 'POSITIVE'
        else null end as cod
    from  patient p 
        inner join openmrs.encounter e on e.patient_id=p.patient_id
        inner join openmrs.obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=6277 and e.encounter_type in (6,9) and e.voided=0 AND o.obs_datetime  between '2016-02-02' AND '2017-09-20' and e.location_id=5
    ) tb
set patient.tb_diagnostic= tb.cod
where tb.patient_id=patient.patient_id;

  /*TB diagnostic date*/   
update patient,
    (select 
         p.patient_id,
         e.encounter_datetime,
        o.value_datetime
    from  patient p 
        inner join openmrs.encounter e on e.patient_id=p.patient_id
        inner join openmrs.obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=1113 and e.encounter_type in (6,9) and e.voided=0 AND o.obs_datetime  between '2016-02-02' AND '2017-09-20' and e.location_id=5
    ) tb
set patient.tb_start_date= tb.value_datetime
where tb.patient_id=patient.patient_id;

/*Problemas na primeira visita Q30*/

update patient,
(
select   p.patient_id,
        case o.value_coded
        when 2005 then 'PATIENT FORGOT VISIT DATE'
        when 2006 then 'PATIENT IS BEDRIDDEN AT HOME'
        when 2007 then 'DISTANCE OR MONEY FOR TRANSPORT IS TO MUCH FOR PATIENT'
        when 2008 then 'PATIENT HAS LACK OF FOOD'
        when 2014 then 'PATIENTS WORK PREVENTS CLINIC VISIT'
        when 2010 then 'PATIENT IS DISSATISFIED WITH DAY HOSPITAL SERVICES'
        when 2015 then 'PATIENT DOES NOT LIKE ARV TREATMENT SIDE EFFECTS'
        when 2013 then 'PATIENT IS TREATING HIV WITH TRADITIONAL MEDICINE'
        when 2012 then 'PATIENT HAS LACK OF MOTIVATION'
        when 2012 then 'OTHER REASON WHY PATIENT MISSED VISIT'
        else null end as cod
    from  openmrs.patient p 
        inner join openmrs.encounter e on e.patient_id=p.patient_id
        inner join openmrs.obs o on o.encounter_id=e.encounter_id
    where  e.encounter_type=21 and o.concept_id=2016 and o.voided=0 
)msg set patient.problems_at_first_home_visit_q30=msg.cod WHERE msg.patient_id=patient.patient_id

  /*Regime*/   
update patient,
(
    select  max_fila.patient_id,
         case o.value_coded     
         WHEN 6324 THEN  'TDF+3TC+EFV'
         WHEN 1651 THEN 'AZT+3TC+NVP'
         WHEN 1703 THEN 'AZT+3TC+EFV'  
         WHEN 6343 THEN 'TDF+3TC+NVP' 
         WHEN 792  THEN 'D4T+3TC+NVP' 
         WHEN 6103 THEN 'D4T+3TC+LPV/r' 
         WHEN 1827 THEN 'D4T+3TC+EFV' 
         WHEN 6102 THEN 'D4T+3TC+ABC' 
         WHEN 6116 THEN 'AZT+3TC+ABC' 
         WHEN 6100 THEN 'AZT+3TC+LPV/r'
         WHEN 6104 THEN 'ABC+3TC+EFV'
         WHEN 6106 THEN 'ABC+3TC+LPV/r'
         WHEN 6108 THEN 'TDF+3TC+LPV/r(2ª Linha)'
         WHEN 1314 THEN 'AZT+3TC+LPV/r(2ª Linha)'
         WHEN 1311 THEN 'ABC+3TC+LPV/r (2ª Linha)'
         WHEN 1315 THEN 'TDF+3TC+EFV (2ª Linha)'
         WHEN 6329 THEN 'TDF+3TC+RAL+DRV/r (3ª Linha)'
         WHEN 6330 THEN 'AZT+3TC+RAL+DRV/r (3ª Linha)'
         else null end as code
    from
    (
        select  p.patient_id,
                max(e.encounter_datetime) datafila
        from    openmrs.patient p 
                inner join openmrs.encounter e on p.patient_id=e.patient_id
        where   e.encounter_type=18 and e.voided=0 and p.voided=0 and 
                e.encounter_datetime between '2016-02-02' AND '2017-09-20' and e.location_id=5
        GROUP by e.patient_id
    ) max_fila
    inner join openmrs.obs o on o.person_id=max_fila.patient_id and o.obs_datetime=max_fila.datafila
    where o.voided=0 and o.concept_id=1088
) fila 
set patient.current_treatment_regimen=fila.code
where fila.patient_id=patient.patient_id;


/*mensages PP1*/   
insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'PP1 - MESSAGE OF SEXUAL BEHAVIOR AND SUPPLY OF CONDOMS',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=6317 and o.value_coded=1065;
  
  /*mensages PP2*/  
insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'PP2 - MESSAGE DISCLOSING THEIR SEROSTATUS AND KNOWLEDGE / CALL FOR TESTING THE PARTNER',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=6318 and o.value_coded=1065;


  /*mensages PP3*/   
insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'PP3 - MESSAGE OF ADHERENCE OF CARE AND TREATMENT',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=6319 and o.value_coded=1065;


 /*mensages PP4*/   
insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'MESSAGE OF SEXUALLY TRANSMITTED INFECTION',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=6320 and o.value_coded=1065;


/*mensages FAMILY PLANNING*/   
insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'FAMILY PLANNING',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=5271 and o.value_coded=1065;


/*PMTCT*/  

insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'MESSAGE OF PREVENTION OF VERTICAL TRANSMISSION',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=6316 and o.value_coded=1065;


 /*mensages PP6*/   
insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'MESSAGE OF CONSUMPTION OF ALCOHOL AND OTHER DRUGS',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=6321 and o.value_coded=1065;


           /*mensages PP7*/   
insert into pp_messages_delivered(patient_id,message,message_date,uuid)
select     p.patient_id, 
    'MESSAGE OF THE NEED FOR COMMUNITY SUPPORT SERVICES',
    o.obs_datetime, 
    uuid()
from      patient p
        inner join openmrs_namacurra.encounter e on p.patient_id=e.patient_id
        inner join openmrs_namacurra.obs o on o.encounter_id=e.encounter_id
where     e.encounter_datetime  between '2016-02-02' AND '2017-09-20'  and e.location_id=5
          and o.voided=0 and e.voided=0 and o.concept_id=6322 and o.value_coded=1065;




    








