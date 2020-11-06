SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `b_prevention` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `study_code`varchar(100) DEFAULT NULL,
  `study_name`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
  `middle_name`varchar(100) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `date_of_first_ANC_visit` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `disclosure_of_serostatus` varchar(100) DEFAULT NULL,
  `serostatus_partner` varchar(100) DEFAULT NULL,
  `who_stage_of_patient` varchar(100) DEFAULT NULL,
  `serostatus_child` varchar(100) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `b_prevention_psychosocial_factors` (
  `patient_id` int(11) DEFAULT NULL,
  `factor` varchar(100) DEFAULT NULL,
  `factor_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `factor_date` (`factor_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `b_prevention_sessions` (
  `patient_id` int(11) DEFAULT NULL,
  `session` varchar(100) DEFAULT NULL,
  `session_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `session_date` (`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `b_prevention_adherence` (
  `patient_id` int(11) DEFAULT NULL,
  `adherence` varchar(100) DEFAULT NULL,
  `adherence_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `adherence_date` (`adherence_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `b_prevention_expected` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `expected_visit_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `expected_visit_date` (`expected_visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `b_pp_messages_delivered`;
CREATE TABLE `b_pp_messages_delivered` (
  `patient_id` int(11) DEFAULT NULL,
  `message` varchar(100) DEFAULT NULL,
  `message_date` datetime DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `b_prevention_consent_contact`;
CREATE TABLE `b_prevention_consent_contact` (
  `patient_id` int(11) DEFAULT NULL,  
  `visit_date` varchar(100) DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `b_prevention_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `art_date` (`art_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `b_prevention_cv`;
CREATE TABLE `b_prevention_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `b_prevention_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP PROCEDURE IF EXISTS `FillTBTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTBTable`(dataAvaliacao date, district varchar(100)) 

READS SQL DATA
begin


/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE b_prevention,
       patient_identifier
SET b_prevention.patient_id = patient_identifier.patient_id, b_prevention.location_id=patient_identifier.location_id
WHERE patient_identifier.identifier_type=2
  AND patient_identifier.identifier=b_prevention.nid;

UPDATE b_prevention, location SET b_prevention.health_facility=location.name where location.location_id=b_prevention.location_id;

  /*FIRST NAME*/
UPDATE b_prevention,
       person_name
SET b_prevention.first_name=person_name.given_name
WHERE b_prevention.patient_id=person_name.person_id;

/*middle_name NAME*/
UPDATE b_prevention,
       person_name
SET b_prevention.middle_name=person_name.middle_name
WHERE b_prevention.patient_id=person_name.person_id;


/*FAMILY NAME*/
UPDATE b_prevention,
       person_name
SET b_prevention.family_name=person_name.family_name
WHERE b_prevention.patient_id=person_name.person_id;


/*INSCRICAO*/
UPDATE b_prevention,

  (
    SELECT e.patient_id, min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,7,53)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id
   ) enrollment
SET b_prevention.enrollment_date=enrollment.data_abertura
WHERE b_prevention.patient_id=enrollment.patient_id;

/*IDADE NA INSCRICAO*/
update b_prevention,person set b_prevention.age_enrollment=round(datediff(b_prevention.enrollment_date,person.birthdate)/365)
where  person_id=b_prevention.patient_id;

update b_prevention set urban='N';

update b_prevention set main='N';

if district='Quelimane' then
  update b_prevention set urban='Y'; 
end if;

if district='Namacurra' then
  update b_prevention set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update b_prevention set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update cvgaac_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update b_prevention set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update b_prevention set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update b_prevention set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update b_prevention set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update b_prevention set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
  update b_prevention set main='Y' where location_id in (252);
end if;


/*ESTADO CIVIL*/
update b_prevention,obs
set b_prevention.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=b_prevention.patient_id and obs.concept_id=1054 and obs.voided=0;

/*ESCOLARIDADE*/
update b_prevention,obs
set b_prevention.education= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=b_prevention.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update b_prevention,obs
set b_prevention.occupation= obs.value_text
where obs.person_id=b_prevention.patient_id and obs.concept_id=1459 and voided=0; 



UPDATE b_prevention,
(
  SELECT DISTINCT e.patient_id, min(e.encounter_datetime) data_inicio FROM patient p
         INNER JOIN encounter e ON e.patient_id = p.patient_id
  WHERE  p.voided = 0 AND e.encounter_type=11 AND e.voided = 0
  GROUP  BY p.patient_id

)cpn 
SET b_prevention.date_of_first_ANC_visit=cpn.data_inicio
where b_prevention.patient_id=cpn.patient_id;

/*INICIO TARV*/
UPDATE b_prevention,

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
      GROUP BY p.patient_id

  ) inicio
   GROUP BY patient_id
   )inicio_real
SET b_prevention.art_initiation_date=inicio_real.data_inicio
WHERE b_prevention.patient_id=inicio_real.patient_id;


 /*PESO AT TIME OF ART ENROLLMENT*/
update b_prevention,
( select  p.patient_id, min(encounter_datetime) encounter_datetime, o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set b_prevention.weight_enrollment=obs.value_numeric, b_prevention.weight_date=peso.encounter_datetime
where b_prevention.patient_id=obs.person_id 
and b_prevention.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;


/*ESTADIO OMS */
update b_prevention,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=5356
  group by p.patient_id
)stage, obs
set b_prevention.who_stage_of_patient=if(obs.value_coded=1204,'I',if(obs.value_coded=1205,'II',if(obs.value_coded=1206,'III','IV')))
where b_prevention.patient_id=obs.person_id 
and b_prevention.patient_id=stage.patient_id 
and obs.voided=0 and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/*ALTURA AT TIME OF ART ENROLLMENT*/
update b_prevention,
( select  p.patient_id as patient_id, min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set b_prevention.height_enrollment=obs.value_numeric, b_prevention.height_date=altura.encounter_datetime
where b_prevention.patient_id=obs.person_id 
and b_prevention.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*ALTURA AT TIME OF ART ENROLLMENT*/
update b_prevention,
( select  p.patient_id, min(encounter_datetime) encounter_datetime,
       case   o.value_coded
              when 1065 then 'YES'
              when 1066 then 'NO'
             else null end as code  
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=34
  and o.obs_datetime=e.encounter_datetime and o.concept_id=1048
  group by p.patient_id
)sr
set b_prevention.disclosure_of_serostatus=sr.code
where b_prevention.patient_id=sr.patient_id;


update b_prevention,
( select  p.patient_id,min(encounter_datetime) encounter_datetime,
       case   o.value_coded
              when 1457 then 'NO INFORMATION'
              when 703  then 'POSITIVE'
              when 664  then 'NEGATIVE'
             else null end as code 
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=34
  and o.obs_datetime=e.encounter_datetime and o.concept_id=2074
  group by p.patient_id
)sr
set b_prevention.serostatus_partner=sr.code
where b_prevention.patient_id=sr.patient_id ;


update b_prevention,
( select  p.patient_id, min(encounter_datetime) encounter_datetime,
       case   o.value_coded
              when 6337  then 'REVEALED'
              when 6338  then 'PARTIALLY REVEALED'
              when 6339  then 'NOT REVEALED'
             else null end as code  
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=34
  and o.obs_datetime=e.encounter_datetime and o.concept_id=6340
  group by p.patient_id
)sr
set b_prevention.serostatus_child=sr.code
where b_prevention.patient_id=sr.patient_id;


   /*PSICOPATASOCIAL FACTOR*/   
insert into b_prevention_psychosocial_factors(patient_id,factor,factor_date)
select  p.patient_id,
       case   o.value_coded
              when 2153 then 'PATIENT HAS LACK OF SUPPORT'
              when 6189 then 'NOT EMPLOYED'
              when 820  then 'TRANSPORT PROBLEMS'
              when 2010 then 'PATIENT IS DISSATISFIED WITH DAY HOSPITAL SERVICES'
              when 2010 then 'PATIENT IS DISSATISFIED WITH DAY HOSPITAL SERVICES'
              when 2155 then 'NOT REVEALED HIS DIAGNOSIS'
              when 2015 then 'PATIENT DOES NOT LIKE ARV TREATMENT SIDE EFFECTS'
              when 6186 then 'PATIENT DOES NOT BELIEVE ARV TREATMENT'
              when 1389 then 'DRUG HABIT(S)'
              when 1750 then 'DOES THE PATIENT SUFFER FROM DEPRESSION'
              when 2017 then 'OTHER REASON WHY PATIENT MISSED VISIT'
             else null end,
             o.obs_datetime     
  from  b_prevention p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where  e.encounter_type=34 and o.concept_id=6193 and e.voided=0 and o.voided=0  and o.obs_datetime  < dataAvaliacao;


insert into b_prevention_sessions(patient_id,session_date)
Select  p.patient_id,e.encounter_datetime 
from  b_prevention p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type=35  and e.encounter_datetime  < dataAvaliacao;

update b_prevention_sessions,obs 
set  b_prevention_sessions.session=case obs.value_coded               
        when 1115  then 'NORMAL'
        when 6311  then 'LOW ADHERENCE'
        when 1707  then 'ABANDONED'
        else null end    
where b_prevention_sessions.patient_id=obs.person_id and
    b_prevention_sessions.session_date=obs.obs_datetime and 
    obs.concept_id=6315 and obs.voided=0;

insert into b_prevention_adherence(patient_id,adherence_date)
Select  p.patient_id,e.encounter_datetime 
from  b_prevention p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type=35 and e.encounter_datetime  < dataAvaliacao;

update b_prevention_adherence,obs 
set  b_prevention_adherence.adherence=case obs.value_coded               
        when 1383  then 'GOOD'
        when 1749  then 'ARV ADHERENCE RISK'
        when 1385  then 'BAD'
        else null end    
where b_prevention_adherence.patient_id=obs.person_id and
    b_prevention_adherence.adherence_date=obs.obs_datetime and 
    obs.concept_id=6223 and obs.voided=0;

insert into b_prevention_expected(patient_id,visit_date)
Select  p.patient_id,e.encounter_datetime 
from  b_prevention p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type=35 and e.encounter_datetime  < dataAvaliacao;


/* PROXIMA VISITAS*/
update b_prevention_expected,obs 
set  b_prevention_expected.expected_visit_date=obs.value_datetime
where   b_prevention_expected.patient_id=obs.person_id and
    b_prevention_expected.visit_date=obs.obs_datetime and 
    obs.concept_id=6310 and 
    obs.voided=0;


    /*mensages PP1*/   
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select p.patient_id, 'PP1 - MESSAGE OF SEXUAL BEHAVIOR AND SUPPLY OF CONDOMS', o.obs_datetime,
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end  
from   b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where    e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=6317 and e.encounter_datetime  < dataAvaliacao;
  
  /*mensages PP2*/  
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select p.patient_id, 'PP2 - MESSAGE DISCLOSING THEIR SEROSTATUS AND KNOWLEDGE / CALL FOR TESTING THE PARTNER', o.obs_datetime, 
case   o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end    
from b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where  e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=6318 and e.encounter_datetime  < dataAvaliacao;

  /*mensages PP3*/   
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select p.patient_id, 
    'PP3 - MESSAGE OF ADHERENCE OF CARE AND TREATMENT',o.obs_datetime,
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end  
from  b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where  e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=6319 and e.encounter_datetime  < dataAvaliacao;


 /*mensages PP4*/   
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select  p.patient_id, 
    'PP4 - MESSAGE OF SEXUALLY TRANSMITTED INFECTION',o.obs_datetime,
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end  
from  b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where  e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=6320 and e.encounter_datetime  < dataAvaliacao;


/*mensages FAMILY PLANNING*/   
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select p.patient_id, 'PP5 - FAMILY PLANNING',o.obs_datetime,
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end  
from  b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where   e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=5271 and e.encounter_datetime  < dataAvaliacao;


/*PMTCT*/  
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select     p.patient_id, 'PP5 - MESSAGE OF PREVENTION OF VERTICAL TRANSMISSION',o.obs_datetime,
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end  
from  b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where   e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=6316 and e.encounter_datetime  < dataAvaliacao;


 /*mensages PP6*/   
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select p.patient_id, 'PP6 - MESSAGE OF CONSUMPTION OF ALCOHOL AND OTHER DRUGS', o.obs_datetime, 
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end  
from  b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where   e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=6321 and e.encounter_datetime  < dataAvaliacao;


           /*mensages PP7*/   
insert into b_pp_messages_delivered(patient_id,message,message_date,answer)
select     p.patient_id,'PP7 - MESSAGE OF THE NEED FOR COMMUNITY SUPPORT SERVICES', o.obs_datetime, 
      case o.value_coded
      when 1065 then 'YES'
      when 1066 then 'NO'
      else null end  
from  b_prevention p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
where   e.encounter_type =35 and o.voided=0 and e.voided=0 and o.concept_id=6322 and e.encounter_datetime  < dataAvaliacao;


insert into b_prevention_consent_contact(patient_id,visit_date)
Select  p.patient_id,e.encounter_datetime 
from  b_prevention p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (34,35) and e.encounter_datetime  < dataAvaliacao;

update b_prevention_consent_contact,obs 
set  b_prevention_consent_contact.answer=case obs.value_coded               
        when 1065  then 'YES'
        when 1066  then 'NO'
        else null end    
where b_prevention_consent_contact.patient_id=obs.person_id and
    b_prevention_consent_contact.visit_date=obs.obs_datetime and 
    obs.concept_id=6306 and obs.voided=0;


    /*CD4*/
insert into b_prevention_cd4(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  b_prevention p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497   and o.obs_datetime  < dataAvaliacao;


/*CARGA VIRAL*/
insert into b_prevention_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime
from  b_prevention p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and o.obs_datetime  < dataAvaliacao;



/*LEVANTAMENTO ARV*/
insert into b_prevention_art_pick_up(patient_id,regime,art_date)
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
  from  b_prevention p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime  < dataAvaliacao;


/*PROXIMO LEVANTAMENTO*/
update b_prevention_art_pick_up,obs 
set  b_prevention_art_pick_up.next_art_date=obs.value_datetime
where   b_prevention_art_pick_up.patient_id=obs.person_id and
    b_prevention_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;


end
;;
DELIMITER ;


