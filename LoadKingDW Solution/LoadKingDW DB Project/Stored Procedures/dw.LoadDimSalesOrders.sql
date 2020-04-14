CREATE PROCEDURE [dw].[sp_LoadDimSalesOrders] @LoadLogKey INT  AS

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
   	[DimCustomer_Key] [int] NOT NULL,
	[DimCustomerShipTo_Key] [int] NOT NULL,
	[OrderDateDimDate_Key] [int] NULL,
	[DueDateDimDate_Key] [int] NULL,
	[QuoteCreateDimDate_Key] [int] NULL,
	[QuoteWonLostDimDate] [int] NULL,
	[SONumber] [nchar](7) NOT NULL,
	[CustomerID] [nchar](6) NOT NULL,
	[CustomerName] [nvarchar](50) NULL,
	[ShipToID] [nchar](6) NOT NULL,
	[SOCreationDate] [date] NULL,
	[SODueDate] [date] NULL,
	[OrderSort] [nvarchar](20) NULL,
	[ProjectType] [nvarchar](30) NULL,
	[SalesPerson] [nvarchar](50) NULL,
	[Branch] [nvarchar](2) NULL,
	[ShipVia] [nvarchar](20) NULL,
	[QuoteNumber] [nchar](7) NULL,
	[QuoteCreationDate] [date] NULL,
	[QuoteWonLostDate] [date] NULL,
	[PrimaryGroup] [nchar](2) NULL,
	[ShippingZone] [nchar](6) NULL,
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
				 * from dwstage.V_LoadDimSalesOrders
    
    Update #DimSalesOrders_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimSalesOrders_current ( SONumber NCHAR(7)
	                                          	, Type2RecordHash   VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimSalesOrders_current
	SELECT		SONumber, Type2RecordHash

	FROM	dw.DimSalesOrders
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimSalesOrders 
	SELECT	*
	FROM	#DimSalesOrders_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimSalesOrders AS DIM
						WHERE	DIM.SONumber = Work.SONumber 
						   
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimSalesOrders		AS DIM
	 JOIN   #DimSalesOrders_work	AS Work
	  ON	Dim.SONumber = Work.SONumber
	     AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimSalesOrders
	SELECT	Work.*
	FROM	#DimSalesOrders_current AS DIM
	 JOIN   #DimSalesOrders_work    AS Work
	  ON	Dim.SONumber = Work.SONumber
	  
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimSalesOrders_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimSalesOrders_current	END TRY BEGIN CATCH END CATCH
	 

END