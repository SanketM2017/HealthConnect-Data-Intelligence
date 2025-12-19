
Create Database dev_HealthConnect_raw

Create Database dev_HealthConnect_cleansed

Create Database  dev_HealthConnect_Refined


use dev_HealthConnect_raw


CREATE TABLE raw_patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    date_of_birth DATE NOT NULL,
    state_code CHAR(2),
    city VARCHAR(50),
    phone VARCHAR(15)
);

Create table raw_providers (
provider_id INT Primary Key,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
specialty VARCHAR(50),
npi VARCHAR(20) Unique
);

CREATE TABLE raw_payers (
    payer_id INT PRIMARY KEY,
    payer_name VARCHAR(100) NOT NULL
);

-- 4. raw_encounters
CREATE TABLE raw_encounters (
    encounter_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    provider_id INT NOT NULL,
    encounter_type VARCHAR(10) CHECK (encounter_type IN ('OPD', 'ER', 'IPD')),
    encounter_start DATETIME,
    encounter_end DATETIME,
    height_cm INT,
    weight_kg FLOAT,
    systolic_bp INT,
    diastolic_bp INT,
    CONSTRAINT FK_raw_encounters_patient FOREIGN KEY (patient_id)
        REFERENCES raw_patients(patient_id),
    CONSTRAINT FK_raw_encounters_provider FOREIGN KEY (provider_id)
        REFERENCES raw_providers(provider_id)
);

-- 5. raw_diagnoses
CREATE TABLE raw_diagnoses (
    diagnosis_id INT PRIMARY KEY,
    encounter_id INT NOT NULL,
    diagnosis_description VARCHAR(100),
    is_primary BIT,
    CONSTRAINT FK_raw_diagnoses_encounter FOREIGN KEY (encounter_id)
        REFERENCES raw_encounters(encounter_id)
);


-- 6. raw_procedures
CREATE TABLE raw_procedures (
    procedure_id INT PRIMARY KEY,
    encounter_id INT NOT NULL,
    procedure_description VARCHAR(100),
    CONSTRAINT FK_raw_procedures_encounter FOREIGN KEY (encounter_id)
        REFERENCES raw_encounters(encounter_id)
);

-- 7. raw_medications
CREATE TABLE raw_medications (
    medication_id INT PRIMARY KEY,
    encounter_id INT NOT NULL,
    drug_name VARCHAR(50),
    route VARCHAR(20),
    dose VARCHAR(20),
    frequency VARCHAR(10),
    days_supply INT,
    CONSTRAINT FK_raw_medications_encounter FOREIGN KEY (encounter_id)
        REFERENCES raw_encounters(encounter_id)
);


-- 8. raw_claims
CREATE TABLE raw_claims (
    claim_id INT PRIMARY KEY,
    encounter_id INT NOT NULL,
    payer_id INT NOT NULL,
    admit_date DATE,
    discharge_date DATE,
    total_billed_amount FLOAT,
    total_allowed_amount FLOAT,
    total_paid_amount FLOAT,
    claim_status VARCHAR(20) CHECK (claim_status IN ('Pending', 'Approved', 'Rejected', 'Paid')),
    CONSTRAINT FK_raw_claims_encounter FOREIGN KEY (encounter_id)
        REFERENCES raw_encounters(encounter_id),
    CONSTRAINT FK_raw_claims_payer FOREIGN KEY (payer_id)
        REFERENCES raw_payers(payer_id)
);

