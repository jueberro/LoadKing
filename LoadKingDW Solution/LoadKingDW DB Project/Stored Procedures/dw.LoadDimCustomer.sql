CREATE PROCEDURE [dw].[sp_LoadDimCustomer] @LoadLogKey INT  AS

BEGIN

	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimCustomer_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimCustomer_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimCustomer_work (
		[CustomerID]				[nchar](6) NOT NULL,
		[CustomerName]				[nvarchar](50) NOT NULL,
		[CustomerAddress1]          [nvarchar](100) NULL,
		[CustomerAddress2]          [nvarchar](100) NULL,
		[CustomerCity]              [nvarchar](100) NULL,
		[CustomerStateOrProvince]   [nvarchar](10) NULL,
		[CustomerPostalCode]        [nvarchar](50) NULL,
		[CustomerCountry]           [nvarchar](50) NULL,
		[CustomerCounty]            [nvarchar](50) NULL,
		[CustomerInternationalFlag] [bit] NULL,
		[CustomerTerritory]         [nchar](2) NULL,
		[CustomerCodeArea]          [nchar](2) NULL,
		[CustomerCredit]            [nchar](2) NULL,

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
	INSERT INTO #DimCustomer_work
			SELECT 		
				 * from dwstage.V_LoadDimCustomer
    
    Update #DimCustomer_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimCustomer_current (CustomerID NCHAR(5)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimCustomer_current
	SELECT	CustomerID
			, Type2RecordHash
	FROM	dw.DimCustomer
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimCustomer 
	SELECT	*
	FROM	#DimCustomer_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimCustomer AS DIM
						WHERE	DIM.CustomerID = Work.CustomerID 
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimCustomer		AS DIM
	 JOIN   #DimCustomer_work	AS Work
	  ON	Dim.CustomerD = Work.CustomerID
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimCustomer
	SELECT	Work.*
	FROM	#DimCustomer_current AS DIM
	 JOIN   #DimCustomer_work    AS Work
	  ON	Dim.CustomerID = Work.CustomerID
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimCustomer_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimCustomer_current	END TRY BEGIN CATCH END CATCH
	 

END