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
  `clinical_history` varchar(100) DEFAULT NULL,
  `general_status` varchar(100) DEFAULT NULL,
  `pregnancy` varchar(11) DEFAULT NULL,
  `weight` int(11)  DEFAULT NULL,
  `height` int(11)  DEFAULT NULL,
  `imc` int(11)  DEFAULT NULL,
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

end
;;
DELIMITER ;


                                                                  