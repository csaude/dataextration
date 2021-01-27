           		select final.patient_id, max(final.data) from ( 
                    Select p.patient_id,max(encounter_datetime) data from patient p 
                     			inner join encounter e on e.patient_id=p.patient_id 
                     	where 	p.voided=0 and e.voided=0 and e.encounter_type=18 and 
                     			e.location_id= 271 and e.encounter_datetime<= '2010-09-20' 
                     group by p.patient_id 
                     union 
                     Select p.patient_id,max(value_datetime) data 
                     	from 	patient p inner join encounter e on p.patient_id=e.patient_id 
                     			inner join obs o on e.encounter_id=o.encounter_id 
                     	where 	p.voided=0 and e.voided=0 and o.voided=0 and e.encounter_type=52 and 
                     			o.concept_id=23866 and o.value_datetime is not null and 
                     			o.value_datetime<= '2010-09-20' and e.location_id= 271 
                     group by p.patient_id 
                     union 
                     Select p.patient_id,max(encounter_datetime) data from patient p 
                     			inner join encounter e on e.patient_id=p.patient_id 
                     	where 	p.voided=0 and e.voided=0 and e.encounter_type in (6,9) and 
                     			e.location_id= 271 and e.encounter_datetime<= '2010-09-20' 
                     	group by p.patient_id 
                     )final group by final.patient_id 