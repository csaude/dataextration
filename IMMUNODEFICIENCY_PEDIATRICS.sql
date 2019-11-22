SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for immune_pediatric_patient
-- ----------------------------
DROP TABLE IF EXISTS `immune_pediatric_patient`;
CREATE TABLE `immune_pediatric_patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `source_of_referral`varchar(100) DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `first_absulute_cd4`  double DEFAULT NULL,
  `first_absulute_cd4_date` datetime DEFAULT NULL,
  `wbc`  double DEFAULT NULL,
  `absulute_lym`  double DEFAULT NULL,
  `percentege_lym`  double DEFAULT NULL,
  `first_percentege_cd4` double DEFAULT NULL,
  `first_percentege_cd4_date` datetime DEFAULT NULL,
  `first_viral_load_result` double DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(1) DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `age_of_mother` int(11) DEFAULT NULL,
  `age_of_fother` int(11) DEFAULT NULL,
  `mother_hiv_test_result`varchar(100) DEFAULT NULL,
  `fother_hiv_test_result`varchar(100) DEFAULT NULL,
  `mother_hiv_tratment`varchar(100) DEFAULT NULL,
  `fother_hiv_tratment`varchar(100) DEFAULT NULL,
  `mother_alive`varchar(100) DEFAULT NULL,
  `fother_alive`varchar(100) DEFAULT NULL,
  `mother_profession`varchar(100) DEFAULT NULL,
  `fother_profession`varchar(100) DEFAULT NULL,
  `perinatal_antiretroviral_exposure_from_mother`varchar(100) DEFAULT NULL,
  `perinatal_antiretroviral_exposure_from_child`varchar(100) DEFAULT NULL,
  `child_history_of_breastfeeding`varchar(100) DEFAULT NULL,
  `child_age_of_weaning_from_breastfeeding` int(11) DEFAULT NULL,
   PRIMARY KEY (`id`),
   KEY `immune_pediatric_patient_patient_id` (`patient_id`),
   KEY `immune_pediatric_patient_birth_date` (`birth_date`),
   KEY `immune_pediatric_patient_enrollment_date` (`enrollment_date`),
   KEY `immune_pediatric_patient_art_initiation_date` (`art_initiation_date`),
   KEY `immune_pediatric_patient_first_absulute_cd4_date` (`first_absulute_cd4_date`), 
   KEY `immune_pediatric_patient_first_percentege_cd4_date` (`first_percentege_cd4_date`),
   KEY `immune_pediatric_patient_first_viral_load_result_date` (`first_viral_load_result_date`),
   KEY `immune_pediatric_patient_weight_date` (`weight_date`),  
   KEY `immune_pediatric_patient_height_date` (`height_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;
-- ----------------------------
-- Table structure for cd4
-- ----------------------------
DROP TABLE IF EXISTS `immune_pediatric_cd4`;
CREATE TABLE `immune_pediatric_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `absulute_cd4` double DEFAULT NULL,
  `percentage_cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `immune_pediatric_cv`;
