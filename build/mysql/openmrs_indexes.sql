SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE orders MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE reporting_report_design_resource MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE concept_reference_source MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE concept_name MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Alter default value for columns
ALTER TABLE `encounter`
    MODIFY `encounter_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
    MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;
	
ALTER TABLE `obs`
    MODIFY `obs_datetime` DATETIME DEFAULT CURRENT_TIMESTAMP,
    MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `patient` MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `patient_program` MODIFY `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person_name` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `patient_identifier` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `location` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `patient_state` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person_address` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `person_attribute` MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Indexes for encounter
ALTER TABLE `encounter` ADD INDEX `encounter_idx_location_voided_encounttype_encountdatetime` (`location_id`,`voided`,`encounter_type`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_encounttype_location_voided_encountdatetime` (`encounter_type`,`location_id`,`voided`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_location_patient_encount` (`voided`,`encounter_type`,`location_id`,`patient_id`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_location` (`voided`,`encounter_type`,`location_id`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_location_encountdatetime` (`voided`,`encounter_type`,`location_id`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_voided_encounttype_patient_encountdatetime` (`voided`,`encounter_type`,`patient_id`,`encounter_datetime`);
ALTER TABLE `encounter` ADD INDEX `encounter_idx_patient_id_encountdatetime` (`patient_id`,`encounter_datetime`);

-- Indexes for obs
ALTER TABLE `obs` ADD INDEX `obs_idx_location_voided_obsdatetime` (`location_id`,`voided`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_encount_valuecoded_concept_voided` (`encounter_id`,`value_coded`,`concept_id`,`voided`);
ALTER TABLE `obs` ADD INDEX `obs_idx_encount_concept_voided_valuedatetime` (`encounter_id`,`concept_id`,`voided`,`value_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_encount_voided_concept_obsdatetime` (`encounter_id`,`voided`,`concept_id`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_concept_location_voided_obsdatetime` (`concept_id`,`location_id`,`voided`,`obs_datetime`);
ALTER TABLE `obs` ADD INDEX `obs_idx_concept_location_voided_valuenumeric` (`concept_id`,`location_id`,`voided`,`value_numeric`);

-- Indexes for patient
ALTER TABLE `patient` ADD INDEX `patient_idx_patient_voided` (`patient_id`,`voided`); --index ja criado na base OpenMRS
ALTER TABLE `patient` ADD INDEX `patient_idx_voided_patient` (`voided`,`patient_id`);

-- Indexes for patient_program
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_location_program_voided` (`location_id`,`program_id`,`voided`,`date_enrolled`);
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_program_voided_patient` (`program_id`,`voided`,`patient_id`);
ALTER TABLE `patient_program` ADD INDEX `patient_program_idx_program_voided_location` (`program_id`,`voided`,`location_id`);

-- Indexes for patient_identifier
ALTER TABLE `patient_identifier` ADD INDEX `patient_identifier_idx_voided_patient_patient` (`voided`,`patient_id`,`patient_identifier_id`);
ALTER TABLE `patient_identifier` ADD INDEX `patient_identifier_idx_voided_patientidenti` (`voided`,`patient_identifier_id`);
ALTER TABLE `patient_identifier` ADD INDEX `patient_identifier_idx_voided_identifiertype` (`voided`,`identifier_type`);


-- Indexes for location
ALTER TABLE `location` ADD INDEX `location_idx_location` (`location_id`);
ALTER TABLE `location` ADD INDEX `location_idx_retired_location` (`retired`,`location_id`);

-- Indexes for patient_state
ALTER TABLE `patient_state` ADD INDEX `patient_state_idx_voided_state_enddate_patienprogram_start` (`voided`,`state`,`end_date`,`patient_program_id`,`start_date`);

-- Indexes for person
ALTER TABLE `person` ADD INDEX `person_idx_voided` (`voided`);

-- Indexes for person_address
ALTER TABLE `person_address` ADD INDEX `person_address_idx_voided_person_personaddress` (`voided`,`person_id`,`person_address_id`);
ALTER TABLE `person_address` ADD INDEX `person_address_idx_person_personaddres` (`person_id`,`person_address_id`);

-- Indexes for person_attribute
ALTER TABLE `person_attribute` ADD INDEX `person_attribute_idx_voided_personattributetype_person_personat` (`voided`,`person_attribute_type_id`,`person_id`,`person_attribute_id`);
ALTER TABLE `person_attribute` ADD INDEX `person_attribute_idx_person_personattribute` (`person_id`,`person_attribute_id`);

-- Indexes for person_name
ALTER TABLE `person_name` ADD INDEX `person_name_idx_voided_person_personname` (`voided`,`person_id`,`person_name_id`);
ALTER TABLE `person_name` ADD INDEX `person_name_idx_person_personname` (`person_id`,`person_name_id`);

SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
