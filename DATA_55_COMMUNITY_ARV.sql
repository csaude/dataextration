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
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
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

DROP TABLE IF EXISTS `community_arv_art_pick_up`;
CREATE TABLE IF NOT EXISTS `community_arv_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
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

DROP TABLE IF EXISTS `community_arv_cv`;
CREATE TABLE `community_arv_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `copies_cv` decimal(12,2) DEFAULT NULL,
  `logs_cv` decimal(12,2) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
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
CREATE TABLE `community_arv_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `next_visit_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `visit_date` (`visit_date`),
  KEY `next_visit_date` (`next_visit_date`)
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


DROP PROCEDURE IF EXISTS `FillCOMMARV`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillCOMMARV`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

TRUNCATE TABLE community_arv_WHO_clinical_stage;
TRUNCATE TABLE community_arv_art_pick_up;
TRUNCATE TABLE community_arv_weight;
TRUNCATE TABLE community_arv_height;
TRUNCATE TABLE community_arv_cv;
TRUNCATE TABLE community_arv_cd4_absolute;
TRUNCATE TABLE community_arv_cd4_percentage;
TRUNCATE TABLE community_arv_visit;
TRUNCATE TABLE community_arv_posology;

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
      preTarvFinal where preTarvFinal.initialDate BETWEEN startDate AND endDate
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

/*Exclusion criteria*/
delete from community_arv_patient where age_enrollment<3;

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
  and o.concept_id=5356;


/*LEVANTAMENTO AMC_ART*/
insert into community_arv_art_pick_up(patient_id,regime,art_date)
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
        
        else null end,
        encounter_datetime
  from community_arv_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; /*por confirmar*/


/*Weight*/
insert into community_arv_weight (patient_id,Weight,weight_date)
  select  p.patient_id,
o.value_numeric,
      encounter_datetime encounter_datetime
  from  patient p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) AND p.patient_id 	in (select patient_id from community_arv_patient)
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089;

/*Height*/
insert into community_arv_height (patient_id, height, height_date)
select  p.patient_id as patient_id, o.value_numeric,
      encounter_datetime encounter_datetime
            from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  AND p.patient_id in (select patient_id from community_arv_patient);


/*DMC CARGA VIRAL LABORATORIO*/
insert into community_arv_cv(patient_id,copies_cv,cv_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"LABORATORY"
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 
and o.concept_id=856 and o.obs_datetime < endDate;

/*DMC CARGA VIRAL SEGUIMENTO*/
insert into community_arv_cv(patient_id,copies_cv,cv_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"FOLLOW_UP"
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=9
and o.concept_id=1518 and  o.obs_datetime < endDate;

/*DMC CARGA VIRAL LOGS*/
update community_arv_cv,obs 
set  community_arv_cv.logs_cv=obs.value_numeric
where  community_arv_cv.patient_id=obs.person_id and
    community_arv_cv.cv_date=obs.obs_datetime and 
    obs.concept_id=1518 and 
    obs.voided=0;

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
insert into ccommunity_arv_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  community_arv_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*PROXIMA VISITAS*/
update ccommunity_arv_visit,obs 
set  ccommunity_arv_visit.next_visit_date=obs.value_datetime
where   ccommunity_arv_visit.patient_id=obs.person_id and
    ccommunity_arv_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;

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
Select distinct p.patient_id,e.encounter_datetime
from  community_arv_patient p
    inner join encounter e on p.patient_id=e.patient_id
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;
update community_type_arv_dispensation,
    (
    select p.patient_id,case o.value_coded when 1098  then 'DM' when 23720 then 'DT' when 23888 then 'DS' else null end  as code from patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    where e.encounter_type=6 and e.encounter_datetime BETWEEN startDate AND endDate and p.voided=0 and e.voided=0 and o.voided=0 and o.concept_id=23739
    ) final
    set community_type_arv_dispensation.dispensation_type=final.code
    where community_type_arv_dispensation.patient_id=final.patient_id;

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