SET FOREIGN_KEY_CHECKS=0;

 
CREATE TABLE IF NOT EXISTS `hops_47` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `district` varchar(100) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(1) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_at_art_initiation` varchar(4) DEFAULT NULL,
  `WHO_clinical_stage_at_art_initiation_date` datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)) 
   ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

   DROP PROCEDURE IF EXISTS `FillHops_47`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHops_47`(startDate date,endDate date, district varchar(100))
    READS SQL DATA
begin

TRUNCATE TABLE hops_47;

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE hops_47,
       patient_identifier
SET hops_47.patient_id=patient_identifier.patient_id, hops_47.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=hops_47.nid;

/*health facility*/
update hops_47,location
set hops_47.health_facility=location.name
where hops_47.location_id=location.location_id;

  /*Sexo*/
update hops_47,person set hops_47.sex=.person.gender
where  person_id=hops_47.patient_id;

/*INICIO TARV*/
UPDATE hops_47,

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
SET hops_47.art_initiation_date=inicio_real.data_inicio
WHERE hops_47.patient_id=inicio_real.patient_id;

/*INSCRICAO*/
UPDATE hops_47,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,
                              7,53)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment
SET hops_47.enrollment_date=enrollment.data_abertura
WHERE hops_47.patient_id=enrollment.patient_id;

/*ESTADIO OMS AT ENROLLMENT*/
update hops_47,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set hops_47.WHO_clinical_stage_at_enrollment=stage.cod,
hops_47.WHO_clinical_stage_at_enrollment_date=stage.encounter_datetime
where hops_47.patient_id=stage.patient_id 
and hops_47.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;

/*ESTADIO OMS AT ART INITIATION*/
update hops_47,
( select  p.patient_id,
      encounter_datetime encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime
  and o.concept_id=5356
)stage,obs
set hops_47.WHO_clinical_stage_at_art_initiation=stage.cod,
hops_47.WHO_clinical_stage_at_art_initiation_date=stage.encounter_datetime
where hops_47.patient_id=stage.patient_id 
and stage.encounter_datetime=hops_47.art_initiation_date
and hops_47.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/* Urban and Main*/
update hops_47 set urban='N';

update hops_47 set main='N';

if district='Quelimane' then
  update hops_47 set urban='Y'; 
end if;

if district='Namacurra' then
  update hops_47 set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update hops_47 set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update hops_47 set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update hops_47 set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update hops_47 set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update hops_47 set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update hops_47 set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update hops_47 set main='Y' where location_id in (4,55); 
end if;
end
;;
DELIMITER ;







 
