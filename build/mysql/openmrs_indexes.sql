SELECT 'Removendo sql_mode e desactivando foreign_key_checks' AS Status;
SET GLOBAL sql_mode = '';
SET foreign_key_checks = 0;

select 'Alterando default date_created para CURRENT_TIMESTAMP para as Tabelas --> orders, reporting_report_design_resource, users, concept_reference_source, concept_name' AS Status;
ALTER TABLE orders MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE reporting_report_design_resource MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE concept_reference_source MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE concept_name MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;


select 'Alterando default date_created para CURRENT_TIMESTAMP para as Tabelas--> patient, patient_program, person, person_name, patient_identifier, location, patient_state, person_address, person_attribute ' AS Status;
ALTER TABLE `patient` MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `patient_program` MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person_name` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `patient_identifier` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `location` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `patient_state` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person_address` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person_attribute` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;

-- encounter
select 'Alterando default encounter_datetime,date_created para CURRENT_TIMESTAMP Tabela --> encounter' AS Status;
-- Alter default value for columns
ALTER TABLE `encounter`
    MODIFY `encounter_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
    MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;
-- Indexes for encounter
select 'Criação de Índices para a Tabela encounter' AS Status;
ALTER TABLE `encounter` ADD INDEX `encounter_idx_location_voided_encounttype_encountdatetime` (`location_id`,`voided`,`encounter_type`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_encounttype_location_voided_encountdatetime` (`encounter_type`,`location_id`,`voided`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_location_patient_encount` (`voided`,`encounter_type`,`location_id`,`patient_id`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_location` (`voided`,`encounter_type`,`location_id`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_location_encountdatetime` (`voided`,`encounter_type`,`location_id`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_patient_encountdatetime` (`voided`,`encounter_type`,`patient_id`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_patient_id_encountdatetime` (`patient_id`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_location_encountertype_encountdatetime` (`location_id`,`encounter_type`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_locatio_encount_encount` (`voided`,`location_id`,`encounter_type`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_encounter_location_encounter` (`encounter_type`,`location_id`,`encounter_datetime`);

-- obs
select 'Alterando default (obs_datetime, date_created) para CURRENT_TIMESTAMP para a Tabela--> obs' AS Status;
ALTER TABLE `obs`
    MODIFY `obs_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
    MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;
-- Indexes for obs
select 'Criação de Índices para a Tabela obs' AS Status;
ALTER TABLE `obs` ADD INDEX `obs_idx_location_voided_obsdatetime` (`location_id`,`voided`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_encount_valuecoded_concept_voided` (`encounter_id`,`value_coded`,`concept_id`,`voided`);
ALTER TABLE `obs` ADD INDEX `obs_idx_encount_concept_voided_valuedatetime` (`encounter_id`,`concept_id`,`voided`,`value_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_encount_voided_concept_obsdatetime` (`encounter_id`,`voided`,`concept_id`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_concept_location_voided_obsdatetime` (`concept_id`,`location_id`,`voided`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_concept_location_voided_valuenumeric` (`concept_id`,`location_id`,`voided`,`value_numeric`);
ALTER TABLE `obs` ADD INDEX `obs_idx_concept_valuecoded_obsdatetime` (`concept_id`,`value_coded`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_voide_conce_locat_perso_obs_value` (`voided`,`concept_id`,`location_id`,`person_id`,`obs_datetime`,`value_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_voided_concep_value_encoun_obs_da` (`voided`,`concept_id`,`value_coded`,`encounter_id`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_voided_concept_encount_value` (`voided`,`concept_id`,`encounter_id`,`value_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_voided_value_encoun_concep_obs_da` (`voided`,`value_coded`,`encounter_id`,`concept_id`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_concep_voided_encoun_value_obs_da` (`concept_id`,`voided`,`encounter_id`,`value_coded`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_voided_encount_concept_value` (`voided`,`encounter_id`,`concept_id`,`value_coded`);

-- patient
-- Indexes for patient
select 'Criação de Índices para a Tabela patient' AS Status;
ALTER TABLE `patient` ADD INDEX `patient_idx_patient_voided` (`patient_id`,`voided`);
ALTER TABLE `patient` ADD INDEX `patient_idx_voided_patient` (`voided`,`patient_id`);

-- patient_program
-- Indexes for patient_program
select 'Criação de Índices para a Tabela patient_program' AS Status;
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_location_program_voided` (`location_id`,`program_id`,`voided`,`date_enrolled`);
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_program_voided_patient` (`program_id`,`voided`,`patient_id`);
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_program_voided_location` (`program_id`,`voided`,`location_id`);

--Novos
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_voided_patient_id_date_enrol` (`voided`,`patient_id`,`date_enrolled`);
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_voided_program_locatio_patient` (`voided`,`program_id`,`location_id`,`patient_id`);

-- patient_identifier
-- Indexes for patient_identifier
select 'Criação de Índices para a Tabela patient_identifier' AS Status;
ALTER TABLE `patient_identifier` ADD INDEX `patient_identifier_idx_voided_patient_patient` (`voided`,`patient_id`,`patient_identifier_id`);
ALTER TABLE `patient_identifier` ADD INDEX `patient_identifier_idx_voided_patientidenti` (`voided`,`patient_identifier_id`);
ALTER TABLE `patient_identifier` ADD INDEX `patient_identifier_idx_voided_identifiertype` (`voided`,`identifier_type`);

-- Indexes for location
select 'Criação de Índices para a Tabela location' AS Status;
ALTER TABLE `location` ADD INDEX `location_idx_location` (`location_id`);
ALTER TABLE `location` ADD INDEX `location_idx_retired_location` (`retired`,`location_id`);

-- patient_state
-- Indexes for patient_state
select 'Criação de Índices para a Tabela patient_state' AS Status;
ALTER TABLE `patient_state` ADD INDEX `patient_state_idx_voided_state_enddate_patienprogram_start` (`voided`,`state`,`end_date`,`patient_program_id`,`start_date`);
ALTER TABLE `patient_state` ADD INDEX `patient_state_idx_patienprogram_startdate` (`patient_program_id`,`start_date`);


-- person
-- Indexes for person
select 'Criação de Índices para a Tabela person' AS Status;
ALTER TABLE `person` ADD INDEX `person_idx_voided` (`voided`);
ALTER TABLE `person` ADD INDEX `person_idx_dead_voided_death_date` (`dead`,`voided`,`death_date`);

-- person_address
-- Indexes for person_address
select 'Criação de Índices para a Tabela person_address' AS Status;
ALTER TABLE `person_address` ADD INDEX `person_address_idx_voided_person_personaddress` (`voided`,`person_id`,`person_address_id`);
ALTER TABLE `person_address` ADD INDEX `person_address_idx_person_personaddres` (`person_id`,`person_address_id`);

-- person_attribute
-- Indexes for person_attribute
select 'Criação de Índices para a Tabela person_attribute' AS Status;
ALTER TABLE `person_attribute` ADD INDEX `person_attribute_idx_voided_personattributetype_person_personat` (`voided`,`person_attribute_type_id`,`person_id`,`person_attribute_id`);
ALTER TABLE `person_attribute` ADD INDEX `person_attribute_idx_person_personattribute` (`person_id`,`person_attribute_id`);

-- person_name
-- Indexes for person_name
select 'Criação de Índices para a Tabela person_name' AS Status;
ALTER TABLE `person_name` ADD INDEX `person_name_idx_voided_person_personname` (`voided`,`person_id`,`person_name_id`);
ALTER TABLE `person_name` ADD INDEX `person_name_idx_person_personname` (`person_id`,`person_name_id`);

select 'Rebuild de indices para a tabela encounter' AS Status;
ALTER TABLE `encounter` FORCE;

select 'Rebuild de indices para a tabela patient' AS Status;
ALTER TABLE `patient` FORCE;

select 'Rebuild de indices para a tabela patient_program' AS Status;
ALTER TABLE `patient_program` FORCE;

select 'Rebuild de indices para a tabela patient_identifier' AS Status;
ALTER TABLE `patient_identifier` FORCE;

select 'Rebuild de indices para a tabela location' AS Status;
ALTER TABLE `location` FORCE;

select 'Rebuild de indices para a tabela patient_state' AS Status;
ALTER TABLE `patient_state` FORCE;

select 'Rebuild de indices para a tabela person' AS Status;
ALTER TABLE `person` FORCE;

select 'Rebuild de indices para a tabela person_address' AS Status;
ALTER TABLE `person_address` FORCE;

select 'Rebuild de indices para a tabela person_attribute' AS Status;
ALTER TABLE `person_attribute` FORCE;

select 'Rebuild de indices para a tabela person_name' AS Status;
ALTER TABLE `person_name` FORCE;

SELECT 'Ativando foreign_key_checks novamente e devolvendo sql_mode' AS Status;
SET foreign_key_checks = 1;
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

SELECT 'Execução do script concluída!' AS Status;