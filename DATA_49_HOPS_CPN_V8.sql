SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `hops_cpn`;
CREATE TABLE IF NOT EXISTS `hops_cpn` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `openmrs_gender`varchar(100) DEFAULT NULL,
  `date_of_delivery` datetime DEFAULT NULL,
  `family_planning` varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_visit_cpn`;
CREATE TABLE IF NOT EXISTS `hops_visit_cpn` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_visit_estimate_delivery`;
CREATE TABLE IF NOT EXISTS `hops_visit_estimate_delivery` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_cpn_type_of_method`;
CREATE TABLE `hops_cpn_type_of_method` (
  `patient_id` int(11) DEFAULT NULL,
  `type_date` datetime DEFAULT NULL,
  `type_of_method` varchar(100) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_cpn_family_planning`;
CREATE TABLE `hops_cpn_family_planning` (
  `patient_id` int(11) DEFAULT NULL,
  `fp_date` datetime DEFAULT NULL,
  `fp` varchar(100) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `hops_cpn_status_each_consultation`;
CREATE TABLE `hops_cpn_status_each_consultation` (
  `patient_id` int(11) DEFAULT NULL,
  `patient__status_date` datetime DEFAULT NULL,
  `patient__status` varchar(100) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_cpn_last_menstrual_period`;
CREATE TABLE `hops_cpn_last_menstrual_period` (
  `patient_id` int(11) DEFAULT NULL,
  `hosp_cpn_last_menstrual_period_date` datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Procedure structure for HOPS CPN
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillHOPS`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHOPS`(startDate date,endDate date, district varchar(100))
    READS SQL DATA
begin

truncate table hops_visit_cpn;
truncate table hops_visit_estimate_delivery;
truncate table hops_cpn_type_of_method;
truncate table hops_cpn_family_planning;
truncate table hops_cpn_status_each_consultation;
truncate table hops_cpn_last_menstrual_period;




/*INSCRICAO*/
update  hops_cpn,       
        (  SELECT enrolment.patient_id, MIN(enrolment.initialDate) initialDate FROM 
             ( 
             SELECT p.patient_id,min(o.value_datetime) AS initialDate FROM patient p  
             
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type=53 
             AND o.value_datetime IS NOT NULL AND o.concept_id=23808 AND o.value_datetime<=endDate
             GROUP BY p.patient_id 
             UNION 
             SELECT p.patient_id,min(e.encounter_datetime) AS initialDate FROM patient p 
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type IN(5,7) 
             AND e.encounter_datetime<=endDate 
             GROUP BY p.patient_id 
             UNION 
             SELECT pg.patient_id, MIN(pg.date_enrolled) AS initialDate FROM patient p 
             INNER JOIN patient_program pg on pg.patient_id=p.patient_id 
             WHERE pg.program_id in(1,2)  AND pg.voided=0 AND pg.date_enrolled<=endDate  GROUP BY patient_id 
              ) enrolment 
            GROUP BY enrolment.patient_id
        ) 
      enrolmentFinal set hops_cpn.enrollment_date=enrolmentFinal.initialDate;


/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE hops_cpn,
       patient_identifier
SET hops_cpn.patient_id=patient_identifier.patient_id, hops_cpn.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=hops_cpn.nid;

update hops_cpn,location
set hops_cpn.health_facility=location.name
where hops_cpn.location_id=location.location_id;

/*SEXO*/
UPDATE hops_cpn,
       person
SET hops_cpn.openmrs_gender=.person.gender
WHERE hops_cpn.patient_id=person.person_id;

/*DATA DE NASCIMENTO*/
UPDATE hops_cpn,
       person
SET hops_cpn.date_of_birth=person.birthdate
WHERE hops_cpn.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update hops_cpn,person set hops_cpn.age_enrollment=round(datediff(hops_cpn.enrollment_date,person.birthdate)/365) where  person_id=hops_cpn.patient_id;

/*delete from hops_cpn where age_enrollment<18;*/



/*VISITAS CPN*/
insert into hops_visit_cpn(patient_id,visit_date,source)
Select  p.patient_id,o.obs_datetime,"FICHA RESUMO" 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and e.encounter_type in(53) and o.concept_id in (1982,6332) and o.value_coded in(1065) and o.voided=0 and e.encounter_datetime  BETWEEN startDate AND endDate
GROUP BY p.patient_id;

/*VISITAS CPN*/
insert into hops_visit_cpn(patient_id,visit_date,source)
Select  p.patient_id,o.obs_datetime,"FICHA CLINICA"
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and e.encounter_type in (6,9) and o.concept_id in (1982,6332) and o.value_coded in(1065) and o.voided=0 and e.encounter_datetime BETWEEN startDate AND endDate
GROUP BY p.patient_id;


/*VISITAS DATA PREVISTA DO PARTO*/
insert into hops_visit_estimate_delivery(patient_id,visit_date,source)
Select p.patient_id,o.value_datetime,"ADULTO:PROCESSO PARTE A-ANAMNESE"
from hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on e.encounter_id=o.encounter_id
where e.voided=0 and e.encounter_type in(67) and o.concept_id in(1600) and o.voided=0 and e.encounter_datetime BETWEEN startDate AND endDate
GROUP BY p.patient_id;

update hops_visit_cpn,obs 
set  hops_visit_cpn.next_visit_date=obs.value_datetime
where  hops_visit_cpn.patient_id=obs.person_id and
    hops_visit_cpn.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;

/*DATA DO PARTO*/
update hops_cpn,encounter,obs 
set hops_cpn.date_of_delivery=obs.value_datetime
where hops_cpn.patient_id=obs.person_id 
      and encounter.encounter_datetime=obs.obs_datetime 
      and encounter.encounter_type=67
      and obs.concept_id=5599;


/*DMC DISPENSATION VISIT*/
update hops_cpn,
(
Select distinct p.patient_id,e.encounter_datetime 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and o.voided=0 and e.encounter_type in (6,9) 
      and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=23725 
      and o.value_coded in(1256,1257,1267)
      GROUP BY p.patient_id
 )obs_planning
set hops_cpn.family_planning=case obs_planning.encounter_datetime when null then 'NO' else 'YES' end;


/*hops_cpn_type_of_method*/
insert into hops_cpn_type_of_method(patient_id,type_date,type_of_method,source)
select distinct p.patient_id,e.encounter_datetime,
    case   o.value_coded     
        when 1107  then 'NONE'
        when 190   then 'CONDOMS'
        when 780   then 'ORAL CONTRACEPTION'
        when 5279  then 'INJECTABLE CONTRACEPTIVES'
        when 21928 then 'IMPLANT'
        when 5275  then 'INTRAUTERINE DEVICE'
        when 5276  then 'FEMALE STERILIZATION'
        when 23714 then 'VASECTOMY'
        when 23714 then 'LACTATIONAL AMENORRAY METHOD'      
        else null end as type, "FICHA CLINICA"
  from hops_cpn p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where e.encounter_type in(6,9) and o.concept_id=374  and e.voided=0 and e.encounter_datetime=o.obs_datetime and o.obs_datetime BETWEEN startDate AND endDate
  GROUP BY p.patient_id;

  /*hops_cpn_family_planning*/
insert into hops_cpn_family_planning(patient_id,fp_date,source)
Select distinct p.patient_id,e.encounter_datetime,"FICHA CLINICA" 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate
GROUP BY p.patient_id;


update hops_cpn_family_planning,obs,encounter 
set  hops_cpn_family_planning.fp= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where  hops_cpn_family_planning.patient_id=obs.person_id and
    hops_cpn_family_planning.fp_date=obs.obs_datetime and 
    obs.concept_id=23725 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_cpn_family_planning.fp_date=encounter.encounter_datetime;


  /*hops_cpn_status_each_consultation*/
insert into hops_cpn_status_each_consultation(patient_id,patient__status_date,source)
Select distinct p.patient_id,e.encounter_datetime,"FICHA CLINICA" 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate
GROUP BY p.patient_id;


update hops_cpn_status_each_consultation,obs,encounter 
set  hops_cpn_status_each_consultation.patient__status= case obs.value_coded
             when 1709 then  'SUSPEND TREATMENT'
             when 1707 then  'DROPPED FROM TREATMENT'
             when 1705 then  'RESTART'
             when 1706 then  'TRANSFERRED OUT TO ANOTHER FACILITY'
             when 1366 then  'PATIENT HAS DIED'
             when 23903 then 'NEGATIVE DIAGNOSIS'
             else null end
where  hops_cpn_status_each_consultation.patient_id=obs.person_id and
    hops_cpn_status_each_consultation.patient__status_date=obs.obs_datetime and 
    obs.concept_id=6273 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and hops_cpn_status_each_consultation.patient__status_date=encounter.encounter_datetime;


  /*hosp_cpn_last_menstrual_period*/
insert into hops_cpn_last_menstrual_period(patient_id,hosp_cpn_last_menstrual_period_date,source)
Select distinct p.patient_id,o.value_datetime,"FICHA CLINICA" 
from  hops_cpn p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=1465
GROUP BY p.patient_id;

update hops_cpn set urban='N';

update hops_cpn set main='N';

if district='Quelimane' then
  update hops_cpn set urban='Y'; 
end if;

if district='Namacurra' then
  update hops_cpn set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update hops_cpn set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update hops_cpn set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update hops_cpn set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update hops_cpn set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update hops_cpn set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update hops_cpn set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update hops_cpn set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
  update hops_cpn set main='Y' where location_id in (252);
end if;

if district='Mopeia' then
  update hops_cpn set main='Y' where location_id in (11);
end if;

if district='Morrumbala' then
  update hops_cpn set main='Y' where location_id in (13);
end if;

if district='Gurue' then
  update hops_cpn set main='Y' where location_id in (280);
end if;

if district='Mocuba' then
  update hops_cpn set main='Y' where location_id in (227);
end if;

if district='Nicoadala' then
  update hops_cpn set main='Y' where location_id in (277);
end if;

if district='Milange' then
  update hops_cpn set main='Y' where location_id in (281);
end if;

end
;;
DELIMITER ;
