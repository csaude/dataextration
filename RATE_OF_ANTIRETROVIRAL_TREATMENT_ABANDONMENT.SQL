SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `rate_patient` (
  `patient_id` int(11) DEFAULT NULL,
  `enrollment_date`datetime DEFAULT NULL,
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
  `time_from_diagnosis_to_the_start_of_ART` int(11)  DEFAULT NULL,
  `date_of_the_last_ARV_therapy_withdrawal` datetime DEFAULT NULL,
  `first_viral_load` int(11)  DEFAULT NULL,
  `last_viral_load` int(11)  DEFAULT NULL,
  `location_id` int(11)  DEFAULT NULL

) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;




-- ----------------------------
-- Procedure structure for FillRate
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillRate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillRate`(startDate date,endDate date,district varchar(100))
    READS SQL DATA
begin
truncate table rate_patient;

/*ADULTOS QUE INICIARAM O TARV NUM DETERMINADO PERIUDO*/
insert into rate_patient(patient_id,enrollment_date)
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
AND e.encounter_datetime <= '2018-12-31'
AND e.location_id = 401
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
AND o.value_datetime <= '2018-12-31'
AND e.location_id = 401
GROUP BY p.patient_id

UNION

SELECT pg.patient_id, date_enrolled data_inicio
FROM patient p
INNER JOIN patient_program pg
  ON p.patient_id = pg.patient_id
WHERE pg.voided = 0
AND p.voided = 0
AND program_id = 2
AND date_enrolled <= '2018-12-31'
AND location_id = 401

UNION

SELECT e.patient_id, MIN(e.encounter_datetime) AS data_inicio
FROM patient p
INNER JOIN encounter e
  ON p.patient_id = e.patient_id
WHERE p.voided = 0
AND e.encounter_type = 18
AND e.voided = 0
AND e.encounter_datetime <= '2018-12-31'
AND e.location_id = 401
GROUP BY p.patient_id) inicio
GROUP BY patient_id) inicio1 WHERE  data_inicio BETWEEN '2015-01-01' AND '2016-12-31';



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
update rate_patient,openmrs.obs
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

/* Mulher Gravida*/
update rate_patient,obs
set rate_patient.pregnancy= case obs.value_coded
             when 44 then 'YES PREGNANCY GESTATION'
             when 1066 then 'NO'
             when 1175 then 'N/A'
             else null end
where obs.person_id=rate_patient.patient_id and obs.concept_id=1982 and voided=0;

/*Peso*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso
set rate_patient.weight=peso.value_numeric
where rate_patient.patient_id=peso.patient_id;

/*Altura*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090
  group by p.patient_id
)altura
set rate_patient.height=altura.value_numeric
where rate_patient.patient_id=altura.patient_id;


/*IMC*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=1342
  group by p.patient_id
)imc
set rate_patient.imc=imc.value_numeric
where rate_patient.patient_id=imc.patient_id;


/*Pesao 1*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5085
  group by p.patient_id
)blood_pressure_sys
set rate_patient.blood_pressure_at_screening_systolic=blood_pressure_sys.value_numeric
where rate_patient.patient_id=blood_pressure_sys.patient_id;


/*Presao 2*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5086
  group by p.patient_id
)blood_pressure_dysys
set rate_patient.blood_pressure_at_screening_diastolic=blood_pressure_dysys.value_numeric
where rate_patient.patient_id=blood_pressure_dysys.patient_id;

/*HEMOGLOBINA */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=1692 and o.concept_id is not null
  group by p.patient_id
)hemoglobin
set rate_patient.hemoglobin=hemoglobin.value_numeric
where rate_patient.patient_id=hemoglobin.patient_id;


/*GLICEMIA */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=887 and o.concept_id is not null
  group by p.patient_id
)glycemic
set rate_patient.glycemic=glycemic.value_numeric
where rate_patient.patient_id=glycemic.patient_id;

/*ITS */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_coded
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=6258 and o.concept_id is not null
  group by p.patient_id
)its
set rate_patient.sti_at_screening=if(its.value_coded=1065,'YES',if(its.value_coded=1066,'NO',null))
where rate_patient.patient_id=its.patient_id;


/*TB */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_coded
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=6257 and o.concept_id is not null
  group by p.patient_id
)tb
set rate_patient.tb_at_screening=if(tb.value_coded=1065,'YES',if(tb.value_coded=1066,'NO',null))
where rate_patient.patient_id=tb.patient_id;

/*FOI ACONSEHLADO ARV */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_coded
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=1714 and o.concept_id is not null
  group by p.patient_id
)advise
set rate_patient.it_was_advised_to_start_ART=if(advise.value_coded=1065,'YES',if(advise.value_coded=1066,'NO',null))
where rate_patient.patient_id=advise.patient_id;


/*ESTADIO OMS */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_coded
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime and o.concept_id=5356 and o.concept_id is not null
  group by p.patient_id
)stage
set rate_patient.who_stage_of_patient=if(stage.value_coded=1204,'I',if(stage.value_coded=1205,'II',if(stage.value_coded=1206,'III','IV')))
where rate_patient.patient_id=stage.patient_id;

/*PRIMEIRO TIPO DE ARV NO PRIMEIRO FILA */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_coded
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=18 and o.obs_datetime=e.encounter_datetime and o.concept_id=1088 and o.concept_id is not null
  group by p.patient_id
)firt_arv
set rate_patient.type_of_therapy= case firt_arv.value_coded     
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
where rate_patient.patient_id=firt_arv.patient_id;


/*NUMERO DE PILULAS AVIADAS NO PRIMEIRO FILA */
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=18 and o.obs_datetime=e.encounter_datetime and o.concept_id=1715 and o.concept_id is not null
  group by p.patient_id
)number_of_tablets
set rate_patient.number_of_tablets= number_of_tablets.value_numeric
where rate_patient.patient_id=number_of_tablets.patient_id;


/*DOSAGEM NO PRIMEIRO FILA*/
update rate_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_text
  from  rate_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=18 and o.obs_datetime=e.encounter_datetime and o.concept_id=1711 and o.concept_id is not null
  group by p.patient_id
)number_of_tablets_daily
set rate_patient.number_of_tablets_consumed_daily= number_of_tablets_daily.value_text
where rate_patient.patient_id=number_of_tablets_daily.patient_id;


end
;;
DELIMITER ;


                                                                  