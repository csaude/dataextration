/*
Navicat MySQL Data Transfer

Source Server         : LocalServer
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : mobile_clinic_eval

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2016-06-30 08:32:57
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for art_pickup
-- ----------------------------
DROP TABLE IF EXISTS `art_pickup`;
CREATE TABLE `art_pickup` (
  `patient_id` int(11) DEFAULT NULL,
  `art_pickup_date` datetime DEFAULT NULL,
  `scheduled_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of art_pickup
-- ----------------------------

-- ----------------------------
-- Table structure for cd4
-- ----------------------------
DROP TABLE IF EXISTS `cd4`;
CREATE TABLE `cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of cd4
-- ----------------------------

-- ----------------------------
-- Table structure for ctx
-- ----------------------------
DROP TABLE IF EXISTS `ctx`;
CREATE TABLE `ctx` (
  `patient_id` int(11) DEFAULT NULL,
  `ctx` varchar(255) DEFAULT NULL,
  `date_ctx` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ctx
-- ----------------------------

-- ----------------------------
-- Table structure for inh
-- ----------------------------
DROP TABLE IF EXISTS `inh`;
CREATE TABLE `inh` (
  `patient_id` int(11) DEFAULT NULL,
  `inh` varchar(255) DEFAULT NULL,
  `date_inh` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of inh
-- ----------------------------

-- ----------------------------
-- Table structure for patient
-- ----------------------------
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
  `id` int(11) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `clinic` varchar(255) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `marital_status` varchar(255) DEFAULT NULL,
  `number_childrean` int(11) DEFAULT NULL,
  `education` varchar(255) DEFAULT NULL,
  `occupation` varchar(255) DEFAULT NULL,
  `home_electricity` varchar(255) DEFAULT NULL,
  `home_refrigerator` varchar(255) DEFAULT NULL,
  `hiv_entry_point` varchar(255) DEFAULT NULL,
  `date_enrolment` datetime DEFAULT NULL,
  `date_diagnosis` datetime DEFAULT NULL,
  `date_death` datetime DEFAULT NULL,
  `patient_state` varchar(255) DEFAULT NULL,
  `date_state` datetime DEFAULT NULL,
  `date_art_initiation` datetime DEFAULT NULL,
  `pregnacy_status_enrol` varchar(255) DEFAULT NULL,
  `date_pregnacy_due` datetime DEFAULT NULL,
  `height` double DEFAULT NULL,
  `date_height` date DEFAULT NULL,
  `weight_enr` double DEFAULT NULL,
  `date_weight_enr` date DEFAULT NULL,
  `weight_art` double DEFAULT NULL,
  `date_weight_art` date DEFAULT NULL,
  `bmi_enr` double DEFAULT NULL,
  `date_bmi_enr` datetime DEFAULT NULL,
  `bmi_art` double DEFAULT NULL,
  `date_bmi_art` datetime DEFAULT NULL,
  `cd4_enr` double DEFAULT NULL,
  `date_cd4_enr` datetime DEFAULT NULL,
  `cd4_art` double DEFAULT NULL,
  `date_cd4_art` datetime DEFAULT NULL,
  `hemoglobin_enr` double DEFAULT NULL,
  `date_hemoglobin_enr` datetime DEFAULT NULL,
  `hemoglobin_art` double DEFAULT NULL,
  `date_hemoglobin_art` datetime DEFAULT NULL,
  `who_enr` varchar(255) DEFAULT NULL,
  `date_who_enr` datetime DEFAULT NULL,
  `who_art` varchar(255) DEFAULT NULL,
  `date_who_art` datetime DEFAULT NULL,
  `nutrition_enr` varchar(255) DEFAULT NULL,
  `date_nutrition_enr` datetime DEFAULT NULL,
  `nutrition_art` varchar(255) DEFAULT NULL,
  `date_nutrition_art` datetime DEFAULT NULL,
  `its_enr` varchar(255) DEFAULT NULL,
  `date_its_enr` datetime DEFAULT NULL,
  `its_art` varchar(255) DEFAULT NULL,
  `date_its_art` datetime DEFAULT NULL,
  `date_start_tb` datetime DEFAULT NULL,
  `ctx_enr` varchar(255) DEFAULT NULL,
  `date_ctx_enr` datetime DEFAULT NULL,
  `ctx_art` varchar(255) DEFAULT NULL,
  `date_ctx_art` datetime DEFAULT NULL,
  `inh_enr` varchar(255) DEFAULT NULL,
  `date_inh_enr` datetime DEFAULT NULL,
  `inh_art` varchar(255) DEFAULT NULL,
  `date_inh_art` datetime DEFAULT NULL,
  `ctx_eligible` varchar(255) DEFAULT NULL,
  `art_eligible` varchar(255) DEFAULT NULL,
  `art_eligible_criteria` varchar(255) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `date_first_followup` datetime DEFAULT NULL,
  `date_last_pickup` datetime DEFAULT NULL,
  `date_scheduled_last_pickup` datetime DEFAULT NULL,
  `date_last_followup` datetime DEFAULT NULL,
  `date_scheduled_last_followup` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `transferred_from` varchar(255) DEFAULT NULL,
  `date_transferred_from` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of patient
-- ----------------------------

-- ----------------------------
-- Table structure for visit_followup
-- ----------------------------
DROP TABLE IF EXISTS `visit_followup`;
CREATE TABLE `visit_followup` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `scheduled_date` datetime DEFAULT NULL,
  `uuid` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of visit_followup
-- ----------------------------

-- ----------------------------
-- Procedure structure for FillTPacienteTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillTPacienteTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTPacienteTable`(dataInicial date,dataFinal date,distrito varchar(40))
    READS SQL DATA
begin

truncate table patient;
truncate table art_pickup;
truncate table cd4;
truncate table ctx;
truncate table inh;
truncate table visit_followup;

/*Inscricao*/
insert into patient(id,date_enrolment,sex,date_death,age,location_id)
Select 	e.patient_id,
		min(encounter_datetime) data_abertura,
		gender,				
		death_date,
		round(datediff(e.encounter_datetime,pe.birthdate)/365) idade_abertura,
		e.location_id
