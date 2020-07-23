CREATE PROCEDURE [dw].[sp_LoadFactGLDetail] @LoadLogKey INT  AS

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

IF object_id('##FactGLDetail_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactGLDetail_SOURCE
	END

IF object_id('##FactGLDetail_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactGLDetail_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactGLDetail_SOURCE (
	[DimDatePostDateSql_Key]        [int] NOT NULL,
	[DimDateTransDateSql_Key]       [int] NOT NULL,
	[DimDateReverseDateSql_Key]     [int] NOT NULL,
	[DimDatePeriodBegDateSql_Key]   [int] NOT NULL,
	[DimDatePeriodEndDateSql_Key]   [int] NOT NULL,
	[DimDateLastChgDateSql_Key]     [int] NOT NULL,
	[DimGLAccount_Key]              [int] NOT NULL,
    [GL_NUMBER] [char](15) NULL,
	[BATCH] [char](5) NULL,
	[LINE] [numeric](5, 0) NULL,
	[SEQ] [numeric](8, 0) NULL,
	[POST_DATE_SQL] [date] NULL,
	[TRANS_DATE_SQL] [date] NULL,
	[REVERSE_FLAG] [bit] NULL,
	[REVERSE_DATE_SQL] [date] NULL,
	[PERIOD] [numeric](2, 0) NULL,
	[PERIOD_BEG_DATE_SQL] [date] NULL,
	[PERIOD_END_DATE_SQL] [date] NULL,
	[REFERENCE] [char](15) NULL,
	[DESCRIPTION] [char](30) NULL,
	[VOUCHER] [char](7) NULL,
	[DB_CR_FLAG] [bit] NULL,
	[AMOUNT_CMPNY] [numeric](16, 2) NULL,
	[APPL_TYPE] [numeric](2, 0) NULL,
	[TRAN_TYPE] [numeric](2, 0) NULL,
	[DATA_CNV_FLAG] [numeric](2, 0) NULL,
	[ASSET] [char](6) NULL,
	[PERIOD_13_FLAG] [bit] NULL,
	[USERID] [char](8) NULL,
	[DEPT] [char](4) NULL,
	[BRANCH] [char](2) NULL,
	[SYSTEM] [numeric](2, 0) NULL,
	[EXPORT_TO_EXT_SYS] [bit] NULL,
	[INCL_IN_VAT_RPT] [bit] NULL,
	[VAT_BOX] [char](2) NULL,
	[FILLER] [char](50) NULL,
	[TRMNL] [char](3) NULL,
	[LAST_CHG_DATE] [date] NULL,
	[LAST_CHG_TIME] [time](0) NULL,
	[LAST_CHG_PGM] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[Type1RecordHash] [varbinary](64) NULL

)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactGLDetail_SOURCE
			SELECT * from dwstage.V_LoadFactGLDetail

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactGLDetail_TARGET 
					(
					      GL_NUMBER [char](15)      NULL
				   ,  POST_DATE_SQL	[date]          NULL
			       ,          BATCH [char](5)       NULL
			       ,           LINE [numeric](5, 0) NULL
				   ,            SEQ [numeric](8, 0) NULL
				   ,Type1RecordHash [varbinary](64) NULL
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactGLDetail_TARGET
	SELECT	
			        GL_NUMBER 
				   ,POST_DATE_SQL
			       ,BATCH
			       ,LINE
				   ,SEQ
				   ,Type1RecordHash 
	FROM	dw.FactGLDetail

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactGLDetail 
	SELECT	*
	FROM	##FactGLDetail_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactGLDetail AS TGT
						WHERE	
						        TGT.GL_NUMBER       = SRC.GL_NUMBER 
							and TGT.POST_DATE_SQL   = SRC.POST_DATE_SQL   
							and TGT.BATCH           = SRC.BATCH           
							and TGT.LINE            = SRC.LINE            
							and TGT.SEQ             = SRC.SEQ             
							and TGT.Type1RecordHash = SRC.Type1RecordHash 
									
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

 TGT.DimDatePostDateSql_Key       = SRC.DimDatePostDateSql_Key
,TGT.DimDateTransDateSql_Key      = SRC.DimDateTransDateSql_Key
,TGT.DimDateReverseDateSql_Key    = SRC.DimDateReverseDateSql_Key  
,TGT.DimDatePeriodBegDateSql_Key  = SRC.DimDatePeriodBegDateSql_Key  
,TGT.DimDatePeriodEndDateSql_Key  = SRC.DimDatePeriodEndDateSql_Key
,TGT.DimDateLastChgDateSql_Key = SRC.DimDateLastChgDateSql_Key  
,TGT.DimGLAccount_Key          = SRC.DimGLAccount_Key
,TGT.[GL_NUMBER]               = SRC.[GL_NUMBER]             
,TGT.[BATCH]                   = SRC.[BATCH]                 
,TGT.[LINE]                    = SRC.[LINE]                  
,TGT.[SEQ]                     = SRC.[SEQ]                   
,TGT.[POST_DATE_SQL]           = SRC.[POST_DATE_SQL]         
,TGT.[TRANS_DATE_SQL]          = SRC.[TRANS_DATE_SQL]        
,TGT.[REVERSE_FLAG]            = SRC.[REVERSE_FLAG]          
,TGT.[REVERSE_DATE_SQL]        = SRC.[REVERSE_DATE_SQL]      
,TGT.[PERIOD]                  = SRC.[PERIOD]                
,TGT.[PERIOD_BEG_DATE_SQL]     = SRC.[PERIOD_BEG_DATE_SQL]   
,TGT.[PERIOD_END_DATE_SQL]     = SRC.[PERIOD_END_DATE_SQL]   
,TGT.[REFERENCE]               = SRC.[REFERENCE]             
,TGT.[DESCRIPTION]             = SRC.[DESCRIPTION]           
,TGT.[VOUCHER]                 = SRC.[VOUCHER]               
,TGT.[DB_CR_FLAG]              = SRC.[DB_CR_FLAG]            
,TGT.[AMOUNT_CMPNY]            = SRC.[AMOUNT_CMPNY]          
,TGT.[APPL_TYPE]               = SRC.[APPL_TYPE]             
,TGT.[TRAN_TYPE]               = SRC.[TRAN_TYPE]             
,TGT.[DATA_CNV_FLAG]           = SRC.[DATA_CNV_FLAG]         
,TGT.[ASSET]                   = SRC.[ASSET]                 
,TGT.[PERIOD_13_FLAG]          = SRC.[PERIOD_13_FLAG]        
,TGT.[USERID]                  = SRC.[USERID]                
,TGT.[DEPT]                    = SRC.[DEPT]            
,TGT.[BRANCH]                  = SRC.[BRANCH]                
,TGT.[SYSTEM]                  = SRC.[SYSTEM]                
,TGT.[EXPORT_TO_EXT_SYS]       = SRC.[EXPORT_TO_EXT_SYS]     
,TGT.[INCL_IN_VAT_RPT]         = SRC.[INCL_IN_VAT_RPT]       
,TGT.[VAT_BOX]                 = SRC.[VAT_BOX]               
,TGT.[FILLER]                  = SRC.[FILLER]                
,TGT.[TRMNL]                   = SRC.[TRMNL]                 
,TGT.[LAST_CHG_DATE]           = SRC.[LAST_CHG_DATE]         
,TGT.[LAST_CHG_TIME]           = SRC.[LAST_CHG_TIME]         
,TGT.[LAST_CHG_PGM]            = SRC.[LAST_CHG_PGM]          
,TGT.[LAST_CHG_BY]             = SRC.[LAST_CHG_BY]           
,TGT.[Type1RecordHash]         = SRC.[Type1RecordHash]  

	FROM	dw.FactGLDetail		AS TGT
	 JOIN   ##FactGLDetail_SOURCE	AS SRC
			ON  TGT.GL_NUMBER       = SRC.GL_NUMBER      
			and TGT.POST_DATE_SQL   = SRC.POST_DATE_SQL  
			and TGT.BATCH           = SRC.BATCH          
			and TGT.LINE            = SRC.LINE           
			and TGT.SEQ             = SRC.SEQ            
					
	WHERE	    TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactGLDetail_SOURCE		
	 DROP TABLE ##FactGLDetail_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO
