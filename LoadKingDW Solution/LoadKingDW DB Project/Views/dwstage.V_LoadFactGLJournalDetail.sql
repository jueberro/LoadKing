--USE [LK-GS-EDW]
--GO


CREATE VIEW dwstage.V_LoadFactGLJournalDetail
AS

SELECT 
        ISNULL(pd.DimDate_Key, -1)              as DimDatePostDateSql_Key
	   ,ISNULL(td.DimDate_Key, -1)              as DimDateTransDateSql_Key
	   ,ISNULL(rd.DimDate_Key, -1)              as DimDateReverseDateSql_Key  
	   ,ISNULL(pbd.DimDate_Key, -1)             as DimDatePeriodBeginDateSql_Key  
	   ,ISNULL(ped.DimDate_Key, -1)             as DimDatePeriodEndDateSql_Key
	   ,ISNULL(lcd.DimDate_Key, -1)             as DimDateLastChgDateSql_Key  
	   ,ISNULL(gl.DimGLAccount_Key, -1)         as DimGLAccount_Key
       ,[GL_NUMBER]             
	   ,[BATCH]                 
	   ,[LINE]                  
	   ,[SEQ]                   
	   ,[POST_DATE_SQL]         
	   ,[TRANS_DATE_SQL]        
	   ,[REVERSE_FLAG]          
	   ,[REVERSE_DATE_SQL]      
	   ,[PERIOD]                
	   ,[PERIOD_BEG_DATE_SQL]   
	   ,[PERIOD_END_DATE_SQL]   
	   ,[REFERENCE]             
	   ,[DESCRIPTION]           
	   ,[VOUCHER]               
	   ,[DB_CR_FLAG]            
	   ,[AMOUNT_CMPNY]          
	   ,[TYPE]             
	   ,[DATA_CNV_FLAG]         
	   ,[ASSET]                 
	   ,[THIRTEENTH_FLAG]        
	   ,[USERID]                
	   ,stage.[DEPT]                  
	   ,[BRANCH]                
	   ,[EXPORT_TO_EXT_SYS]     
	   ,[INCL_IN_VAT_RPT]       
	   ,[VAT_BOX]               
	   ,[FILLER]                
	   ,[TRMNL]                 
	   ,[LAST_CHG_DATE]         
	   ,[LAST_CHG_TIME]         
	   ,[LAST_CHG_PGM]          
	   ,[LAST_CHG_BY]           
       ,[Type1RecordHash]  
	   
	 = HASHBYTES('SHA2_256',

      
	+ CAST([GL_NUMBER]             AS [nchar](15))       
	+ CAST([BATCH]                 AS [nchar](5))        
	+ CAST([LINE]                  AS nvarchar(5))  --[numeric](5, 0))  
	+ CAST([SEQ]                   AS nvarchar(8))  --[numeric](8, 0))  
	+ CAST([POST_DATE_SQL]         AS nvarchar(20)) --[date]           
	+ CAST([TRANS_DATE_SQL]        AS nvarchar(20)) --[date]            
    + CAST([REVERSE_FLAG]          AS nchar(1))     --[bit]            
	+ CAST([REVERSE_DATE_SQL]      AS nvarchar(20)) --[date]            
	+ CAST([PERIOD]                AS nvarchar(2))  --[numeric](2, 0))    
	+ CAST([PERIOD_BEG_DATE_SQL]   AS nvarchar(20)) --[date]            
	+ CAST([PERIOD_END_DATE_SQL]   AS nvarchar(20)) --[date]            
    + CAST([REFERENCE]             AS [nchar](15))       
	+ CAST([DESCRIPTION]           AS [nchar](30))       
	+ CAST([VOUCHER]               AS [nchar](7))        
	+ CAST([DB_CR_FLAG]            AS nchar(1))     --[bit]            
	+ CAST([AMOUNT_CMPNY]          AS nvarchar(16)) --[numeric](16, 0))  
	+ CAST([TYPE]             AS nvarchar(2))  --[numeric](2, 0))    
	+ CAST([DATA_CNV_FLAG]         AS nvarchar(2))  --[numeric](2, 0))  
	+ CAST([ASSET]                 AS [nchar](6))        
	+ CAST([THIRTEENTH_FLAG]        AS nchar(1)) --[bit]            
	+ CAST([USERID]                AS [nchar](8))        
	+ CAST(stage.[DEPT]                  AS [nchar](4))        
	+ CAST([BRANCH]                AS [nchar](2))        
	+ CAST([EXPORT_TO_EXT_SYS]     AS nchar(1)) --[bit]            
	+ CAST([INCL_IN_VAT_RPT]       AS nchar(1)) --[bit]           
	+ CAST([VAT_BOX]               AS [nchar](2))        
	+ CAST([FILLER]                AS [nchar](50))       
	+ CAST([TRMNL]                 AS [nchar](3))        
	+ CAST([LAST_CHG_DATE]         AS nvarchar(20)) --[date]            
	+ CAST([LAST_CHG_TIME]         AS nvarchar(10)) --[time](0))        
	+ CAST([LAST_CHG_PGM]          AS [nchar](8))        
	+ CAST([LAST_CHG_BY]           AS [nchar](8))                   
										
                )

FROM 
	dwstage.GL_JOURNAL_DTL Stage

LEFT OUTER JOIN dw.DimDate AS pd
ON	Stage.POST_DATE_SQL   = pd.[Date]		

LEFT OUTER JOIN dw.DimDate AS td
ON	Stage.TRANS_DATE_SQL  = td.[Date]	

LEFT OUTER JOIN dw.DimDate AS rd
ON	Stage.REVERSE_DATE_SQL  = rd.[Date]

LEFT OUTER JOIN dw.DimDate AS pbd
ON	Stage.PERIOD_BEG_DATE_SQL  = pbd.[Date]

LEFT OUTER JOIN dw.DimDate AS ped
ON	Stage.PERIOD_END_DATE_SQL  = ped.[Date]

LEFT OUTER JOIN dw.DimDate AS lcd
ON	Stage.LAST_CHG_DATE  = lcd.[Date]

LEFT OUTER JOIN dw.DimGLAccount AS gl
ON	Stage.GL_Number  = gl.[GLAccount]
and gl.DWIsCurrent = 1

GO


