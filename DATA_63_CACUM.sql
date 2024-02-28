SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `cacum_patient`;
CREATE TABLE  `cacum_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `current_age` int(11) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `adress_1` varchar(100) DEFAULT null,
  `adress_2` varchar(100) DEFAULT null,
  `village` varchar(100) DEFAULT null,
  `art_initiation_date` datetime DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `women_status` varchar(100) DEFAULT NULL,
  `number_children_enrollment` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `cacum_related`;
CREATE TABLE  `cacum_related` (
  `patient_id` int(11) DEFAULT NULL,
  `hiv` varchar(100) DEFAULT null,
  `visit_date` datetime DEFAULT NULL,
  `age_first_sexual` int(11) DEFAULT NULL,
  `via_result` varchar(100) DEFAULT null,
  `cryotherapy_same_day_via` varchar(100) DEFAULT null,
  `reference_hospital_name` varchar(100) DEFAULT null,
  `reason_referral_1` varchar(100) DEFAULT null,
  `reason_referral_2` varchar(100) DEFAULT null,
  `reason_referral_3` varchar(100) DEFAULT null,
  `reason_referral_4` varchar(100) DEFAULT null,
  `reason_referral_5` varchar(100) DEFAULT null,
  `hdr` varchar(100) DEFAULT null,
  `reference_result_hdr1` varchar(100) DEFAULT null,
  `reference_result_hdr2` varchar(100) DEFAULT null,
  `reference_result_hdr3` varchar(100) DEFAULT null,
  `reference_result_hdr4` varchar(100) DEFAULT null,
  `reference_result_hdr5` varchar(100) DEFAULT null,
  `reference_result_hdr6` varchar(100) DEFAULT null,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT 'Rastreio dos Cancros do Colo do Utero e da Mama'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `cacum_women_pregnant_lactation`;
CREATE TABLE  `cacum_women_pregnant_lactation` (
  `patient_id` int(11) DEFAULT NULL,
  `date_status` datetime DEFAULT NULL, 
  `cacum_women_status` varchar(100) DEFAULT null,
  `source` varchar(100) DEFAULT null
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


  DROP PROCEDURE IF EXISTS `FillCACUM`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillCACUM`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

TRUNCATE TABLE cacum_related;
TRUNCATE TABLE cacum_women_pregnant_lactation;

SET @location:=location_id_parameter;


/*INSCRICAO*/
insert into cacum_patient(patient_id, enrollment_date, location_id)
        SELECT preTarvFinal.patient_id,preTarvFinal.initialDate,preTarvFinal.location FROM
         
         (   
             SELECT preTarv.patient_id, MIN(preTarv.initialDate) initialDate,preTarv.location as location FROM 
             ( 
             SELECT p.patient_id,min(o.value_datetime) AS initialDate,e.location_id as location FROM patient p  
             
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type=53 
             AND o.value_datetime IS NOT NULL AND o.concept_id=23808 AND o.value_datetime<=endDate
             GROUP BY p.patient_id 
             UNION 
             SELECT p.patient_id,min(e.encounter_datetime) AS initialDate,e.location_id as location FROM patient p 
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type IN(5,7) 
             AND e.encounter_datetime<=endDate 
             GROUP BY p.patient_id 
             UNION 
             SELECT pg.patient_id, MIN(pg.date_enrolled) AS initialDate,pg.location_id as location FROM patient p 
             INNER JOIN patient_program pg on pg.patient_id=p.patient_id 
             WHERE pg.program_id=1  AND pg.voided=0 AND pg.date_enrolled<=endDate  GROUP BY patient_id 
              ) preTarv 
             GROUP BY preTarv.patient_id
        ) 
      preTarvFinal where preTarvFinal.initialDate <= endDate
      GROUP BY preTarvFinal.patient_id;

Update cacum_patient set cacum_patient.district=district;

update cacum_patient,location
set cacum_patient.health_facility=location.name
where cacum_patient.location_id=location.location_id;

/*Apagar todos fora desta localização*/
delete from cacum_patient where location_id not in (@location);

/*DATA DE NASCIMENTO*/
UPDATE cacum_patient,
       person
SET cacum_patient.date_of_birth=person.birthdate
WHERE cacum_patient.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update cacum_patient,person set cacum_patient.age_enrollment=round(datediff(cacum_patient.enrollment_date,person.birthdate)/365)
where  person_id=cacum_patient.patient_id;

/*Data de Nascimento*/
update cacum_patient,person set cacum_patient.current_age=round(datediff("2023-09-20",person.birthdate)/365)
where  person_id=cacum_patient.patient_id;

  /*Sexo*/
update cacum_patient,person set cacum_patient.sex=.person.gender
where  person.person_id=cacum_patient.patient_id;


/*Exclusion criteria*/
delete from cacum_patient where current_age<15;

/*Exclusion criteria*/
delete from cacum_patient where sex='M';

/*PROFISSAO*/
update cacum_patient,obs
set cacum_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=cacum_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESCOLARIDADE*/
update cacum_patient,obs
set cacum_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
             else null end        
where obs.person_id=cacum_patient.patient_id and obs.concept_id=1443 and voided=0;

/*ESTADO CIVIL*/
update cacum_patient,obs
set cacum_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=cacum_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*Adress1*/
update cacum_patient,person_address set cacum_patient.adress_1=person_address.address1
where person_id=cacum_patient.patient_id;

/*Adress2*/
update cacum_patient,person_address set cacum_patient.adress_2=person_address.address2
where person_id=cacum_patient.patient_id;

/*last_city_village*/
update cacum_patient,person_address set cacum_patient.village=person_address.city_village
where person_id=cacum_patient.patient_id;

/*INICIO TARV*/
UPDATE cacum_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM cacum_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM cacum_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM cacum_patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM cacum_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET cacum_patient.art_initiation_date=inicio_real.data_inicio
WHERE cacum_patient.patient_id=inicio_real.patient_id;

/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update cacum_patient,obs
set cacum_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where cacum_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=cacum_patient.enrollment_date;

update cacum_patient,obs
set cacum_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where cacum_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=cacum_patient.enrollment_date and cacum_patient.pregnancy_status_at_enrollment is null;

update cacum_patient,patient_program
set cacum_patient.pregnancy_status_at_enrollment= 'YES'
where cacum_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;

/*WOMEN STATUS GRAVIDA/LACTANTE*/
update cacum_patient,
  (  select patient_id,decisao from  (  select inicio_real.patient_id,
            				gravida_real.data_gravida,  lactante_real.data_parto,
            				if(max(gravida_real.data_gravida) is null and max(lactante_real.data_parto) is null,null,
            				if(max(gravida_real.data_gravida) is null,'Lactante',
            				if(max(lactante_real.data_parto) is null,'Gravida',
            				if(max(lactante_real.data_parto)>max(gravida_real.data_gravida),'Lactante','Gravida')))) decisao from (	 
            				select p.patient_id  from patient p  inner join encounter e on e.patient_id=p.patient_id
            				where e.voided=0 and p.voided=0 and e.encounter_type in (5,7) and e.encounter_datetime<=endDate and e.location_id = location_id
            				union  select pg.patient_id from patient p
            				inner join patient_program pg on p.patient_id=pg.patient_id
            				where pg.voided=0 and p.voided=0 and program_id in (1,2) and date_enrolled<=endDate and location_id
            				union  Select p.patient_id from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type=53 and
            				o.concept_id=23891 and o.value_datetime is not null and
            				o.value_datetime<=endDate and e.location_id  )inicio_real  left join  (
            				Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1982 and value_coded=1065 and
            				e.encounter_type in (5,6) and e.encounter_datetime  between startDate and endDate and e.location_id
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1279 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1600 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id	 
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6334 and value_coded=6331 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id		 
            				union  select pp.patient_id,pp.date_enrolled data_gravida from patient_program pp
            				where pp.program_id=8 and pp.voided=0 and
            				pp.date_enrolled between startDate and endDate and pp.location_id  union
            				Select p.patient_id,obsART.value_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				inner join obs obsART on e.encounter_id=obsART.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=1982 and o.value_coded=1065 and
            				e.encounter_type=53 and obsART.value_datetime between startDate and endDate and e.location_id and
            				obsART.concept_id=1190 and obsART.voided=0  union
            				Select p.patient_id,o.value_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=1465 and
            				e.encounter_type=6 and o.value_datetime between startDate and endDate and e.location_id
            				) gravida_real on gravida_real.patient_id=inicio_real.patient_id    left join   (
            				Select p.patient_id,o.value_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where  p.voided=0 and e.voided=0 and o.voided=0 and concept_id=5599 and
            				e.encounter_type in (5,6) and o.value_datetime between startDate and endDate and e.location_id	 
            				union  Select p.patient_id, e.encounter_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6332 and value_coded=1065 and
            				e.encounter_type=6 and e.encounter_datetime between startDate and endDate and e.location_id
            				union  Select p.patient_id, obsART.value_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				inner join obs obsART on e.encounter_id=obsART.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=6332 and o.value_coded=1065 and
            				e.encounter_type=53 and e.location_id and
            				obsART.value_datetime between startDate and endDate and
            				obsART.concept_id=1190 and obsART.voided=0  union
            				Select p.patient_id, e.encounter_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6334 and value_coded=6332 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id
            				union  select pg.patient_id,ps.start_date data_parto from patient p
            				inner join patient_program pg on p.patient_id=pg.patient_id
            				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
            				where pg.voided=0 and ps.voided=0 and p.voided=0 and
            				pg.program_id=8 and ps.state=27 and
            				ps.start_date between startDate and endDate and location_id
            				) lactante_real on lactante_real.patient_id=inicio_real.patient_id
            				where lactante_real.data_parto is not null or gravida_real.data_gravida is not null
            				group by inicio_real.patient_id  ) gravidaLactante		 
            				inner join person pe on pe.person_id=gravidaLactante.patient_id		 
            				where pe.voided=0 and pe.gender='F') gravidaLactante 
        set cacum_patient.women_status=gravidaLactante.decisao
        where  cacum_patient.patient_id=gravidaLactante.patient_id;

  /*cacum_related*/
insert into cacum_related(patient_id,hiv,visit_date,encounter)
Select p.patient_id,
    case o.value_coded
             when 703 then 'POSITIVE'
             when 664 then 'NEGATIVE'
             when 1457 then 'NO INFORMATION'
             when 1138 then 'INDETERMINATE'
             else null end,
      o.obs_datetime, e.encounter_id
from  cacum_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=28 and o.concept_id=2143 and e.encounter_datetime  < endDate;


/*Idade da 1ª relação sexual*/
update cacum_related,obs
set  cacum_related.age_first_sexual=obs.value_numeric
where   cacum_related.patient_id=obs.person_id and
    cacum_related.visit_date=obs.obs_datetime and
    cacum_related.encounter=obs.encounter_id and
    obs.concept_id=2126 and
    obs.voided=0;

/*Resultado Rastreio com VIA*/
update cacum_related,obs
set  cacum_related.via_result= case obs.value_coded
            when 2093 THEN 'SUSPECTED CANCER'
            when 664 THEN 'NEGATIVE'
            when 703 THEN 'POSITIVE'
            when 5622 THEN 'OTHER'
            when 165341 THEN 'VIA POSITIVE > 75%'
            when 165342 THEN 'VIA POSITIVE < 75%'
            else null end
where   cacum_related.patient_id=obs.person_id and
    cacum_related.visit_date=obs.obs_datetime and
    cacum_related.encounter=obs.encounter_id and
    obs.concept_id=2094 and
    obs.voided=0;

/*Se VIA + ou Resultado de HPV 16/18 POSITIVO*/
update cacum_related,obs
set  cacum_related.cryotherapy_same_day_via= case obs.value_coded
            when 1066 THEN 'NO'
            when 1065 THEN 'YES'
            else null end
where   cacum_related.patient_id=obs.person_id and
    cacum_related.visit_date=obs.obs_datetime and
    cacum_related.encounter=obs.encounter_id and
    obs.concept_id=2117 and
    obs.voided=0;


 /*Referencia para Hospital*/
update cacum_related,obs
set  cacum_related.reference_hospital_name=obs.value_text
where   cacum_related.patient_id=obs.person_id and
    cacum_related.visit_date=obs.obs_datetime and
    cacum_related.encounter=obs.encounter_id and
    obs.concept_id=1460 and
    obs.voided=0;

/*Razoes para referencia*/
UPDATE cacum_related
SET 
    cacum_related.reason_referral_1 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2122
                    AND obs.value_coded = 2093
                    AND obs.voided = 0
            )
            THEN 'SUSPECTED CANCER'
            ELSE NULL
        END,
    
    cacum_related.reason_referral_2 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2122
                    AND obs.value_coded = 165341
                    AND obs.voided = 0
            )
            THEN 'VIA Positive > 75%'
            ELSE NULL
        END,

    cacum_related.reason_referral_3 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2122
                    AND obs.value_coded = 2120
                    AND obs.voided = 0
            )
            THEN 'LESION INVADING THE VAGINAL WALL'
            ELSE NULL
        END,

    cacum_related.reason_referral_4 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2122
                    AND obs.value_coded = 23969
                    AND obs.voided = 0
            )
            THEN 'Changes in the breast'
            ELSE NULL
        END,

    cacum_related.reason_referral_5 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2122
                    AND obs.value_coded = 2097
                    AND obs.voided = 0
            )
            THEN 'SQUAMOCOLUMNAR JUNCTION NOT VIEWED'
            ELSE NULL
        END;


    /*Referral Hospital HDR*/
    update cacum_related,obs
set  cacum_related.hdr= case obs.value_coded
                       when 1065 THEN 'YES'
            else null end
where   cacum_related.patient_id=obs.person_id and
    cacum_related.visit_date=obs.obs_datetime and
    cacum_related.encounter=obs.encounter_id and
    obs.concept_id=165345 and
    obs.voided=0;

    /*VIA RESULT ON THE REFERENCE*/
   UPDATE cacum_related
SET 
    cacum_related.reference_result_hdr1 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2149
                    AND obs.value_coded = 23970
                    AND obs.voided = 0
            )
            THEN 'LEEP'
            ELSE NULL
        END,
    
    cacum_related.reference_result_hdr2 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2149
                    AND obs.value_coded = 23972
                    AND obs.voided = 0
            )
            THEN 'Thermocoagulation'
            ELSE NULL
        END,

    cacum_related.reference_result_hdr3 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2149
                    AND obs.value_coded = 23974
                    AND obs.voided = 0
            )
            THEN 'Cryotherapy'
            ELSE NULL
        END,

    cacum_related.reference_result_hdr4 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2149
                    AND obs.value_coded = 23973
                    AND obs.voided = 0
            )
            THEN 'Conization'
            ELSE NULL
        END,

    cacum_related.reference_result_hdr5 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2149
                    AND obs.value_coded = 23971
                    AND obs.voided = 0
            )
            THEN 'Hysteroctomy'
            ELSE NULL
        END,
    
    cacum_related.reference_result_hdr6 = 
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM obs
                WHERE 
                    cacum_related.patient_id = obs.person_id
                    AND cacum_related.visit_date = obs.obs_datetime
                    AND cacum_related.encounter = obs.encounter_id
                    AND obs.concept_id = 2149
                    AND obs.value_coded = 5622
                    AND obs.voided = 0
            )
            THEN 'OTHER'
            ELSE NULL
        END;

/*CACUM WOMEN STATUS*/
insert into cacum_women_pregnant_lactation(patient_id,date_status,cacum_women_status,source)
SELECT p.patient_id,
       e.encounter_datetime data_gravida,
       'PREGNANT' status,
       CONCAT(CASE e.encounter_type
                WHEN 5 THEN 'PROCESSO PARTE A - INICIAL'
                WHEN 6 THEN 'FICHA CLINICA'
              END, ' - CONCEPT (1982) GESTANTE') AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND concept_id = 1982
       AND value_coded = 1065
       AND e.encounter_type IN ( 5, 6 )
       AND e.encounter_datetime BETWEEN startDate AND endDate
       
UNION
SELECT p.patient_id,
       e.encounter_datetime                                 data_gravida,
       'PREGNANT'                                           status,
       CONCAT(CASE e.encounter_type
                WHEN 5 THEN 'PROCESSO PARTE A - INICIAL'
                WHEN 6 THEN 'FICHA CLINICA'
              END, ' - CONCEPT (1279) SEMANAS DE GESTACAO') AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND concept_id = 1279
       AND e.encounter_type IN ( 5, 6 )
       AND e.encounter_datetime BETWEEN startDate AND endDate
       
UNION
SELECT p.patient_id,
       e.encounter_datetime                              data_gravida,
       'PREGNANT'                                        status,
       CONCAT(CASE e.encounter_type
                WHEN 5 THEN 'PROCESSO PARTE A - INICIAL'
                WHEN 6 THEN 'FICHA CLINICA'
              END, ' - CONCEPT (1600) DATA DE GRAVIDEZ') AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND concept_id = 1600
       AND e.encounter_type IN ( 5, 6 )
       AND e.encounter_datetime BETWEEN startDate AND endDate
       
UNION
SELECT p.patient_id,
       e.encounter_datetime                     data_gravida,
       'PREGNANT'                               status,
       CONCAT(CASE e.encounter_type
                WHEN 5 THEN 'PROCESSO PARTE A - INICIAL'
                WHEN 6 THEN 'FICHA CLINICA'
              END, ' - CONCEPT (6334-6331) B+') AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND concept_id = 6334
       AND value_coded = 6331
       AND e.encounter_type IN ( 5, 6 )
       AND e.encounter_datetime BETWEEN startDate AND endDate
       
UNION
SELECT pp.patient_id,
       pp.date_enrolled data_gravida,
       'PREGNANT'       status,
       'PROGRAM - PTV'
FROM   patient_program pp
WHERE  pp.program_id = 8
       AND pp.voided = 0
       AND pp.date_enrolled BETWEEN startDate AND endDate
       
UNION
SELECT p.patient_id,
       obsART.value_datetime                    data_gravida,
       'PREGNANT'                               status,
       'FICHA RESUMO - CONCEPT (1982) GESTANTE' source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
       INNER JOIN obs obsART
               ON e.encounter_id = obsART.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND o.concept_id = 1982
       AND o.value_coded = 1065
       AND e.encounter_type = 53
       AND obsART.value_datetime BETWEEN startDate AND endDate
       
       AND obsART.concept_id = 1190
       AND obsART.voided = 0
UNION
SELECT p.patient_id,
       data_colheita.value_datetime            data_gravida,
       'PREGNANT'                              status,
       'FICHA E-LAB - CONCEPT (1982) GESTANTE' source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs esta_gravida
               ON e.encounter_id = esta_gravida.encounter_id
       INNER JOIN obs data_colheita
               ON data_colheita.encounter_id = e.encounter_id
WHERE   e.voided = 0
       AND esta_gravida.voided = 0
       AND data_colheita.voided = 0
       AND esta_gravida.concept_id = 1982
       AND esta_gravida.value_coded = 1065
       AND e.encounter_type = 51
       AND data_colheita.concept_id = 23821
       AND data_colheita.value_datetime BETWEEN startDate AND endDate
       
UNION
SELECT p.patient_id,
       o.value_datetime                              data_parto,
       'BREASTFEEDING'                               status,
       CONCAT(CASE e.encounter_type
                WHEN 5 THEN 'PROCESSO PARTE A - INICIAL'
                WHEN 6 THEN 'FICHA CLINICA'
              END, ' - CONCEPT (5599) DELIVERY DAY') AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND concept_id = 5599
       AND e.encounter_type IN ( 5, 6 )
       AND o.value_datetime BETWEEN startDate AND endDate
       
UNION
SELECT p.patient_id,
       e.encounter_datetime                       data_parto,
       'BREASTFEEDING'                            status,
       CONCAT(CASE e.encounter_type
                WHEN 5 THEN 'PROCESSO PARTE A - INICIAL'
                WHEN 6 THEN 'FICHA CLINICA'
              END, ' - CONCEPT (6332) LACTATION') AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND concept_id = 6332
       AND value_coded = 1065
       AND e.encounter_type = 6
       AND e.encounter_datetime BETWEEN startDate AND endDate
       
UNION
SELECT p.patient_id,
       obsART.value_datetime                     data_parto,
       'BREASTFEEDING'                           status,
       'FICHA RESUMO - CONCEPT (5532) LACTATION' AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
       INNER JOIN obs obsART
               ON e.encounter_id = obsART.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND o.concept_id = 6332
       AND o.value_coded = 1065
       AND e.encounter_type = 53
              AND obsART.value_datetime BETWEEN startDate AND endDate
       AND obsART.concept_id = 1190
       AND obsART.voided = 0
UNION
SELECT p.patient_id,
       e.encounter_datetime                            data_parto,
       'BREASTFEEDING'                                 status,
       CONCAT(CASE e.encounter_type
                WHEN 5 THEN 'PROCESSO PARTE A - INICIAL'
                WHEN 6 THEN 'FICHA CLINICA'
              END, ' - CONCEPT (6334/6332) LACTATION') AS source
FROM   cacum_patient p
       INNER JOIN encounter e
               ON p.patient_id = e.patient_id
       INNER JOIN obs o
               ON e.encounter_id = o.encounter_id
WHERE   e.voided = 0
       AND o.voided = 0
       AND concept_id = 6334
       AND value_coded = 6332
       AND e.encounter_type IN ( 5, 6 )
       AND e.encounter_datetime BETWEEN startDate AND endDate
       
UNION
SELECT pg.patient_id,
       ps.start_date   data_parto,
       'BREASTFEEDING' status,
       'PROGRAM - PTV'
FROM   cacum_patient p
       INNER JOIN patient_program pg
               ON p.patient_id = pg.patient_id
       INNER JOIN patient_state ps
               ON pg.patient_program_id = ps.patient_program_id
WHERE  pg.voided = 0
       AND ps.voided = 0
       AND pg.program_id = 8
       AND ps.state = 27
       AND ps.start_date BETWEEN startDate AND endDate;

    /*URBAN AND MAIN*/
update cacum_patient set urban='N';
update cacum_patient set main='N';
if district='Quelimane' then
  update cacum_patient set urban='Y';
end if;
if district='Namacurra' then
  update cacum_patient set main='Y' where location_id=5;
end if;
if district='Maganja' then
  update cacum_patient set main='Y' where location_id=15;
end if;
if district='Pebane' then
  update cacum_patient set main='Y' where location_id=16;
end if;
if district='Gile' then
  update cacum_patient set main='Y' where location_id=6;
end if;
if district='Molocue' then
  update cacum_patient set main='Y' where location_id=3;
end if;
if district='Mocubela' then
  update cacum_patient set main='Y' where location_id=62;
end if;
if district='Inhassunge' then
  update cacum_patient set main='Y' where location_id=7;
end if;
if district='Ile' then
  update cacum_patient set main='Y' where location_id in (4,55);
end if;
if district='Namarroi' then
  update cacum_patient set main='Y' where location_id in (252);
end if;
if district='Mopeia' then
  update cacum_patient set main='Y' where location_id in (11);
end if;
if district='Morrumbala' then
  update cacum_patient set main='Y' where location_id in (13);
end if;
if district='Gurue' then
  update cacum_patient set main='Y' where location_id in (280);
end if;
if district='Mocuba' then
  update cacum_patient set main='Y' where location_id in (227);
end if;
if district='Nicoadala' then
  update cacum_patient set main='Y' where location_id in (277);
end if;
if district='Milange' then
  update cacum_patient set main='Y' where location_id in (281);
end if;

end
;;
DELIMITER ;