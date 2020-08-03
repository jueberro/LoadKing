--USE [LK-GS-EDW]
--GO


CREATE PROCEDURE dw.sp_LoadDimEmployee @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

DECLARE @RowsInsertedCount int
DECLARE @RowsUpdatedCount int

	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimEmployee_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimEmployee_current	END TRY BEGIN CATCH END CATCH

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
		[EmployeeInitials]          NVARCHAR(3)     NULL,

		[PAY_TYPE]					char(1)			NULL,
		[FREQUENCY]					char(1)			NULL,
		[RATE]						numeric(9,3)	NULL,
		[SHIFT]						char(1)			NULL,

		/*Hashes used for identifying changes, not required for reporting*/
		[Type1RecordHash]			VARBINARY(64)  	NULL,	--66 allows for "0x" + 64 characater hash
		[Type2RecordHash]			VARBINARY(64)	NULL,	--66 allows for "0x" + 64 characater hash

		/*DW Metadata fields, not required for reporting*/
		[SourceSystemName]			NVARCHAR(100)		NOT NULL,
		[DWEffectiveStartDate]		DATETIME2(7)		NOT NULL,
		[DWEffectiveEndDate]		DATETIME2(7)		NOT NULL,
		[DWIsCurrent]				BIT					NOT NULL,

		/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
		[LoadLogKey]				INT
	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #DimEmployee_work
			SELECT 		
				 * from dwstage.V_LoadDimEmployee
    
    Update #DimEmployee_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimEmployee_current (EmployeeID NCHAR(5)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimEmployee_current
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

SET @RowsInsertedCount = @@ROWCOUNT

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
	FROM	#DimEmployee_current AS DIM
	 JOIN   #DimEmployee_work	AS Work
	  ON	Dim.EmployeeID = Work.EmployeeID
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimEmployee_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimEmployee_current	END TRY BEGIN CATCH END CATCH

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount
	 

END
GO


