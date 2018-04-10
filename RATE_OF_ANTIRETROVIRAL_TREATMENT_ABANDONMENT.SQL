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
  `blood_pressure_at_screening_hemoglobin` int(11)  DEFAULT NULL,
  `glycemic` int(11)  DEFAULT NULL,
  `who_stage_of_patient` varchar(100) DEFAULT NULL,
  `sti_at_screening` varchar(100) DEFAULT NULL,
  `tb_at_screening` varchar(100) DEFAULT NULL,
  `it_was_advised_to_start_ART` varchar(50) DEFAULT NULL,
  `type_of_therapy` varchar(100) DEFAULT NULL,
  `number_of_tablets_consumed_daily` int(11)  DEFAULT NULL,
  `first_cd4` int(11)  DEFAULT NULL,
  `last_cd4` int(11)  DEFAULT NULL,
  `time_from_diagnosis_to_the_start_of_ART` int(11)  DEFAULT NULL,
  `date_of_the_last_ARV_therapy_withdrawal` datetime DEFAULT NULL,
  `first_viral_load` int(11)  DEFAULT NULL,
  `last_viral_load` int(11)  DEFAULT NULL,
  `location_id` int(11)  DEFAULT NULL

) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillTCVGAACTableV2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTCVGAACTableV2`(beforeARTStartDate date,startDate date,endDate date,district varchar(100))
    READS SQL DATA
begin
truncate table rate_patient;

/*Inscricao*/
insert into rate_patient(patient_id,enrollment_date,sex,age,location_id)
Select  e.patient_id,min(encounter_datetime) data_abertura,gender,round(datediff(e.encounter_datetime,pe.birthdate)/365) idade_abertura,e.location_id
from  openmrs.patient p     
    inner join openmrs.encounter e on e.patient_id=p.patient_id
    inner join openmrs.person pe on pe.person_id=p.patient_id     
where   p.voided=0 and e.encounter_type in (1,5) and e.voided=0 and pe.voided=0 and 
    e.encounter_datetime between startDate and endDate
group by p.patient_id;

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


end
;;
DELIMITER ;


                                                                  