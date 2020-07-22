--USE [LK-GS-EDW]
--GO


CREATE VIEW dwstage.V_LoadFactGLBalances
AS

SELECT 
	   ISNULL(lcd.DimDate_Key, -1)       as DimDateLastChgDateSql_Key  
	   ,ISNULL(gl.DimGLAccount_Key, -1)  as DimGLAccount_Key
	   ,[FISCAL_YR]
	   ,[TYPE]
	   ,[ACCT]
	   ,[COMP9_START_YR]
	   ,[BEG_BAL]
	   ,[FILLER]
	   ,[LAST_CHG_DATE]         
	   ,[LAST_CHG_TIME]   
	   ,[LAST_CHG_BY]            
	   ,[LAST_CHG_PGM]          
       ,[Type1RecordHash]  
	   
	 = HASHBYTES('SHA2_256',
	+ CAST([FISCAL_YR]          AS [nchar](4))       
	+ CAST([TYPE]               AS [nchar](1))        
	+ CAST([ACCT]               AS nvarchar(15))  
	+ CAST([COMP9_START_YR]     AS nvarchar(4))    
	+ CAST([BEG_BAL]			AS nvarchar(12))            
	+ CAST([FILLER]				AS nvarchar(100))         
	+ CAST([LAST_CHG_DATE]      AS nvarchar(20))           
	+ CAST([LAST_CHG_TIME]      AS nvarchar(10)) 
	+ CAST([LAST_CHG_BY]        AS [nchar](8))                   
	+ CAST([LAST_CHG_PGM]       AS [nchar](8))        									
                )

FROM 
	dwstage.GL_BALANCES Stage

LEFT OUTER JOIN dw.DimDate AS lcd
ON	Stage.LAST_CHG_DATE  = lcd.[Date]

LEFT OUTER JOIN dw.DimGLAccount AS gl
ON	Stage.ACCT  = gl.[GLAccount]
and gl.DWIsCurrent = 1

GO


