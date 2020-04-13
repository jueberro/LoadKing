CREATE PROCEDURE [dw].[sp_LoadFactSalesOrderLine] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

SELECT		@CurrentTimestamp = GETUTCDATE()
	
	--Set @LoadLogKey = 21

	BEGIN TRY DROP TABLE #FactSalesOrderLine_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #FactSalesOrderLine_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #FactSalesOrderLine_work (
  
      FactSalesOrder_Key int not null
	, DimCustomer_Key int not null
	, OrderDateDimDate_Key int not null
	, ShipDateDimDate_Key int not null
	, DimCustomerShipTo_Key int not null
	, DimPart_Key int not null
	--, DimEmployee_Key int not null -- In Header
	--, DimOrderType_Key int not null
	--, DimProduct_Key int not null

	-- Key Attributes 

	, OrderNumber               nchar(7)
	, OrderLine                 nchar(4)
	, ShipToId                  nchar(6)
	, OrderDate                 datetime
	, Shipdate                  datetime
	, Customer                  nchar(6)
	, Part                      nchar(20)

	-- measures
	, QuantityOrdered decimal (13,4) -- should quantity be decimal??
	, Cost decimal (16,4) 
	, Margin decimal(16,4)
	, Price decimal(16,4)
	, PriceDiscount decimal(16,4)
	, PricePerPound decimal(16,4)
	, DiscountAmount decimal(16,4)
	, OrderDiscount decimal(5,4)
	, PriceClassDiscount decimal(5,4) 
	, ProductLineDiscount decimal(5,4)
	, OrderDiscountAmount decimal(16,4)
	, ProductClassDiscountAmount decimal(16,4)
	, ProductLineDiscountAmount decimal(16,4)
	, OrderPrice decimal(16,4)
	, OrderDiscountPrice decimal(16,4)
	, OrderPricePerPound decimal(16,4)
	/*Hash used for identifying changes, not required for reporting*/
		/*Hash used for identifying changes, not required for reporting*/
	,RecordHash					VARBINARY(64)			NULL

	/*DW Metadata fields, not required for reporting*/
	,SourceSystemName			NVARCHAR(100)		NOT NULL
    ,DWEffectiveStartDate		DATETIME2(7)		NOT NULL
	,DWEffectiveEndDate			DATETIME2(7)		NOT NULL
	,DWIsCurrent					BIT				NOT NULL

	/*ETL Metadata fields, not required for reporting */
	,LoadLogKey					INT					NOT NULL	--ID of ETL process that inserted the record
	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #FactSalesOrderLine_work
			SELECT 		
				 * from dwstage.V_LoadFactSalesOrderLines 
				     
    
    Update #FactSalesOrderLine_work 
	Set 
	[DWEffectiveStartDate] = @CurrentTimestamp, 
	[LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #FactSalesOrderLine_current ( OrderNumber NCHAR(7)
	                                        ,  OrderLine   NCHAR(4)
									    	,  RecordHash   VARBINARY(64)
										     )

	--Load temp table with NK and Type2RecordHash for CURRENT Extension records
	INSERT INTO #factSalesOrderLine_current
	SELECT		OrderNumber, 
	            OrderLine, 
				RecordHash

	FROM	dw.FactSalesOrderLine
	WHERE	DWIsCurrent = 1


	--INSERT NEW Fact Items
	INSERT INTO dw.FactSalesOrderLine
	SELECT	*
	FROM	#FactSalesOrderLine_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactSalesOrderLine AS Fact
						WHERE	Fact.OrderNumber = Work.OrderNumber
						 AND    Fact.OrderLine   = Work.OrderLine
						 
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	Fact
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.FactSalesOrderLine		AS Fact
	 JOIN   #FactSalesOrderLine_work	AS Work
	  ON	fact.OrderLine = Work.OrderLine
	      AND fact.OrderNumber = Work.OrderNumber
	        AND	fact.DWIsCurrent = 1
	WHERE	Fact.RecordHash <> Work.RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.FactSalesOrderLine
	SELECT	Work.*
	FROM	#FactSalesOrderLine_current AS Fact
	 JOIN   #FactSalesOrderLine_work    AS Work
	  ON	Fact.OrderNumber = Work.OrderNumber
	    AND   Fact.OrderLine = Work.OrderNumber
	  
	WHERE	Fact.RecordHash <> Work.RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #FactSalesOrderLine_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #FactSalesOrderLine_current	END TRY BEGIN CATCH END CATCH
	 

END

