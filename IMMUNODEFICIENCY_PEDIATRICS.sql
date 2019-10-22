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
  `cd4_first_visit` decimal(10,0) DEFAULT NULL,
  `cd4_first_visit_date` datetime DEFAULT NULL,
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
  `perinatal_antiretroviral_exposure_from_mother `varchar(100) DEFAULT NULL,
  `perinatal_antiretroviral_exposure_from_child`varchar(100) DEFAULT NULL,
  `child_history_of_breastfeeding`varchar(100) DEFAULT NULL,
  `child_age_of_weaning_from_breastfeeding` int(11) DEFAULT NULL,
   PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


DROP PROCEDURE IF EXISTS `FillTIMMUNEPEDIATRICTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTIMMUNEPEDIATRICTable`(startDate date,endDate date,dataAvaliacao date, district varchar(100)) 

READS SQL DATA
begin

truncate table immune_pediatric_patient;

/*INSCRICAO*/
insert into immune_pediatric_patient(patient_id, enrollment_date, location_id)
SELECT e.patient_id,min(encounter_datetime) data_abertura, e.location_id
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type =7
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
      min(encounter_datetime) encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=9 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage, obs
set immune_pediatric_patient.WHO_clinical_stage_at_enrollment=if(obs.value_coded=1204,'I',if(obs.value_coded=1205,'II',if(obs.value_coded=1206,'III','IV')))
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=stage.patient_id 
and obs.voided=0 and obs.obs_datetime=stage.encounter_datetime;

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
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
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
  where   e.voided=0 and e.encounter_type=7 and o.obs_datetime=e.encounter_datetime and o.concept_id=1483 
  group by p.patient_id
)resultadoHivMae,obs
set immune_pediatric_patient.mother_hiv_test_result=obs.value_coded
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
set immune_pediatric_patient.mother_hiv_test_result=obs.value_coded
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
set immune_pediatric_patient.mother_hiv_tratment=obs.value_coded
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
)maeEmTratamentoARV,obs
set immune_pediatric_patient.mother_hiv_tratment=obs.value_coded
where immune_pediatric_patient.patient_id=obs.person_id 
and immune_pediatric_patient.patient_id=maeEmTratamentoARV.patient_id 
and obs.voided=0 and obs.obs_datetime=maeEmTratamentoARV.encounter_datetime
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
set immune_pediatric_patient.mother_alive=obs.value_coded
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
set immune_pediatric_patient.fother_alive=obs.value_coded
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
set immune_pediatric_patient.perinatal_antiretroviral_exposure_from_mother=obs.value_coded
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
set immune_pediatric_patient.perinatal_antiretroviral_exposure_from_child=obs.value_coded
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
set immune_pediatric_patient.child_history_of_breastfeeding=obs.value_coded
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


/*PRIMEIRO CD4*/
update immune_pediatric_patient,
( select  e.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join openmrs.encounter e on p.id=e.patient_id
      inner join openmrs.obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=13 and 
      e.encounter_datetime between startDate and endDate and o.concept_id=5497
  group by p.id
)seguimento
set immune_pediatric_patient.cd4_first_visit=seguimento.encounter_datetime
where immune_pediatric_patient.patient=seguimento.patient_id;

update  immune_pediatric_patient,obs 
set   immune_pediatric_patient.cd4_first_visit=obs.value_numeric
where   immune_pediatric_patient.patient_id=obs.person_id and obs.obs_datetime=immune_pediatric_patient.cd4_first_visit and obs.concept_id=5497 and obs.voided=0;



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
