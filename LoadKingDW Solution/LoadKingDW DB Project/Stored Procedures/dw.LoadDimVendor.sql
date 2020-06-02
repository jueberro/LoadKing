--USE [LK-GS-EDW]
--GO



CREATE PROCEDURE dw.sp_LoadDimVendor @LoadLogKey INT  AS

BEGIN

/*
DECLARE @LoadLogKey INT
SET @LoadLogKey = 118
*/

DECLARE @RowsInsertedCount int
DECLARE @RowsUpdatedCount int


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimVendor_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimVendor_current	END TRY BEGIN CATCH END CATCH



	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimVendor_work (
		[Vendor]				  [nchar](6) NOT NULL,
		[VendorName]			  [nvarchar](30) NOT NULL,
		[VendorAddress1]          [nvarchar](30) NULL,
		[VendorAddress2]          [nvarchar](30) NULL,
		[VendorCity]              [nvarchar](20) NULL,
		[VendorState]             [nchar](2) NULL,
		[VendorPostalCode]        [nchar](13) NULL,
		[VendorCountry]           [nchar](12) NULL,
		[VendorCounty]            [nchar](12) NULL,
		[VendorIntlFlag]          [nchar](1) NULL,
		[VendorTerritory]         [nchar](2) NULL,
		[VendorCodeArea]          [nchar](2) NULL,
		[VendorEmail]             [nchar](30) NULL,

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
	INSERT INTO #DimVendor_work
			SELECT 		
				 * from dwstage.V_LoadDimVendor
    
    Update #DimVendor_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimVendor_current (Vendor NCHAR(6)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimVendor_current
	SELECT	Vendor
			, Type2RecordHash
	FROM	dw.DimVendor
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimVendor 
	SELECT	*
	FROM	#DimVendor_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimVendor AS DIM
						WHERE	DIM.Vendor = Work.Vendor 
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimVendor		AS DIM
	 JOIN   #DimVendor_work	AS Work
	  ON	Dim.Vendor = Work.Vendor
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT

	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimVendor
	SELECT	Work.*
	FROM	#DimVendor_current AS DIM
	 JOIN   #DimVendor_work    AS Work
	  ON	Dim.Vendor = Work.Vendor
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimVendor_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimVendor_current	END TRY BEGIN CATCH END CATCH
	 

END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO


