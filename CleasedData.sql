use dev_HealthConnect_cleansed

CREATE TABLE cleansed_patients(
	[patient_id] [int] NOT NULL,
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[gender] [char](1) NULL,
	[date_of_birth] [date] NULL,
	[state_code] [char](2) NULL,
	[city] [varchar](50) NULL,
	[phone] [varchar](15) NULL,
    load_date date
    )
CREATE TABLE cleansed_providers (
    provider_id INT ,
    first_name VARCHAR(50) ,
    last_name VARCHAR(50),
    specialty VARCHAR(50),
    npi VARCHAR(20) ,
    load_date date
);

CREATE TABLE cleansed_payers (
    payer_id INT,
    payer_name VARCHAR(100) ,
    load_date date
);


CREATE TABLE cleansed_encounters (
    encounter_id INT ,
    patient_id INT ,
    provider_id INT ,
    encounter_type VARCHAR(10) ,
    encounter_start DATETIME,
    encounter_end DATETIME,
    height_cm INT,
    weight_kg FLOAT,
    systolic_bp INT,
    diastolic_bp INT,
    load_date date
);

CREATE TABLE cleansed_diagnoses (
    diagnosis_id INT ,
    encounter_id INT ,
    diagnosis_description VARCHAR(100),
    is_primary BIT,
    load_date date
   
)


CREATE TABLE cleansed_procedures (
    procedure_id INT ,
    encounter_id INT ,
    procedure_description VARCHAR(100),
    load_date date
);

CREATE TABLE cleansed_medications (
    medication_id INT ,
    encounter_id INT ,
    drug_name VARCHAR(50),
    route VARCHAR(20),
    dose VARCHAR(20),
    frequency VARCHAR(10),
    days_supply INT,
    load_date date
);


CREATE TABLE cleansed_claims (
    claim_id INT,
    encounter_id INT ,
    payer_id INT ,
    admit_date DATE,
    discharge_date DATE,
    total_billed_amount FLOAT,
    total_allowed_amount FLOAT,
    total_paid_amount FLOAT,
    claim_status VARCHAR(20) ,
    load_date date
    )
    

    --insert table 

    CREATE TABLE cleansed_claims (
    claim_id INT,
    encounter_id INT ,
    payer_id INT ,
    admit_date DATE,
    discharge_date DATE,
    total_billed_amount FLOAT,
    total_allowed_amount FLOAT,
    total_paid_amount FLOAT,
    claim_status VARCHAR(20) ,
    load_date date
    )
    



-