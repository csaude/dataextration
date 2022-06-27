SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `children`;
CREATE TABLE  `children` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `nid` int(11) DEFAULT NULL, 
  `nuic` int(11) DEFAULT NULL, /*missing*/
  `first_name`varchar(100) DEFAULT NULL, /*codified name*/
  `middle_name`varchar(100) DEFAULT NULL, /*codified name*/
  `family_name`varchar(100) DEFAULT NULL, /*codified name*/
  `district`varchar(100) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `date_of_ART_initiation` datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for Fillchildren
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillNUIC`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillNUIC`(startDate date,endDate date,district varchar(100))
    READS SQL DATA
begin

truncate children;

/*BUSCAR ID DO PACIENTE E LOCATION*/
UPDATE children,
       patient_identifier
SET children.patient_id = patient_identifier.patient_id, children.location_id=patient_identifier.location_id
WHERE patient_identifier.identifier_type=2
  AND patient_identifier.identifier=children.nid;

UPDATE children, location SET children.health_facility=location.name where location.location_id=children.location_id;

  /*FIRST NAME*/
UPDATE children,
       person_name
SET children.first_name=person_name.given_name
WHERE children.patient_id=person_name.person_id;

/*middle_name NAME*/
UPDATE children,
       person_name
SET children.middle_name=person_name.middle_name
WHERE children.patient_id=person_name.person_id;


/*FAMILY NAME*/
UPDATE children,
       person_name
SET children.family_name=person_name.family_name
WHERE children.patient_id=person_name.person_id;

/*DATA DE NAICIMENTO*/
UPDATE children,
       person
SET children.date_of_birth=person.birthdate
WHERE children.patient_id=person.person_id;

/*SEXO*/
update children,person set children.sex=.person.gender where  person_id=children.patient_id;


/*IDADE NA INSCRICAO*/
update children,person set children.age_enrollment=round(datediff(children.enrollment_date,person.birthdate)/365)
where  person_id=children.patient_id;


/*INSCRICAO*/
UPDATE children,

  (SELECT e.patient_id,
          min(encounter_datetime) data_abertura
   FROM patient p
   INNER JOIN encounter e ON e.patient_id=p.patient_id
   INNER JOIN person pe ON pe.person_id=p.patient_id
   WHERE p.voided=0
     AND e.encounter_type IN (5,7,53)
     AND e.voided=0
     AND pe.voided=0
   GROUP BY p.patient_id) enrollment
SET children.enrollment_date=enrollment.data_abertura
WHERE children.patient_id=enrollment.patient_id;

/*INICIO TARV*/

/*INICIO TARV*/
UPDATE children,

  (
  Select patient_id,min(data_inicio) data_inicio                                        
               from                                                            
                 (                                                           
            /* Patients on ART who initiated the ARV DRUGS: ART Regimen Start Date */
                   Select  p.patient_id,min(e.encounter_datetime) data_inicio                              
                   from  patient p                                                   
                       inner join person pe on pe.person_id = p.patient_id                             
                       inner join encounter e on p.patient_id=e.patient_id                             
                       inner join obs o on o.encounter_id=e.encounter_id                             
                   where   e.voided=0 and o.voided=0 and p.voided=0 and pe.voided = 0 and                        
                       e.encounter_type in (18,6,9) and o.concept_id=1255 and o.value_coded=1256                    
                   group by p.patient_id                                               
                   union                                                       
            /* Patients on ART who have art start date: ART Start date */
                   Select  p.patient_id,min(value_datetime) data_inicio                                
                   from  patient p                                                 
                       inner join person pe on pe.person_id = p.patient_id                             
                       inner join encounter e on p.patient_id=e.patient_id                             
                       inner join obs o on e.encounter_id=o.encounter_id                             
                   where   p.voided=0 and pe.voided = 0 and e.voided=0 and o.voided=0 and e.encounter_type in (18,6,9,53) and      
                       o.concept_id=1190 and o.value_datetime is not null                            
                   group by p.patient_id                                               
                   union                                                       
            /* Patients enrolled in ART Program: OpenMRS Program */
                   select  pg.patient_id,min(date_enrolled) data_inicio                                
                   from  patient p                                                   
                     inner join person pe on pe.person_id = p.patient_id                               
                     inner join patient_program pg on p.patient_id=pg.patient_id                           
                   where   pg.voided=0 and p.voided=0 and pe.voided = 0 and program_id=2 
                   group by pg.patient_id                                                
                   union                                                       
            /*
             * Patients with first drugs pick up date set in Pharmacy: First ART Start Date
             */
                     SELECT  e.patient_id, MIN(e.encounter_datetime) AS data_inicio                          
                     FROM    patient p                                               
                         inner join person pe on pe.person_id = p.patient_id                           
                         inner join encounter e on p.patient_id=e.patient_id                           
                     WHERE   p.voided=0 and pe.voided = 0 and e.encounter_type=18 AND e.voided=0   
                     GROUP BY  p.patient_id                                                    
                   union                                                             
            /* Patients with first drugs pick up date set: Recepcao Levantou ARV */
                   Select  p.patient_id,min(value_datetime) data_inicio                                      
                   from  patient p                                                       
                       inner join person pe on pe.person_id = p.patient_id                                   
                       inner join encounter e on p.patient_id=e.patient_id                                   
                       inner join obs o on e.encounter_id=o.encounter_id                                   
                   where   p.voided=0 and pe.voided = 0 and e.voided=0 and o.voided=0 and e.encounter_type=52 and                  
                       o.concept_id=23866 and o.value_datetime is not null                                    
                   group by p.patient_id                                                     
      )inicio_real
      )inicio_real
SET children.date_of_ART_initiation=inicio_real.data_inicio
WHERE children.patient_id=inicio_real.patient_id;

delete from children where children.age_enrollment<=13 and children.nuic is null;

/*Urban e Main*/
update children set urban='N';

update children set main='N';

if district='Quelimane' then
  update children set urban='Y'; 
end if;

if district='Namacurra' then
    update children set main='Y' where location_id=5; 
  end if;

-- if district='Maganja' then
--   update children set main='Y' where location_id=15; 
-- end if;

if district='Pebane' then
  update children set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update children set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update children set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update children set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update children set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update children set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
  update children set main='Y' where location_id in (252);
end if;

end
;;
DELIMITER ;