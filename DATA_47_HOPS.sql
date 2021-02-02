SET FOREIGN_KEY_CHECKS=0;

 
CREATE TABLE IF NOT EXISTS `hops_47` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `nid`varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `date_of_ART_initiation` datetime DEFAULT NULL, 
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
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

/*DATA DE NASCIMENTO*/
UPDATE hops_47,
       person
SET hops_47.date_of_birth=person.birthdate
WHERE hops_47.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update hops_47,person set hops_47.age_enrollment=round(datediff(hops_47.enrollment_date,person.birthdate)/365)
where  person_id=hops_47.patient_id;

delete from hops_47 where age_enrollment<=18;

/*district*/ 
Update hops_47 set hops_47.district=district;

update hops_47,location
set hops_47.health_facility=location.name
where hops_47.location_id=location.location_id;

  /*Sexo*/
update hops_47,person set hops_47.sex=.person.gender
where  person_id=hops_47.patient_id;

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
and stage.encounter_datetime=hops_47.date_of_ART_initiation
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







 
