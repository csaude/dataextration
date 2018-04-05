SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for cvgaac_patient_v2
-- ----------------------------

-- ----------------------------
DROP TABLE IF EXISTS `cvgaac_patient_v2`;
CREATE TABLE `cvgaac_patient_v2` (
  `patient_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `last_visit_date`  datetime DEFAULT NULL,
  `last_art_pick_up`  datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `next_artpick_up_date` datetime DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillTCVGAACTableV2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTCVGAACTableV2`(beforeARTStartDate date,cvStartDate date,cvEndDate date,district varchar(100))
    READS SQL DATA
begin

truncate table cvgaac_patient_v2;

/*Inscricao*/
insert into cvgaac_patient_v2(patient_id, location_id)
Select 	e.patient_id, e.location_id
from 	patient p			
		inner join encounter e on e.patient_id=p.patient_id
		inner join person pe on pe.person_id=p.patient_id			
where 	p.voided=0 and e.encounter_type in (5,7) and e.voided=0 and pe.voided=0 and 
		e.encounter_datetime<=beforeARTStartDate
group by p.patient_id;


/*ULTIMO SEGUIMENTO*/
update cvgaac_patient_v2,
( select  p.patient_id,max(encounter_datetime) as encounter_datetime
	from    patient p
			inner join encounter e on p.patient_id=e.patient_id
	where   encounter_type in (6,9) and e.voided=0 and
			encounter_datetime between cvStartDate and cvEndDate
	group by p.patient_id
) seguimento
set cvgaac_patient_v2.last_visit_date=seguimento.encounter_datetime
where cvgaac_patient_v2.patient_id=seguimento.patient_id;

/*PROXIMO SEGUIMENTO*/
update cvgaac_patient_v2, obs o 
set cvgaac_patient_v2.next_visit_date=o.value_datetime
 where cvgaac_patient_v2.last_visit_date=o.obs_datetime 
		and cvgaac_patient_v2.patient_id=o.person_id and 
		 o.concept_id=1410  and o.voided=0;


/*ULTIMO LEVANTAMENTO*/
update cvgaac_patient_v2,
(   select  p.patient_id,max(encounter_datetime) as encounter_datetime
	from    patient p
			inner join encounter e on p.patient_id=e.patient_id
	where   encounter_type=18 and e.voided=0 and
			encounter_datetime between cvStartDate and cvEndDate
	group by p.patient_id
) ultimo
set cvgaac_patient_v2.last_art_pick_up=ultimo.encounter_datetime
where cvgaac_patient_v2.patient_id=ultimo.patient_id;


/*PROXIMO LEVANTAMENTO*/
update cvgaac_patient_v2, obs o 
set cvgaac_patient_v2.next_artpick_up_date=o.value_datetime
 where cvgaac_patient_v2.last_art_pick_up=o.obs_datetime 
		and cvgaac_patient_v2.patient_id=o.person_id and 
		 o.concept_id=5096  and o.voided=0;


update cvgaac_patient_v2,location
set cvgaac_patient_v2.health_facility=location.name
where cvgaac_patient_v2.location_id=location.location_id;

update cvgaac_patient_v2 set urban='N';

update cvgaac_patient_v2 set main='N';

if district='Quelimane' then
	update cvgaac_patient_v2 set urban='Y'; 
end if;

if district='Namacurra' then
	update cvgaac_patient_v2 set main='Y' where location_id=5; 
end if;

if district='Maganja' then
	update cvgaac_patient_v2 set main='Y' where location_id=15; 
end if;

if district='Pebane' then
	update cvgaac_patient_v2 set main='Y' where location_id=16; 
end if;

if district='Gile' then
	update cvgaac_patient_v2 set main='Y' where location_id=6; 
end if;

if district='Molocue' then
	update cvgaac_patient_v2 set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
	update cvgaac_patient_v2 set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
	update cvgaac_patient_v2 set main='Y' where location_id=7; 
end if;

if district='Ile' then
	update cvgaac_patient_v2 set main='Y' where location_id in (4,55); 
end if;

end
;;
DELIMITER ;

