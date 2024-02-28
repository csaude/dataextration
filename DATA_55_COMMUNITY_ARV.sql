SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `community_arv_patient`;
CREATE TABLE  `community_arv_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `openmrs_current_age` int(11) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `women_status` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `partner_status_at_enrollment` varchar(100) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(10) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `art_regimen` varchar(255) DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL,
  `tb_at_screening` varchar(255) DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL, 
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`),
  KEY `height_date` (`height_date`),
  KEY `weight_date` (`weight_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `community_arv_WHO_clinical_stage`;
CREATE TABLE `community_arv_WHO_clinical_stage` (
  `patient_id` int(11) DEFAULT NULL,
  `who_stage`  varchar(4) DEFAULT NULL,
  `who_stage_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_art_pick_up`;
CREATE TABLE IF NOT EXISTS `community_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `pickup_art` varchar(5) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT 'Registo de Levantamento de ARVs Master Card'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_art_fila_drugs`;
CREATE TABLE `community_art_fila_drugs` (
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

DROP TABLE IF EXISTS `community_arv_weight`;
CREATE TABLE `community_arv_weight` (
  `patient_id` int(11) DEFAULT NULL,
  `weight`  varchar(10) DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_height`;
CREATE TABLE `community_arv_height` (
  `patient_id` int(11) DEFAULT NULL,
  `height`  varchar(10) DEFAULT NULL,
  `height_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_viral_load`;
CREATE TABLE `community_arv_viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` double DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_comments` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_cd4_absolute`;
CREATE TABLE `community_arv_cd4_absolute` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_cd4_percentage`;
CREATE TABLE `community_arv_cd4_percentage` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_visit`;
CREATE TABLE IF NOT EXISTS `community_arv_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source` varchar(255),
  `encounter` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_arv_posology`;
CREATE TABLE `community_arv_posology` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `dmc_type` varchar(100) DEFAULT NULL,
  `therapeutic_line` varchar(100) DEFAULT NULL,
  `posology` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_type_arv_dispensation`;
CREATE TABLE `community_type_arv_dispensation` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `dispensation_type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_differentiated_model`;
CREATE TABLE `community_differentiated_model` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `differentiated_model` varchar(100) DEFAULT NULL,
  `differentiated_model_status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_support_groups_visit`;
CREATE TABLE `community_support_groups_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_support_groups` varchar(100) DEFAULT NULL,
  `date_elegibbly_support_groups` datetime DEFAULT NULL,
  `type_support_groups` varchar(100) DEFAULT NULL,
  `value_support_groups` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `community_dmc_type_of_dispensation_visit`;
CREATE TABLE `community_dmc_type_of_dispensation_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `type_dmc` varchar(100) DEFAULT NULL,
  `value_dmc` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- community_arv_patient table
CREATE INDEX idx_patient_id_arv_patient ON community_arv_patient (patient_id);

-- community_arv_WHO_clinical_stage table
CREATE INDEX idx_patient_id_WHO_clinical_stage ON community_arv_WHO_clinical_stage (patient_id);

-- community_art_pick_up table
CREATE INDEX idx_patient_id_art_pick_up ON community_art_pick_up (patient_id);

-- community_art_fila_drugs table
CREATE INDEX idx_patient_id_art_fila_drugs ON community_art_fila_drugs (patient_id);

-- community_arv_weight table
CREATE INDEX idx_patient_id_arv_weight ON community_arv_weight (patient_id);

-- community_arv_height table
CREATE INDEX idx_patient_id_arv_height ON community_arv_height (patient_id);

-- community_arv_viral_load table
CREATE INDEX idx_patient_id_arv_viral_load ON community_arv_viral_load (patient_id);

-- community_arv_cd4_absolute table
CREATE INDEX idx_patient_id_arv_cd4_absolute ON community_arv_cd4_absolute (patient_id);

-- community_arv_cd4_percentage table
CREATE INDEX idx_patient_id_arv_cd4_percentage ON community_arv_cd4_percentage (patient_id);

-- community_arv_visit table
CREATE INDEX idx_patient_id_arv_visit ON community_arv_visit (patient_id);

-- community_arv_posology table
CREATE INDEX idx_patient_id_arv_posology ON community_arv_posology (patient_id);

-- community_type_arv_dispensation table
CREATE INDEX idx_patient_id_type_arv_dispensation ON community_type_arv_dispensation (patient_id);

-- community_differentiated_model table
CREATE INDEX idx_patient_id_differentiated_model ON community_differentiated_model (patient_id);

-- community_support_groups_visit table
CREATE INDEX idx_patient_id_support_groups_visit ON community_support_groups_visit (patient_id);

-- community_dmc_type_of_dispensation_visit table
CREATE INDEX idx_patient_id_dmc_type_of_dispensation ON community_dmc_type_of_dispensation_visit (patient_id);



DROP PROCEDURE IF EXISTS `FillCOMMARV`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillCOMMARV`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

TRUNCATE TABLE community_arv_WHO_clinical_stage;
TRUNCATE TABLE community_art_pick_up;
TRUNCATE TABLE community_art_fila_drugs;
TRUNCATE TABLE community_arv_weight;
TRUNCATE TABLE community_arv_height;
TRUNCATE TABLE community_arv_viral_load;
TRUNCATE TABLE community_arv_cd4_absolute;
TRUNCATE TABLE community_arv_cd4_percentage;
TRUNCATE TABLE community_arv_visit;
TRUNCATE TABLE community_arv_posology;
TRUNCATE TABLE community_type_arv_dispensation;
TRUNCATE TABLE community_differentiated_model;
TRUNCATE TABLE community_support_groups_visit;
TRUNCATE TABLE community_dmc_type_of_dispensation_visit;


SET @location:=location_id_parameter;

/*INSCRICAO*/
insert into community_arv_patient(patient_id, enrollment_date, location_id)
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

Update community_arv_patient set community_arv_patient.district=district;

update community_arv_patient,location
set community_arv_patient.health_facility=location.name
where community_arv_patient.location_id=location.location_id;

/*Apagar todos fora desta localização*/
delete from community_arv_patient where location_id not in (@location);

/*DATA DE NASCIMENTO*/
UPDATE community_arv_patient,
       person
SET community_arv_patient.date_of_birth=person.birthdate
WHERE community_arv_patient.patient_id=person.person_id;

/*IDADE NA INSCRICAO*/
update community_arv_patient,person set community_arv_patient.age_enrollment=round(datediff(community_arv_patient.enrollment_date,person.birthdate)/365)
where  person_id=community_arv_patient.patient_id;

/*Data de Nascimento*/
update community_arv_patient,person set community_arv_patient.openmrs_current_age=round(datediff("2023-09-20",person.birthdate)/365)
where  person_id=community_arv_patient.patient_id;

/*Exclusion criteria*/
delete from community_arv_patient where openmrs_current_age<2;

  /*Sexo*/
update community_arv_patient,person set community_arv_patient.sex=.person.gender
where  person.person_id=community_arv_patient.patient_id;

/*ESTADO CIVIL*/
update community_arv_patient,obs
set community_arv_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update community_arv_patient,obs
set community_arv_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where community_arv_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=community_arv_patient.enrollment_date;

update community_arv_patient,obs
set community_arv_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where community_arv_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=community_arv_patient.enrollment_date and community_arv_patient.pregnancy_status_at_enrollment is null;

update community_arv_patient,patient_program
set community_arv_patient.pregnancy_status_at_enrollment= 'YES'
where community_arv_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;


/*WOMEN STATUS GRAVIDA/LACTANTE*/
update community_arv_patient,
  (  select patient_id,decisao from  (  select inicio_real.patient_id,
            				gravida_real.data_gravida,  lactante_real.data_parto,
            				if(max(gravida_real.data_gravida) is null and max(lactante_real.data_parto) is null,null,
            				if(max(gravida_real.data_gravida) is null,'Lactante',
            				if(max(lactante_real.data_parto) is null,'Gravida',
            				if(max(lactante_real.data_parto)>max(gravida_real.data_gravida),'Lactante','Gravida')))) decisao from (	 
            				select p.patient_id  from patient p  inner join encounter e on e.patient_id=p.patient_id
            				where e.voided=0 and p.voided=0 and e.encounter_type in (5,7) and e.encounter_datetime<=endDate and e.location_id = 398
            				union  select pg.patient_id from patient p
            				inner join patient_program pg on p.patient_id=pg.patient_id
            				where pg.voided=0 and p.voided=0 and program_id in (1,2) and date_enrolled<=endDate and location_id=398
            				union  Select p.patient_id from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type=53 and
            				o.concept_id=23891 and o.value_datetime is not null and
            				o.value_datetime<=endDate and e.location_id=398  )inicio_real  left join  (
            				Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1982 and value_coded=1065 and
            				e.encounter_type in (5,6) and e.encounter_datetime  between startDate and endDate and e.location_id=398
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1279 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id=398
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=1600 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id=398	 
            				union  Select p.patient_id,e.encounter_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6334 and value_coded=6331 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id=398		 
            				union  select pp.patient_id,pp.date_enrolled data_gravida from patient_program pp
            				where pp.program_id=8 and pp.voided=0 and
            				pp.date_enrolled between startDate and endDate and pp.location_id=398  union
            				Select p.patient_id,obsART.value_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				inner join obs obsART on e.encounter_id=obsART.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=1982 and o.value_coded=1065 and
            				e.encounter_type=53 and obsART.value_datetime between startDate and endDate and e.location_id=398 and
            				obsART.concept_id=1190 and obsART.voided=0  union
            				Select p.patient_id,o.value_datetime data_gravida from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=1465 and
            				e.encounter_type=6 and o.value_datetime between startDate and endDate and e.location_id=398
            				) gravida_real on gravida_real.patient_id=inicio_real.patient_id    left join   (
            				Select p.patient_id,o.value_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where  p.voided=0 and e.voided=0 and o.voided=0 and concept_id=5599 and
            				e.encounter_type in (5,6) and o.value_datetime between startDate and endDate and e.location_id=398	 
            				union  Select p.patient_id, e.encounter_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6332 and value_coded=1065 and
            				e.encounter_type=6 and e.encounter_datetime between startDate and endDate and e.location_id=398
            				union  Select p.patient_id, obsART.value_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				inner join obs obsART on e.encounter_id=obsART.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=6332 and o.value_coded=1065 and
            				e.encounter_type=53 and e.location_id=398 and
            				obsART.value_datetime between startDate and endDate and
            				obsART.concept_id=1190 and obsART.voided=0  union
            				Select p.patient_id, e.encounter_datetime data_parto from patient p
            				inner join encounter e on p.patient_id=e.patient_id
            				inner join obs o on e.encounter_id=o.encounter_id
            				where p.voided=0 and e.voided=0 and o.voided=0 and concept_id=6334 and value_coded=6332 and
            				e.encounter_type in (5,6) and e.encounter_datetime between startDate and endDate and e.location_id=398
            				union  select pg.patient_id,ps.start_date data_parto from patient p
            				inner join patient_program pg on p.patient_id=pg.patient_id
            				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
            				where pg.voided=0 and ps.voided=0 and p.voided=0 and
            				pg.program_id=8 and ps.state=27 and
            				ps.start_date between startDate and endDate and location_id=398
            				) lactante_real on lactante_real.patient_id=inicio_real.patient_id
            				where lactante_real.data_parto is not null or gravida_real.data_gravida is not null
            				group by inicio_real.patient_id  ) gravidaLactante		 
            				inner join person pe on pe.person_id=gravidaLactante.patient_id		 
            				where pe.voided=0 and pe.gender='F') gravidaLactante 
        set community_arv_patient.women_status=gravidaLactante.decisao
        where  community_arv_patient.patient_id=gravidaLactante.patient_id;


/*ESCOLARIDADE*/
update community_arv_patient,obs
set community_arv_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
             else null end
          
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update community_arv_patient,obs
set community_arv_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO DO PARCEIRO*/
update community_arv_patient,obs
set community_arv_patient.partner_status_at_enrollment= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=community_arv_patient.patient_id and obs.concept_id=1449 and obs.voided=0; 

/*ESTADIO OMS AT ENROLLMENT*/
update community_arv_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from community_arv_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set community_arv_patient.WHO_clinical_stage_at_enrollment=stage.cod,
community_arv_patient.WHO_clinical_stage_at_enrollment_date=stage.encounter_datetime
where community_arv_patient.patient_id=stage.patient_id 
and community_arv_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;

/*Apagar todos ESTADIO OMS II E IV*/
delete from community_arv_patient where WHO_clinical_stage_at_enrollment='III' OR WHO_clinical_stage_at_enrollment='IV';

/*PESO AT TIME OF ART ENROLLMENT*/
update community_arv_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  community_arv_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set community_arv_patient.weight_enrollment=obs.value_numeric, community_arv_patient.weight_date=peso.encounter_datetime
where community_arv_patient.patient_id=obs.person_id 
and community_arv_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update community_arv_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  community_arv_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set community_arv_patient.height_enrollment=obs.value_numeric, community_arv_patient.height_date=altura.encounter_datetime
where community_arv_patient.patient_id=obs.person_id 
and community_arv_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;

/*INICIO TARV*/
UPDATE community_arv_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM community_arv_patient p
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
      FROM community_arv_patient p
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
      FROM community_arv_patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM community_arv_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET community_arv_patient.art_initiation_date=inicio_real.data_inicio
WHERE community_arv_patient.patient_id=inicio_real.patient_id;

/*ARV TRATMENT AT FIRST ANC VISIT*/
update community_arv_patient,
(
Select cpn.patient_id, cpn.data_cpn,  case obs.value_coded
when 6388 then 'ON ARV TREATMENT AT ANC ENTRANCE' 
when 631  then 'NEVIRAPINE' 
when 1801 then 'ZIDOVUDINE + NEVIRAPINE' 
when 1256 then 'START DRUGS' 
when 1257 then 'CONTINUE REGIMEN' 
when 797 then 'ZIDOVUDINE'
when 792 then 'STAVUDINE + LAMIVUDINE + NEVIRAPINE'
when 628 then 'LAMIVUDINE'
when 87 then 'SULFADOXINE AND PYRIMETHAMINE'
when 1800 then 'TARV TREATMENT'
when 916 then 'TRIMETHOPRIM AND SULFAMETHOXAZOLE'
when 1107 then 'NONE'
when 630 then 'ZIDOVUDINE AND LAMIVUDINE'
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  community_arv_patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   e.voided=0  and e.encounter_type in (11) 
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=1504 
)updateART
set community_arv_patient.ART_regimen=updateART.cod
where community_arv_patient.patient_id=updateART.patient_id;

/*Estado Actual TARV*/
update community_arv_patient,
		(select 	pg.patient_id,ps.start_date,
				case ps.state
					when 7 then 'TRASFERRED OUT'
					when 8 then 'SUSPENDED'
					when 9 then 'ART LTFU'
					when 10 then 'DEAD'
				else null end as codeestado
		from 	community_arv_patient p 
				inner join patient_program pg on p.patient_id=pg.patient_id
				inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
		where 	pg.voided=0 and ps.voided=0 and  
				pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
				ps.start_date BETWEEN startDate AND endDate
		) saida
set 	community_arv_patient.patient_status=saida.codeestado,
community_arv_patient.patient_status_date=saida.start_date
where saida.patient_id=community_arv_patient.patient_id;

/*TB */
update community_arv_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  community_arv_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id in(6257,23758)
  group by p.patient_id
)tb, obs
set community_arv_patient.tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where community_arv_patient.patient_id=obs.person_id 
and community_arv_patient.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id in(6257,23758) ;

/*TB DIAGNOSTIC*/   
update community_arv_patient,
    (select p.patient_id,
         e.encounter_datetime,
        case o.value_coded
        when 664 then 'NEGATIVE'
        when 703 then 'POSITIVE'
        when 1065 then 'YES'
        when 1066 then 'NO'
        else null end as cod
    from  community_arv_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id in (6277,23761) and e.encounter_type in (6,9) and e.voided=0 
    ) tb
set community_arv_patient.tb_co_infection= tb.cod
where tb.patient_id=community_arv_patient.patient_id;


/*PMC Entry date*/
update community_arv_patient, patient_program
	set community_arv_patient.pmtct_entry_date=date_enrolled
	where voided=0 and program_id=8 and community_arv_patient.patient_id=patient_program.patient_id;

/*PMC exit date*/
update community_arv_patient, patient_program
	set community_arv_patient.pmtct_exit_date=date_completed
	where voided=0 and program_id=8 and community_arv_patient.patient_id=patient_program.patient_id;

  /*ESTADO ACTUAL DO STATUS DMC*/
update community_arv_patient,
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
set 	community_arv_patient.current_status_in_DMC=saida.codeestado
/*community_arv_patient.patient_status_date=saida.start_date*/
where saida.patient_id=community_arv_patient.patient_id;

/*Clinical Stage*/
insert into community_arv_WHO_clinical_stage (patient_id, who_stage,who_stage_date)
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
  AND p.patient_id IN (SELECT patient_id FROM community_arv_patient)
  and o.concept_id=5356 and o.obs_datetime   BETWEEN startDate AND endDate;


/*LEVANTAMENTO AMC_ART*/
insert into community_art_pick_up(patient_id,pickup_art,encounter)
  select distinct p.patient_id, case o.value_coded 
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as pick_art, e.encounter_id
  from community_arv_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=52 and o.concept_id=23865  and e.voided=0 and o.encounter_id=e.encounter_id
  and p.patient_id=o.person_id and o.obs_datetime < endDate;


update community_art_pick_up,obs
set  community_art_pick_up.art_date=obs.value_datetime
where   community_art_pick_up.patient_id=obs.person_id and
    obs.concept_id=23866 and
    obs.voided=0 and community_art_pick_up.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/*Formulação FILA*/
insert into community_art_fila_drugs(patient_id,regime,formulation,pickup_date, group_id, encounter)
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
from  community_arv_patient p
inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id and concept_id in (1088,165256)
    inner join drug d on o.value_drug=d.drug_id
where   e.voided=0 and o.voided=0 and d.retired=0 and e.encounter_type=18 and o.concept_id in (1088,165256) 
and o.obs_datetime < endDate;

/*quantidade levantada*/
update community_art_fila_drugs,obs
set  community_art_fila_drugs.quantity=obs.value_numeric
where   community_art_fila_drugs.patient_id=obs.person_id and
    community_art_fila_drugs.pickup_date=obs.obs_datetime and 
    community_art_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1715 and
    obs.voided=0;

/*dosagem */
update community_art_fila_drugs,obs
set  community_art_fila_drugs.dosage=obs.value_text
where   community_art_fila_drugs.patient_id=obs.person_id and
    community_art_fila_drugs.pickup_date=obs.obs_datetime and
    community_art_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1711 and
    obs.voided=0;

/*proximo levantamento*/
update community_art_fila_drugs,obs
set  community_art_fila_drugs.next_art_date=obs.value_datetime
where   community_art_fila_drugs.patient_id=obs.person_id and
      obs.concept_id=5096 and
    obs.voided=0 and community_art_fila_drugs.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Campo de acomodação*/
UPDATE community_art_fila_drugs AS efd
JOIN obs AS obs_patient ON efd.patient_id = obs_patient.person_id
                         AND efd.pickup_date = obs_patient.obs_datetime
JOIN community_arv_patient AS p ON efd.patient_id = p.patient_id
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
UPDATE community_art_fila_drugs, obs,

(
    SELECT o.obs_id,
        CASE o.value_coded
            WHEN 23888 THEN 'SEMESTER ARV PICKUP (DS)'
            WHEN 165175 THEN 'NORMAL EXPEDIENT SCHEDULE'
            WHEN 165176 THEN 'HOURS EXTENSION (EH)' /*OUT OF TIME*/
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
        AND o.concept_id = 165174 AND e.encounter_type=18 and o.obs_datetime < endDate
) dis

SET community_art_fila_drugs.dispensation_model = dis.regime
WHERE community_art_fila_drugs.patient_id = obs.person_id
    AND community_art_fila_drugs.pickup_date = obs.obs_datetime
    AND obs.obs_id=dis.obs_id;



/*Weight*/
insert into community_arv_weight (patient_id,Weight,weight_date)
  select  p.patient_id,
o.value_numeric,
      encounter_datetime encounter_datetime
  from  patient p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) AND p.patient_id 	in (select patient_id from community_arv_patient)
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089 and o.obs_datetime   BETWEEN startDate AND endDate;

/*Height*/
insert into community_arv_height (patient_id, height, height_date)
select  p.patient_id as patient_id, o.value_numeric,
      encounter_datetime encounter_datetime
            from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  AND p.patient_id in (select patient_id from community_arv_patient) and o.obs_datetime   BETWEEN startDate AND endDate;

/*DMC CARGA VIRAL LABORATORIO*/

/*CARGA VIRAL*/
insert into community_arv_viral_load(patient_id,cv,cv_qualit,cv_comments,cv_date,source)
select valor.patient_id,valor.value_numeric,valor.value_cod,valor.comments,valor.obs_datetime,valor.encounter_type
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
    o.comments,
	  o.obs_datetime,
        case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 13 then 'Ficha Laboratorio'
    when 51 then 'FSR'
    else null end as encounter_type
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,13,51) and o.concept_id in (856,1305) and e.encounter_datetime < endDate
)  valor group by valor.patient_id,valor.obs_datetime; 


 /*CD4 absolute*/
insert into community_arv_cd4_absolute(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497  and o.obs_datetime   BETWEEN startDate AND endDate;

/*CD4 percentage*/
insert into community_arv_cd4_percentage(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=730   and o.obs_datetime   BETWEEN startDate AND endDate;

/*VISITAS*/
insert into community_arv_visit(patient_id,visit_date,source, encounter)
Select distinct p.patient_id,e.encounter_datetime, case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 53 then 'Ficha Resumo'
    when 35 then 'Ficha APSS e PP'
    else null end as encounter_type, e.encounter_id
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id 
where   e.voided=0 and e.encounter_type in (6,53,35) and e.encounter_datetime  < endDate;

/* PROXIMA VISITAS Clinica*/
update community_arv_visit,obs,encounter 
set  community_arv_visit.next_visit_date=obs.value_datetime
where   community_arv_visit.patient_id=obs.person_id and
    obs.concept_id=1410 and 
    encounter.encounter_type=6 and obs.voided=0 and community_arv_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/* PROXIMA VISITAS Apss*/
update community_arv_visit,obs,encounter
set  community_arv_visit.next_visit_date=obs.value_datetime
where   community_arv_visit.patient_id=obs.person_id and 
    obs.concept_id=6310 and 
    encounter.encounter_type=35 and obs.voided=0 and community_arv_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*DMC*/
insert into community_arv_posology(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

update community_arv_posology,obs,encounter 
set community_arv_posology.dmc_type= case obs.value_coded
             when 1098 then  'DM'
             when 23720 then 'DT'
             when 23888 then 'DS'
             else null end
where   community_arv_posology.patient_id=obs.person_id and
    community_arv_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=23739 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_arv_posology.visit_date=encounter.encounter_datetime;

update community_arv_posology,obs,encounter 
set community_arv_posology.posology= obs.value_text
where community_arv_posology.patient_id=obs.person_id and
    community_arv_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=1711 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_arv_posology.visit_date=encounter.encounter_datetime;


update community_arv_posology,obs,encounter 
set community_arv_posology.therapeutic_line= case obs.value_coded
      when 23741 then 'ALTERNATIVE 1st LINE OF THE ART'
      when 1371  then 'REGIMEN SWITCH'
      when 1066  then 'NO'
      else null  end
where community_arv_posology.patient_id=obs.person_id and
    community_arv_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=23742 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_arv_posology.visit_date=encounter.encounter_datetime;

/* ARV Dispensation*/
insert into community_type_arv_dispensation(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime
from  community_arv_patient p
    inner join encounter e on p.patient_id=e.patient_id
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;
update community_type_arv_dispensation,
    (
    select p.patient_id,e.encounter_datetime,case o.value_coded when 1098  then 'DM' when 23720 then 'DT' when 23888 then 'DS' else null end  as code from community_arv_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    where e.encounter_type=6 and e.voided=0 and o.voided=0 and o.concept_id=23739
    ) final
    set community_type_arv_dispensation.dispensation_type=final.code
    where community_type_arv_dispensation.patient_id=final.patient_id
-- 	and community_type_arv_dispensation.patient_id=community_arv_patient.patient_id
    and community_type_arv_dispensation.visit_date=final.encounter_datetime;

 /* community model*/  
   insert into community_differentiated_model(patient_id,visit_date,differentiated_model) 
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

    update community_differentiated_model,
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
    set community_differentiated_model.differentiated_model_status=final.status
    where community_differentiated_model.patient_id=final.patient_id
    and community_differentiated_model.visit_date=final.encounter_datetime;

/*DMC DISPENSATION VISIT GROUP*/
insert into community_support_groups_visit(patient_id,date_elegibbly_support_groups)
Select distinct p.patient_id,e.encounter_datetime 
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC SUPPORT GROUP*/
update community_support_groups_visit,obs,encounter 
set community_support_groups_visit.elegibbly_support_groups=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  community_support_groups_visit.patient_id=obs.person_id and obs.concept_id=23764 and obs.voided=0 and
        obs.obs_datetime=community_support_groups_visit.date_elegibbly_support_groups
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

/*TYPE SUPPORT GROUP CRIANCAS REVELADAS*/
update community_support_groups_visit,obs,encounter 
set  community_support_groups_visit.type_support_groups="CR", 
community_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_support_groups_visit.patient_id=obs.person_id and
    community_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23753 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

/*TYPE SUPPORT GROUP PAIS E CUIDADORES*/
update community_support_groups_visit,obs,encounter 
set  community_support_groups_visit.type_support_groups="PC",
community_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_support_groups_visit.patient_id=obs.person_id and
    community_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23755 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;
 
 /*TYPE SUPPORT GROUP ADOLESCENTES RV*/
update community_support_groups_visit,obs,encounter 
set  community_support_groups_visit.type_support_groups="AR",
community_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_support_groups_visit.patient_id=obs.person_id and
    community_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23757 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

 /*TYPE SUPPORT GROUP MAE PARA MAE*/
update community_support_groups_visit,obs,encounter 
set  community_support_groups_visit.type_support_groups="MPM",
community_support_groups_visit.value_support_groups= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_support_groups_visit.patient_id=obs.person_id and
    community_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23759 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;

          
/*PROXIMO OUTRO DE APOIO*/
update community_support_groups_visit,obs,encounter 
set  community_support_groups_visit.type_support_groups=obs.value_text
where   community_support_groups_visit.patient_id=obs.person_id and
    community_support_groups_visit.date_elegibbly_support_groups=obs.obs_datetime and 
    obs.concept_id=23772 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_support_groups_visit.date_elegibbly_support_groups=encounter.encounter_datetime;


/*DMC DISPENSATION VISIT*/
insert into community_dmc_type_of_dispensation_visit(patient_id,date_elegibbly_dmc) /*ask Eusebiu*/
Select distinct p.patient_id,e.encounter_datetime 
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set community_dmc_type_of_dispensation_visit.elegibbly_dmc=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and obs.concept_id=23765 and obs.voided=0 and
        obs.obs_datetime=community_dmc_type_of_dispensation_visit.date_elegibbly_dmc
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

/*PROXIMO GAAC*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="GAAC", 
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23724 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

    /*PROXIMO AF*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="AF",
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23725 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

        /*PROXIMO CA*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="CA",
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23726 and obs.voided=0
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

            /*PROXIMO PU*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="PU",
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and obs.concept_id=23727 and obs.voided=0 
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


            /*PROXIMO FR*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="FR",
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23729 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                /*PROXIMO DT*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="DT",
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23730 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                    /*PROXIMO DT*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="DC",
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23731 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


                    /*PROXIMO DS*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc="DS",
community_dmc_type_of_dispensation_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23888 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                        /*PROXIMO OUTRO*/
update community_dmc_type_of_dispensation_visit,obs,encounter 
set  community_dmc_type_of_dispensation_visit.type_dmc=obs.value_text
where   community_dmc_type_of_dispensation_visit.patient_id=obs.person_id and
    community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23732 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and community_dmc_type_of_dispensation_visit.date_elegibbly_dmc=encounter.encounter_datetime;


/*URBAN AND MAIN*/
update community_arv_patient set urban='N';
update community_arv_patient set main='N';
if district='Quelimane' then
  update community_arv_patient set urban='Y';
end if;
if district='Namacurra' then
  update community_arv_patient set main='Y' where location_id=5;
end if;
if district='Maganja' then
  update community_arv_patient set main='Y' where location_id=15;
end if;
if district='Pebane' then
  update community_arv_patient set main='Y' where location_id=16;
end if;
if district='Gile' then
  update community_arv_patient set main='Y' where location_id=6;
end if;
if district='Molocue' then
  update community_arv_patient set main='Y' where location_id=3;
end if;
if district='Mocubela' then
  update community_arv_patient set main='Y' where location_id=62;
end if;
if district='Inhassunge' then
  update community_arv_patient set main='Y' where location_id=7;
end if;
if district='Ile' then
  update community_arv_patient set main='Y' where location_id in (4,55);
end if;
if district='Namarroi' then
  update community_arv_patient set main='Y' where location_id in (252);
end if;
if district='Mopeia' then
  update community_arv_patient set main='Y' where location_id in (11);
end if;
if district='Morrumbala' then
  update community_arv_patient set main='Y' where location_id in (13);
end if;
if district='Gurue' then
  update community_arv_patient set main='Y' where location_id in (280);
end if;
if district='Mocuba' then
  update community_arv_patient set main='Y' where location_id in (227);
end if;
if district='Nicoadala' then
  update community_arv_patient set main='Y' where location_id in (277);
end if;
if district='Milange' then
  update community_arv_patient set main='Y' where location_id in (281);
end if;

end
;;
DELIMITER ;