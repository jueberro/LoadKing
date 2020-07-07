--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE dw.sp_LoadFactInventoryMovement @LoadLogKey INT  AS

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

IF object_id('##FactInventoryMovement_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactInventoryMovement_SOURCE
	END

IF object_id('##FactInventoryMovement_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactInventoryMovement_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactInventoryMovement_SOURCE (

	DimInventory_Key int NOT NULL,
	DimGLAccount_Key int NOT NULL,
	DimProductLine_Key int NOT NULL,
	DimWorkOrder_Key int NOT NULL,
	DimVendor_Key int NOT NULL,
	DimDate_Key int NOT NULL,
	[PART] [char](20) NULL,
	[GL_ACCOUNT] [char](15) NULL,
	[PRODUCT_LINE] [char](2) NULL,
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[SEQ] [char](6) NULL,
	[VENDOR_NO] [char](6) NULL,
	[VENDOR_NAME] [char](30) NULL,
	[DATE_ACCT_YR] [char](2) NULL,
	[DATE_ACCT_MO] [char](2) NULL,
	[LOCATION] [char](2) NULL,
	[CODE_TRANSACTION] [char](3) NULL,
	[TRANSACTION_DESC] [char](15) NULL,
	[REFER_2] [char](15) NULL,
	[BIN] [char](6) NULL,
	[JCM_CLOSED] [char](1) NULL,
	[DEBIT_PROD_LN] [char](2) NULL,
	[A50_CUSTOMER] [char](6) NULL,
	[A50_SHIPTO] [char](6) NULL,
	[PROGRAM_A] [char](8) NULL,
	[IGNORE_FOR_USAGE] [bit] NULL,
	[USERID] [char](8) NULL,
	[FG_CLOSE] [char](1) NULL,
	[RECEIVER] [char](6) NULL,
	[COST_NOT_UPD] [bit] NULL,
	[DTL_KEY_SEQ] [numeric](4, 0) NULL,
	[T10_FRGT] [numeric](14, 6) NULL,
	[T10_FRGT_ACCT] [char](15) NULL,
	[FILLER] [char](37) NULL,
	[DATE_HISTORY] datetime NULL,
	[INV_HIST_TIME] [char](8) NULL,
	[DATE_ACTION] datetime NULL,
	[QUANTITY] [numeric](15, 6) NULL,
	[COST] [numeric](16, 6) NULL,
	[NEW_ONHAND] [numeric](15, 6) NULL,
	[OLD_ONHAND] [numeric](15, 6) NULL,
	[OLD_INV_COST] [numeric](16, 6) NULL,
	[NEW_INV_COST] [numeric](16, 6) NULL,
	[COST_MATERIAL] [numeric](16, 6) NULL,
	[COST_LABOR] [numeric](16, 6) NULL,
	[COST_OVERHEAD] [numeric](16, 6) NULL,
	[OUTS_COST] [numeric](16, 6) NULL,
	[FREIGHT_COST] [numeric](16, 6) NULL,
	[OTHER_COST] [numeric](16, 6) NULL,
	[MATL_VAR] [numeric](16, 6) NULL,
	[LABR_VAR] [numeric](16, 6) NULL,
	[OVHD_VAR] [numeric](16, 6) NULL,
	[OUTS_VAR] [numeric](16, 6) NULL,
	[FRGT_VAR] [numeric](16, 6) NULL,
	[OTH_VAR] [numeric](16, 6) NULL,
	[OLD_MATL] [numeric](16, 6) NULL,
	[OLD_LABR] [numeric](16, 6) NULL,
	[OLD_OVHD] [numeric](16, 6) NULL,
	[OLD_OUTS] [numeric](16, 6) NULL,
	[OLD_FRGT] [numeric](16, 6) NULL,
	[OLD_OTH] [numeric](16, 6) NULL,
	[NEW_MATL] [numeric](16, 6) NULL,
	[NEW_LABR] [numeric](16, 6) NULL,
	[NEW_OVHD] [numeric](16, 6) NULL,
	[NEW_OUTS] [numeric](16, 6) NULL,
	[NEW_FRGT] [numeric](16, 6) NULL,
	[NEW_OTH] [numeric](16, 6) NULL,
	/*Hashes used for identifying changes, not required for reporting*/
	[Type1RecordHash]			VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactInventoryMovement_SOURCE
			SELECT * from dwstage.V_LoadFactInventoryMovement

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactInventoryMovement_TARGET 
					(
					PART CHAR(20)
					,DATE_HISTORY datetime
					,INV_HIST_TIME CHAR(8)
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactInventoryMovement_TARGET
	SELECT	
			PART
			,DATE_HISTORY
			,INV_HIST_TIME
			, Type1RecordHash
	FROM	dw.FactInventoryMovement

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactInventoryMovement 
	SELECT	*
	FROM	##FactInventoryMovement_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactInventoryMovement AS TGT
						WHERE	
							TGT.PART = SRC.PART
							and TGT.DATE_HISTORY = SRC.DATE_HISTORY
							and TGT.INV_HIST_TIME = SRC.INV_HIST_TIME
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

  TGT.DimInventory_Key = SRC.DimInventory_Key
, TGT.DimGLAccount_Key = SRC.DimGLAccount_Key
, TGT.DimProductLine_Key = SRC.DimProductLine_Key
, TGT.DimWorkOrder_Key = SRC.DimWorkOrder_Key
, TGT.DimVendor_Key = SRC.DimVendor_Key
, TGT.DimDate_Key = SRC.DimDate_Key

, TGT.[GL_ACCOUNT] = SRC.[GL_ACCOUNT]
, TGT.[PRODUCT_LINE] = SRC.[PRODUCT_LINE]
, TGT.[JOB] = SRC.[JOB]
, TGT.[SUFFIX] = SRC.[SUFFIX]
, TGT.[SEQ] = SRC.[SEQ]
, TGT.[VENDOR_NO] = SRC.[VENDOR_NO]
, TGT.[VENDOR_NAME] = SRC.[VENDOR_NAME]
, TGT.[DATE_ACCT_YR] = SRC.[DATE_ACCT_YR]
, TGT.[DATE_ACCT_MO] = SRC.[DATE_ACCT_MO]
, TGT.[LOCATION] = SRC.[LOCATION]
, TGT.[CODE_TRANSACTION] = SRC.[CODE_TRANSACTION]
, TGT.[TRANSACTION_DESC] = SRC.[TRANSACTION_DESC]
, TGT.[REFER_2] = SRC.[REFER_2]
, TGT.[BIN] = SRC.[BIN]
, TGT.[JCM_CLOSED] = SRC.[JCM_CLOSED]
, TGT.[DEBIT_PROD_LN] = SRC.[DEBIT_PROD_LN]
, TGT.[A50_CUSTOMER] = SRC.[A50_CUSTOMER]
, TGT.[A50_SHIPTO] = SRC.[A50_SHIPTO]
, TGT.[PROGRAM_A] = SRC.[PROGRAM_A]
, TGT.[IGNORE_FOR_USAGE] = SRC.[IGNORE_FOR_USAGE]
, TGT.[USERID] = SRC.[USERID]
, TGT.[FG_CLOSE] = SRC.[FG_CLOSE]
, TGT.[RECEIVER] = SRC.[RECEIVER]
, TGT.[COST_NOT_UPD] = SRC.[COST_NOT_UPD]
, TGT.[DTL_KEY_SEQ] = SRC.[DTL_KEY_SEQ]
, TGT.[T10_FRGT] = SRC.[T10_FRGT]
, TGT.[T10_FRGT_ACCT] = SRC.[T10_FRGT_ACCT]
, TGT.[FILLER] = SRC.[FILLER]
, TGT.[DATE_ACTION] = SRC.[DATE_ACTION]
, TGT.[QUANTITY] = SRC.[QUANTITY]
, TGT.[COST] = SRC.[COST]
, TGT.[NEW_ONHAND] = SRC.[NEW_ONHAND]
, TGT.[OLD_ONHAND] = SRC.[OLD_ONHAND]
, TGT.[OLD_INV_COST] = SRC.[OLD_INV_COST]
, TGT.[NEW_INV_COST] = SRC.[NEW_INV_COST]
, TGT.[COST_MATERIAL] = SRC.[COST_MATERIAL]
, TGT.[COST_LABOR] = SRC.[COST_LABOR]
, TGT.[COST_OVERHEAD] = SRC.[COST_OVERHEAD]
, TGT.[OUTS_COST] = SRC.[OUTS_COST]
, TGT.[FREIGHT_COST] = SRC.[FREIGHT_COST]
, TGT.[OTHER_COST] = SRC.[OTHER_COST]
, TGT.[MATL_VAR] = SRC.[MATL_VAR]
, TGT.[LABR_VAR] = SRC.[LABR_VAR]
, TGT.[OVHD_VAR] = SRC.[OVHD_VAR]
, TGT.[OUTS_VAR] = SRC.[OUTS_VAR]
, TGT.[FRGT_VAR] = SRC.[FRGT_VAR]
, TGT.[OTH_VAR] = SRC.[OTH_VAR]
, TGT.[OLD_MATL] = SRC.[OLD_MATL]
, TGT.[OLD_LABR] = SRC.[OLD_LABR]
, TGT.[OLD_OVHD] = SRC.[OLD_OVHD]
, TGT.[OLD_OUTS] = SRC.[OLD_OUTS]
, TGT.[OLD_FRGT] = SRC.[OLD_FRGT]
, TGT.[OLD_OTH] = SRC.[OLD_OTH]
, TGT.[NEW_MATL] = SRC.[NEW_MATL]
, TGT.[NEW_LABR] = SRC.[NEW_LABR]
, TGT.[NEW_OVHD] = SRC.[NEW_OVHD]
, TGT.[NEW_OUTS] = SRC.[NEW_OUTS]
, TGT.[NEW_FRGT] = SRC.[NEW_FRGT]
, TGT.[NEW_OTH] = SRC.[NEW_OTH]
, TGT.Type1RecordHash = SRC.Type1RecordHash
	FROM	dw.FactInventoryMovement		AS TGT
	 JOIN   ##FactInventoryMovement_SOURCE	AS SRC
			ON TGT.PART = SRC.PART
			and TGT.DATE_HISTORY = SRC.DATE_HISTORY
			and TGT.INV_HIST_TIME = SRC.INV_HIST_TIME
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactInventoryMovement_SOURCE		
	 DROP TABLE ##FactInventoryMovement_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO

