


USE dev_HealthConnect_raw;
GO

CREATE OR ALTER PROCEDURE MergerrawTables
AS
BEGIN
    SET NOCOUNT ON;

    -- =============================================
    -- Declare File Existence Variables
    -- =============================================
    DECLARE 
        @patientsFileExists INT,
        @claimsFileExists INT,
        @diagnosesFileExists INT,
        @encountersFileExists INT,
        @medicationsFileExists INT,
        @payersFileExists INT,
        @proceduresFileExists INT,
        @providersFileExists INT;

    -- =============================================
    -- File Paths
    -- =============================================
    DECLARE 
        @patientsFilePath NVARCHAR(255)   = N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\patients_'    + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv',
        @claimsFilePath NVARCHAR(255)     = N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\claims_'      + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv',
        @diagnosesFilePath NVARCHAR(255)  = N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\diagnoses_'   + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv',
        @encountersFilePath NVARCHAR(255) = N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\encounters_'  + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv',
        @medicationsFilePath NVARCHAR(255)= N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\medications_' + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv',
        @payersFilePath NVARCHAR(255)     = N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\payers_'      + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv',
        @proceduresFilePath NVARCHAR(255) = N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\procedures_'  + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv',
        @providersFilePath NVARCHAR(255)  = N'C:\IntellibiSQL_Project\HelthConnect\InboundFiles\providers_'   + FORMAT(GETDATE(), 'ddMMyyyy') + '.csv';

    -- =============================================
    -- Check File Existence
    -- =============================================
    EXEC master.dbo.xp_fileexist @patientsFilePath,    @patientsFileExists OUTPUT;
    EXEC master.dbo.xp_fileexist @claimsFilePath,      @claimsFileExists OUTPUT;
    EXEC master.dbo.xp_fileexist @diagnosesFilePath,   @diagnosesFileExists OUTPUT;
    EXEC master.dbo.xp_fileexist @encountersFilePath,  @encountersFileExists OUTPUT;
    EXEC master.dbo.xp_fileexist @medicationsFilePath, @medicationsFileExists OUTPUT;
    EXEC master.dbo.xp_fileexist @payersFilePath,      @payersFileExists OUTPUT;
    EXEC master.dbo.xp_fileexist @proceduresFilePath,  @proceduresFileExists OUTPUT;
    EXEC master.dbo.xp_fileexist @providersFilePath,   @providersFileExists OUTPUT;

    -- =============================================
    -- Declare BULK INSERT SQL Variables
    -- =============================================
    DECLARE 
        @patientsBulkInsert NVARCHAR(MAX),
        @claimsBulkInsert NVARCHAR(MAX),
        @diagnosesBulkInsert NVARCHAR(MAX),
        @encountersBulkInsert NVARCHAR(MAX),
        @medicationsBulkInsert NVARCHAR(MAX),
        @payersBulkInsert NVARCHAR(MAX),
        @proceduresBulkInsert NVARCHAR(MAX),
        @providersBulkInsert NVARCHAR(MAX);

    -- =============================================
    -- BULK INSERT: Patients
    -- =============================================
    IF @patientsFileExists = 1
    BEGIN
        PRINT 'Patients file exists. Starting BULK INSERT...';
        SET @patientsBulkInsert = N'
        BULK INSERT raw_patients
        FROM ''' + @patientsFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @patientsBulkInsert;
    END
    ELSE PRINT 'Patients file not found.';

    -- =============================================
    -- BULK INSERT: Claims
    -- =============================================
    IF @claimsFileExists = 1
    BEGIN
        PRINT 'Claims file exists. Starting BULK INSERT...';
        SET @claimsBulkInsert = N'
        BULK INSERT raw_claims
        FROM ''' + @claimsFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @claimsBulkInsert;
    END
    ELSE PRINT 'Claims file not found.';

    -- =============================================
    -- BULK INSERT: Diagnoses
    -- =============================================
    IF @diagnosesFileExists = 1
    BEGIN
        PRINT 'Diagnoses file exists. Starting BULK INSERT...';
        SET @diagnosesBulkInsert = N'
        BULK INSERT raw_diagnoses
        FROM ''' + @diagnosesFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @diagnosesBulkInsert;
    END
    ELSE PRINT 'Diagnoses file not found.';

    -- =============================================
    -- BULK INSERT: Encounters
    -- =============================================
    IF @encountersFileExists = 1
    BEGIN
        PRINT 'Encounters file exists. Starting BULK INSERT...';
        SET @encountersBulkInsert = N'
        BULK INSERT raw_encounters
        FROM ''' + @encountersFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @encountersBulkInsert;
    END
    ELSE PRINT 'Encounters file not found.';

    -- =============================================
    -- BULK INSERT: Medications
    -- =============================================
    IF @medicationsFileExists = 1
    BEGIN
        PRINT 'Medications file exists. Starting BULK INSERT...';
        SET @medicationsBulkInsert = N'
        BULK INSERT raw_medications
        FROM ''' + @medicationsFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @medicationsBulkInsert;
    END
    ELSE PRINT 'Medications file not found.';

    -- =============================================
    -- BULK INSERT: Payers
    -- =============================================
    IF @payersFileExists = 1
    BEGIN
        PRINT 'Payers file exists. Starting BULK INSERT...';
        SET @payersBulkInsert = N'
        BULK INSERT raw_payers
        FROM ''' + @payersFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @payersBulkInsert;
    END
    ELSE PRINT 'Payers file not found.';

    -- =============================================
    -- BULK INSERT: Procedures
    -- =============================================
    IF @proceduresFileExists = 1
    BEGIN
        PRINT 'Procedures file exists. Starting BULK INSERT...';
        SET @proceduresBulkInsert = N'
        BULK INSERT raw_procedures
        FROM ''' + @proceduresFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @proceduresBulkInsert;
    END
    ELSE PRINT 'Procedures file not found.';

    -- =============================================
    -- BULK INSERT: Providers
    -- =============================================
    IF @providersFileExists = 1
    BEGIN
        PRINT 'Providers file exists. Starting BULK INSERT...';
        SET @providersBulkInsert = N'
        BULK INSERT raw_providers
        FROM ''' + @providersFilePath + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0A'',
            TABLOCK,
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @providersBulkInsert;
    END
    ELSE PRINT 'Providers file not found.';

END;
GO

