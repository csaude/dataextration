select 	seguimento_sem_fila.patient_id,
		seguimento_sem_fila.data_seguimento,
		concat(ifnull(pn.given_name,''),' ',ifnull(pn.middle_name,''),' ',ifnull(pn.family_name,'')) nome,
		pid.identifier as nid
from
(
	select * from 
	(	
		SELECT distinct	p.patient_id, e.encounter_datetime AS data_seguimento 
		FROM 	patient p
				inner join encounter e on p.patient_id=e.patient_id
		WHERE	p.voided=0 and e.encounter_type in (6,9) AND e.voided=0 and 
				e.encounter_datetime between :startDate and :endDate and 
				e.location_id=:location
		ORDER BY 1,2
	) seguimento
	where not exists 
	(
		select * from
		(
			SELECT 	distinct p.patient_id, e.encounter_datetime AS data_fila 
			FROM 	patient p
					inner join encounter e on p.patient_id=e.patient_id
			WHERE	p.voided=0 and e.encounter_type=18 AND e.voided=0 and 
					e.encounter_datetime between :startDate and :endDate and 
					e.location_id=:location
			ORDER BY 1,2
		) fila
		where fila.patient_id=seguimento.patient_id and fila.data_fila between seguimento.data_seguimento and DATE_ADD(seguimento.data_seguimento, INTERVAL 7 DAY)
	)
) seguimento_sem_fila
inner join 
(	Select 	distinct p.patient_id
	from 	patient p 
			inner join encounter e on p.patient_id=e.patient_id	
			inner join obs o on o.encounter_id=e.encounter_id
	where 	e.voided=0 and o.voided=0 and p.voided=0 and 
			e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and 
			e.encounter_datetime<=:endDate and e.location_id=:location

	union

	Select 	distinct p.patient_id
	from 	patient p
			inner join encounter e on p.patient_id=e.patient_id
			inner join obs o on e.encounter_id=o.encounter_id
	where 	p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and 
			o.concept_id=1190 and o.value_datetime is not null and 
			o.value_datetime<=:endDate and e.location_id=:location

	union

	select 	distinct pg.patient_id
	from 	patient p inner join patient_program pg on p.patient_id=pg.patient_id
	where 	pg.voided=0 and p.voided=0 and program_id=2 and date_enrolled<=:endDate and location_id=:location
	
	union
	
	
	  SELECT 	distinct e.patient_id 
	  FROM 		patient p
				inner join encounter e on p.patient_id=e.patient_id
	  WHERE		p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=:endDate and e.location_id=:location					
						
) inicio on seguimento_sem_fila.patient_id=inicio.patient_id
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
) pid on pid.patient_id=seguimento_sem_fila.patient_id
left join 
(	select pn1.*
	from person_name pn1
	inner join 
		(
			select person_id,min(person_name_id) id 
			from person_name
			where voided=0
			group by person_id
		) pn2
	where pn1.person_id=pn2.person_id and pn1.person_name_id=pn2.id
) pn on pn.person_id=seguimento_sem_fila.patient_id