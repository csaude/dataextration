SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `artvl_patient`;
CREATE TABLE  `artvl_patient` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL, 
  `sex` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `current_age` int(11) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `education_at_enrollment` varchar(100) DEFAULT NULL,
  `current_status_in_DMC` varchar(225) DEFAULT NULL, 
  `location_id` int(11) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL, 
  PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`),
  KEY `date_of_birth` (`date_of_birth`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


  DROP TABLE IF EXISTS `artvl_art_pick_up`;
CREATE TABLE IF NOT EXISTS `artvl_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `pickup_art` varchar(5) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `encounter` int(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT 'Registo de Levantamento de ARVs Master Card'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `artvl_fila_drugs`;
CREATE TABLE `artvl_fila_drugs` (
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

DROP TABLE IF EXISTS `artvl_viral_load`;
CREATE TABLE `artvl_viral_load` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` double DEFAULT NULL,
  `cv_qualit` varchar(300) DEFAULT NULL,
  `cv_comments` varchar(300) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `artvl_differentiated_model`;
CREATE TABLE `artvl_differentiated_model` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `differentiated_model` varchar(100) DEFAULT NULL,
  `differentiated_model_status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `artvl_visit`;
CREATE TABLE IF NOT EXISTS `artvl_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
  `source` varchar(255),
  `encounter` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `artvl_reint_visit`;
CREATE TABLE `artvl_reint_visit` (
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


DROP PROCEDURE IF EXISTS `FillARTVL`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillARTVL`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

TRUNCATE TABLE artvl_art_pick_up;
TRUNCATE TABLE artvl_fila_drugs;
TRUNCATE TABLE artvl_viral_load;
TRUNCATE TABLE artvl_differentiated_model;
TRUNCATE TABLE artvl_visit;
TRUNCATE TABLE artvl_reint_visit;

SET @location:=location_id_parameter;




/*INSCRICAO*/
insert into artvl_patient(patient_id, enrollment_date, location_id)
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
delete from artvl_patient where location_id not in (@location);

/*distrito*/
Update artvl_patient set artvl_patient.district=district;

/* Unidade Sanitaria*/
update artvl_patient,location
set artvl_patient.health_facility=location.name
where artvl_patient.location_id=location.location_id;


/*DATA DE NASCIMENTO*/
UPDATE artvl_patient,
       person
SET artvl_patient.date_of_birth=person.birthdate
WHERE artvl_patient.patient_id=person.person_id;


/*Data de Nascimento*/
update artvl_patient,person set artvl_patient.current_age=round(datediff("2023-03-20",person.birthdate)/365)
where  person_id=artvl_patient.patient_id;

  /*Sexo*/
update artvl_patient,person set artvl_patient.sex=.person.gender
where  person.person_id=artvl_patient.patient_id;


/*ESCOLARIDADE*/
update artvl_patient,obs
set artvl_patient.education_at_enrollment= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
             else null end        
where obs.person_id=artvl_patient.patient_id and obs.concept_id=1443 and voided=0;


/*ESTADO ACTUAL DO STATUS DMC*/
update artvl_patient,
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
set 	artvl_patient.current_status_in_DMC=saida.codeestado
/*artvl_patient.patient_status_date=saida.start_date*/
where saida.patient_id=artvl_patient.patient_id;




/*LEVANTAMENTO AMC_ART*/
insert into artvl_art_pick_up(patient_id,pickup_art,encounter)
  select distinct p.patient_id, case o.value_coded 
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as pick_art, e.encounter_id
  from artvl_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=52 and o.concept_id=23865  and e.voided=0 and o.encounter_id=e.encounter_id
  and p.patient_id=o.person_id and o.obs_datetime < endDate;


update artvl_art_pick_up,obs
set  artvl_art_pick_up.art_date=obs.value_datetime
where   artvl_art_pick_up.patient_id=obs.person_id and
    obs.concept_id=23866 and
    obs.voided=0 and artvl_art_pick_up.encounter=obs.encounter_id and obs.obs_datetime < endDate;



/*Formulação FILA*/
insert into artvl_fila_drugs(patient_id,regime,formulation,pickup_date, group_id, encounter)
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
from  artvl_patient p
inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id and concept_id in (1088,165256)
    inner join drug d on o.value_drug=d.drug_id
where   e.voided=0 and o.voided=0 and d.retired=0 and e.encounter_type=18 and o.concept_id in (1088,165256) 
and o.obs_datetime < endDate;

/*quantidade levantada*/
update artvl_fila_drugs,obs
set  artvl_fila_drugs.quantity=obs.value_numeric
where   artvl_fila_drugs.patient_id=obs.person_id and
    artvl_fila_drugs.pickup_date=obs.obs_datetime and 
    artvl_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1715 and
    obs.voided=0;

/*dosagem */
update artvl_fila_drugs,obs
set  artvl_fila_drugs.dosage=obs.value_text
where   artvl_fila_drugs.patient_id=obs.person_id and
    artvl_fila_drugs.pickup_date=obs.obs_datetime and
    artvl_fila_drugs.group_id=obs.obs_group_id and
    obs.concept_id=1711 and
    obs.voided=0;

/*proximo levantamento*/
update artvl_fila_drugs,obs
set  artvl_fila_drugs.next_art_date=obs.value_datetime
where   artvl_fila_drugs.patient_id=obs.person_id and
      obs.concept_id=5096 and
    obs.voided=0 and artvl_fila_drugs.encounter=obs.encounter_id and obs.obs_datetime < endDate;

/*Campo de acomodação*/
UPDATE artvl_fila_drugs AS efd
JOIN obs AS obs_patient ON efd.patient_id = obs_patient.person_id
                         AND efd.pickup_date = obs_patient.obs_datetime
JOIN artvl_patient AS p ON efd.patient_id = p.patient_id
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
UPDATE artvl_fila_drugs, obs,

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

SET artvl_fila_drugs.dispensation_model = dis.regime
WHERE artvl_fila_drugs.patient_id = obs.person_id
    AND artvl_fila_drugs.pickup_date = obs.obs_datetime
    AND obs.obs_id=dis.obs_id;


/*CARGA VIRAL*/
insert into artvl_viral_load(patient_id,cv,cv_qualit,cv_comments,cv_date,source)
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
from  artvl_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type in (6,13,51) and o.concept_id in (856,1305) and e.encounter_datetime < endDate
)  valor group by valor.patient_id,valor.obs_datetime; 



 /* community model*/  
   insert into artvl_differentiated_model(patient_id,visit_date,differentiated_model) 
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
        and person_id IN (select patient_id from artvl_patient);

    update artvl_differentiated_model,
    (
    select p.patient_id,e.encounter_datetime,
    case obsEstado.value_coded
    when 1256  then 'START DRUGS'
    when 1257  then 'CONTINUE REGIMEN'
    when 1267  then 'COMPLETED' else null end  status
    from artvl_patient p
    inner join encounter e on e.patient_id=p.patient_id
    inner join obs o on o.encounter_id=e.encounter_id
    inner join obs obsEstado on obsEstado.encounter_id=e.encounter_id
    where e.encounter_type in (6,9,18) and e.voided=0 and o.voided=0
    and o.concept_id=165174  and obsEstado.concept_id=165322 and obsEstado.voided=0
    ) final
    set artvl_differentiated_model.differentiated_model_status=final.status
    where artvl_differentiated_model.patient_id=final.patient_id
    and artvl_differentiated_model.visit_date=final.encounter_datetime;

/*VISITAS*/
insert into artvl_visit(patient_id,visit_date,source, encounter)
Select distinct p.patient_id,e.encounter_datetime, case e.encounter_type
     when 35 then 'Ficha APSS e PP'
    else null end as encounter_type, e.encounter_id
from  artvl_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id 
where   e.voided=0 and e.encounter_type=35 and e.encounter_datetime  < endDate;

/* PROXIMA VISITAS Apss*/
update artvl_visit,obs,encounter
set  artvl_visit.next_visit_date=obs.value_datetime
where   artvl_visit.patient_id=obs.person_id and 
    obs.concept_id=6310 and 
    encounter.encounter_type=35 and obs.voided=0 and artvl_visit.encounter=obs.encounter_id and obs.obs_datetime < endDate;



/*VISITAS REITEGRAÇÃO*/
insert into artvl_reint_visit(patient_id,first_visit_date,visit_type, found_1, encounter)
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
artvl_patient p inner join encounter e on p.patient_id=e.patient_id
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

from  artvl_patient p
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
from  artvl_patient p
    inner join encounter e on p.patient_id=e.patient_id
    INNER JOIN obs o ON o.encounter_id=e.encounter_id
where   e.voided=0 and o.concept_id in (2003) and e.encounter_type=21 and e.encounter_datetime  BETWEEN startDate AND endDate
) encontrado on consultas.encounter_id=encontrado.encounter_id;


/*segunda visita*/
update artvl_reint_visit,encounter,obs
set artvl_reint_visit.second_visit_date=obs.value_datetime
where artvl_reint_visit.patient_id=obs.person_id 
and artvl_reint_visit.encounter=obs.encounter_id
and obs.concept_id=6254 and encounter.encounter_type=21 and obs.voided=0;

/*terceira visita*/
update artvl_reint_visit,encounter,obs
set artvl_reint_visit.third_visit_date=obs.value_datetime
where artvl_reint_visit.patient_id=obs.person_id 
and artvl_reint_visit.encounter=obs.encounter_id
and obs.concept_id=6255 and encounter.encounter_type=21 and obs.voided=0;

/*motivos de falta*/
UPDATE artvl_reint_visit,
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

SET artvl_reint_visit.reason_missed_visit=rei.motivo
WHERE  artvl_reint_visit.encounter = rei.encounter_id;

/*retorno primeira visita*/
update artvl_reint_visit,encounter,obs
set artvl_reint_visit.date_return_us_1=obs.value_datetime
where artvl_reint_visit.patient_id=obs.person_id 
and artvl_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23933 and encounter.encounter_type=21 and obs.voided=0;

/*retorno segunda visita*/
update artvl_reint_visit,encounter,obs
set artvl_reint_visit.date_return_us_2=obs.value_datetime
where artvl_reint_visit.patient_id=obs.person_id 
and artvl_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23934 and encounter.encounter_type=21 and obs.voided=0;

/*retorno terceira visita*/
update artvl_reint_visit,encounter,obs
set artvl_reint_visit.date_return_us_3=obs.value_datetime
where artvl_reint_visit.patient_id=obs.person_id 
and artvl_reint_visit.encounter=obs.encounter_id
and obs.concept_id=23935 and encounter.encounter_type=21 and obs.voided=0;
    
/*URBAN AND MAIN*/
update artvl_patient set urban='N';
update artvl_patient set main='N';
if district='Quelimane' then
  update artvl_patient set urban='Y';
end if;
if district='Namacurra' then
  update artvl_patient set main='Y' where location_id=5;
end if;
if district='Maganja' then
  update artvl_patient set main='Y' where location_id=15;
end if;
if district='Pebane' then
  update artvl_patient set main='Y' where location_id=16;
end if;
if district='Gile' then
  update artvl_patient set main='Y' where location_id=6;
end if;
if district='Molocue' then
  update artvl_patient set main='Y' where location_id=3;
end if;
if district='Mocubela' then
  update artvl_patient set main='Y' where location_id=62;
end if;
if district='Inhassunge' then
  update artvl_patient set main='Y' where location_id=7;
end if;
if district='Ile' then
  update artvl_patient set main='Y' where location_id in (4,55);
end if;
if district='Namarroi' then
  update artvl_patient set main='Y' where location_id in (252);
end if;
if district='Mopeia' then
  update artvl_patient set main='Y' where location_id in (11);
end if;
if district='Morrumbala' then
  update artvl_patient set main='Y' where location_id in (13);
end if;
if district='Gurue' then
  update artvl_patient set main='Y' where location_id in (280);
end if;
if district='Mocuba' then
  update artvl_patient set main='Y' where location_id in (227);
end if;
if district='Nicoadala' then
  update artvl_patient set main='Y' where location_id in (277);
end if;
if district='Milange' then
  update artvl_patient set main='Y' where location_id in (281);
end if;

end
;;
DELIMITER ;