from 	openmrs.patient p			
		inner join openmrs.encounter e on e.patient_id=p.patient_id
		inner join openmrs.person pe on pe.person_id=p.patient_id			
where 	p.voided=0 and e.encounter_type in (5,7) and e.voided=0 and pe.voided=0 and 
		e.encounter_datetime between dataInicial and dataFinal
group by p.patient_id;


delete from patient where age<15;

update patient set district=distrito;

update patient,openmrs.location
set patient.clinic=location.name
where patient.location_id=location.location_id;


/*ESTADO CIVIL*/
update patient,openmrs.obs
set patient.marital_status= case obs.value_coded
					   when 1057 then 'SINGLE'
					   when 5555 then 'MARRIED'
					   when 1059 then 'WIDOWED'
					   when 1060 then 'LIVING WITH PARTNER'
					   when 1056 then 'SEPARATED'
					   when 1058 then 'DIVORCED'
					   else null end
where obs.person_id=patient.id and obs.concept_id=1054 and obs.voided=0;	

/*NUMERO DE Filhos*/
update patient,openmrs.obs
set patient.number_childrean= obs.value_numeric
where obs.person_id=patient.id and obs.concept_id=5573 and obs.voided=0;

/*ESCOLARIDADE*/
update patient,openmrs.obs
set patient.education= case obs.value_coded 
					   when 1445 then 'NONE'
					   when 1446 then 'PRIMARY SCHOOL'
					   when 1447 then 'SECONDARY SCHOOL'
					   when 6124 then 'TECHNICAL SCHOOL'
					   when 1444 then 'SECONDARY SCHOOL'
					   when 6125 then 'TECHNICAL SCHOOL'
					   when 1448 then 'UNIVERSITY'
					else null end
where obs.person_id=patient.id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update patient,openmrs.obs
set patient.occupation= obs.value_text
where obs.person_id=patient.id and obs.concept_id=1459 and voided=0;

/*ELECTRICIDADE*/
update patient,openmrs.obs
set patient.home_electricity= case obs.value_coded
					   when 1065 then 'YES'
					   when 1066 then 'NO'
					   else null end
where obs.person_id=patient.id and obs.concept_id=5609 and voided=0;

/*GELEIRA*/
update patient,openmrs.obs
set patient.home_refrigerator= case obs.value_coded
					   when 1065 then 'YES'
					   when 1066 then 'NO'
					   else null end
