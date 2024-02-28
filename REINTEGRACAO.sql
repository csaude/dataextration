SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `rei_patient`;
CREATE TABLE  `rei_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `current_age` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rei_reint_visit`;
CREATE TABLE `rei_reint_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_type` varchar(255) DEFAULT NULL,
  `first_visit_date` datetime DEFAULT NULL,
  `found_1` varchar(25) DEFAULT NULL,
  `second_visit_date` datetime DEFAULT NULL,
  `third_visit_date` datetime DEFAULT NULL,
  `reason_missed_visit` varchar(255) DEFAULT NULL,
  `date_return_us_1` datetime DEFAULT NULL,
  `date_return_us_2` datetime DEFAULT NULL,
  `date_return_us_3` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for Fillewh
-- ----------------------------
DROP PROCEDURE IF EXISTS `REINTEG`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `REINTEG`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

truncate table rei_reint_visit;


/*INSCRICAO*/
insert into rei_patient(patient_id, enrollment_date, location_id)
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
delete from rei_patient where location_id not in (@location);

/*distrito*/
Update rei_patient set rei_patient.district=district;

/*NID*/
UPDATE rei_patient,
       patient_identifier
SET rei_patient.nid=patient_identifier.identifier
where rei_patient.patient_id=patient_identifier.patient_id;


/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE rei_patient,
       patient_identifier
SET rei_patient.patient_id=patient_identifier.patient_id, rei_patient.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=rei_patient.nid;

/*Local*/
update rei_patient,location
set rei_patient.health_facility=location.name
where rei_patient.location_id=location.location_id;

  /*Sexo*/
update rei_patient,person set rei_patient.sex=person.gender
where  person.person_id=rei_patient.patient_id;

/*DATA DE NASCIMENTO*/
UPDATE rei_patient,
       person
SET rei_patient.date_of_birth=person.birthdate
WHERE rei_patient.patient_id=person.person_id;

/*IDADE ACTUAL*/
update rei_patient,person set rei_patient.current_age=timestampdiff(year,person.birthdate,endDate) where
person_id=rei_patient.patient_id;

/*IDADE NA INSCRICAO*/
update rei_patient,person set rei_patient.age_enrollment=round(datediff(rei_patient.enrollment_date,person.birthdate)/365)
where  person_id=rei_patient.patient_id;


 /*VISITAS REITEGRAÇÃO*/
insert into rei_reint_visit(patient_id,first_visit_date,visit_type, found_1, encounter)
select 
consultas.patient_id,
consultas.encounter_datetime,
tipo_visita.encounter_type,
encontrado.found_1,
consultas.encounter_id
from
-- Consultas
(Select 
p.patient_id, 
e.encounter_datetime, 
e.encounter_id
from 
sp_patient p inner join encounter e on p.patient_id=e.patient_id
where   e.voided=0  and e.encounter_type=21 and e.encounter_datetime  BETWEEN startDate AND endDate
) consultas

-- Informacao adicional das consultas
left  join
(
Select 
e.encounter_id,
case o.value_coded
    when 2161 then 'SUPPORT VISIT'
    when 2160 then 'MISSED VISIT'
    when 23914 then 'VISIT FOR SPECIAL CASES'
 else null end as encounter_type

from  sp_patient p
    inner join encounter e on p.patient_id=e.patient_id
    INNER JOIN obs o ON o.encounter_id=e.encounter_id
where   e.voided=0 and o.concept_id in (1981) and e.encounter_type=21 and e.encounter_datetime  BETWEEN startDate AND endDate

) tipo_visita on consultas.encounter_id=tipo_visita.encounter_id
left  join
(
Select
e.encounter_id,
    case o.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as found_1
from  sp_patient p
    inner join encounter e on p.patient_id=e.patient_id
    INNER JOIN obs o ON o.encounter_id=e.encounter_id
where   e.voided=0 and o.concept_id in (2003) and e.encounter_type=21 and e.encounter_datetime  BETWEEN startDate AND endDate
) encontrado on consultas.encounter_id=encontrado.encounter_id;


/*segunda visita*/
update rei_reint_visit,encounter,obs
set rei_reint_visit.second_visit_date=obs.value_datetime
where rei_reint_visit.patient_id=obs.person_id 
and rei_reint_visit.encounter=obs.encounter_id
and obs.concept_id=6254 and encounter.encounter_type=21 and obs.voided=0;

/*terceira visita*/
update rei_reint_visit,encounter,obs
set rei_reint_visit.third_visit_date=obs.value_datetime
where rei_reint_visit.patient_id=obs.person_id 
and rei_reint_visit.encounter=obs.encounter_id
and obs.concept_id=6255 and encounter.encounter_type=21 and obs.voided=0;

/*motivos de falta*/
UPDATE rei_reint_visit,
(select
reii.encounter_id,
GROUP_CONCAT(reii.motivo) AS motivo
from
(
    SELECT
o.encounter_id,
o.obs_id,
        CASE o.value_coded
            WHEN 2005 THEN 'PATIENT FORGOT VISIT DATE '
            WHEN 2013 THEN 'PATIENT IS TREATING HIV WITH TRADITIONAL MEDICINE '
            WHEN 2009 THEN 'PATIENT HAS SOCIAL PROBLEMS '
            WHEN 2011 THEN 'PATIENT TOOK A TRIP '
            WHEN 2007 THEN 'DISTANCE OR MONEY FOR TRANSPORT IS TO MUCH FOR PATIENT '
            WHEN 2014 THEN 'PATIENTS WORK PREVENTS CLINIC VISIT '
            WHEN 2012 THEN 'PATIENT HAS LACK OF MOTIVATION '
            WHEN 2008 THEN 'PATIENT HAS LACK OF FOOD '
            WHEN 5622 THEN 'Other '
            WHEN 2010 THEN 'PATIENT IS DISSATISFIED WITH DAY HOSPITAL SERVICES '
            WHEN 2015 THEN 'PATIENT DOES NOT LIKE ARV TREATMENT SIDE EFFECTS '
            WHEN 2006 THEN 'PATIENT IS BEDRIDDEN AT HOME '
            WHEN 2017 THEN 'OTHER REASON WHY PATIENT MISSED VISIT '
            WHEN 6436 THEN 'STIGMA '
            WHEN 6439 THEN 'Changed health unit '
            WHEN 1956 THEN 'PATIENT DOES NOT BELIEVE TEST RESULTS '
            WHEN 6186 THEN 'PATIENT DOES NOT BELIEVE ARV TREATMENT '
            WHEN 6437 THEN 'Partner does not allow to return to health facility '
            WHEN 23863 THEN 'AUTO TRANSFER '
            WHEN 23915 THEN 'FEAR OF THE PROVIDER '
            WHEN 23946 THEN 'Absence of Health Provider in Health Unit '
            WHEN 1898 THEN 'RELIGION '
            WHEN 1706 THEN 'TRANSFERRED OUT TO ANOTHER FACILITY '
            WHEN 6303 THEN 'BASED GENDER VIOLENCE '
            WHEN 23767 THEN 'FEEL BETTER (E)'
                     ELSE NULL
        END as motivo
    FROM obs o
    INNER JOIN encounter e ON e.encounter_id = o.encounter_id
    WHERE e.voided = 0
        AND o.voided = 0
        AND o.concept_id = 2016
) reii

group by reii.encounter_id
) rei

SET rei_reint_visit.reason_missed_visit=rei.motivo
WHERE  rei_reint_visit.encounter = rei.encounter_id;

/*retorno primeira visita*/
update rei_reint_visit,encounter,obs
set rei_reint_visit.date_return_us_1=obs.value_datetime
where rei_reint_visit.patient_id=obs.person_id 
and rei_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23933 and encounter.encounter_type=21 and obs.voided=0;

/*retorno segunda visita*/
update rei_reint_visit,encounter,obs
set rei_reint_visit.date_return_us_2=obs.value_datetime
where rei_reint_visit.patient_id=obs.person_id 
and rei_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23934 and encounter.encounter_type=21 and obs.voided=0;

/*retorno terceira visita*/
update rei_reint_visit,encounter,obs
set rei_reint_visit.date_return_us_3=obs.value_datetime
where rei_reint_visit.patient_id=obs.person_id 
and rei_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23935 and encounter.encounter_type=21 and obs.voided=0;


/* Urban and Main*/
update rei_patient set urban='N';

update rei_patient set main='N';

if district='Quelimane' then
  update rei_patient set urban='Y'; 
end if;

if district='Namacurra' then
  update rei_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update rei_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update rei_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update rei_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update rei_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update rei_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update rei_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update rei_patient set main='Y' where location_id in (4,55); 
end if;

end
;;
DELIMITER ;