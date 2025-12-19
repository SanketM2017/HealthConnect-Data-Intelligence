
use dev_HealthConnect_raw

/*
ALTER TABLE raw_encounters
DROP CONSTRAINT [FK_raw_encounters_patient];

ALTER TABLE raw_encounters
ADD CONSTRAINT [FK_raw_encounters_patient]
FOREIGN KEY (patient_id)
REFERENCES raw_patients(patient_id)
ON DELETE CASCADE;

-- Drop and recreate provider_id foreign key with ON DELETE CASCADE
ALTER TABLE raw_encounters
DROP CONSTRAINT [FK_raw_encounters_provider];

ALTER TABLE raw_encounters
ADD CONSTRAINT [FK_raw_encounters_provider]
FOREIGN KEY (provider_id)
REFERENCES raw_providers(provider_id)
ON DELETE CASCADE;



ALTER TABLE raw_diagnoses
DROP CONSTRAINT [FK_raw_diagnoses_encounter];
ALTER TABLE raw_diagnoses
ADD CONSTRAINT [FK_raw_diagnoses_encounter]
FOREIGN KEY (encounter_id)
REFERENCES raw_encounters(encounter_id)
ON DELETE CASCADE;




/*
ALTER TABLE raw_procedures
DROP CONSTRAINT [FK_raw_procedures_encounter]
ALTER TABLE raw_procedures
ADD CONSTRAINT [FK_raw_procedures_encounter]
FOREIGN KEY (encounter_id)
REFERENCES raw_encounters(encounter_id)
ON DELETE CASCADE;
*/


/*
ALTER TABLE raw_medications
DROP CONSTRAINT [FK_raw_medications_encounter] 
ALTER TABLE raw_medications
ADD CONSTRAINT  [FK_raw_medications_encounter] 
FOREIGN KEY (encounter_id)
REFERENCES raw_encounters(encounter_id)
ON DELETE CASCADE;
*/


    
    /*
ALTER TABLE raw_claims
DROP CONSTRAINT [FK_raw_claims_encounter],[FK_raw_claims_payer];
ALTER TABLE raw_claims
ADD CONSTRAINT [FK_raw_claims_encounter]
FOREIGN KEY (encounter_id)
REFERENCES raw_encounters(encounter_id)
ON DELETE CASCADE;
ALTER TABLE raw_claims
ADD CONSTRAINT [FK_raw_claims_payer]
FOREIGN KEY (payer_id)
REFERENCES raw_payers(payer_id)
ON DELETE CASCADE;


*/