where obs.person_id=patient.id and obs.concept_id=1455 and voided=0;

/*Update CodProveniencia*/
update patient,
		(Select 	p.id,
				case o.value_coded
				when 1595 then 'MEDICAL INPATIENT'
				when 1596 then 'EXTERNAL CONSULTATION'
				when 1414 then 'TB CLINIC - PNCT'
				when 1597 then 'VCT'
				when 1987 then 'VCT - YOUTH'
				when 1598 then 'PMTCT'
				when 1872 then 'CHILD AT RISK CLINIC'
				when 1275 then 'HEALTH CENTER HOSPITALS'
				when 1984 then 'HEALTH UNIT'
				when 1599 then 'PRIVATE PROVIDER'
				when 1932 then 'REFERRED BY A HEALTH PROFESSIONAL'
				when 1387 then 'LABORATORY'
				when 1386 then 'MOBILE CLINIC'
				when 1044 then 'PEDIATRIC TREATMENT'
				when 6304 then 'ATIP'
				when 1986 then 'SECONDARY SITE'
				when 6245 then 'VCT - COMMUNITY'
				when 1699 then 'HOME BASED CARE'
				when 2160 then 'MISSED VISIT'
				when 6288 then 'MATERNAL CHILD HEALTH'
				when 5484 then 'NUTRITIONAL SUPPORT'
				when 6155 then 'TRADITIONAL CLINICIAN'
				when 6303 then 'BASED GENDER VIOLENCE'
				when 6305 then 'COMMUNITY BASED ORGANIZATION'
				else null end as codProv
		from 	patient p 
				inner join openmrs.encounter e on e.patient_id=p.id
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	o.voided=0 and o.concept_id=1594 and e.encounter_type in (5,7) and e.voided=0
		) proveniencia
set patient.hiv_entry_point=proveniencia.codProv
where proveniencia.id=patient.id;


/*Data de Diagnostico*/
update patient,
	(	Select 	p.id,
				o.value_datetime
		from 	patient p 
				inner join openmrs.encounter e on p.id=e.patient_id	
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and
				e.encounter_type in (5,7) and o.concept_id=6123 and o.value_datetime between dataInicial and dataFinal
	) diagnostico

set 	patient.date_diagnosis=diagnostico.value_datetime
where 	patient.id=diagnostico.id;


/*Inicio TARV*/
update patient,
	(select id,min(data_inicio) data_inicio
		from
		(
			Select 	p.id,min(e.encounter_datetime) data_inicio
			from 	patient p 
					inner join openmrs.encounter e on p.id=e.patient_id	
					inner join openmrs.obs o on o.encounter_id=e.encounter_id
			where 	e.voided=0 and o.voided=0 and  
					e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and 
					e.encounter_datetime between dataInicial and dataFinal
			group by p.id
			
			union
		
			Select p.id,min(value_datetime) data_inicio
			from 	patient p
					inner join openmrs.encounter e on p.id=e.patient_id
					inner join openmrs.obs o on e.encounter_id=o.encounter_id
			where 	e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and 
					o.concept_id=1190 and o.value_datetime is not null and 
					o.value_datetime between dataInicial and dataFinal
			group by p.id
			
			union
			
			select 	p.id,date_enrolled as data_inicio
			from 	patient p inner join openmrs.patient_program pg on p.id=pg.patient_id
			where 	pg.voided=0 and program_id=2 and 
					pg.date_enrolled between dataInicial and dataFinal
		) inicio
		group by id
	)inicio_real 

set patient.date_art_initiation=inicio_real.data_inicio
where patient.id=inicio_real.id;



/*Estado Actual TARV*/
update patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	patient p 
				inner join openmrs.patient_program pg on p.id=pg.patient_id
				inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
				ps.start_date<=dataFinal
		) saida
set 	patient.patient_state=saida.codeestado,
		patient.date_state=saida.start_date
where saida.patient_id=patient.id;

/*Estado Actual NAO TARV*/
update patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 2 then 'pre-ART LTFU'
					when 3 then 'TRASFERRED OUT'
					when 5 then 'DEAD'
				else null end as codeestado
		from 	patient p 
				inner join openmrs.patient_program pg on p.id=pg.patient_id
				inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=1 and ps.state in (2,3,5) and ps.end_date is null and 
				ps.start_date<=dataFinal
		) saida
set 	patient.patient_state=saida.codeestado,
		patient.date_state=saida.start_date
where saida.patient_id=patient.id and patient.date_art_initiation is null;		

/*Estado Actual - Obito Demografico*/
update patient,openmrs.person
set 	patient.patient_state='DEAD',
		patient.date_state=person.death_date
where person.person_id=patient.id and patient_state is null and dead=1;


/*GRAVIDA*/
update patient,openmrs.obs
set patient.pregnacy_status_enrol= if(obs.value_coded=44,'YES',null)
where patient.id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=patient.date_enrolment;

update patient,openmrs.obs
set patient.pregnacy_status_enrol= if(obs.value_numeric is not null,'YES',null)
where patient.id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=patient.date_enrolment and patient.pregnacy_status_enrol is null;

/*DATA PREVISTA*/
update patient,openmrs.obs
set patient.date_pregnacy_due= obs.value_datetime
where patient.id=obs.person_id and obs.concept_id=1600 and obs.obs_datetime=patient.date_enrolment;

/*ALTURA*/
update patient,
	(	select 	person_id,max(obs_datetime) data_peso
		from 	openmrs.obs
		where 	voided=0 and concept_id=5090 and 
				obs_datetime between dataInicial and dataFinal
		group by person_id
	) altura
set patient.date_height=altura.data_peso
where patient.id=altura.person_id;

update patient,openmrs.obs
set patient.height=obs.value_numeric
where patient.id=obs.person_id and patient.date_height=obs.obs_datetime and obs.voided=0 and obs.concept_id=5090;

/*Data Primeiro seguimento*/
update patient,
(	select 	p.patient_id,
			min(encounter_datetime) encounter_datetime
	from 	openmrs.patient p
			inner join openmrs.encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type in (6,9) and p.voided=0 and 
			e.encounter_datetime between dataInicial and dataFinal
	group by p.patient_id
)seguimento
set patient.date_first_followup=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

/*Peso Na Abertura de Processo*/
update 	patient,openmrs.obs 
set 	patient.weight_enr=obs.value_numeric,
		patient.date_weight_enr=obs.obs_datetime
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_first_followup and obs.concept_id=5089 and obs.voided=0;

/*Peso no inicio de TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=5089 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_weight_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.weight_art=obs.value_numeric
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_weight_art and obs.concept_id=5089 and obs.voided=0;


/*IMC Na Abertura de Processo*/
update 	patient,openmrs.obs 
set 	patient.bmi_enr=obs.value_numeric,
		patient.date_bmi_enr=obs.obs_datetime
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_first_followup and obs.concept_id=1342 and obs.voided=0;


/*IMC no inicio de TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=1342 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_bmi_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.bmi_art=obs.value_numeric
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_bmi_art and obs.concept_id=1342 and obs.voided=0;

/*PRIMEIRO CD4*/
update patient,
(	select 	e.patient_id,
			min(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between dataInicial and dataFinal and o.concept_id=5497
	group by p.id
)seguimento
set patient.date_cd4_enr=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.cd4_enr=obs.value_numeric
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_cd4_enr and obs.concept_id=5497 and obs.voided=0;


/*CD4 NO INICIO DE TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=5497 and p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_cd4_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.cd4_art=obs.value_numeric
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_cd4_art and obs.concept_id=5497 and obs.voided=0;



/*PRIMEIRO HEMOGLOBINA*/
update patient,
(	select 	e.patient_id,
			min(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between dataInicial and dataFinal and o.concept_id=21
	group by p.id
)seguimento
set patient.date_hemoglobin_enr=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.hemoglobin_enr=obs.value_numeric
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_hemoglobin_enr and obs.concept_id=21 and obs.voided=0;


/*HEMOGLOBINA NO INICIO DE TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=21 and p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_hemoglobin_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.hemoglobin_art=obs.value_numeric
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_hemoglobin_art and obs.concept_id=21 and obs.voided=0;


/*ESTADIO Na Abertura de Processo*/
update 	patient,openmrs.obs 
set 	patient.who_enr=if(obs.value_coded=1204,'I',if(obs.value_coded=1205,'II',if(obs.value_coded=1206,'III','IV'))),
		patient.date_who_enr=obs.obs_datetime
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_first_followup and obs.concept_id=5356 and obs.voided=0;


/*ESTADIO no inicio de TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=5356 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_who_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.who_art=if(obs.value_coded=1204,'I',if(obs.value_coded=1205,'II',if(obs.value_coded=1206,'III','IV')))
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_who_art and obs.concept_id=5356 and obs.voided=0;


/*NUTRICAO Na Abertura de Processo*/
update 	patient,openmrs.obs 
set 	patient.nutrition_enr=if(obs.value_coded=1065,'YES','NO'),
		patient.date_nutrition_enr=obs.obs_datetime
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_first_followup and obs.concept_id=2152 and obs.voided=0;

/*NUTRICAO no inicio de TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=2152 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_nutrition_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.nutrition_art=if(obs.value_coded=1065,'YES','NO')
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_nutrition_art and obs.concept_id=2152 and obs.voided=0;

/*ITS Na Abertura de Processo*/
update 	patient,openmrs.obs 
set 	patient.its_enr=if(obs.value_coded=1065,'YES','NO'),
		patient.date_its_enr=obs.obs_datetime
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_first_followup and obs.concept_id=6258 and obs.voided=0;


/*ITS no inicio de TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=6258 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_its_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.its_art=if(obs.value_coded=1065,'YES','NO')
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_its_art and obs.concept_id=6258 and obs.voided=0;

/*Tratamento de TB no inicio de TARV*/
update patient,
(select patient_id,max(data) data
from 
(
	SELECT 	e.patient_id,o.value_datetime AS data
	FROM 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id AND o.person_id=e.patient_id
	WHERE 	e.encounter_type IN (6,9) and o.concept_id=1113 AND o.voided=0 AND e.voided=0 and 
			o.value_datetime between dataInicial and dataFinal 
		   
	UNION
		 
	SELECT 	e.patient_id,o.obs_datetime AS data
	FROM 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			INNER JOIN openmrs.obs o ON e.encounter_id=o.encounter_id AND o.person_id=e.patient_id
	WHERE 	e.encounter_type IN (6,9) AND o.concept_id=1268 AND o.value_coded=1256 AND o.voided=0 AND e.voided=0 and 
			o.obs_datetime between dataInicial and dataFinal
			
	Union
	 
	SELECT 	pp.patient_id, pp.date_enrolled as data
	FROM 	patient p
			inner join openmrs.patient_program pp ON pp.patient_id = p.id
	WHERE 	pp.program_id = 5 AND pp.voided = 0 and pp.date_enrolled between dataInicial and dataFinal
) tb
group by patient_id
)tb1
set patient.date_start_tb=tb1.data
where patient.id=tb1.patient_id;

/*CTX Na Abertura de Processo*/
update 	patient,openmrs.obs 
set 	patient.ctx_enr=if(obs.value_coded=1065,'YES','NO'),
		patient.date_ctx_enr=obs.obs_datetime
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_first_followup and obs.concept_id=6121 and obs.voided=0;

/*CTX no inicio de TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=6121 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_ctx_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.ctx_art=if(obs.value_coded=1065,'YES','NO')
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_ctx_art and obs.concept_id=6121 and obs.voided=0;


/*INH Na Abertura de Processo*/
update 	patient,openmrs.obs 
set 	patient.inh_enr=if(obs.value_coded=1065,'YES','NO'),
		patient.date_inh_enr=obs.obs_datetime
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_first_followup and obs.concept_id=6122 and obs.voided=0;

/*INH no inicio de TARV*/
update patient,
(	select 	e.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	patient p
			inner join openmrs.encounter e on p.id=e.patient_id
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime between dataInicial and p.date_art_initiation and o.concept_id=6122 and 
			p.date_art_initiation is not null
	group by p.id
)seguimento
set patient.date_inh_art=seguimento.encounter_datetime
where patient.id=seguimento.patient_id;

update 	patient,openmrs.obs 
set 	patient.inh_art=if(obs.value_coded=1065,'YES','NO')
where 	patient.id=obs.person_id and obs.obs_datetime=patient.date_inh_art and obs.concept_id=6122 and obs.voided=0;



update patient,
(select *
from 
(select 	visita.id,		
			if(round(datediff(dataFinal,pe.birthdate)/365)<5,'AGE',
			if(cd4.value_numeric is not null and cd4.value_numeric<=350,'CD4',
				if(estadio.estadio is not null and (estadio.estadio='III' or estadio.estadio='IV'),'WHO STAGE',
					if(tb.data_inicio_tb is not null,'TB',
						if(gravida.data_gravida is not null,'PREGNACY',null)
					)
				)
			)
		) criterio
from
	patient visita
	inner join openmrs.person pe on pe.person_id=visita.id and pe.voided=0
	left join 
	(	select o.person_id, o.concept_id,o.value_numeric,o.obs_datetime
		from openmrs.obs o,				
			(	select p.id,max(encounter_datetime) as encounter_datetime
				from 	patient p
						inner join openmrs.encounter e on p.id=e.patient_id
						inner join openmrs.obs o on o.encounter_id=e.encounter_id
				where 	encounter_type=13 and e.voided=0 and
						encounter_datetime between dataInicial and dataFinal and o.voided=0 and o.concept_id=5497
				group by p.id
			) d
		where 	o.person_id=d.id and o.obs_datetime=d.encounter_datetime and o.voided=0 and o.concept_id=5497
	) cd4 on cd4.person_id=visita.id
	left join 
	(	select o.person_id, o.concept_id,if(value_coded=1204,'I',if(value_coded=1205,'II',if(value_coded=1206,'III','IV'))) estadio,o.obs_datetime
		from openmrs.obs o,				
			(	select 	p.id,max(encounter_datetime) as encounter_datetime
				from 	patient p
						inner join openmrs.encounter e on p.id=e.patient_id
						inner join openmrs.obs o on o.encounter_id=e.encounter_id
				where 	encounter_type in (6,9) and e.voided=0 and
						encounter_datetime between dataInicial and dataFinal and o.voided=0 and o.concept_id=5356
				group by p.id
			) d
		where 	o.person_id=d.id and o.obs_datetime=d.encounter_datetime and o.voided=0 and 
				o.concept_id=5356
	) estadio on estadio.person_id=visita.id
	left join 
	(	Select 	p.id,
				max(o.value_datetime) data_inicio_tb
		from 	patient p 
				inner join openmrs.encounter e on p.id=e.patient_id	
				inner join openmrs.obs o on o.encounter_id=e.encounter_id
		where 	e.voided=0 and o.voided=0 and o.value_datetime between dataInicial and dataFinal and 
				o.concept_id=1113 and e.encounter_type in (6,9)
		group by p.id
	) tb on tb.id=visita.id
	left join 
	(	select pp.patient_id id,pp.date_enrolled as data_gravida
		from 	openmrs.patient_program pp 
		where 	pp.program_id=8 and pp.date_enrolled between dataInicial and dataFinal and pp.voided=0
	) gravida on gravida.id=visita.id
) elegivel
where CRITERIO is not null
) elegivel1

set patient.art_eligible='YES',
	patient.art_eligible_criteria=elegivel1.criterio
where patient.id=elegivel1.id;




update patient,
(select o.person_id id
	from  openmrs.obs o,                                                    
		(   select 	p.id,max(encounter_datetime) as encounter_datetime
			from    patient p
					inner join openmrs.encounter e on p.id=e.patient_id
					inner join openmrs.obs o on o.encounter_id=e.encounter_id
			where   encounter_type=13 and e.voided=0 and
					encounter_datetime between dataInicial and dataFinal and o.voided=0 and o.concept_id=5497
			group by p.id
		) d
	where   o.person_id=d.id and o.obs_datetime=d.encounter_datetime and o.voided=0 and 
			o.concept_id=5497 and o.value_numeric<=350
	union
                                                
	select  o.person_id id
	from    openmrs.obs o,                                                    
			(   select  p.id,max(encounter_datetime) as encounter_datetime
				from    patient p
						inner join openmrs.encounter e on p.id=e.patient_id
						inner join openmrs.obs o on o.encounter_id=e.encounter_id
				where   encounter_type in (6,9) and e.voided=0 and
						encounter_datetime between dataInicial and dataFinal and o.voided=0 and o.concept_id=5356
				group by p.id
			) d
	where   o.person_id=d.id and o.obs_datetime=d.encounter_datetime and o.voided=0 and 
			o.concept_id=5356 and o.value_coded in (1206,1207)									
									
	union
                                                
	select  o.person_id id
	from    openmrs.obs o,                                                    
			(   select  p.id,max(encounter_datetime) as encounter_datetime
				from    patient p
						inner join openmrs.encounter e on p.id=e.patient_id
						inner join openmrs.obs o on o.encounter_id=e.encounter_id
				where   encounter_type in (6,9) and e.voided=0 and
						encounter_datetime between dataInicial and dataFinal and o.voided=0 and o.concept_id=5356
				group by p.id
			) d
	where   o.person_id=d.id and o.obs_datetime=d.encounter_datetime and o.voided=0 and 
			o.concept_id=5356 and o.value_coded=1205 and 
			d.id not in (select distinct person_id from openmrs.obs where concept_id=5497 and voided=0)
                                                                                
	union
	
	Select  p.id
	from    patient p 
			inner join openmrs.encounter e on p.id=e.patient_id       
			inner join openmrs.obs o on o.encounter_id=e.encounter_id
	where   e.voided=0 and o.voided=0 and o.value_datetime between dataInicial and dataFinal and 
			o.concept_id=1113 and e.encounter_type in (6,9)    

	union                    
	
	select  p.id
	from    patient p 
			inner join openmrs.patient_program pg on p.id=pg.patient_id
	where   pg.voided=0 and program_id in (5,8) and date_enrolled between dataInicial and dataFinal
	
	union
	
	select 	p.id
	from 	openmrs.person pe 
			inner join patient p on p.id=pe.person_id
	where 	pe.voided=0 and (datediff(dataFinal,birthdate)/365)<5
) elegivelctx
set patient.ctx_eligible='YES'
where patient.id=elegivelctx.id;

/*ULTIMO SEGUIMENTO*/
update patient,
(   select  p.id,max(encounter_datetime) as encounter_datetime
	from    patient p
			inner join openmrs.encounter e on p.id=e.patient_id
	where   encounter_type in (6,9) and e.voided=0 and
			encounter_datetime between dataInicial and dataFinal
	group by p.id
) seguimento
set patient.date_last_followup=seguimento.encounter_datetime
where patient.id=seguimento.id;

update patient,openmrs.obs
set patient.date_scheduled_last_followup=obs.value_datetime
where patient.id=obs.person_id and patient.date_last_followup=obs.obs_datetime and obs.voided=0 and obs.concept_id=1410;


/*ULTIMO LEVANTAMENTO*/
update patient,
(   select  p.id,max(encounter_datetime) as encounter_datetime
	from    patient p
			inner join openmrs.encounter e on p.id=e.patient_id
	where   encounter_type=18 and e.voided=0 and
			encounter_datetime between dataInicial and dataFinal
	group by p.id
) seguimento
set patient.date_last_pickup=seguimento.encounter_datetime
where patient.id=seguimento.id;

update patient,openmrs.obs
set patient.date_scheduled_last_pickup=obs.value_datetime
where patient.id=obs.person_id and patient.date_last_pickup=obs.obs_datetime and obs.voided=0 and obs.concept_id=5096;

update patient
set patient_state='ART LTFU-NOT NOTIFIED',
	date_state=date_add(date_scheduled_last_pickup, interval 61 day)
where datediff(dataFinal,date_scheduled_last_pickup)>60 and date_art_initiation is not null;


update patient
set patient_state='pre-ART LTFU-NOT NOTIFIED',
	date_state=date_add(date_scheduled_last_followup, interval 61 day)
where datediff(dataFinal,date_scheduled_last_followup)>60 and date_art_initiation is null;

/*COTRIMOXAZOL*/
insert into ctx(patient_id,ctx,date_ctx)
select 	p.id,'YES',o.obs_datetime
from 	patient p
		inner join openmrs.encounter e on p.id=e.patient_id
		inner join openmrs.obs o on o.encounter_id=e.encounter_id
where 	e.encounter_datetime between dataInicial and dataFinal and 
		e.encounter_type in (6,9) and o.voided=0 and e.voided=0 and o.concept_id=6121 and o.value_coded=1065;
/*CD4*/		
insert into cd4(patient_id,cd4,cd4_date)
select 	p.id,o.value_numeric,o.obs_datetime
from 	patient p
		inner join openmrs.encounter e on p.id=e.patient_id
		inner join openmrs.obs o on o.encounter_id=e.encounter_id
where 	e.encounter_datetime between dataInicial and dataFinal and 
		e.encounter_type=13 and o.voided=0 and e.voided=0 and o.concept_id=5497;
		
		
/*INH*/
insert into inh(patient_id,inh,date_inh)
select 	p.id,'YES',o.obs_datetime
from 	patient p
		inner join openmrs.encounter e on p.id=e.patient_id
		inner join openmrs.obs o on o.encounter_id=e.encounter_id
where 	e.encounter_datetime between dataInicial and dataFinal and 
		e.encounter_type in (6,9) and o.voided=0 and e.voided=0 and o.concept_id=6122 and o.value_coded=1065;
		
		
/*LEVANTAMENTO ARV*/
insert into art_pickup(patient_id,art_pickup_date)
  select  p.id,encounter_datetime
	from    patient p
			inner join openmrs.encounter e on p.id=e.patient_id
	where   encounter_type=18 and e.voided=0 and
			encounter_datetime between dataInicial and dataFinal;

update art_pickup,openmrs.obs
set art_pickup.scheduled_date=obs.value_datetime
where art_pickup.patient_id=obs.person_id and art_pickup.art_pickup_date=obs.obs_datetime and obs.voided=0 and obs.concept_id=5096;

/*SEGUIMENTOS*/
insert into visit_followup(patient_id,visit_date)
  select  p.id,encounter_datetime
	from    patient p
			inner join openmrs.encounter e on p.id=e.patient_id
	where   encounter_type in (6,9) and e.voided=0 and
			encounter_datetime between dataInicial and dataFinal;

update visit_followup,openmrs.obs
set visit_followup.scheduled_date=obs.value_datetime
where visit_followup.patient_id=obs.person_id and visit_followup.visit_date=obs.obs_datetime and obs.voided=0 and obs.concept_id=1410;


/*TRANSFERIDOS DE*/
update patient,
(	
	select 	p.id,max(ps.start_date) data_transferido_de,pg.program_id
	from 	patient p 
			inner join openmrs.patient_program pg on p.id=pg.patient_id
			inner join openmrs.patient_state ps on pg.patient_program_id=ps.patient_program_id
	where 	pg.voided=0 and ps.voided=0 and  
			pg.program_id in (1,2) and ps.state in (28,29) and 
			ps.start_date between dataInicial and dataFinal	
	group by p.id
		
) transferido
set patient.transferred_from=if(program_id=1,'pre_ART','ART'),
	patient.date_transferred_from=data_transferido_de
where transferido.id=patient.id;






		
update patient set uuid=uuid();

update patient,art_pickup
set art_pickup.uuid=patient.uuid
where patient.id=art_pickup.patient_id;

update patient,cd4
set cd4.uuid=patient.uuid
where patient.id=cd4.patient_id;

update patient,ctx
set ctx.uuid=patient.uuid
where patient.id=ctx.patient_id;

update patient,inh
set inh.uuid=patient.uuid
where patient.id=inh.patient_id;

update patient,visit_followup
set visit_followup.uuid=patient.uuid
where patient.id=visit_followup.patient_id;

update patient set height=height*(-1) where height<0;

update patient set weight_enr=weight_enr*(-1) where weight_enr<0;

update patient set weight_art=weight_art*(-1) where weight_art<0;

update patient set bmi_enr=bmi_enr*(-1) where bmi_enr<0;

update patient set bmi_art=bmi_art*(-1) where bmi_art<0;

update patient set cd4_enr=cd4_enr*(-1) where cd4_enr<0;

update patient set cd4_art=cd4_art*(-1) where cd4_art<0;

update patient set hemoglobin_enr=hemoglobin_enr*(-1) where hemoglobin_enr<0;

update patient set hemoglobin_art=hemoglobin_art*(-1) where hemoglobin_art<0;

update cd4 set cd4=cd4*(-1) where cd4<0;


end
;;
DELIMITER ;
