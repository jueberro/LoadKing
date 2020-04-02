CREATE PROCEDURE [dw].[sp_LoadDimEmployee] @LoadLogKey INT  AS

BEGIN

	DECLARE @CurrentTimestamp DATETIME2(7)
	SELECT @CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimEmployee_work END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table
	CREATE TABLE #DimEmployee_work (
		[EmployeeID]				NCHAR (5)      NOT NULL,
		[EmployeeRecordType]		NCHAR (1)      NULL,
		[EmployeeName]				NVARCHAR (100) NULL,
		[EmployeeAddress]			NVARCHAR (100) NULL,
		[EmployeeCity]				NVARCHAR (50)  NULL,
		[EmployeeState]				NCHAR (2)      NULL,
		[EmployeePostalCode]		NCHAR (9)      NULL,
		[EmployeeGender]			NCHAR (1)      NULL,
		[EmployeeHireDate]			DATE			NULL,
		[EmployeeTerminationDate]	DATE          NULL,
		[EmployeeDepartment]		NCHAR (4)      NULL,
		[EmployeeIsSalesperson]		BIT   null,

		/*Hashes used for identifying changes, not required for reporting*/
		[Type1RecordHash]			VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash
		[Type2RecordHash]			VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash

		/*DW Metadata fields, not required for reporting*/
		[SourceSystemName]			NVARCHAR(100)		NOT NULL,
		[DWEffectiveStartDate]		DATETIME2(7)		NOT NULL,
		[DWEffectiveEndDate]		DATETIME2(7)		NOT NULL,
		[DWIsCurrent]				BIT					NOT NULL,

		/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
		[LoadLogKey]					INT
	)



	INSERT INTO #DimEmployee
	SELECT 		
		, [EmployeeID]				= CAST(EMPLOYEE AS NCHAR(5))
		, [EmployeeRecordType]		= CAST(RECORD_TYPE AS NCHAR(1))
		, [EmployeeName]			= CAST(NAME AS NVARCHAR(100))
		, [EmployeeAddress]			= CAST(ADDRESS AS NVARCHAR(100))
		, [EmployeeCity]			= CAST(CITY AS NVARCHAR(50))
		, [EmployeeState]			= CAST(STATE AS NCHAR(2))	
		, [EmployeePostalCode]		= CAST(ZIP_CODE AS NCHAR(9)
		, [EmployeeGender]			= CAST(SEX AS NCAHR(1)
		, [EmployeeHireDate]		= dwstage.udf_cv_nvarchar6_to_date(DATE_HIRE)
		, [EmployeeTerminationDate]	= dwstage.udf_cv_nvarchar6_to_date(DATE_TERMINATION)
		, [EmployeeDepartment]		= CAST(DEPARTMENT_EMPLOYEE AS NCHAR(4)
		, [EmployeeIsSalesperson]	= CAST(0 AS BIT) 	
		
		, [Type1RecordHash]			
		, [Type2RecordHash]			
		
		, [SourceSystemName]			
		, [DWEffectiveStartDate]		
		, [DWEffectiveEndDate]		
		, [DWIsCurrent]				
		
		, /*ETL Metadata fields, not rrtDate may not neccessarily be the same as RecordCreateDate, for example */
		 [LoadLogKey]				
	FROM  dwstage.EMPLOYEE_MSTR


END