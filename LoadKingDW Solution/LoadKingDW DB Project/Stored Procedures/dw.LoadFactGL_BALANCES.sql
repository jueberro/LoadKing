--USE [LK-GS-EDW]
--GO
CREATE PROCEDURE dw.sp_LoadFactGLBalances @LoadLogKey INT  AS

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

IF object_id('##FactGLBalances_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactGLBalances_SOURCE
	END

IF object_id('##FactGLBalances_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactGLBalances_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactGLBalances_SOURCE (
	[DimDateLastChgDateSql_Key]  [int] NOT NULL,
	[DimGLAccount_Key]           [int] NOT NULL,
	[FISCAL_YR] [char](4) NULL,
	[TYPE] [char](1) NULL,
	[ACCT] [char](15) NULL,
	[COMP9_START_YR] [numeric](4, 0) NULL,
	[BEG_BAL] [numeric](13, 2) NULL,
	[FILLER] [char](100) NULL,
	[LAST_CHG_DATE] [char](8) NULL,
	[LAST_CHG_TIME] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[LAST_CHG_PGM] [char](8) NULL,
	[Type1RecordHash] [varbinary](64) NULL

)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactGLBalances_SOURCE
			SELECT * from dwstage.V_LoadFactGLBALANCES

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactGLBalances_TARGET 
					(
					 FISCAL_YR char(4) NULL
					,[TYPE]	char(1) NULL
					,ACCT char(15) NULL
					,Type1RecordHash [varbinary](64) NULL
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactGLBalances_TARGET
	SELECT	
					 FISCAL_YR
					,[TYPE]
					,ACCT
					,Type1RecordHash
	FROM	dw.FactGLBALANCES

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactGLBALANCES 
	SELECT	*
	FROM	##FactGLBalances_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactGLBALANCES AS TGT
						WHERE	
						        TGT.FISCAL_YR       = SRC.FISCAL_YR 
							and TGT.[TYPE]			= SRC.[TYPE]   
							and TGT.ACCT			= SRC.ACCT           
							and TGT.Type1RecordHash = SRC.Type1RecordHash 									
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
TGT.DimDateLastChgDateSql_Key = SRC.DimDateLastChgDateSql_Key  
,TGT.DimGLAccount_Key          = SRC.DimGLAccount_Key
,TGT.[FISCAL_YR]				= SRC.[FISCAL_YR]             
,TGT.[TYPE]						= SRC.[TYPE]                 
,TGT.[ACCT]						= SRC.[ACCT]                  
,TGT.[COMP9_START_YR]           = SRC.[COMP9_START_YR]                   
,TGT.[BEG_BAL]					= SRC.[BEG_BAL]         
,TGT.[FILLER]					= SRC.[FILLER]        
,TGT.[LAST_CHG_DATE]			= SRC.[LAST_CHG_DATE]         
,TGT.[LAST_CHG_TIME]			= SRC.[LAST_CHG_TIME] 
,TGT.[LAST_CHG_BY]				= SRC.[LAST_CHG_BY]           
,TGT.[LAST_CHG_PGM]				= SRC.[LAST_CHG_PGM]          
,TGT.[Type1RecordHash]			= SRC.[Type1RecordHash]  

	FROM	dw.FactGLBalances		AS TGT
	 JOIN   ##FactGLBalances_SOURCE	AS SRC
			ON  TGT.FISCAL_YR       = SRC.FISCAL_YR      
			and TGT.[TYPE]   = SRC.[TYPE]  
			and TGT.ACCT           = SRC.ACCT          
					
	WHERE	    TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactGLBalances_SOURCE		
	 DROP TABLE ##FactGLBalances_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO


