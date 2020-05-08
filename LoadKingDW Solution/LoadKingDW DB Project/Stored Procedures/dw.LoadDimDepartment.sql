--USE [LK-GS-EDW]
--GO


CREATE PROCEDURE dw.sp_LoadDimDepartment @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	--BEGIN TRY DROP TABLE ##DimDepartment_SOURCE		END TRY BEGIN CATCH END CATCH
	--BEGIN TRY DROP TABLE ##DimDepartment_TARGET	END TRY BEGIN CATCH END CATCH

IF object_id('##DimDepartment_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##DimDepartment_SOURCE
	END

IF object_id('##DimDepartment_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##DimDepartment_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##DimDepartment_SOURCE (
		[DepartmentID]				[nchar](6) NOT NULL,
		[DepartmentName]			[nvarchar](50) NULL,
		[LAST_DATE_CHG]				datetime NULL,
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

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##DimDepartment_SOURCE
			SELECT 		
				 * from dwstage.V_LoadDimDepartment

--SELECT * FROM ##DimDepartment_SOURCE

    Update ##DimDepartment_SOURCE Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE ##DimDepartment_TARGET (DepartmentID NCHAR(5)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO ##DimDepartment_TARGET
	SELECT	DepartmentID
			, Type2RecordHash
	FROM	dw.DimDepartment
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimDepartment 
	SELECT	*
	FROM	##DimDepartment_SOURCE AS SOURCE
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimDepartment AS DIM
						WHERE	DIM.DepartmentID = SOURCE.DepartmentID 
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimDepartment		AS DIM
	 JOIN   ##DimDepartment_SOURCE	AS SOURCE
	  ON	Dim.DepartmentID = SOURCE.DepartmentID
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> SOURCE.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimDepartment
	SELECT	SOURCE.*
	FROM	##DimDepartment_TARGET AS DIM
	 JOIN   ##DimDepartment_SOURCE    AS SOURCE
	  ON	Dim.DepartmentID = SOURCE.DepartmentID
	WHERE	DIM.Type2RecordHash <> SOURCE.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE ##DimDepartment_SOURCE		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE ##DimDepartment_TARGET	END TRY BEGIN CATCH END CATCH
	 

END
GO


