CREATE VIEW [dwstage].[V_LoadFactGLARDetail]
AS

SELECT 
       ISNULL(pd.DimDate_Key, -1)              as DimDatePostDate_Key
	  ,ISNULL(td.DimDate_Key, -1)              as DimDateTransDate_Key
	  ,ISNULL(td.DimDate_Key, -1)              as DimDateRetainDate_Key
	  ,ISNULL(id.DimDate_Key, -1)              as DimDateInvcDate_Key  
	  ,ISNULL(idd.DimDate_Key, -1)             as DimDateInvcDueDate_Key  
	  ,ISNULL(ddd.DimDate_Key, -1)             as DimDateDiscDueDate_Key
	  ,ISNULL(ddd.DimDate_Key, -1)             as DimDatExchDate_Key
	  ,ISNULL(lcd.DimDate_Key, -1)             as DimDateLastChgDate_Key  
	  ,ISNULL(gl.DimGLAccount_Key, -1)         as DimGLAccount_Key
	  ,ISNULL(c.DimCustomer_Key, -1)           as DimCustomer_Key
	  
	  ,[GL_NUMBER]          
	  ,dwstage.udf_cv_nvarchar8_to_date([POST_DATE])  AS POST_DATE       
	  ,[BATCH]              
	  ,[LINE]               
	  ,[SEQ]                
	  ,[USERID]             
	  ,[CUST]               
	  ,[CUST_NAME]          
	  ,[INVOICE_NO]         
	  ,dwstage.udf_cv_nvarchar8_to_date([TRANS_DATE])   AS TRANS_DATE      
	  ,dwstage.udf_cv_nvarchar8_to_date([RETAIN_DATE])  AS RETAIN_DATE       
	  ,dwstage.udf_cv_nvarchar8_to_date([INVC_DATE])    AS INVC_DATE      
	  ,[INVC_DTE_J]         
	  ,dwstage.udf_cv_nvarchar8_to_date([INVC_DUE_DATE])   AS INVC_DUE_DATE   
	  ,[INVC_DUE_DTE_J]     
	  ,dwstage.udf_cv_nvarchar8_to_date([DISC_DUE_DATE])   AS DISC_DUE_DATE   
	  ,[DISC_DUE_DTE_J]     
	  ,[TRAN_TYPE]          
	  ,[TRTY_BRANCH]        
	  ,[RETAIN]             
	  ,[SALSM]              
	  ,[REFN]               
	  ,[AREA]               
	  ,[STATE]              
	  ,[FACTOR_FLAG]        
	  ,[TERMS_CODE]         
	  ,[PAYMENT_TYPE]       
	  ,[PREPAID_FLAG]       
	  ,[EXCH_VARIANCE_FLAG] 
	  ,[TAXABLE_FLG]        
	  ,[ORDER_NUM]          
	  ,[ORDER_SEQ]          
	  ,dwstage.udf_cv_nvarchar8_to_date([EXCH_DATE])         AS EXCH_DATE 
	  ,[EXCH_OE_CURR]       
	  ,[EXCH_OE_RATE]       
	  ,[EXCH_CMPNY_CURR]    
	  ,[EXCH_CMPNY_RATE]    
	  ,[DB_CR_FLAG]         
	  ,[AMOUNT_CMPNY]       
	  ,[COST_CMPNY]         
	  ,[INVTOT_CMPNY]       
	  ,[FRT_AMT_CMPNY]      
	  ,[TAX_AMT_CMPNY]      
	  ,[INVC_DISC_CMPNY]    
	  ,[TAXABLE_AMT_CMPNY]  
	  ,[RETENTION_CMPNY]    
	  ,[AMOUNT_OE]          
	  ,[COST_OE]            
	  ,[INVTOT_OE]          
	  ,[FRT_AMT_OE]         
	  ,[TAX_AMT_OE]         
	  ,[INVC_DISC_OE]       
	  ,[TAXABL_AMT_OE]      
	  ,[RETENTION_OE]       
	  ,[EXPORT_TO_EXT_SYS]  
	  ,[PAYMENT_CURR]       
	  ,[FILLER]             
	  ,[TRMNL]              
	  ,[LAST_CHG_DATE]      
	  ,[LAST_CHG_TIME]      
	  ,[LAST_CHG_PGM]       
	  ,[LAST_CHG_BY]        
	 
      ,[Type1RecordHash]  
	  
	  = HASHBYTES('SHA2_256',

      
	+ CAST([GL_NUMBER]          AS [nchar](15))       
	+ CAST([POST_DATE]          AS [nchar](8))        
	+ CAST([BATCH]              AS [nchar](5))        
	+ CAST([LINE]               AS [nvarchar](5)) 
	+ CAST([SEQ]                AS [nvarchar](8)) 
	+ CAST([USERID]             AS [nchar](8))        
	+ CAST([CUST]               AS [nchar](7))        
	+ CAST([CUST_NAME]          AS [nchar](50))       
	+ CAST([INVOICE_NO]         AS [nchar](25))       
    + CAST([TRANS_DATE]         AS [nchar](8))        
	+ CAST([RETAIN_DATE]        AS [nchar](8))        
    + CAST([INVC_DATE]          AS [nchar](8))        
	+ CAST([INVC_DTE_J]         AS [nvarchar](5))  
	+ CAST([INVC_DUE_DATE]      AS [nchar](8))        
	+ CAST([INVC_DUE_DTE_J]     AS [nvarchar](5))  
    + CAST([DISC_DUE_DATE]      AS [nchar](8))        
	+ CAST([DISC_DUE_DTE_J]     AS [nvarchar](5))  
	+ CAST([TRAN_TYPE]          AS [nvarchar](2))  
	+ CAST([TRTY_BRANCH]        AS [nchar](2))        
	+ CAST([RETAIN]             AS [nchar](1))              
	+ CAST([SALSM]              AS [nchar](3))        
	+ CAST([REFN]               AS [nchar](15))       
	+ CAST([AREA]               AS [nchar](2))        
	+ CAST([STATE]              AS [nchar](2))        
	+ CAST([FACTOR_FLAG]        AS [nchar](1))              
	+ CAST([TERMS_CODE]         AS [nchar](1))        
	+ CAST([PAYMENT_TYPE]       AS [nvarchar](3))  
	+ CAST([PREPAID_FLAG]       AS [nchar](1))              
	+ CAST([EXCH_VARIANCE_FLAG] AS [nchar](1))              
	+ CAST([TAXABLE_FLG]        AS [nchar](1))              
	+ CAST([ORDER_NUM]          AS [nvarchar](7))  
	+ CAST([ORDER_SEQ]          AS [nvarchar](4))  
	+ CAST([EXCH_DATE]          AS [nchar](8))        
	+ CAST([EXCH_OE_CURR]       AS [nchar](3))        
	+ CAST([EXCH_OE_RATE]       AS [nvarchar](10))
	+ CAST([EXCH_CMPNY_CURR]    AS [nchar](3))        
	+ CAST([EXCH_CMPNY_RATE]    AS [nvarchar](10)) 
	+ CAST([DB_CR_FLAG]         AS [nchar](1))              
	+ CAST([AMOUNT_CMPNY]       AS [nvarchar](16))
	+ CAST([COST_CMPNY]         AS [nvarchar](16))
	+ CAST([INVTOT_CMPNY]       AS [nvarchar](16))
	+ CAST([FRT_AMT_CMPNY]      AS [nvarchar](11))
	+ CAST([TAX_AMT_CMPNY]      AS [nvarchar](11))
	+ CAST([INVC_DISC_CMPNY]    AS [nvarchar](10))
	+ CAST([TAXABLE_AMT_CMPNY]  AS [nvarchar](16))
	+ CAST([RETENTION_CMPNY]    AS [nvarchar](16))
	+ CAST([AMOUNT_OE]          AS [nvarchar](16))
	+ CAST([COST_OE]            AS [nvarchar](16))
	+ CAST([INVTOT_OE]          AS [nvarchar](16))
	+ CAST([FRT_AMT_OE]         AS [nvarchar](11))
	+ CAST([TAX_AMT_OE]         AS [nvarchar](11))
	+ CAST([INVC_DISC_OE]       AS [nvarchar](10))
	+ CAST([TAXABL_AMT_OE]      AS [nvarchar](16))
	+ CAST([RETENTION_OE]       AS [nvarchar](16))
	+ CAST([EXPORT_TO_EXT_SYS]  AS [nchar](1))              
	+ CAST([PAYMENT_CURR]       AS [nchar](3))        
	+ CAST([FILLER]             AS [nchar](96))       
	+ CAST([TRMNL]              AS [nchar](3))        
	+ CAST([LAST_CHG_DATE]      AS [nvarchar](20)) --[date]             
	+ CAST([LAST_CHG_TIME]      AS [nvarchar](20)) --[time](0))         
	+ CAST([LAST_CHG_PGM]       AS [nchar](8))        
	+ CAST([LAST_CHG_BY]        AS [nchar](8))        
										
                               )

-- Insert into dwstage._v_job select * from [lk-gs-ods].dbo._v_job
-- SELECT COUNT(*)
FROM 
	dwstage.GL_AR_Detail Stage

LEFT OUTER JOIN dw.DimDate AS pd
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.POST_DATE)   = pd.[Date]		

LEFT OUTER JOIN dw.DimDate AS td
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.TRANS_DATE)  = td.[Date]	

LEFT OUTER JOIN dw.DimDate AS rd
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.RETAIN_DATE)  = rd.[Date]

LEFT OUTER JOIN dw.DimDate AS id
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.INVC_DATE)  = id.[Date]

LEFT OUTER JOIN dw.DimDate AS idd
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.INVC_DUE_DATE)  = idd.[Date]

LEFT OUTER JOIN dw.DimDate AS ddd
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.DISC_DUE_DATE)  = ddd.[Date]

LEFT OUTER JOIN dw.DimDate AS ed
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.EXCH_DATE)  = ed.[Date]

LEFT OUTER JOIN dw.DimDate AS lcd
ON	Stage.LAST_CHG_DATE  = lcd.[Date]

LEFT OUTER JOIN dw.DimGLAccount AS gl
ON	Stage.GL_Number  = gl.[GLAccount]
and gl.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimCustomer AS c
ON	Stage.Cust  = c.CustomerID
and c.DWIsCurrent = 1



GO