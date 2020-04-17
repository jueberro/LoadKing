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
  
	 [SalesOrderNumber]            [nchar](7)          NOT NULL
	,[SOCreationDate]              [date] NULL
	,[SODueDate]                   [date] NULL
	,[SODatelastChanged]           [date] NULL

	,[OLDateOrder]               datetime    --[DATE_ORDER] nvarchar(6) - Use nvarchar6 udf
	,[OLDateShipped]             datetime    --[DATE_SHIP]  nvarchar(6) - Use nvrachar6 udf

	   --NewKeyAttributes

	,[User1]                     varchar(30) --[USER_1] [char](30) NULL,	User1
    ,[User2]                     varchar(30) --[USER_2] [char](30) NULL,	User2
    ,[TrackingNotes]             varchar(30) --[USER_3] [char](30) NULL,	TrackingNotes
    ,[User4]                     varchar(30) --[USER_4] [char](30) NULL,	User3
    ,[LineShipVia]               varchar(30) --[USER_5] [char](30) NULL,	LineShipVia
	,[SOLastChangeBy]            [nvarchar](8) NULL

	,[PromiseDimDate]            datetime    --[ITEM_PROMISE_DT] date NULL,	PromiseDateDimDate
    ,[DateAddedDimDate]          datetime    --[ADD_BY_DATE] date NULL,	DateAddedDateDimDate
    ,[DeliverByDateDimDate]      datetime    --[MUST_DLVR_BY_DATE] date NULL,	DeliverByDateDimDate

	
	,[CustomerPart]              varchar(20) --[CUSTOMER_PART] [char](20) NULL,	CustomerPart
    ,[PriceGrpID]                varchar(20) --[INFO_1] [char](20) NULL,	PriceGroupID
	,[SOGroupID]                 varchar(20) --[INFO_2] [char](20) NULL,	SOGroupID
	,[OrderSort]                 varchar(20) --[CODE_SORT] [nvarchar](20) NULL,
	
	,[Type1RecordHash] [varbinary](64) NULL
	,[Type2RecordHash] [varbinary](64) NULL
	,[SourceSystemName] [nvarchar](100) NOT NULL
	,[DWEffectiveStartDate] [datetime2](7) NOT NULL
	,[DWEffectiveEndDate] [datetime2](7) NOT NULL
	,[DWIsCurrent] [bit] NOT NULL
	,[LoadLogKey] [int] NOT NULL 
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