CREATE TABLE `immune_pediatric_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `copies_cv` decimal(12,2) DEFAULT NULL,
  `logs_cv` decimal(12,2) DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `immune_pediatric_art_pick_up`;
CREATE TABLE `immune_pediatric_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `art_date` (`art_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `immune_pediatric_wbc`;
CREATE TABLE `immune_pediatric_wbc` (
  `patient_id` int(11) DEFAULT NULL,
  `wbc`  double DEFAULT NULL,
  `wbc_date` datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `wbc_date` (`wbc_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `immune_pediatric_lym`;
CREATE TABLE `immune_pediatric_lym` (
  `patient_id` int(11) DEFAULT NULL,
  `absulute_lym` double DEFAULT NULL,
  `percentege_lym` double DEFAULT NULL,
  `lym_date` datetime DEFAULT NULL,
  `source`varchar(100) DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `lym_date` (`lym_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `immune_pediatric_visit`;
CREATE TABLE `immune_pediatric_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP PROCEDURE IF EXISTS `FillTIMMUNEPEDIATRICTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTIMMUNEPEDIATRICTable`(startDate date,endDate date,dataAvaliacao date, district varchar(100)) 

READS SQL DATA
begin

truncate table immune_pediatric_patient;

/*INSCRICAO*/
insert into immune_pediatric_patient(patient_id, enrollment_date,location_id)
SELECT e.patient_id,min(encounter_datetime) data_abertura, e.location_id
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,7)
     AND e.encounter_datetime   BETWEEN startDate  AND endDate
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id;

update immune_pediatric_patient,
(Select patient_id,min(data_inicio) data_inicio
    from
      ( 
        -- leva a primeira ocorrencia do conceito 1255: Gestão de TARV e que a resposta foi 1256: Inicio
        Select  p.patient_id,min(e.encounter_datetime) data_inicio
        from  patient p
            inner join encounter e on p.patient_id=e.patient_id
            inner join obs o on o.encounter_id=e.encounter_id
        where   e.voided=0 and o.voided=0 and p.voided=0 and
            e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and
            e.encounter_datetime<=endDate
        group by p.patient_id

        union
        
        -- leva a primeira ocorrencia do conceito 1190: Data de Inicio de TARV
        Select  p.patient_id,min(value_datetime) data_inicio
        from  patient p
            inner join encounter e on p.patient_id=e.patient_id
            inner join obs o on e.encounter_id=o.encounter_id
        where   p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and
            o.concept_id=1190 and o.value_datetime is not null and
            o.value_datetime<=endDate
        group by p.patient_id

        union

        -- leva a primeira ocorrencia da inscricao do paciente no programa de Tratamento ARV
        select  pg.patient_id,date_enrolled data_inicio
        from  patient p inner join patient_program pg on p.patient_id=pg.patient_id
        where   pg.voided=0 and p.voided=0 and program_id=2 and date_enrolled<=endDate

        union
        
        -- Leva a data do primeiro levantamento de ARV para cada paciente: Data do primeiro Fila do paciente
          SELECT  e.patient_id, MIN(e.encounter_datetime) AS data_inicio
          FROM    patient p
              inner join encounter e on p.patient_id=e.patient_id
          WHERE   p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=endDate
          GROUP BY  p.patient_id
      ) inicio_real
    group by patient_id
)inicio
set immune_pediatric_patient.art_initiation_date=inicio.data_inicio
where inicio.patient_id=immune_pediatric_patient.patient_id;

  /*UNIDADE SANITARIA*/
update immune_pediatric_patient,location
set immune_pediatric_patient.health_facility=location.name
where immune_pediatric_patient.location_id=location.location_id;

/*Sexo*/
update immune_pediatric_patient,person set immune_pediatric_patient.sex=.person.gender
where  person_id=immune_pediatric_patient.patient_id;

/*DATA DE NAICIMENTO*/
UPDATE immune_pediatric_patient,
       person
SET immune_pediatric_patient.birth_date=person.birthdate
WHERE immune_pediatric_patient.patient_id=person.person_id;

   /*IDADE NA INSCRICAO*/
update immune_pediatric_patient,person set immune_pediatric_patient.age_enrollment=round(datediff(immune_pediatric_patient.enrollment_date,person.birthdate)/365)
where  person_id=immune_pediatric_patient.patient_id;

delete from immune_pediatric_patient where age_enrollment >= 15;

/*UPDATE CODPROVENIENCIA*/
update immune_pediatric_patient,
    (select   
        p.patient_id,
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
    from  patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=1594 and e.encounter_type=7 and e.voided=0
    ) proveniencia
set immune_pediatric_patient.source_of_referral=proveniencia.codProv
where proveniencia.patient_id=immune_pediatric_patient.patient_id;


/*ESTADIO OMS */
update immune_pediatric_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=9 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set immune_pediatric_patient.WHO_clinical_stage_at_enrollment=stage.cod
where immune_pediatric_patient.patient_id=stage.patient_id 
and immune_pediatric_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


 /*PESO AT TIME OF ART ENROLLMENT*/
update immune_pediatric_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
   from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=3 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set immune_pediatric_patient.weight_enrollment=obs.value_numeric, immune_pediatric_patient.weight_date=peso.encounter_datetime
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=peso.patient_id 
and obs.voided=0 
and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update immune_pediatric_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=3 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set immune_pediatric_patient.height_enrollment=obs.value_numeric, immune_pediatric_patient.height_date=altura.encounter_datetime
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*IDADE DA MAE AT TIME OF ART ENROLLMENT*/
update immune_pediatric_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1478 
  group by p.patient_id
)idadeMae,obs
set immune_pediatric_patient.age_of_mother=obs.value_numeric
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=idadeMae.patient_id 
and obs.voided=0 and obs.obs_datetime=idadeMae.encounter_datetime
and obs.concept_id=1478;

/*IDADE DO PAI AT TIME OF ART ENROLLMENT*/
update immune_pediatric_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1486 
  group by p.patient_id
)idadePai,obs
set immune_pediatric_patient.age_of_fother=obs.value_numeric
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=idadePai.patient_id 
and obs.voided=0 and obs.obs_datetime=idadePai.encounter_datetime
and obs.concept_id=1486;

/*RESULTADO DO TESTE DE HIV DA MAE*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case  o.value_coded
            when 664  then  'NEGATIVE' 
            when 1138 then  'INDETERMINATE' 
            when 703  then  'POSITIVE' 
            when 1118 then  'NOT DONE'
            when 1457 then  'NO INFORMATION'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1483 
  group by p.patient_id
)resultadoHivMae,obs
set immune_pediatric_patient.mother_hiv_test_result=resultadoHivMae.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=resultadoHivMae.patient_id 
and obs.voided=0 and obs.obs_datetime=resultadoHivMae.encounter_datetime
and obs.concept_id=1483;

/*RESULTADO DO TESTE DE HIV DO PAI*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 664  then  'NEGATIVE' 
            when 1138 then  'INDETERMINATE' 
            when 703  then  'POSITIVE' 
            when 1118 then  'NOT DONE'
            when 1457 then  'NO INFORMATION'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1491 
  group by p.patient_id
)resultadoHivPai,obs
set immune_pediatric_patient.fother_hiv_test_result=resultadoHivPai.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=resultadoHivPai.patient_id 
and obs.voided=0 and obs.obs_datetime=resultadoHivPai.encounter_datetime
and obs.concept_id=1491;


/*MAE EM TRATAMENTO HIV*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 1457  then  'NO INFORMATION' 
            when 1066  then  'NO'
            when 1065  then  'YES'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1484 
  group by p.patient_id
)maeEmTratamentoARV,obs
set immune_pediatric_patient.mother_hiv_tratment=maeEmTratamentoARV.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=maeEmTratamentoARV.patient_id 
and obs.voided=0 and obs.obs_datetime=maeEmTratamentoARV.encounter_datetime
and obs.concept_id=1484;

/*PAI EM TRATAMENTO HIV*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 1457  then  'NO INFORMATION' 
            when 1066  then  'NO'
            when 1065  then  'YES'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1492 
  group by p.patient_id
)paiEmTratamentoARV,obs
set immune_pediatric_patient.fother_hiv_tratment=paiEmTratamentoARV.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=paiEmTratamentoARV.patient_id 
and obs.voided=0 and obs.obs_datetime=paiEmTratamentoARV.encounter_datetime
and obs.concept_id=1492;

/*MAE VIVA*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 1457  then  'NO INFORMATION' 
            when 1066  then  'NO'
            when 1065  then  'YES'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1479 
  group by p.patient_id
)maeViva,obs
set immune_pediatric_patient.mother_alive=maeViva.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=maeViva.patient_id 
and obs.voided=0 and obs.obs_datetime=maeViva.encounter_datetime
and obs.concept_id=1479;

/*PAI VIVO*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 1457  then  'NO INFORMATION' 
            when 1066  then  'NO'
            when 1065  then  'YES'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1487
  group by p.patient_id
)paiVivo,obs
set immune_pediatric_patient.fother_alive=paiVivo.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=paiVivo.patient_id 
and obs.voided=0 and obs.obs_datetime=paiVivo.encounter_datetime
and obs.concept_id=1487;

/*PROFISAO DA MAE*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1482
  group by p.patient_id
)profissaoMae,obs
set immune_pediatric_patient.mother_profession=obs.value_text
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=profissaoMae.patient_id 
and obs.voided=0 and obs.obs_datetime=profissaoMae.encounter_datetime
and obs.concept_id=1482;


/*PROFISAO DO PAI*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1490
  group by p.patient_id
)profissaoPai,obs
set immune_pediatric_patient.fother_profession=obs.value_text
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=profissaoPai.patient_id 
and obs.voided=0 and obs.obs_datetime=profissaoPai.encounter_datetime
and obs.concept_id=1490;


/*PERINATAL ANTIRETROVIRAL EXPOSURE FROM MOTHER*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 1457  then  'NO INFORMATION' 
            when 1066  then  'NO'
            when 1065  then  'YES'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1501
  group by p.patient_id
)perinitalMother,obs
set immune_pediatric_patient.perinatal_antiretroviral_exposure_from_mother=perinitalMother.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=perinitalMother.patient_id 
and obs.voided=0 and obs.obs_datetime=perinitalMother.encounter_datetime
and obs.concept_id=1501;

/*PERINATAL ANTIRETROVIRAL EXPOSURE FROM CHILD*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 1457  then  'NO INFORMATION' 
            when 1066  then  'NO'
            when 1065  then  'YES'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1502
  group by p.patient_id
)perinitalChild,obs
set immune_pediatric_patient.perinatal_antiretroviral_exposure_from_child=perinitalChild.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=perinitalChild.patient_id 
and obs.voided=0 and obs.obs_datetime=perinitalChild.encounter_datetime
and obs.concept_id=1502;

/*CHILD’S HISTORY OF BREASTFEEDING*/
update immune_pediatric_patient,
(select  p.patient_id as patient_id,min(encounter_datetime) encounter_datetime,
      case o.value_coded
            when 1066  then  'NO'
            when 1065  then  'YES'  
            else null end as cod
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=6061
  group by p.patient_id
)childBreastfeeding,obs
set immune_pediatric_patient.child_history_of_breastfeeding=childBreastfeeding.cod
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=childBreastfeeding.patient_id 
and obs.voided=0 and obs.obs_datetime=childBreastfeeding.encounter_datetime
and obs.concept_id=6061;

/*CHILD’S AGE OF WEANING FROM BREASTFEEDING*/
update immune_pediatric_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1515 
  group by p.patient_id
)idadeAleitamento,obs
set immune_pediatric_patient.child_age_of_weaning_from_breastfeeding=obs.value_numeric
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=idadeAleitamento.patient_id 
and obs.voided=0 and obs.obs_datetime=idadeAleitamento.encounter_datetime
and obs.concept_id=1515;


/*PRIMEIRO CD4 ABSULUTO*/
update immune_pediatric_patient,
( select  e.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where e.voided=0 and e.encounter_type=13 and 
      e.encounter_datetime between startDate and endDate and o.concept_id=5497
  group by p.patient_id
)cd4
set immune_pediatric_patient.first_absulute_cd4_date=cd4.encounter_datetime
where immune_pediatric_patient.patient_id=cd4.patient_id;

update  immune_pediatric_patient,obs 
set   immune_pediatric_patient.first_absulute_cd4=obs.value_numeric
where   immune_pediatric_patient.patient_id=obs.person_id 
and obs.obs_datetime=immune_pediatric_patient.first_absulute_cd4_date and obs.concept_id=5497 and obs.voided=0;

/*GLOBOLOS BRANCOS*/
update  immune_pediatric_patient,obs 
set   immune_pediatric_patient.wbc=obs.value_numeric
where   immune_pediatric_patient.patient_id=obs.person_id 
and obs.obs_datetime=immune_pediatric_patient.first_absulute_cd4_date and obs.concept_id=678 and obs.voided=0;

/*LINFOCITOS ABSULUTO (LYM)*/
update  immune_pediatric_patient,obs 
set   immune_pediatric_patient.absulute_lym=obs.value_numeric
where   immune_pediatric_patient.patient_id=obs.person_id 
and obs.obs_datetime=immune_pediatric_patient.first_absulute_cd4_date and obs.concept_id=952 and obs.voided=0;


/*LINFOCITOS PERCENTEGE (LYM)*/
update  immune_pediatric_patient,obs 
set   immune_pediatric_patient.percentege_lym=obs.value_numeric
where   immune_pediatric_patient.patient_id=obs.person_id 
and obs.obs_datetime=immune_pediatric_patient.first_absulute_cd4_date and obs.concept_id=1021 and obs.voided=0;


/*PRIMEIRO CD4 PERCENTUAL*/
update immune_pediatric_patient,
( select  e.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where e.voided=0 and e.encounter_type=13 and 
      e.encounter_datetime between startDate and endDate and o.concept_id=730
  group by p.patient_id
)seguimento
set immune_pediatric_patient.first_percentege_cd4_date=seguimento.encounter_datetime
where immune_pediatric_patient.patient_id=seguimento.patient_id;

update  immune_pediatric_patient,obs 
set   immune_pediatric_patient.first_percentege_cd4=obs.value_numeric
where   immune_pediatric_patient.patient_id=obs.person_id 
and obs.obs_datetime=immune_pediatric_patient.first_percentege_cd4_date and obs.concept_id=730 and obs.voided=0;

/*PRIMEIRA CARGA VIRAL*/
UPDATE immune_pediatric_patient,
  (SELECT p.patient_id,
          min(e.encounter_datetime) encounter_datetime
   FROM patient p
   INNER JOIN encounter e ON p.patient_id=e.patient_id
   INNER JOIN obs o ON o.encounter_id=e.encounter_id
   WHERE e.voided=0
     AND o.voided=0
     AND e.encounter_type=13
     AND o.concept_id=856
     AND e.encounter_datetime between startDate and endDate 
   GROUP BY p.patient_id 

) viral_load1, obs
SET immune_pediatric_patient.first_viral_load_result=obs.value_numeric,immune_pediatric_patient.first_viral_load_result_date=viral_load1.encounter_datetime
WHERE immune_pediatric_patient.patient_id=obs.person_id
  AND immune_pediatric_patient.patient_id=viral_load1.patient_id
  AND obs.voided=0
  AND obs.obs_datetime=viral_load1.encounter_datetime
  AND obs.concept_id=856;

/*CD4 LABORATORIO*/
insert into immune_pediatric_cd4(patient_id,absulute_cd4,cd4_date,source)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime,"LABORATORY"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and o.voided=0 and e.encounter_type=13
and   o.concept_id=5497 and o.obs_datetime < dataAvaliacao;

/*CD4 SUEGUIMENTO*/
insert into immune_pediatric_cd4(patient_id,absulute_cd4,cd4_date,source)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime,"FOLLOW_UP"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where e.voided=0 and o.voided=0 and e.encounter_type=9
and   o.concept_id=1695 and o.obs_datetime < dataAvaliacao;

/*CD4 PERCENTUAL*/
update immune_pediatric_cd4,obs 
set  immune_pediatric_cd4.percentage_cd4=obs.value_numeric
where  immune_pediatric_cd4.patient_id=obs.person_id and
    immune_pediatric_cd4.cd4_date=obs.obs_datetime and 
    obs.concept_id=730 and 
    obs.voided=0;

/*CARGA VIRAL LABORATORIO*/
insert into immune_pediatric_cv(patient_id,copies_cv,cv_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"LABORATORY"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 
and o.concept_id=856 and o.obs_datetime < dataAvaliacao;

/*CARGA VIRAL SEGUIMENTO*/
insert into immune_pediatric_cv(patient_id,copies_cv,cv_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"FOLLOW_UP"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=9
and o.concept_id=1518 and  o.obs_datetime < dataAvaliacao;

/*CARGA VIRAL LOGS*/
update immune_pediatric_cv,obs 
set  immune_pediatric_cv.logs_cv=obs.value_numeric
where  immune_pediatric_cv.patient_id=obs.person_id and
    immune_pediatric_cv.cv_date=obs.obs_datetime and 
    obs.concept_id=1518 and 
    obs.voided=0;


        /*LEVANTAMENTO ARV*/
insert into immune_pediatric_art_pick_up(patient_id,regime,art_date)
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
        when 6100 then 'AZT+3TC+LPV/r(2ª Linha)'
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
        else null end,
        encounter_datetime
  from  immune_pediatric_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime  and o.obs_datetime < dataAvaliacao;

/*PROXIMO LEVANTAMENTO*/
update immune_pediatric_art_pick_up,obs 
set  immune_pediatric_art_pick_up.next_art_date=obs.value_datetime
where   immune_pediatric_art_pick_up.patient_id=obs.person_id and
    immune_pediatric_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

  /*GLOBOLOS BRANCOS*/
insert into immune_pediatric_wbc(patient_id,wbc,wbc_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"LABORATORY"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13
and o.concept_id=678 and o.obs_datetime < dataAvaliacao;

  /*GLOBOLOS BRANCOS*/
insert into immune_pediatric_wbc(patient_id,wbc,wbc_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"FOLLOW_UP"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=9
and o.concept_id=678 and o.obs_datetime < dataAvaliacao;

  /*LINFOCITOS LABORATORY*/
insert into immune_pediatric_lym(patient_id,absulute_lym,lym_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"LABORATORY"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13
and o.concept_id=952 and o.obs_datetime < dataAvaliacao;

  /*LINFOCITOS FOLOW UP*/
insert into immune_pediatric_lym(patient_id,absulute_lym,lym_date,source)
Select distinct p.patient_id,o.value_numeric,o.obs_datetime,"FOLLOW_UP"
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=9
and o.concept_id=1691 and o.obs_datetime < dataAvaliacao;

/*LINFOCITOS PERCENTUAL*/
update immune_pediatric_lym,obs 
set  immune_pediatric_lym.percentege_lym=obs.value_numeric
where   immune_pediatric_lym.patient_id=obs.person_id and
    immune_pediatric_lym.lym_date=obs.obs_datetime and 
    obs.concept_id=1021 and 
    obs.voided=0;

    /*VISITAS*/
insert into immune_pediatric_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  immune_pediatric_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) ;

/* PROXIMA VISITAS*/
update immune_pediatric_visit,obs 
set  immune_pediatric_visit.next_visit_date=obs.value_datetime
where   immune_pediatric_visit.patient_id=obs.person_id and
    immune_pediatric_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;


update immune_pediatric_patient set urban='N';

update immune_pediatric_patient set main='N';

if district='Quelimane' then
  update immune_pediatric_patient set urban='Y'; 
end if;

if district='Namacurra' then
  update immune_pediatric_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update immune_pediatric_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update immune_pediatric_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update immune_pediatric_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update immune_pediatric_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update immune_pediatric_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update immune_pediatric_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update immune_pediatric_patient set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
  update immune_pediatric_patient set main='Y' where location_id in (252);
end if;


end
;;
DELIMITER ;
