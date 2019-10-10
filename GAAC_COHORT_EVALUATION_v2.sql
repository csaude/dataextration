SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for cvgaac_patient
-- ----------------------------
DROP TABLE IF EXISTS `cvgaac_patient`;
CREATE TABLE `cvgaac_patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `marital_status` varchar(100) DEFAULT NULL,
  `education` varchar(100) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `partner_status` varchar(100) DEFAULT NULL,
  `hiv_entry_point` varchar(100) DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `last_clinic_visit` datetime DEFAULT NULL,
  `scheduled_clinic_visit` datetime DEFAULT NULL,
  `last_artpickup` datetime DEFAULT NULL,
  `scheduled_artpickp` datetime DEFAULT NULL,  
  `cd4_first_visit` decimal(10,0) DEFAULT NULL,
  `cd4_first_visit_date` datetime DEFAULT NULL,
  `bmi_art` decimal(10,0) DEFAULT NULL,
  `bmi_art_date` datetime DEFAULT NULL,
  `WHO_clinical_stage_at_enrollment` varchar(1) DEFAULT NULL,
  `pregnancy_status_at_enrollment` varchar(100) DEFAULT NULL,
  `date_consent_sms` datetime DEFAULT NULL,  
  `has_phone_number` varchar(100) DEFAULT NULL, 
  `weight_enrollment` double DEFAULT NULL,
  `weight_date` datetime DEFAULT NULL,
  `height_enrollment` double DEFAULT NULL,
  `tb_at_screening` varchar(255) DEFAULT NULL,
  `date_of_TB_medication_completion` datetime DEFAULT NULL,
  `height_date` datetime DEFAULT NULL,
  `pmtct_entry_date` datetime DEFAULT NULL,
  `pmtct_exit_date` datetime DEFAULT NULL,
  `prophylaxis_isoniazide` varchar(100) DEFAULT NULL,
  `prophylaxis_isoniazide_date` datetime DEFAULT NULL,
  `patient_status` varchar(225) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL,
  `tb_co_infected_at_time_of_enrollment` varchar(5) DEFAULT NULL,   
  `its_in_gaac` varchar(100) DEFAULT NULL,
  `gaac_start_date`datetime DEFAULT NULL,
  `gaac_end_date` datetime DEFAULT NULL,
  `gaac_identifier` varchar(225) DEFAULT NULL,
   PRIMARY KEY (`id`),
   KEY `cvgaac_patient_patient_id` (`patient_id`),
   KEY `cvgaac_patient_enrollment_date` (`enrollment_date`),
   KEY `cvgaac_patient_art_initiation_date` (`art_initiation_date`),
   KEY `cvgaac_patient_enrolled_gaac_start_date` (`gaac_start_date`),
   KEY `cvgaac_patient_enrolled_gaac_end_date` (`gaac_end_date`), 
   KEY `cvgaac_patient_enrolled_pmtct_start_date` (`pmtct_entry_date`),
   KEY `cvgaac_patient_enrolled_pmtct_end_date` (`pmtct_exit_date`),
   KEY `cvgaac_patient_enrolled_last_clinic_visit` (`last_clinic_visit`),  
   KEY `cvgaac_patient_enrolled_scheduled_clinic_visit` (`scheduled_clinic_visit`), 
   KEY `cvgaac_patient_enrolled_last_artpickup` (`last_artpickup`),  
   KEY `cvgaac_patient_enrolled_scheduled_artpickp` (`scheduled_artpickp`)   
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cvgaac_cv
-- ----------------------------
DROP TABLE IF EXISTS `gaac_cv`;
CREATE TABLE `gaac_cv` (
  `patient_id` int(11) DEFAULT NULL,
  `cv` decimal(12,2) DEFAULT NULL,
  `cv_date` datetime DEFAULT NULL,
  KEY `patient_id` (`patient_id`),
  KEY `cv_date` (`cv_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `gaac_cd4`;
CREATE TABLE `gaac_cd4` (
  `patient_id` int(11) DEFAULT NULL,
  `cd4` double DEFAULT NULL,
  `cd4_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `cd4_date` (`cd4_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `gaac_art_pick_up`;
CREATE TABLE `gaac_art_pick_up` (
  `patient_id` int(11) DEFAULT NULL,
  `regime` varchar(255) DEFAULT NULL,
  `art_date` datetime DEFAULT NULL,
  `next_art_date` datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `art_date` (`art_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `gaac_visit`;
CREATE TABLE `gaac_visit` (
  `patient_id` int(11) DEFAULT NULL,
  `visit_date`   datetime DEFAULT NULL,
  `next_visit_date`   datetime DEFAULT NULL,
   KEY `patient_id` (`patient_id`),
   KEY `visit_date` (`visit_date`),
   KEY `next_visit_date` (`next_visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Procedure structure for FillTCVGAACTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillTCVGAACTable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillTCVGAACTable`(startDate date,endDate date,dataAvaliacao date, district varchar(100)) 

READS SQL DATA
begin

truncate table cvgaac_patient;
truncate table gaac_cd4;
truncate table gaac_art_pick_up;
truncate table gaac_visit;
truncate table gaac_cv;


insert into cvgaac_patient(patient_id, sex, birth_date, enrollment_date,age_enrollment,art_initiation_date, location_id)

select inicio.patient_id, pe.gender, pe.birthdate, abertura.data_abertura, round(datediff(abertura.data_abertura,pe.birthdate)/360) idade, inicio.data_inicio, pid.location_id 

from
	
(Select patient_id,min(data_inicio) data_inicio
		from
			(	
				-- leva a primeira ocorrencia do conceito 1255: Gestão de TARV e que a resposta foi 1256: Inicio
				Select 	p.patient_id,min(e.encounter_datetime) data_inicio
				from 	patient p
						inner join encounter e on p.patient_id=e.patient_id
						inner join obs o on o.encounter_id=e.encounter_id
				where 	e.voided=0 and o.voided=0 and p.voided=0 and
						e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and
						e.encounter_datetime<=endDate
				group by p.patient_id

				union
				
				-- leva a primeira ocorrencia do conceito 1190: Data de Inicio de TARV
				Select 	p.patient_id,min(value_datetime) data_inicio
				from 	patient p
						inner join encounter e on p.patient_id=e.patient_id
						inner join obs o on e.encounter_id=o.encounter_id
				where 	p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and
						o.concept_id=1190 and o.value_datetime is not null and
						o.value_datetime<=endDate
				group by p.patient_id

				union

				-- leva a primeira ocorrencia da inscricao do paciente no programa de Tratamento ARV
				select 	pg.patient_id,date_enrolled data_inicio
				from 	patient p inner join patient_program pg on p.patient_id=pg.patient_id
				where 	pg.voided=0 and p.voided=0 and program_id=2 and date_enrolled<=endDate

				union
				
				-- Leva a data do primeiro levantamento de ARV para cada paciente: Data do primeiro Fila do paciente
				  SELECT 	e.patient_id, MIN(e.encounter_datetime) AS data_inicio
				  FROM 		patient p
							inner join encounter e on p.patient_id=e.patient_id
				  WHERE		p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=endDate
				  GROUP BY 	p.patient_id
			) inicio_real
		group by patient_id
)inicio

inner join
(
 
SELECT e.patient_id, min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,7)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id
) 
abertura on inicio.patient_id=abertura.patient_id

left join 

(	select pid1.*
	from patient_identifier pid1
	inner join 
		(
			select patient_id,min(patient_identifier_id) id 
			from patient_identifier
			where voided=0
			group by patient_id
		) pid2
	where pid1.patient_id=pid2.patient_id and pid1.patient_identifier_id=pid2.id
) pid on pid.patient_id=inicio.patient_id

inner join person pe on pe.person_id=inicio.patient_id

where inicio.data_inicio between startDate and endDate and round(datediff(abertura.data_abertura,pe.birthdate)/360)>=15;		

-- delete from cvgaac_patient where art_initiation_date < startDate;

update cvgaac_patient,location
set cvgaac_patient.health_facility=location.name
where cvgaac_patient.location_id=location.location_id;

update cvgaac_patient set urban='N';

update cvgaac_patient set main='N';

if district='Quelimane' then
	update cvgaac_patient set urban='Y'; 
end if;

if district='Namacurra' then
	update cvgaac_patient set main='Y' where location_id=5; 
end if;

if district='Maganja' then
	update cvgaac_patient set main='Y' where location_id=15; 
end if;

if district='Pebane' then
	update cvgaac_patient set main='Y' where location_id=16; 
end if;

if district='Gile' then
	update cvgaac_patient set main='Y' where location_id=6; 
end if;

if district='Molocue' then
	update cvgaac_patient set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
	update cvgaac_patient set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
	update cvgaac_patient set main='Y' where location_id=7; 
end if;

if district='Ile' then
	update cvgaac_patient set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
	update cvgaac_patient set main='Y' where location_id in (252);
end if;

/*UPDATE CODPROVENIENCIA*/
update cvgaac_patient,
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
    where   o.voided=0 and o.concept_id=1594 and e.encounter_type in (5,7) and e.voided=0
    ) proveniencia
set cvgaac_patient.hiv_entry_point=proveniencia.codProv
where proveniencia.patient_id=cvgaac_patient.patient_id;


/*ESTADO CIVIL*/
update cvgaac_patient,obs
set cvgaac_patient.marital_status= case obs.value_coded
					   when 1057 then 'SINGLE'
					   when 5555 then 'MARRIED'
					   when 1059 then 'WIDOWED'
					   when 1060 then 'LIVING WITH PARTNER'
					   when 1056 then 'SEPARATED'
					   when 1058 then 'DIVORCED'
					   else null end
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=1054 and obs.voided=0;	

/*ESCOLARIDADE*/
update cvgaac_patient,obs
set cvgaac_patient.education= case obs.value_coded 
             when 1445 then 'NONE'
             when 1446 then 'PRIMARY SCHOOL'
             when 1447 then 'SECONDARY SCHOOL'
             when 6124 then 'TECHNICAL SCHOOL'
             when 1444 then 'SECONDARY SCHOOL'
             when 6125 then 'TECHNICAL SCHOOL'
             when 1448 then 'UNIVERSITY'
          else null end
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=1443 and voided=0;

/*PROFISSAO*/
update cvgaac_patient,obs
set cvgaac_patient.occupation= obs.value_text
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=1459 and voided=0;

/*ESTADO DO PARCEIRO*/
update cvgaac_patient,obs
set cvgaac_patient.partner_status= case obs.value_coded
             when 1169 then 'HIV INFECTED'
             when 1066 then 'NO'
             when 1457 then 'NO INFORMATION'
             else null end
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=1449 and obs.voided=0;

/*ESTADIO OMS */
update cvgaac_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type in(6,9) and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=5356
  group by p.patient_id
)stage, obs
set cvgaac_patient.WHO_clinical_stage_at_enrollment=if(obs.value_coded=1204,'I',if(obs.value_coded=1205,'II',if(obs.value_coded=1206,'III','IV')))
where cvgaac_patient.patient_id=obs.person_id 
and cvgaac_patient.patient_id=stage.patient_id 
and obs.voided=0 and obs.obs_datetime=stage.encounter_datetime
and obs.concept_id=5356;


/*PREGNANCY STATUS AT TIME OF ART ENROLLMENT*/
update cvgaac_patient,obs
set cvgaac_patient.pregnancy_status_at_enrollment= if(obs.value_coded=44,'YES',null)
where cvgaac_patient.patient_id=obs.person_id and obs.concept_id=1982 and obs.obs_datetime=cvgaac_patient.enrollment_date;

update cvgaac_patient,obs
set cvgaac_patient.pregnancy_status_at_enrollment= if(obs.value_numeric is not null,'YES',null)
where cvgaac_patient.patient_id=obs.person_id and obs.concept_id=1279 and obs.obs_datetime=cvgaac_patient.enrollment_date and cvgaac_patient.pregnancy_status_at_enrollment is null;


update cvgaac_patient,patient_program
set cvgaac_patient.pregnancy_status_at_enrollment= 'YES'
where cvgaac_patient.patient_id=patient_program.patient_id and program_id=8 and  voided=0 and pregnancy_status_at_enrollment is null;


/*TB PULMONARAT TIME OF ART ENROLLMENT*/
update cvgaac_patient,obs
set cvgaac_patient.tb_co_infected_at_time_of_enrollment= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=42 and voided=0;


/*TB EXTRA PULMONAR AT TIME OF ART ENROLLMENT */
update cvgaac_patient,obs
set cvgaac_patient.tb_co_infected_at_time_of_enrollment= case obs.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end
where obs.person_id=cvgaac_patient.patient_id and obs.concept_id=5042 and
 voided=0 AND cvgaac_patient.tb_co_infected_at_time_of_enrollment is null ;


 /*PESO AT TIME OF ART ENROLLMENT*/
update cvgaac_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime,
      o.value_numeric
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 
  and o.obs_datetime=e.encounter_datetime and o.concept_id=5089
  group by p.patient_id
)peso,obs
set cvgaac_patient.weight_enrollment=obs.value_numeric, cvgaac_patient.weight_date=peso.encounter_datetime
where cvgaac_patient.patient_id=obs.person_id 
and cvgaac_patient.patient_id=peso.patient_id 
and obs.voided=0 and obs.obs_datetime=peso.encounter_datetime
and obs.concept_id=5089;

/*ALTURA AT TIME OF ART ENROLLMENT*/
update cvgaac_patient,
( select  p.patient_id as patient_id,
      min(encounter_datetime) encounter_datetime
      from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=1 and o.obs_datetime=e.encounter_datetime and o.concept_id=5090 
  group by p.patient_id
)altura,obs
set cvgaac_patient.height_enrollment=obs.value_numeric, cvgaac_patient.height_date=altura.encounter_datetime
where cvgaac_patient.patient_id=obs.person_id 
and cvgaac_patient.patient_id=altura.patient_id 
and obs.voided=0 and obs.obs_datetime=altura.encounter_datetime
and obs.concept_id=5090;


/*HAS PHONE NUMBER*/		
update 	cvgaac_patient,person_attribute
set 	has_phone_number='Y'
where 	patient_id=person_id and person_attribute_type_id=9 and voided=0 and value is not null and length(value)>=9;

/*SMS CONSENT DATE*/		
update 	cvgaac_patient,obs
set 	date_consent_sms=obs_datetime
where 	cvgaac_patient.patient_id=person_id and 
		concept_id=6309 and value_coded=6307 and voided=0;

update cvgaac_patient, patient_program
	set cvgaac_patient.pmtct_entry_date=date_enrolled
	where voided=0 and program_id=8 and cvgaac_patient.patient_id=patient_program.patient_id;


update cvgaac_patient, patient_program
	set cvgaac_patient.pmtct_exit_date=date_completed
	where voided=0 and program_id=8 and cvgaac_patient.patient_id=patient_program.patient_id;

/*TB */
update cvgaac_patient,
( select  p.patient_id,
      min(encounter_datetime) encounter_datetime
  from  patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.encounter_id=e.encounter_id
  where   e.voided=0 and e.encounter_type=6 and o.obs_datetime=e.encounter_datetime 
  and o.concept_id=6257
  group by p.patient_id
)tb, obs
set cvgaac_patient.tb_at_screening=if(obs.value_coded=1065,'YES',if(obs.value_coded=1066,'NO',null))
where cvgaac_patient.patient_id=obs.person_id 
and cvgaac_patient.patient_id=tb.patient_id 
and obs.voided=0 and obs.obs_datetime=tb.encounter_datetime
and obs.concept_id=6257 ;

 /*DATA FIM DA MEDICACAO DE TB DATE*/   
update cvgaac_patient,
    (select 
         p.patient_id,
         e.encounter_datetime,
         o.value_datetime
    from  cvgaac_patient p 
        inner join encounter e on e.patient_id=p.patient_id
        inner join obs o on o.encounter_id=e.encounter_id
    where   o.voided=0 and o.concept_id=6120 and e.encounter_type in (6,9) and e.voided=0 AND o.obs_datetime  < dataAvaliacao
    ) tb
set cvgaac_patient.date_of_TB_medication_completion= tb.value_datetime
where tb.patient_id=cvgaac_patient.patient_id;

/*VISITAS*/
insert into gaac_visit(patient_id,visit_date)
Select distinct p.patient_id,e.encounter_datetime 
from  cvgaac_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
where   e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime between startDate and dataAvaliacao;

/* PROXIMA VISITAS*/
update gaac_visit,obs 
set  gaac_visit.next_visit_date=obs.value_datetime
where   gaac_visit.patient_id=obs.person_id and
    gaac_visit.visit_date=obs.obs_datetime and 
    obs.concept_id=1410 and 
    obs.voided=0;

    /*LEVANTAMENTO ARV*/
insert into gaac_art_pick_up(patient_id,regime,art_date)
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
  from  cvgaac_patient p
      inner join encounter e on p.patient_id=e.patient_id
      inner join obs o on o.person_id=e.patient_id
  where   encounter_type=18 and o.concept_id=1088  and e.voided=0 
  and p.patient_id=o.person_id  and e.encounter_datetime=o.obs_datetime  and o.obs_datetime between startDate and dataAvaliacao;

/*PROXIMO LEVANTAMENTO*/
update gaac_art_pick_up,obs 
set  gaac_art_pick_up.next_art_date=obs.value_datetime
where   gaac_art_pick_up.patient_id=obs.person_id and
    gaac_art_pick_up.art_date=obs.obs_datetime and 
    obs.concept_id=5096 and 
    obs.voided=0;

    /*CD4*/
insert into gaac_cd4(patient_id,cd4,cd4_date)
Select distinct p.patient_id,o.value_numeric, o.obs_datetime
from  cvgaac_patient p 
    inner join encounter e on p.patient_id=e.patient_id 
    inner join obs o on o.encounter_id=e.encounter_id
where   e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=5497   and o.obs_datetime   between startDate and dataAvaliacao;

/*CARGA VIRAL*/
insert into gaac_cv(patient_id,cv,cv_date)
Select distinct	p.patient_id,
		o.value_numeric,
		o.obs_datetime
from 	cvgaac_patient p 
		inner join encounter e on p.patient_id=e.patient_id	
		inner join obs o on o.encounter_id=e.encounter_id
where 	e.voided=0 and o.voided=0 and e.encounter_type=13 and o.concept_id=856 and o.obs_datetime   between startDate and dataAvaliacao;


update cvgaac_patient set cvgaac_patient.its_in_gaac='YES' where cvgaac_patient.patient_id in (select member_id from gaac_member);

/*GAAC START DATE*/
update cvgaac_patient,gaac_member set cvgaac_patient.gaac_start_date=gaac_member.start_date where gaac_member.member_id=cvgaac_patient.patient_id ;

/*GAAC END DATE*/
update cvgaac_patient,gaac_member set cvgaac_patient.gaac_end_date=gaac_member.end_date where gaac_member.member_id=cvgaac_patient.patient_id; 

	/*GAAC END DATE*/
update cvgaac_patient,gaac_member, gaac set cvgaac_patient.gaac_identifier=gaac.gaac_identifier where gaac_member.member_id=cvgaac_patient.patient_id and gaac_member.gaac_id=gaac.gaac_id; 


update cvgaac_patient,(
Select 	p.patient_id,min(o.obs_datetime) datainh,case o.value_coded
             when 1065 then 'YES'
             when 1066 then 'NO'
             else null end as code
		from 	cvgaac_patient p
				inner join encounter e on p.patient_id=e.patient_id
				inner join obs o on e.encounter_id=o.encounter_id
		where     e.voided=0 and o.voided=0 and e.encounter_type in (13,6,9) and  o.concept_id=6122 
		group by p.patient_id ) seg  
set cvgaac_patient.prophylaxis_isoniazide=seg.code, cvgaac_patient.prophylaxis_isoniazide_date=seg.datainh
where seg.patient_id=cvgaac_patient.patient_id;


 /*ESTADO ACTUAL TARV*/
update cvgaac_patient,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  cvgaac_patient p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and ps.start_date < dataAvaliacao
    ) out_state
set   cvgaac_patient.patient_status=out_state.codeestado, cvgaac_patient.patient_status_date=out_state.start_date
where cvgaac_patient.patient_id=out_state.patient_id;


/*LAST CLINIC VISIT*/
update cvgaac_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type in (6,9) and e.encounter_datetime  < dataAvaliacao
	group by p.patient_id
)seguimento
set cvgaac_patient.last_clinic_visit=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;


/*NEXT CLINIC VISIT*/
update 	cvgaac_patient,obs
set 	scheduled_clinic_visit=value_datetime
where 	patient_id=person_id and 
		obs_datetime=last_clinic_visit and 
		concept_id=5096 and voided=0;

/*CD4  FIRST VISIT */
update cvgaac_patient,
(	select 	e.patient_id,
			min(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type=13 and 
			e.encounter_datetime between enrollment_date and date_add(enrollment_date, interval 6 month) and o.concept_id=5497
	group by p.patient_id
)seguimento
set cvgaac_patient.cd4_first_visit_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.cd4_first_visit=obs.value_numeric
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.cd4_first_visit_date and obs.concept_id=5497 and obs.voided=0;

/*BMI  FIRST VISIT */
update cvgaac_patient,
(	select 	e.patient_id,
			min(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and e.encounter_type in (6,9) and 
			e.encounter_datetime <=p.art_initiation_date and o.concept_id=1342 and 
			p.art_initiation_date is not null
	group by p.patient_id
)seguimento
set cvgaac_patient.bmi_art_date=seguimento.encounter_datetime
where cvgaac_patient.patient_id=seguimento.patient_id;

update 	cvgaac_patient,obs 
set 	cvgaac_patient.bmi_art=obs.value_numeric
where 	cvgaac_patient.patient_id=obs.person_id and obs.obs_datetime=cvgaac_patient.bmi_art_date and obs.concept_id=1342 and obs.voided=0;


/*LAST ART PICKUP*/
update cvgaac_patient,
(	select 	p.patient_id,
			max(encounter_datetime) encounter_datetime
	from 	cvgaac_patient p
			inner join encounter e on p.patient_id=e.patient_id
	where 	e.voided=0 and e.encounter_type=18 and e.encounter_datetime  < dataAvaliacao
	group by p.patient_id
)levantamento
set cvgaac_patient.last_artpickup=levantamento.encounter_datetime
where cvgaac_patient.patient_id=levantamento.patient_id;

update 	cvgaac_patient,obs
set 	scheduled_artpickp=value_datetime
where 	patient_id=person_id and 
		obs_datetime=last_artpickup and 
		concept_id=5096 and voided=0;

end
;;
DELIMITER ;
