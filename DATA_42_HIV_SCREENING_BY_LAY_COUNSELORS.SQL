SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `lay_counsolers_patient`;
CREATE TABLE  `lay_counsolers_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `hiv_entry_point` varchar(100) DEFAULT NULL,
  `date_hiv_entry_point` datetime DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status_at_enrollment` varchar(100) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `partner_status_at_enrollment` varchar(100) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(1) DEFAULT NULL,
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `date_of_ART_initiation` datetime DEFAULT NULL,
  `tb_co_infection` varchar(255) DEFAULT NULL,
  `tb_at_screening` varchar(255) DEFAULT NULL,
  `prophylaxis_isoniazide` varchar(100) DEFAULT NULL,
  `prophylaxis_isoniazide_date` datetime DEFAULT NULL,
  `enrolled_in_GAAC` varchar(100) DEFAULT NULL,
  `gaac_start_date`datetime DEFAULT NULL,
  `gaac_end_date` datetime DEFAULT NULL,
  `gaac_identifier` varchar(225) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `enrollment_date` (`enrollment_date`),
  KEY `date_of_birth` (`date_of_birth`),
  KEY `date_of_ART_initiation` (`date_of_ART_initiation`),
  KEY `gaac_start_date` (`gaac_start_date`),
  KEY `gaac_end_date` (`gaac_end_date`),
  KEY `height_date` (`height_date`),
  KEY `weight_date` (`weight_date`),
  KEY `prophylaxis_isoniazide_date` (`prophylaxis_isoniazide_date`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `lay_counsolers_cv`;
CREATE TABLE `lay_counsolers_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `lay_counsolers_cd4_absulute`;
CREATE TABLE `lay_counsolers_cd4_absulute` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `lay_counsolers_cd4_percentage`;
CREATE TABLE `lay_counsolers_cd4_percentage` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `lay_counsolers_art_pick_up`;
CREATE TABLE `lay_counsolers_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `lay_counsolers_visit`;
CREATE TABLE `lay_counsolers_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `next_visit_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `lay_counsolers_dmc_visit`;
CREATE TABLE `lay_counsolers_dmc_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `type_dmc` varchar(100) DEFAULT NULL,
  `value_dmc` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP PROCEDURE IF EXISTS `FillLayConsolers`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillLayConsolers`(startDate date,endDate date, district varchar(100),location int(11))
    READS SQL DATA
begin

/*INSCRICAO*/
insert into lay_counsolers_patient(patient_id, enrollment_date,location_id)
       
        SELECT preTarvFinal.patient_id,preTarvFinal.initialDate,preTarvFinal.location FROM
         
         (   
             
             SELECT preTarv.patient_id, MIN(preTarv.initialDate) initialDate,preTarv.location as location FROM 
             ( 
             SELECT p.patient_id,min(o.value_datetime) AS initialDate,e.location_id as location FROM patient p  
             
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type=53 
             AND e.location_id=location  AND o.value_datetime IS NOT NULL AND o.concept_id=23808 AND o.value_datetime<=endDate
             GROUP BY p.patient_id 
             UNION 
             SELECT p.patient_id,min(e.encounter_datetime) AS initialDate,e.location_id as location FROM patient p 
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             WHERE e.voided=0 AND o.voided=0 AND e.encounter_type IN(5,7) 
             AND e.location_id=location AND e.encounter_datetime<=endDate 
             GROUP BY p.patient_id 
             UNION 
             SELECT pg.patient_id, MIN(pg.date_enrolled) AS initialDate,pg.location_id as location FROM patient p 
             INNER JOIN patient_program pg on pg.patient_id=p.patient_id 
             WHERE pg.program_id=1 AND pg.location_id=location AND pg.voided=0 AND pg.date_enrolled<=endDate  GROUP BY patient_id 
              ) preTarv 
             GROUP BY preTarv.patient_id
             ) 
  preTarvFinal WHERE preTarvFinal.patient_id not in(
          SELECT trasferedPatients.patient_id FROM ( 
             select minState.patient_id,minState.minStateDate as initialDate from( 
             SELECT p.patient_id, pg.patient_program_id, MIN(ps.start_date) as minStateDate FROM patient p  
             inner join patient_program pg on p.patient_id=pg.patient_id  
             inner join patient_state ps on pg.patient_program_id=ps.patient_program_id  
             WHERE  pg.voided=0 and ps.voided=0 and p.voided=0 and pg.program_id=1 and location_id=location and ps.start_date<endDate 
             GROUP BY pg.patient_program_id 
             ) minState  
             inner join patient_state ps on ps.patient_program_id=minState.patient_program_id  
             where ps.start_date=minState.minStateDate and ps.state=28 and ps.voided=0 
             union 
             select minState.patient_id,minState.minStateDate as initialDate from ( 
             SELECT p.patient_id, pg.patient_program_id, MIN(ps.start_date) as minStateDate  FROM patient p  
             inner join patient_program pg on p.patient_id=pg.patient_id 
             inner join patient_state ps on pg.patient_program_id=ps.patient_program_id  
             WHERE  pg.voided=0 and ps.voided=0 and p.voided=0 and pg.program_id=2 and location_id=location  and ps.start_date<endDate 
             GROUP BY pg.patient_program_id) minState  
             inner join patient_state ps on ps.patient_program_id=minState.patient_program_id 
             where ps.start_date=minState.minStateDate and ps.state=29 and ps.voided=0 
             UNION  
             SELECT p.patient_id,MIN(obsData.value_datetime) AS initialDate  FROM patient p 
             INNER JOIN encounter e  ON e.patient_id=p.patient_id 
             INNER JOIN obs o on o.encounter_id=e.encounter_id 
             INNER JOIN obs obsPretarv on e.encounter_id=obsPretarv.encounter_id  
             INNER JOIN obs obsData on e.encounter_id=obsData.encounter_id 
             WHERE e.voided=0 AND o.voided=0  AND e.encounter_type=53  AND obsPretarv.voided=0  AND obsPretarv.concept_id=6300  AND obsPretarv.value_coded in(6275,6276) AND obsData.concept_id=23891 
             AND obsData.voided=0 AND e.location_id=location   AND o.concept_id=1369  AND o.value_coded=1065  AND obsData.value_datetime< endDate GROUP BY p.patient_id)trasferedPatients  GROUP BY trasferedPatients.patient_id 
    )  AND preTarvFinal.initialDate BETWEEN startDate AND endDate;


update lay_counsolers_patient,location
set lay_counsolers_patient.health_facility=location.name where lay_counsolers_patient.location_id=location.location_id ;

/*Sexo*/
update lay_counsolers_patient,person set lay_counsolers_patient.sex=.person.gender
where  person_id=lay_counsolers_patient.patient_id;

/*DATA DE NAICIMENTO*/
UPDATE lay_counsolers_patient,
       person
SET lay_counsolers_patient.date_of_birth=person.birthdate
WHERE lay_counsolers_patient.patient_id=person.person_id;


/*UPDATE CODPROVENIENCIA*/
update lay_counsolers_patient,
    (select 
        p.patient_id,min(encounter_datetime) as dataEntryPoint,   
        case o.value_coded
        when 1595 then 'MEDICAL INPATIENT'
        when 1596 then 'EXTERNAL CONSULTATION'
        when 1414 then 'TB CLINIC - PNCT'
        when 1597 then 'VCT'
        when 1987 then 'HEALTH UNIT, VOLUNTARY TESTING AND COUNSELING - YOUTH'
        when 1598 then 'PMTCT'
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
        when 1985 then 'HEALTH UNIT, PREVENTION OF VERTICAL TRANSMISSION'
        when 1872 then 'CHILD AT RISK CLINIC'
        when 21275 then 'CLINIC'
        else "OTHER" end as codProv
    from  patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id in(1594,23783) and e.encounter_type in (5,7,53) and e.voided=0 
    GROUP BY p.patient_id 
    ) proveniencia
set lay_counsolers_patient.hiv_entry_point=proveniencia.codProv, lay_counsolers_patient.date_hiv_entry_point=proveniencia.dataEntryPoint
where proveniencia.patient_id=lay_counsolers_patient.patient_id;

/*IDADE NA INSCRICAO*/
update lay_counsolers_patient,person set lay_counsolers_patient.age_enrollment=round(datediff(lay_counsolers_patient.enrollment_date,person.birthdate)/365)
where  person_id=lay_counsolers_patient.patient_id;

/*ESTADO CIVIL*/
update lay_counsolers_patient,obs
set lay_counsolers_patient.marital_status_at_enrollment= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=lay_counsolers_patient.patient_id and obs.concept_id=1054 and obs.voided=0; 

/*ESCOLARIDADE*/
update lay_counsolers_patient,obs
set lay_counsolers_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=lay_counsolers_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update lay_counsolers_patient,obs
set lay_counsolers_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=lay_counsolers_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO DO PARCEIRO*/
update lay_counsolers_patient,obs
set lay_counsolers_patient.partner_status_at_enrollment= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=lay_counsolers_patient.patient_id and obs.concept_id=1449 and obs.voided=0;  


/*ESTADIO OMS */
update lay_counsolers_patient,
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
  where   e.voided=0 and e.encounter_type in(9,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set lay_counsolers_patient.WHO_clinical_stage_at_enrollment=stage.cod
where lay_counsolers_patient.patient_id=stage.patient_id 
and lay_counsolers_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;



 /*PESO AT TIME OF ART ENROLLMENT*/
update lay_counsolers_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set lay_counsolers_patient.weight_enrollment=obs.value_numeric, lay_counsolers_patient.weight_date=peso.encounter_datetime
where lay_counsolers_patient.patient_id=obs.person_id 
and lay_counsolers_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update lay_counsolers_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(1,6) and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set lay_counsolers_patient.height_enrollment=obs.value_numeric, lay_counsolers_patient.height_date=altura.encounter_datetime
where lay_counsolers_patient.patient_id=obs.person_id 
and lay_counsolers_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*Inicio TARV*/
update lay_counsolers_patient,
( 

        Select patient_id,min(data_inicio) data_inicio FROM 
        (

            SELECT p.patient_id,min(e.encounter_datetime) data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id  
            INNER JOIN obs o on o.encounter_id=e.encounter_id 
            WHERE e.voided=0 and o.voided=0 and p.voided=0 AND e.encounter_type in (18,6,9) and o.concept_id=1255 
            and o.value_coded=1256 AND e.encounter_datetime<=endDate  
            GROUP BY p.patient_id 
            UNION SELECT p.patient_id,min(value_datetime) data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id 
            INNER JOIN obs o on e.encounter_id=o.encounter_id 
            WHERE p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9,53) AND o.concept_id=1190 
            and o.value_datetime is not null and o.value_datetime<=endDate  
            group by p.patient_id 
            UNION 
            SELECT pg.patient_id,min(date_enrolled) data_inicio FROM patient p 
            INNER JOIN patient_program pg on p.patient_id=pg.patient_id 
            WHERE pg.voided=0 and p.voided=0 and program_id=2 AND date_enrolled<=endDate
            GROUP BY pg.patient_id 
            UNION 
            SELECT e.patient_id, MIN(e.encounter_datetime) AS data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id 
            WHERE p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=endDate  
            GROUP BY p.patient_id 
            UNION 
            SELECT p.patient_id,min(value_datetime) data_inicio FROM patient p 
            INNER JOIN encounter e on p.patient_id=e.patient_id 
            INNER JOIN obs o on e.encounter_id=o.encounter_id 
            WHERE p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type=52 and o.concept_id=23866 
            and o.value_datetime is not null and o.value_datetime<=endDate  
            group by p.patient_id
      ) inicio
    group by patient_id 
  
)inicio_real
set lay_counsolers_patient.date_of_ART_initiation=inicio_real.data_inicio
where lay_counsolers_patient.patient_id=inicio_real.patient_id;


    /*TB DIAGNOSTIC*/   
update lay_counsolers_patient,
    (select p.patient_id,
         e.encounter_datetime,
        case o.value_coded
        when 664 then 'NEGATIVE'
        when 703 then 'POSITIVE'
        when 1065 then 'YES'
        when 1066 then 'NO'
        else null end as cod
    from  lay_counsolers_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id in (6277,23761) and e.encounter_type in (6,9) and e.voided=0 
    ) tb
set lay_counsolers_patient.tb_co_infection= tb.cod
where tb.patient_id=lay_counsolers_patient.patient_id;

/*TB */
update lay_counsolers_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id in(6257,23758)
  group by p.patient_id
)tb, obs
set lay_counsolers_patient.tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where lay_counsolers_patient.patient_id=obs.person_id 
and lay_counsolers_patient.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id in(6257,23758) ;


update lay_counsolers_patient,(
Select  p.patient_id,min(o.obs_datetime) datainh,case o.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  lay_counsolers_patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (13,6,9) and  o.concept_id=6122 
    group by p.patient_id ) seg  
set lay_counsolers_patient.prophylaxis_isoniazide=seg.code, lay_counsolers_patient.prophylaxis_isoniazide_date=seg.datainh
where seg.patient_id=lay_counsolers_patient.patient_id;


/*VISITAS*/
insert into lay_counsolers_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  lay_counsolers_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/* PROXIMA VISITAS*/
update lay_counsolers_visit,obs 
set  lay_counsolers_visit.next_visit_date=obs.value_datetime
where   lay_counsolers_visit.patient_id=obs.person_id and
    lay_counsolers_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;

    /*LEVANTAMENTO ARV*/
insert into lay_counsolers_art_pick_up(patient_id,regime,art_date)
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
  from  lay_counsolers_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime  and o.obs_datetime  BETWEEN startDate AND endDate;
  

/*PROXIMO LEVANTAMENTO*/
update lay_counsolers_art_pick_up,obs 
set  lay_counsolers_art_pick_up.next_art_date=obs.value_datetime
where   lay_counsolers_art_pick_up.patient_id=obs.person_id and
    lay_counsolers_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

    /*CD4*/
insert into lay_counsolers_cd4_absulute(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  lay_counsolers_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497  and o.obs_datetime   BETWEEN startDate AND endDate;

    /*CD4*/
insert into lay_counsolers_cd4_percentage(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  lay_counsolers_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=730   and o.obs_datetime   BETWEEN startDate AND endDate;

/*CARGA VIRAL*/
insert into lay_counsolers_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  lay_counsolers_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and o.obs_datetime  BETWEEN startDate AND endDate;

update lay_counsolers_patient set lay_counsolers_patient.enrolled_in_GAAC='YES' where lay_counsolers_patient.patient_id in (select member_id from gaac_member);

/*GAAC START DATE*/
update lay_counsolers_patient,gaac_member set lay_counsolers_patient.gaac_start_date=gaac_member.start_date where gaac_member.member_id=lay_counsolers_patient.patient_id ;

/*GAAC END DATE*/
update lay_counsolers_patient,gaac_member set lay_counsolers_patient.gaac_end_date=gaac_member.end_date where gaac_member.member_id=lay_counsolers_patient.patient_id; 

  /*GAAC END DATE*/
update lay_counsolers_patient,gaac_member, gaac set lay_counsolers_patient.gaac_identifier=gaac.gaac_identifier where gaac_member.member_id=lay_counsolers_patient.patient_id and gaac_member.gaac_id=gaac.gaac_id; 

/*DMC*/
insert into lay_counsolers_dmc_visit(patient_id,date_elegibbly_dmc)
Select distinct p.patient_id,e.encounter_datetime 
from  lay_counsolers_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime BETWEEN startDate AND endDate;

/*ELEGIBLE DMC*/
update lay_counsolers_dmc_visit,obs,encounter 
set lay_counsolers_dmc_visit.elegibbly_dmc=case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where  lay_counsolers_dmc_visit.patient_id=obs.person_id and obs.concept_id=23765 and obs.voided=0 and
        obs.obs_datetime=lay_counsolers_dmc_visit.date_elegibbly_dmc
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;

/*PROXIMO GAAC*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="GAAC", 
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23724 and 
    obs.voided=0 and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;

    /*PROXIMO AF*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="AF",
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23725 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;

        /*PROXIMO CA*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="CA",
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23726 and obs.voided=0
        and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;

            /*PROXIMO PU*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="PU",
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and obs.concept_id=23727 and obs.voided=0 
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;


            /*PROXIMO FR*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="FR",
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23729 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                /*PROXIMO DT*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="DT",
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23730 and obs.voided=0
            and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                    /*PROXIMO DT*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="DC",
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23731 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;



                    /*PROXIMO DS*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc="DS",
lay_counsolers_dmc_visit.value_dmc= case obs.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23888 and obs.voided=0
    and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;

                        /*PROXIMO OUTRO*/
update lay_counsolers_dmc_visit,obs,encounter 
set  lay_counsolers_dmc_visit.type_dmc=obs.value_text
where   lay_counsolers_dmc_visit.patient_id=obs.person_id and
    lay_counsolers_dmc_visit.date_elegibbly_dmc=obs.obs_datetime and 
    obs.concept_id=23732 and obs.voided=0
  and encounter.encounter_id=obs.encounter_id and encounter.encounter_type in(6,9) and lay_counsolers_dmc_visit.date_elegibbly_dmc=encounter.encounter_datetime;


update lay_counsolers_patient set urban='N';

update lay_counsolers_patient set main='N';

if district='Quelimane' then
  update lay_counsolers_patient set urban='Y'; 
end if;

if district='Namacurra' then
  update lay_counsolers_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update lay_counsolers_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update lay_counsolers_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update lay_counsolers_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update lay_counsolers_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update lay_counsolers_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update lay_counsolers_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update lay_counsolers_patient set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
  update lay_counsolers_patient set main='Y' where location_id in (252);
end if;

if district='Mopeia' then
  update lay_counsolers_patient set main='Y' where location_id in (11);
end if;

if district='Morrumbala' then
  update lay_counsolers_patient set main='Y' where location_id in (13);
end if;

if district='Gurue' then
  update lay_counsolers_patient set main='Y' where location_id in (280);
end if;

if district='Mocuba' then
  update lay_counsolers_patient set main='Y' where location_id in (227);
end if;

if district='Nicoadala' then
  update lay_counsolers_patient set main='Y' where location_id in (277);
end if;




end
;;
DELIMITER ;



