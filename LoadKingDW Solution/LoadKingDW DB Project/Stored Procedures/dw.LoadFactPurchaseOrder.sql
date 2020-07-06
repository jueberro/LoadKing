--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE [dw].[sp_LoadFactPurchaseOrder] @LoadLogKey INT  AS

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

IF object_id('##FactPurchaseOrder_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactPurchaseOrder_SOURCE
	END

IF object_id('##FactPurchaseOrder_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactPurchaseOrder_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactPurchaseOrder_SOURCE (

DimPurchaseOrder_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimVendor_Key int NOT NULL,
DimGLAccount_Key int NOT NULL,
DimPaymentTerms_Key int NOT NULL,
DimDate_Key int NOT NULL,
-- DEGENERATE HEADER ATTRIBUTES ----------------------------------------------
[POL_PURCHASE_ORDER] [char](7) NULL,
[POL_RECORD_NO] [char](4) NULL,
-- DATES --------------------------------------------
[POH_DATE_ORDER] [datetime] NULL,
[POH_DATE_REQ] [datetime] NULL,
[POH_DATE_DUE] [datetime] NULL,
[POL_DATE_LAST_RECEIVED] [datetime] NULL,
[POL_DATE_LAST_CHG] [datetime] NULL,
[POH_CHANGE_DATE] [datetime] NULL,  
[POH_SHIP_DATE]  [datetime] NULL,     

--HEADER MEASURES --------------------------------------------------
[POL_COST] [numeric](14, 4) NULL,
[POL_QTY_ORDER] [numeric](14, 4) NULL,
[POL_EXTENSION] [numeric](15, 2) NULL,
[POL_QTY_RECEIVED] [numeric](14, 4) NULL,
[POL_VEN_TAX] [numeric](15, 2) NULL,
[POL_PUR_TAX] [numeric](15, 2) NULL,
[POL_ROLL_QTY] [numeric](7, 0) NULL,
[POL_INV_COST] [numeric](15, 6) NULL,
[POL_SHIPPED_QTY] [numeric](14, 4) NULL,
[POL_EXCHANGE_COST2] [numeric](15, 6) NULL,
[POL_EXCHANGE_RATE] [numeric](10, 5) NULL,
[POL_COST_6_DEC] [numeric](15, 6) NULL,
[POL_EXCHANGE_EXT] [numeric](15, 2) NULL,
[POL_VEN_TAX_PER_PIECE] [numeric](15, 6) NULL,
[POL_QTY_ALT_ORDER] [numeric](14, 4) NULL,
[POL_QTY_RECD_NOT_INSP] [numeric](14, 4) NULL,
[POL_DISCOUNT] [numeric](5, 4) NULL,
[POL_QTY_REJECT] [numeric](14, 4) NULL,
[POL_QTY_RECV_ALT] [numeric](14, 4) NULL,
[POL_PUR_TAX_PER_PIECE] [numeric](15, 6) NULL,

/*Hashes used for identifying changes, not required for reporting*/
[Type1RecordHash]			VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactPurchaseOrder_SOURCE
			SELECT * from dwstage.V_LoadFactPurchaseOrder

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactPurchaseOrder_TARGET 
					(
					POL_PURCHASE_ORDER CHAR(7)
					,POL_RECORD_NO CHAR(4)
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactPurchaseOrder_TARGET
	SELECT	
			POL_PURCHASE_ORDER
			,POL_RECORD_NO
			, Type1RecordHash
	FROM	dw.FactPurchaseOrder

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactPurchaseOrder 
	SELECT	*
	FROM	##FactPurchaseOrder_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactPurchaseOrder AS TGT
						WHERE	
							TGT.POL_PURCHASE_ORDER = SRC.POL_PURCHASE_ORDER
							and TGT.POL_RECORD_NO = SRC.POL_RECORD_NO
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

  TGT.DimPurchaseOrder_Key = SRC.DimPurchaseOrder_Key
, TGT.DimInventory_Key = SRC.DimInventory_Key
, TGT.DimVendor_Key = SRC.DimVendor_Key
, TGT.DimGLAccount_Key = SRC.DimGLAccount_Key
, TGT.DimPaymentTerms_Key = SRC.DimPaymentTerms_Key
, TGT.DimDate_Key = SRC.DimDate_Key
, TGT.[POL_PURCHASE_ORDER] = SRC.[POL_PURCHASE_ORDER]
, TGT.[POL_RECORD_NO] = SRC.[POL_RECORD_NO]
, TGT.[POH_DATE_ORDER] = SRC.[POH_DATE_ORDER]
, TGT.[POH_DATE_REQ] = SRC.[POH_DATE_REQ]
, TGT.[POH_DATE_DUE] = SRC.[POH_DATE_DUE]
, TGT.[POL_DATE_LAST_RECEIVED] = SRC.[POL_DATE_LAST_RECEIVED]
, TGT.[POL_DATE_LAST_CHG]      = SRC.[POL_DATE_LAST_CHG]
, TGT.[POH_CHANGE_DATE]   	   = SRC.[POH_CHANGE_DATE]  
, TGT.[POH_SHIP_DATE]          = SRC.[POH_SHIP_DATE]    
, TGT.[POL_COST] = SRC.[POL_COST]
, TGT.[POL_QTY_ORDER] = SRC.[POL_QTY_ORDER]
, TGT.[POL_EXTENSION] = SRC.[POL_EXTENSION]
, TGT.[POL_QTY_RECEIVED] = SRC.[POL_QTY_RECEIVED]
, TGT.[POL_VEN_TAX] = SRC.[POL_VEN_TAX]
, TGT.[POL_PUR_TAX] = SRC.[POL_PUR_TAX]
, TGT.[POL_ROLL_QTY] = SRC.[POL_ROLL_QTY]
, TGT.[POL_INV_COST] = SRC.[POL_INV_COST]
, TGT.[POL_SHIPPED_QTY] = SRC.[POL_SHIPPED_QTY]
, TGT.[POL_EXCHANGE_COST2] = SRC.[POL_EXCHANGE_COST2]
, TGT.[POL_EXCHANGE_RATE] = SRC.[POL_EXCHANGE_RATE]
, TGT.[POL_COST_6_DEC] = SRC.[POL_COST_6_DEC]
, TGT.[POL_EXCHANGE_EXT] = SRC.[POL_EXCHANGE_EXT]
, TGT.[POL_VEN_TAX_PER_PIECE] = SRC.[POL_VEN_TAX_PER_PIECE]
, TGT.[POL_QTY_ALT_ORDER] = SRC.[POL_QTY_ALT_ORDER]
, TGT.[POL_QTY_RECD_NOT_INSP] = SRC.[POL_QTY_RECD_NOT_INSP]
, TGT.[POL_DISCOUNT] = SRC.[POL_DISCOUNT]
, TGT.[POL_QTY_REJECT] = SRC.[POL_QTY_REJECT]
, TGT.[POL_QTY_RECV_ALT] = SRC.[POL_QTY_RECV_ALT]
, TGT.[POL_PUR_TAX_PER_PIECE] = SRC.[POL_PUR_TAX_PER_PIECE]
, TGT.Type1RecordHash = SRC.Type1RecordHash
	FROM	dw.FactPurchaseOrder		AS TGT
	 JOIN   ##FactPurchaseOrder_SOURCE	AS SRC
			ON TGT.POL_PURCHASE_ORDER = SRC.POL_PURCHASE_ORDER
			and TGT.POL_RECORD_NO = SRC.POL_RECORD_NO
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactPurchaseOrder_SOURCE		
	 DROP TABLE ##FactPurchaseOrder_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO