--USE [LK-GS-EDW]
--GO


CREATE PROCEDURE dw.sp_LoadDimQuote @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	DECLARE @RowsInsertedCount int
    DECLARE @RowsUpdatedCount int


	BEGIN TRY DROP TABLE #DimQuote_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimQuote_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimQuote_work (
		[QuoteNumber]				[nchar](7) NOT NULL,
		[QuoteCreationDate]			datetime NULL,
		[QuoteWonLossDate]			datetime NULL,

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
	INSERT INTO #DimQuote_work
			SELECT 		
				 * from dwstage.V_LoadDimQuote
    
    Update #DimQuote_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimQuote_current (QuoteNumber NVARCHAR(7)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimQuote_current
	SELECT	QuoteNumber
			, Type2RecordHash
	FROM	dw.DimQuote
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimQuote 
	SELECT	*
	FROM	#DimQuote_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimQuote AS DIM
						WHERE	DIM.QuoteNumber = Work.QuoteNumber 
						)
SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimQuote		AS DIM
	 JOIN   #DimQuote_work	AS Work
	  ON	Dim.QuoteNumber  = Work.QuoteNumber 
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT	
	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimSalesPerson
	SELECT	Work.*
	FROM	#DimQuote_current AS DIM
	 JOIN   #DimQuote_work    AS Work
	  ON	Dim.QuoteNumber = Work.QuoteNumber
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimQuote_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimQuote_current	END TRY BEGIN CATCH END CATCH
	 

END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO


