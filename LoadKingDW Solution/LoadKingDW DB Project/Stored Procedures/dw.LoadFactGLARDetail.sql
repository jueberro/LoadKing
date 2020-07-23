CREATE PROCEDURE [dw].[sp_LoadFactGLARDetail] @LoadLogKey INT  AS

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

IF object_id('##FactGLARDetail_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactGLARDetail_SOURCE
	END

IF object_id('##FactGLARDetail_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactGLARDetail_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactGLARDetail_SOURCE (

   [DimDatePostDate_Key] [int] NOT NULL,
   [DimDateTransDate_Key] [int] NOT NULL,
   [DimDateRetainDate_Key] [int] NOT NULL,
   [DimDateInvcDate_Key] [int] NOT NULL,
   [DimDateInvcDueDate_Key] [int] NOT NULL,
   [DimDateDiscDueDate_Key] [int] NOT NULL,
   [DimDatExchDate_Key] [int] NOT NULL,
   [DimDateLastChgDate_Key] [int] NOT NULL,
   [DimGLAccount_Key] [int] NOT NULL,
   [DimCustomer_Key] [int] NOT NULL,
   [GL_NUMBER] [char](15) NULL,
   [POST_DATE] [datetime] NULL,
   [BATCH] [char](5) NULL,
   [LINE] [numeric](5, 0) NULL,
   [SEQ] [numeric](8, 0) NULL,
   [USERID] [char](8) NULL,
   [CUST] [char](7) NULL,
   [CUST_NAME] [char](50) NULL,
   [INVOICE_NO] [char](25) NULL,
   [TRANS_DATE] [datetime] NULL,
   [RETAIN_DATE] [datetime] NULL,
   [INVC_DATE] [datetime] NULL,
   [INVC_DTE_J] [numeric](5, 0) NULL,
   [INVC_DUE_DATE] [datetime] NULL,
   [INVC_DUE_DTE_J] [numeric](5, 0) NULL,
   [DISC_DUE_DATE] [datetime] NULL,
   [DISC_DUE_DTE_J] [numeric](5, 0) NULL,
   [TRAN_TYPE] [numeric](2, 0) NULL,
   [TRTY_BRANCH] [char](2) NULL,
   [RETAIN] [bit] NULL,
   [SALSM] [char](3) NULL,
   [REFN] [char](15) NULL,
   [AREA] [char](2) NULL,
   [STATE] [char](2) NULL,
   [FACTOR_FLAG] [bit] NULL,
   [TERMS_CODE] [char](1) NULL,
   [PAYMENT_TYPE] [numeric](3, 0) NULL,
   [PREPAID_FLAG] [bit] NULL,
   [EXCH_VARIANCE_FLAG] [bit] NULL,
   [TAXABLE_FLG] [bit] NULL,
   [ORDER_NUM] [numeric](7, 0) NULL,
   [ORDER_SEQ] [numeric](4, 0) NULL,
   [EXCH_DATE] [datetime] NULL,
   [EXCH_OE_CURR] [char](3) NULL,
   [EXCH_OE_RATE] [numeric](10, 5) NULL,
   [EXCH_CMPNY_CURR] [char](3) NULL,
   [EXCH_CMPNY_RATE] [numeric](10, 5) NULL,
   [DB_CR_FLAG] [bit] NULL,
   [AMOUNT_CMPNY] [numeric](16, 2) NULL,
   [COST_CMPNY] [numeric](16, 2) NULL,
   [INVTOT_CMPNY] [numeric](16, 2) NULL,
   [FRT_AMT_CMPNY] [numeric](11, 2) NULL,
   [TAX_AMT_CMPNY] [numeric](11, 2) NULL,
   [INVC_DISC_CMPNY] [numeric](10, 2) NULL,
   [TAXABLE_AMT_CMPNY] [numeric](16, 2) NULL,
   [RETENTION_CMPNY] [numeric](16, 2) NULL,
   [AMOUNT_OE] [numeric](16, 2) NULL,
   [COST_OE] [numeric](16, 2) NULL,
   [INVTOT_OE] [numeric](16, 2) NULL,
   [FRT_AMT_OE] [numeric](11, 2) NULL,
   [TAX_AMT_OE] [numeric](11, 2) NULL,
   [INVC_DISC_OE] [numeric](10, 2) NULL,
   [TAXABL_AMT_OE] [numeric](16, 2) NULL,
   [RETENTION_OE] [numeric](16, 2) NULL,
   [EXPORT_TO_EXT_SYS] [bit] NULL,
   [PAYMENT_CURR] [char](3) NULL,
   [FILLER] [char](96) NULL,
   [TRMNL] [char](3) NULL,
   [LAST_CHG_DATE] [date] NULL,
   [LAST_CHG_TIME] [time](0) NULL,
   [LAST_CHG_PGM] [char](8) NULL,
   [LAST_CHG_BY] [char](8) NULL,


[Type1RecordHash] [varbinary](8000) NULL
)
	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactGLARDetail_SOURCE
			SELECT * from dwstage.V_LoadFactGLARDetail

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactGLARDetail_TARGET 
					(
					 [GL_NUMBER] [char](15)
					,[POST_DATE] [char](8)
					,[BATCH] [char](5)      
					,[LINE] [numeric](5, 0) 
					,[SEQ] [numeric](8, 0)  
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactGLARDetail_TARGET
	SELECT	
			 [GL_NUMBER] 
			,[POST_DATE] 
			,[BATCH]
			,[LINE]  
			,[SEQ]    
			,Type1RecordHash 
	FROM	dw.FactGLARDetail

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactGLARDetail 
	SELECT	*
	FROM	##FactGLARDetail_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactGLARDetail AS TGT
						WHERE	
							    TGT.[GL_NUMBER]   = SRC.[GL_NUMBER] 
							and TGT.[POST_DATE]   = SRC.[POST_DATE] 
							and TGT.[BATCH]       = SRC.[BATCH]
							and TGT.[LINE]        = SRC.[LINE]  
							and TGT.[SEQ]         = SRC.[SEQ]    
										
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

  TGT.DimDatePostDate_Key      = SRC.DimDatePostDate_Key     
, TGT.DimDateTransDate_Key     = SRC.DimDateTransDate_Key    
, TGT.DimDateRetainDate_Key    = SRC.DimDateRetainDate_Key   
, TGT.DimDateInvcDate_Key      = SRC.DimDateInvcDate_Key     
, TGT.DimDateInvcDueDate_Key   = SRC.DimDateInvcDueDate_Key  
, TGT.DimDateDiscDueDate_Key   = SRC.DimDateDiscDueDate_Key  
, TGT.DimDatExchDate_Key       = SRC.DimDatExchDate_Key      
, TGT.DimDateLastChgDate_Key   = SRC.DimDateLastChgDate_Key  
, TGT.DimGLAccount_Key         = SRC.DimGLAccount_Key        
, TGT.DimCustomer_Key          = SRC.DimCustomer_Key         
, TGT.[GL_NUMBER]              = SRC.[GL_NUMBER]         
, TGT.[POST_DATE]              = SRC.[POST_DATE]         
, TGT.[BATCH]                  = SRC.[BATCH]             
, TGT.[LINE]                   = SRC.[LINE]              
, TGT.[SEQ]                    = SRC.[SEQ]               
, TGT.[USERID]                 = SRC.[USERID]            
, TGT.[CUST]                   = SRC.[CUST]              
, TGT.[CUST_NAME]              = SRC.[CUST_NAME]         
, TGT.[INVOICE_NO]             = SRC.[INVOICE_NO]        
, TGT.[TRANS_DATE]             = SRC.[TRANS_DATE]        
, TGT.[RETAIN_DATE]            = SRC.[RETAIN_DATE]       
, TGT.[INVC_DATE]              = SRC.[INVC_DATE]         
, TGT.[INVC_DTE_J]             = SRC.[INVC_DTE_J]        
, TGT.[INVC_DUE_DATE]          = SRC.[INVC_DUE_DATE]     
, TGT.[INVC_DUE_DTE_J]         = SRC.[INVC_DUE_DTE_J]    
, TGT.[DISC_DUE_DATE]          = SRC.[DISC_DUE_DATE]     
, TGT.[DISC_DUE_DTE_J]         = SRC.[DISC_DUE_DTE_J]    
, TGT.[TRAN_TYPE]              = SRC.[TRAN_TYPE]         
, TGT.[TRTY_BRANCH]            = SRC.[TRTY_BRANCH]       
, TGT.[RETAIN]                 = SRC.[RETAIN]            
, TGT.[SALSM]                  = SRC.[SALSM]             
, TGT.[REFN]                   = SRC.[REFN]              
, TGT.[AREA]                   = SRC.[AREA]              
, TGT.[STATE]                  = SRC.[STATE]             
, TGT.[FACTOR_FLAG]            = SRC.[FACTOR_FLAG]       
, TGT.[TERMS_CODE]             = SRC.[TERMS_CODE]        
, TGT.[PAYMENT_TYPE]           = SRC.[PAYMENT_TYPE]      
, TGT.[PREPAID_FLAG]           = SRC.[PREPAID_FLAG]      
, TGT.[EXCH_VARIANCE_FLAG]     = SRC.[EXCH_VARIANCE_FLAG]
, TGT.[TAXABLE_FLG]            = SRC.[TAXABLE_FLG]       
, TGT.[ORDER_NUM]              = SRC.[ORDER_NUM]         
, TGT.[ORDER_SEQ]              = SRC.[ORDER_SEQ]         
, TGT.[EXCH_DATE]              = SRC.[EXCH_DATE]         
, TGT.[EXCH_OE_CURR]           = SRC.[EXCH_OE_CURR]      
, TGT.[EXCH_OE_RATE]           = SRC.[EXCH_OE_RATE]      
, TGT.[EXCH_CMPNY_CURR]        = SRC.[EXCH_CMPNY_CURR]   
, TGT.[EXCH_CMPNY_RATE]        = SRC.[EXCH_CMPNY_RATE]   
, TGT.[DB_CR_FLAG]             = SRC.[DB_CR_FLAG]        
, TGT.[AMOUNT_CMPNY]           = SRC.[AMOUNT_CMPNY]      
, TGT.[COST_CMPNY]             = SRC.[COST_CMPNY]        
, TGT.[INVTOT_CMPNY]           = SRC.[INVTOT_CMPNY]      
, TGT.[FRT_AMT_CMPNY]          = SRC.[FRT_AMT_CMPNY]     
, TGT.[TAX_AMT_CMPNY]          = SRC.[TAX_AMT_CMPNY]     
, TGT.[INVC_DISC_CMPNY]        = SRC.[INVC_DISC_CMPNY]   
, TGT.[TAXABLE_AMT_CMPNY]      = SRC.[TAXABLE_AMT_CMPNY] 
, TGT.[RETENTION_CMPNY]        = SRC.[RETENTION_CMPNY]   
, TGT.[AMOUNT_OE]              = SRC.[AMOUNT_OE]         
, TGT.[COST_OE]                = SRC.[COST_OE]           
, TGT.[INVTOT_OE]              = SRC.[INVTOT_OE]         
, TGT.[FRT_AMT_OE]             = SRC.[FRT_AMT_OE]        
, TGT.[TAX_AMT_OE]             = SRC.[TAX_AMT_OE]        
, TGT.[INVC_DISC_OE]           = SRC.[INVC_DISC_OE]      
, TGT.[TAXABL_AMT_OE]          = SRC.[TAXABL_AMT_OE]     
, TGT.[RETENTION_OE]           = SRC.[RETENTION_OE]      
, TGT.[EXPORT_TO_EXT_SYS]      = SRC.[EXPORT_TO_EXT_SYS] 
, TGT.[PAYMENT_CURR]           = SRC.[PAYMENT_CURR]      
, TGT.[FILLER]                 = SRC.[FILLER]            
, TGT.[TRMNL]                  = SRC.[TRMNL]             
, TGT.[LAST_CHG_DATE]          = SRC.[LAST_CHG_DATE]     
, TGT.[LAST_CHG_TIME]          = SRC.[LAST_CHG_TIME]     
, TGT.[LAST_CHG_PGM]           = SRC.[LAST_CHG_PGM]      
, TGT.[LAST_CHG_BY]            = SRC.[LAST_CHG_BY]       
, TGT.[Type1RecordHash]        = SRC.[Type1RecordHash]  		 
								


	FROM	dw.FactGLARDetail		    AS TGT
	 JOIN   ##FactGLARDetail_SOURCE	AS SRC
			ON  TGT.[GL_NUMBER]  =  SRC.[GL_NUMBER] 
			and TGT.[POST_DATE]  =	SRC.[POST_DATE] 
			and TGT.[BATCH]		 =	SRC.[BATCH]		
			and TGT.[LINE]  	 =	SRC.[LINE]  	
			and TGT.[SEQ]    	 =	SRC.[SEQ]    	
					
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactGLARDetail_SOURCE		
	 DROP TABLE ##FactGLARDetail_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO


