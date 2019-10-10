SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `icap_harmonization_logs`;
CREATE TABLE `icap_harmonization_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name`  varchar(100) DEFAULT NULL,
  `original_reference`  int DEFAULT NULL,
  `original_value`  int DEFAULT NULL,
  `new_reference`  int DEFAULT NULL,
  `new_value`  int DEFAULT NULL,
  `reference_uuid`  varchar(255) NOT NULL UNIQUE,
   KEY `id` (`id`),
   KEY `table_name` (`table_name`),
   KEY `original_reference` (`original_reference`),
   KEY `original_value` (`original_value`),
   KEY `new_value` (`new_value`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP PROCEDURE IF EXISTS `IcapHarmonization`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IcapHarmonization`() 

READS SQL DATA
begin


/*DISPENSA TRIMESTRAL 6337*/

insert into icap_harmonization_logs(table_name, original_reference,original_value,reference_uuid,new_reference,new_value) 
select 'program_workflow',program_workflow_id,concept_id,uuid,program_workflow_id, 23730 from program_workflow where program_workflow.concept_id=6337 and program_workflow.program_workflow_id=6;

update program_workflow set program_workflow.concept_id=23730 where program_workflow.concept_id=6337 and program_workflow.program_workflow_id=6;


/*CARGA VIRAL - MOTIVO DE VISITA 6341*/

insert into icap_harmonization_logs(table_name,original_reference,original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23912 from obs where obs.concept_id=2172 and obs.value_coded=6341;

update obs set obs.value_coded=23912 where obs.concept_id=2172 and obs.value_coded=6341;


/*ACOMPANHAMENTO FÍSICO ATÉ A RESIDÊNCIA NO DIA DA INSCRIÇÃO 6366*/

insert into icap_harmonization_logs(table_name,original_reference,reference_uuid,new_reference) 
	select 'obs',concept_id,uuid,23917 from obs where concept_id=6366;

update obs set obs.concept_id=23917 where obs.concept_id=6366;



/*AZT+3TC+ATV/r 6360*/

insert into icap_harmonization_logs(table_name,original_reference,original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23793 from obs  where obs.value_coded=6360 and concept_id in (1088,1087);

update obs set obs.value_coded=23793 where obs.value_coded=6360 and concept_id in (1088,1087);



/*TDF+3TC+ATV/r 6359*/

insert into icap_harmonization_logs(table_name,original_reference,original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23791 from obs  where obs.value_coded=6359 and concept_id in (1088,1087);

update obs set obs.value_coded=23791 where obs.value_coded=6359 and concept_id in (1088,1087);



/*MDC - DISPENSA TRIMESTRAL 6349*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'program', program_id, concept_id,uuid,program_id,23918 from program where program.program_id=10 and program.concept_id=6349;

update program set program.concept_id=23918 where program.program_id=10 and program.concept_id=6349;


/*ABC+3TC+ATV/r 6361*/

insert into icap_harmonization_logs(table_name,original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23792 from obs  where obs.value_coded=6361 and concept_id in (1088,1087);

update obs set obs.value_coded=23792 where obs.value_coded=6361 and concept_id in (1088,1087);



/*NUMERO DA FICHA DE VISITA DOMICILIAR 6338*/

insert into icap_harmonization_logs(table_name,original_reference,reference_uuid,new_reference) 
	select 'obs',concept_id,uuid,23919 from  obs  where obs.concept_id=6338;

update obs set obs.concept_id=23919 where obs.concept_id=6338;



/*DISPENSA TRIMESTRAL E CONSULTA SEMESTRAL 6357*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
select 'program_workflow',program_workflow_id,concept_id,uuid,program_workflow_id,23920 from program_workflow where program_workflow.concept_id=6357 and program_workflow.program_workflow_id=9;

update program_workflow set program_workflow.concept_id=23920 where program_workflow.concept_id=6357 and program_workflow.program_workflow_id=9;



/*VISITA DE APOIO CASOS ESPECIAIS 6344*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23914 from  obs where obs.value_coded=6344 and obs.concept_id=1981;

update obs set obs.value_coded=23914 where obs.value_coded=6344 and obs.concept_id=1981;


/*ENCONTROU O PACIENTE 6348*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,2003 from obs where obs.value_coded=6348 and obs.concept_id in(1065,1066);

update obs set obs.value_coded=2003 where obs.value_coded=6348 and obs.concept_id in(1065,1066) ;


/*MDC - ABORDAGEM FAMILIAR 6351 */

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'program', program_id, concept_id,uuid,program_id,23922 from program where program.program_id=12 and program.concept_id=6351;

update program set program.concept_id=23922 where program.program_id=12 and program.concept_id=6351;


/*ABORDAGEM FAMILIAR 6353*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
select 'program_workflow',program_workflow_id,concept_id,uuid,program_workflow_id,23725 from program_workflow where program_workflow.concept_id=6353 and program_workflow.program_workflow_id=8;

update program_workflow set program_workflow.concept_id=23725 where program_workflow.concept_id=6353 and program_workflow.program_workflow_id=8;


/*CONTACTO DO INFORMANTE 6346*/

insert into icap_harmonization_logs(table_name, original_reference,reference_uuid,new_reference) 
	select 'obs',concept_id,uuid,23923 from obs where obs.concept_id=6346;

update obs set obs.concept_id=23923 where obs.concept_id=6346;


 /*SEM CARGA VIRAL 6339*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23910 from obs  where obs.value_coded=6339 and obs.concept_id=2172;

update obs set obs.value_coded=23910 where obs.value_coded=6339 and obs.concept_id=2172;


/*ALCUNHA DO PACIENTE 6343*/

insert into icap_harmonization_logs(table_name,original_reference,reference_uuid,new_reference) 
	select 'obs',concept_id,uuid,23924 from obs where  obs.concept_id=6343;

update obs set obs.concept_id=23924 where obs.concept_id=6343;


/*CODIGO DO VOLUNTARIO 6358*/

insert into icap_harmonization_logs(table_name, original_reference,reference_uuid,new_reference) 
	select 'obs',concept_id,uuid,23925 from obs where obs.concept_id=6358;

update obs set obs.concept_id=23925 where obs.concept_id=6358;


/*TDF+3TC+DTG 6362*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23784 from obs where  obs.value_coded=6362 and obs.concept_id in (1088,1087);

update obs set obs.value_coded=23784 where obs.value_coded=6362 and obs.concept_id in (1088,1087);


/*AUTO TRANSFERENCIA 6345*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23863 from obs where obs.value_coded=6345 and obs.concept_id=2016;

update obs set obs.value_coded=23863 where obs.value_coded=6345 and obs.concept_id=2016;



/*ACTIVO NO MDS 6354*/

insert into icap_harmonization_logs(table_name,original_reference,original_value,reference_uuid,new_reference,new_value) 
select 'program_workflow_state',program_workflow_state_id,concept_id,uuid,program_workflow_state_id,23926 from program_workflow_state 
where program_workflow_state.program_workflow_state_id in(33,35,37,39) and program_workflow_state.concept_id=6354;

update program_workflow_state set program_workflow_state.concept_id=23926 where program_workflow_state.program_workflow_state_id in(33,35,37,39) and program_workflow_state.concept_id=6354;


-- /*TDF+3TC+ABC 6363 Recomendando pelo CDC nao criar esse conceito*/

-- insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid) 
-- 	select 'obs',concept_id,value_coded,uuid from obs where obs.value_coded=6363 and obs.concept_id in (1088,1087);

-- update obs set obs.value_coded=NIW_ID where obs.value_coded=6363 and obs.concept_id in (1088,1087);

-- update icap_harmonization_logs,obs set new_reference=concept_id,new_value=value_coded where reference_uuid=uuid;


/*MDC - CONSULTA SEMESTRAL 6350*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'program',program_id,concept_id,uuid,program_id,23927 from program where program.program_id=11 and program.concept_id=6350;

update program set program.concept_id=23927 where program.program_id=11 and program.concept_id=6350;


/*MDC - DISPENSA TRIMESTRAL E CONSULTA SEMESTRAL 6356*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'program', program_id, concept_id,uuid,program_id,23928 from program where program.program_id=13 and program.concept_id=6356;

update program set program.concept_id=23928 where program.program_id=13 and program.concept_id=6356;


/*SAIU DESTE DMS 6355*/

insert into icap_harmonization_logs(table_name,original_reference,original_value,reference_uuid,new_reference,new_value) 
select 'program_workflow_state',program_workflow_state_id,concept_id,uuid,program_workflow_state_id,23929 from program_workflow_state 
where  program_workflow_state.program_workflow_state_id in(34,36,38,40) and program_workflow_state.concept_id=6355;

update program_workflow_state set program_workflow_state.concept_id=23929 where program_workflow_state.program_workflow_state_id in(34,36,38,40) and program_workflow_state.concept_id=6355;


/*RESPONSÁVEL DA BUSCA ACTIVA 6347: Confirmar se ICAP esta usar este conceito */

-- insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid) 
-- 	select 'obs',concept_id,value_text,uuid from obs where obs.concept_id=6347;

-- update obs set obs.concept_id=NIW_ID where obs.concept_id=6347;

-- update icap_harmonization_logs,obs set new_reference=concept_id,new_value=value_text where reference_uuid=uuid;


/*FALTOSO AS CONSULTAS 6340*/

insert into icap_harmonization_logs(table_name,original_reference, original_value,reference_uuid,new_reference,new_value) 
	select 'obs',concept_id,value_coded,uuid,concept_id,23911 from obs where obs.value_coded=6340 and obs.concept_id=2172;

update obs set obs.value_coded=23911 where obs.value_coded=6340 and obs.concept_id=2172;


/*ALCUNHA DO CONFIDENTE 6342*/

insert into icap_harmonization_logs(table_name,original_reference,reference_uuid,new_reference) 
	select 'obs',concept_id,uuid,23930 from obs where  obs.concept_id=6342;

update obs set obs.concept_id=23930 where obs.concept_id=6342;



/*CONSULTA SEMESTRAL 6352*/

insert into icap_harmonization_logs(table_name, original_reference, original_value,reference_uuid,new_reference,new_value) 
select 'program_workflow',program_workflow_id,concept_id,uuid,program_workflow_id,23931 from program_workflow where program_workflow.concept_id=6352 and program_workflow.program_workflow_id=7;

update program_workflow set program_workflow.concept_id=23931 where program_workflow.concept_id=6352 and program_workflow.program_workflow_id=7;

end
;;
DELIMITER ;


