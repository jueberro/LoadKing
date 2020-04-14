CREATE PROCEDURE [dw].[sp_LoadDimSalesOrder] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimSalesOrders_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimSalesOrders_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimSalesOrders_work (
  
	[SalesOrderNumber] [nchar](7) NOT NULL,
	[SOCreationDate] [date] NULL,
	[SODueDate] [date] NULL,
	[SODatelastChanged] DATE NULL,
	[SOLastChangeBy] [nvarchar](8) NULL,
	
	

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
	INSERT INTO #DimSalesOrders_work
			SELECT 		
				 * from dwstage.V_LoadDimSalesOrder
    
    Update #DimSalesOrders_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimSalesOrders_current ( SalesOrderNumber NCHAR(7)
	                                          	, Type2RecordHash   VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimSalesOrders_current
	SELECT		SalesOrderNumber, Type2RecordHash

	FROM	dw.DimSalesOrder
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimSalesOrder
	SELECT	*
	FROM	#DimSalesOrders_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimSalesOrder AS DIM
						WHERE	DIM.SalesOrderNumber = Work.SalesOrderNumber 
						   
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimSalesOrder		AS DIM
	 JOIN   #DimSalesOrders_work	AS Work
	  ON	Dim.SalesOrderNumber = Work.SalesOrderNumber
	     AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimSalesOrder
	SELECT	Work.*
	FROM	#DimSalesOrders_current AS DIM
	 JOIN   #DimSalesOrders_work    AS Work
	  ON	Dim.SalesOrderNumber = Work.SalesOrderNumber
	  
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimSalesOrders_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimSalesOrders_current	END TRY BEGIN CATCH END CATCH
	 

END