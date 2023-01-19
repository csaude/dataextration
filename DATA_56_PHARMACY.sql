SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `pharmacy_patient`;
CREATE TABLE  `pharmacy_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `partner_status_at_enrollment` varchar(100) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(10) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL, 
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `tb_at_screening` varchar(255) DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `lactation` varchar(255) DEFAULT NULL,
  `regime_TPT` varchar(255) DEFAULT NULL,
  `regime_CTZ` varchar(255) DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL, 
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`),
  KEY `height_date` (`height_date`),
  KEY `weight_date` (`weight_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `pharmacy_dmc_type_of_dispensation_visit`;
CREATE TABLE `pharmacy_dmc_type_of_dispensation_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `type_dmc` varchar(100) DEFAULT NULL,
  `value_dmc` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `pharmacy_dispensation_therapeutic_line_posology`;
CREATE TABLE `pharmacy_dispensation_therapeutic_line_posology` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `dmc_type` varchar(100) DEFAULT NULL,
  `therapeutic_line` varchar(100) DEFAULT NULL,
  `posology` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_support_groups_visit`;
CREATE TABLE `pharmacy_support_groups_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_support_groups` varchar(100) DEFAULT NULL,
  `date_elegibbly_support_groups` datetime DEFAULT NULL,
  `type_support_groups` varchar(100) DEFAULT NULL,
  `value_support_groups` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_type_arv_dispensation`;
CREATE TABLE `pharmacy_type_arv_dispensation` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `dispensation_type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `pharmacy_differentiated_model`;
CREATE TABLE `pharmacy_differentiated_model` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `differentiated_model` varchar(100) DEFAULT NULL,
  `differentiated_model_status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_visit`;
CREATE TABLE `pharmacy_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `next_visit_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `visit_date` (`visit_date`),
  KEY `next_visit_date` (`next_visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_WHO_clinical_stage`;
CREATE TABLE `pharmacy_WHO_clinical_stage` (
  `patient_id` int(11) DEFAULT NULL,
  `who_stage`  varchar(4) DEFAULT NULL,
  `who_stage_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_art_pick_up`;
CREATE TABLE IF NOT EXISTS `pharmacy_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_cd4_absolute`;
CREATE TABLE `pharmacy_cd4_absolute` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_cd4_percentage`;
CREATE TABLE `pharmacy_cd4_percentage` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_viral_load`;
CREATE TABLE `pharmacy_viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` double DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pharmacy_drugs`;
CREATE TABLE `pharmacy_drugs` (
  `patient_id` int(11) DEFAULT NULL,
  `formulation` varchar(300) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `dosage` varchar(300) DEFAULT NULL,
  `pickup_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP PROCEDURE IF EXISTS `FillPHARMACY`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillPHARMACY`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

TRUNCATE TABLE pharmacy_dmc_type_of_dispensation_visit;
TRUNCATE TABLE pharmacy_dispensation_therapeutic_line_posology;
TRUNCATE TABLE pharmacy_support_groups_visit;
TRUNCATE TABLE pharmacy_type_arv_dispensation;
TRUNCATE TABLE pharmacy_differentiated_model;
TRUNCATE TABLE pharmacy_visit;
TRUNCATE TABLE pharmacy_WHO_clinical_stage;
TRUNCATE TABLE pharmacy_art_pick_up;
TRUNCATE TABLE pharmacy_cd4_absolute;
TRUNCATE TABLE pharmacy_cd4_percentage;
TRUNCATE TABLE pharmacy_viral_load;
TRUNCATE TABLE pharmacy_drugs;
SET @location:=location_id_parameter;

/*INSCRICAO*/
insert into pharmacy_patient(patient_id, enrollment_date, location_id)
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

Update pharmacy_patient set pharmacy_patient.district=district;

update pharmacy_patient,location
set pharmacy_patient.health_facility=location.name
where pharmacy_patient.location_id=location.location_id;

/*Apagar todos fora desta localização*/
delete from pharmacy_patient where location_id not in (@location);

/*DATA DE NASCIMENTO*/
UPDATE pharmacy_patient,
       person
SET pharmacy_patient.date_of_birth=person.birthdate
WHERE pharmacy_patient.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update pharmacy_patient,person set pharmacy_patient.age_enrollment=round(datediff(pharmacy_patient.enrollment_date,person.birthdate)/365)
where  person_id=pharmacy_patient.patient_id;

/*Exclusion criteria*/
delete from pharmacy_patient where age_enrollment<5;

  /*Sexo*/
update pharmacy_patient,person set pharmacy_patient.sex=.person.gender
where  person.person_id=pharmacy_patient.patient_id;

/*ESTADO CIVIL*/
update pharmacy_patient,obs
set pharmacy_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=pharmacy_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 


/*ESCOLARIDADE*/
update pharmacy_patient,obs
set pharmacy_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
             else null end
          
where obs.person_id=pharmacy_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update pharmacy_patient,obs
set pharmacy_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=pharmacy_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO DO PARCEIRO*/
update pharmacy_patient,obs
set pharmacy_patient.partner_status_at_enrollment= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=pharmacy_patient.patient_id and obs.concept_id=1449 and obs.voided=0; 

/*ESTADIO OMS AT ENROLLMENT*/
update pharmacy_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from pharmacy_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set pharmacy_patient.WHO_clinical_stage_at_enrollment=stage.cod,
pharmacy_patient.WHO_clinical_stage_at_enrollment_date=stage.encounter_datetime
where pharmacy_patient.patient_id=stage.patient_id 
and pharmacy_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update pharmacy_patient,obs
set pharmacy_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where pharmacy_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=pharmacy_patient.enrollment_date;

update pharmacy_patient,obs
set pharmacy_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where pharmacy_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=pharmacy_patient.enrollment_date and pharmacy_patient.pregnancy_status_at_enrollment is null;

update pharmacy_patient,patient_program
set pharmacy_patient.pregnancy_status_at_enrollment= 'YES'
where pharmacy_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;


  /*ESTADO ACTUAL DO STATUS DMC*/
update pharmacy_patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	patient p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
				ps.start_date<=endDate
		) saida
set 	pharmacy_patient.current_status_in_DMC=saida.codeestado
/*pharmacy_patient.patient_status_date=saida.start_date*/
where saida.patient_id=pharmacy_patient.patient_id;

/*PMC Entry date*/
update pharmacy_patient, patient_program
	set pharmacy_patient.pmtct_entry_date=date_enrolled
	where voided=0 and program_id=8 and pharmacy_patient.patient_id=patient_program.patient_id;

/*PMC exit date*/
update pharmacy_patient, patient_program
	set pharmacy_patient.pmtct_exit_date=date_completed
	where voided=0 and program_id=8 and pharmacy_patient.patient_id=patient_program.patient_id;

/*TB */
update pharmacy_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  pharmacy_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id in(6257,23758)
  group by p.patient_id
)tb, obs
set pharmacy_patient.tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where pharmacy_patient.patient_id=obs.person_id 
and pharmacy_patient.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id in(6257,23758) ;

/*TB DIAGNOSTIC*/   
update pharmacy_patient,
    (select p.patient_id,
         e.encounter_datetime,
        case o.value_coded
        when 664 then 'NEGATIVE'
        when 703 then 'POSITIVE'
        when 1065 then 'YES'
        when 1066 then 'NO'
        else null end as cod
    from  pharmacy_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id in (6277,23761) and e.encounter_type in (6,9) and e.voided=0 
    ) tb
set pharmacy_patient.tb_co_infection= tb.cod
where tb.patient_id=pharmacy_patient.patient_id;

/*lactation*/
update pharmacy_patient,obs
set pharmacy_patient.lactation= case obs.value_coded 
             when 1065 then 'Yes'
             when 1066 then 'No'
             when 1067 then 'Unknown'
                       else null end        
where obs.person_id=pharmacy_patient.patient_id and obs.concept_id=6332 and voided=0;


/*Regime TPT*/
update pharmacy_patient,obs
set pharmacy_patient.regime_TPT= case obs.value_coded 
             when 656 then 'ISONIAZID'
             when 23982 then 'Isoniazide + Piridoxina'
             when 755 then 'LEVOFLOXACIN'
             when 23983 then 'Levofloxacina + Piridoxina'
             when 23954 then '3HP'
             when 23984 then '3HP + Piridoxina'
             when 165305 then '1HP'
             when 165306 then 'LFX'
             else null end        
where obs.person_id=pharmacy_patient.patient_id and obs.concept_id=23985 and voided=0;

/*Regime CTZ*/
update pharmacy_patient,obs
set pharmacy_patient.regime_CTZ= case obs.value_coded 
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end        
where obs.person_id=pharmacy_patient.patient_id and obs.concept_id=6121 and voided=0;


delete from pharmacy_patient where pregnancy_status_at_enrollment='Yes';
delete from pharmacy_patient where lactation='Yes';
delete from pharmacy_patient where regime_TPT IS NOT NULL;
delete from pharmacy_patient where regime_CTZ='CONTINUE REGIMEN';
delete from pharmacy_patient where regime_CTZ='START DRUGS';


/*CARGA VIRAL*/
insert into pharmacy_viral_load(patient_id,cv,cv_qualit,cv_date)
select valor.patient_id,valor.value_numeric,valor.value_cod,valor.obs_datetime
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
    e.encounter_id
from  pharmacy_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (856,1305) and e.encounter_datetime  between startDate and endDate
)  valor group by valor.patient_id,valor.value_numeric,valor.encounter_id; 


       /*PESO AT TIME OF ART ENROLLMENT*/
update pharmacy_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  pharmacy_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set pharmacy_patient.weight_enrollment=obs.value_numeric, pharmacy_patient.weight_date=peso.encounter_datetime
where pharmacy_patient.patient_id=obs.person_id 
and pharmacy_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*INICIO TARV*/
UPDATE pharmacy_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM pharmacy_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM pharmacy_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM pharmacy_patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM pharmacy_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET pharmacy_patient.art_initiation_date=inicio_real.data_inicio
WHERE pharmacy_patient.patient_id=inicio_real.patient_id;

/*Estado Actual TARV*/
update pharmacy_patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	pharmacy_patient p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
				ps.start_date BETWEEN startDate AND endDate
		) saida
set 	pharmacy_patient.patient_status=saida.codeestado,
pharmacy_patient.patient_status_date=saida.start_date
where saida.patient_id=pharmacy_patient.patient_id;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update pharmacy_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  pharmacy_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set pharmacy_patient.height_enrollment=obs.value_numeric, pharmacy_patient.height_date=altura.encounter_datetime
where pharmacy_patient.patient_id=obs.person_id 
and pharmacy_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;

/*DMC DISPENSATION VISIT*/
insert into pharmacy_dmc_type_of_dispensation_visit(patient_id,date_elegibbly_dmc) /*ask Eusebiu*/
Select distinct p.patient_id,e.encounter_datetime 
from  pharmacy_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set pharmacy_dmc_type_of_dispensation_visit.elegibbly_dmc=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and obs.concept_id=23765 and obs.voided=0 and
        obs.obs_datetime=pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

/*PROXIMO GAAC*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="GAAC", 
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23724 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

    /*PROXIMO AF*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="AF",
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23725 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

        /*PROXIMO CA*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="CA",
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23726 and obs.voided=0
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

            /*PROXIMO PU*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="PU",
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and obs.concept_id=23727 and obs.voided=0 
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

            /*PROXIMO FR*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="FR",
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23729 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                /*PROXIMO DT*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="DT",
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23730 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                    /*PROXIMO DT*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="DC",
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23731 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                    /*PROXIMO DS*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc="DS",
pharmacy_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23888 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                        /*PROXIMO OUTRO*/
update pharmacy_dmc_type_of_dispensation_visit,obs,encounter 
set  pharmacy_dmc_type_of_dispensation_visit.type_dmc=obs.value_text
where   pharmacy_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23732 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


/*DMC*/
insert into pharmacy_dispensation_therapeutic_line_posology(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  pharmacy_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

update pharmacy_dispensation_therapeutic_line_posology,obs,encounter 
set pharmacy_dispensation_therapeutic_line_posology.dmc_type= case obs.value_coded
             when 1098 then  'DM'
             when 23720 then 'DT'
             when 23888 then 'DS'
             else null end
where   pharmacy_dispensation_therapeutic_line_posology.patient_id=obs.person_id and
    pharmacy_dispensation_therapeutic_line_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=23739 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dispensation_therapeutic_line_posology.visit_date=encounter.encounter_datetime;

update pharmacy_dispensation_therapeutic_line_posology,obs,encounter 
set pharmacy_dispensation_therapeutic_line_posology.posology= obs.value_text
where pharmacy_dispensation_therapeutic_line_posology.patient_id=obs.person_id and
    pharmacy_dispensation_therapeutic_line_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=1711 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dispensation_therapeutic_line_posology.visit_date=encounter.encounter_datetime;

update pharmacy_dispensation_therapeutic_line_posology,obs,encounter 
set pharmacy_dispensation_therapeutic_line_posology.therapeutic_line= case obs.value_coded
      when 23741 then 'ALTERNATIVE 1st LINE OF THE ART'
      when 1371  then 'REGIMEN SWITCH'
      when 1066  then 'NO'
      else null  end
where pharmacy_dispensation_therapeutic_line_posology.patient_id=obs.person_id and
    pharmacy_dispensation_therapeutic_line_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=23742 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_dispensation_therapeutic_line_posology.visit_date=encounter.encounter_datetime;

/*DMC DISPENSATION VISIT GROUP*/
insert into pharmacy_support_groups_visit(patient_id,date_elegibbly_support_groups)
Select distinct p.patient_id,e.encounter_datetime 
from  pharmacy_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC SUPPORT GROUP*/
update pharmacy_support_groups_visit,obs,encounter 
set pharmacy_support_groups_visit.elegibbly_support_groups=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  pharmacy_support_groups_visit.patient_id=obs.person_id and obs.concept_id=23764 and obs.voided=0 and
        obs.obs_datetime=pharmacy_support_groups_visit.date_elegibbly_support_groups
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

/*TYPE SUPPORT GROUP CRIANCAS REVELADAS*/
update pharmacy_support_groups_visit,obs,encounter 
set  pharmacy_support_groups_visit.type_support_groups="CR", 
pharmacy_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_support_groups_visit.patient_id=obs.person_id and
    pharmacy_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23753 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

/*TYPE SUPPORT GROUP PAIS E CUIDADORES*/
update pharmacy_support_groups_visit,obs,encounter 
set  pharmacy_support_groups_visit.type_support_groups="PC",
pharmacy_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_support_groups_visit.patient_id=obs.person_id and
    pharmacy_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23755 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;
 
 /*TYPE SUPPORT GROUP ADOLESCENTES RV*/
update pharmacy_support_groups_visit,obs,encounter 
set  pharmacy_support_groups_visit.type_support_groups="AR",
pharmacy_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_support_groups_visit.patient_id=obs.person_id and
    pharmacy_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23757 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

 /*TYPE SUPPORT GROUP MAE PARA MAE*/
update pharmacy_support_groups_visit,obs,encounter 
set  pharmacy_support_groups_visit.type_support_groups="MPM",
pharmacy_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   pharmacy_support_groups_visit.patient_id=obs.person_id and
    pharmacy_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23759 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;
          
/*PROXIMO OUTRO DE APOIO*/
update pharmacy_support_groups_visit,obs,encounter 
set  pharmacy_support_groups_visit.type_support_groups=obs.value_text
where   pharmacy_support_groups_visit.patient_id=obs.person_id and
    pharmacy_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23772 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and pharmacy_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

  /* ARV Dispensation*/
insert into pharmacy_type_arv_dispensation(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime
from  pharmacy_patient p
    inner join encounter e on p.patient_id=e.patient_id
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;
update pharmacy_type_arv_dispensation,
    (
    select p.patient_id,e.encounter_datetime,case o.value_coded when 1098  then 'DM' when 23720 then 'DT' when 23888 then 'DS' else null end  as code from pharmacy_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    where e.encounter_type=6 and e.voided=0 and o.voided=0 and o.concept_id=23739
    ) final
    set pharmacy_type_arv_dispensation.dispensation_type=final.code
    where pharmacy_type_arv_dispensation.patient_id=final.patient_id
-- 	and pharmacy_type_arv_dispensation.patient_id=pharmacy_patient.patient_id
    and pharmacy_type_arv_dispensation.visit_date=final.encounter_datetime;

/* community model*/  
   insert into pharmacy_differentiated_model(patient_id,visit_date,differentiated_model) 
   select o.person_id,e.encounter_datetime,
    case o.value_coded
    when 23888  then 'SEMESTER ARV PICKUP (DS)'
    when 165175 then 'NORMAL EXPEDIENT SCHEDULE'
    when 165176 then 'OUT OF TIME'
    when 165180 then 'DAILY MOBILE BRIGADES'
    when 165181 then 'DAILY MOBILE BRIGADES (HOTSPOTS)'
    when 165182 then 'DAILY MOBILE CLINICS'
    when 165183 then 'NIGHT MOBILE BRIGADES (HOTSPOTS)'
    when 165314 then 'ARV ANUAL DISPENSATION (DA)'
    when 165315 then 'DESCENTRALIZED ARV DISPENSATION (DD)'
    when 165178 then 'COMMUNITY DISPENSE VIA PROVIDER (DCP)'
    when 165179 then 'COMMUNITY DISPENSE VIA APE (DCA)'
    when 165264 then 'MOBILE BRIGADES (DCBM)'
    when 165265 then 'MOBILE CLINICS (DCCM)'
    when 23725  then 'FAMILY APPROACH (AF)'
    when 23729  then 'RAPID FLOW (FR)'
    when 23724  then 'GAAC (GA)'
    when 23726  then 'ACCESSION CLUBS (CA)'
    when 165316 then 'HOURS EXTENSION (EH)'
    when 165317 then 'SINGLE STOP IN TB SECTOR (TB)'
    when 165318 then 'SINGLE STOP ON TARV SERVICES (CT)'
    when 165319 then 'SINGLE STOP SAAJ (SAAJ)'
    when 165320 then 'SINGLE STOP SMI (SMI)'
    when 165321 then 'HIV ADVANCED DISEASE (DAH)'
    when 23727  then 'SINGLE STOP (PU)'
    when 165177 then 'FARMAC/PRIVATE PHARMACY (FARMAC)'
    when 23731  then 'COMMUNITY DISPENSATION (DC)'
    when 23732  then 'OTHER'
     when 23730  then 'QUARTERLY DISPENSATION (DT)'
    else null end  as code
    from obs o
    inner join encounter e on e.encounter_id=o.encounter_id
        where e.voided=0 and o.voided=0
    and o.concept_id=165174 and e.encounter_datetime BETWEEN startDate AND endDate
        and person_id IN (select patient_id from pharmacy_patient);

    update pharmacy_differentiated_model,
    (
    select p.patient_id,e.encounter_datetime,
    case obsEstado.value_coded
    when 1256  then 'START DRUGS'
    when 1257  then 'CONTINUE REGIMEN'
    when 1267  then 'COMPLETED' else null end  status
    from pharmacy_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    inner join obs obsEstado on obsEstado.encounter_id=e.encounter_id
    where e.encounter_type in (6,9,18) and e.voided=0 and o.voided=0
    and o.concept_id=165174  and obsEstado.concept_id=165322 and obsEstado.voided=0
    ) final
    set pharmacy_differentiated_model.differentiated_model_status=final.status
    where pharmacy_differentiated_model.patient_id=final.patient_id
    and pharmacy_differentiated_model.visit_date=final.encounter_datetime;

  /*VISITAS*/
insert into pharmacy_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  pharmacy_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*PROXIMA VISITAS*/
update pharmacy_visit,obs 
set  pharmacy_visit.next_visit_date=obs.value_datetime
where   pharmacy_visit.patient_id=obs.person_id and
    pharmacy_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;

/*Clinical Stage*/
insert into pharmacy_WHO_clinical_stage (patient_id, who_stage,who_stage_date)
 select  p.patient_id,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod,
      encounter_datetime encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  AND p.patient_id IN (SELECT patient_id FROM pharmacy_patient)
  and o.concept_id=5356 and o.obs_datetime   BETWEEN startDate AND endDate;

/*LEVANTAMENTO AMC_ART*/
insert into pharmacy_art_pick_up(patient_id,regime,art_date)
  select distinct p.patient_id,
  case   o.value_coded     
               when 1651 then 'AZT+3TC+NVP'
        when 6324 then 'TDF+3TC+EFV'
        when 1703 then 'AZT+3TC+EFV'
        when 6243 then 'TDF+3TC+NVP'
        when 6103 then 'D4T+3TC+LPV/r'
        when 792  then 'D4T+3TC+NVP'
        when 1827 then 'D4T+3TC+EFV'
        when 6102 then 'D4T+3TC+ABC'
        when 6116 then 'AZT+3TC+ABC'
        when 6108 then 'TDF+3TC+LPV/r(2ª Linha)'
        when 6100 then 'AZT+3TC+LPV/r'
        when 6329 then 'TDF+3TC+RAL+DRV/r (3ª Linha)'
        when 6330 then 'AZT+3TC+RAL+DRV/r (3ª Linha)'
        when 6105 then 'ABC+3TC+NVP'
        when 6325 then 'D4T+3TC+ABC+LPV/r (2ª Linha)'
        when 6326 then 'AZT+3TC+ABC+LPV/r (2ª Linha)'
        when 6327 then 'D4T+3TC+ABC+EFV (2ª Linha)'
        when 6328 then 'AZT+3TC+ABC+EFV (2ª Linha)'
        when 6109 then 'AZT+DDI+LPV/r (2ª Linha)'
        when 6110 then 'D4T20+3TC+NVP'
        when 1702 then 'AZT+3TC+NFV'
        when 817  then 'AZT+3TC+ABC'
        when 6104 then 'ABC+3TC+EFV'
        when 6106 then 'ABC+3TC+LPV/r'
        when 6244 then 'AZT+3TC+RTV'
        when 1700 then 'AZT+DDl+NFV'
        when 633  then 'EFV'
        when 625  then 'D4T'
        when 631  then 'NVP'
        when 628  then '3TC'
        when 635  then 'NFV'
        when 797  then 'AZT'
        when 814  then 'ABC'
        when 6107 then 'TDF+AZT+3TC+LPV/r'
        when 6236 then 'D4T+DDI+RTV-IP'
        when 1701 then 'ABC+DDI+NFV'
        when 1311 then 'ABC+3TC+LPV/r (2ª Linha)'
        when 1313 then 'ABC+3TC+EFV (2ª Linha)'
        when 1314 then 'AZT+3TC+LPV (2ª Linha)'
        when 1315 then 'TDF+3TC+EFV (2ª Linha)'
        when 6114 then '3DFC'
        when 6115 then '2DFC+EFV'
        when 6233 then 'AZT+3TC+DDI+LPV'
        when 6234 then 'ABC+TDF+LPV'
        when 6242 then 'D4T+DDI+NVP'
        when 6118 then 'DDI50+ABC+LPV'
        when 23784 then 'TDF+3TC+DTG'
        when 23799 then 'TDF+3TC+DTG (2ª Linha)' 
        when 23786 then 'ABC+3TC+DTG'
        when 23790 then 'TDF+3TC+LPV/r+RTV'
        when 23791 then 'TDF+3TC+ATV/r'
        when 23792 then 'ABC+3TC+ATV/r'
        when 23793 then 'AZT+3TC+ATV/r'
        when 23795 then 'ABC+3TC+ATV/r+RAL'
        when 23796 then 'TDF+3TC+ATV/r+RAL'
        when 23801 then 'AZT+3TC+RAL'
        when 23802 then 'AZT+3TC+DRV/r'
        when 23815 then 'AZT+3TC+DTG'
        when 23797 then 'ABC+3TC++RAL+DRV/r'
        when 23798 then '3TC+RAL+DRV/r'
        when 23803 then 'AZT+3TC+RAL+DRV/r'
        when 23785 then 'TDF+3TC+DTG2'
        when 23800 then 'ABC+3TC+DTG (2ª Linha)'
        when 165261 then 'TDF+3TC+RAL'
        when 165262 then 'ABC+3TC+RAL' 
        when 165215 then 'TDF/FTC' 
        when 23787 then 'ABC+AZT+LPV/r'
        when 23789 then 'TDF+AZT+LPV/r'
        when 23788 then 'TDF+ABC+3TC+LPV/r'
        when 165330 then 'ATV/r+TDF+3TC+DTG'
                else null end,
        encounter_datetime
  from pharmacy_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime BETWEEN startDate AND endDate;

update pharmacy_art_pick_up,obs
set  pharmacy_art_pick_up.next_art_date=obs.value_datetime
where   pharmacy_art_pick_up.patient_id=obs.person_id and
    pharmacy_art_pick_up.art_date=obs.obs_datetime and
    obs.concept_id=5096 and
    obs.voided=0;

     /*CD4 absolute*/
insert into pharmacy_cd4_absolute(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  pharmacy_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497  and o.obs_datetime BETWEEN startDate AND endDate;

/*CD4 percentage*/
insert into pharmacy_cd4_percentage(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  pharmacy_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=730   and o.obs_datetime BETWEEN startDate AND endDate;

/*Formulação FILA*/
insert into pharmacy_drugs(patient_id,formulation,pickup_date, group_id)
select  p.patient_id, case d.drug_id     
when 11 then ' [TDF/3TC/DTG] Tenofovir 300mg/Lamivudina 300mg/Dolutegravir 50mg TLD30'
when 12 then '[TDF/3TC/DTG] Tenofovir 300mg/Lamivudina 300mg/Dolutegravir 50mg TLD90'
when 13 then '[TDF/3TC/DTG] Tenofovir 300mg/Lamivudina 300mg/Dolutegravir 50mg TLD180'
when 17 then '[LPV/RTV] Lopinavir/Ritonavir -Aluvia 200mg/50mg'
when 18 then '[ABC/3TC] Abacavir 600mg/Lamivudina 300mg'
when 19 then '[DTG] Dolutegravir 50mg'
when 20 then '[ABC/3TC] Abacavir 120mg/Lamivudina 60mg'
when 21 then '[ABC/3TC] Abacavir 60 and Lamivudina 30mg'
when 22 then '[3TC/AZT] Lamivudina 150mg/ Zidovudina 300mg'
when 23 then '[3TC/AZT] Lamivudina 30mg/ Zidovudina 60mg'
when 24 then '[TDF/3TC] Tenofovir 300mg/Lamivudina 300mg'
when 25 then '[RAL] Raltegravir 400mg'
when 26 then '[LPV/RTV] Lopinavir/Ritonavir 400mg/100mg'
when 27 then '[LPV/RTV] Lopinavir/Ritonavir -Aluvia 100mg/25mg'
when 28 then '[LPV/RTV] Lopinavir/Ritonavir 200mg/50mg'
when 29 then '[LPV/RTV] Lopinavir/Ritornavir 40mg/10mg Pellets/Granulos'
when 30 then '[LPV/RTV]  Lopinavir/Ritonavir-Kaletra 80/20 mg/ml'
when 31 then '[ATV/RTV] Atazanavir 300mg/Ritonavir 100mg'
when 32 then '[NVP] Nevirapine 200mg'
when 33 then '[NVP]  Nevirapina 50mg'
when 34 then '[NVP] Nevirapine 50mg/5ml'
when 35 then '[AZT] Zidovudine 50mg/5ml'
when 36 then '[AZT] Zidovudine 300mg'
when 37 then '[ABC] Abacavir 300mg'
when 38 then '[ABC] Abacavir 60mg'
when 39 then '[EFV] Efavirenz 600mg'
when 40 then '[EFV] Efavirenz 200mg'
when 41 then '[3TC] Lamivudine150mg'
when 42 then '[TDF] Tenofovir 300mg'
when 43 then '[TDF/3TC/EFV] Tenofovir 300mg/Lamivudina 300mg/Efavirenze 400mg TLE90'
when 44 then '[TDF/3TC/EFV] Tenofovir 300mg/Lamivudina 300mg/Efavirenze 400mg TLE30'
when 45 then '[TDF/3TC/EFV] Tenofovir 300mg/Lamivudina 300mg/Efavirenze 400mg TLE180'
when 46 then '[TDF/3TC/EFV] Tenofovir 300mg/Lamivudina 300mg/Efavirenze 600mg'
when 47 then '[3TC/AZT/NVP] Lamivudina 150mg/Zidovudina 300mg/Nevirapina 200mg'
when 48 then '[3TC/AZT/NVP] Lamivudina 30mg/Zidovudina 60mg/Nevirapina 50mg'
when 49 then '[3TC/AZT/ABC] Lamivudina 150mg/Zidovudina 300mg/Abacavir 300mg'
when 50 then '[TDF/FTC] Tenofovir 300mg/Emtricitabina 200mg'
when 51 then '[DTG] Dolutegravir 10 mg 90 Comp'
when 52 then '[DTG] Dolutegravir 10 mg 30 Comp'
when 53 then '[ABC/3TC] Abacavir 120mg/Lamivudina 60mg 30 Comp'				
   else null end,                  
   encounter_datetime, obs_group_id
from  pharmacy_patient p
inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
    inner join drug d on o.value_drug=d.drug_id
where   e.voided=0 and o.voided=0 and d.retired=0 and e.encounter_type=18 and o.concept_id=165256 and o.obs_datetime BETWEEN startDate AND endDate;

update pharmacy_drugs,obs
set  pharmacy_drugs.quantity=obs.value_numeric
where   pharmacy_drugs.patient_id=obs.person_id and
    pharmacy_drugs.pickup_date=obs.obs_datetime and 
    pharmacy_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1715 and
    obs.voided=0;

update pharmacy_drugs,obs
set  pharmacy_drugs.dosage=obs.value_text
where   pharmacy_drugs.patient_id=obs.person_id and
    pharmacy_drugs.pickup_date=obs.obs_datetime and
    pharmacy_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1711 and
    obs.voided=0;

/*URBAN AND MAIN*/
update pharmacy_patient set urban='N';
update pharmacy_patient set main='N';
if district='Quelimane' then
  update pharmacy_patient set urban='Y';
end if;
if district='Namacurra' then
  update pharmacy_patient set main='Y' where location_id=5;
end if;
if district='Maganja' then
  update pharmacy_patient set main='Y' where location_id=15;
end if;
if district='Pebane' then
  update pharmacy_patient set main='Y' where location_id=16;
end if;
if district='Gile' then
  update pharmacy_patient set main='Y' where location_id=6;
end if;
if district='Molocue' then
  update pharmacy_patient set main='Y' where location_id=3;
end if;
if district='Mocubela' then
  update pharmacy_patient set main='Y' where location_id=62;
end if;
if district='Inhassunge' then
  update pharmacy_patient set main='Y' where location_id=7;
end if;
if district='Ile' then
  update pharmacy_patient set main='Y' where location_id in (4,55);
end if;
if district='Namarroi' then
  update pharmacy_patient set main='Y' where location_id in (252);
end if;
if district='Mopeia' then
  update pharmacy_patient set main='Y' where location_id in (11);
end if;
if district='Morrumbala' then
  update pharmacy_patient set main='Y' where location_id in (13);
end if;
if district='Gurue' then
  update pharmacy_patient set main='Y' where location_id in (280);
end if;
if district='Mocuba' then
  update pharmacy_patient set main='Y' where location_id in (227);
end if;
if district='Nicoadala' then
  update pharmacy_patient set main='Y' where location_id in (277);
end if;
if district='Milange' then
  update pharmacy_patient set main='Y' where location_id in (281);
end if;

end
;;
DELIMITER ;