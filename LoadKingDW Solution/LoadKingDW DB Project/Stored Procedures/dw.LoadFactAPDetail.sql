CREATE PROCEDURE [dw].[sp_LoadFactAPDetail] @LoadLogKey INT  AS

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

IF object_id('##FactAPDetail_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactAPDetail_SOURCE
	END

IF object_id('##FactAPDetail_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactAPDetail_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactAPDetail_SOURCE (

[DimDatePostDateSql_Key] [int] NOT NULL,
[DimDateTransDateSql_Key] [int] NOT NULL,
[DimDateInvcDateSql_Key] [int] NOT NULL,
[DimDateInvcDueDateSql_Key] [int] NOT NULL,
[DimDateDiscDueDateSql_Key] [int] NOT NULL,
[DimDateLastChgDateSql_Key] [int] NOT NULL,
[DimExchDateSql_Key] [int] NOT NULL,
[DimGLAccount_Key] [int] NOT NULL,
[DimVendor_Key] [int] NOT NULL,
[DimPurchaseOrder_Key] [int] NOT NULL,
[DimWorkOrder_Key] [int] NOT NULL,
[GL_NUMBER] [char](15) NULL,
[VENDOR] [char](7) NULL,
[PO_NUM] [char](7) NULL,
[PO_LINE] [char](3) NULL,
[WO] [char](7) NULL,
[WO_SUFFIX] [char](4) NULL,
[POST_DATE] [char](8) NULL,
[BATCH] [char](5)       NULL,
[LINE] [numeric](5, 0)  NULL,
[SEQ] [numeric](8, 0)   NULL,
[USERID] [char](8) NULL,
[INVOICE_NO] [char](25) NULL,
[POST_DATE_SQL] [date] NULL,
[TRANS_DATE_SQL] [date] NULL,
[INVC_DATE_SQL] [date] NULL,
[INVC_DUE_DATE_SEQL] [date] NULL,
[DISC_DUE_DATE_SQL] [date] NULL,
[LAST_CHG_DATE] [date] NULL,
[EXCH_DATE_SQL] [date] NULL,
[LAST_CHG_BY] [char](8) NULL,
[TRAN_TYPE] [numeric](2, 0) NULL,
[AP_CODE] [numeric](2, 0) NULL,
[TRTY_BRANCH] [char](2) NULL,
[AREA] [char](2) NULL,
[BUYER] [char](3) NULL,
[RECEIVER] [char](6) NULL,
[WO_SEQ] [numeric](6, 0) NULL,
[WO_KEY_SEQ] [numeric](4, 0) NULL,
[CHK_O_DESC] [char](30) NULL,
[VOU_NUM] [char](7) NULL,
[PART_PO] [char](1) NULL,
[INV_MESSAGE] [numeric](3, 0) NULL,
[PAY_SEL] [numeric](3, 0) NULL,
[RETURN_NUM] [numeric](7, 0) NULL,
[RETURN_SEQ] [numeric](3, 0) NULL,
[PACK_LIST] [char](16) NULL,
[TAX_CODE] [char](5) NULL,
[VAT_RULE] [numeric](3, 0) NULL,
[EXCH_VEND_CURR] [char](3) NULL,
[EXCH_CMPNY_CURR] [char](3) NULL,
[TRMNL] [char](3) NULL,
[INCL_IN_VAT_RPT] [bit] NULL,
[JOB_UPDATE] [bit] NULL,
[RETURN] [bit] NULL,
[ADJ_ACC_FLAG] [bit] NULL,
[INVC_EXP_FLG] [bit] NULL,
[DB_CR_FLAG] [bit] NULL,
[EXPORT_TO_EXT_SYS] [bit] NULL,
[TAXABLE_FLG] [bit] NULL,
[USE_TAX_FLAG] [bit] NULL,
[EXCH_VEND_RATE] [numeric](10, 5) NULL,
[EXCH_CMPNY_RATE] [numeric](10, 5) NULL,
[AMOUNT_CMPNY] [numeric](16, 2) NULL,
[INVC_AMT_CMPNY] [numeric](16, 2) NULL,
[INVC_TAXBL_AMT_CMPNY] [numeric](16, 2) NULL,
[INVC_DISCT_CMPNY] [numeric](10, 2) NULL,
[FRT_CMPNY] [numeric](11, 2) NULL,
[OTH_CMPNY] [numeric](11, 2) NULL,
[INVC_TAX_AMT_CMPNY] [numeric](16, 2) NULL,
[RETN_AMT_CMPNY] [numeric](16, 2) NULL,
[AMOUNT_VEND] [numeric](16, 2) NULL,
[INVC_AMT_VEND] [numeric](16, 2) NULL,
[INVC_TAXABL_AMT_VEND] [numeric](16, 2) NULL,
[INVC_DISCT_VEND] [numeric](10, 2) NULL,
[QUANTITY] [numeric](14, 4) NULL,
[FRT_VEND] [numeric](11, 2) NULL,
[OTH_VEND] [numeric](11, 2) NULL,
[INVC_TAX_AMT_VEND] [numeric](16, 2) NULL,
[RETN_AMT_VEND] [numeric](16, 2) NULL,
[Type1RecordHash] [varbinary](8000) NULL
)
	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactAPDetail_SOURCE
			SELECT * from dwstage.V_LoadFactAPDetail

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactAPDetail_TARGET 
					(
					 [GL_NUMBER] [char](15)
					,[POST_DATE] [char](8)
					,[BATCH] [char](5)      
					,[LINE] [numeric](5, 0) 
					,[SEQ] [numeric](8, 0)  
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactAPDetail_TARGET
	SELECT	
			 [GL_NUMBER] 
			,[POST_DATE] 
			,[BATCH]
			,[LINE]  
			,[SEQ]    
			,Type1RecordHash 
	FROM	dw.FactAPDetail

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactAPDetail 
	SELECT	*
	FROM	##FactAPDetail_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactAPDetail AS TGT
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

  TGT.DimDatePostDateSql_Key     = SRC.DimDatePostDateSql_Key     
, TGT.DimDateTransDateSql_Key    = SRC.DimDateTransDateSql_Key    
, TGT.DimDateInvcDateSql_Key     = SRC.DimDateInvcDateSql_Key     
, TGT.DimDateInvcDueDateSql_Key  = SRC.DimDateInvcDueDateSql_Key  
, TGT.DimDateDiscDueDateSql_Key  = SRC.DimDateDiscDueDateSql_Key  
, TGT.DimDateLastChgDateSql_Key  = SRC.DimDateLastChgDateSql_Key  
, TGT.DimExchDateSql_Key         = SRC.DimExchDateSql_Key         
, TGT.DimGLAccount_Key           = SRC.DimGLAccount_Key           
, TGT.DimVendor_Key              = SRC.DimVendor_Key              
, TGT.DimPurchaseOrder_Key       = SRC.DimPurchaseOrder_Key       
, TGT.DimWorkOrder_Key           = SRC.DimWorkOrder_Key           
, TGT.[GL_NUMBER]                = SRC.[GL_NUMBER]                
, TGT.stage.[VENDOR]             = SRC.stage.[VENDOR]             
, TGT.[PO_NUM]                   = SRC.[PO_NUM]                   
, TGT.[PO_LINE]                  = SRC.[PO_LINE]                  
, TGT.[WO]                       = SRC.[WO]                       
, TGT.[WO_SUFFIX]                = SRC.[WO_SUFFIX]                
, TGT.[POST_DATE]                = SRC.[POST_DATE]                
, TGT.[BATCH]                    = SRC.[BATCH]                    
, TGT.[LINE]                     = SRC.[LINE]                     
, TGT.[SEQ]                      = SRC.[SEQ]                      
, TGT.[USERID]                   = SRC.[USERID]                   
, TGT.[INVOICE_NO]               = SRC.[INVOICE_NO]               
, TGT.[POST_DATE_SQL]            = SRC.[POST_DATE_SQL]            
, TGT.[TRANS_DATE_SQL]           = SRC.[TRANS_DATE_SQL]           
, TGT.[INVC_DATE_SQL]            = SRC.[INVC_DATE_SQL]            
, TGT.[INVC_DUE_DATE_SEQL]       = SRC.[INVC_DUE_DATE_SEQL]       
, TGT.[DISC_DUE_DATE_SQL]        = SRC.[DISC_DUE_DATE_SQL]        
, TGT.[LAST_CHG_DATE]            = SRC.[LAST_CHG_DATE]            
, TGT.[EXCH_DATE_SQL]            = SRC.[EXCH_DATE_SQL]            
, TGT.[LAST_CHG_BY]              = SRC.[LAST_CHG_BY]              
, TGT.[TRAN_TYPE]                = SRC.[TRAN_TYPE]                
, TGT.[AP_CODE]                  = SRC.[AP_CODE]                  
, TGT.[TRTY_BRANCH]              = SRC.[TRTY_BRANCH]              
, TGT.[AREA]                     = SRC.[AREA]                     
, TGT.[BUYER]                    = SRC.[BUYER]                    
, TGT.[RECEIVER]                 = SRC.[RECEIVER]                 
, TGT.[WO_SEQ]                   = SRC.[WO_SEQ]                   
, TGT.[WO_KEY_SEQ]               = SRC.[WO_KEY_SEQ]               
, TGT.[CHK_O_DESC]               = SRC.[CHK_O_DESC]               
, TGT.[VOU_NUM]                  = SRC.[VOU_NUM]                  
, TGT.[PART_PO]                  = SRC.[PART_PO]                  
, TGT.[INV_MESSAGE]              = SRC.[INV_MESSAGE]              
, TGT.[PAY_SEL]                  = SRC.[PAY_SEL]                  
, TGT.[RETURN_NUM]               = SRC.[RETURN_NUM]               
, TGT.[RETURN_SEQ]               = SRC.[RETURN_SEQ]               
, TGT.[PACK_LIST]                = SRC.[PACK_LIST]                
, TGT.[TAX_CODE]                 = SRC.[TAX_CODE]                 
, TGT.[VAT_RULE]                 = SRC.[VAT_RULE]                 
, TGT.[EXCH_VEND_CURR]           = SRC.[EXCH_VEND_CURR]           
, TGT.[EXCH_CMPNY_CURR]          = SRC.[EXCH_CMPNY_CURR]          
, TGT.[TRMNL]                    = SRC.[TRMNL]                    
, TGT.[INCL_IN_VAT_RPT]          = SRC.[INCL_IN_VAT_RPT]          
, TGT.[JOB_UPDATE]               = SRC.[JOB_UPDATE]               
, TGT.[RETURN]                   = SRC.[RETURN]                   
, TGT.[ADJ_ACC_FLAG]             = SRC.[ADJ_ACC_FLAG]             
, TGT.[INVC_EXP_FLG]             = SRC.[INVC_EXP_FLG]             
, TGT.[DB_CR_FLAG]               = SRC.[DB_CR_FLAG]               
, TGT.[EXPORT_TO_EXT_SYS]        = SRC.[EXPORT_TO_EXT_SYS]        
, TGT.[TAXABLE_FLG]              = SRC.[TAXABLE_FLG]              
, TGT.[USE_TAX_FLAG]             = SRC.[USE_TAX_FLAG]             
, TGT.[EXCH_VEND_RATE]           = SRC.[EXCH_VEND_RATE]           
, TGT.[EXCH_CMPNY_RATE]          = SRC.[EXCH_CMPNY_RATE]          
, TGT.[AMOUNT_CMPNY]             = SRC.[AMOUNT_CMPNY]             
, TGT.[INVC_AMT_CMPNY]           = SRC.[INVC_AMT_CMPNY]           
, TGT.[INVC_TAXBL_AMT_CMPNY]     = SRC.[INVC_TAXBL_AMT_CMPNY]     
, TGT.[INVC_DISCT_CMPNY]         = SRC.[INVC_DISCT_CMPNY]         
, TGT.[FRT_CMPNY]                = SRC.[FRT_CMPNY]                
, TGT.[OTH_CMPNY]                = SRC.[OTH_CMPNY]                
, TGT.[INVC_TAX_AMT_CMPNY]       = SRC.[INVC_TAX_AMT_CMPNY]       
, TGT.[RETN_AMT_CMPNY]           = SRC.[RETN_AMT_CMPNY]           
, TGT.[AMOUNT_VEND]              = SRC.[AMOUNT_VEND]              
, TGT.[INVC_AMT_VEND]            = SRC.[INVC_AMT_VEND]            
, TGT.[INVC_TAXABL_AMT_VEND]     = SRC.[INVC_TAXABL_AMT_VEND]     
, TGT.[INVC_DISCT_VEND]          = SRC.[INVC_DISCT_VEND]          
, TGT.[QUANTITY]                 = SRC.[QUANTITY]                 
, TGT.[FRT_VEND]                 = SRC.[FRT_VEND]                 
, TGT.[OTH_VEND]                 = SRC.[OTH_VEND]                 
, TGT.[INVC_TAX_AMT_VEND]        = SRC.[INVC_TAX_AMT_VEND]        
, TGT.[RETN_AMT_VEND]            = SRC.[RETN_AMT_VEND]            
, TGT.[Type1RecordHash]  		 = SRC.[Type1RecordHash]  		 
								


	FROM	dw.FactAPDetail		    AS TGT
	 JOIN   ##FactAPDetail_SOURCE	AS SRC
			ON  TGT.[GL_NUMBER]  =  SRC.[GL_NUMBER] 
			and TGT.[POST_DATE]  =	SRC.[POST_DATE] 
			and TGT.[BATCH]		 =	SRC.[BATCH]		
			and TGT.[LINE]  	 =	SRC.[LINE]  	
			and TGT.[SEQ]    	 =	SRC.[SEQ]    	
					
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactAPDetail_SOURCE		
	 DROP TABLE ##FactAPDetail_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO
