CREATE VIEW [dwstage].[V_LoadFactGLAPDetail]
AS
SELECT 
       ISNULL(pd.DimDate_Key, -1)              as DimDatePostDateSql_Key
	  ,ISNULL(td.DimDate_Key, -1)              as DimDateTransDateSql_Key
	  ,ISNULL(id.DimDate_Key, -1)              as DimDateInvcDateSql_Key  
	  ,ISNULL(idd.DimDate_Key, -1)             as DimDateInvcDueDateSql_Key  
	  ,ISNULL(ddd.DimDate_Key, -1)             as DimDateDiscDueDateSql_Key
	  ,ISNULL(lcd.DimDate_Key, -1)             as DimDateLastChgDateSql_Key  
	  ,ISNULL(ed.DimDate_Key, -1)              as DimExchDateSql_Key  
	  ,ISNULL(gl.DimGLAccount_Key, -1)         as DimGLAccount_Key
	  ,ISNULL(v.DimVendor_Key, -1)             as DimVendor_Key
	  ,ISNULL(po.DimPurchaseOrder_Key, -1)     as DimPurchaseOrder_Key
	  ,ISNULL(wo.DimWorkOrder_Key, -1)         as DimWorkOrder_Key

      ,[GL_NUMBER]    -- GL Key Lookup   
	  ,stage.[VENDOR]       -- Vendor Key Lookup   
	  ,[PO_NUM]       -- PO Line Key Lookup
	  ,[PO_LINE]      -- PO Line Key Lookup
	  ,[WO]           -- WO Key Lookup           
      ,[WO_SUFFIX]    -- WO Key Lookup
      ,[POST_DATE]               
      ,[BATCH]                   
      ,[LINE]                    
      ,[SEQ]                     
      ,[USERID]                  
      ,[INVOICE_NO]              
      ,[POST_DATE_SQL]           
      ,[TRANS_DATE_SQL]          
      ,[INVC_DATE_SQL]           
      ,[INVC_DUE_DATE_SEQL]      
      ,[DISC_DUE_DATE_SQL]       
      ,[LAST_CHG_DATE]           
      ,[EXCH_DATE_SQL]           
      ,[LAST_CHG_BY]             
      ,[TRAN_TYPE]               
      ,[AP_CODE]                 
      ,[TRTY_BRANCH]             
      ,[AREA]                    
      ,[BUYER]                   
      ,[RECEIVER]                
      ,[WO_SEQ]                  
      ,[WO_KEY_SEQ]              
      ,[CHK_O_DESC]              
      ,[VOU_NUM]                 
      ,[PART_PO]                 
      ,[INV_MESSAGE]             
      ,[PAY_SEL]                 
      ,[RETURN_NUM]              
      ,[RETURN_SEQ]              
      ,[PACK_LIST]               
      ,[TAX_CODE]                
      ,[VAT_RULE]                
      ,[EXCH_VEND_CURR]          
      ,[EXCH_CMPNY_CURR]         
      ,[TRMNL]                   
      ,[INCL_IN_VAT_RPT]         
      ,[JOB_UPDATE]              
      ,[RETURN]                  
      ,[ADJ_ACC_FLAG]            
      ,[INVC_EXP_FLG]            
      ,[DB_CR_FLAG]              
      ,[EXPORT_TO_EXT_SYS]       
      ,[TAXABLE_FLG]             
      ,[USE_TAX_FLAG]            
      ,[EXCH_VEND_RATE]          
      ,[EXCH_CMPNY_RATE]         
      ,[AMOUNT_CMPNY]            
      ,[INVC_AMT_CMPNY]          
      ,[INVC_TAXBL_AMT_CMPNY]    
      ,[INVC_DISCT_CMPNY]        
      ,[FRT_CMPNY]               
      ,[OTH_CMPNY]               
      ,[INVC_TAX_AMT_CMPNY]      
      ,[RETN_AMT_CMPNY]          
      ,[AMOUNT_VEND]             
      ,[INVC_AMT_VEND]           
      ,[INVC_TAXABL_AMT_VEND]    
      ,[INVC_DISCT_VEND]         
      ,[QUANTITY]                
      ,[FRT_VEND]                
      ,[OTH_VEND]                
      ,[INVC_TAX_AMT_VEND]       
      ,[RETN_AMT_VEND]           
     
, [Type1RecordHash]	 = HASHBYTES('SHA2_256',

      CAST([GL_NUMBER]           AS       [nchar](15))       
	+ CAST([POST_DATE]           AS       [nchar](8))        
	+ CAST([BATCH]               AS       [nchar](5))        
	+ CAST([LINE]                AS       nvarchar(5)) --[numeric](5, 0))  
	+ CAST([SEQ]                 AS       nvarchar(8)) --[numeric](8, 0))  
	+ CAST([USERID]              AS       [nchar](8))        
	+ CAST(stage.[VENDOR]              AS       [nchar](7))        
	+ CAST([VENDOR_NAME]         AS       [nchar](50))       
	+ CAST([INVOICE_NO]          AS       [nchar](25))       
	+ CAST([POST_DATE_SQL]       AS       nvarchar(20))    --Date Key       
	+ CAST([TRANS_DATE_SQL]      AS       nvarchar(20))    --Date Key
	+ CAST([INVC_DATE_SQL]       AS       nvarchar(20))    --Date Key
	+ CAST([INVC_DUE_DATE_SEQL]  AS       nvarchar(20))    --Date Key
--	+ CAST([DISC_DUE_DATE_SQL]   AS       nvarchar(20))    --Date Key
	+ CAST([LAST_CHG_DATE]       AS       nvarchar(20))    --Date Key
--	+ CAST([EXCH_DATE_SQL]       AS       nvarchar(20))    --Date Key
	+ CAST([LAST_CHG_BY]         AS       [nchar](8))        
	+ CAST([TRAN_TYPE]           AS       nvarchar(2)) --[numeric](2, 0)) 
	+ CAST([AP_CODE]             AS       nvarchar(2)) --[numeric](2, 0)  
	+ CAST([TRTY_BRANCH]         AS       [nchar](2))        
	+ CAST([AREA]                AS       [nchar](2))        
	+ CAST([BUYER]               AS       [nchar](3))        
	+ CAST([PO_NUM]              AS       [nchar](7))        
	+ CAST([RECEIVER]            AS       [nchar](6))        
	+ CAST([WO]                  AS       [nchar](7))        
	+ CAST([WO_SUFFIX]           AS       [nchar](4))        
	+ CAST([WO_SEQ]              AS       nvarchar(6)) --[numeric](6, 0))  
	+ CAST([WO_KEY_SEQ]          AS       nvarchar(4)) --[numeric](4, 0))  
	+ CAST([CHK_O_DESC]          AS       [nchar](30))       
	+ CAST([VOU_NUM]             AS       [nchar](7))        
	+ CAST([PART_PO]             AS       [nchar](1))        
	+ CAST([INV_MESSAGE]         AS       nvarchar(3)) --[numeric](3, 0))  
	+ CAST([PO_LINE]             AS       [nchar](3))        
	+ CAST([PAY_SEL]             AS       nvarchar(3)) --[numeric](3, 0))  
	+ CAST([RETURN_NUM]          AS       nvarchar(7)) --[numeric](7, 0))  
	+ CAST([RETURN_SEQ]          AS       nvarchar(3)) --[numeric](3, 0))  
	+ CAST([PACK_LIST]           AS       [nchar](16))       
	+ CAST([TAX_CODE]            AS       [nchar](5))        
	+ CAST([VAT_RULE]            AS       nvarchar(3)) --[numeric](3, 0))  
	+ CAST([EXCH_VEND_CURR]      AS       [nchar](3))        
	+ CAST([EXCH_CMPNY_CURR]     AS       [nchar](3))        
	+ CAST([TRMNL]               AS       [nchar](3))        
	+ CAST([INCL_IN_VAT_RPT]     AS       nchar(1)) --[bit]            
	+ CAST([JOB_UPDATE]          AS       nchar(1)) --[bit] [bit]            
	+ CAST([RETURN]              AS       nchar(1)) --[bit] [bit]            
	+ CAST([ADJ_ACC_FLAG]        AS       nchar(1)) --[bit] [bit]            
	+ CAST([INVC_EXP_FLG]        AS       nchar(1)) --[bit] [bit]            
	+ CAST([DB_CR_FLAG]          AS       nchar(1)) --[bit] [bit]            
	+ CAST([EXPORT_TO_EXT_SYS]   AS       nchar(1)) --[bit] [bit]            
	+ CAST([TAXABLE_FLG]         AS       nchar(1)) --[bit] [bit]            
	+ CAST([USE_TAX_FLAG]        AS       nchar(1)) --[bit] [bit]            
	+ CAST([EXCH_VEND_RATE]      AS       nvarchar(10)) --[numeric](10, 5)) 
	+ CAST([EXCH_CMPNY_RATE]     AS       nvarchar(10)) --[numeric](10, 5)) 
	+ CAST([AMOUNT_CMPNY]        AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([INVC_AMT_CMPNY]      AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([INVC_TAXBL_AMT_CMPNY]AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([INVC_DISCT_CMPNY]    AS       nvarchar(10)) --[numeric](10, 2)) 
	+ CAST([FRT_CMPNY]           AS       nvarchar(11)) --[numeric](11, 2)) 
	+ CAST([OTH_CMPNY]           AS       nvarchar(11)) --[numeric](11, 2)) 
	+ CAST([INVC_TAX_AMT_CMPNY]  AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([RETN_AMT_CMPNY]      AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([AMOUNT_VEND]         AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([INVC_AMT_VEND]       AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([INVC_TAXABL_AMT_VEND]AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([INVC_DISCT_VEND]     AS       nvarchar(10)) --[numeric](10, 2)) 
	+ CAST([QUANTITY]            AS       nvarchar(14)) --[numeric](14, 4)) 
	+ CAST([FRT_VEND]            AS       nvarchar(11)) --[numeric](11, 2)) 
	+ CAST([OTH_VEND]            AS       nvarchar(11)) --[numeric](11, 2)) 
	+ CAST([INVC_TAX_AMT_VEND]   AS       nvarchar(16)) --[numeric](16, 2)) 
	+ CAST([RETN_AMT_VEND]       AS       nvarchar(16)) --[numeric](16, 2)) 
													
                               )
-- Insert into dwstage._v_job select * from [lk-gs-ods].dbo._v_job
-- SELECT COUNT(*)
FROM 
	dwstage.GL_AP_Detail Stage

LEFT OUTER JOIN dw.DimDate AS pd
ON	Stage.POST_DATE_SQL   = pd.[Date]		

LEFT OUTER JOIN dw.DimDate AS td
ON	Stage.TRANS_DATE_SQL  = td.[Date]	

LEFT OUTER JOIN dw.DimDate AS id
ON	Stage.INVC_DATE_SQL  = id.[Date]

LEFT OUTER JOIN dw.DimDate AS idd
ON	Stage.INVC_DUE_DATE_SEQL  = idd.[Date]

LEFT OUTER JOIN dw.DimDate AS ddd
ON	Stage.DISC_DUE_DATE_SQL  = ddd.[Date]

LEFT OUTER JOIN dw.DimDate AS lcd
ON	Stage.LAST_CHG_DATE  = lcd.[Date]

LEFT OUTER JOIN dw.DimDate AS ed
ON	Stage.EXCH_DATE_SQL  = ed.[Date]

LEFT OUTER JOIN dw.DimGLAccount AS gl
ON	Stage.GL_Number  = gl.[GLAccount]
and gl.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimVendor AS v
ON	Stage.Vendor  = v.Vendor
and v.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimPurchaseOrder AS po
ON	   Stage.PO_NUM = po.POH_PURCHASE_ORDER
AND    Stage.PO_LINE = substring(po.POH_RECORD_NO,2,3)
and po.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimWorkOrder AS wo
ON	Stage.WO = wo.WorkOrderNumber
AND Stage.WO_SUFFIX = wo.Suffix       
and wo.DWIsCurrent = 1

GO
