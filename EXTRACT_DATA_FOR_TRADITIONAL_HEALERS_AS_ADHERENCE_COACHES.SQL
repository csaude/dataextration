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


CREATE TABLE IF NOT EXISTS `healers_patient` (
  `nid`varchar(100) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
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
  `drink` varchar(255) DEFAULT NULL,
  `drugs` varchar(255) DEFAULT NULL,
  `smoking` varchar(255) DEFAULT NULL,
  `partner_known_to_be_diagnosed_with_hiv` varchar(255) DEFAULT NULL,
  `partner_enrolled_on_ART` varchar(255) DEFAULT NULL,
  `date_of_diagnosis` datetime DEFAULT NULL,
  `date_of_ART_initiation` datetime DEFAULT NULL,
  `current_treatment_regimen` varchar(255) DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `date_of_diagnosis_tb_co_infection` datetime DEFAULT NULL,
  `date_of_TB_medication_initiation`  datetime DEFAULT NULL,
  `date_of_TB_medication_completion`  datetime DEFAULT NULL,
  `TB_medication_completed` varchar(255) DEFAULT NULL,
  `known_to_have_died` varchar(255) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `death` varchar(255) DEFAULT NULL,
  `date_of_death`  datetime DEFAULT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for art_pickup
-- ----------------------------
DROP TABLE IF EXISTS `healers_art_pickup`;
CREATE TABLE `healers_art_pickup` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of art_pickup
-- ----------------------------

-- ----------------------------
-- Table structure for cd4
-- ----------------------------
DROP TABLE IF EXISTS `healers_cd4`;
CREATE TABLE `healers_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for viral_load
-- ----------------------------
DROP TABLE IF EXISTS `healers_viral_load`;
CREATE TABLE `healers_viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `viral_load_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `viral_load_date` (`viral_load_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `healers_home_visitq30`;
CREATE TABLE `healers_home_visitq30` (
  `patient_id` int(11) DEFAULT NULL,
  `reason_for_the_visit` varchar(100) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `healers_home_visitq31`;
CREATE TABLE `healers_home_visitq31` (
  `patient_id` int(11) DEFAULT NULL,
  `reason_for_the_visit` varchar(100) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP PROCEDURE IF EXISTS `FillHealersPatient`;

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHealersPatient`(startDate date,endDate date)
    READS SQL DATA
begin

truncate table healers_art_pickup;
truncate table healers_viral_load;
truncate table healers_cd4;
truncate table healers_home_visitq30;
truncate table healers_home_visitq31;

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE healers_patient,
       patient_identifier
SET healers_patient.patient_id = patient_identifier.patient_id, healers_patient.location_id=patient_identifier.location_id
WHERE patient_identifier.identifier_type=2
  AND patient_identifier.identifier=healers_patient.nid AND patient_identifier.voided=0;


  /*Sexo*/
update healers_patient,person set healers_patient.sex=person.gender
where  person.person_id=healers_patient.patient_id;

  /*BUSCAR NOME DA LOCATION*/
UPDATE healers_patient,
       location
SET healers_patient.health_facility = location.name
WHERE location.location_id=healers_patient.location_id;

/*Data de Naicimento*/
update healers_patient, person set healers_patient.date_of_birth=person.birthdate
where  person_id=healers_patient.patient_id;

/*PROFISSAO*/
update healers_patient,obs
set healers_patient.profession = obs.value_text
where obs.person_id=healers_patient.patient_id and obs.concept_id=1459 and voided=0;

/*Bairro*/
update healers_patient,person_address 
set healers_patient.community_bairro=person_address.address5
where  person_id=healers_patient.patient_id;

/*Celula*/
update healers_patient,person_address 
  set healers_patient.community_celula=person_address.address3
where  person_address.person_id=healers_patient.patient_id;

/*Ponto de referencia*/
update healers_patient,person_address 
  set healers_patient.community_ponto_referencia=person_address.address1
where person_address.person_id=healers_patient.patient_id;


/*LOCALIDADE*/
update healers_patient,person_address 
  set healers_patient.community_localidade=person_address.address6
where  person_address.person_id=healers_patient.patient_id;

/*ESTADO CIVIL*/
update healers_patient,obs
set healers_patient.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=healers_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

 /*NUMERO DE FILHOS*/
update healers_patient,obs
  set healers_patient.children= obs.value_numeric
where obs.person_id=healers_patient.patient_id and obs.concept_id=5573 and obs.voided=0;

/*NUMERO DE FILHOS TESTADOS*/
update healers_patient,obs
  set healers_patient.children_tested= obs.value_numeric
where obs.person_id=healers_patient.patient_id and obs.concept_id=1452 and obs.voided=0;

/*NUMERO DE Filhos HIV*/
update healers_patient,obs
  set healers_patient.children_hiv= obs.value_numeric
where obs.person_id=healers_patient.patient_id and obs.concept_id=1453 and obs.voided=0;

/*ELECTRICIDADE*/
update healers_patient,obs
set healers_patient.home_electricity= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=healers_patient.patient_id and obs.concept_id=5609 and voided=0;

/*GELEIRA*/
update healers_patient,obs
set healers_patient.home_refrigerator= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=healers_patient.patient_id and obs.concept_id=1455 and voided=0;

/*UPDATE CODPROVENIENCIA*/
update healers_patient,
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
    from  healers_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=1594 and e.encounter_type in (5,7) and e.voided=0
    ) proveniencia
set healers_patient.hiv_entry_point=proveniencia.codProv
where proveniencia.patient_id=healers_patient.patient_id;

/*ALCOOL*/
update healers_patient,obs
set healers_patient.drink= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=healers_patient.patient_id and obs.concept_id=1603 and voided=0;

/*DROGAS*/
update healers_patient,obs
set healers_patient.drugs= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=healers_patient.patient_id and obs.concept_id=105 and voided=0;

/*TABACO*/
update healers_patient,obs
set healers_patient.smoking= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=healers_patient.patient_id and obs.concept_id=1388 and voided=0;

/*ESTADO DO PARCEIRO*/
update healers_patient,obs
set healers_patient.partner_known_to_be_diagnosed_with_hiv= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=healers_patient.patient_id and obs.concept_id=1449 and obs.voided=0;  

/*PROCESSO DO PARCEIRO*/
update healers_patient,obs
set healers_patient.partner_enrolled_on_ART = obs.value_text
where obs.person_id=healers_patient.patient_id and obs.concept_id=1450 and voided=0;

/*DATA DO DIAGNOSTICO HIV*/
update healers_patient,
  ( Select  p.patient_id,
        o.value_datetime
    from  patient p 
        inner join encounter e on p.patient_id=e.patient_id 
        inner join obs o on o.encounter_id=e.encounter_id
    where   e.voided=0 and o.voided=0 and
        e.encounter_type in (5,7) and o.concept_id=6123 
  ) diagnostico
set   healers_patient.date_of_diagnosis=diagnostico.value_datetime
where   healers_patient.patient_id=diagnostico.patient_id;

/*INICIO TARV*/
update healers_patient,
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
set healers_patient.date_of_ART_initiation=inicio_real.data_inicio
where healers_patient.patient_id=inicio_real.patient_id;


  /*REGIME*/   
update healers_patient,
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
        from    healers_patient p 
                inner join encounter e on p.patient_id=e.patient_id
        where   e.encounter_type=18 and e.voided=0  and e.encounter_datetime between startDate AND endDate
                GROUP by e.patient_id
    ) max_fila
    inner join obs o on o.person_id=max_fila.patient_id and o.obs_datetime=max_fila.datafila
    where o.voided=0 and o.concept_id=1088
) fila 
set healers_patient.current_treatment_regimen=fila.code
where fila.patient_id=healers_patient.patient_id;


/*CD4*/   
insert into healers_cd4(patient_id,cd4,cd4_date,uuid)
select  p.patient_id,o.value_numeric,o.obs_datetime, uuid()
from  healers_patient p
    inner join encounter e on p.patient_id=e.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
where   e.encounter_datetime  between startDate AND endDate and 
    e.encounter_type=13 and o.voided=0 and e.voided=0 and o.concept_id=5497 ;

    /*VIRAL LOAD*/   
insert into healers_viral_load(patient_id,cv,viral_load_date)
select p.patient_id,o.value_numeric,o.obs_datetime
from  healers_patient p
    inner join encounter e on p.patient_id=e.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
where e.encounter_datetime  between startDate AND endDate and 
      e.encounter_type=13 and o.voided=0 and e.voided=0 and o.concept_id=856 ;


      /*LEVANTAMENTOS ARV*/
insert into healers_art_pickup(patient_id,regime,art_date)
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
  from  healers_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0  
  and e.encounter_datetime between startDate AND endDate
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime;


   /*VISIT Q30*/   
insert into healers_home_visitq30(patient_id,reason_for_the_visit,visit_date)
select  p.patient_id,
        case o.value_coded
        when 2005  then 'PATIENT FORGOT VISIT DATE'
        when 2006  then 'PATIENT IS BEDRIDDEN AT HOME'
        when 2007  then 'DISTANCE OR MONEY FOR TRANSPORT IS TO MUCH FOR PATIENT'
        when 2008  then 'PATIENT HAS LACK OF FOOD'
        when 2014  then 'PATIENTS WORK PREVENTS CLINIC VISIT'
        when 2010  then 'PATIENT IS DISSATISFIED WITH DAY HOSPITAL SERVICES'
        when 2015  then 'PATIENT DOES NOT LIKE ARV TREATMENT SIDE EFFECTS'
        when 2013  then 'PATIENT IS TREATING HIV WITH TRADITIONAL MEDICINE'
        when 2012  then 'PATIENT HAS LACK OF MOTIVATION'
        when 2017  then 'OTHER REASON WHY PATIENT MISSED VISIT'
        else null end,
        o.obs_datetime
  from  healers_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where e.encounter_datetime  between startDate AND endDate and 
  e.encounter_type=21 and o.voided=0 and e.voided=0 and o.concept_id=2016;

     /*VISIT Q31*/   
insert into healers_home_visitq31(patient_id,reason_for_the_visit,visit_date)
select  p.patient_id,
        case o.value_coded
        when 1383  then 'GOOD'
        when 2157  then 'THE PATIENT HAD DIFFICULTY'
        when 2156  then 'CONCERNS WITH FAMILY'
        when 2015  then 'PATIENT DOES NOT LIKE ARV TREATMENT SIDE EFFECTS'
        when 2153  then 'PATIENT HAS LACK OF SUPPORT'
        when 2154  then 'PROBLEMS IN TAKING MEDICINES'
        when 2155  then 'NOT REVEALED HIS DIAGNOSIS'
        else null end,
        o.obs_datetime
  from  healers_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where e.encounter_datetime  between '2018-04-01'AND '2018-08-01' and 
  e.encounter_type=21 and o.voided=0 and e.voided=0 and o.concept_id=2157;


  /*TB DIAGNOSTIC*/   
update healers_patient,
    (select p.patient_id,
         e.encounter_datetime,
        case o.value_coded
        when 664 then 'NEGATIVE'
        when 703 then 'POSITIVE'
        else null end as cod
    from  healers_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=6277 and e.encounter_type in (6,9) and e.voided=0 AND o.obs_datetime  between startDate AND endDate 
    ) tb
set healers_patient.tb_co_infection= tb.cod
where tb.patient_id=healers_patient.patient_id;

  /*TB DIAGNOSTIC DATE*/   
update healers_patient,
    (select 
         p.patient_id,
         e.encounter_datetime,
         o.value_datetime
    from  healers_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=1113 and e.encounter_type in (6,9) and e.voided=0 AND o.obs_datetime  between startDate AND endDate
    ) tb
set healers_patient.date_of_diagnosis_tb_co_infection= tb.value_datetime
where tb.patient_id=healers_patient.patient_id;

  /*DATA FIM DA MEDICACAO DE TB DATE*/   
update healers_patient,
    (select 
         p.patient_id,
         e.encounter_datetime,
         o.value_datetime
    from  healers_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=6120 and e.encounter_type in (6,9) and e.voided=0 AND o.obs_datetime  between startDate AND endDate
    ) tb
set healers_patient.date_of_TB_medication_completion= tb.value_datetime
where tb.patient_id=healers_patient.patient_id;

/*DEAD*/
update healers_patient,person
set healers_patient.death= case person.dead
             when 1 then 'YES'
             when 0 then 'NO'
             else null end
where healers_patient.patient_id=person.person_id;

/*DATE OF DEAD*/
update healers_patient,person
set healers_patient.date_of_death= person.death_date 
where healers_patient.death='YES' 
AND healers_patient.patient_id=person.person_id;

end
;;
DELIMITER ;
