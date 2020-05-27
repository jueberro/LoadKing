--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE [dw].[sp_LoadFactInvoice] @LoadLogKey INT  AS

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
		Drop table ##FactInvoice_SOURCE
	END

IF object_id('##FactInvoice_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactInvoice_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactInvoice_SOURCE (

    [DimInvoice_Key]                [int] NOT NULL,
	[DimCustomer_Key]               [int] NOT NULL,
	[OrderDateDimDate_Key]          [int] NOT NULL,
	[ShipDateDimDate_Key]           [int] NOT NULL,
	[DimCustomerShipTo_Key]         [int] NOT NULL,
	[DimInventory_Key]              [int] NOT NULL,
	[DimGLAccount_Key]              [int] NOT NULL,
	[DimSalesperson_Key]            [int] NOT NULL,
	
	
	[SalesOrderNumber] [nchar](7) NULL,   
    [SalesOrderLine] [nchar](4) NULL,	
    [OHOrderSuffix] [nchar](4) NULL,      
    [OLOrderSuffix] [nchar](4) NULL,		
    [OLInvoiceNumber] [nchar](7) NULL,	 
    [OLDateShipped] DATETIME NULL,			
    [OLDateLineInvoiced] DATETIME NULL,	
    [QtyOrdered] [decimal](13, 4) NULL,
    [QtyShipped] [decimal](13, 4) NULL,
    [QtyBO] [decimal](13, 4) NULL,
    [QtyOriginal] [decimal](13, 4) NULL,
    [Cost] [decimal](16, 6) NULL,
    [CostMaterial] [decimal](11, 2) NULL,
    [CostLabor] [decimal](11, 2) NULL,
    [CostOutside] [decimal](11, 2) NULL,
    [CostOverhead] [decimal](11, 2) NULL,
    [CostOther] [decimal](11, 2) NULL,
    [Margin] [decimal](7, 4) NULL,
    [Price] [decimal](16, 6) NULL,
    [ExtendedPrice] [decimal](16, 2) NULL,
    [TaxApply1] [nchar](1) NULL,
    [TaxApply2] [nchar](1) NULL,
    [TaxAmt1] [decimal](11, 2) NULL,
    [TaxAmt2] [decimal](11, 2) NULL,	
     
    Type1RecordHash varbinary(64)
	
	)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactInvoice_SOURCE
			SELECT * from dwstage.V_LoadFactInvoice

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactInvoice_TARGET 
					(
					                       SalesOrderNumber NCHAR(7),
                                           SalesOrderLine   nchar(4) ,
										   OHOrderSuffix    nchar(4) ,
										   OLInvoiceNumber  nchar(7) ,
	                                       Type1RecordHash   VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactInvoice_TARGET
	SELECT	
			 SalesOrderNumber
			,SalesOrderLine 
			,OHOrderSuffix  
			,OLInvoiceNumber
	  
	  ,Type1RecordHash


	FROM	dw.FactInvoice

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactInvoice
	SELECT	*
	FROM	##FactInvoice_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactInvoice AS TGT
						WHERE	
							    TGT.SalesOrderNumber = SRC.SalesOrderNumber
							and TGT.SalesOrderLine   = SRC.SalesOrderLine 
							and TGT.OHOrderSuffix    = SRC.OHOrderSuffix  
							and TGT.OLInvoiceNumber  = SRC.OLInvoiceNumber			
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

 TGT.[DimInvoice_Key]                  = SRC.DimInvoice_Key
,TGT.[DimCustomer_Key]                 = SRC.DimCustomer_Key
,TGT.[OrderDateDimDate_Key]            = SRC.OrderDateDimDate_Key
,TGT.[ShipDateDimDate_Key]             = SRC.DimCustomer_Key
,TGT.[DimCustomerShipTo_Key]           = SRC.DimSalesPerson_Key
,TGT.[DimInventory_Key]                = SRC.DimInventory_Key
,TGT.[DimGLAccount_Key]                = SRC.DimGLAccount_Key
,TGT.[DimSalesperson_Key]              = SRC.[DimSalesperson_Key] 

, TGT.[SalesOrderNumber]     = SRC.[SalesOrderNumber]    
, TGT.[SalesOrderLine]       = SRC.[SalesOrderLine]      
, TGT.[OHOrderSuffix]        = SRC.[OHOrderSuffix]       
, TGT.[OLOrderSuffix]        = SRC.[OLOrderSuffix]       
, TGT.[OLInvoiceNumber]      = SRC.[OLInvoiceNumber]     
, TGT.[OLDateShipped]        = SRC.[OLDateShipped]       
, TGT.[OLDateLineInvoiced]   = SRC.[OLDateLineInvoiced]  
, TGT.[QtyOrdered]           = SRC.[QtyOrdered]          
, TGT.[QtyShipped]           = SRC.[QtyShipped]          
, TGT.[QtyBO]                = SRC.[QtyBO]               
, TGT.[QtyOriginal]          = SRC.[QtyOriginal]         
, TGT.[Cost]                 = SRC.[Cost]                
, TGT.[CostMaterial]         = SRC.[CostMaterial]        
, TGT.[CostLabor]            = SRC.[CostLabor]           
, TGT.[CostOutside]          = SRC.[CostOutside]         
, TGT.[CostOverhead]         = SRC.[CostOverhead]        
, TGT.[CostOther]            = SRC.[CostOther]           
, TGT.[Margin]               = SRC.[Margin]              
, TGT.[Price]                = SRC.[Price]               
, TGT.[ExtendedPrice]        = SRC.[ExtendedPrice]       
, TGT.[TaxApply1]            = SRC.[TaxApply1]           
, TGT.[TaxApply2]            = SRC.[TaxApply2]           
, TGT.[TaxAmt1]              = SRC.[TaxAmt1]             
, TGT.[TaxAmt2]              = SRC.[TaxAmt2]             


	FROM	dw.FactInvoice		    AS TGT
	 JOIN   ##FactInvoice_SOURCE	AS SRC
			ON  TGT.SalesOrderNumber = SRC.SalesOrderNumber
			and TGT.SalesOrderLine   = SRC.SalesOrderLine 
			and TGT.OHOrderSuffix    = SRC.OHOrderSuffix  
			and TGT.OLInvoiceNumber  = SRC.OLInvoiceNumber			
	   
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash
	

SET @RowsUpdatedCount = @@ROWCOUNT


	--DROP temp tables

	 DROP TABLE ##FactInvoice_SOURCE		
	 DROP TABLE ##FactInvoice_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO

