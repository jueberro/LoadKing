--USE [LK-GS-EDW]
--GO



CREATE PROCEDURE dw.sp_LoadFactSalesOrderLine @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

	/*
	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table
	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	DECLARE     @RowsInsertedCount int
    DECLARE     @RowsUpdatedCount int


	SELECT		@CurrentTimestamp = GETUTCDATE()

	--BEGIN TRY DROP TABLE ##FactInvoice_SOURCE		END TRY BEGIN CATCH END CATCH
	--BEGIN TRY DROP TABLE ##FactInvoice_TARGET	END TRY BEGIN CATCH END CATCH

IF object_id('##FactInvoice_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactSalesOrderLine_SOURCE
	END

IF object_id('##FactInvoice_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactSalesOrderLine_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactSalesOrderLine_SOURCE (

    -- dimensions

	DimSalesOrder_Key int not null,
	DimCustomer_Key int not null,
	OrderDateDimDate_Key int not null,
	ShipDateDimDate_Key int not null,
	DimCustomerShipTo_Key int not null,
	FactInventory_Key int not null,
	DimGLMaster_Key int not null,
	DimSalesperson_Key int not null,
	DimQuote_Key int not null,
	
	-- Key Attributes 

	[OrderNumber] [nchar](7) NOT NULL,
	[OrderLine] [nchar](4) NULL,
	[OLDateOrder] [datetime] NULL,
	[OLDateShipped] [datetime] NULL,

		--Measure Sources

	[Price]                      [decimal](16, 4) NULL,
	[Cost]                       [decimal](16, 4) NULL,
	[ExtenedPrice]               [decimal](16, 4) NULL,
	[Margin]                     [decimal](16, 4) NULL,
	[QtyOriginal]                [decimal](16, 4) NULL,
	[QtyAllocated]               [decimal](16, 4) NULL,
	[QuantityOrdered]            [decimal](16, 4) NULL,
	[Qty_Shipped]                [decimal](16, 4) NULL,
	[QtyBackOrdered]             [decimal](16, 4) NULL,
	[PriceDiscount]              [decimal](16, 4) NULL,
	[PricePerPound]              [decimal](16, 4) NULL,
	[DiscountAmount]             [decimal](16, 4) NULL,
	[OrderDiscount]              [decimal](16, 4) NULL,
	[ProductClassDiscountAmount] [decimal](16, 4) NULL,
	[ProductLineDiscount]        [decimal](16, 4) NULL,
	[OrderDiscountAmount]        [decimal](16, 4) NULL,
	[PriceClassDiscount]         [decimal](16, 4) NULL,
	[ProductLineDiscountAmount]  [decimal](16, 4) NULL,
	[OrderPrice]                 [decimal](16, 4) NULL,
	[OrderDiscountPrice]         [decimal](16, 4) NULL,
	[OrderPricePerPound]         [decimal](16, 4) NULL,
		
	/*Hash used for identifying changes, not required for reporting*/
	RecordHash					VARBINARY(64)			NULL
	
	)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactSalesOrderLine_SOURCE
			SELECT * from dwstage.V_LoadFactSalesOrderLine --dwstage.V_LoadFactInvoice

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactSalesOrderLine_TARGET 
					(
					                       OrderNumber NCHAR(7),
                                           OrderLine   nchar(4) ,
										   RecordHash   VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactSalesOrderLine_TARGET
	SELECT	
			 OrderNumber
			,OrderLine 
			,RecordHash


	FROM	dw.FactSalesOrderLine

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactSalesOrderLine
	SELECT	*
	FROM	##FactSalesOrderLine_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactSalesOrderLine AS TGT
						WHERE	
							    TGT.OrderNumber = SRC.OrderNumber
							and TGT.OrderLine   = SRC.OrderLine 
							
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

 TGT.[DimSalesOrder_Key]               = SRC.DimsalesOrder_Key
,TGT.[DimCustomer_Key]                 = SRC.DimCustomer_Key
,TGT.[OrderDateDimDate_Key]            = SRC.OrderDateDimDate_Key
,TGT.[ShipDateDimDate_Key]             = SRC.DimCustomer_Key
,TGT.[DimCustomerShipTo_Key]           = SRC.DimSalesPerson_Key
,TGT.[FactInventory_Key]               = SRC.FactInventory_Key
,TGT.[DimGLMaster_Key]                 = SRC.DimGLMaster_Key
,TGT.[DimSalesperson_Key]              = SRC.[DimSalesperson_Key] 

, TGT.[OrderNumber]                 = SRC.[OrderNumber]    
, TGT.[OrderLine]                   = SRC.[OrderLine]      
, TGT.[Price]                       = SRC.[Price]                      
, TGT.[Cost]                        = SRC.[Cost]                       
, TGT.[ExtenedPrice]                = SRC.[ExtenedPrice]               
, TGT.[Margin]                      = SRC.[Margin]                     
, TGT.[QtyOriginal]                 = SRC.[QtyOriginal]                
, TGT.[QtyAllocated]                = SRC.[QtyAllocated]               
, TGT.[QuantityOrdered]             = SRC.[QuantityOrdered]            
, TGT.[Qty_Shipped]                 = SRC.[Qty_Shipped]                
, TGT.[QtyBackOrdered]              = SRC.[QtyBackOrdered]             
, TGT.[PriceDiscount]               = SRC.[PriceDiscount]              
, TGT.[PricePerPound]               = SRC.[PricePerPound]              
, TGT.[DiscountAmount]              = SRC.[DiscountAmount]             
, TGT.[OrderDiscount]               = SRC.[OrderDiscount]              
, TGT.[ProductClassDiscountAmount]  = SRC.[ProductClassDiscountAmount] 
, TGT.[ProductLineDiscount]         = SRC.[ProductLineDiscount]        
, TGT.[OrderDiscountAmount]         = SRC.[OrderDiscountAmount]        
, TGT.[PriceClassDiscount]          = SRC.[PriceClassDiscount]         
, TGT.[ProductLineDiscountAmount]   = SRC.[ProductLineDiscountAmount]  
, TGT.[OrderPrice]                  = SRC.[OrderPrice]                 
, TGT.[OrderDiscountPrice]          = SRC.[OrderDiscountPrice]         
, TGT.[OrderPricePerPound]          = SRC.[OrderPricePerPound]         
            

	FROM	dw.FactSalesOrderLine		    AS TGT
	 JOIN   ##FactSalesOrderLine_SOURCE	AS SRC
			ON  TGT.OrderNumber = SRC.OrderNumber
			and TGT.OrderLine   = SRC.OrderLine 
					
	   
	WHERE	TGT.RecordHash <> SRC.RecordHash
	

SET @RowsUpdatedCount = @@ROWCOUNT


	--DROP temp tables

	 DROP TABLE ##FactSalesOrderLine_SOURCE		
	 DROP TABLE ##FactSalesOrderLine_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO


