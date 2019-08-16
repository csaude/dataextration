SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `b_prevention` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
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
  `serostatus_child` varchar(100) DEFAULT NULL,

  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `b_prevention_psychosocial_factors` (
  `patient_id` int(11) DEFAULT NULL,
  `factor` double DEFAULT NULL,
  `factor_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `factor_date` (`factor_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `b_prevention_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `art_date` (`art_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure for cvgaac_cv
-- ----------------------------
DROP TABLE IF EXISTS `b_prevention_cv`;
CREATE TABLE `gaac_cv` (
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


-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillBTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillBTable`(startDate date,endDate date,dataAvaliacao date, district varchar(100)) 

READS SQL DATA
begin

/*INSCRICAO*/
UPDATE b_prevention,

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

SET b_prevention.enrollment_date=enrollment.data_abertura
WHERE b_prevention.patient_id=enrollment.patient_id;

/*IDADE NA INSCRICAO*/
update b_prevention,person set b_prevention.age_enrollment=round(datediff(b_prevention.enrollment_date,person.birthdate)/365)
where  person_id=b_prevention.patient_id;



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
set cvgaac_patient.education= case obs.value_coded 
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
      GROUP BY p.patient_id) inicio
   GROUP BY patient_id)inicio_real
SET b_prevention.art_initiation_date=inicio_real.data_inicio
WHERE b_prevention.patient_id=inicio_real.patient_id;


 /*PESO AT TIME OF ART ENROLLMENT*/
update b_prevention,
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
set b_prevention.weight_enrollment=obs.value_numeric, b_prevention.weight_date=peso.encounter_datetime
where b_prevention.patient_id=obs.person_id 
and b_prevention.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update b_prevention,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
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
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
       case   o.value_coded
              when 1065 then 'YES'
              when 1066 then 'NO'
             else null end    
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=34
  and o.obs_datetime=e.encounter_datetime and o.concept_id=1048
  group by p.patient_id
)seroestado
set b_prevention.disclosure_of_serostatus=seroestado.value_coded
where b_prevention.patient_id=seroestado.patient_id 


update b_prevention,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
       case   o.value_coded
              when 1457 then 'NO INFORMATION'
              when 703  then 'POSITIVE'
              when 664  then 'NEGATIVE'
             else null end    
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=34
  and o.obs_datetime=e.encounter_datetime and o.concept_id=2074
  group by p.patient_id
)seroestado
set b_prevention.serostatus_partner=seroestado.value_coded
where b_prevention.patient_id=seroestado.patient_id ;


update b_prevention,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
       case   o.value_coded
              when 6337  then 'REVEALED'
              when 6338  then 'PARTIALLY REVEALED'
              when 6339  then 'NOT REVEALED'
             else null end    
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=34
  and o.obs_datetime=e.encounter_datetime and o.concept_id=6340
  group by p.patient_id
)seroestado
set b_prevention.serostatus_child=seroestado.value_coded
where b_prevention.patient_id=seroestado.patient_id ;


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
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where  e.encounter_type=34 and o.concept_id=6193 and e.voided=0 and o.voided=0