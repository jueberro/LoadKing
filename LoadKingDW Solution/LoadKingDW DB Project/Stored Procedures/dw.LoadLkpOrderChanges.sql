CREATE PROCEDURE [dw].[sp_LoadLkpOrderChanges] @LoadLogKey INT  AS

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

IF object_id('##LkpOrderChanges_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##LkpOrderChanges_SOURCE
	END

IF object_id('##LkpOrderChanges_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##LkpOrderChanges_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##LkpOrderChanges_SOURCE (


    [ORDER_NO]        [char](7) NULL,
	[CHANGE_DATE]     [char](8) NULL,
	[CHANGE_TIME]     [char](6) NULL,
	[TERMINAL_NO]     [char](3) NULL,
	[RECORD_NO]       [char](4) NULL,
	[FIELD_NAME]      [char](30) NULL,
	[BEFORE] [char](30) NULL,
	[AFTER] [char](30) NULL,
	[CUST_NO] [char](6) NULL,
	[SHIPTO] [char](6) NULL,
	[CUST_PO] [char](15) NULL,
	[FILLER15] [char](15) NULL,
	[SALESMAN] [char](3) NULL,
	[PART] [char](20) NULL,
	[LOCN] [char](2) NULL,
	[PROD_LINE] [char](5) NULL,
	[QTY] [numeric](13, 4) NULL,
	[FILLER81] [char](81) NULL,
	[CHANGE_USER] [char](8) NULL,
	[CHANGE_PGM] [char](8) NULL,
	[Type1RecordHash] [varbinary](64) NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##LkpOrderChanges_SOURCE
			SELECT * from dwstage.V_LoadLkpOrderChanges

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##LkpOrderChanges_TARGET 
					(
					     [ORDER_NO] [char](7)
					, [CHANGE_DATE] [char](8)
					, [CHANGE_TIME] [char](6) NULL
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##LkpOrderChanges_TARGET
	SELECT	
			    [ORDER_NO] 
			, [CHANGE_DATE] 
			, [CHANGE_TIME] 
			,Type1RecordHash 
	FROM	dw.LkpOrderChanges

	--INSERT NEW TARGET Items
	INSERT INTO dw.LkpOrderChanges 
	SELECT	*
	FROM	##LkpOrderChanges_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.LkpOrderChanges AS TGT
						WHERE	
							    TGT.ORDER_NO = SRC.ORDER_NO
							and TGT.CHANGE_DATE = SRC.CHANGE_DATE
							and TGT.CHANGE_TIME = SRC.CHANGE_TIME
								
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
	
	  TGT.[ORDER_NO]            =     SRC.[ORDER_NO]               
	, TGT.[CHANGE_DATE] 		=	  SRC.[CHANGE_DATE] 
	, TGT.[CHANGE_TIME] 		=	  SRC.[CHANGE_TIME] 
	, TGT.[TERMINAL_NO] 		=	  SRC.[TERMINAL_NO] 
	, TGT.[RECORD_NO] 			=	  SRC.[RECORD_NO] 
	, TGT.[FIELD_NAME] 			=	  SRC.[FIELD_NAME] 
	, TGT.[BEFORE] 				=	  SRC.[BEFORE] 
	, TGT.[AFTER] 				=	  SRC.[AFTER] 
	, TGT.[CUST_NO]				=	  SRC.[CUST_NO]
	, TGT.[SHIPTO] 				=	  SRC.[SHIPTO] 
	, TGT.[CUST_PO] 			=	  SRC.[CUST_PO] 
	, TGT.[FILLER15] 			=	  SRC.[FILLER15] 
	, TGT.[SALESMAN]			=	  SRC.[SALESMAN]
	, TGT.[PART] 				=	  SRC.[PART] 
	, TGT.[LOCN] 				=	  SRC.[LOCN] 
	, TGT.[PROD_LINE] 			=	  SRC.[PROD_LINE] 
	, TGT.[QTY] 				=	  SRC.[QTY] 
	, TGT.[CHANGE_USER]			=	  SRC.[CHANGE_USER]
	, TGT.[CHANGE_PGM] 			=	  SRC.[CHANGE_PGM] 
	, TGT.[Type1RecordHash] 	=	  SRC.[Type1RecordHash] 

	FROM	dw.LkpOrderChanges		AS TGT
	 JOIN   ##LkpOrderChanges_SOURCE	AS SRC
			ON  TGT.ORDER_NO    = SRC.ORDER_NO
			and TGT.CHANGE_DATE = SRC.CHANGE_DATE
			and TGT.CHANGE_TIME = SRC.CHANGE_TIME			
	WHERE	    TGT.Type1RecordHash <> SRC.Type1RecordHash
	
	--DROP temp tables

SET @RowsUpdatedCount = @@ROWCOUNT

	 DROP TABLE ##LkpOrderChanges_SOURCE		
	 DROP TABLE ##LkpOrderChanges_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO
