SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sms_patient
-- ----------------------------
DROP TABLE IF EXISTS `sms_patient`;
CREATE TABLE `sms_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,   
  `sex` varchar(1) DEFAULT NULL,
  `patient_birthdate`  datetime DEFAULT NULL,  
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `partner_status` varchar(100) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,  
  `art_initiation_date` datetime DEFAULT NULL,
  `pregnancy_status` varchar(10) DEFAULT NULL,
  `date_delivery` datetime DEFAULT NULL,  
  `enrolled_gaac` varchar(1) DEFAULT NULL,
  `enrolled_gaac_date` datetime DEFAULT NULL,  
  `last_artpickup_at3` datetime DEFAULT NULL,
  `scheduled_artpickup3` datetime DEFAULT NULL,  
  `last_artpickup_at6` datetime DEFAULT NULL,
  `scheduled_artpickup6` datetime DEFAULT NULL,  
  `last_artpickup_at12` datetime DEFAULT NULL,
  `scheduled_artpickup12` datetime DEFAULT NULL,  
  `last_clinic_at3` datetime DEFAULT NULL,
  `last_clinic_at6` datetime DEFAULT NULL,
  `last_clinic_at12` datetime DEFAULT NULL,  
  `patient_status3` varchar(100) DEFAULT NULL,
  `patient_status3_date` datetime DEFAULT NULL,
  `patient_status6` varchar(100) DEFAULT NULL,
  `patient_status6_date` datetime DEFAULT NULL,  
  `patient_status12` varchar(100) DEFAULT NULL,
  `patient_status12_date` datetime DEFAULT NULL,
  `date_consent_sms` datetime DEFAULT NULL,  
  `has_phone_number` varchar(5) DEFAULT NULL,  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `sms_patient_patient_id` (`patient_id`),
  KEY `sms_patient_enrollment_date` (`enrollment_date`),
  KEY `sms_patient_art_initiation_date` (`art_initiation_date`),
  KEY `sms_patient_enrolled_gaac_date` (`enrolled_gaac_date`)  
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_sent
-- ----------------------------
DROP TABLE IF EXISTS `sms_sent`;
CREATE TABLE `sms_sent` (
  `patient_id` int(11) DEFAULT NULL,
  `alert_date` datetime DEFAULT NULL,
  `date_sent` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `date_sent` (`date_sent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sms_artpickup`;
CREATE TABLE `sms_artpickup` (
  `patient_id` int(11) DEFAULT NULL,
  `art_pickup_date` datetime DEFAULT NULL,
  `art_pickup_schedulled` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `art_pickup_date` (`art_pickup_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sms_patientstatus`;
CREATE TABLE `sms_patientstatus` (
  `patient_id` int(11) DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_status_startdate` datetime DEFAULT NULL,
  `patient_status_enddate` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `patient_status_startdate` (`patient_status_startdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;	


-- ----------------------------
-- Procedure structure for FillTSMSTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillTSMSTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTSMSTable`(enrollmentStartDate date,enrollmentEndDate date,district varchar(100),location int,dateDataEval date)
    READS SQL DATA
begin

truncate table sms_patient;
truncate table sms_sent;
truncate table sms_artpickup;
truncate table sms_patientstatus;


/*Enrollment date, Sex,Age at enrollment*/
insert into sms_patient(patient_id,enrollment_date,sex,age_enrollment,location_id, patient_birthdate)
Select 	e.patient_id,
		min(encounter_datetime) data_abertura,
		gender,
		round(datediff(e.encounter_datetime,pe.birthdate)/365) idade_abertura,
		e.location_id,
		pe.birthdate
from 	patient p			
		inner join encounter e on e.patient_id=p.patient_id
		inner join person pe on pe.person_id=p.patient_id			
where 	p.voided=0 and e.encounter_type in (5,7) and e.voided=0 and pe.voided=0 and 
		e.encounter_datetime between enrollmentStartDate and enrollmentEndDate and e.location_id=location
group by p.patient_id;


/*ART initiation date*/
update sms_patient,
(	Select patient_id,min(data_inicio) data_inicio
	from
			(	Select 	p.patient_id,min(e.encounter_datetime) data_inicio
				from 	patient p 
						inner join encounter e on p.patient_id=e.patient_id	
						inner join obs o on o.encounter_id=e.encounter_id
				where 	e.voided=0 and o.voided=0 and p.voided=0 and 
						e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and 
						e.encounter_datetime<=dateDataEval
				group by p.patient_id
		
				union
		
				Select 	p.patient_id,min(value_datetime) data_inicio
				from 	patient p
						inner join encounter e on p.patient_id=e.patient_id
						inner join obs o on e.encounter_id=o.encounter_id
				where 	p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and 
						o.concept_id=1190 and o.value_datetime is not null and 
						o.value_datetime<=dateDataEval
				group by p.patient_id

				union

				select 	pg.patient_id,date_enrolled data_inicio
				from 	patient p inner join patient_program pg on p.patient_id=pg.patient_id
				where 	pg.voided=0 and p.voided=0 and program_id=2 and date_enrolled<=dateDataEval
				
				union
				
				
			  SELECT 	e.patient_id, MIN(e.encounter_datetime) AS data_inicio 
			  FROM 		patient p
						inner join encounter e on p.patient_id=e.patient_id
			  WHERE		p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=dateDataEval
			  GROUP BY 	p.patient_id				
				
				
			) inicio
		group by patient_id	
)inicio_real	
set sms_patient.art_initiation_date=inicio_real.data_inicio
where sms_patient.patient_id=inicio_real.patient_id;

/*Removing patient who has no ART Initiation Date*/
delete from sms_patient where art_initiation_date is null;

delete from sms_patient where art_initiation_date<enrollment_date;



/*Health facility, Urban, Main*/
update sms_patient,location
set sms_patient.health_facility=location.name
where sms_patient.location_id=location.location_id;

update sms_patient set urban='N';

update sms_patient set main='N';

if district='Quelimane' then
	update sms_patient set urban='Y'; 
end if;

if district='Namacurra' then
	update sms_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
	update sms_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
	update sms_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
	update sms_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
	update sms_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
	update sms_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
	update sms_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
	update sms_patient set main='Y' where location_id in (4,55); 
end if;

/*Gaac Enrollment*/
update sms_patient,gaac,gaac_member
set sms_patient.enrolled_gaac='Y',sms_patient.enrolled_gaac_date=gaac_member.start_date
where sms_patient.patient_id=gaac_member.member_id and gaac_member.gaac_id=gaac.gaac_id;


/*Educational level at enrollment*/
update sms_patient,obs
set sms_patient.education= case obs.value_coded 
					   when 1445 then 'NONE'
					   when 1446 then 'PRIMARY SCHOOL'
					   when 1447 then 'SECONDARY SCHOOL'
					   when 6124 then 'TECHNICAL SCHOOL'
					   when 1444 then 'SECONDARY SCHOOL'
					   when 6125 then 'TECHNICAL SCHOOL'
					   when 1448 then 'UNIVERSITY'
					else null end
where obs.person_id=sms_patient.patient_id and obs.concept_id=1443 and voided=0;

/*Occupation at enrollment*/
update sms_patient,obs
set sms_patient.occupation= obs.value_text
where obs.person_id=sms_patient.patient_id and obs.concept_id=1459 and voided=0;

/*Marital status at enrollment*/
update sms_patient,obs
set sms_patient.marital_status= case obs.value_coded
					   when 1057 then 'SINGLE'
					   when 5555 then 'MARRIED'
					   when 1059 then 'WIDOWED'
					   when 1060 then 'LIVING WITH PARTNER'
					   when 1056 then 'SEPARATED'
					   when 1058 then 'DIVORCED'
					   else null end
where obs.person_id=sms_patient.patient_id and obs.concept_id=1054 and obs.voided=0;


/*Partner HIV status at enrollment*/
update sms_patient,obs
set sms_patient.partner_status= case obs.value_coded
					   when 1169 then 'POSITIVE'
					   when 1066 then 'NEGATIVE'
					   when 1457 then 'NO INFO.'
					   else null end
where obs.person_id=sms_patient.patient_id and obs.concept_id=1449 and obs.voided=0;


/*Pregnancy status at time of ART enrollment*/
update sms_patient,obs
set sms_patient.pregnancy_status= if(obs.value_coded=44,'YES',null)
where sms_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=sms_patient.enrollment_date;

update sms_patient,obs
set sms_patient.pregnancy_status= if(obs.value_numeric is not null,'YES',null)
where sms_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=sms_patient.enrollment_date and sms_patient.pregnancy_status is null;


update sms_patient,patient_program
set sms_patient.pregnancy_status= 'YES'
where sms_patient.patient_id=patient_program.patient_id and program_id=8 and date_enrolled between art_initiation_date and date_add(art_initiation_date,interval 1 month) and voided=0 and pregnancy_status is null;

/*Date of delivery*/
update sms_patient,obs
set sms_patient.date_delivery= obs.value_datetime
where sms_patient.patient_id=obs.person_id  and obs.concept_id=1600 and obs.obs_datetime=sms_patient.enrollment_date;

update sms_patient,patient_program,patient_state
set sms_patient.date_delivery=patient_state.start_date
where 	sms_patient.patient_id=patient_program.patient_id and 
		patient_program.patient_program_id=patient_state.patient_program_id and 
		program_id=8 and date_enrolled between art_initiation_date and date_add(art_initiation_date,interval 1 month) and 
		patient_program.voided=0 and patient_state.voided=0 and 
		patient_state.state=27;



/*Patient State at 3 month*/
update sms_patient,
		(	select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
			from 	sms_patient p 
					inner join patient_program pg on p.patient_id=pg.patient_id
					inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
			where 	pg.voided=0 and ps.voided=0 and  
					pg.program_id=2 and ps.state in (7,8,9,10) and (ps.end_date is null or ps.end_date<date_add(p.art_initiation_date,interval 3 month)) and 
					ps.start_date between p.art_initiation_date and date_add(p.art_initiation_date,interval 3 month)
		) saida
set 	sms_patient.patient_status3=saida.codeestado,
		sms_patient.patient_status3_date=saida.start_date
where saida.patient_id=sms_patient.patient_id;


/*Patient State at 6 month*/
update sms_patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	sms_patient p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and (ps.end_date is null or ps.end_date<date_add(p.art_initiation_date,interval 6 month)) and 
				ps.start_date between p.art_initiation_date and date_add(p.art_initiation_date,interval 6 month)
		) saida
set 	sms_patient.patient_status6=saida.codeestado,
		sms_patient.patient_status6_date=saida.start_date
where saida.patient_id=sms_patient.patient_id;


/*Patient State at 12 month*/
update sms_patient,
		(	select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
			from 	sms_patient p 
					inner join patient_program pg on p.patient_id=pg.patient_id
					inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
			where 	pg.voided=0 and ps.voided=0 and  
					pg.program_id=2 and ps.state in (7,8,9,10) and (ps.end_date is null or ps.end_date<date_add(p.art_initiation_date,interval 12 month)) and 
					ps.start_date between p.art_initiation_date and date_add(p.art_initiation_date,interval 12 month)
		) saida
set 	sms_patient.patient_status12=saida.codeestado,
		sms_patient.patient_status12_date=saida.start_date
where saida.patient_id=sms_patient.patient_id;


/*DEAD state in demographics at 3 month*/
update 	sms_patient,person
set 	sms_patient.patient_status3='DEAD',
		sms_patient.patient_status3_date=person.death_date
where 	person.person_id=sms_patient.patient_id and patient_status3 is null and dead=1 and 
		person.death_date between art_initiation_date and date_add(art_initiation_date,interval 3 month) and person.death_date is not null;
		
/*DEAD state in demographics at 6 month*/
update 	sms_patient,person
set 	sms_patient.patient_status6='DEAD',
		sms_patient.patient_status6_date=person.death_date
where 	person.person_id=sms_patient.patient_id and patient_status6 is null and dead=1 and 
		person.death_date between art_initiation_date and date_add(art_initiation_date,interval 6 month) and person.death_date is not null;
		
		
/*DEAD state in demographics at 12 month*/
update 	sms_patient,person
set 	sms_patient.patient_status12='DEAD',
		sms_patient.patient_status12_date=person.death_date
where 	person.person_id=sms_patient.patient_id and patient_status12 is null and dead=1 and 
		person.death_date between art_initiation_date and date_add(art_initiation_date,interval 12 month) and person.death_date is not null;

/*Last follow up date at 3 month on art*/
update sms_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	sms_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime between p.art_initiation_date and date_add(p.art_initiation_date,interval 3 month)
	group by p.patient_id
)seguimento
set sms_patient.last_clinic_at3=seguimento.encounter_datetime
where sms_patient.patient_id=seguimento.patient_id;

/*Last follow up date at 6 month on art*/
update sms_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	sms_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime between p.art_initiation_date and date_add(p.art_initiation_date,interval 6 month)
	group by p.patient_id
)seguimento
set sms_patient.last_clinic_at6=seguimento.encounter_datetime
where sms_patient.patient_id=seguimento.patient_id;

/*Last follow up date at 12 month on art*/
update sms_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	sms_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime between p.art_initiation_date and date_add(p.art_initiation_date,interval 12 month)
	group by p.patient_id
)seguimento
set sms_patient.last_clinic_at12=seguimento.encounter_datetime
where sms_patient.patient_id=seguimento.patient_id;


/*Last art pickup and schedulled at 3 month on ART*/
update sms_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	sms_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type=18 and e.encounter_datetime between p.art_initiation_date and date_add(p.art_initiation_date,interval 3 month)
	group by p.patient_id
)levantamento
set sms_patient.last_artpickup_at3=levantamento.encounter_datetime
where sms_patient.patient_id=levantamento.patient_id;

update 	sms_patient,obs
set 	scheduled_artpickup3=value_datetime
where 	patient_id=person_id and 
		obs_datetime=last_artpickup_at3 and 
		concept_id=5096 and voided=0;		

/*Last art pickup and schedulled at 6 month on ART*/
update sms_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	sms_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type=18 and e.encounter_datetime between p.art_initiation_date and date_add(p.art_initiation_date,interval 6 month)
	group by p.patient_id
)levantamento
set sms_patient.last_artpickup_at6=levantamento.encounter_datetime
where sms_patient.patient_id=levantamento.patient_id;

update 	sms_patient,obs
set 	scheduled_artpickup6=value_datetime
where 	patient_id=person_id and 
		obs_datetime=last_artpickup_at6 and 
		concept_id=5096 and voided=0;		
		
/*Last art pickup and schedulled at 12 month on ART*/
update sms_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	sms_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type=18 and e.encounter_datetime between p.art_initiation_date and date_add(p.art_initiation_date,interval 12 month)
	group by p.patient_id
)levantamento
set sms_patient.last_artpickup_at12=levantamento.encounter_datetime
where sms_patient.patient_id=levantamento.patient_id;

update 	sms_patient,obs
set 	scheduled_artpickup12=value_datetime
where 	patient_id=person_id and 
		obs_datetime=last_artpickup_at12 and 
		concept_id=5096 and voided=0;

/*SMS consent date*/		
update 	sms_patient,obs
set 	date_consent_sms=obs_datetime
where 	patient_id=person_id and 
		concept_id=6309 and value_coded=6307 and voided=0;
		
/*has phone number*/		
update 	sms_patient,person_attribute
set 	has_phone_number='Y'
where 	patient_id=person_id and person_attribute_type_id=9 and voided=0 and value is not null and length(value)>=9;

/*SMS sent*/
insert into sms_sent(patient_id,date_sent,alert_date)
Select 	distinct p.patient_id,ss.created,alert_date
from 	sms_patient p 
		inner join smsreminder_sent ss on p.patient_id=ss.patient_id;


/*ART Pickup*/
insert into sms_artpickup(patient_id,art_pickup_date)
Select 	distinct p.patient_id,e.encounter_datetime 
from 	sms_patient p 
		inner join encounter e on p.patient_id=e.patient_id
where e.voided=0 and e.encounter_type=18 and e.location_id=location and e.encounter_datetime<=dateDataEval;

update sms_artpickup,obs 
set art_pickup_schedulled=value_datetime
where sms_artpickup.patient_id=obs.person_id and obs.obs_datetime=art_pickup_date and obs.voided=0 and obs.concept_id=5096;



/*Patient_status*/
insert into sms_patientstatus(patient_id,patient_status_startdate,patient_status,patient_status_enddate)
select 	pg.patient_id,ps.start_date,
		case ps.state
			when 7 then 'TRASFERRED OUT'
			when 8 then 'SUSPENDED'
			when 9 then 'ART LTFU'
			when 10 then 'DEAD'
		else null end as codeestado,
		ps.end_date
	from 	sms_patient p 
			inner join patient_program pg on p.patient_id=pg.patient_id
			inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
	where 	pg.voided=0 and ps.voided=0 and  
			pg.program_id=2 and ps.state in (7,8,9,10) and ps.start_date<=dateDataEval;	

		
end
;;
DELIMITER ;
