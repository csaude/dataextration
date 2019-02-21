DROP TABLE IF EXISTS `pmtct_patient`;

CREATE TABLE `pmtct_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `date_of_first_consultation` datetime DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `gestational_age` int(11) DEFAULT NULL,
  `hiv_status_at_first_ANC_visit` varchar(255) DEFAULT NULL,
  `result_test_hiv` varchar(255) DEFAULT NULL,
  `date_test_hiv` datetime DEFAULT NULL,
  `partner_present` varchar(255) DEFAULT NULL,
  `test_hiv_partner` varchar(255) DEFAULT NULL,
  `test_hiv_partner_date` datetime DEFAULT NULL,
  `estimated_delivery_date` datetime DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  `hemoglobin`varchar(255) DEFAULT NULL,
  `blood_pressure` varchar(255) DEFAULT NULL,
  `arm_circumference` varchar(255) DEFAULT NULL,
  `its_tratment` varchar(255) DEFAULT NULL,
  `syphilis` varchar(255) DEFAULT NULL,
  `syphilis_test_date` datetime DEFAULT NULL,
  `cotrimoxazole_prophylaxis` varchar(255) DEFAULT NULL,
  `ART_regimen` varchar(255) DEFAULT NULL,
  `TB_treatment` varchar(255) DEFAULT NULL,
  `NID_mother_ANC` varchar(255) DEFAULT NULL,
  `NID_mother_ART` varchar(255) DEFAULT NULL,
  `NID_partner` varchar(255) DEFAULT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `pmtct_hiv_test_result_each_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `test_hiv` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `pmtct_hiv_partner_result_each_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `partner_present` varchar(255) DEFAULT NULL,
  `test_hiv` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `art_mother_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `NID_mother_ART` varchar(255) DEFAULT NULL,
  `NID_partner` varchar(255) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `birth_date_mother` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `partner_status` varchar(100) DEFAULT NULL,
  `hiv_entry_point` varchar(100) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `current_treatment_regimen` varchar(255) DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `last_clinic_visit` datetime DEFAULT NULL,
  `scheduled_clinic_visit` datetime DEFAULT NULL,
  `last_artpickup` datetime DEFAULT NULL,
  `scheduled_artpickp` datetime DEFAULT NULL,
  `patient_status` varchar(225) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for cvgaac_cv
-- ----------------------------
DROP TABLE IF EXISTS `art_mother_cv`;
CREATE TABLE `art_mother_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for cd4
-- ----------------------------
CREATE TABLE IF NOT EXISTS `art_mother_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `art_mother_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `art_mother_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ccr_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `date_of_register_at_CCR` datetime DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `NID_child_CCR` varchar(255) DEFAULT NULL,
  `NID_mother` varchar(255) DEFAULT NULL,
  `companion` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `birth_weight` int(11) DEFAULT NULL,
  `cotrimoxazole_prophylaxis` varchar(255) DEFAULT NULL,
  `prophylaxis_isoniazide` varchar(100) DEFAULT NULL,
  `prophylaxis_isoniazide_date` datetime DEFAULT NULL,
  `infant_feeding_type` varchar(225) DEFAULT NULL,
  `prematurity` varchar(225) DEFAULT NULL,
  `date_of_weaning` datetime DEFAULT NULL,
  `ART_regimen_mother` varchar(255) DEFAULT NULL,
  `place_of_birth` varchar(255) DEFAULT NULL,
  `birth_type` varchar(255) DEFAULT NULL,
  `date_ART_regime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `ccr_weigh_each_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `weight`  int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ccr_height_each_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `height` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ccr_colect_pcr_less_than_two_weeks` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `colect` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `ccr_colect_pcr_bigger_than_two_weeks` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `colect` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `ccr_result_pcr_less_than_eight_weeks` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `test_result` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ccr_result_pcr_bigger_than_eight_weeks` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `test_result` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ccr_result_rapid_test` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `test_result` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ccr_result_definitive_test` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `test_result` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE IF NOT EXISTS `ccr_infant_feeding_type_each_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `infant_feeding_type` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ccr_visits` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `art_child_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `child_status` varchar(255) DEFAULT NULL,
  `NID_child_CCR` varchar(255) DEFAULT NULL,
  `NID_child_ART` varchar(255) DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for cvgaac_cv
-- ----------------------------
DROP TABLE IF EXISTS `art_child_cv`;
CREATE TABLE `art_child_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for cd4
-- ----------------------------
CREATE TABLE IF NOT EXISTS `art_child_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `art_child_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `art_child_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Procedure structure for FillTPMTCTTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillTPMTCTTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTPMTCTTable`(startDate date,endDate date, dataAvaliacao date, district varchar(100)) 

READS SQL DATA
begin

truncate table pmtct_patient;

INSERT INTO pmtct_patient (patient_id,date_of_first_consultation,location_id)
SELECT DISTINCT e.patient_id, e.encounter_datetime,location_id FROM   patient p
       INNER JOIN encounter e
               ON e.patient_id = p.patient_id
       INNER JOIN person pe
               ON pe.person_id = p.patient_id
WHERE  p.voided = 0
       AND e.encounter_type=11
       AND e.voided = 0
       AND pe.voided = 0
       AND e.encounter_datetime BETWEEN startdate AND enddate
GROUP  BY p.patient_id
HAVING MIN(e.encounter_datetime) = MIN(e.encounter_datetime);


update pmtct_patient,location
set pmtct_patient.health_facility=location.name
where pmtct_patient.location_id=location.location_id;

update pmtct_patient set urban='N';

update pmtct_patient set main='N';

if district='Namacurra' then
  update pmtct_patient set main='Y' where location_id=5; 

end if;


/*DATA DE NAICIMENTO*/
UPDATE pmtct_patient, person SET pmtct_patient.birth_date=person.birthdate WHERE pmtct_patient.patient_id=person.person_id;

/*IDADE*/
update pmtct_patient,person set pmtct_patient.age_enrollment=round(datediff(pmtct_patient.date_of_first_consultation,person.birthdate)/365)
where  person_id=pmtct_patient.patient_id;

/*SEXO*/
update pmtct_patient,person set pmtct_patient.sex=.person.gender where  person_id=pmtct_patient.patient_id;

update pmtct_patient,person_name set pmtct_patient.name=.person_name.given_name, pmtct_patient.surname=person_name.family_name where  person_id=pmtct_patient.patient_id;


/*ESTADO CIVIL*/
update pmtct_patient,obs
set pmtct_patient.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=pmtct_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*ESCOLARIDADE*/
update pmtct_patient,obs
set pmtct_patient.education= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=pmtct_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update pmtct_patient,obs
set pmtct_patient.occupation= obs.value_text
where obs.person_id=pmtct_patient.patient_id and obs.concept_id=1459 and voided=0;

/*GESTATIONAL AGE FIRST ANC VISIT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn, obs.value_numeric as code
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in(11)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=1279 
)updateGest
set pmtct_patient.gestational_age=updateGest.code, pmtct_patient.date_of_first_consultation=updateGest.data_cpn
where pmtct_patient.patient_id=updateGest.patient_id;




/*HIV STATUS AT FIRST ANC VISIT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn,  case obs.value_coded  
when 664 then   'NEGATIVE' 
when 1067 then  'UNKNOWN' 
when 703 then   'POSITIVE'  
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in (11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=6385 
)updateState
set pmtct_patient.hiv_status_at_first_ANC_visit=updateState.cod
where pmtct_patient.patient_id=updateState.patient_id;


/*HIV TEST RESULT FIRST VISIT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn as data, case obs.value_coded 
when 664 then 'NEGATIVE' 
when 1138 then 'INDETERMINATE' 
when 703 then 'POSITIVE' 
when 1118 then 'NOT DONE' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and  e.encounter_type in (11)    
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=2079 
)updateState
set pmtct_patient.result_test_hiv=updateState.cod, pmtct_patient.date_test_hiv=updateState.data
where pmtct_patient.patient_id=updateState.patient_id;


/*PARTNER PRESENT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn as data, case obs.value_coded 
        when 1065 then 'YES'
        when 1066 then 'NO'
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and  e.encounter_type in (11)    
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=6368 
)updateState
set pmtct_patient.partner_present=updateState.cod
where pmtct_patient.patient_id=updateState.patient_id;



/*HIV PARTNER TEST RESULT FIRST VISIT AND DATE RESULT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn as data, case obs.value_coded
when 664 then 'NEGATIVE' 
when 1138 then 'INDETERMINATE' 
when 703 then 'POSITIVE' 
when 1118 then 'NOT DONE' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and  e.encounter_type in (11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=2074 
)updatePartnerResult
set pmtct_patient.test_hiv_partner=updatePartnerResult.cod, 
pmtct_patient.test_hiv_partner_date=updatePartnerResult.data
where pmtct_patient.patient_id=updatePartnerResult.patient_id;


/*ESTIMATE DELIVERY DATE*/
update pmtct_patient, obs set pmtct_patient.estimated_delivery_date=obs.value_datetime where obs.person_id=pmtct_patient.patient_id and obs.concept_id=5596 and voided=0;

/*WEIGHT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn, obs.value_numeric as code
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in(11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=5089 
)updateWeight
set pmtct_patient.weight=updateWeight.code
where pmtct_patient.patient_id=updateWeight.patient_id;

/*ARM CIRCUMFERENCE*/
update pmtct_patient,
(
select cpn.patient_id, cpn.data_cpn as data, case obs.value_coded
when 6370 then 'MUAC < 21 CM' 
when 6371 then 'MUAC >= 21 CM AND < 23 CM' 
when 6372 then 'MUAC >= 23 CM'  
else null end as code
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type in (11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=6373 
)updatePB
set pmtct_patient.arm_circumference=updatePB.code
where pmtct_patient.patient_id=updatePB.patient_id;

/*BLOOD PRESSURE AT FIRST ANC VISIT*/
update pmtct_patient,
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
set pmtct_patient.blood_pressure=updateBP.cod
where pmtct_patient.patient_id=updateBP.patient_id;


/*MEMOGLOBIN AT FIRST ANC VISIT*/
update pmtct_patient,
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
    where   p.voided=0 and e.voided=0  and e.encounter_type in (11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=6380
)updateHG
set pmtct_patient.hemoglobin=updateHG.cod
where pmtct_patient.patient_id=updateHG.patient_id;


/*ITS TRATMENT AT FIRST ANC VISIT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn, case obs.value_coded 
when 1065 then 'YES' 
when 1066 then 'NO' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and  e.encounter_type in (11)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=1975
)updateITS
set pmtct_patient.its_tratment=updateITS.cod
where pmtct_patient.patient_id=updateITS.patient_id;


/*SIFLIS TRATMENT AT FIRST ANC VISIT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn as data, case obs.value_coded 
when 1229 then 'NEGATIVE' 
when 1228 then 'POSITIVE'
when 1118 then 'NOT DONE'
 else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type in (11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=299 
)updateSIFLIS
set pmtct_patient.syphilis=updateSIFLIS.cod, pmtct_patient.syphilis_test_date=updateSIFLIS.data
where pmtct_patient.patient_id=updateSIFLIS.patient_id;


/*CTZ TRATMENT AT FIRST ANC VISIT*/
update pmtct_patient,
(
Select distinct cpn.patient_id, cpn.data_cpn as data, case  obs.value_coded
when 1256 then 'START DRUGS' 
when 1257 then 'CONTINUE REGIMEN' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type in (11)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=6121 
)updateCTZ
set pmtct_patient.cotrimoxazole_prophylaxis=updateCTZ.cod
where pmtct_patient.patient_id=updateCTZ.patient_id;



/*TB TRATMENT AT FIRST ANC VISIT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn, case  obs.value_coded
when 1256 then 'START DRUGS' 
when 1257 then 'CONTINUE REGIMEN' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type in (11)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=1268 

)updateTB
set pmtct_patient.TB_treatment=updateTB.cod
where pmtct_patient.patient_id=updateTB.patient_id;



/*ARV TRATMENT AT FIRST ANC VISIT*/
update pmtct_patient,
(
Select cpn.patient_id, cpn.data_cpn,  case obs.value_coded
when 6388 then 'ON ARV TREATMENT AT ANC ENTRANCE' 
when 631  then 'NEVIRAPINE' 
when 1801 then 'ZIDOVUDINE + NEVIRAPINE' 
when 1256 then 'START DRUGS' 
when 1257 then 'CONTINUE REGIMEN' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type in (11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=1504 
)updateART
set pmtct_patient.ART_regimen=updateART.cod
where pmtct_patient.patient_id=updateART.patient_id;


UPDATE pmtct_patient, patient_identifier SET pmtct_patient.NID_mother_ANC = patient_identifier.identifier 
WHERE pmtct_patient.patient_id=patient_identifier.patient_id;


UPDATE pmtct_patient, patient_identifier SET pmtct_patient.NID_mother_ART = patient_identifier.identifier 
WHERE pmtct_patient.patient_id=patient_identifier.patient_id and patient_identifier.identifier_type=2 ;


/*VISITAS */
insert into pmtct_hiv_test_result_each_visit(patient_id,visit_date)
  select  p.patient_id, e.encounter_datetime
  from  patient p 
    inner join encounter e on p.patient_id=e.patient_id
where   e.voided=0 and e.encounter_type =11;

/*STATUS VISIT DATE*/
update pmtct_hiv_test_result_each_visit,obs
set pmtct_hiv_test_result_each_visit.test_hiv=case obs.value_coded when 664 then 'NEGATIVE' when 1138 then 'INDETERMINATE' when 703 then 'POSITIVE' when 1118 then 'NOT DONE' else null end
where obs.obs_datetime=pmtct_hiv_test_result_each_visit.visit_date and obs.person_id=pmtct_hiv_test_result_each_visit.patient_id and obs.concept_id=2079 and voided=0;


/*VISITAS PATNER*/
insert into pmtct_hiv_partner_result_each_visit(patient_id,visit_date)
Select distinct p.patient_id, e.encounter_datetime
from  pmtct_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type =11;

/*STATUS VISIT DATE PATNER*/
update pmtct_hiv_partner_result_each_visit,obs
set pmtct_hiv_partner_result_each_visit.test_hiv=case obs.value_coded when 664 then 'NEGATIVE' when 1138 then 'INDETERMINATE' when 703 then 'POSITIVE' when 1118 then 'NOT DONE' else null end
where obs.obs_datetime=pmtct_hiv_partner_result_each_visit.visit_date and obs.person_id=pmtct_hiv_partner_result_each_visit.patient_id and obs.concept_id=2074 and voided=0;


/*STATUS VISIT DATE PATNER*/
update pmtct_hiv_partner_result_each_visit,obs
set pmtct_hiv_partner_result_each_visit.partner_present=case obs.value_coded  when 1065 then 'YES' when 1066 then 'NO' else null end
where obs.obs_datetime=pmtct_hiv_partner_result_each_visit.visit_date and obs.person_id=pmtct_hiv_partner_result_each_visit.patient_id and obs.concept_id=6368 and voided=0;


/*TARV */
insert into art_mother_patient(patient_id) 
select distinct p.patient_id from  pmtct_patient p where p.result_test_hiv='POSITIVE'
union 
select distinct p.patient_id from  pmtct_patient p where p.hiv_status_at_first_ANC_visit='POSITIVE'
union 
select distinct p.patient_id from  pmtct_hiv_test_result_each_visit p where p.test_hiv='POSITIVE';


/*IDENTIFICACAO DO PACIENTE*/
UPDATE art_mother_patient,patient_identifier SET art_mother_patient.NID_mother_ART = patient_identifier.identifier 
WHERE art_mother_patient.patient_id=patient_identifier.patient_id;

/*DATA AICIMENTO DO PACIENTE*/
UPDATE art_mother_patient, person SET art_mother_patient.birth_date_mother=person.birthdate WHERE art_mother_patient.patient_id=person.person_id;


update art_mother_patient,person_name set art_mother_patient.name=.person_name.given_name, art_mother_patient.surname=person_name.family_name where  person_id=art_mother_patient.patient_id;

/*UPDATE CODPROVENIENCIA*/
update art_mother_patient,
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
set art_mother_patient.hiv_entry_point=proveniencia.codProv
where proveniencia.patient_id=art_mother_patient.patient_id;


/*ESTADO CIVIL*/
update art_mother_patient,obs
set art_mother_patient.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=art_mother_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*ESCOLARIDADE*/
update art_mother_patient,obs
set art_mother_patient.education= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=art_mother_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update art_mother_patient,obs
set art_mother_patient.occupation= obs.value_text
where obs.person_id=art_mother_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO DO PARCEIRO*/
update art_mother_patient,obs
set art_mother_patient.partner_status= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=art_mother_patient.patient_id and obs.concept_id=1449 and obs.voided=0;


/*INICIO TARV*/
UPDATE art_mother_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND p.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE p.voided=0
        AND e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND p.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE p.voided=0
        AND e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id) inicio
   GROUP BY patient_id)inicio_real
SET art_mother_patient.art_initiation_date=inicio_real.data_inicio
WHERE art_mother_patient.patient_id=inicio_real.patient_id;


/*INSCRICAO*/
UPDATE art_mother_patient,

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

SET art_mother_patient.enrollment_date=enrollment.data_abertura
WHERE art_mother_patient.patient_id=enrollment.patient_id;

/*DATA DE NAICIMENTO*/
update art_mother_patient,person set art_mother_patient.age_enrollment=round(datediff(art_mother_patient.enrollment_date,person.birthdate)/365)
where  person_id=art_mother_patient.patient_id;

  /*REGIME*/   
update art_mother_patient,
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
        from    art_mother_patient p 
                inner join encounter e on p.patient_id=e.patient_id
        where   e.encounter_type=18 and e.voided=0  and e.encounter_datetime < dataAvaliacao
                GROUP by e.patient_id
    ) max_fila
    inner join obs o on o.person_id=max_fila.patient_id and o.obs_datetime=max_fila.datafila
    where o.voided=0 and o.concept_id=1088
) fila 
set art_mother_patient.current_treatment_regimen=fila.code
where fila.patient_id=art_mother_patient.patient_id;

    /* ALL CD4*/
insert into art_mother_cd4(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  art_mother_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497   and o.obs_datetime  < dataAvaliacao;

/*CARGA VIRAL*/
insert into art_mother_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  art_mother_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and o.obs_datetime < dataAvaliacao;

    /*LEVANTAMENTO ARV*/
insert into art_mother_art_pick_up(patient_id,regime,art_date)
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
  from  art_mother_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime < dataAvaliacao;

  /*VISITAS*/
insert into art_mother_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  art_mother_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime  < dataAvaliacao;

/* PROXIMA VISITAS*/
update art_mother_visit,obs 
set  art_mother_visit.next_visit_date=obs.value_datetime
where   art_mother_visit.patient_id=obs.person_id and
    art_mother_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;

/*PROXIMO LEVANTAMENTO*/
update art_mother_art_pick_up,obs 
set  art_mother_art_pick_up.next_art_date=obs.value_datetime
where   art_mother_art_pick_up.patient_id=obs.person_id and
    art_mother_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;


    /*LAST CLINIC VISIT*/
update art_mother_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  art_mother_patient p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime  < dataAvaliacao
  group by p.patient_id
)seguimento
set art_mother_patient.last_clinic_visit=seguimento.encounter_datetime
where art_mother_patient.patient_id=seguimento.patient_id;


/*NEXT CLINIC VISIT*/
update  art_mother_patient,obs
set   scheduled_clinic_visit=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_clinic_visit and 
    concept_id=5096 and voided=0;


    /*LAST ART PICKUP*/
update art_mother_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  art_mother_patient p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type=18 and e.encounter_datetime  < dataAvaliacao
  group by p.patient_id
)levantamento
set art_mother_patient.last_artpickup=levantamento.encounter_datetime
where art_mother_patient.patient_id=levantamento.patient_id;


/*NEXT ART PICKUP*/
update  art_mother_patient,obs
set   scheduled_artpickp=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_artpickup and 
    concept_id=5096 and voided=0;


     /*ESTADO ACTUAL TARV*/
update art_mother_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  art_mother_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and ps.start_date < dataAvaliacao
    ) out_state
set   art_mother_patient.patient_status=out_state.codeestado, art_mother_patient.patient_status_date=out_state.start_date
where art_mother_patient.patient_id=out_state.patient_id;


INSERT INTO ccr_patient(patient_id, date_of_register_at_CCR)
SELECT  distinct e.patient_id, e.encounter_datetime FROM   patient p
       INNER JOIN encounter e ON e.patient_id = p.patient_id
WHERE  p.voided = 0 and e.voided=0
       AND e.encounter_type=10
       AND e.voided = 0
       AND e.encounter_datetime BETWEEN startDate AND endDate
group by p.patient_id
HAVING MIN(e.encounter_datetime) = MIN(e.encounter_datetime);


 /*Sexo*/
