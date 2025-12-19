

use [dev_HealthConnect_Refined]


------------------------------------------------------------------------refined Table----------------------------------


--CREATE TABLE refined_patients(
--	[patient_id] [int] NOT NULL,
--	[first_name] [varchar](50) NULL,
--	[last_name] [varchar](50) NULL,
--	[gender] [char](1) NULL,
--	[date_of_birth] [date] NULL,
--	[state_code] [char](2) NULL,
--	[city] [varchar](50) NULL,
--	[phone] [varchar](15) NULL,
--    load_date date,last_updated_date date
--    )

--CREATE TABLE refined_providers (
--    provider_id INT ,
--    first_name VARCHAR(50) ,
--    last_name VARCHAR(50),
--    specialty VARCHAR(50),
--    npi VARCHAR(20) ,
--    load_date date,last_updated_date date
--);

--CREATE TABLE refined_payers (
--    payer_id INT,
--    payer_name VARCHAR(100) ,
--    load_date date,last_updated_date date
--);


--CREATE TABLE refined_encounters (
--    encounter_id INT ,
--    patient_id INT ,
--    provider_id INT ,
--    encounter_type VARCHAR(10) ,
--    encounter_start DATETIME,
--    encounter_end DATETIME,
--    height_cm INT,
--    weight_kg FLOAT,
--    systolic_bp INT,
--    diastolic_bp INT,
--    load_date date,last_updated_date date
--);

--CREATE TABLE refined_diagnoses (
--    diagnosis_id INT ,
--    encounter_id INT ,
--    diagnosis_description VARCHAR(100),
--    is_primary BIT,
--    load_date date,last_updated_date date
   
--)


--CREATE TABLE refined_procedures (
--    procedure_id INT ,
--    encounter_id INT ,
--    procedure_description VARCHAR(100),
--    load_date date,last_updated_date date
--);

--CREATE TABLE refined_medications (
--    medication_id INT ,
--    encounter_id INT ,
--    drug_name VARCHAR(50),
--    route VARCHAR(20),
--    dose VARCHAR(20),
--    frequency VARCHAR(10),
--    days_supply INT,
--    load_date date,last_updated_date date
--);


--CREATE TABLE refined_claims (
--    claim_id INT,
--    encounter_id INT ,
--    payer_id INT ,
--    admit_date DATE,
--    discharge_date DATE,
--    total_billed_amount FLOAT,
--    total_allowed_amount FLOAT,
--    total_paid_amount FLOAT,
--    claim_status VARCHAR(20) ,
--   load_date date,last_updated_date date);




USE dev_healthConnect_refined;
GO
CREATE OR ALTER PROCEDURE [dbo].[MergerefinedTables]
AS
BEGIN
    SET NOCOUNT ON;

merge into  dev_healthConnect_refined.dbo.refined_medications as rfm
using dev_HealthConnect_cleansed.dbo.cleansed_medications cm on 
(rfm.medication_id=cm.medication_id and  rfm.encounter_id=cm.encounter_id)
WHEN MATCHED AND ( rfm.drug_name <> cm.drug_name  OR  rfm.route <> cm.route OR
 rfm.dose <> cm.dose OR rfm.frequency<> cm.frequency OR rfm.days_supply<>cm.days_supply
)
THEN
UPDATE SET 
  rfm.drug_name = cm.drug_name  ,  rfm.route = cm.route ,
 rfm.dose = cm.dose , rfm.frequency= cm.frequency , rfm.days_supply=cm.days_supply,load_date=rfm.last_updated_date
 ,last_updated_date= getdate()
 WHEN NOT MATCHED THEN
INSERT  VALUES (cm.medication_id ,cm.encounter_id  ,cm.drug_name ,cm.route ,
cm.dose  ,cm.frequency ,cm.days_supply ,getdate() ,getdate() );


--select count(*) from [dbo].[refined_medications]

-------------------------------------------------------------------------------------------------------------------------------------------------------------


merge into  dev_healthConnect_refined.dbo.refined_claims as rfc
using dev_HealthConnect_cleansed.dbo.[cleansed_claims] cc on 
(rfc.[claim_id]=cc.[claim_id] and  rfc.encounter_id=cc.encounter_id) and rfc.[payer_id]=cc.[payer_id]
WHEN MATCHED AND (rfc.[admit_date]<>cc.[admit_date] or rfc.[discharge_date]<>cc.[discharge_date] 
                                            or rfc.[total_billed_amount]<>cc.[total_billed_amount] or rfc.[total_allowed_amount]
                                            <>cc.[total_allowed_amount] or rfc.[total_paid_amount]<>cc. [total_paid_amount] or 
                                            rfc.[claim_status] <>cc.[claim_status])
THEN
UPDATE SET 
         rfc. [admit_date]=cc.[admit_date] ,rfc.[discharge_date]=cc.[discharge_date] ,rfc.[total_billed_amount] =cc.[total_billed_amount],rfc.[total_allowed_amount]=cc.[total_allowed_amount]
         ,rfc.[total_paid_amount]=cc.[total_paid_amount] ,rfc.[claim_status]=cc.[claim_status],rfc.load_date=rfc.last_updated_date
         ,rfc.last_updated_date= getdate()
 WHEN NOT MATCHED THEN
INSERT  VALUES ( [claim_id] ,[encounter_id] ,[payer_id],[admit_date] ,[discharge_date] ,[total_billed_amount] ,[total_allowed_amount]
      ,[total_paid_amount] ,[claim_status] ,getdate() ,getdate() );


--select * from refined_claims --ORDER BY 1 DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.[dbo].[refined_encounters] AS rfe
USING dev_HealthConnect_cleansed.[dbo].[cleansed_encounters] AS ce
    ON (rfe.[encounter_id]=ce.[encounter_id] and rfe.[patient_id] = ce.[patient_id]   AND rfe.[provider_id] = ce.[provider_id])
    WHEN MATCHED AND (
       rfe.[encounter_type]   <> ce.[encounter_type]
    OR rfe.[encounter_start]  <> ce.[encounter_start]
    OR rfe.[encounter_end]    <> ce.[encounter_end]
    OR rfe.[height_cm]        <> ce.[height_cm]
    OR rfe.[weight_kg]        <> ce.[weight_kg]
    OR rfe.[systolic_bp]      <> ce.[systolic_bp]
    OR rfe.[diastolic_bp]     <> ce.[diastolic_bp]
)
THEN
    UPDATE SET
        rfe.[encounter_type]   = ce.[encounter_type],
        rfe.[encounter_start]  = ce.[encounter_start],
        rfe.[encounter_end]    = ce.[encounter_end],
        rfe.[height_cm]        = ce.[height_cm],
        rfe.[weight_kg]        = ce.[weight_kg],
        rfe.[systolic_bp]      = ce.[systolic_bp],
        rfe.[diastolic_bp]     = ce.[diastolic_bp],
        rfe.load_date=  rfe.[last_updated_date],
        rfe.[last_updated_date] = GETDATE()

WHEN NOT MATCHED THEN
    INSERT   VALUES (ce.[encounter_id],ce.[patient_id],  ce.[provider_id],     ce.[encounter_type],   ce.[encounter_start],   ce.[encounter_end],
            ce.[height_cm],            ce.[weight_kg],            ce.[systolic_bp],            ce.[diastolic_bp],            GETDA


            --------------------------------------------------------------*******************___________________________________________


CREATE OR ALTER PROCEDURE [dbo].[MergerefinedTables]
AS
BEGIN
    SET NOCOUNT ON;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MEDICATIONS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_medications AS rfm
USING dev_healthConnect_cleansed.dbo.cleansed_medications AS cm
    ON (rfm.medication_id = cm.medication_id AND rfm.encounter_id = cm.encounter_id)
WHEN MATCHED AND (
        rfm.drug_name <> cm.drug_name
     OR rfm.route <> cm.route
     OR rfm.dose <> cm.dose
     OR rfm.frequency <> cm.frequency
     OR rfm.days_supply <> cm.days_supply
)
THEN
    UPDATE SET
        rfm.drug_name = cm.drug_name,
        rfm.route = cm.route,
        rfm.dose = cm.dose,
        rfm.frequency = cm.frequency,
        rfm.days_supply = cm.days_supply,
        rfm.load_date = rfm.last_updated_date,
        rfm.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (medication_id, encounter_id, drug_name, route, dose, frequency, days_supply, load_date, last_updated_date)
    VALUES (cm.medication_id, cm.encounter_id, cm.drug_name, cm.route, cm.dose, cm.frequency, cm.days_supply, GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CLAIMS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_claims AS rfc
USING dev_healthConnect_cleansed.dbo.cleansed_claims AS cc
    ON (rfc.claim_id = cc.claim_id AND rfc.encounter_id = cc.encounter_id AND rfc.payer_id = cc.payer_id)
WHEN MATCHED AND (
        ISNULL(rfc.admit_date,'') <> ISNULL(cc.admit_date,'')
     OR ISNULL(rfc.discharge_date,'') <> ISNULL(cc.discharge_date,'')
     OR ISNULL(rfc.total_billed_amount,0) <> ISNULL(cc.total_billed_amount,0)
     OR ISNULL(rfc.total_allowed_amount,0) <> ISNULL(cc.total_allowed_amount,0)
     OR ISNULL(rfc.total_paid_amount,0) <> ISNULL(cc.total_paid_amount,0)
     OR ISNULL(rfc.claim_status,'') <> ISNULL(cc.claim_status,'')
)
THEN
    UPDATE SET
        rfc.admit_date = cc.admit_date,
        rfc.discharge_date = cc.discharge_date,
        rfc.total_billed_amount = cc.total_billed_amount,
        rfc.total_allowed_amount = cc.total_allowed_amount,
        rfc.total_paid_amount = cc.total_paid_amount,
        rfc.claim_status = cc.claim_status,
        rfc.load_date = rfc.last_updated_date,
        rfc.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (claim_id, encounter_id, payer_id, admit_date, discharge_date, total_billed_amount,
            total_allowed_amount, total_paid_amount, claim_status, load_date, last_updated_date)
    VALUES (cc.claim_id, cc.encounter_id, cc.payer_id, cc.admit_date, cc.discharge_date,
            cc.total_billed_amount, cc.total_allowed_amount, cc.total_paid_amount, cc.claim_status,
            GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ENCOUNTERS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_encounters AS rfe
USING dev_healthConnect_cleansed.dbo.cleansed_encounters AS ce
    ON (rfe.encounter_id = ce.encounter_id AND rfe.patient_id = ce.patient_id AND rfe.provider_id = ce.provider_id)
WHEN MATCHED AND (
        rfe.encounter_type <> ce.encounter_type
     OR rfe.encounter_start <> ce.encounter_start
     OR rfe.encounter_end <> ce.encounter_end
     OR rfe.height_cm <> ce.height_cm
     OR rfe.weight_kg <> ce.weight_kg
     OR rfe.systolic_bp <> ce.systolic_bp
     OR rfe.diastolic_bp <> ce.diastolic_bp
)
THEN
    UPDATE SET
        rfe.encounter_type = ce.encounter_type,
        rfe.encounter_start = ce.encounter_start,
        rfe.encounter_end = ce.encounter_end,
        rfe.height_cm = ce.height_cm,
        rfe.weight_kg = ce.weight_kg,
        rfe.systolic_bp = ce.systolic_bp,
        rfe.diastolic_bp = ce.diastolic_bp,
        rfe.load_date = rfe.last_updated_date,
        rfe.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (encounter_id, patient_id, provider_id, encounter_type, encounter_start, encounter_end,
            height_cm, weight_kg, systolic_bp, diastolic_bp, load_date, last_updated_date)
    VALUES (ce.encounter_id, ce.patient_id, ce.provider_id, ce.encounter_type, ce.encounter_start,
            ce.encounter_end, ce.height_cm, ce.weight_kg, ce.systolic_bp, ce.diastolic_bp,
            GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DIAGNOSES
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_diagnoses AS rfd
USING dev_healthConnect_cleansed.dbo.cleansed_diagnoses AS cd
    ON (rfd.diagnosis_id = cd.diagnosis_id AND rfd.encounter_id = cd.encounter_id)
WHEN MATCHED AND (
        rfd.diagnosis_description <> cd.diagnosis_description
     OR rfd.is_primary <> cd.is_primary
)
THEN
    UPDATE SET
        rfd.diagnosis_description = cd.diagnosis_description,
        rfd.is_primary = cd.is_primary,
        rfd.load_date = rfd.last_updated_date,
        rfd.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (diagnosis_id, encounter_id, diagnosis_description, is_primary, load_date, last_updated_date)
    VALUES (cd.diagnosis_id, cd.encounter_id, cd.diagnosis_description, cd.is_primary, GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PROCEDURES
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_procedures AS rfp
USING dev_healthConnect_cleansed.dbo.cleansed_procedures AS cp
    ON (rfp.procedure_id = cp.procedure_id AND rfp.encounter_id = cp.encounter_id)
WHEN MATCHED AND (rfp.procedure_description <> cp.procedure_description)
THEN
    UPDATE SET
        rfp.procedure_description = cp.procedure_description,
        rfp.load_date = rfp.last_updated_date,
        rfp.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (procedure_id, encounter_id, procedure_description, load_date, last_updated_date)
    VALUES (cp.procedure_id, cp.encounter_id, cp.procedure_description, GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PROVIDERS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_providers AS rpr
USING dev_healthConnect_cleansed.dbo.cleansed_providers AS cpr
    ON (rpr.provider_id = cpr.provider_id)
WHEN MATCHED AND (
        rpr.first_name <> cpr.first_name
     OR rpr.last_name <> cpr.last_name
     OR rpr.specialty <> cpr.specialty
     OR rpr.npi <> cpr.npi
)
THEN
    UPDATE SET
        rpr.first_name = cpr.first_name,
        rpr.last_name = cpr.last_name,
        rpr.specialty = cpr.specialty,
        rpr.npi = cpr.npi,
        rpr.load_date = rpr.last_updated_date,
        rpr.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (provider_id, first_name, last_name, specialty, npi, load_date, last_updated_date)
    VALUES (cpr.provider_id, cpr.first_name, cpr.last_name, cpr.specialty, cpr.npi, GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PAYERS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_payers AS rpy
USING dev_healthConnect_cleansed.dbo.cleansed_payers AS cpy
    ON (rpy.payer_id = cpy.payer_id)
WHEN MATCHED AND (rpy.payer_name <> cpy.payer_name)
THEN
    UPDATE SET
        rpy.payer_name = cpy.payer_name,
        rpy.load_date = rpy.last_updated_date,
        rpy.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (payer_id, payer_name, load_date, last_updated_date)
    VALUES (cpy.payer_id, cpy.payer_name, GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PATIENTS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO dev_healthConnect_refined.dbo.refined_patients AS rpt
USING dev_healthConnect_cleansed.dbo.cleansed_patients AS cpt
    ON (rpt.patient_id = cpt.patient_id)
WHEN MATCHED AND (
        rpt.first_name <> cpt.first_name
     OR rpt.last_name <> cpt.last_name
     OR rpt.gender <> cpt.gender
     OR rpt.date_of_birth <> cpt.date_of_birth
     OR rpt.state_code <> cpt.state_code
     OR rpt.city <> cpt.city
     OR rpt.phone <> cpt.phone
)
THEN
    UPDATE SET
        rpt.first_name = cpt.first_name,
        rpt.last_name = cpt.last_name,
        rpt.gender = cpt.gender,
        rpt.date_of_birth = cpt.date_of_birth,
        rpt.state_code = cpt.state_code,
        rpt.city = cpt.city,
        rpt.phone = cpt.phone,
        rpt.load_date = rpt.last_updated_date,
        rpt.last_updated_date = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (patient_id, first_name, last_name, gender, date_of_birth, state_code, city, phone, load_date, last_updated_date)
    VALUES (cpt.patient_id, cpt.first_name, cpt.last_name, cpt.gender, cpt.date_of_birth,
            cpt.state_code, cpt.city, cpt.phone, GETDATE(), GETDATE());
-------------------------------------------------------------------------------------------------------------------------------------------------------------

PRINT 'Merge operation completed successfully.';
END;


