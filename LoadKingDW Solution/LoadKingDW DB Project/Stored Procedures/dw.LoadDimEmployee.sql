CREATE PROCEDURE [dw].[sp_LoadDimEmployee] @LoadLogKey INT  AS

BEGIN

	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)
	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimEmployee_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #Dim_Employee_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimEmployee_work (
		[EmployeeID]				NCHAR (5)		NOT NULL,
		[EmployeeRecordType]		NCHAR (1)		NULL,
		[EmployeeName]				NVARCHAR (100)	NULL,
		[EmployeeAddress]			NVARCHAR (100)	NULL,
		[EmployeeCity]				NVARCHAR (50)	NULL,
		[EmployeeState]				NCHAR (2)		NULL,
		[EmployeePostalCode]		NCHAR (9)		NULL,
		[EmployeeGender]			NCHAR (1)		NULL,
		[EmployeeHireDate]			DATE			NULL,
		[EmployeeTerminationDate]	DATE			NULL,
		[EmployeeDepartment]		NCHAR (4)		NULL,
		[EmployeeIsSalesperson]		BIT				NULL,

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

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #DimEmployee_work
	SELECT 		
		  [EmployeeID]				= CAST(EMPLOYEE				AS NCHAR(5))
		, [EmployeeRecordType]		= CAST(RECORD_TYPE			AS NCHAR(1))
		, [EmployeeName]			= CAST([NAME]				AS NVARCHAR(100))
		, [EmployeeAddress]			= CAST([ADDRESS]			AS NVARCHAR(100))
		, [EmployeeCity]			= CAST(CITY					AS NVARCHAR(50))
		, [EmployeeState]			= CAST([STATE]				AS NCHAR(2))	
		, [EmployeePostalCode]		= CAST(ZIP_CODE				AS NCHAR(9))
		, [EmployeeGender]			= CAST(SEX					AS NCHAR(1))
		, [EmployeeHireDate]		= dwstage.udf_cv_nvarchar6_to_date(DATE_HIRE)
		, [EmployeeTerminationDate]	= dwstage.udf_cv_nvarchar6_to_date(DATE_TERMINATION)
		, [EmployeeDepartment]		= CAST(DEPT_EMPLOYEE		AS NCHAR(4))
		, [EmployeeIsSalesperson]	= CAST(0					AS BIT) 	
		
		, [Type1RecordHash]			= CAST('0x0000' AS VARCHAR(66))
		, [Type2RecordHash]			= CAST(HASHBYTES('SHA2_256', CAST(EMPLOYEE		AS NCHAR(5))
															+ CAST(RECORD_TYPE		AS NCHAR(1))
															+ CAST([NAME]			AS NVARCHAR(100))
															+ CAST([ADDRESS]		AS NVARCHAR(100))
															+ CAST(CITY				AS NVARCHAR(50))
															+ CAST([STATE]			AS NCHAR(2))	
															+ CAST(ZIP_CODE			AS NCHAR(9))
															+ CAST(SEX				AS NCHAR(1))
															+ dwstage.udf_cv_nvarchar6_to_date(DATE_HIRE)
															+ dwstage.udf_cv_nvarchar6_to_date(DATE_TERMINATION)
															+ CAST(DEPT_EMPLOYEE	AS NCHAR(4))
															+ CAST(0				AS BIT)) AS VARCHAR(66))
		
		, [SourceSystemName]		= CAST('Global Shop' AS		NVARCHAR(100))
		, [DWEffectiveStartDate]	= @CurrentTimestamp
		, [DWEffectiveEndDate]		= '2100-01-01'
		, [DWIsCurrent]				= CAST(1					AS BIT)
		
		, [LoadLogKey]				= @LoadLogKey
	FROM  dwstage.EMPLOYEE_MSTR


	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #Dim_Employee_current (EmployeeID NCHAR(5)
										, Type2RecordHash VARBINARY(62)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #Dim_Employee_current
	SELECT	EmployeeID
			, Type2RecordHash
	FROM	dw.DimEmployee
	WHERE	DWIsCurrent = 1






	--INSERT NEW Dimension Items
	INSERT INTO dw.DimEmployee 
	SELECT	*
	FROM	#DimEmployee_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimEmployee AS DIM
						WHERE	DIM.EmployeeID = Work.EmployeeID 
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimEmployee		AS DIM
	 JOIN   #DimEmployee_work	AS Work
	  ON	Dim.EmployeeID = Work.EmployeeID
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimEmployee
	SELECT	Work.*
	FROM	#Dim_Employee_current AS DIM
	 JOIN   #DimEmployee_work	AS Work
	  ON	Dim.EmployeeID = Work.EmployeeID
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimEmployee_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #Dim_Employee_current	END TRY BEGIN CATCH END CATCH
	 

END
