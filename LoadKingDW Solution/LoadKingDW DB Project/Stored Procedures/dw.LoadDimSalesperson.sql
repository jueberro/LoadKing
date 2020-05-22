--USE [LK-GS-EDW]
--GO



CREATE PROCEDURE dw.sp_LoadDimSalesperson @LoadLogKey INT  AS

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

	BEGIN TRY DROP TABLE #DimSalesperson_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimSalesperson_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimSalesperson_work (
		[SalespersonID]				[nvarchar](6) NOT NULL,
		[Name]						[nvarchar](100) NOT NULL,
		[Email]						[nvarchar](100) NULL,


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
	INSERT INTO #DimSalesperson_work
			SELECT 		
				 * from dwstage.V_LoadDimSalesperson
    
    Update #DimSalesperson_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimSalesperson_current (SalespersonID NVARCHAR(6)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimSalesperson_current
	SELECT	SalespersonID
			, Type2RecordHash
	FROM	dw.DimSalesPerson
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimSalesperson 
	SELECT	*
	FROM	#DimSalesperson_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimSalesPerson AS DIM
						WHERE	DIM.SalespersonID = Work.SalespersonID 
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimSalesPerson		AS DIM
	 JOIN   #DimSalesperson_work	AS Work
	  ON	Dim.SalespersonID = Work.SalespersonID
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimSalesPerson
	SELECT	Work.*
	FROM	#DimSalesperson_current AS DIM
	 JOIN   #DimSalesperson_work    AS Work
	  ON	Dim.SalespersonID = Work.SalespersonID
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimSalesperson_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimSalesperson_current	END TRY BEGIN CATCH END CATCH
	 

END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO


