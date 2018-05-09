SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for cvgaac_patient
-- ----------------------------
DROP TABLE IF EXISTS `cvgaac_patient`;
CREATE TABLE `cvgaac_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `enrolled_gaac` varchar(1) DEFAULT NULL,
  `enrolled_gaac_date` datetime DEFAULT NULL,
  `gaac_code` varchar(30) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `partner_status` varchar(100) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `date_first_followup` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL,
  `bmi_first` decimal(10,0) DEFAULT NULL,
  `bmi_first_date` datetime DEFAULT NULL,
  `bmi_art` decimal(10,0) DEFAULT NULL,
  `bmi_art_date` datetime DEFAULT NULL,
  `bmi_consultation` decimal(10,0) DEFAULT NULL,
  `bmi_consultation_date` datetime DEFAULT NULL,
  `cd4_first` decimal(10,0) DEFAULT NULL,
  `cd4_first_date` datetime DEFAULT NULL,
  `cd4_art` decimal(10,0) DEFAULT NULL,
  `cd4_art_date` datetime DEFAULT NULL,
  `cd4_consultation` decimal(10,0) DEFAULT NULL,
  `cd4_consultation_date` datetime DEFAULT NULL,
  `who_first` varchar(5) DEFAULT NULL,
  `who_first_date` datetime DEFAULT NULL,
  `who_art` varchar(5) DEFAULT NULL,
  `who_art_date` datetime DEFAULT NULL,
  `who_consultation` varchar(5) DEFAULT NULL,
  `who_consultation_date` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `cv_first_date` datetime DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `cvgaacpatient_patient_id` (`patient_id`),
  KEY `cvgaacpatient_enrollment_date` (`enrollment_date`),
  KEY `art_initiation_date` (`art_initiation_date`),
  KEY `enrolled_gaac_date` (`enrolled_gaac_date`),
  KEY `bmi_first_date` (`bmi_first_date`),
  KEY `bmi_art_date` (`bmi_art_date`),
  KEY `bmi_consultation_date` (`bmi_consultation_date`),
  KEY `cd4_first_date` (`cd4_first_date`),
  KEY `cd4_art_date` (`cd4_art_date`),
  KEY `cd4_consultation_date` (`cd4_consultation_date`),
  KEY `who_first_date` (`who_first_date`),
  KEY `who_art_date` (`who_art_date`),
  KEY `who_consultation_date` (`who_consultation_date`),
  KEY `cv_first_date` (`cv_first_date`),
  KEY `date_first_followup` (`date_first_followup`)
) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for cvgaac_cv
-- ----------------------------
DROP TABLE IF EXISTS `cvgaac_cv`;
CREATE TABLE `cvgaac_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillTCVGAACTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTCVGAACTable`(beforeARTStartDate date,cvStartDate date,cvEndDate date,district varchar(100))
    READS SQL DATA
begin

truncate table cvgaac_cv;
truncate table cvgaac_patient;


/*Inscricao*/
insert into cvgaac_patient(patient_id,enrollment_date,sex,age_enrollment,location_id)
Select 	e.patient_id,
		min(encounter_datetime) data_abertura,
		gender,
		round(datediff(e.encounter_datetime,pe.birthdate)/365) idade_abertura,
		e.location_id
from 	patient p			
		inner join encounter e on e.patient_id=p.patient_id
		inner join person pe on pe.person_id=p.patient_id			
where 	p.voided=0 and e.encounter_type in (5,7) and e.voided=0 and pe.voided=0 and 
		e.encounter_datetime<=beforeARTStartDate
group by p.patient_id;


/*Inicio TARV*/
update cvgaac_patient,
(	Select patient_id,min(data_inicio) data_inicio
	from
			(	Select 	p.patient_id,min(e.encounter_datetime) data_inicio
				from 	patient p 
						inner join encounter e on p.patient_id=e.patient_id	
						inner join obs o on o.encounter_id=e.encounter_id
				where 	e.voided=0 and o.voided=0 and p.voided=0 and 
						e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and 
						e.encounter_datetime<=beforeARTStartDate
				group by p.patient_id
		
				union
		
				Select 	p.patient_id,min(value_datetime) data_inicio
				from 	patient p
						inner join encounter e on p.patient_id=e.patient_id
						inner join obs o on e.encounter_id=o.encounter_id
				where 	p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and 
						o.concept_id=1190 and o.value_datetime is not null and 
						o.value_datetime<=beforeARTStartDate
				group by p.patient_id

				union

				select 	pg.patient_id,date_enrolled data_inicio
				from 	patient p inner join patient_program pg on p.patient_id=pg.patient_id
				where 	pg.voided=0 and p.voided=0 and program_id=2 and date_enrolled<=beforeARTStartDate
				
				union
				
				
			  SELECT 	e.patient_id, MIN(e.encounter_datetime) AS data_inicio 
			  FROM 		patient p
						inner join encounter e on p.patient_id=e.patient_id
			  WHERE		p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=beforeARTStartDate
			  GROUP BY 	p.patient_id				
				
				
			) inicio
		group by patient_id	
)inicio_real	
set cvgaac_patient.art_initiation_date=inicio_real.data_inicio
where cvgaac_patient.patient_id=inicio_real.patient_id;


/*Carga Viral*/
update cvgaac_patient,
	(	Select 	p.patient_id,
				min(e.encounter_datetime) data_carga
		from 	cvgaac_patient p 
				inner join encounter e on p.patient_id=e.patient_id	
				inner join obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and
				e.encounter_type in (6,9,13) and o.concept_id=856 and o.obs_datetime between cvStartDate and cvEndDate
		group by p.patient_id
	) cargaviral

set 	cvgaac_patient.cv_first_date=cargaviral.data_carga
where 	cvgaac_patient.patient_id=cargaviral.patient_id;


delete from cvgaac_patient where cv_first_date is null;

delete from cvgaac_patient where age_enrollment<15;

delete from cvgaac_patient where art_initiation_date is null;

delete from cvgaac_patient where enrollment_date is null;


update cvgaac_patient,location
set cvgaac_patient.health_facility=location.name
where cvgaac_patient.location_id=location.location_id;

update cvgaac_patient set urban='N';

update cvgaac_patient set main='N';

if district='Quelimane' then
	update cvgaac_patient set urban='Y'; 
end if;

if district='Namacurra' then
	update cvgaac_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
	update cvgaac_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
	update cvgaac_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
	update cvgaac_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
	update cvgaac_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
	update cvgaac_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
	update cvgaac_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
	update cvgaac_patient set main='Y' where location_id in (4,55); 
end if;

/*Gaac Enrollment*/
update cvgaac_patient,gaac,gaac_member
set cvgaac_patient.gaac_code=gaac.gaac_identifier,cvgaac_patient.enrolled_gaac='Y',cvgaac_patient.enrolled_gaac_date=gaac_member.start_date
where cvgaac_patient.patient_id=gaac_member.member_id and gaac_member.gaac_id=gaac.gaac_id;


/*ESTADO CIVIL*/
update cvgaac_patient,obs
set cvgaac_patient.marital_status= case obs.value_coded
					   when 1057 then 'SINGLE'
					   when 5555 then 'MARRIED'
					   when 1059 then 'WIDOWED'
					   when 1060 then 'LIVING WITH PARTNER'
					   when 1056 then 'SEPARATED'
					   when 1058 then 'DIVORCED'
					   else null end
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=1054 and obs.voided=0;	

/*ESCOLARIDADE*/
update cvgaac_patient,obs
set cvgaac_patient.education= case obs.value_coded 
					   when 1445 then 'NONE'
					   when 1446 then 'PRIMARY SCHOOL'
					   when 1447 then 'SECONDARY SCHOOL'
					   when 6124 then 'TECHNICAL SCHOOL'
					   when 1444 then 'SECONDARY SCHOOL'
					   when 6125 then 'TECHNICAL SCHOOL'
					   when 1448 then 'UNIVERSITY'
					else null end
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update cvgaac_patient,obs
set cvgaac_patient.occupation= obs.value_text
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=1459 and voided=0;

/*Estado Actual TARV*/
update cvgaac_patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	cvgaac_patient p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
				ps.start_date<=cvEndDate
		) saida
set 	cvgaac_patient.patient_status=saida.codeestado,
		cvgaac_patient.patient_status_date=saida.start_date
where saida.patient_id=cvgaac_patient.patient_id;

/*Estado Actual - Obito Demografico*/
update cvgaac_patient,person
set 	cvgaac_patient.patient_status='DEAD',
		cvgaac_patient.patient_status_date=person.death_date
where person.person_id=cvgaac_patient.patient_id and patient_status is null and dead=1;

/*Data Primeiro seguimento*/
update cvgaac_patient,
(	select 	p.patient_id,
			min(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime<=beforeARTStartDate
	group by p.patient_id
)seguimento
set cvgaac_patient.date_first_followup=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;


/*IMC Na Abertura de Processo*/
update 	cvgaac_patient,obs 
set 	cvgaac_patient.bmi_first=obs.value_numeric,
		cvgaac_patient.bmi_first_date=obs.obs_datetime
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.date_first_followup and obs.concept_id=1342 and obs.voided=0;


/*IMC no inicio de TARV*/
update cvgaac_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime <=p.art_initiation_date and o.concept_id=1342 and 
			p.art_initiation_date is not null
	group by p.patient_id
)seguimento
set cvgaac_patient.bmi_art_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.bmi_art=obs.value_numeric
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.bmi_art_date and obs.concept_id=1342 and obs.voided=0;


/*IMC no consulta antes Carga Viral*/
update cvgaac_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime <=p.cv_first_date and o.concept_id=1342 and 
			p.cv_first_date is not null
	group by p.patient_id
)seguimento
set cvgaac_patient.bmi_consultation_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.bmi_consultation=obs.value_numeric
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.bmi_consultation_date and obs.concept_id=1342 and obs.voided=0;

/*CD4 Enrollment*/
update cvgaac_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between enrollment_date and date_add(enrollment_date, interval 1 month) and o.concept_id=5497
	group by p.patient_id
)seguimento
set cvgaac_patient.cd4_first_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.cd4_first=obs.value_numeric
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.cd4_first_date and obs.concept_id=5497 and obs.voided=0;


/*CD4 on ART Initiation*/
update cvgaac_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between date_add(art_initiation_date, interval -6 month) and date_add(art_initiation_date, interval 2 month) and o.concept_id=5497
	group by p.patient_id
)seguimento
set cvgaac_patient.cd4_art_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.cd4_art=obs.value_numeric
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.cd4_art_date and obs.concept_id=5497 and obs.voided=0;


/*CD4 on CV*/
update cvgaac_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between date_add(cv_first_date, interval -1 month) and date_add(cv_first_date, interval 2 month) and o.concept_id=5497
	group by p.patient_id
)seguimento
set cvgaac_patient.cd4_consultation_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.cd4_consultation=obs.value_numeric
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.cd4_consultation_date and obs.concept_id=5497 and obs.voided=0;

/*WHO Na Abertura de Processo*/
update 	cvgaac_patient,obs 
set 	cvgaac_patient.who_first=case obs.value_coded
						when 1204 then 'I'
						when 1205 then 'II'
						when 1206 then 'III'
						when 1207 then 'IV'
						else 'OUTRO' end ,
		cvgaac_patient.who_first_date=obs.obs_datetime
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.date_first_followup and obs.concept_id=5356 and obs.voided=0;


/*IMC no inicio de TARV*/
update cvgaac_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime <=p.art_initiation_date and o.concept_id=5356 and 
			p.art_initiation_date is not null
	group by p.patient_id
)seguimento
set cvgaac_patient.who_art_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.who_art=case obs.value_coded
						when 1204 then 'I'
						when 1205 then 'II'
						when 1206 then 'III'
						when 1207 then 'IV'
						else 'OUTRO' end 
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.who_art_date and obs.concept_id=5356 and obs.voided=0;


/*IMC no consulta antes Carga Viral*/
update cvgaac_patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime <=p.cv_first_date and o.concept_id=5356 and 
			p.cv_first_date is not null
	group by p.patient_id
)seguimento
set cvgaac_patient.who_consultation_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.who_consultation=case obs.value_coded
						when 1204 then 'I'
						when 1205 then 'II'
						when 1206 then 'III'
						when 1207 then 'IV'
						else 'OUTRO' end 
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.who_consultation_date and obs.concept_id=5356 and obs.voided=0;


/*Carga Viral*/
insert into cvgaac_cv(patient_id,cv,cv_date)
Select distinct	p.patient_id,
		o.value_numeric,
		o.obs_datetime
from 	cvgaac_patient p 
		inner join encounter e on p.patient_id=e.patient_id	
		inner join obs o on o.encounter_id=e.encounter_id
where 	e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=856 and o.obs_datetime between cvStartDate and cvEndDate;
		
end
;;
DELIMITER ;
