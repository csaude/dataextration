SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `ewh_patient`;
CREATE TABLE  `ewh_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `current_age` int(11) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `adress_1` varchar(100) DEFAULT null,
  `adress_2` varchar(100) DEFAULT null,
  `village` varchar(100) DEFAULT null,
  `art_initiation_date` datetime DEFAULT NULL,
  `last_clinic_visit` datetime DEFAULT NULL,
  `scheduled_clinic_visit` datetime DEFAULT NULL,
  `last_artpickup` datetime DEFAULT NULL,
  `scheduled_artpickp` datetime DEFAULT NULL,  
  `WHO_clinical_stage_at_enrollment` varchar(10) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `last_tb_at_screening` varchar(255) DEFAULT NULL,
  `last_tb_co_infection` varchar(255) DEFAULT NULL,
  `patient_status_1_months` varchar(225) DEFAULT NULL,
  `patient_status_1_months_date_` datetime DEFAULT NULL,
  `patient_status_3_months` varchar(225) DEFAULT NULL,
  `patient_status_3_months_date_` datetime DEFAULT NULL,
  `patient_status_6_months` varchar(225) DEFAULT NULL,
  `patient_status_6_months_date_` datetime DEFAULT NULL,
  `patient_status_12_months` varchar(225) DEFAULT NULL,
  `patient_status_12_months_date_` datetime DEFAULT NULL,
  `patient_status_24_months` varchar(225) DEFAULT NULL,
  `patient_status_24_months_date_` datetime DEFAULT NULL,
  `last_clinic_visit` datetime DEFAULT NULL,
  `scheduled_clinic_visit` datetime DEFAULT NULL,
  `last_artpickup` datetime DEFAULT NULL,
  `scheduled_artpickp` datetime DEFAULT NULL,  
  `regime_CTZ` varchar(255) DEFAULT NULL,
  `CTZ_prescribe` datetime DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL, 
  `imc_`    double DEFAULT NULL,
  `imc_date` datetime DEFAULT NULL,
  `hemoglobin` int(11)  DEFAULT NULL,
  `blood_pressure` varchar(255) DEFAULT NULL,
  `hemoglobin_date` datetime DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_enrollment_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_enrollment_date` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`),
  KEY `height_enrollment_date` (`height_enrollment_date`),
  KEY `weight_date` (`weight_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_patient_model`;
CREATE TABLE `ewh_patient_model` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `differentiated_model` varchar(100) DEFAULT NULL,
  `differentiated_model_status` varchar(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ewh_pharmacy_cd4_absolute`;
CREATE TABLE `ewh_pharmacy_cd4_absolute` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ewh_pharmacy_cd4_percentage`;
CREATE TABLE `ewh_pharmacy_cd4_percentage` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ewh_pharmacy_viral_load`;
CREATE TABLE `ewh_pharmacy_viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` double DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_hops_tb_investigation`;
CREATE TABLE `ewh_hops_tb_investigation` (
  `patient_id` int(11) DEFAULT NULL,
  `tb` varchar(255) DEFAULT NULL,
  `tb_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_hops_start_tb_treatment`;
CREATE TABLE `ewh_hops_start_tb_treatment` (
  `patient_id` int(11) DEFAULT NULL,
  `start_tb_treatment` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT 'Ficha Clinica',
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_hops_end_tb_treatment`;
CREATE TABLE `ewh_hops_end_tb_treatment` (
  `patient_id` int(11) DEFAULT NULL,
  `end_tb_treatment` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT 'Ficha Clinica',
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_community_arv_weight`;
CREATE TABLE `ewh_community_arv_weight` (
  `patient_id` int(11) DEFAULT NULL,
  `weight`  varchar(10) DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT 'Ficha Clinica',
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ewh_community_arv_height`;
CREATE TABLE `ewh_community_arv_height` (
  `patient_id` int(11) DEFAULT NULL,
  `height`  varchar(10) DEFAULT NULL,
  `height_enrollment_date` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT 'Ficha Clinica',
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ewh_imc`;
CREATE TABLE `ewh_imc` (
  `patient_id` int(11) DEFAULT NULL,
  `imc`  varchar(10) DEFAULT NULL,
  `imd_date` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT 'Ficha Clinica',
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ewh_hops_hemoglobin`;
CREATE TABLE `ewh_hops_hemoglobin` (
  `patient_id` int(11) DEFAULT NULL,
  `hemoglobin_value` varchar(100)  DEFAULT NULL,
  `hemoglobin_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ewh_hops_blood_pressure`;
CREATE TABLE `ewh_hops_blood_pressure` (
  `patient_id` int(11) DEFAULT NULL,
  `blood_pressure_value` varchar(100)  DEFAULT NULL,
  `blood_pressure_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_hops_visit`;
CREATE TABLE IF NOT EXISTS `ewh_hops_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT 'Ficha Clinica',
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_art_pick_up`;
CREATE TABLE IF NOT EXISTS `ewh_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `pickup_art` varchar(5) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
  `source` varchar(100) DEFAULT 'Registo de Levantamento de ARVs Master Card'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ewh_fila_drugs`;
CREATE TABLE `ewh_fila_drugs` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(300) DEFAULT NULL,
  `formulation` varchar(300) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `dosage` varchar(300) DEFAULT NULL,
  `pickup_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
  `accommodation_camp` char(3) DEFAULT NULL,
  `dispensation_model` char(3) DEFAULT NULL,
  `source` varchar(100) DEFAULT 'FILA'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


  DROP TABLE IF EXISTS `ewh_community_arv_posology`;
CREATE TABLE `ewh_community_arv_posology` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `dmc_type` varchar(100) DEFAULT NULL,
  `therapeutic_line` varchar(100) DEFAULT NULL,
  `posology` varchar(100) DEFAULT NULL,
  `regime` varchar(100) DEFAULT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Procedure structure for Fillewh
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillEWH`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillEWH`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

truncate table ewh_patient_model;
truncate table ewh_pharmacy_cd4_absolute;
truncate table ewh_pharmacy_cd4_percentage;
truncate table ewh_pharmacy_viral_load;
truncate table ewh_hops_tb_investigation;
truncate table ewh_hops_start_tb_treatment;
truncate table ewh_hops_end_tb_treatment;
truncate table ewh_community_arv_weight;
truncate table ewh_community_arv_height;
truncate table ewh_imc;
truncate table ewh_hops_hemoglobin;
truncate table ewh_hops_blood_pressure;
truncate table ewh_hops_visit;
truncate table ewh_art_pick_up;
truncate table ewh_fila_drugs;
truncate table ewh_community_arv_posology;


SET @location:=location_id_parameter;

/*INSCRICAO*/
insert into ewh_patient(patient_id, enrollment_date, location_id)
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


/*distrito*/
Update ewh_patient set ewh_patient.district=district;

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE ewh_patient,
       patient_identifier
SET ewh_patient.patient_id=patient_identifier.patient_id, ewh_patient.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=ewh_patient.nid;

/*Local*/
update ewh_patient,location
set ewh_patient.health_facility=location.name
where ewh_patient.location_id=location.location_id;

/*Apagar todos fora desta localização*/
delete from ewh_patient where location_id not in (@location);

  /*Sexo*/
update ewh_patient,person set ewh_patient.sex=.person.gender
where  person.person_id=ewh_patient.patient_id;

/*DATA DE NASCIMENTO*/
UPDATE ewh_patient,
       person
SET ewh_patient.date_of_birth=person.birthdate
WHERE ewh_patient.patient_id=person.person_id;

/*IDADE ACTUAL*/
update ewh_patient,person set ewh_patient.current_age=timestampdiff(year,person.birthdate,endDate) where
person_id=ewh_patient.patient_id;

/*IDADE NA INSCRICAO*/
update ewh_patient,person set ewh_patient.age_enrollment=round(datediff(ewh_patient.enrollment_date,person.birthdate)/365)
where  person_id=ewh_patient.patient_id;

/*PROFISSAO*/
update ewh_patient,obs
set ewh_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=ewh_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO CIVIL*/
update ewh_patient,obs
set ewh_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=ewh_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

*Adress1*/
update ewh_patient,person_address set ewh_patient.adress_1=person_address.address1
where person_id=ewh_patient.patient_id;

/*Adress2*/
update ewh_patient,person_address set ewh_patient.adress_2=person_address.address2
where person_id=ewh_patient.patient_id;

/*last_city_village*/
update ewh_patient,person_address set ewh_patient.village=person_address.city_village
where person_id=ewh_patient.patient_id;


/*INICIO TARV*/
UPDATE ewh_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM ewh_patient p
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
      FROM ewh_patient p
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
      FROM ewh_patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM ewh_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET ewh_patient.art_initiation_date=inicio_real.data_inicio
WHERE ewh_patient.patient_id=inicio_real.patient_id;




/*ESTADIO OMS AT ENROLLMENT*/
update ewh_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from ewh_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set ewh_patient.WHO_clinical_stage_at_enrollment=stage.cod,
ewh_patient.WHO_clinical_stage_at_enrollment_date=stage.encounter_datetime
where ewh_patient.patient_id=stage.patient_id 
and ewh_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/*TB */
update ewh_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  ewh_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id in(6257,23758)
  group by p.patient_id
)tb, obs
set ewh_patient.last_tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where ewh_patient.patient_id=obs.person_id 
and ewh_patient.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id in(6257,23758) ;

/*TB DIAGNOSTIC*/   
update ewh_patient,
    (select p.patient_id,
         e.encounter_datetime,
        case o.value_coded
        when 664 then 'NEGATIVE'
        when 703 then 'POSITIVE'
        when 1065 then 'YES'
        when 1066 then 'NO'
        else null end as cod
    from  ewh_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id in (6277,23761) and e.encounter_type in (6,9) and e.voided=0 
    ) tb
set ewh_patient.last_tb_co_infection= tb.cod
where tb.patient_id=ewh_patient.patient_id;

 /*ESTADO ACTUAL TARV 1MESES*/
update ewh_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  ewh_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 1 MONTH)
    ) out_state
set   ewh_patient.patient_status_1_months=out_state.codeestado, ewh_patient.patient_status_1_months_date_=out_state.start_date
where ewh_patient.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 3 MESES*/
update ewh_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  ewh_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 3 MONTH)
    ) out_state
set   ewh_patient.patient_status_3_months=out_state.codeestado, ewh_patient.patient_status_3_months_date_=out_state.start_date
where ewh_patient.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 6 MESES*/
update ewh_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  ewh_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 6 MONTH)
    ) out_state
set   ewh_patient.patient_status_6_months=out_state.codeestado, ewh_patient.patient_status_6_months_date_=out_state.start_date
where ewh_patient.patient_id=out_state.patient_id;


/*ESTADO ACTUAL TARV 12 MESES*/
update ewh_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  ewh_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 12 MONTH)
    ) out_state
set   ewh_patient.patient_status_12_months=out_state.codeestado, ewh_patient.patient_status_12_months_date_=out_state.start_date
where ewh_patient.patient_id=out_state.patient_id;

/*ESTADO ACTUAL TARV 24 MESES*/
update ewh_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  ewh_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 24 MONTH)
    ) out_state
set   ewh_patient.patient_status_24_months=out_state.codeestado, ewh_patient.patient_status_24_months_date_=out_state.start_date
where ewh_patient.patient_id=out_state.patient_id;

/*LAST CLINIC VISIT*/
update ewh_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  ewh_patient p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type=6 and e.encounter_datetime < endDate
  group by p.patient_id
)seguimento
set ewh_patient.last_clinic_visit=seguimento.encounter_datetime
where ewh_patient.patient_id=seguimento.patient_id;

/*NEXT CLINIC VISIT*/
update  ewh_patient,obs,encounter
set   scheduled_clinic_visit=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_clinic_visit and encounter_type=6 and
    concept_id=5096 and voided=0;

    /*LAST ART PICKUP*/
update ewh_patient,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  ewh_patient p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type=6 and e.encounter_datetime < endDate
  group by p.patient_id
)levantamento
set ewh_patient.last_artpickup=levantamento.encounter_datetime
where ewh_patient.patient_id=levantamento.patient_id;

update  ewh_patient,obs,encounter
set   scheduled_artpickp=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_artpickup and 
    concept_id=5096  and encounter_type=6 and voided=0;

/*PRIMEIRA CARGA VIRAL*/
UPDATE ewh_patient,

  (SELECT p.patient_id,
          min(e.encounter_datetime) encounter_datetime
   FROM patient p
   INNER JOIN encounter e ON p.patient_id=e.patient_id
   INNER JOIN obs o ON o.encounter_id=e.encounter_id
   WHERE e.voided=0
     AND o.voided=0
     AND e.encounter_type =6
     AND o.concept_id=856
   GROUP BY p.patient_id ) viral_load1,
       obs
SET ewh_patient.first_viral_load_result=obs.value_numeric,ewh_patient.first_viral_load_result_date=viral_load1.encounter_datetime
WHERE ewh_patient.patient_id=obs.person_id
  AND ewh_patient.patient_id=viral_load1.patient_id
  AND obs.voided=0
  AND obs.obs_datetime=viral_load1.encounter_datetime
  AND obs.concept_id=856;


/*Regime CTZ*/
update ewh_patient,obs,encounter
set ewh_patient.regime_CTZ= case obs.value_coded 
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end        
where obs.person_id=ewh_patient.patient_id and obs.concept_id=6121 and obs.voided=0 and encounter.encounter_type=6
and obs.encounter_id=encounter.encounter_id and
encounter.encounter_datetime  between startDate and endDate;

/*Regime CTZ prescribe*/
update ewh_patient,obs,encounter
set ewh_patient.CTZ_prescribe=obs.obs_datetime
where obs.person_id=ewh_patient.patient_id and obs.concept_id=6121 and obs.voided=0 and encounter.encounter_type=6
and obs.encounter_id=encounter.encounter_id and
encounter.encounter_datetime  between startDate and endDate;


/*dmc ellegible*/
update ewh_patient,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23765 
    group by p.patient_id ) firsDMC  
set ewh_patient.elegibbly_dmc=firsDMC.code, ewh_patient.date_elegibbly_dmc=firsDMC.dataDMC
where firsDMC.patient_id=ewh_patient.patient_id;

/*ESTADO ACTUAL DO STATUS DMC*/
update ewh_patient,
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
set 	ewh_patient.current_status_in_DMC=saida.codeestado
/*ewh_patient.patient_status_date=saida.start_date*/
where saida.patient_id=ewh_patient.patient_id;




/* community model*/  
   insert into ewh_patient_model(patient_id,visit_date,differentiated_model,source) 
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
    else null end  as code,
    case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 53 then 'Ficha Resumo'
    else outro end as fonte
    from obs o
    inner join encounter e on e.encounter_id=o.encounter_id
        where e.voided=0 and o.voided=0
    and o.concept_id=165174 and e.encounter_type in (6,53)
    and e.encounter_datetime BETWEEN startDate AND endDate
        and person_id IN (select patient_id from ewh_patient);

    update ewh_patient_model,
    (
    select p.patient_id,e.encounter_datetime,
    case obsEstado.value_coded
    when 1256  then 'START DRUGS'
    when 1257  then 'CONTINUE REGIMEN'
    when 1267  then 'COMPLETED' else null end  status
    from ewh_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    inner join obs obsEstado on obsEstado.encounter_id=e.encounter_id
    where e.encounter_type in (6,9,18) and e.voided=0 and o.voided=0
    and o.concept_id=165174  and obsEstado.concept_id=165322 and obsEstado.voided=0
    ) final
    set ewh_patient_model.differentiated_model_status=final.status
    where ewh_patient_model.patient_id=final.patient_id
    and ewh_patient_model.visit_date=final.encounter_datetime;

     /*CD4 absolute*/
insert into ewh_pharmacy_cd4_absolute(patient_id,cd4,cd4_date, source)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime, case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 13 then 'Ficha Laboratorio'
    else null end as fonte
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,13) and o.concept_id=5497  and o.obs_datetime BETWEEN startDate AND endDate;

/*CD4 percentage*/
insert into ewh_pharmacy_cd4_percentage(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime, case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 13 then 'Ficha Laboratorio'
    else null end as fonte
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,13) and o.concept_id=730   and o.obs_datetime BETWEEN startDate AND endDate;


/*CARGA VIRAL*/
insert into ewh_pharmacy_viral_load(patient_id,cv,cv_qualit,cv_comments,cv_date,source)
select valor.patient_id,valor.value_numeric,valor.value_cod,valor.comments,valor.obs_datetime,valor.source
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
    e.encounter_id,
    case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 13 then 'Ficha Laboratorio'
    when 51 then 'FSR'
    else null end as fonte
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,13,51) and o.concept_id in (856,1305) and e.encounter_datetime  between startDate and endDate
)  valor group by valor.patient_id,valor.value_numeric,valor.encounter_id; 








/*LEVANTAMENTO AMC_ART*/
insert into ewh_art_pick_up(patient_id,pickup_art,art_date)
  select distinct p.patient_id, case o.value_coded 
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as pick_art, e.encounter_datetime, 
  from ewh_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=52 and o.concept_id=23865  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime BETWEEN startDate AND endDate;

update ewh_art_pick_up,obs
set  ewh_art_pick_up.next_art_date=obs.value_datetime
where   ewh_art_pick_up.patient_id=obs.person_id and
    ewh_art_pick_up.art_date=obs.obs_datetime and
    obs.concept_id=5096 and
    obs.voided=0;


/*TB*/
insert into ewh_hops_tb_investigation(patient_id,tb,tb_date)
Select distinct p.patient_id,
    case o.value_coded
             when 703 then 'POSITIVE'
             when 664 then 'NEGATIVE'
             else null end,
      o.obs_datetime
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=6 and o.concept_id=6277 and e.encounter_datetime  < endDate;

/*TB start Date*/
insert into ewh_hops_start_tb_treatment(patient_id,start_tb_treatment)
Select distinct p.patient_id, min(encounter_datetime) encounter_datetime
from  ewh_patient p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=1113 and o.voided=0 and e.encounter_datetime  < endDate
  group by p.patient_id;


  /*TB end Date*/
insert into ewh_hops_end_tb_treatment(patient_id,end_tb_treatment)
Select distinct p.patient_id, max(encounter_datetime) encounter_datetime
from  ewh_patient p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=6120 and e.encounter_datetime  < endDate
  group by p.patient_id;


/*Weight*/
insert into ewh_community_arv_weight (patient_id,Weight,weight_date)
  select  p.patient_id,
o.value_numeric,
      encounter_datetime encounter_datetime
  from  patient p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 AND p.patient_id 	in (select patient_id from ewh_patient)
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089 and o.obs_datetime   BETWEEN startDate AND endDate;

/*Height*/
insert into ewh_community_arv_height (patient_id, height, height_enrollment_date)
select  p.patient_id as patient_id, o.value_numeric,
      encounter_datetime encounter_datetime
            from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_typ=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  AND p.patient_id in (select patient_id from ewh_patient) and o.obs_datetime   BETWEEN startDate AND endDate;

/* Body mass index*/
 insert into ewh_imc (patient_id, imc, imc_date)
select  p.patient_id as patient_id, o.value_numeric,
      encounter_datetime encounter_datetime
            from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_typ=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=1342 
  AND p.patient_id in (select patient_id from ewh_patient) and o.obs_datetime   BETWEEN startDate AND endDate;


/*HEMOGLOBINA SEGUIMENTO */
update ewh_patient,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime  and e.encounter_datetime between startDate and endDate
      and o.concept_id=1692 
  group by p.patient_id
)hemoglobin,obs 
set  ewh_patient.hemoglobin=obs.value_numeric, ewh_patient.hemoglobin_date=hemoglobin.encounter_datetime
where ewh_patient.patient_id=obs.person_id 
and ewh_patient.patient_id=hemoglobin.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin.encounter_datetime  and obs.concept_id=1692;

/*BLOOD PRESSURE AT FIRST ANC VISIT*/
update ewh_patient,
(Select cpn.patient_id, cpn.data_cpn, case obs.value_coded 
when 1065 then 'YES'
when 1066 then 'NO' 
when 1118 then 'NOT DONE'  
else null end as cod
  from
  ( Select  p.patient_id,min(e.encounter_datetime) data_cpn
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
    where   p.voided=0 and e.voided=0 and e.encounter_type in (11)
    group by p.patient_id
  ) cpn
  inner join obs on obs.person_id=cpn.patient_id and obs.obs_datetime=cpn.data_cpn
  where   obs.voided=0 and obs.concept_id=6379 
)updateBP
set ewh_patient.blood_pressure=updateBP.cod
where ewh_patient.patient_id=updateBP.patient_id;
  
/* All hemoglobin*/
insert into ewh_hops_hemoglobin(patient_id,hemoglobin_value,hemoglobin_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and e.encounter_type in (6,13) and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id=1692
GROUP BY p.patient_id;

/* All Blood Pressure*/
insert into ewh_hops_blood_pressure(patient_id,blood_pressure_value,blood_pressure_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and e.encounter_datetime BETWEEN startDate AND endDate and o.concept_id in (5086,5085)
GROUP BY p.patient_id;






/*VISITAS*/
insert into ewh_hops_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type=6 and e.encounter_datetime  < endDate;

/* PROXIMA VISITAS*/
update ewh_hops_visit,obs 
set  ewh_hops_visit.next_visit_date=obs.value_datetime
where   ewh_hops_visit.patient_id=obs.person_id and
    ewh_hops_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and  and e.encounter_type=6
    obs.voided=0;
/*Peso*/
update ewh_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089 and e.encounter_datetime between startDate and endDate
  group by p.patient_id
)peso,obs
set ewh_patient.weight_enrollment=obs.value_numeric, ewh_patient.weight_enrollment_date=peso.encounter_datetime
where ewh_patient.patient_id=obs.person_id 
and ewh_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*Altura*/
update ewh_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 and e.encounter_datetime between startDate and endDate
  group by p.patient_id
)altura,obs
set ewh_patient.height_enrollment=obs.value_numeric, ewh_patient.height_enrollment_date=altura.encounter_datetime
where ewh_patient.patient_id=obs.person_id 
and ewh_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;



/*Formulação FILA*/
insert into ewh_fila_drugs(patient_id,regime,formulation,pickup_date, group_id)
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
   encounter_datetime, obs_group_id
from  ewh_patient p
inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_idconcept_id in (1088,165256)
    inner join drug d on o.value_drug=d.drug_id
where   e.voided=0 and o.voided=0 and d.retired=0 and e.encounter_type=18 and o.concept_id in (1088,165256) and o.obs_datetime BETWEEN startDate AND endDate;

/*quantidade levantada*/
update ewh_fila_drugs,obs
set  ewh_fila_drugs.quantity=obs.value_numeric
where   ewh_fila_drugs.patient_id=obs.person_id and
    ewh_fila_drugs.pickup_date=obs.obs_datetime and 
    ewh_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1715 and
    obs.voided=0;

/*dosagem */
update ewh_fila_drugs,obs
set  ewh_fila_drugs.dosage=obs.value_text
where   ewh_fila_drugs.patient_id=obs.person_id and
    ewh_fila_drugs.pickup_date=obs.obs_datetime and
    ewh_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1711 and
    obs.voided=0;

/*proximo levantamento*/
update ewh_fila_drugs,obs
set  ewh_fila_drugs.next_art_date=obs.value_datetime
where   ewh_fila_drugs.patient_id=obs.person_id and
      obs.concept_id=5096 and
    obs.voided=0;

/*Campo de acomodação*/
    update ewh_fila_drugs,obs
    ( select p.patient_id,e.encounter_datetime,
    case obsEstado.value_coded
    when 1065  then 'YES'
    when 1066  then 'NO'
    else null end  status
    from ewh_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    inner join obs obsEstado on obsEstado.encounter_id=e.encounter_id
    where e.encounter_type=18 and e.voided=0 and o.voided=0
    and o.concept_id=23856) accommodation
set  ewh_fila_drugs.accommodation_camp=accommodation.value_coded
where   ewh_fila_drugs.patient_id=accommodation.person_id and
    ewh_fila_drugs.pickup_date=accommodation.obs_datetime;

/*tipo de dispensa na FILA*/
 update ewh_fila_drugs,obs
( select
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
    and o.concept_id=165174) model
set  ewh_fila_drugs.dispensation_model=model.value_coded
where   ewh_fila_drugs.patient_id=model.person_id and
    ewh_fila_drugs.pickup_date=model.obs_datetime;



/*DMC*/
insert into ewh_community_arv_posology(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  ewh_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

update ewh_community_arv_posology,obs,encounter 
set ewh_community_arv_posology.dmc_type= case obs.value_coded
             when 1098 then  'DM'
             when 23720 then 'DT'
             when 23888 then 'DS'
             else null end
where   ewh_community_arv_posology.patient_id=obs.person_id and
    ewh_community_arv_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=23739 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and ewh_community_arv_posology.visit_date=encounter.encounter_datetime;

update ewh_community_arv_posology,obs,encounter 
set ewh_community_arv_posology.posology= obs.value_text
where ewh_community_arv_posology.patient_id=obs.person_id and
    ewh_community_arv_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=1711 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and ewh_community_arv_posology.visit_date=encounter.encounter_datetime;


update ewh_community_arv_posology,obs,encounter 
set ewh_community_arv_posology.therapeutic_line= case obs.value_coded
      when 23741 then 'ALTERNATIVE 1st LINE OF THE ART'
      when 1371  then 'REGIMEN SWITCH'
      when 1066  then 'NO'
      else null  end
where ewh_community_arv_posology.patient_id=obs.person_id and
    ewh_community_arv_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=23742 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and ewh_community_arv_posology.visit_date=encounter.encounter_datetime;


update ewh_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=1342 and e.encounter_datetime between startDate and endDate
  group by p.patient_id
)imc,obs
set ewh_patient.imc=obs.value_numeric, ewh_patient.imc_date=imc.encounter_datetime
where ewh_patient.patient_id=obs.person_id 
and ewh_patient.patient_id=imc.patient_id 
and obs.voided=0 and obs.obs_datetime=imc.encounter_datetime;

/*Regime posologia*/
update ewh_community_arv_posology,obs,encounter 
set ewh_community_arv_posology.regime= case  o.value_coded     
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
        else null end
        where ewh_community_arv_posology.patient_id=obs.person_id and
    ewh_community_arv_posology.visit_date=obs.obs_datetime and 
    obs.concept_id=1087 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type=6 and ewh_community_arv_posology.visit_date=encounter.encounter_datetime;

   

/* Urban and Main*/
update ewh_patient set urban='N';

update ewh_patient set main='N';

if district='Quelimane' then
  update ewh_patient set urban='Y'; 
end if;

if district='Namacurra' then
  update ewh_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update ewh_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update ewh_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update ewh_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update ewh_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update ewh_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update ewh_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update ewh_patient set main='Y' where location_id in (4,55); 
end if;

end
;;
DELIMITER ;