SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `hops` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `study_code`varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `study_first_name`varchar(100) DEFAULT NULL,
  `study_second_name`varchar(100) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `openmrs_birth_date` datetime DEFAULT NULL,
  `openmrs_age` int(11) DEFAULT NULL,
  `openmrs_gender` varchar(1) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `last_clinic_visit` datetime DEFAULT NULL,
  `scheduled_clinic_visit` datetime DEFAULT NULL,
  `last_artpickup` datetime DEFAULT NULL,
  `scheduled_artpickp` datetime DEFAULT NULL,  
  `first_viral_load_result` int(11)  DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height` double DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `imc`    double DEFAULT NULL,
  `imc_date` datetime DEFAULT NULL,
  `hemoglobin` int(11)  DEFAULT NULL,
  `hemoglobin_date` datetime DEFAULT NULL,
  `patient_status_6_months` varchar(225) DEFAULT NULL,
  `patient_status_6_months_date_` datetime DEFAULT NULL,
  `patient_status_12_months` varchar(225) DEFAULT NULL,
  `patient_status_12_months_date_` datetime DEFAULT NULL,
  `patient_status_18_months` varchar(225) DEFAULT NULL,
  `patient_status_18_months_date_` datetime DEFAULT NULL,
  `enrolled_in_GAAC` varchar(100) DEFAULT NULL,
  `gaac_start_date`datetime DEFAULT NULL,
  `gaac_end_date` datetime DEFAULT NULL,
  `gaac_identifier` varchar(225) DEFAULT NULL,
  `elegibbly_dmc` varchar(100) DEFAULT NULL,
  `date_elegibbly_dmc` datetime DEFAULT NULL,
  `dmc_gaac` varchar(100) DEFAULT NULL,
  `dmc_AF` varchar(100) DEFAULT NULL,
  `dmc_CA` varchar(100) DEFAULT NULL,
  `dmc_PU` varchar(100) DEFAULT NULL,
  `dmc_FR` varchar(100) DEFAULT NULL,
  `dmc_DT` varchar(100) DEFAULT NULL,
  `dmc_DC` varchar(100) DEFAULT NULL,
  `dmc_DS` varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cd4
-- ----------------------------
CREATE TABLE IF NOT EXISTS `hops_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hops_cv`;
CREATE TABLE `hops_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hops_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hops_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_tb_investigation` (
  `patient_id` int(11) DEFAULT NULL,
  `tb` varchar(255) DEFAULT NULL,
  `tb_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_start_tb_tretment` (
  `patient_id` int(11) DEFAULT NULL,
  `start_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hops_end_tb_tretment` (
  `patient_id` int(11) DEFAULT NULL,
  `end_tb_treatment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillHOPS`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillHOPS`(startDate date,endDate date, district varchar(100))
    READS SQL DATA
begin

truncate table hops_cd4;
truncate table hops_visit;
truncate table hops_tb_investigation;
truncate table hops_start_tb_tretment;
truncate table hops_end_tb_tretment;


/*BUSCAR ID DO PACIENTE E LOCATION*/
/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE hops,
       patient_identifier
SET hops.patient_id=patient_identifier.patient_id, hops.location_id=patient_identifier.location_id
WHERE  patient_identifier.identifier=hops.nid;


/*DATA DE NAICIMENTO*/
UPDATE hops,
       person
SET hops.openmrs_birth_date=person.birthdate
WHERE hops.patient_id=person.person_id;

/*FIRST NAME*/
UPDATE hops,
       person_name
SET hops.first_name=person_name.given_name
WHERE hops.patient_id=person_name.person_id;


/*FAMILY NAME*/
UPDATE hops,
       person_name
SET hops.family_name=person_name.family_name
WHERE hops.patient_id=person_name.person_id;


/*SEXO*/
UPDATE hops,
       person
SET hops.openmrs_gender=.person.gender
WHERE hops.patient_id=person.person_id;

/*INICIO TARV*/
UPDATE hops,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND p.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE p.voided=0
        AND e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND p.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE p.voided=0
        AND e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id) inicio
   GROUP BY patient_id)inicio_real
SET hops.art_initiation_date=inicio_real.data_inicio
WHERE hops.patient_id=inicio_real.patient_id;


/*Data de Naicimento*/
update hops,person set hops.openmrs_age=round(datediff(hops.art_initiation_date,person.birthdate)/365)
where  person_id=hops.patient_id;

/*INSCRICAO*/
UPDATE hops,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,
                              7,53)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment
SET hops.enrollment_date=enrollment.data_abertura
WHERE hops.patient_id=enrollment.patient_id;

/*PRIMEIRA CARGA VIRAL*/
UPDATE hops,

  (SELECT p.patient_id,
          min(e.encounter_datetime) encounter_datetime
   FROM patient p
   INNER JOIN encounter e ON p.patient_id=e.patient_id
   INNER JOIN obs o ON o.encounter_id=e.encounter_id
   WHERE e.voided=0
     AND o.voided=0
     AND e.encounter_type IN (6,
                              9,
                              13)
     AND o.concept_id=856
   GROUP BY p.patient_id ) viral_load1,
       obs
SET hops.first_viral_load_result=obs.value_numeric,hops.first_viral_load_result_date=viral_load1.encounter_datetime
WHERE hops.patient_id=obs.person_id
  AND hops.patient_id=viral_load1.patient_id
  AND obs.voided=0
  AND obs.obs_datetime=viral_load1.encounter_datetime
  AND obs.concept_id=856;


/*Peso*/
update hops,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089 and e.encounter_datetime between startDate and endDate
  group by p.patient_id
)peso,obs
set hops.weight=obs.value_numeric, hops.weight_date=peso.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*Altura*/
update hops,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 and e.encounter_datetime between startDate and endDate
  group by p.patient_id
)altura,obs
set hops.height=obs.value_numeric, hops.height_date=altura.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


update hops,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=1342 and e.encounter_datetime between startDate and endDate
  group by p.patient_id
)imc,obs
set hops.imc=obs.value_numeric, hops.imc_date=imc.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=imc.patient_id 
and obs.voided=0 and obs.obs_datetime=imc.encounter_datetime;


/*HEMOGLOBINA SEGUIMENTO */
update hops,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime  and e.encounter_datetime between startDate and endDate
      and o.concept_id=1692 
  group by p.patient_id
)hemoglobin,obs 
set  hops.hemoglobin=obs.value_numeric, hops.hemoglobin_date=hemoglobin.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=hemoglobin.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin.encounter_datetime
 and obs.concept_id=1692;


/*HEMOGLOBINA LAB */
update hops,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=13 and o.obs_datetime=e.encounter_datetime and e.encounter_datetime between startDate and endDate 
      and o.concept_id=21
  group by p.patient_id
)hemoglobin,
obs 
set  hops.hemoglobin=obs.value_numeric, hops.hemoglobin_date=hemoglobin.encounter_datetime
where hops.patient_id=obs.person_id 
and hops.patient_id=hemoglobin.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin.encounter_datetime
and obs.concept_id=21 and hops.hemoglobin is null;


 /*ESTADO ACTUAL TARV 6 MESES*/
update hops,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  hops p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 6 MONTH)
    ) out_state
set   hops.patient_status_6_months=out_state.codeestado, hops.patient_status_6_months_date_=out_state.start_date
where hops.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 12 MESES*/
update hops,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  hops p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 12 MONTH)
    ) out_state
set   hops.patient_status_12_months=out_state.codeestado, hops.patient_status_12_months_date_=out_state.start_date
where hops.patient_id=out_state.patient_id;

 /*ESTADO ACTUAL TARV 12 MESES*/
update hops,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  hops p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and  ps.start_date between enrollment_date and DATE_ADD(enrollment_date, INTERVAL 18 MONTH)
    ) out_state
set   hops.patient_status_18_months=out_state.codeestado, hops.patient_status_18_months_date_=out_state.start_date
where hops.patient_id=out_state.patient_id;


/*CD4*/
insert into hops_cd4(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  hops p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=5497 and e.encounter_datetime  < endDate ;

/*LAST CLINIC VISIT*/
update hops,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  hops p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime < endDate
  group by p.patient_id
)seguimento
set hops.last_clinic_visit=seguimento.encounter_datetime
where hops.patient_id=seguimento.patient_id;

/*CARGA VIRAL*/
insert into hops_cv(patient_id,cv,cv_date)
Select distinct p.patient_id,
    o.value_numeric,
    o.obs_datetime
from  hops p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and e.encounter_datetime  < endDate;



/*NEXT CLINIC VISIT*/
update  hops,obs
set   scheduled_clinic_visit=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_clinic_visit and 
    concept_id=5096 and voided=0;

    /*LAST ART PICKUP*/
update hops,
( select  p.patient_id,
      max(encounter_datetime) encounter_datetime
  from  hops p
      inner join encounter e on p.patient_id=e.patient_id
  where   e.voided=0 and e.encounter_type=18 and e.encounter_datetime < endDate
  group by p.patient_id
)levantamento
set hops.last_artpickup=levantamento.encounter_datetime
where hops.patient_id=levantamento.patient_id;

update  hops,obs
set   scheduled_artpickp=value_datetime
where   patient_id=person_id and 
    obs_datetime=last_artpickup and 
    concept_id=5096 and voided=0;

/*TB*/
insert into hops_tb_investigation(patient_id,tb,tb_date)
Select distinct p.patient_id,
    case o.value_coded
             when 703 then 'POSITIVE'
             when 664 then 'NEGATIVE'
             else null end,
      o.obs_datetime
from  hops p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,9,13) and o.concept_id=6277 and e.encounter_datetime  < endDate;

/*LEVANTAMENTO ARV*/
insert into hops_art_pick_up(patient_id,regime,art_date)
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
  from  hops p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and e.encounter_datetime  < endDate;

/*PROXIMO LEVANTAMENTO*/
update hops_art_pick_up,obs 
set  hops_art_pick_up.next_art_date=obs.value_datetime
where   hops_art_pick_up.patient_id=obs.person_id and
    hops_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

/*VISITAS*/
insert into hops_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  hops p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime  < endDate;

/* PROXIMA VISITAS*/
update hops_visit,obs 
set  hops_visit.next_visit_date=obs.value_datetime
where   hops_visit.patient_id=obs.person_id and
    hops_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;


/*TB start Date*/
insert into hops_start_tb_tretment(patient_id,start_tb_treatment)
Select distinct p.patient_id, min(encounter_datetime) encounter_datetime
from  hops p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=1113 and o.voided=0 and e.encounter_datetime  < endDate
  group by p.patient_id;


  /*TB end Date*/
insert into hops_end_tb_tretment(patient_id,end_tb_treatment)
Select distinct p.patient_id, max(encounter_datetime) encounter_datetime
from  hops p 
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in (6,9) and o.concept_id=6120 and e.encounter_datetime  < endDate
  group by p.patient_id;




update hops,location
set hops.health_facility=location.name
where hops.location_id=location.location_id;


update hops set hops.enrolled_in_GAAC='YES' where hops.patient_id in (select member_id from gaac_member);

/*GAAC START DATE*/
update hops,gaac_member set hops.gaac_start_date=gaac_member.start_date where gaac_member.member_id=hops.patient_id ;

/*GAAC END DATE*/
update hops,gaac_member set hops.gaac_end_date=gaac_member.end_date where gaac_member.member_id=hops.patient_id; 

  /*GAAC END DATE*/
update hops,gaac_member, gaac set hops.gaac_identifier=gaac.gaac_identifier where gaac_member.member_id=hops.patient_id and gaac_member.gaac_id=gaac.gaac_id; 

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23765 
    group by p.patient_id ) firsDMC  
set hops.elegibbly_dmc=firsDMC.code, hops.date_elegibbly_dmc=firsDMC.dataDMC
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23724 
    group by p.patient_id ) firsDMC  
set hops.dmc_gaac=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23725 
    group by p.patient_id) firsDMC  
set hops.dmc_AF=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23726 
    group by p.patient_id) firsDMC  
set hops.dmc_CA=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23727 
    group by p.patient_id) firsDMC  
set hops.dmc_PU=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23729 
    group by p.patient_id) firsDMC  
set hops.dmc_FR=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23730 
    group by p.patient_id) firsDMC  
set hops.dmc_DT=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23731 
    group by p.patient_id) firsDMC  
set hops.dmc_DC=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops,(
Select  p.patient_id,min(o.obs_datetime) dataDMC,case o.value_coded
             when 1256 then 'START DRUGS'
             when 1257 then 'CONTINUE REGIMEN'
             when 1267 then 'COMPLETED'
             else null end as code
    from  patient p
        inner join encounter e on p.patient_id=e.patient_id
        inner join obs o on e.encounter_id=o.encounter_id
    where     e.voided=0 and o.voided=0 and e.encounter_type in (6,9) and  o.concept_id=23888 
    group by p.patient_id) firsDMC  
set hops.dmc_DS=firsDMC.code
where firsDMC.patient_id=hops.patient_id;

update hops set urban='N';

update hops set main='N';

if district='Quelimane' then
  update hops set urban='Y'; 
end if;

if district='Namacurra' then
  update hops set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update hops set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update hops set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update hops set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update hops set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update hops set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update hops set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update hops set main='Y' where location_id in (4,55); 
end if;

end
;;
DELIMITER ;



