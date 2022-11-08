SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `nuic_children`;
CREATE TABLE  `nuic_children` (
  `id` int(11) DEFAULT NULL AUTO_INCREMENT,
  `patient_id` int(11) DEFAULT NULL,
  `nid` varchar(100) DEFAULT NULL, 
  `nuic` varchar(100) DEFAULT NULL, /*missing*/
  `first_name`varchar(3) DEFAULT NULL, /*codified name*/
  `middle_name`varchar(3) DEFAULT NULL, /*codified name*/
  `family_name`varchar(3) DEFAULT NULL, /*codified name*/
  `district`varchar(100) DEFAULT NULL,
  `health_facility` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `openmrs_age` int(11) DEFAULT NULL,
  `age_enrollment` int(11) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT NULL,
  `art_initiation_date` datetime DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_status_date` datetime DEFAULT NULL,
  `urban` varchar(1) DEFAULT NULL,
  `main` varchar(1) DEFAULT NULL,
   PRIMARY KEY (id),
  KEY `patient_id` (`patient_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for Fillnuic_children
-- ----------------------------
DROP PROCEDURE IF EXISTS `FillNUIC`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FillNUIC`(startDate date,endDate date, district varchar(100), location_id_parameter int(11))
    READS SQL DATA
begin

SET @location:=location_id_parameter;

/*INSCRICAO*/
insert into nuic_children(patient_id, enrollment_date, location_id)
        SELECT preTarvFinal.patient_id,preTarvFinal.initialDate,preTarvFinal.location FROM
         
         (   
              SELECT p.patient_id, MIN(e.encounter_datetime) initialDate,e.location_id FROM patient p 
              INNER JOIN encounter e ON p.patient_id=e.patient_id 
              INNER JOIN obs o ON o.encounter_id=e.encounter_id 
              WHERE e.voided=0 AND o.voided=0 AND p.voided=0 AND e.encounter_type in (18,6,9) 
              AND o.concept_id=1255 AND o.value_coded=1256 AND e.encounter_datetime<=endDate 
              GROUP BY p.patient_id 
              UNION 
              SELECT p.patient_id, MIN(value_datetime) initialDate,e.location_id FROM patient p 
              INNER JOIN encounter e ON p.patient_id=e.patient_id 
              INNER JOIN obs o ON e.encounter_id=o.encounter_id WHERE p.voided=0 AND e.voided=0 AND o.voided=0 AND e.encounter_type IN (18,6,9,53) 
              AND o.concept_id=1190 AND o.value_datetime is NOT NULL AND o.value_datetime<=endDate
              GROUP BY p.patient_id 
              UNION 
              SELECT pg.patient_id, MIN(date_enrolled) initialDate,pg.location_id FROM patient p 
              INNER JOIN patient_program pg ON p.patient_id=pg.patient_id 
              WHERE pg.voided=0 AND p.voided=0 AND program_id=2 AND date_enrolled<=:endDate 
              GROUP BY pg.patient_id 
              UNION SELECT e.patient_id, MIN(e.encounter_datetime) AS initialDate,e.location_id FROM patient p 
              INNER JOIN encounter e ON p.patient_id=e.patient_id 
              WHERE p.voided=0 AND e.encounter_type=18 AND e.voided=0 AND e.encounter_datetime<=endDate 
              GROUP BY p.patient_id 
              UNION 
              SELECT p.patient_id, MIN(value_datetime) initialDate,e.location_id FROM patient p 
              INNER JOIN encounter e ON p.patient_id=e.patient_id 
              INNER JOIN obs o ON e.encounter_id=o.encounter_id 
              WHERE p.voided=0 AND e.voided=0 AND o.voided=0 AND e.encounter_type=52 
              AND o.concept_id=23866 AND o.value_datetime is NOT NULL AND o.value_datetime<=endDate 
              GROUP BY p.patient_id 
        ) 
         preTarvFinal 
         where preTarvFinal.initialDate <= endDate
         GROUP BY preTarvFinal.patient_id;


Update nuic_children set nuic_children.district=district;

update nuic_children,location
set nuic_children.health_facility=location.name
where nuic_children.location_id=location.location_id;

/*NUIC */
UPDATE nuic_children, patient_identifier
SET nuic_children.nuic=patient_identifier.identifier where nuic_children.patient_id=patient_identifier.patient_id and patient_identifier.identifier_type=14;

/*NID TARV*/
UPDATE nuic_children, patient_identifier
SET nuic_children.nid=patient_identifier.identifier where nuic_children.patient_id=patient_identifier.patient_id and patient_identifier.identifier_type=2;



  /*FIRST NAME*/
UPDATE nuic_children,
       person_name
SET nuic_children.first_name=person_name.given_name 
WHERE nuic_children.patient_id=person_name.person_id;

/*middle_name NAME*/
UPDATE nuic_children,
       person_name
SET nuic_children.middle_name=person_name.middle_name
WHERE nuic_children.patient_id=person_name.person_id;


/*FAMILY NAME*/
UPDATE nuic_children,
       person_name
SET nuic_children.family_name=person_name.family_name
WHERE nuic_children.patient_id=person_name.person_id;

/*DATA DE NASCIMENTO*/
UPDATE nuic_children,
       person
SET nuic_children.date_of_birth=person.birthdate
WHERE nuic_children.patient_id=person.person_id;

UPDATE nuic_children,

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
SET nuic_children.enrollment_date=enrollment.data_abertura
WHERE nuic_children.patient_id=enrollment.patient_id;


/*IDADE NA INSCRICAO*/
update nuic_children,person set nuic_children.openmrs_age=FLOOR(datediff(nuic_children.enrollment_date,person.birthdate)/365)
where  person_id=nuic_children.patient_id;


/*Remove nuic_children with Null NUIC*/
delete from nuic_children where nuic_children.openmrs_age>14;



/*INICIO TARV*/
UPDATE nuic_children,

  (SELECT patient_id,
          min(data_inicio) data_inicio
   FROM
     (SELECT p.patient_id,
             min(e.encounter_datetime) data_inicio
      FROM nuic_children p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON o.encounter_id=e.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1255
        AND o.value_coded=1256
      GROUP BY p.patient_id
      UNION SELECT p.patient_id,
                   min(value_datetime) data_inicio
      FROM nuic_children p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      INNER JOIN obs o ON e.encounter_id=o.encounter_id
      WHERE e.voided=0
        AND o.voided=0
        AND e.encounter_type IN (18,
                                 6,
                                 9)
        AND o.concept_id=1190
        AND o.value_datetime IS NOT NULL
      GROUP BY p.patient_id
      UNION SELECT pg.patient_id,
                   date_enrolled data_inicio
      FROM nuic_children p
      INNER JOIN patient_program pg ON p.patient_id=pg.patient_id
      WHERE pg.voided=0
        AND program_id=2
      UNION SELECT e.patient_id,
                   MIN(e.encounter_datetime) AS data_inicio
      FROM nuic_children p
      INNER JOIN encounter e ON p.patient_id=e.patient_id
      WHERE e.encounter_type=18
        AND e.voided=0
      GROUP BY p.patient_id 
      ) inicio
   GROUP BY patient_id 
   )inicio_real
SET nuic_children.art_initiation_date=inicio_real.data_inicio
WHERE nuic_children.patient_id=inicio_real.patient_id;

/*Estado Actual TARV*/
update nuic_children,
    (select   pg.patient_id,ps.start_date,
        case ps.state
          when 7 then 'TRASFERRED OUT'
          when 8 then 'SUSPENDED'
          when 9 then 'ART LTFU'
          when 10 then 'DEAD'
        else null end as codeestado
    from  nuic_children p 
        inner join patient_program pg on p.patient_id=pg.patient_id
        inner join patient_state ps on pg.patient_program_id=ps.patient_program_id
    where   pg.voided=0 and ps.voided=0 and  
        pg.program_id=2 and ps.state in (7,8,9,10) and ps.end_date is null and 
        ps.start_date BETWEEN startDate AND endDate
    ) saida
set   nuic_children.patient_status=saida.codeestado,
nuic_children.patient_status_date=saida.start_date
where saida.patient_id=nuic_children.patient_id;



/*Urban e Main*/
update nuic_children set urban='N';

update nuic_children set main='N';

if district='Quelimane' then
  update nuic_children set urban='Y'; 
end if;

if district='Namacurra' then
    update nuic_children set main='Y' where location_id=5; 
  end if;

-- if district='Maganja' then
--   update nuic_children set main='Y' where location_id=15; 
-- end if;

if district='Pebane' then
  update nuic_children set main='Y' where location_id=16; 
end if;

if district='Gile' then
  update nuic_children set main='Y' where location_id=6; 
end if;

if district='Molocue' then
  update nuic_children set main='Y' where location_id=3; 
end if;

if district='Mocubela' then
  update nuic_children set main='Y' where location_id=62; 
end if;

if district='Inhassunge' then
  update nuic_children set main='Y' where location_id=7; 
end if;

if district='Ile' then
  update nuic_children set main='Y' where location_id in (4,55); 
end if;

if district='Namarroi' then
  update nuic_children set main='Y' where location_id in (252);
end if;

end
;;
DELIMITER ;