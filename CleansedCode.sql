USE dev_HealthConnect_cleansed;
GO
CREATE OR ALTER PROCEDURE [dbo].[MergecleansedTables]
AS
BEGIN
    SET NOCOUNT ON;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT 1 FROM dev_healthConnect_raw.dbo.raw_medications )
BEGIN
  INSERT INTO cleansed_medications(medication_id ,encounter_id,drug_name ,route ,dose  ,frequency ,days_supply ,load_date)
  SELECT medication_id ,encounter_id ,UPPER(TRIM(drug_name)) ,UPPER(TRIM(route)) ,UPPER(TRIM(dose))  ,
  frequency ,days_supply ,getdate() as  load_date FROM dev_healthConnect_raw.dbo.raw_medications

  truncate table dev_healthConnect_raw.dbo.raw_medications

--select *from  dev_healthConnect_raw.dbo.raw_medications

END
ELSE
BEGIN
    PRINT 'No record found';
END
-------------------------------------------------------------------------------------------------------------------------------------------------------------


  IF EXISTS (SELECT 1 FROM dev_healthConnect_raw.dbo.raw_procedures )
BEGIN
  INSERT INTO cleansed_procedures( procedure_id ,encounter_id,procedure_description ,load_date )
  SELECT  procedure_id ,encounter_id,UPPER(TRIM(procedure_description)) ,getdate() as load_date  
  FROM dev_healthConnect_raw.dbo.raw_procedures
  
  truncate table  dev_healthConnect_raw.dbo.raw_procedures
  
  --select * from  dev_healthConnect_raw.dbo.raw_procedures
  END
ELSE
BEGIN
    PRINT 'No record found';
END
-------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT 1 FROM dev_healthConnect_raw.dbo.raw_diagnoses )
BEGIN
INSERT INTO cleansed_diagnoses(diagnosis_id ,encounter_id ,diagnosis_description ,is_primary)
SELECT diagnosis_id ,encounter_id ,UPPER(TRIM(diagnosis_description)) ,is_primary
FROM dev_healthConnect_raw.dbo.raw_diagnoses

truncate table dev_healthConnect_raw.dbo.raw_diagnoses
END
ELSE
BEGIN
    PRINT 'No record found';
END
-------------------------------------------------------------------------------------------------------------------------------------------------------------



IF EXISTS (SELECT 1 FROM dev_healthConnect_raw.dbo.raw_claims )
BEGIN
INSERT INTO cleansed_claims(claim_id ,encounter_id ,payer_id ,admit_date ,discharge_date ,total_billed_amount ,
total_allowed_amount,total_paid_amount ,claim_status,load_date)
SELECT claim_id ,encounter_id ,payer_id ,admit_date ,discharge_date ,total_billed_amount ,total_allowed_amount ,
total_paid_amount ,claim_status,getdate() as load_date
FROM dev_healthConnect_raw.dbo.raw_claims

truncate table dev_healthConnect_raw.dbo.raw_claims

--select * from dev_healthConnect_raw.dbo.raw_claims
END
ELSE
BEGIN
    PRINT 'No record found';
END
-------------------------------------------------------------------------------------------------------------------------------------------------------------




IF EXISTS (SELECT 1 FROM dev_healthConnect_raw.dbo.raw_encounters )
BEGIN
INSERT INTO cleansed_encounters(encounter_id,patient_id,provider_id,encounter_type,
encounter_start,encounter_end,height_cm,weight_kg,systolic_bp,diastolic_bp,load_date)
  SELECT encounter_id,patient_id,provider_id,encounter_type,encounter_start,
  encounter_end,height_cm,weight_kg,systolic_bp,diastolic_bp,getdate() as load_date FROM 
  dev_healthConnect_raw.dbo.raw_encounters


delete from  dev_healthConnect_raw.dbo.raw_encounters

   --select * from dev_healthConnect_raw.dbo.raw_encounters
END
ELSE
BEGIN
    PRINT 'No record found';
END
-------------------------------------------------------------------------------------------------------------------------------------------------------------



--IF EXISTS (SELECT 1 FROM [dev_healthConnect_raw].[dbo].[raw_patients] )
--BEGIN
--INSERT INTO cleansed_patients (patient_id,first_name,last_name ,gender,date_of_birth,state_code ,city ,phone,load_date)
--SELECT patient_id,UPPER(TRIM(raw_patients.first_name)),UPPER(TRIM(raw_patients.last_name)) ,
--UPPER(TRIM(raw_patients.gender)),date_of_


IF EXISTS (SELECT 1 FROM [dev_healthConnect_raw].[dbo].[raw_patients])
BEGIN
    INSERT INTO cleansed_patients (
        patient_id,
        first_name,
        last_name,
        gender,
        date_of_birth,
        state_code,
        city,
        phone,
        load_date
    )
    SELECT 
        patient_id,
        UPPER(TRIM(first_name)),
        UPPER(TRIM(last_name)),
        UPPER(TRIM(gender)),
        date_of_birth,
        UPPER(TRIM(state_code)),
        UPPER(TRIM(city)),
        phone,
        GETDATE() AS load_date
    FROM [dev_healthConnect_raw].[dbo].[raw_patients];

    TRUNCATE TABLE [dev_healthConnect_raw].[dbo].[raw_patients];
END
ELSE
BEGIN
    PRINT 'No record found';
END

END;
GO






