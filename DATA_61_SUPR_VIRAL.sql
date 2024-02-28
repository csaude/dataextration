SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `sp_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `district`varchar(100) DEFAULT NULL,
  `health_facility`varchar(100) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `openmrs_birth_date` datetime DEFAULT NULL,
  `openmrs_gender` varchar(1) DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `occupation_at_enrollment` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `first_viral_load_result` int(11)  DEFAULT NULL,
  `first_viral_load_result_date` datetime DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(10) DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment_date` datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


  DROP TABLE IF EXISTS `sp_art_pick_up`;
CREATE TABLE IF NOT EXISTS `sp_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `pickup_art` varchar(5) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT 'Registo de Levantamento de ARVs Master Card'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sp_fila_drugs`;
CREATE TABLE `sp_fila_drugs` (
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

DROP TABLE IF EXISTS `sp_viral_load`;
CREATE TABLE `sp_viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `nid`varchar(100) DEFAULT NULL,
  `family_name`varchar(100) DEFAULT NULL,
  `first_name`varchar(100) DEFAULT NULL,
  `cv` double DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_comments` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sp_visit`;
CREATE TABLE IF NOT EXISTS `sp_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source` varchar(255),
  `encounter` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sp_art_regimes`;
CREATE TABLE `sp_art_regimes` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `regime_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sp_reint_visit`;
CREATE TABLE `sp_reint_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_type` varchar(255) DEFAULT NULL,
  `first_visit_date` datetime DEFAULT NULL,
  `found_1` varchar(25) DEFAULT NULL,
  `second_visit_date` datetime DEFAULT NULL,
  `third_visit_date` datetime DEFAULT NULL,
  `reason_missed_visit` varchar(255) DEFAULT NULL,
  `date_return_us_1` datetime DEFAULT NULL,
  `date_return_us_2` datetime DEFAULT NULL,
  `date_return_us_3` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sp_differentiated_model`;
CREATE TABLE `sp_differentiated_model` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `differentiated_model` varchar(100) DEFAULT NULL,
  `differentiated_model_status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



/*CREATE INDEX idx_patient_id ON sp_patient(patient_id);
--CREATE INDEX idx_encounter_datetime ON encounter(encounter_datetime);
--CREATE INDEX idx_encounter_type ON encounter(encounter_type);
--CREATE INDEX idx_obs_datetime ON obs(obs_datetime);*/


-- ----------------------------
-- Procedure structure for Fillewh
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillSUPR`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillSUPR`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

truncate table sp_art_pick_up;
truncate table sp_fila_drugs;
truncate table sp_viral_load;
truncate table sp_visit;
truncate table sp_art_regimes;
truncate table sp_reint_visit;
truncate table sp_differentiated_model;

SET @location:=location_id_parameter;

/*INSCRICAO*/
insert into sp_patient(patient_id, enrollment_date, location_id)
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

/*Apagar todos fora desta localização*/
delete from sp_patient where location_id not in (@location);



/*distrito*/
Update sp_patient set sp_patient.district=district;


/* Unidade Sanitaria*/
update sp_patient,location
set sp_patient.health_facility=location.name
where sp_patient.location_id=location.location_id;

/*BUSCAR NID*/
UPDATE sp_patient,
       patient_identifier
SET  sp_patient.nid=patient_identifier.identifier
WHERE  sp_patient.patient_id=patient_identifier.patient_id;

/*FIRST NAME*/
UPDATE sp_patient,
       person_name
SET sp_patient.first_name=person_name.given_name
WHERE sp_patient.patient_id=person_name.person_id;

/*FAMILY NAME*/
UPDATE sp_patient,
       person_name
SET sp_patient.family_name=person_name.family_name
WHERE sp_patient.patient_id=person_name.person_id;

/*DATA DE NASCIMENTO*/
UPDATE sp_patient,
       person
SET sp_patient.openmrs_birth_date=person.birthdate
WHERE sp_patient.patient_id=person.person_id;

/*SEXO*/
UPDATE sp_patient,
       person
SET sp_patient.openmrs_gender=person.gender
WHERE sp_patient.patient_id=person.person_id;


/*IDADE NA INSCRICAO*/
update sp_patient,person set sp_patient.age_enrollment=round(datediff(sp_patient.enrollment_date,person.birthdate)/365)
where  person_id=sp_patient.patient_id;

/*Exclusion criteria*/
delete from sp_patient where age_enrollment<2;


/*ESCOLARIDADE*/
update sp_patient,obs
set sp_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
             else null end
          
where obs.person_id=sp_patient.patient_id and obs.concept_id=1443 and voided=0;


/*PROFISSAO*/
update sp_patient,obs
set sp_patient.occupation_at_enrollment= obs.value_text
where obs.person_id=sp_patient.patient_id and obs.concept_id=1459 and voided=0;


/*INICIO TARV*/
UPDATE sp_patient,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM sp_patient p
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
      FROM sp_patient p
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
      FROM sp_patient p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM sp_patient p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET sp_patient.art_initiation_date=inicio_real.data_inicio
WHERE sp_patient.patient_id=inicio_real.patient_id;



/*PRIMEIRA CARGA VIRAL*/
UPDATE sp_patient,

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
SET sp_patient.first_viral_load_result=obs.value_numeric,sp_patient.first_viral_load_result_date=viral_load1.encounter_datetime
WHERE sp_patient.patient_id=obs.person_id
  AND sp_patient.patient_id=viral_load1.patient_id
  AND obs.voided=0
  AND obs.obs_datetime=viral_load1.encounter_datetime
  AND obs.concept_id=856;
  
/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update sp_patient,obs
set sp_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where sp_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=sp_patient.enrollment_date;

update sp_patient,obs
set sp_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where sp_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=sp_patient.enrollment_date and sp_patient.pregnancy_status_at_enrollment is null;

update sp_patient,patient_program
set sp_patient.pregnancy_status_at_enrollment= 'YES'
where sp_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;

/*Apagar todos ESTADIO OMS II E IV*/
delete from sp_patient where pregnancy_status_at_enrollment='YES';

/*ESTADIO OMS AT ENROLLMENT*/
update sp_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      case o.value_coded
      when 1204 then 'I'
      when 1205 then 'II'
      when 1206 then 'III'
      when 1207 then 'IV'
      else null end as cod
  from sp_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,53) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage,obs
set sp_patient.WHO_clinical_stage_at_enrollment=stage.cod,
sp_patient.WHO_clinical_stage_at_enrollment_date=stage.encounter_datetime
where sp_patient.patient_id=stage.patient_id 
and sp_patient.patient_id=obs.person_id 
and obs.voided=0 
and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;

/*Apagar todos ESTADIO OMS II E IV*/
delete from sp_patient where WHO_clinical_stage_at_enrollment='III' OR WHO_clinical_stage_at_enrollment='IV';


/*LEVANTAMENTO AMC_ART*/
insert into sp_art_pick_up(patient_id,pickup_art,encounter)
  select distinct p.patient_id, case o.value_coded 
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as pick_art, e.encounter_id
  from sp_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=52 and o.concept_id=23865  and e.voided=0 and o.encounter_id=e.encounter_id
  and p.patient_id=o.person_id and o.obs_datetime < endDate;


update sp_art_pick_up,obs
set  sp_art_pick_up.art_date=obs.value_datetime
where   sp_art_pick_up.patient_id=obs.person_id and
    obs.concept_id=23866 and
    obs.voided=0 and sp_art_pick_up.encounter=obs.encounter_id and obs.obs_datetime < endDate;



/*Formulação FILA*/
insert into sp_fila_drugs(patient_id,regime,formulation,pickup_date, group_id, encounter)
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
from  sp_patient p
inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id and concept_id in (1088,165256)
    inner join drug d on o.value_drug=d.drug_id
where   e.voided=0 and o.voided=0 and d.retired=0 and e.encounter_type=18 and o.concept_id in (1088,165256) 
and o.obs_datetime < endDate;

/*quantidade levantada*/
update sp_fila_drugs,obs
set  sp_fila_drugs.quantity=obs.value_numeric
where   sp_fila_drugs.patient_id=obs.person_id and
    sp_fila_drugs.pickup_date=obs.obs_datetime and 
    sp_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1715 and
    obs.voided=0;

/*dosagem */
update sp_fila_drugs,obs
set  sp_fila_drugs.dosage=obs.value_text
where   sp_fila_drugs.patient_id=obs.person_id and
    sp_fila_drugs.pickup_date=obs.obs_datetime and
    sp_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1711 and
    obs.voided=0;

/*proximo levantamento*/
update sp_fila_drugs,obs
set  sp_fila_drugs.next_art_date=obs.value_datetime
where   sp_fila_drugs.patient_id=obs.person_id and
      obs.concept_id=5096 and
    obs.voided=0 and sp_fila_drugs.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Campo de acomodação*/
UPDATE sp_fila_drugs AS efd
JOIN obs AS obs_patient ON efd.patient_id = obs_patient.person_id
                         AND efd.pickup_date = obs_patient.obs_datetime
JOIN sp_patient AS p ON efd.patient_id = p.patient_id
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
UPDATE sp_fila_drugs, obs,

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

SET sp_fila_drugs.dispensation_model = dis.regime
WHERE sp_fila_drugs.patient_id = obs.person_id
    AND sp_fila_drugs.pickup_date = obs.obs_datetime
    AND obs.obs_id=dis.obs_id;


/*CARGA VIRAL*/
insert into sp_viral_load(patient_id,cv,cv_qualit,cv_comments,cv_date,source)
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
from  sp_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,13,51) and o.concept_id in (856,1305) and e.encounter_datetime < endDate
)  valor group by valor.patient_id,valor.obs_datetime; 

/*BUSCAR NID*/
UPDATE sp_viral_load,
       patient_identifier
SET  sp_viral_load.nid=patient_identifier.identifier
WHERE  sp_viral_load.patient_id=patient_identifier.patient_id;

/*FIRST NAME*/
UPDATE sp_viral_load,
       person_name
SET sp_viral_load.first_name=person_name.given_name
WHERE sp_viral_load.patient_id=person_name.person_id;

/*FAMILY NAME*/
UPDATE sp_viral_load,
       person_name
SET sp_viral_load.family_name=person_name.family_name
WHERE sp_viral_load.patient_id=person_name.person_id;


/*VISITAS*/
insert into sp_visit(patient_id,visit_date,source, encounter)
Select distinct p.patient_id,e.encounter_datetime, case e.encounter_type
    when 6 then 'Ficha Clinica'
    when 53 then 'Ficha Resumo'
    when 35 then 'Ficha APSS e PP'
    else null end as encounter_type, e.encounter_id
from  sp_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id 
where   e.voided=0 and e.encounter_type in (6,53,35) and e.encounter_datetime  < endDate;

/* PROXIMA VISITAS Clinica*/
update sp_visit,obs,encounter 
set  sp_visit.next_visit_date=obs.value_datetime
where   sp_visit.patient_id=obs.person_id and
    obs.concept_id=1410 and 
    encounter.encounter_type=6 and obs.voided=0 and sp_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;


/* PROXIMA VISITAS Apss*/
update sp_visit,obs,encounter
set  sp_visit.next_visit_date=obs.value_datetime
where   sp_visit.patient_id=obs.person_id and 
    obs.concept_id=6310 and 
    encounter.encounter_type=35 and obs.voided=0 and sp_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;




/*LEVANTAMENTO Regime*/
insert into sp_art_regimes(patient_id,regime,regime_date)
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
  from sp_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type in (53,6) and o.concept_id=23893  and e.voided=0  
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime and o.obs_datetime < endDate; 

 /*VISITAS REITEGRAÇÃO*/
insert into sp_reint_visit(patient_id,first_visit_date,visit_type, found_1, encounter)
select 
consultas.patient_id,
consultas.encounter_datetime,
tipo_visita.encounter_type,
encontrado.found_1,
consultas.encounter_id
from
-- Consultas
(Select 
p.patient_id, 
e.encounter_datetime, 
e.encounter_id
from 
sp_patient p inner join encounter e on p.patient_id=e.patient_id
where   e.voided=0  and e.encounter_type=21 and e.encounter_datetime  BETWEEN startDate AND endDate
) consultas

-- Informacao adicional das consultas
left  join
(
Select 
e.encounter_id,
case o.value_coded
    when 2161 then 'SUPPORT VISIT'
    when 2160 then 'MISSED VISIT'
    when 23914 then 'VISIT FOR SPECIAL CASES'
 else null end as encounter_type

from  sp_patient p
    inner join encounter e on p.patient_id=e.patient_id
    INNER JOIN obs o ON o.encounter_id=e.encounter_id
where   e.voided=0 and o.concept_id in (1981) and e.encounter_type=21 and e.encounter_datetime  BETWEEN startDate AND endDate

) tipo_visita on consultas.encounter_id=tipo_visita.encounter_id
left  join
(
Select
e.encounter_id,
    case o.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as found_1
from  sp_patient p
    inner join encounter e on p.patient_id=e.patient_id
    INNER JOIN obs o ON o.encounter_id=e.encounter_id
where   e.voided=0 and o.concept_id in (2003) and e.encounter_type=21 and e.encounter_datetime  BETWEEN startDate AND endDate
) encontrado on consultas.encounter_id=encontrado.encounter_id;


/*segunda visita*/
update sp_reint_visit,encounter,obs
set sp_reint_visit.second_visit_date=obs.value_datetime
where sp_reint_visit.patient_id=obs.person_id 
and sp_reint_visit.encounter=obs.encounter_id
and obs.concept_id=6254 and encounter.encounter_type=21 and obs.voided=0;

/*terceira visita*/
update sp_reint_visit,encounter,obs
set sp_reint_visit.third_visit_date=obs.value_datetime
where sp_reint_visit.patient_id=obs.person_id 
and sp_reint_visit.encounter=obs.encounter_id
and obs.concept_id=6255 and encounter.encounter_type=21 and obs.voided=0;

/*motivos de falta*/
UPDATE sp_reint_visit,
(select
reii.encounter_id,
GROUP_CONCAT(reii.motivo) AS motivo
from
(
    SELECT
o.encounter_id,
o.obs_id,
        CASE o.value_coded
            WHEN 2005 THEN 'PATIENT FORGOT VISIT DATE '
            WHEN 2013 THEN 'PATIENT IS TREATING HIV WITH TRADITIONAL MEDICINE '
            WHEN 2009 THEN 'PATIENT HAS SOCIAL PROBLEMS '
            WHEN 2011 THEN 'PATIENT TOOK A TRIP '
            WHEN 2007 THEN 'DISTANCE OR MONEY FOR TRANSPORT IS TO MUCH FOR PATIENT '
            WHEN 2014 THEN 'PATIENTS WORK PREVENTS CLINIC VISIT '
            WHEN 2012 THEN 'PATIENT HAS LACK OF MOTIVATION '
            WHEN 2008 THEN 'PATIENT HAS LACK OF FOOD '
            WHEN 5622 THEN 'Other '
            WHEN 2010 THEN 'PATIENT IS DISSATISFIED WITH DAY HOSPITAL SERVICES '
            WHEN 2015 THEN 'PATIENT DOES NOT LIKE ARV TREATMENT SIDE EFFECTS '
            WHEN 2006 THEN 'PATIENT IS BEDRIDDEN AT HOME '
            WHEN 2017 THEN 'OTHER REASON WHY PATIENT MISSED VISIT '
            WHEN 6436 THEN 'STIGMA '
            WHEN 6439 THEN 'Changed health unit '
            WHEN 1956 THEN 'PATIENT DOES NOT BELIEVE TEST RESULTS '
            WHEN 6186 THEN 'PATIENT DOES NOT BELIEVE ARV TREATMENT '
            WHEN 6437 THEN 'Partner does not allow to return to health facility '
            WHEN 23863 THEN 'AUTO TRANSFER '
            WHEN 23915 THEN 'FEAR OF THE PROVIDER '
            WHEN 23946 THEN 'Absence of Health Provider in Health Unit '
            WHEN 1898 THEN 'RELIGION '
            WHEN 1706 THEN 'TRANSFERRED OUT TO ANOTHER FACILITY '
            WHEN 6303 THEN 'BASED GENDER VIOLENCE '
            WHEN 23767 THEN 'FEEL BETTER (E)'
                     ELSE NULL
        END as motivo
    FROM obs o
    INNER JOIN encounter e ON e.encounter_id = o.encounter_id
    WHERE e.voided = 0
        AND o.voided = 0
        AND o.concept_id = 2016
) reii

group by reii.encounter_id
) rei

SET sp_reint_visit.reason_missed_visit=rei.motivo
WHERE  sp_reint_visit.encounter = rei.encounter_id;

/*retorno primeira visita*/
update sp_reint_visit,encounter,obs
set sp_reint_visit.date_return_us_1=obs.value_datetime
where sp_reint_visit.patient_id=obs.person_id 
and sp_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23933 and encounter.encounter_type=21 and obs.voided=0;

/*retorno segunda visita*/
update sp_reint_visit,encounter,obs
set sp_reint_visit.date_return_us_2=obs.value_datetime
where sp_reint_visit.patient_id=obs.person_id 
and sp_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23934 and encounter.encounter_type=21 and obs.voided=0;

/*retorno terceira visita*/
update sp_reint_visit,encounter,obs
set sp_reint_visit.date_return_us_3=obs.value_datetime
where sp_reint_visit.patient_id=obs.person_id 
and sp_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23935 and encounter.encounter_type=21 and obs.voided=0;

/* community model*/  
   insert into sp_differentiated_model(patient_id,visit_date,differentiated_model) 
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
    and o.concept_id=165174 and e.encounter_type=6 and e.encounter_datetime BETWEEN startDate AND endDate
        and person_id IN (select patient_id from sp_patient);

    update sp_differentiated_model,
    (
    select p.patient_id,e.encounter_datetime,
    case obsEstado.value_coded
    when 1256  then 'START DRUGS'
    when 1257  then 'CONTINUE REGIMEN'
    when 1267  then 'COMPLETED' else null end  status
    from sp_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    inner join obs obsEstado on obsEstado.encounter_id=e.encounter_id
    where e.encounter_type in (6) and e.voided=0 and o.voided=0
    and o.concept_id=165174  and obsEstado.concept_id=165322 and obsEstado.voided=0
    ) final
    set sp_differentiated_model.differentiated_model_status=final.status
    where sp_differentiated_model.patient_id=final.patient_id
    and sp_differentiated_model.visit_date=final.encounter_datetime;

/* Urban and Main*/
update sp_patient set urban='N';

update sp_patient set main='N';

if district='Quelimane' then
  update sp_patient set urban='Y'; 
end if;

if district='Namacurra' then
  update sp_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
  update sp_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
  update sp_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update sp_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update sp_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update sp_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update sp_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update sp_patient set main='Y' where location_id in (4,55); 
end if;

end
;;
DELIMITER ;