update ccr_patient,person set ccr_patient.sex=person.gender
where  person.person_id=ccr_patient.patient_id;

/*Data de Naicimento*/
update ccr_patient, person set ccr_patient.birth_date=person.birthdate
where  person_id=ccr_patient.patient_id;

/*IDADE*/
update ccr_patient,person set ccr_patient.age_enrollment=round(datediff(ccr_patient.date_of_register_at_CCR,person.birthdate)/365)
where  person_id=ccr_patient.patient_id;

/*IDENTIFICACAO DO PACIENTE*/
UPDATE ccr_patient,patient_identifier SET ccr_patient.NID_child_CCR = patient_identifier.identifier 
WHERE ccr_patient.patient_id=patient_identifier.patient_id;

/*NOME E SOBRENOME DO PACIENTE*/
update ccr_patient,person_name set ccr_patient.name=.person_name.given_name, ccr_patient.surname=person_name.family_name where  person_id=ccr_patient.patient_id;


/*WEIGHT AO  NAICIMENTO*/
update ccr_patient,
(
select cpn.patient_id, cpn.encounter_id, cpn.data_cpn, obs.value_numeric as code
  from
  ( select  p.patient_id, e.encounter_id, min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in(10)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id  and cpn.encounter_id=obs.encounter_id
  where   obs.voided=0 and obs.concept_id=5916 
)ccrWeight
set ccr_patient.birth_weight=ccrWeight.code
where ccr_patient.patient_id=ccrWeight.patient_id;


/*TIPO DE ACOMPAHANTE*/
update ccr_patient,
(
Select ccr.patient_id, ccr.data_ccr as data, case obs.value_coded
when 970 then 'MOTHER'  
when 971 then 'FATHER' 
when 972 then 'BROTHER' 
when 973 then 'GRANDPARENT' 
when 975 then 'AUNT' 
when 5620 then 'OTHER FAMILY MEMBER' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_ccr
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type=10
    group by p.patient_id
  ) ccr
  inner join obs on obs.person_id=ccr.patient_id and obs.obs_datetime=ccr.data_ccr
  where   obs.voided=0 and obs.concept_id=969 
)updateComp
set ccr_patient.companion=updateComp.cod
where ccr_patient.patient_id=updateComp.patient_id;

/*LOCAL DO PARTO FIRST ANC VISIT*/
update ccr_patient,
(
Select ccr.patient_id, ccr.data_ccr as data, case obs.value_coded 
when 1818 then 'FACILITY BASED DELIVERY'  
when 1817 then 'HOME DELIVERY' 
when 5622 then 'OTHER NON-CODED' 
when 1831 then 'IN TRANSIT' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_ccr
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type=10
    group by p.patient_id
  ) ccr
  inner join obs on obs.person_id=ccr.patient_id and obs.obs_datetime=ccr.data_ccr
  where   obs.voided=0 and obs.concept_id=1581 
)updatePlace
set ccr_patient.place_of_birth=updatePlace.cod
where ccr_patient.patient_id=updatePlace.patient_id;

/*TIPO DO PARTO FIRST ANC VISIT*/
update ccr_patient,
(
Select ccr.patient_id, ccr.data_ccr as data, case obs.value_coded
when 1170 then 'SPONTANEOUS VAGINAL DELIVERY'  
when 1172 then 'BREECH DELIVERY' 
when 1171 then 'CESAREAN SECTION' 
when 5622 then 'OTHER NON-CODED' 
when 1826 then 'STILLBORN' 
when 1115 then 'NORMAL' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_ccr
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type=10
    group by p.patient_id
  ) ccr
  inner join obs on obs.person_id=ccr.patient_id and obs.obs_datetime=ccr.data_ccr
  where   obs.voided=0 and obs.concept_id=5630 
)updatePlace
set ccr_patient.birth_type=updatePlace.cod
where ccr_patient.patient_id=updatePlace.patient_id;

/*REGIME FIRST ANC VISIT*/
update ccr_patient,
(
Select ccr.patient_id, ccr.data_ccr as data, case obs.value_coded  when 1107  then 'NONE'  when 6276 then 'ART' else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_ccr
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0  and e.encounter_type=10
    group by p.patient_id
  ) ccr
  inner join obs on obs.person_id=ccr.patient_id and obs.obs_datetime=ccr.data_ccr
  where   obs.voided=0 and obs.concept_id=6394 
)updateReg
set ccr_patient.ART_regimen_mother=updateReg.cod, ccr_patient.date_ART_regime=updateReg.data
where ccr_patient.patient_id=updateReg.patient_id;

/*CTZ TRATMENT AT FIRST ANC VISIT*/
update ccr_patient,
(
Select ccr.patient_id, ccr.data_cpn as data, case obs.value_coded
when 1257 then 'CONTINUE REGIMEN'  
when 6387 then 'NO COTRIMOXAZOL AT HEALTH UNIT'
when 6411 then 'STARTS COTRIMOXAZOL USE UP TO 8 WEEKS' 
when 6412 then 'TARTS COTRIMOXAZOL USE AFTER 8 WEEKS
' else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in (10)
    group by p.patient_id
  ) ccr
  inner join obs on obs.person_id=ccr.patient_id and obs.obs_datetime=ccr.data_cpn
  where   obs.voided=0 and obs.concept_id=6121 
)updateCTZ
set ccr_patient.cotrimoxazole_prophylaxis=updateCTZ.cod
where ccr_patient.patient_id=updateCTZ.patient_id;

/*IZODEAZIDA TRATMENT AT FIRST ANC VISIT*/
update ccr_patient,
(
select cpn.patient_id, cpn.encounter_id, cpn.data_cpn, case obs.value_coded
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
            else null end as cod
  from
  ( select  p.patient_id, e.encounter_id, min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in(10)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id  and cpn.encounter_id=obs.encounter_id
  where   obs.voided=0 and obs.concept_id=6122 
) seg  
set ccr_patient.prophylaxis_isoniazide=seg.cod, ccr_patient.prophylaxis_isoniazide_date=seg.data_cpn
where seg.patient_id=ccr_patient.patient_id;


/*INFANT TRATMENT AT FIRST ANC VISIT*/
update ccr_patient,
(
Select ccr.patient_id, ccr.data_cpn as data, case obs.value_coded
when 5526 then 'BREASTFED EXCLUSIVELY'  
when 5254 then 'INFANT FORMULA'  
when 6046 then 'MIXED FEEDING' 
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type=10
    group by p.patient_id
  ) ccr
  inner join obs on obs.person_id=ccr.patient_id and obs.obs_datetime=ccr.data_cpn
  where   obs.voided=0 and obs.concept_id=1151 
)updateINF
set ccr_patient.infant_feeding_type=updateINF.cod
where ccr_patient.patient_id=updateINF.patient_id;



/*WEIGTH VISITAS */
insert into ccr_weigh_each_visit(patient_id,visit_date, weight)
Select distinct p.patient_id, o.obs_datetime, o.value_numeric
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=5089 and o.obs_datetime  < dataAvaliacao;


/*HEIGHT VISITAS */
insert into ccr_height_each_visit(patient_id,visit_date, height)
select distinct p.patient_id, o.obs_datetime, o.value_numeric
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=5090 and o.obs_datetime  < dataAvaliacao;

/*PCCR COLECT VISITAS */
insert into ccr_colect_pcr_less_than_two_weeks(patient_id,visit_date,colect)
select distinct p.patient_id, o.obs_datetime, case o.value_coded when 1065 then 'YES' when 1066  then 'NO' else null end 
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=6414 and o.obs_datetime  < dataAvaliacao
group by p.patient_id;


/*CCR COLECT VISITAS */
insert into ccr_colect_pcr_bigger_than_two_weeks(patient_id,visit_date,colect)
select distinct p.patient_id, o.obs_datetime, case o.value_coded when 1065 then 'YES' when 1066  then 'NO' else null end 
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=6415 and o.obs_datetime  < dataAvaliacao
group by p.patient_id;

/*CCR COLECT VISITAS */
insert into ccr_result_pcr_less_than_eight_weeks(patient_id,visit_date,test_result)
select distinct p.patient_id, o.obs_datetime, case o.value_coded when 703 then 'POSITIVE' when 664  then 'NEGATIVE' else null end 
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=6416 and o.obs_datetime  < dataAvaliacao
group by p.patient_id;

