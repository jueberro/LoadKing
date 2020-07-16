CREATE PROCEDURE [dw].[sp_LoadFactAPOpenItems] @LoadLogKey INT  AS

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

IF object_id('##FactAPOpenItems_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactAPOpenItems_SOURCE
	END

IF object_id('##FactAPOpenItems_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactAPOpenItems_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactAPOpenItems_SOURCE (
	[DimVendor_Key] [int] NOT NULL,
	[DimGLAccount_Key] [int] NOT NULL,
	[DimDateInvoice_key] [int] NOT NULL,
	[DimDateInvoiceDue_Key] [int] NOT NULL,
	[VENDOR] [char](7) NULL,
	[INVOICE] [char](15) NULL,
	[BATCH_CODE] [char](2) NULL,
	[BATCH_NUM] [char](5) NULL,
	[BATCH_LINE] [char](4) NULL,
	[DATE_BATCH] [date] NULL,
	[AREA] [char](2) NULL,
	[GL_ACCOUNT] [char](15) NULL,
	[DATE_INVOICE] [date] NULL,
	[AMT_INVOICE] [numeric](16, 2) NULL,
	[DATE_INVOICE_DUE] [date] NULL,
	[DISCOUNT_INVOICE] [numeric](10, 2) NULL,
	[PURCHASE_ORDER] [char](7) NULL,
	[BUYER] [char](3) NULL,
	[CHECK_NUM] [char](20) NULL,
	[DATE_CHECK] [date] NULL,
	[CHECK_CODE] [char](1) NULL,
	[RECEIVER] [char](6) NULL,
	[JOB] [char](7) NULL,
	[SUFFIX] [char](4) NULL,
	[SEQ] [char](6) NULL,
	[CHECK_DESC] [char](30) NULL,
	[VOUCHER] [char](7) NULL,
	[PAYMENT_SEQ] [char](1) NULL,
	[PO_LINE] [char](3) NULL,
	[AMT_TRANSACTION] [numeric](16, 2) NULL,
	[FLAG_PAY_SELECT] [char](1) NULL,
	[FLAG_CK_CLEARED] [char](1) NULL,
	[USERID] [char](8) NULL,
	[PAY_ACH] [char](1) NULL,
	[INVC_TAXABLE_AMT] [numeric](16, 2) NULL,
	[Type1RecordHash] [varbinary](64) NULL
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactAPOpenItems_SOURCE
			SELECT * from dwstage.V_LoadFactAPOpenItems

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactAPOpenItems_TARGET 
					(
						[VENDOR] [char](7) NULL,
						[INVOICE] [char](15) NULL,
						[BATCH_CODE] [char](2) NULL,
						[BATCH_NUM] [char](5) NULL,
						[BATCH_LINE] [char](4) NULL,
						Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactAPOpenItems_TARGET
	SELECT	
		[VENDOR] ,
		[INVOICE] ,
		[BATCH_CODE] ,
		[BATCH_NUM] ,
		[BATCH_LINE],
		[Type1RecordHash]
	FROM dw.FactAPOpenItems

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactAPOpenItems 
	SELECT	*
	FROM	##FactAPOpenItems_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactAPOpenItems AS TGT
						WHERE	
							TGT.[VENDOR]		= SRC.[VENDOR]	AND
							TGT.[INVOICE]		= SRC.[INVOICE]	AND
							TGT.[BATCH_CODE]	= SRC.[BATCH_CODE] AND
							TGT.[BATCH_NUM]		= SRC.[BATCH_NUM] AND
							TGT.[BATCH_LINE]	= SRC.[BATCH_LINE] 
					  )
SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
    TGT.[AREA]				= SRC.[AREA],
	TGT.[GL_ACCOUNT]		= SRC.[GL_ACCOUNT],
	TGT.[DATE_INVOICE]		= SRC.[DATE_INVOICE],
	TGT.[AMT_INVOICE]		= SRC.[AMT_INVOICE],
	TGT.[DATE_INVOICE_DUE]	= SRC.[DATE_INVOICE_DUE],
	TGT.[DISCOUNT_INVOICE]	= SRC.[DISCOUNT_INVOICE],
	TGT.[PURCHASE_ORDER]	= SRC.[PURCHASE_ORDER],
	TGT.[BUYER]				= SRC.[BUYER],
	TGT.[CHECK_NUM]			= SRC.[CHECK_NUM],
	TGT.[DATE_CHECK]		= SRC.[DATE_CHECK],
	TGT.[CHECK_CODE]		= SRC.[CHECK_CODE],
	TGT.[RECEIVER]			= SRC.[RECEIVER],
	TGT.[JOB]				= SRC.[JOB],
	TGT.[SUFFIX]			= SRC.[SUFFIX],
	TGT.[SEQ]				= SRC.[SEQ],
	TGT.[CHECK_DESC]		= SRC.[CHECK_DESC],
	TGT.[VOUCHER]			= SRC.[VOUCHER],
	TGT.[PAYMENT_SEQ]		= SRC.[PAYMENT_SEQ],
	TGT.[PO_LINE]			= SRC.[PO_LINE],
	TGT.[AMT_TRANSACTION]	= SRC.[AMT_TRANSACTION],
	TGT.[FLAG_PAY_SELECT]	= SRC.[FLAG_PAY_SELECT],
	TGT.[FLAG_CK_CLEARED]	= SRC.[FLAG_CK_CLEARED],
	TGT.[USERID]			= SRC.[USERID],
	TGT.[PAY_ACH]			= SRC.[PAY_ACH],
	TGT.[INVC_TAXABLE_AMT]	= SRC.[INVC_TAXABLE_AMT],
	TGT.Type1RecordHash     = SRC.Type1RecordHash
	FROM	dw.FactAPOpenItems		AS TGT
	 JOIN   ##FactAPOpenItems_SOURCE	AS SRC
	  ON	TGT.[VENDOR]		= SRC.[VENDOR]	AND
			TGT.[INVOICE]		= SRC.[INVOICE]	 AND
			TGT.[BATCH_CODE]	= SRC.[BATCH_CODE] AND
			TGT.[BATCH_NUM]		= SRC.[BATCH_NUM]	AND
			TGT.[BATCH_LINE]	= SRC.[BATCH_LINE] 

	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactAPOpenItems_SOURCE		
	 DROP TABLE ##FactAPOpenItems_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO
