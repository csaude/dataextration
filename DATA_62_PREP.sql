SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `prep_patient`;
CREATE TABLE  `prep_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `current_age` int(11) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `adress_1` varchar(100) DEFAULT null,
  `adress_2` varchar(100) DEFAULT null,
  `village` varchar(100) DEFAULT null,
  `art_initiation_date` datetime DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `women_status` varchar(100) DEFAULT NULL,
  `number_children_enrollment` int(11) DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL, 
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `prep_cd4_absolute`;
CREATE TABLE `prep_cd4_absolute` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `prep_cd4_percentage`;
CREATE TABLE `prep_cd4_percentage` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


 DROP TABLE IF EXISTS `prep_art_pick_up`;
CREATE TABLE IF NOT EXISTS `prep_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `pickup_art` varchar(5) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT 'Registo de Levantamento de ARVs Master Card'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `prep_fila_drugs`;
CREATE TABLE `prep_fila_drugs` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(300) DEFAULT NULL,
  `formulation` varchar(300) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `dosage` varchar(300) DEFAULT NULL,
  `pickup_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
  `accommodation_camp` char(3) DEFAULT NULL,
  `dispensation_model` varchar(300) DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT 'FILA'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `prep_extraction_cv`;
CREATE TABLE `prep_extraction_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  `request_id` varchar(30) DEFAULT NULL,
  `harvest_date` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(30) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `prep_visit`;
CREATE TABLE IF NOT EXISTS `prep_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source` varchar(255),
  `encounter` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `prep_art_regimes`;
CREATE TABLE `prep_art_regimes` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `regime_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `prep_differentiated_model`;
CREATE TABLE `prep_differentiated_model` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `differentiated_model` varchar(100) DEFAULT NULL,
  `differentiated_model_status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*prep_initial*/
DROP TABLE IF EXISTS `prep_initial_form`;
CREATE TABLE `prep_initial_form` (
 `patient_id` int(11) DEFAULT NULL,
 `nid_prep` varchar(255) DEFAULT NULL,
 `birth_date` datetime DEFAULT NULL,
 `current_age` int(2) DEFAULT NULL,
 `gender` varchar(255) DEFAULT NULL,
 `visit_date` datetime DEFAULT NULL,
 `date_initial_test` datetime DEFAULT NULL,
 `marital_status` varchar(255) DEFAULT NULL,
 `partner_nid` varchar(255) DEFAULT NULL,
 `hf_partner_hiv_care` varchar(255) DEFAULT NULL,
 `special_case_10_14` varchar(255) DEFAULT NULL,
 `member_target_population` varchar(255) DEFAULT NULL,
 `pregnancy_status_enrollment_prep` varchar(255) DEFAULT NULL,
 `situation_prep` varchar(255) DEFAULT NULL,
 `date_situation` datetime DEFAULT NULL,
  `source` varchar(100) DEFAULT 'FORMULARIO DE CONSULTA INICIAL PREP',
 `encounter` int(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*prep_seguimento*/
DROP TABLE IF EXISTS `prep_follow_up_form`;
CREATE TABLE `prep_follow_up_form` (
 `patient_id` int(11) DEFAULT NULL, 
`nid_prep` varchar(255) DEFAULT NULL,
`date_follow_up` datetime DEFAULT NULL,
`key_population` varchar(100) DEFAULT NULL,
`date_hiv_retesting` datetime DEFAULT NULL,
`result_hiv_retesting` varchar(255) DEFAULT NULL,
`symptoms_hiv_infection` varchar(255) DEFAULT NULL,
`condom_prevention_method` varchar(255) DEFAULT NULL,
`side_effects` varchar(255) DEFAULT NULL,
`sti_symptoms` varchar(255) DEFAULT NULL,
`adherence_counseling` varchar(255) DEFAULT NULL,
`counseling_risk_reduction` varchar(255) DEFAULT NULL,
`women_status` varchar(255) DEFAULT NULL,
`prep_prescription` varchar(255) DEFAULT NULL,
`prep_prescription_bottles` varchar(255) DEFAULT NULL,
`prep_interruption`varchar(255) DEFAULT NULL,
`next_scheduled_visit` datetime DEFAULT NULL,
 `source` varchar(100) DEFAULT 'FORMULARIO DE CONSULTA DE SEGUIMENTO PREP',
 `encounter` int(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP PROCEDURE IF EXISTS `FillPREP`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillPREP`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

TRUNCATE TABLE prep_cd4_absolute;
TRUNCATE TABLE prep_cd4_percentage;
TRUNCATE TABLE prep_art_pick_up;
TRUNCATE TABLE prep_fila_drugs;
TRUNCATE TABLE prep_extraction_cv;
TRUNCATE TABLE prep_visit;
TRUNCATE TABLE prep_art_regimes;
TRUNCATE TABLE prep_differentiated_model;
TRUNCATE TABLE prep_initial_form;
TRUNCATE TABLE prep_follow_up_form;

SET @location:=location_id_parameter;

/*INSCRICAO*/
insert into prep_patient(patient_id, enrollment_date, location_id)
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

Update prep_patient set prep_patient.district=district;

/*Health facility*/
update prep_patient,location
set prep_patient.health_facility=location.name
where prep_patient.location_id=location.location_id;

/*Apagar todos fora desta localização*/
delete from prep_patient where location_id not in (@location);

/*DATA DE NASCIMENTO*/
UPDATE prep_patient,
       person
SET prep_patient.date_of_birth=person.birthdate
WHERE prep_patient.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update prep_patient,person set prep_patient.age_enrollment=round(datediff(prep_patient.enrollment_date,person.birthdate)/365)
where  person_id=prep_patient.patient_id;

/*Data de Nascimento*/
update prep_patient,person set prep_patient.current_age=round(datediff("2023-09-20",person.birthdate)/365)
where  person_id=prep_patient.patient_id;

  /*Sexo*/
update prep_patient,person set prep_patient.sex=.person.gender
where  person.person_id=prep_patient.patient_id;

/*PROFISSAO*/
update prep_patient,obs
set prep_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=prep_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESCOLARIDADE*/
update prep_patient,obs
set prep_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
             else null end        
where obs.person_id=prep_patient.patient_id and obs.concept_id=1443 and voided=0;

/*ESTADO CIVIL*/
update prep_patient,obs
set prep_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=prep_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*Adress1*/
update prep_patient,person_address set prep_patient.adress_1=person_address.address1
where person_id=prep_patient.patient_id;

/*Adress2*/
update prep_patient,person_address set prep_patient.adress_2=person_address.address2
where person_id=prep_patient.patient_id;

/*last_city_village*/
update prep_patient,person_address set prep_patient.village=person_address.city_village
where person_id=prep_patient.patient_id;

/*INICIO TARV*/
UPDATE prep_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM prep_patient p
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
      FROM prep_patient p
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
      FROM prep_patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM prep_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET prep_patient.art_initiation_date=inicio_real.data_inicio
WHERE prep_patient.patient_id=inicio_real.patient_id;

/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update prep_patient,obs
set prep_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where prep_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=prep_patient.enrollment_date;

update prep_patient,obs
set prep_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where prep_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=prep_patient.enrollment_date and prep_patient.pregnancy_status_at_enrollment is null;

update prep_patient,patient_program
set prep_patient.pregnancy_status_at_enrollment= 'YES'
where prep_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;

/*WOMEN STATUS GRAVIDA/LACTANTE*/
update prep_patient,
  (  select patient_id,decisao from  (  select inicio_real.patient_id,
            				gravida_real.data_gravida,  lactante_real.data_parto,
            				if(max(gravida_real.data_gravida) is null and max(lactante_real.data_parto) is null,null,
            				if(max(gravida_real.data_gravida) is null,'Lactante',
            				if(max(lactante_real.data_parto) is null,'Gravida',
            				if(max(lactante_real.data_parto)>max(gravida_real.data_gravida),'Lactante','Gravida')))) decisao from (	 
            				select p.patient_id  from patient p  inner join encounter e on e.patient_id=p.patient_id
            				where e.voided=0 and p.voided=0 and e.encounter_type in (5,7) and e.encounter_datetime<=endDate and e.location_id = location_id
            				union  select pg.patient_id from patient p
            				inner join patient_program pg on p.patient_id=pg.patient_id
            				where pg.voided=0 and p.voided=0 and program_id in (1,2) and date_enrolled<=endDate and location_id
            				union  Select p.patient_id from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type=53 and
            				o.concept_id=23891 and o.value_datetime is not null and
            				o.value_datetime<=endDate and e.location_id  )inicio_real  left join  (
            				Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1982 and value_coded=1065 and
            				e.encounter_type in (5,6) and e.encounter_datetime  between startDate and endDate and e.location_id
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1279 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1600 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id	 
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6334 and value_coded=6331 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id		 
            				union  select pp.patient_id,pp.date_enrolled data_gravida from patient_program pp
            				where pp.program_id=8 and pp.voided=0 and
            				pp.date_enrolled between startDate and endDate and pp.location_id  union
            				Select p.patient_id,obsART.value_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				inner join obs obsART on e.encounter_id=obsART.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=1982 and o.value_coded=1065 and
            				e.encounter_type=53 and obsART.value_datetime between startDate and endDate and e.location_id and
            				obsART.concept_id=1190 and obsART.voided=0  union
            				Select p.patient_id,o.value_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=1465 and
            				e.encounter_type=6 and o.value_datetime between startDate and endDate and e.location_id
            				) gravida_real on gravida_real.patient_id=inicio_real.patient_id    left join   (
            				Select p.patient_id,o.value_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where  p.voided=0 and e.voided=0 and o.voided=0 and concept_id=5599 and
            				e.encounter_type in (5,6) and o.value_datetime between startDate and endDate and e.location_id	 
            				union  Select p.patient_id, e.encounter_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6332 and value_coded=1065 and
            				e.encounter_type=6 and e.encounter_datetime between startDate and endDate and e.location_id
            				union  Select p.patient_id, obsART.value_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				inner join obs obsART on e.encounter_id=obsART.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=6332 and o.value_coded=1065 and
            				e.encounter_type=53 and e.location_id and
            				obsART.value_datetime between startDate and endDate and
            				obsART.concept_id=1190 and obsART.voided=0  union
            				Select p.patient_id, e.encounter_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6334 and value_coded=6332 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id
            				union  select pg.patient_id,ps.start_date data_parto from patient p
            				inner join patient_program pg on p.patient_id=pg.patient_id
            				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
            				where pg.voided=0 and ps.voided=0 and p.voided=0 and
            				pg.program_id=8 and ps.state=27 and
            				ps.start_date between startDate and endDate and location_id
            				) lactante_real on lactante_real.patient_id=inicio_real.patient_id
            				where lactante_real.data_parto is not null or gravida_real.data_gravida is not null
            				group by inicio_real.patient_id  ) gravidaLactante		 
            				inner join person pe on pe.person_id=gravidaLactante.patient_id		 
            				where pe.voided=0 and pe.gender='F') gravidaLactante 
        set prep_patient.women_status=gravidaLactante.decisao
        where  prep_patient.patient_id=gravidaLactante.patient_id;


/*ESTADO ACTUAL DO STATUS DMC*/
update prep_patient,
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
set 	prep_patient.current_status_in_DMC=saida.codeestado
/*prep_patient.patient_status_date=saida.start_date*/
where saida.patient_id=prep_patient.patient_id;


 /*CD4 absolute*/
insert into prep_cd4_absolute(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  prep_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497  and o.obs_datetime BETWEEN startDate AND endDate;

/*CD4 percentage*/
insert into prep_cd4_percentage(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  prep_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=730   and o.obs_datetime BETWEEN startDate AND endDate;

/*LEVANTAMENTO AMC_ART*/
insert into prep_art_pick_up(patient_id,pickup_art,encounter)
  select distinct p.patient_id, case o.value_coded 
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as pick_art, e.encounter_id
  from prep_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=52 and o.concept_id=23865  and e.voided=0 and o.encounter_id=e.encounter_id
  and p.patient_id=o.person_id and o.obs_datetime < endDate;


update prep_art_pick_up,obs
set  prep_art_pick_up.art_date=obs.value_datetime
where   prep_art_pick_up.patient_id=obs.person_id and
    obs.concept_id=23866 and
    obs.voided=0 and prep_art_pick_up.encounter=obs.encounter_id and obs.obs_datetime < endDate;



/*Formulação FILA*/
insert into prep_fila_drugs(patient_id,regime,formulation,pickup_date, group_id, encounter)
select  p.patient_id, case  o.value_coded     
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
        when 5424 then 'OTHER ANTIRETROVIRAL DRUG'
        when 165330 then 'ATV/r+TDF+3TC+DTG'
        else null end,
case d.drug_id     
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
   e.encounter_datetime, o.obs_group_id, e.encounter_id
from  prep_patient p
inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id and concept_id in (1088,165256)
    inner join drug d on o.value_drug=d.drug_id
where   e.voided=0 and o.voided=0 and d.retired=0 and e.encounter_type=18 and o.concept_id in (1088,165256) 
and o.obs_datetime < endDate;

/*quantidade levantada*/
update prep_fila_drugs,obs
set  prep_fila_drugs.quantity=obs.value_numeric
where   prep_fila_drugs.patient_id=obs.person_id and
    prep_fila_drugs.pickup_date=obs.obs_datetime and 
    prep_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1715 and
    obs.voided=0;

/*dosagem */
update prep_fila_drugs,obs
set  prep_fila_drugs.dosage=obs.value_text
where   prep_fila_drugs.patient_id=obs.person_id and
    prep_fila_drugs.pickup_date=obs.obs_datetime and
    prep_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1711 and
    obs.voided=0;

/*proximo levantamento*/
update prep_fila_drugs,obs
set  prep_fila_drugs.next_art_date=obs.value_datetime
where   prep_fila_drugs.patient_id=obs.person_id and
      obs.concept_id=5096 and
    obs.voided=0 and prep_fila_drugs.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Campo de acomodação*/
UPDATE prep_fila_drugs AS efd
JOIN obs AS obs_patient ON efd.patient_id = obs_patient.person_id
                         AND efd.pickup_date = obs_patient.obs_datetime
JOIN prep_patient AS p ON efd.patient_id = p.patient_id
JOIN encounter AS e ON p.patient_id = e.patient_id
JOIN obs AS o ON e.encounter_id = o.encounter_id
JOIN obs AS obsEstado ON e.encounter_id = obsEstado.encounter_id
SET efd.accommodation_camp = CASE obsEstado.value_coded
                                WHEN 1065 THEN 'YES'
                                WHEN 1066 THEN 'NO'
                                ELSE NULL
                            END
WHERE e.encounter_type = 18
    AND e.voided = 0
    AND o.voided = 0
    AND o.concept_id = 23856;



/*tipo de dispensa na FILA*/
UPDATE prep_fila_drugs, obs,

(
    SELECT o.obs_id,
        CASE o.value_coded
            WHEN 23888 THEN 'SEMESTER ARV PICKUP (DS)'
            WHEN 165175 THEN 'NORMAL EXPEDIENT SCHEDULE'
            WHEN 165176 THEN 'OUT OF TIME'
            WHEN 165180 THEN 'DAILY MOBILE BRIGADES'
            WHEN 165181 THEN 'DAILY MOBILE BRIGADES (HOTSPOTS)'
            WHEN 165182 THEN 'DAILY MOBILE CLINICS'
            WHEN 165183 THEN 'NIGHT MOBILE BRIGADES (HOTSPOTS)'
            WHEN 165314 THEN 'ARV ANUAL DISPENSATION (DA)'
            WHEN 165315 THEN 'DESCENTRALIZED ARV DISPENSATION (DD)'
            WHEN 165178 THEN 'COMMUNITY DISPENSE VIA PROVIDER (DCP)'
            WHEN 165179 THEN 'COMMUNITY DISPENSE VIA APE (DCA)'
            WHEN 165264 THEN 'MOBILE BRIGADES (DCBM)'
            WHEN 165265 THEN 'MOBILE CLINICS (DCCM)'
            WHEN 23725 THEN 'FAMILY APPROACH (AF)'
            WHEN 23729 THEN 'RAPID FLOW (FR)'
            WHEN 23724 THEN 'GAAC (GA)'
            WHEN 23726 THEN 'ACCESSION CLUBS (CA)'
            WHEN 165316 THEN 'HOURS EXTENSION (EH)'
            WHEN 165317 THEN 'SINGLE STOP IN TB SECTOR (TB)'
            WHEN 165318 THEN 'SINGLE STOP ON TARV SERVICES (CT)'
            WHEN 165319 THEN 'SINGLE STOP SAAJ (SAAJ)'
            WHEN 165320 THEN 'SINGLE STOP SMI (SMI)'
            WHEN 165321 THEN 'HIV ADVANCED DISEASE (DAH)'
            WHEN 23727 THEN 'SINGLE STOP (PU)'
            WHEN 165177 THEN 'FARMAC/PRIVATE PHARMACY (FARMAC)'
            WHEN 23731 THEN 'COMMUNITY DISPENSATION (DC)'
            WHEN 23732 THEN 'OTHER'
            WHEN 23730 THEN 'QUARTERLY DISPENSATION (DT)'
            ELSE NULL
        END as regime
    FROM obs o
    INNER JOIN encounter e ON e.encounter_id = o.encounter_id
    WHERE e.voided = 0
        AND o.voided = 0
        AND o.concept_id = 165174
) dis

SET prep_fila_drugs.dispensation_model = dis.regime
WHERE prep_fila_drugs.patient_id = obs.person_id
    AND prep_fila_drugs.pickup_date = obs.obs_datetime
    AND obs.obs_id=dis.obs_id;


/*CARGA VIRAL*/
insert into prep_extraction_cv(patient_id,cv,cv_qualit,cv_date,encounter,source,request_id)
select valor.patient_id,valor.value_numeric,valor.value_cod,valor.obs_datetime,valor.encounter_id,valor.encounter_type,requisicao.value_text
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
    e.encounter_id, case e.encounter_type
     when 13 then 'Ficha Laboratorio'
    when 51 then 'FSR'
    else null end as encounter_type
from  prep_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (856,1305) and e.encounter_datetime  between startDate and endDate
)  valor 
left join
(
Select p.patient_id,
    o.value_numeric,
    o.obs_datetime,
    o.value_text,
    e.encounter_id
from  prep_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (13,51) and o.concept_id in (22771) and e.encounter_datetime  between startDate and endDate 
) requisicao on valor.encounter_id= requisicao.encounter_id
group by valor.patient_id,valor.obs_datetime,valor.encounter_id; 


/*Data da Colheita*/
update prep_extraction_cv,obs
set  prep_extraction_cv.harvest_date=obs.value_datetime
where   prep_extraction_cv.patient_id=obs.person_id and
    obs.concept_id=23821 and
    obs.voided=0 and prep_extraction_cv.encounter=obs.encounter_id and obs.obs_datetime < endDate;



/*VISITAS*/
insert into prep_visit(patient_id,visit_date,source, encounter)
Select distinct p.patient_id,e.encounter_datetime, case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 53 then 'Ficha Resumo'
    when 35 then 'Ficha APSS e PP'
    else null end as encounter_type, e.encounter_id
from  prep_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id 
where   e.voided=0 and e.encounter_type in (6,53,35) and e.encounter_datetime  < endDate;

/* PROXIMA VISITAS Clinica*/
update prep_visit,obs,encounter 
set  prep_visit.next_visit_date=obs.value_datetime
where   prep_visit.patient_id=obs.person_id and
    obs.concept_id=1410 and 
    encounter.encounter_type=6 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/* PROXIMA VISITAS Apss*/
update prep_visit,obs,encounter
set  prep_visit.next_visit_date=obs.value_datetime
where   prep_visit.patient_id=obs.person_id and 
    obs.concept_id=6310 and 
    encounter.encounter_type=35 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*LEVANTAMENTO Regime*/
insert into prep_art_regimes(patient_id,regime,regime_date)
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
        when 6424 then 'TDF+3TC+LPV/r'
        else null end,
        encounter_datetime
  from prep_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type in (53,6) and o.concept_id=23893  and e.voided=0  
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; 

  /* community model*/  
   insert into prep_differentiated_model(patient_id,visit_date,differentiated_model) 
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
        and person_id IN (select patient_id from community_arv_patient);

    update prep_differentiated_model,
    (
    select p.patient_id,e.encounter_datetime,
    case obsEstado.value_coded
    when 1256  then 'START DRUGS'
    when 1257  then 'CONTINUE REGIMEN'
    when 1267  then 'COMPLETED' else null end  status
    from community_arv_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    inner join obs obsEstado on obsEstado.encounter_id=e.encounter_id
    where e.encounter_type in (6,9,18) and e.voided=0 and o.voided=0
    and o.concept_id=165174  and obsEstado.concept_id=165322 and obsEstado.voided=0
    ) final
    set prep_differentiated_model.differentiated_model_status=final.status
    where prep_differentiated_model.patient_id=final.patient_id
    and prep_differentiated_model.visit_date=final.encounter_datetime;


/*FICHA PREP inicial*/
INSERT INTO prep_initial_form (patient_id, nid_prep, birth_date, current_age, gender, visit_date, encounter)
SELECT
    persondata.person_id,
    nids.nid AS nid_prep,
    persondata.birthdate, 
    persondata.current_age,
    persondata.gender,
    obs.obs_datetime AS visit_date,
    e.encounter_id
FROM
    (SELECT
        pe.person_id,
        TIMESTAMPDIFF(YEAR, pe.birthdate, NOW()) AS current_age,
        pe.birthdate,
        pe.gender
    FROM
        person pe
    WHERE
        pe.voided = 0
        AND pe.birthdate IS NOT NULL
        AND pe.gender IS NOT NULL) AS persondata
LEFT JOIN
    (SELECT
        patient_id,
        GROUP_CONCAT(identifier SEPARATOR ", ") AS nid,
        location_id
    FROM 
        patient_identifier
    WHERE 
        voided = 0
        AND identifier_type = 17
    GROUP BY 
        patient_id) AS nids
ON
    persondata.person_id = nids.patient_id
INNER JOIN
    prep_patient p ON p.patient_id = persondata.person_id
INNER JOIN
    encounter e ON p.patient_id = e.patient_id
INNER JOIN
    obs ON obs.encounter_id = e.encounter_id
WHERE   
    e.voided = 0
    AND e.encounter_type = 80
    AND obs.voided = 0
    AND obs.obs_datetime < endDate;


/*Prep inicialdate initial*/
update prep_initial_form,obs,encounter
set  prep_initial_form.birth_date=obs.value_datetime
where   prep_initial_form.patient_id=obs.person_id and 
    obs.concept_id=165194 and 
    encounter.encounter_type=80 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

    /*Prep inicialdate marital status*/
update prep_initial_form,obs,encounter
set  prep_initial_form.birth_date= case obs.value_coded
              when 1056 then 'SEPARATED'
              when 1057 then 'NEVER MARRIED'
              when 1058 then 'DIVORCED'
              when 1059 then 'WIDOWED'
              when 1060 then 'LIVING WITH PARTNER'
              when 5555 then 'MARRIED'
              when 1175 then 'NOT APPLICABLE'
              when 5622 then 'Other'
  else null end 
where   prep_initial_form.patient_id=obs.person_id and 
    obs.concept_id=1054 and 
    encounter.encounter_type=80 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/*Prep hiv partner US*/
update prep_initial_form,obs,encounter
set  prep_initial_form.hf_partner_hiv_care=obs.value_text
where   prep_initial_form.patient_id=obs.person_id and 
    obs.concept_id=165195 and 
    encounter.encounter_type=80 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep special case*/
update prep_initial_form,obs,encounter
set  prep_initial_form.special_case_10_14= case obs.value_coded
              when 1065 then 'YES'
              when 1066 then 'No' 
  else null end 
where   prep_initial_form.patient_id=obs.person_id and 
    obs.concept_id=165285 and 
    encounter.encounter_type=80 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/*Pregnancy status*/
update prep_initial_form,obs,encounter
set  prep_initial_form.pregnancy_status_enrollment_prep= case obs.value_coded
              when 1175 then 'YES'
              when 1066 then 'No' 
              when 1067 then 'Unknown' 
              when 44 then 'GESTATION' 
              when 1065 then 'Yes' 
  else null end 
where   prep_initial_form.patient_id=obs.person_id and 
    obs.concept_id=1982 and 
    encounter.encounter_type=80 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep Initial Status*/
update prep_initial_form,obs,encounter
set  prep_initial_form.situation_prep= case obs.value_coded
              when 1256 then 'START DRUGS'
              when 1705 then 'RESTART' 
              when 1257 then 'CONTINUE REGIMEN'
  else null end,
  prep_initial_form.situation_prep=obs.obs_datetime 
where   prep_initial_form.patient_id=obs.person_id and 
    obs.concept_id=165296 and 
    encounter.encounter_type=80 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep Initial Status*/
update prep_initial_form,obs,encounter
set  prep_initial_form.situation_prep= case obs.value_coded
              when 1256 then 'START DRUGS'
              when 1705 then 'RESTART' 
              when 1257 then 'CONTINUE REGIMEN'
  else null end,
  prep_initial_form.date_situation=obs.obs_datetime 
where   prep_initial_form.patient_id=obs.person_id and 
    obs.concept_id=165296 and 
    encounter.encounter_type=80 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*FICHA PREP seguimento*/
INSERT INTO prep_follow_up_form (patient_id, date_follow_up, encounter, nid_prep)
SELECT DISTINCT p.patient_id, e.encounter_datetime, e.encounter_id, nids.nid AS nid_prep
FROM prep_patient p 
INNER JOIN encounter e ON p.patient_id = e.patient_id 
INNER JOIN obs o ON o.encounter_id = e.encounter_id
LEFT JOIN (
    SELECT
        patient_id,
        GROUP_CONCAT(identifier SEPARATOR ", ") AS nid,
        location_id
    FROM 
        patient_identifier
    WHERE 
        voided = 0
        AND identifier_type = 17
    GROUP BY 
        patient_id
) AS nids ON p.patient_id = nids.patient_id
WHERE   
    e.voided = 0
    AND e.encounter_type = 81
    AND e.encounter_datetime < endDate;


/*Prep Seguimento KP*/
update prep_initial_form,obs,encounter
set  prep_follow_up_form.key_population= case obs.value_coded
              when 1377 then 'Men who have sex with Men'
              when 20454 then 'Drug Use' 
              when 20426 then 'IMPRISONMENT AND OTHER INCARCERATION'
              when 1901 then 'SEX WORKER'
              when 165205 then 'TRANSGENDER'
              when 5622 then 'other'
  else null end 
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=23703 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/*Prep seguimento retestagem*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.result_hiv_retesting= case obs.value_coded
            when 664 then 'NEGATIVE'
            when 703 then 'POSITIVE'
            when 1304 then 'POOR SAMPLE QUALITY'
            when 1175 then 'NOT APPLICABLE'
            when 1138 then 'INDETERMINATE'
            when 1067 then 'Unknown'
            when 1118 then 'NOT DONE'
  else null end,
  prep_follow_up_form.date_hiv_retesting=obs.obs_datetime 
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=1040 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/*Prep Seguimento sintomas*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.symptoms_hiv_infection= case obs.value_coded
              when 1065 then 'Yes'
              when 1066 then 'No' 
       else null end 
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165219 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep condom use*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.condom_prevention_method= case obs.value_coded
              when 1065 then 'Yes'
              when 1066 then 'No' 
       else null end 
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=5571 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

    /*Prep seguimento efeitos secundarios*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.side_effects= case obs.value_coded
              when 3 then 'ANEMIA NOS'
              when 6292 then	'NEUTROPENIA'
              when 6293 then	'PANCREATITIS' 
              when 6294 then	'HEPATOTOXICITY' 
              when 6295 then	'PSYCHOLOGICAL CHANGES' 
              when 821 then'PERIPHERAL NEUROPATHY' 
              when 6296 then	'MYOPATHY' 
              when 6297 then	'SKIN ALLERGY' 
              when 6298 then	'LIPODYSTROPHY' 
              when 16 then   'DIARRHOEA' 
              when 1406 then	'OTHER DIAGNOSIS' 
              when 6299 then	'LACTIC ACIDOSIS' 
              when 29 then 'HEPATITIS' 
              when 11428 then	'Erupção cutânea generalizada devida a drogas e medicamentos' 
              when 14475 then	'Nausea and Vomiting' 
              when 14671 then	'Hyperglycaemia' 
              when 23747 then	'DYSLIPIDEMIA' 
              when 23748 then	'CYTOPENIA' 
              when 23749 then	'NEPHROTOXICITY' 
              when 23750 then	'STEVENS-JOHNSON SYNDROME' 
              when 23751 then	'HYPERSENSITIVITY TO ABC/RAL' 
              when 23752 then	'HEPATIC STEATOSIS WITH HYPERLACTATAEMIA' 
              when 151 then 'ABDOMINAL PAIN'
       else null end 
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=2015 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep doenca renal*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.sti_symptoms= case obs.value_coded
              when 1065 then 'Yes'
              when 1066 then 'No' 
       else null end
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165294 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep adesão conseling*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.adherence_counseling= case obs.value_coded
              when 1065 then 'Yes'
              when 1066 then 'No' 
       else null end
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165221 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep adesão risk conseling*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.counseling_risk_reduction= case obs.value_coded
              when 1065 then 'Yes'
              when 1066 then 'No' 
       else null end
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165222 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


    /*Prep seguimento women status*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.women_status= case obs.value_coded
              when 1982 then 'Pregnant'
              when 6332 then 'Lactation' 
              when 1175 then 'Not Applicable' 
       else null end
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165223 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Prep prescricao*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.prep_prescription= case obs.value_coded
              when 165214 then 'TDF/3TC'
              when 165215 then 'TDF/FTC' 
              when 165216 then 'OTHER DRUG PREP'
              when 165224 then 'SEM PRESCRICAO' 
       else null end
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165213 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

    /*Prep nr frascos*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.prep_prescription_bottles=obs.value_numeric
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165217 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/*Prep prep interruption*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.prep_interruption= case obs.value_coded
              when 1169   then 'HIV INFECTED'
              when 165226 then 'NO MORE SUBSTANTIAL RISKS'
              when 2015   then 'PATIENT DOES NOT LIKE ARV TREATMENT SIDE EFFECTS' 
              when 165227 then 'USER PREFERENCE' 
              when 5622   then 'Other' 
              when 1175   then 'NOT APPLICABLE' 
       else null end
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165225 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/*Prep proxima visita*/
update prep_follow_up_form,obs,encounter
set  prep_follow_up_form.next_scheduled_visit=obs.value_datetime
where   prep_follow_up_form.patient_id=obs.person_id and 
    obs.concept_id=165228 and 
    encounter.encounter_type=81 and obs.voided=0 and prep_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;














/*URBAN AND MAIN*/
update prep_patient set urban='N';
update prep_patient set main='N';
if district='Quelimane' then
  update prep_patient set urban='Y';
end if;
if district='Namacurra' then
  update prep_patient set main='Y' where location_id=5;
end if;
if district='Maganja' then
  update prep_patient set main='Y' where location_id=15;
end if;
if district='Pebane' then
  update prep_patient set main='Y' where location_id=16;
end if;
if district='Gile' then
  update prep_patient set main='Y' where location_id=6;
end if;
if district='Molocue' then
  update prep_patient set main='Y' where location_id=3;
end if;
if district='Mocubela' then
  update prep_patient set main='Y' where location_id=62;
end if;
if district='Inhassunge' then
  update prep_patient set main='Y' where location_id=7;
end if;
if district='Ile' then
  update prep_patient set main='Y' where location_id in (4,55);
end if;
if district='Namarroi' then
  update prep_patient set main='Y' where location_id in (252);
end if;
if district='Mopeia' then
  update prep_patient set main='Y' where location_id in (11);
end if;
if district='Morrumbala' then
  update prep_patient set main='Y' where location_id in (13);
end if;
if district='Gurue' then
  update prep_patient set main='Y' where location_id in (280);
end if;
if district='Mocuba' then
  update prep_patient set main='Y' where location_id in (227);
end if;
if district='Nicoadala' then
  update prep_patient set main='Y' where location_id in (277);
end if;
if district='Milange' then
  update prep_patient set main='Y' where location_id in (281);
end if;

end
;;
DELIMITER ;