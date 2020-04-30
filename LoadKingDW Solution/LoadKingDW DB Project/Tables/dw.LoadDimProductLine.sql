CREATE PROCEDURE [dw].[sp_LoadDimProductLine] @LoadLogKey INT  AS

BEGIN

	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimProductLine_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimProductLine_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimProductLine_work (
		[ProductLine]				[nchar](6) NOT NULL,
		[ProductLineName]				[nvarchar](50) NOT NULL,

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
	INSERT INTO #DimProductLine_work
			SELECT 		
				 * from dwstage.V_LoadDimProductLine
    
    Update #DimProductLine_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimProductLine_current (ProductLine NCHAR(5)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimProductLine_current
	SELECT	ProductLine
			, Type2RecordHash
	FROM	dw.DimProductLine
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimProductLine 
	SELECT	*
	FROM	#DimProductLine_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimProductLine AS DIM
						WHERE	DIM.ProductLine = Work.ProductLine 
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimProductLine		AS DIM
	 JOIN   #DimProductLine_work	AS Work
	  ON	Dim.CustomerD = Work.ProductLine
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimProductLine
	SELECT	Work.*
	FROM	#DimProductLine_current AS DIM
	 JOIN   #DimProductLine_work    AS Work
	  ON	Dim.ProductLine = Work.ProductLine
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimProductLine_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimProductLine_current	END TRY BEGIN CATCH END CATCH
	 

END