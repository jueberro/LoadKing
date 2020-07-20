CREATE PROCEDURE [dw].[sp_LoadFactAROpenItems] @LoadLogKey INT  AS

BEGIN

DECLARE @RowsInsertedCount int
DECLARE @RowsUpdatedCount int

	/*
	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table
	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

IF object_id('##FactAROpenItems_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactAROpenItems_SOURCE
	END

IF object_id('##FactAROpenItems_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactAROpenItems_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactAROpenItems_SOURCE (
	[DimCustomer_Key] [int] NOT NULL,
	[DimGLAccount_Key] [int] NOT NULL,
	[DimDateInvoice_key] [int] NOT NULL,
	[DimDateTransaction_key] [int] NOT NULL,
	[DimSalesPerson_key] [int] NOT NULL,
	[CUSTOMER] [char](7) NULL,
	[INVOICE] [char](7) NULL,
	[BATCH_CODE] [char](2) NULL,
	[BATCH_NUM] [char](5) NULL,
	[BATCH_LINE] [char](4) NULL,
	[DATE_INVOICE] [date] NULL,
	[DATE_TRANSACTION] [date] NULL,
	[AMT_TRANS_TOTAL] [numeric](16, 2) NULL,
	[GL_ACCOUNT] [char](15) NULL,
	[AMT_INVOICE] [numeric](16, 2) NULL,
	[SALESPERSON] [char](3) NULL,
	[REFERENCE] [char](22) NULL,
	[TERRITORY] [char](2) NULL,
	[STATE] [char](2) NULL,
	[EXCHANGE_AMT] [numeric](16, 2) NULL,
	[EXCHANGE_AMT_TOT] [numeric](16, 2) NULL,
	[ORDER_NO] [char](7) NULL,
	[ORDER_SUFFIX] [char](4) NULL,
	[TERMS_CODE] [char](1) NULL,
	[DUE_DATE] [date] NULL,
	[DISC_DATE] [date] NULL,
	[FRT_AMT_CO_CURR] [numeric](11, 2) NULL,
	[TAX_AMT_CO_CURR] [numeric](11, 2) NULL,
	[FRT_AMT_OE_CURR] [numeric](11, 2) NULL,
	[TAX_AMT_OE_CURR] [numeric](11, 2) NULL,
	[PCK_NO] [numeric](7, 0) NULL,
	[TAXABLE_FLG] [bit] NULL,
	[Type1RecordHash] [varbinary](64) NULL
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactAROpenItems_SOURCE
			SELECT * from dwstage.V_LoadFactAROpenItems

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactAROpenItems_TARGET 
					(
						[CUSTOMER] [char](7) NULL,
						[INVOICE] [char](15) NULL,
						[BATCH_CODE] [char](2) NULL,
						[BATCH_NUM] [char](5) NULL,
						[BATCH_LINE] [char](4) NULL,
						Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactAROpenItems_TARGET
	SELECT	
		[CUSTOMER] ,
		[INVOICE] ,
		[BATCH_CODE] ,
		[BATCH_NUM] ,
		[BATCH_LINE],
		[Type1RecordHash]
	FROM dw.FactAROpenItems

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactAROpenItems 
	SELECT	*
	FROM	##FactAROpenItems_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactAROpenItems AS TGT
						WHERE	
							TGT.[CUSTOMER]		= SRC.[CUSTOMER]	AND
							TGT.[INVOICE]		= SRC.[INVOICE]	AND
							TGT.[BATCH_CODE]	= SRC.[BATCH_CODE] AND
							TGT.[BATCH_NUM]		= SRC.[BATCH_NUM] AND
							TGT.[BATCH_LINE]	= SRC.[BATCH_LINE] 
					  )
SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
	    TGT.DATE_INVOICE		= SRC.DATE_INVOICE		,
		TGT.DATE_TRANSACTION	= SRC.DATE_TRANSACTION	,
		TGT.AMT_TRANS_TOTAL		= SRC.AMT_TRANS_TOTAL	,
		TGT.GL_ACCOUNT			= SRC.GL_ACCOUNT		,
		TGT.AMT_INVOICE			= SRC.AMT_INVOICE		,
		TGT.SALESPERSON			= SRC.SALESPERSON		,
		TGT.REFERENCE			= SRC.REFERENCE			,
		TGT.TERRITORY			= SRC.TERRITORY			,
		TGT.[STATE]				= SRC.[STATE]			,
		TGT.EXCHANGE_AMT		= SRC.EXCHANGE_AMT		,
		TGT.EXCHANGE_AMT_TOT	= SRC.EXCHANGE_AMT_TOT	,
		TGT.ORDER_NO			= SRC.ORDER_NO			,
        TGT.ORDER_SUFFIX		= SRC.ORDER_SUFFIX		,
		TGT.TERMS_CODE			= SRC.TERMS_CODE		,
		TGT.DUE_DATE			= SRC.DUE_DATE			,
		TGT.DISC_DATE			= SRC.DISC_DATE			,
		TGT.FRT_AMT_CO_CURR		= SRC.FRT_AMT_CO_CURR	,
		TGT.TAX_AMT_CO_CURR		= SRC.TAX_AMT_CO_CURR	,
		TGT.FRT_AMT_OE_CURR		= SRC.FRT_AMT_OE_CURR	,
		TGT.TAX_AMT_OE_CURR		= SRC.TAX_AMT_OE_CURR	,
		TGT.PCK_NO				= SRC.PCK_NO			,
		TGT.TAXABLE_FLG			= SRC.TAXABLE_FLG		,
		TGT.Type1RecordHash     = SRC.Type1RecordHash
    FROM	dw.FactAROpenItems		AS TGT
	 JOIN   ##FactAROpenItems_SOURCE	AS SRC
	  ON	TGT.[CUSTOMER]		= SRC.[CUSTOMER]	AND
			TGT.[INVOICE]		= SRC.[INVOICE]	 AND
			TGT.[BATCH_CODE]	= SRC.[BATCH_CODE] AND
			TGT.[BATCH_NUM]		= SRC.[BATCH_NUM]	AND
			TGT.[BATCH_LINE]	= SRC.[BATCH_LINE] 

	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactAROpenItems_SOURCE		
	 DROP TABLE ##FactAROpenItems_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO
