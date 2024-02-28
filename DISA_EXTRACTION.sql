SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `disa_extraction_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `openmrs_birth_date` datetime DEFAULT NULL,
  `openmrs_gender` varchar(1) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `first_viral_load_result` int(11)  DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `disa_extraction_cv`;
CREATE TABLE `disa_extraction_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  `request_id` varchar(30) DEFAULT NULL,
  `harvest_date` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(30) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillDISA`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillDISA`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

truncate table disa_extraction_cv;


SET @location:=location_id_parameter;

/*INSCRICAO*/
insert into disa_extraction_patient(patient_id, enrollment_date, location_id)
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


/*Apagar todos fora desta localização*/
delete from disa_extraction_patient where location_id not in (@location);

/*BUSCAR NID*/
UPDATE disa_extraction_patient,
       patient_identifier
SET  disa_extraction_patient.nid=patient_identifier.identifier
WHERE  disa_extraction_patient.patient_id=patient_identifier.patient_id;

/*DATA DE NASCIMENTO*/
UPDATE disa_extraction_patient,
       person
SET disa_extraction_patient.openmrs_birth_date=person.birthdate
WHERE disa_extraction_patient.patient_id=person.person_id;

/*SEXO*/
UPDATE disa_extraction_patient,
       person
SET disa_extraction_patient.openmrs_gender=.person.gender
WHERE disa_extraction_patient.patient_id=person.person_id;

/* Unidade Sanitaria*/
update disa_extraction_patient,location
set disa_extraction_patient.health_facility=location.name
where disa_extraction_patient.location_id=location.location_id;

/*PRIMEIRA CARGA VIRAL*/
UPDATE disa_extraction_patient,

  (SELECT p.patient_id,
          min(e.encounter_datetime) encounter_datetime
   FROM patient p
   INNER JOIN encounter e ON p.patient_id=e.patient_id
   INNER JOIN obs o ON o.encounter_id=e.encounter_id
   WHERE e.voided=0
     AND o.voided=0
     AND e.encounter_type IN (6,
                              9,
                              13)
     AND o.concept_id=856
   GROUP BY p.patient_id ) viral_load1,
       obs
SET disa_extraction_patient.first_viral_load_result=obs.value_numeric,disa_extraction_patient.first_viral_load_result_date=viral_load1.encounter_datetime
WHERE disa_extraction_patient.patient_id=obs.person_id
  AND disa_extraction_patient.patient_id=viral_load1.patient_id
  AND obs.voided=0
  AND obs.obs_datetime=viral_load1.encounter_datetime
  AND obs.concept_id=856;


/*CARGA VIRAL
insert into disa_extraction_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime,
from  disa_extraction_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (856) and e.encounter_datetime  between startDate and endDate;*/

/*CARGA VIRAL*/
insert into disa_extraction_cv(patient_id,cv,cv_qualit,cv_date,encounter,source,request_id)
select valor.patient_id,valor.value_numeric,valor.value_cod,valor.obs_datetime,valor.encounter_id,valor.encounter_type,requisicao.value_text
from
(Select p.patient_id,
    o.value_numeric,
    case o.value_coded
    when 1306 then 'BEYOND DETECTABLE LIMIT'
    when 1304 then 'POOR SAMPLE QUALITY'
    when 23814 then 'UNDETECTABLE VIRAL LOAD'
    when 23907 then 'LESS THAN 40 COPIES/ML'
    when 23905 then 'LESS THAN 10 COPIES/ML'
    when 23904 then 'LESS THAN 839 COPIES/ML'
    when 23906 then 'LESS THAN 20 COPIES/ML'
    when 23908 then 'LESS THAN 400 COPIES/ML'
    when 165331 then 'LESS THAN'
     else null end as value_cod,
	o.obs_datetime,
    e.encounter_id, case e.encounter_type
     when 13 then 'Ficha Laboratorio'
    when 51 then 'FSR'
    else null end as encounter_type
from  disa_extraction_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (856,1305) and e.encounter_datetime  between startDate and endDate
)  valor 
left join
(
Select p.patient_id,
    o.value_numeric,
    o.obs_datetime,
    o.value_text,
    e.encounter_id
from  disa_extraction_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (22771) and e.encounter_datetime  between startDate and endDate 
) requisicao on valor.encounter_id= requisicao.encounter_id
group by valor.patient_id,valor.obs_datetime,valor.encounter_id; 


/*Data da Colheita*/
update disa_extraction_cv,obs
set  disa_extraction_cv.harvest_date=obs.value_datetime
where   disa_extraction_cv.patient_id=obs.person_id and
    obs.concept_id=23821 and
    obs.voided=0 and disa_extraction_cv.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/* Urban and Main*/
update disa_extraction_patient set urban='N';

update disa_extraction_patient set main='N';

if district='Quelimane' then
  update disa_extraction_patient set urban='Y'; 
end if;

if district='Namacurra' then
  update disa_extraction_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update disa_extraction_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update disa_extraction_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update disa_extraction_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update disa_extraction_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update disa_extraction_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update disa_extraction_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update disa_extraction_patient set main='Y' where location_id in (4,55); 
end if;

end
;;
DELIMITER ;

