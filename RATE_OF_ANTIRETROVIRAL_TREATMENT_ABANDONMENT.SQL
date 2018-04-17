SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `rate_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `date_art_initiation`datetime DEFAULT NULL,
  `sex` varchar(100) DEFAULT NULL,
  `age`int(11) DEFAULT NULL,
  `local_of_residence` varchar(100) DEFAULT NULL,
  `profession` varchar(100) DEFAULT NULL,
  `academic_level` varchar(100) DEFAULT NULL,
  `number_of_cohabitants` int(11) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `number_of_spouses` int(11) DEFAULT NULL,
  `number_of_children` int(11) DEFAULT NULL,
  `glacier` varchar(100) DEFAULT NULL,
  `electricity` varchar(100) DEFAULT NULL,
  `smoking_habits` varchar(100) DEFAULT NULL,
  `alcohol_consumption` varchar(100) DEFAULT NULL,
  `other_drugs` varchar(100) DEFAULT NULL,
  `sexuality` varchar(100) DEFAULT NULL,
  `number_of_sexual_partners` int(11)  DEFAULT NULL,
  `drugs_allergies` varchar(100) DEFAULT NULL,
  `therapeutic_history_with_art` varchar(100) DEFAULT NULL,
  `clinical_history_pulmonary_TB` varchar(100) DEFAULT NULL,
  `clinical_history_extra_pulmonar` varchar(100) DEFAULT NULL,
  `clinical_history_herpes_zoster` varchar(100) DEFAULT NULL,
  `clinical_history_candidiase_oral` varchar(100) DEFAULT NULL,
  `clinical_history_candidiase_esofágica` varchar(100) DEFAULT NULL,
  `clinical_history_kaposis_sarcoma` varchar(100) DEFAULT NULL,
  `clinical_history_dts_thinning` varchar(100) DEFAULT NULL,
  `clinical_history_dts_ulcer` varchar(100) DEFAULT NULL,
  `clinical_history_dts_condiloma` varchar(100) DEFAULT NULL,
  `clinical_history_diarrhea_chronic` varchar(100) DEFAULT NULL,
  `clinical_history_weight_loss_greater_than_ten_percent` varchar(100) DEFAULT NULL,
  `clinical_history_prolonged_fever` varchar(100) DEFAULT NULL,
  `clinical_history_prolonged_cough` varchar(100) DEFAULT NULL,
  `general_status` varchar(100) DEFAULT NULL,
  `pregnancy` varchar(11) DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `height` double DEFAULT NULL,
  `imc`    double DEFAULT NULL,
  `blood_pressure_at_screening_systolic` int(11)  DEFAULT NULL,
  `blood_pressure_at_screening_diastolic` int(11)  DEFAULT NULL,
  `hemoglobin` int(11)  DEFAULT NULL,
  `glycemic` int(11)  DEFAULT NULL,
  `who_stage_of_patient` varchar(100) DEFAULT NULL,
  `sti_at_screening` varchar(100) DEFAULT NULL,
  `tb_at_screening` varchar(100) DEFAULT NULL,
  `it_was_advised_to_start_ART` varchar(50) DEFAULT NULL,
  `type_of_therapy` varchar(100) DEFAULT NULL,
  `number_of_tablets` int(11)  DEFAULT NULL,
  `number_of_tablets_consumed_daily` varchar(100) DEFAULT NULL,
  `first_cd4`decimal(10,0) DEFAULT NULL,
  `last_cd4` decimal(10,0) DEFAULT NULL,
  `last_art_pick_up_date` datetime DEFAULT NULL,
  `first_viral_load` int(11)  DEFAULT NULL,
  `last_viral_load` int(11)  DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for FillRate
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillRate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillRate`(startDate date,endDate date,dataAvaliacao date,location int)
    READS SQL DATA
begin
truncate table rate_patient;

/*ADULTOS QUE INICIARAM O TARV NUM DETERMINADO PERIUDO*/
insert into rate_patient(patient_id,date_art_initiation)
SELECT patient_id, data_inicio FROM (SELECT patient_id, MIN(data_inicio) data_inicio
FROM (SELECT
  p.patient_id,
  MIN(e.encounter_datetime) data_inicio
FROM patient p
INNER JOIN encounter e
  ON p.patient_id = e.patient_id
INNER JOIN obs o
  ON o.encounter_id = e.encounter_id
WHERE e.voided = 0
AND o.voided = 0
AND p.voided = 0
AND e.encounter_type IN (18, 6, 9)
AND o.concept_id = 1255
AND o.value_coded = 1256
AND e.encounter_datetime <= dataAvaliacao
AND e.location_id = location
GROUP BY p.patient_id

UNION

SELECT p.patient_id, MIN(value_datetime) data_inicio
FROM patient p
INNER JOIN encounter e
  ON p.patient_id = e.patient_id
INNER JOIN obs o
  ON e.encounter_id = o.encounter_id
WHERE p.voided = 0
AND e.voided = 0
AND o.voided = 0
AND e.encounter_type IN (18, 6, 9)
AND o.concept_id = 1190
AND o.value_datetime IS NOT NULL
AND o.value_datetime <= dataAvaliacao
AND e.location_id = location
GROUP BY p.patient_id

UNION

SELECT pg.patient_id, date_enrolled data_inicio
FROM patient p
INNER JOIN patient_program pg
  ON p.patient_id = pg.patient_id
WHERE pg.voided = 0
AND p.voided = 0
AND program_id = 2
AND date_enrolled <= dataAvaliacao
AND location_id = location

UNION

SELECT e.patient_id, MIN(e.encounter_datetime) AS data_inicio
FROM patient p
INNER JOIN encounter e
  ON p.patient_id = e.patient_id
WHERE p.voided = 0
AND e.encounter_type = 18
AND e.voided = 0
AND e.encounter_datetime <= dataAvaliacao
AND e.location_id = location
GROUP BY p.patient_id) inicio
GROUP BY patient_id) inicio1 WHERE  data_inicio BETWEEN startDate AND endDate;

/*Data de Naicimento*/
update rate_patient,person set rate_patient.age=round(datediff(rate_patient.date_art_initiation,person.birthdate)/365)
where  person_id=rate_patient.patient_id;

delete from rate_patient where age<15;

/*Sexo*/
update rate_patient,person set rate_patient.sex=.person.gender
where  person_id=rate_patient.patient_id;

/*Bairro*/
update rate_patient,person_address 
set rate_patient.local_of_residence=person_address.address5
where  person_id=patient_id;


/*PROFISSAO*/
update rate_patient,obs
set rate_patient.profession = obs.value_text
where obs.person_id=patient_id and obs.concept_id=1459 and voided=0;

/*ESCOLARIDADE*/
update rate_patient,obs
set rate_patient.academic_level= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1443 and voided=0;

/*CONVIVENTES*/
update rate_patient,obs
set rate_patient.number_of_cohabitants = obs.value_numeric
where obs.person_id=rate_patient.patient_id and obs.concept_id=1656 and voided=0;


/*ESTADO CIVIL*/
update rate_patient,obs
set rate_patient.marital_status= case obs.value_coded
             when 1057 then 'SINGLE'
             when 5555 then 'MARRIED'
             when 1059 then 'WIDOWED'
             when 1060 then 'LIVING WITH PARTNER'
             when 1056 then 'SEPARATED'
             when 1058 then 'DIVORCED'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1054 and obs.voided=0;  

/*CONJUGUES*/
update rate_patient,obs
set rate_patient.number_of_spouses = obs.value_numeric
where obs.person_id=rate_patient.patient_id and obs.concept_id=5557 and voided=0;

/*NUMERO DE Filhos*/
update rate_patient,obs
  set rate_patient.number_of_children= obs.value_numeric
where obs.person_id=rate_patient.patient_id and obs.concept_id=5573 and obs.voided=0;


/*ELECTRICIDADE*/
update rate_patient, obs
set rate_patient.electricity= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=5609 and voided=0;

/*GELEIRA*/
update rate_patient,obs
set rate_patient.glacier= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1455 and voided=0;

/*TABACO*/
update rate_patient,obs
set rate_patient.smoking_habits= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1388 and voided=0;

/*ALCOOL*/
update rate_patient,obs
set rate_patient.alcohol_consumption= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1603 and voided=0;

/*OUTRAS DROGAS */
update rate_patient,obs
set rate_patient.other_drugs= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=105 and voided=0;

/*SEXUALIDADE */
update rate_patient,obs
set rate_patient.sexuality= case obs.value_coded
             when 1376 then 'HETEROSEXUAL'
             when 1377 then 'HOMOSEXUAL'
             when 1378 then 'BISEXUAL'

             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1375 and voided=0;

/*NUMERO DE PARCEIROS SEXUAIS NOS ULTIMOS 3 MESES */
update rate_patient,obs
set rate_patient.number_of_sexual_partners= case obs.value_coded
             when 1662 then '1'
             when 1663 then '1 TO 3'
             when 1664 then 'MORE THAN 3'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1666 and voided=0;

/*ALERGIA A MEDICAMENTOS*/
update rate_patient,obs
set rate_patient.drugs_allergies= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             when 1067 then 'UNKNOWN'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1601 and voided=0;

/*ANTECEDENTES TERAPEUTICOS COM TARV*/
update rate_patient,obs
set rate_patient.therapeutic_history_with_art= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1192 and voided=0;

/*TB Pulmonar*/
update rate_patient,obs
set rate_patient.clinical_history_pulmonary_TB= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=42 and voided=0;

/*TB extra pulmonar */
update rate_patient,obs
set rate_patient.clinical_history_extra_pulmonar= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=5042 and voided=0;

/*Herpes Zoster */
update rate_patient,obs
set rate_patient.clinical_history_herpes_zoster= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=836 and voided=0;

/*Candidiase oral */
update rate_patient,obs
set rate_patient.clinical_history_candidiase_oral= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=5334 and voided=0;

/*Candidiase esofágica*/
update rate_patient,obs
set rate_patient.clinical_history_candidiase_esofágica= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=5340 and voided=0;

/* Sarcoma de Kaposi */
update rate_patient,obs
set rate_patient.clinical_history_kaposis_sarcoma= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=507 and voided=0;

/*DTS: Corrimento */
update rate_patient,obs
set rate_patient.clinical_history_dts_thinning= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1379 and voided=0;

/*DTS: Úlcera */
update rate_patient,obs
set rate_patient.clinical_history_dts_ulcer= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1380 and voided=0;

/*DTS: Condiloma */
update rate_patient,obs
set rate_patient.clinical_history_dts_condiloma= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1381 and voided=0;

/*Diarreia crónica */
update rate_patient,obs
set rate_patient.clinical_history_diarrhea_chronic= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=5018 and voided=0;

/*Diarreia crónica */
update rate_patient,obs
set rate_patient.clinical_history_weight_loss_greater_than_ten_percent= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=5339 and voided=0;

/*Febre prolongada*/
update rate_patient,obs
set rate_patient.clinical_history_prolonged_fever= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=5027 and voided=0;

/* Tosse prolongada*/
update rate_patient,obs
set rate_patient.clinical_history_prolonged_cough= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1429 and voided=0;

/* Estado Geral*/
update rate_patient,obs
set rate_patient.general_status= case obs.value_coded
             when 1383 then 'GOOD'
             when 1384 then 'MODERATE'
             when 1385 then 'BAD'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1382 and voided=0;


/* Mulher Gravida */
update rate_patient,encounter,obs
set rate_patient.pregnancy= case obs.value_coded
             when 44 then 'YES'
             when 1066 then 'NO'
             when 1175 then 'N/A'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1982 and obs.voided=0  and encounter.voided=0
and encounter.encounter_type in(1,5) and encounter.encounter_datetime=obs.obs_datetime 
and obs.person_id=encounter.patient_id;


/* Mulher Gravida - Semanas Gestacao */
update rate_patient,encounter,obs
set rate_patient.pregnancy= 'YES'
where obs.person_id=rate_patient.patient_id and obs.concept_id=1279 and obs.voided=0 and encounter.voided=0 and rate_patient.pregnancy is null
and encounter.encounter_type in(1,5) and encounter.encounter_datetime=obs.obs_datetime 
and obs.person_id=encounter.patient_id;



/* Mulher Gravida - Data Prevista*/
update rate_patient,encounter,obs
set rate_patient.pregnancy= 'YES'
where obs.person_id=rate_patient.patient_id and obs.concept_id=1600 and obs.voided=0 and encounter.voided=0 and rate_patient.pregnancy is null
and encounter.encounter_type in(1,5) and encounter.encounter_datetime=obs.obs_datetime 
and obs.person_id=encounter.patient_id;

/*Peso*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089 and e.location_id=location
  group by p.patient_id
)peso,obs
set rate_patient.weight=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*Altura*/
update rate_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 and e.location_id=location
  group by p.patient_id
)altura,obs
set rate_patient.height=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*IMC*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=1342 and e.location_id=location 
  group by p.patient_id
)imc,obs
set rate_patient.imc=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=imc.patient_id 
and obs.voided=0 and obs.obs_datetime=imc.encounter_datetime
and obs.concept_id=1342 ;


/*Pesao 1*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5085 and e.location_id=location
  group by p.patient_id
)blood_pressure_sys,obs
set rate_patient.blood_pressure_at_screening_systolic=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=blood_pressure_sys.patient_id 
and obs.voided=0 and obs.obs_datetime=blood_pressure_sys.encounter_datetime
and obs.concept_id=5085 ;


/*Presao 2*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5086  and e.location_id=location 
  group by p.patient_id
)blood_pressure_dysys,obs
set rate_patient.blood_pressure_at_screening_diastolic=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=blood_pressure_dysys.patient_id 
and obs.voided=0 and obs.obs_datetime=blood_pressure_dysys.encounter_datetime
and obs.concept_id=5086;


/*HEMOGLOBINA */
update rate_patient,
(   select  p.patient_id,
      min(encounter_datetime) encounter_datetime      
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
      and o.concept_id=1692 and e.location_id=location 
  group by p.patient_id
)hemoglobin,
obs 
set rate_patient.hemoglobin=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=hemoglobin.patient_id 
and obs.voided=0 and obs.obs_datetime=hemoglobin.encounter_datetime
 and obs.concept_id=1692 ;


/*GLICEMIA */
update rate_patient,
( select  p.patient_id, min(encounter_datetime) encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=887 and e.location_id=location 
  group by p.patient_id
)glycemic, obs

set rate_patient.glycemic=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=glycemic.patient_id 
and obs.voided=0 and obs.obs_datetime=glycemic.encounter_datetime
and obs.concept_id=887 ;



/*ITS */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=6258 and e.location_id=location 
  group by p.patient_id
)its, obs
set  rate_patient.sti_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=its.patient_id 
and obs.voided=0 and obs.obs_datetime=its.encounter_datetime
and obs.concept_id=6258 ;


/*TB */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=6257 and e.location_id=location 
  group by p.patient_id
)tb, obs
set rate_patient.tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id=6257 ;


/*FOI ACONSEHLADO ARV */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient  p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=1714 and e.location_id=location 
  group by p.patient_id
)advise, obs
set rate_patient.it_was_advised_to_start_ART=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=advise.patient_id 
and obs.voided=0 and obs.obs_datetime=advise.encounter_datetime
and obs.concept_id=1714;

/*ESTADIO OMS */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356  and e.location_id=location
  group by p.patient_id
)stage, obs
set rate_patient.who_stage_of_patient=if(obs.value_coded=1204,'I',if(obs.value_coded=1205,'II',if(obs.value_coded=1206,'III','IV')))
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=stage.patient_id 
and obs.voided=0 and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/*PRIMEIRO TIPO DE ARV NO PRIMEIRO FILA */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=18 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=1088 and e.location_id=location
  group by p.patient_id
)firt_arv,obs
set rate_patient.type_of_therapy= case obs.value_coded     
         WHEN 6324 THEN  'TDF+3TC+EFV'
         WHEN 1651 THEN 'AZT+3TC+NVP'
         WHEN 1703 THEN 'AZT+3TC+EFV'  
         WHEN 6343 THEN 'TDF+3TC+NVP' 
         WHEN 792  THEN 'D4T+3TC+NVP' 
         WHEN 6103 THEN 'D4T+3TC+LPV/r' 
         WHEN 1827 THEN 'D4T+3TC+EFV' 
         WHEN 6102 THEN 'D4T+3TC+ABC' 
         WHEN 6116 THEN 'AZT+3TC+ABC' 
         WHEN 6100 THEN 'AZT+3TC+LPV/r'
         WHEN 6104 THEN 'ABC+3TC+EFV'
         WHEN 6106 THEN 'ABC+3TC+LPV/r'
         WHEN 6108 THEN 'TDF+3TC+LPV/r(2ª Linha)'
         WHEN 1314 THEN 'AZT+3TC+LPV/r(2ª Linha)'
         WHEN 1311 THEN 'ABC+3TC+LPV/r (2ª Linha)'
         WHEN 1315 THEN 'TDF+3TC+EFV (2ª Linha)'
         WHEN 6329 THEN 'TDF+3TC+RAL+DRV/r (3ª Linha)'
         WHEN 6330 THEN 'AZT+3TC+RAL+DRV/r (3ª Linha)'
         else null end
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=firt_arv.patient_id 
and obs.voided=0 and obs.obs_datetime=firt_arv.encounter_datetime
and obs.concept_id=1088;

/*NUMERO DE PILULAS AVIADAS NO PRIMEIRO FILA */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=18 and o.obs_datetime=e.encounter_datetime
   and o.concept_id=1715 and e.location_id=location
  group by p.patient_id
)number_of_tablets,obs
set rate_patient.number_of_tablets= obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=number_of_tablets.patient_id 
and obs.voided=0 and obs.obs_datetime=number_of_tablets.encounter_datetime
and obs.concept_id=1715;


/*DOSAGEM NO PRIMEIRO FILA*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=18 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=1711 and e.location_id=location
  group by p.patient_id
)number_of_tablets_daily,obs
set rate_patient.number_of_tablets_consumed_daily= obs.value_text
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=number_of_tablets_daily.patient_id 
and obs.voided=0 and obs.obs_datetime=number_of_tablets_daily.encounter_datetime
and obs.concept_id=1711;

/*PRIMEIRO CD4*/
update rate_patient,
( select  e.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=13 and 
          e.encounter_datetime and o.concept_id=5497 and e.location_id=location
          and encounter_datetime <=dataAvaliacao
  group by p.patient_id
)seguimento1,obs
set rate_patient.first_cd4=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=seguimento1.patient_id 
and obs.voided=0 and obs.obs_datetime=seguimento1.encounter_datetime
and obs.concept_id=5497;


/*ULTIMO CD4*/
update rate_patient,
( select  e.patient_id,
      max(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=13 and 
          e.encounter_datetime and o.concept_id=5497 and e.location_id=location
          and encounter_datetime <=dataAvaliacao
  group by p.patient_id
)seguimento2,obs
set rate_patient.last_cd4=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=seguimento2.patient_id 
and obs.voided=0 and obs.obs_datetime=seguimento2.encounter_datetime
and obs.concept_id=5497;

/*DATA DO ULTIMO LEVANTAMENTO*/
update rate_patient,
(   select  p.patient_id,max(encounter_datetime) as encounter_datetime
  from    patient p
      inner join encounter e on p.patient_id=e.patient_id
  where   encounter_type=18 and e.voided=0 and e.location_id=location
  and encounter_datetime <=dataAvaliacao
  group by p.patient_id
) ultimo
set rate_patient.last_art_pick_up_date=ultimo.encounter_datetime
where rate_patient.patient_id=ultimo.patient_id;

/*PRIMEIRA CARGA VIRAL*/
update rate_patient,
  ( Select  p.patient_id, min(e.encounter_datetime) encounter_datetime
    from  patient p 
        inner join encounter e on p.patient_id=e.patient_id 
        inner join obs o on o.encounter_id=e.encounter_id 
    where   e.voided=0 and o.voided=0  and e.location_id=location and e.encounter_type in (6,9,13) and o.concept_id=856 and encounter_datetime<=dataAvaliacao
    group by p.patient_id
  ) viral_load1,obs
set   rate_patient.first_viral_load=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=viral_load1.patient_id 
and obs.voided=0 and obs.obs_datetime=viral_load1.encounter_datetime
and obs.concept_id=856;

/*SEGUNDA CARGA VIRAL*/
update rate_patient,
  ( Select  p.patient_id, max(e.encounter_datetime) encounter_datetime
    from  patient p 
        inner join encounter e on p.patient_id=e.patient_id 
        inner join obs o on o.encounter_id=e.encounter_id 
    where   e.voided=0 and o.voided=0  and e.location_id=location and e.encounter_type in (6,9,13) and o.concept_id=856 and encounter_datetime<=dataAvaliacao
    group by p.patient_id
  ) viral_load2,obs
set   rate_patient.last_viral_load=obs.value_numeric
where rate_patient.patient_id=obs.person_id 
and rate_patient.patient_id=viral_load2.patient_id 
and obs.voided=0 and obs.obs_datetime=viral_load2.encounter_datetime
and obs.concept_id=856;

end
;;
DELIMITER ;


                                                                  