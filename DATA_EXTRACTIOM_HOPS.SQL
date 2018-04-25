SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `hops` (
  `id` int(11) DEFAULT NULL,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `study_code`varchar(100) DEFAULT NULL,
  `old_nid`varchar(100) DEFAULT NULL,
  `new_nid`varchar(100) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
  `study_birth_date` datetime DEFAULT NULL,
  `study_age` int(11) DEFAULT NULL,
  `study_gender`varchar(1) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `openmrs_birth_date` datetime DEFAULT NULL,
  `openmrs_age` int(11) DEFAULT NULL,
  `openmrs_gender` varchar(1) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `first_viral_load_result` int(11)  DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `current_enrollment_in_TB_services` varchar(255) DEFAULT NULL,
  `enrollment_date_TB` datetime DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `imc`    double DEFAULT NULL,
  `imc_date` datetime DEFAULT NULL,
  `hemoglobin` int(11)  DEFAULT NULL,
  `hemoglobin_date` datetime DEFAULT NULL,
  `patient_status` varchar(1) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL,
  `last_visit_date`  datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cd4
-- ----------------------------
DROP TABLE IF EXISTS IN NOT EXISTS `cd4`;
CREATE TABLE `cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `previous_tb_positive_screen` (
  `patient_id` int(11) DEFAULT NULL,
  `tb` double DEFAULT NULL,
  `tb_date` varchar(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP PROCEDURE IF EXISTS `FillHOPS`;
DELIMITER ;;
	CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHOPS`(startDate date,endDate, district varchar(100))
READS SQL DATA

begin

/*BUSCAR ID DO PACIENTE*/
UPDATE hops,
       patient_identifier
SET hops.patient_id = patient_identifier.patient_id
WHERE patient_identifier.identifier_type=2
  AND patient_identifier.identifier=hops.new_nid;

/*DATA DE NAICIMENTO*/
UPDATE hops,
       person
SET hops.openmrs_birth_date=person.birthdate
WHERE hops.patient_id=person.person_id;

/*SEXO*/
UPDATE hops,
       person
SET hops.openmrs_gender=.person.gender
WHERE hops.patient_id=person.person_id;

/*INICIO TARV*/
UPDATE hops,

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
SET hops.art_initiation_date=inicio_real.data_inicio
WHERE hops.patient_id=inicio_real.patient_id;

/*INSCRICAO*/
UPDATE hops,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,
                              7)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment
SET hops.enrollment_date=enrollment.data_abertura
WHERE hops.patient_id=enrollment.patient_id;

/*PRIMEIRA CARGA VIRAL*/
UPDATE hops,

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
SET hops.first_viral_load_result=obs.value_numeric
WHERE hops.patient_id=obs.person_id
  AND hops.patient_id=viral_load1.patient_id
  AND obs.voided=0
  AND obs.obs_datetime=viral_load1.encounter_datetime
  AND obs.concept_id=856;


/*Peso*/
update hops,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set hops.weight=obs.value_numeric, hops.weight_date=peso.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*Altura*/
update hops,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090
  group by p.patient_id
)altura,obs
set hops.height=obs.value_numeric, hops.height_date=altura.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;

/*TB */
update hops,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=6257 
  group by p.patient_id
)tb, obs
set hops.current_enrollment_in_TB_services=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where hops.patient_id=obs.person_id 
and hops.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id=6257;


/*IMC*/
update hops,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=1342
  group by p.patient_id
)imc,obs
set hops.imc=obs.value_numeric, hops.imc=imc.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=imc.patient_id 
and obs.voided=0 and obs.obs_datetime=imc.encounter_datetime


/*HEMOGLOBINA */
update hops,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
      and o.concept_id=1692 
  group by p.patient_id
)hemoglobin,
obs 
set  hops.hemoglobin=obs.value_numeric, hops.hemoglobin_date=hemoglobin.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=hemoglobin.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin.encounter_datetime
 and obs.concept_id=1692 ;


 /*ESTADO ACTUAL TARV*/
update hops,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	hops p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 6 MONTH)
		) out_state
set 	hops.patient_status=out_state.codeestado, hops.patient_status_date=out_state.start_date
where hops.patient_id=out_state.patient_id;


/*ULTIMO SEGUIMENTO*/
update hops,
( select  p.patient_id,max(encounter_datetime) as encounter_datetime
	from    patient p
			inner join encounter e on p.patient_id=e.patient_id
	where   encounter_type in (6,9) and e.voided=0 and
			encounter_datetime between startDate and endDate
	group by p.patient_id
) seguimento
set hops.last_visit_date=seguimento.encounter_datetime
where hops.patient_id=seguimento.patient_id;


/*CD4*/
insert into cd4(patient_id,cd4,cd4_date)
Select distinct	p.patient_id,
		o.value_numeric,
		o.obs_datetime,
from 	hops p 
		inner join encounter e on p.patient_id=e.patient_id	
		inner join obs o on o.encounter_id=e.encounter_id
where 	e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=5497 and o.obs_datetime between startDate and endDate;



/*CD4*/
insert into art_pick_up(patient_id,art,art_date)
Select distinct	p.patient_id,
		o.value_numeric,
		o.obs_datetime,
from 	hops p 
		inner join encounter e on p.patient_id=e.patient_id	
		inner join obs o on o.encounter_id=e.encounter_id
where 	e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=5497 and o.obs_datetime between startDate and endDate;


/*TB*/
insert into previous_tb_positive_screen(patient_id,tb,tb_date)
Select distinct	p.patient_id,
		case o.value_coded
             when 703 then 'POSITIVE'
             when 664 then 'NEGATIVE'
             else null end,
			o.obs_datetime
from 	hops p 
		inner join encounter e on p.patient_id=e.patient_id	
		inner join obs o on o.encounter_id=e.encounter_id
where 	e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=6277 

/*LEVANTAMENTO ARV*/
insert into art_pick_up(patient_id,regime,art_date)
  select  p.patient_id,
  case   o.value_coded     
         WHEN 6324 THEN  'TDF+3TC+EFV'
         WHEN 1651 THEN 'AZT+3TC+NVP'
         WHEN 1703 THEN 'AZT+3TC+EFV'  
         WHEN 6343 THEN 'TDF+3TC+NVP' 
         WHEN 792  THEN 'D4T+3TC+NVP' 
         WHEN 6103 THEN 'D4T+3TC+LPV/r' 
         WHEN 1827 THEN 'D4T+3TC+EFV' 
         WHEN 6102 THEN 'D4T+3TC+ABC' 
         WHEN 6116 THEN 'AZT+3TC+ABC' 
         WHEN 6100 THEN 'AZT+3TC+LPV/r'
         WHEN 6104 THEN 'ABC+3TC+EFV'
         WHEN 6106 THEN 'ABC+3TC+LPV/r'
         WHEN 6108 THEN 'TDF+3TC+LPV/r(2ª Linha)'
         WHEN 1314 THEN 'AZT+3TC+LPV/r(2ª Linha)'
         WHEN 1311 THEN 'ABC+3TC+LPV/r (2ª Linha)'
         WHEN 1315 THEN 'TDF+3TC+EFV (2ª Linha)'
         WHEN 6329 THEN 'TDF+3TC+RAL+DRV/r (3ª Linha)'
         WHEN 6330 THEN 'AZT+3TC+RAL+DRV/r (3ª Linha)'
         else null end,
  		 encounter_datetime
	from    hops p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.person_id=e.patient_id
	where   encounter_type=18  and o. concept_id=1088 and e.voided=0 and p.patient_id=o.person_id

/*PROXIMO SEGUIMENTO*/
update hops, obs o 
set hops.next_visit_date=o.value_datetime
 where hops.last_visit_date=o.obs_datetime 
		and hops.patient_id=o.person_id and 
		 o.concept_id=1410  and o.voided=0;

update hops,location
set hops.health_facility=location.name
where hops.location_id=location.location_id;


update hops set urban='N';

update hops set main='N';

if district='Quelimane' then
	update hops set urban='Y'; 
end if;

if district='Namacurra' then
	update hops set main='Y' where location_id=5; 
end if;

if district='Maganja' then
	update hops set main='Y' where location_id=15; 
end if;

if district='Pebane' then
	update hops set main='Y' where location_id=16; 
end if;

if district='Gile' then
	update hops set main='Y' where location_id=6; 
end if;

if district='Molocue' then
	update hops set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
	update hops set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
	update hops set main='Y' where location_id=7; 
end if;

if district='Ile' then
	update hops set main='Y' where location_id in (4,55); 
end if;




END
;;
DELIMITER ;



