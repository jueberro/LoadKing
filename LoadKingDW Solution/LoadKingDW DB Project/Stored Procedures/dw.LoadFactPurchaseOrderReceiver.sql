--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE dw.sp_LoadFactPurchaseOrderReceiver @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

DECLARE @RowsInsertedCount int
DECLARE @RowsUpdatedCount int

	/*
	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table
	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

IF object_id('##FactPurchaseOrderReceiver_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactPurchaseOrderReceiver_SOURCE
	END

IF object_id('##FactPurchaseOrderReceiver_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactPurchaseOrderReceiver_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactPurchaseOrderReceiver_SOURCE (

	DimPurchaseOrder_Key int NOT NULL,
	DimInventory_Key int NOT NULL,
	DimVendor_Key int NOT NULL,
	DimGLAccount_Key int NOT NULL,
	DimDate_Key int NOT NULL,
	[RECEIVER_NO] [char](6) NULL,
	[PURCHASE_ORDER] [char](7) NULL, 
	[PO_LINE] [char](3) NULL, 
	[PART] [char](20) NULL, 
	[GL_ACCOUNT] [char](15) NULL, 
	[JOB] [char](7) NULL, 
	[SUFFIX] [char](4) NULL, 
	[SEQUENCE] [char](6) NULL, 
	[VENDOR] [char](6) NULL, 
	[DESCRIPTION] [char](30) NULL,
	[FLAG_OPN_ITM_POST] [char](1) NULL,
	[PAY_WITH_CCARD] [char](1) NULL,
	[TAXABLE] [bit] NULL,
	[BOOK_USE_TAX] [bit] NULL,
	[VAT_RULE] [numeric](3, 0) NULL,
	[USE_PURPOSE] [numeric](3, 0) NULL,
	[DATE_RECEIVED] datetime NULL, -- Date -- [char](8)
	[DATE_TRANSACTION] datetime NULL, -- Date -- [char](6)
	[TIME_TRANSACTION] [char](8) NULL, 
	[DATE_EXCHANGE] datetime NULL, -- Date -- [char](8)
	[DATE_LAST_CHG] datetime NULL, -- Date -- [char](8)
	[EXTENDED_COST] [numeric](16, 2) NULL, -- Measure
	[QTY_RECEIVED] [numeric](13, 4) NULL, -- Measure
	[QTY_INVOICED] [numeric](13, 4) NULL, -- Measure
	[COST_INVOICED] [numeric](16, 2) NULL, -- Measure
	[EXTENDED_STD_COST] [numeric](16, 2) NULL, -- Measure
	[EXCHANGE_RATE] [numeric](10, 5) NULL, -- Measure
	[EXCH_EXT_COST] [numeric](16, 2) NULL, -- Measure
	[EXCH_COST_INV] [numeric](16, 2) NULL, -- Measure
	[EXCH_EXT_STD_COST] [numeric](16, 2) NULL, -- Measure
	/*Hashes used for identifying changes, not required for reporting*/
	[Type1RecordHash]			VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactPurchaseOrderReceiver_SOURCE
			SELECT * from dwstage.V_LoadFactPurchaseOrderReceiver

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactPurchaseOrderReceiver_TARGET 
					(
					RECEIVER_NO CHAR(6)
					,PURCHASE_ORDER CHAR(7)
					,PO_LINE CHAR(7)
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactPurchaseOrderReceiver_TARGET
	SELECT	
			RECEIVER_NO
			,PURCHASE_ORDER
			,PO_LINE
			, Type1RecordHash
	FROM	dw.FactPurchaseOrderReceiver

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactPurchaseOrderReceiver 
	SELECT	*
	FROM	##FactPurchaseOrderReceiver_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactPurchaseOrderReceiver AS TGT
						WHERE	
							TGT.RECEIVER_NO = SRC.RECEIVER_NO
							and TGT.PURCHASE_ORDER = SRC.PURCHASE_ORDER
							and TGT.PO_LINE = SRC.PO_LINE
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

  TGT.DimPurchaseOrder_Key = SRC.DimPurchaseOrder_Key
, TGT.DimInventory_Key = SRC.DimInventory_Key
, TGT.DimVendor_Key = SRC.DimVendor_Key
, TGT.DimGLAccount_Key = SRC.DimGLAccount_Key
, TGT.DimDate_Key = SRC.DimDate_Key
, TGT.[PART] = SRC.[PART]
, TGT.[GL_ACCOUNT] = SRC.[GL_ACCOUNT]
, TGT.[JOB] = SRC.[JOB]
, TGT.[SUFFIX] = SRC.[SUFFIX]
, TGT.[SEQUENCE] = SRC.[SEQUENCE]
, TGT.[VENDOR] = SRC.[VENDOR]
, TGT.[DESCRIPTION] = SRC.[DESCRIPTION]
, TGT.[FLAG_OPN_ITM_POST] = SRC.[FLAG_OPN_ITM_POST]
, TGT.[PAY_WITH_CCARD] = SRC.[PAY_WITH_CCARD]
, TGT.[TAXABLE] = SRC.[TAXABLE]
, TGT.[BOOK_USE_TAX] = SRC.[BOOK_USE_TAX]
, TGT.[VAT_RULE] = SRC.[VAT_RULE]
, TGT.[USE_PURPOSE] = SRC.[USE_PURPOSE]
, TGT.[DATE_RECEIVED] = SRC.[DATE_RECEIVED]
, TGT.[DATE_TRANSACTION] = SRC.[DATE_TRANSACTION]
, TGT.[TIME_TRANSACTION] = SRC.[TIME_TRANSACTION]
, TGT.[DATE_EXCHANGE] = SRC.[DATE_EXCHANGE]
, TGT.[DATE_LAST_CHG] = SRC.[DATE_LAST_CHG]
, TGT.[EXTENDED_COST] = SRC.[EXTENDED_COST]
, TGT.[QTY_RECEIVED] = SRC.[QTY_RECEIVED]
, TGT.[QTY_INVOICED] = SRC.[QTY_INVOICED]
, TGT.[COST_INVOICED] = SRC.[COST_INVOICED]
, TGT.[EXTENDED_STD_COST] = SRC.[EXTENDED_STD_COST]
, TGT.[EXCHANGE_RATE] = SRC.[EXCHANGE_RATE]
, TGT.[EXCH_EXT_COST] = SRC.[EXCH_EXT_COST]
, TGT.[EXCH_COST_INV] = SRC.[EXCH_COST_INV]
, TGT.[EXCH_EXT_STD_COST] = SRC.[EXCH_EXT_STD_COST]
, TGT.Type1RecordHash = SRC.Type1RecordHash
	FROM	dw.FactPurchaseOrderReceiver		AS TGT
	 JOIN   ##FactPurchaseOrderReceiver_SOURCE	AS SRC
			ON TGT.RECEIVER_NO = SRC.RECEIVER_NO
			and TGT.PURCHASE_ORDER = SRC.PURCHASE_ORDER
			and TGT.PO_LINE = SRC.PO_LINE
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactPurchaseOrderReceiver_SOURCE		
	 DROP TABLE ##FactPurchaseOrderReceiver_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO

