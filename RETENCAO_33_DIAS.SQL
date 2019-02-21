select inicio_real.patient_id
from
(	select patient_id,data_inicio
	from
	(	Select patient_id,min(data_inicio) data_inicio
		from
				(	Select 	p.patient_id,min(e.encounter_datetime) data_inicio
					from 	patient p 
							inner join encounter e on p.patient_id=e.patient_id	
							inner join obs o on o.encounter_id=e.encounter_id
					where 	e.voided=0 and o.voided=0 and p.voided=0 and 
							e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256 and 
							e.encounter_datetime<=:endDate and e.location_id=:location
					group by p.patient_id
			
					union
			
					Select 	p.patient_id,min(value_datetime) data_inicio
					from 	patient p
							inner join encounter e on p.patient_id=e.patient_id
							inner join obs o on e.encounter_id=o.encounter_id
					where 	p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9) and 
							o.concept_id=1190 and o.value_datetime is not null and 
							o.value_datetime<=:endDate and e.location_id=:location
					group by p.patient_id

					union

					select 	pg.patient_id,date_enrolled data_inicio
					from 	patient p inner join patient_program pg on p.patient_id=pg.patient_id
					where 	pg.voided=0 and p.voided=0 and program_id=2 and date_enrolled<=:endDate and location_id=:location
					
					union
					
					
				  SELECT 	e.patient_id, MIN(e.encounter_datetime) AS data_inicio 
				  FROM 		patient p
							inner join encounter e on p.patient_id=e.patient_id
				  WHERE		p.voided=0 and e.encounter_type=18 AND e.voided=0 and e.encounter_datetime<=:endDate and e.location_id=:location
				  GROUP BY 	p.patient_id				
					
					
				) inicio
			group by patient_id	
	)inicio1
	where data_inicio between :startDate and :endDate
) inicio_real
inner join encounter e on e.patient_id=inicio_real.patient_id
where 	e.voided=0 and e.encounter_type in (6,9,18) and e.location_id=:location and 
		e.encounter_datetime between inicio_real.data_inicio and date_add(inicio_real.data_inicio, interval 33 day) and 
		inicio_real.patient_id not in 
		(
			select 	pg.patient_id
			from 	patient p 
					inner join patient_program pg on p.patient_id=pg.patient_id
					inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
			where 	pg.voided=0 and ps.voided=0 and p.voided=0 and 
					pg.program_id=2 and ps.state=29 and ps.start_date=pg.date_enrolled and 
					ps.start_date between :startDate and :endDate and location_id=:location
		)
group by inicio_real.patient_id
having min(e.encounter_datetime)<max(e.encounter_datetime)