/*CCR COLECT VISITAS */
insert into ccr_result_pcr_bigger_than_eight_weeks(patient_id,visit_date,test_result)
select distinct p.patient_id, o.obs_datetime, case o.value_coded when 703 then 'POSITIVE' when 664  then 'NEGATIVE' else null end 
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=6417 and o.obs_datetime  < dataAvaliacao
group by p.patient_id;


/*CCR COLECT VISITAS */
insert into ccr_result_rapid_test(patient_id,visit_date,test_result)
select distinct p.patient_id, o.obs_datetime, case o.value_coded 
when 703  then 'POSITIVE' 
when 664  then 'NEGATIVE' 
when 1138 then 'INDETERMINATE' 
when 1118 then 'NOT DONE'
 else null end 
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=1040 and o.obs_datetime  < dataAvaliacao
group by p.patient_id;


/*CCR COLECT VISITAS */
insert into ccr_result_definitive_test(patient_id,visit_date,test_result)
select distinct p.patient_id, o.obs_datetime, case o.value_coded 
when 703 then 'POSITIVE' 
when 664 then 'NEGATIVE' 
 else null end 
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=6418 and o.obs_datetime  < dataAvaliacao
group by p.patient_id;


/*CCR COLECT VISITAS */
insert into ccr_infant_feeding_type_each_visit(patient_id,visit_date,infant_feeding_type)
select distinct p.patient_id, o.obs_datetime, case o.value_coded 
when 5526 then 'BREASTFED EXCLUSIVELY'  
when 5254 then 'INFANT FORMULA'  
when 6046 then 'MIXED FEEDING' else null end as cod
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.person_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and o.concept_id=1151 and o.obs_datetime  < dataAvaliacao
group by p.patient_id;

/* VISITAS */
insert into ccr_visits(patient_id,visit_date)
Select distinct p.patient_id, e.encounter_datetime
from  ccr_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type =10 and  e.encounter_datetime < dataAvaliacao;


insert into art_child_patient(patient_id,child_status)
select  patient_id, test_result  from ccr_result_rapid_test  where test_result='POSITIVE'
union
select   patient_id, test_result   from ccr_result_pcr_less_than_eight_weeks   where test_result='POSITIVE'
union
select   patient_id, test_result   from ccr_result_pcr_bigger_than_eight_weeks  where test_result='POSITIVE'
union
select   patient_id, test_result  from ccr_result_definitive_test where  test_result='POSITIVE';


UPDATE art_child_patient, patient_identifier SET art_child_patient.NID_child_ART = patient_identifier.identifier 
WHERE art_child_patient.patient_id=patient_identifier.patient_id and patient_identifier.identifier_type=2;


UPDATE art_child_patient, patient_identifier SET art_child_patient.NID_child_CCR = patient_identifier.identifier 
WHERE art_child_patient.patient_id=patient_identifier.patient_id;


update art_child_patient,person_name set art_child_patient.name=person_name.given_name, art_child_patient.surname=person_name.family_name where  person_id=art_child_patient.patient_id;


/*INICIO TARV*/
UPDATE art_child_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND p.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE p.voided=0
        AND e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND p.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE p.voided=0
        AND e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id) inicio
   GROUP BY patient_id)inicio_real
SET art_child_patient.art_initiation_date=inicio_real.data_inicio
WHERE art_child_patient.patient_id=inicio_real.patient_id;


    /* ALL CD4*/
insert into art_child_cd4(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  art_child_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497   and o.obs_datetime  < dataAvaliacao;

/*CARGA VIRAL*/
insert into art_child_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  art_child_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and o.obs_datetime < dataAvaliacao;

    /*LEVANTAMENTO ARV*/
insert into art_child_art_pick_up(patient_id,regime,art_date)
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
  from  art_child_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime < dataAvaliacao;

/*PROXIMO LEVANTAMENTO*/
update art_child_art_pick_up,obs 
set  art_child_art_pick_up.next_art_date=obs.value_datetime
where   art_child_art_pick_up.patient_id=obs.person_id and
    art_child_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

  /*VISITAS*/
insert into art_child_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  art_child_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime  < dataAvaliacao;

/* PROXIMA VISITAS*/
update art_child_visit,obs 
set  art_child_visit.next_visit_date=obs.value_datetime
where   art_child_visit.patient_id=obs.person_id and
    art_child_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;



end
;;
DELIMITER ;
