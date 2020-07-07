CREATE VIEW [dwstage].[V_LoadLkpOrderChanges]
AS
SELECT 		
		  [ORDER_NO]        
		, [CHANGE_DATE]     
		, [CHANGE_TIME]     
		, [TERMINAL_NO]     
		, [RECORD_NO]       
		, [FIELD_NAME]      
		, [BEFORE]          
		, [AFTER]           
		, [CUST_NO]         
		, [SHIPTO]          
		, [CUST_PO]         
		, [FILLER15]        
		, [SALESMAN]        
		, [PART]            
		, [LOCN]            
		, [PROD_LINE]       
		, [QTY]             
		, [FILLER81]        
		, [CHANGE_USER]     
		, [CHANGE_PGM]      
		, [Type1RecordHash]			= HASHBYTES('SHA2_256',   CAST([CHANGE_DATE]     AS [nchar](8))	 
															+ CAST([CHANGE_TIME]     AS [nchar](6))
															+ CAST([TERMINAL_NO]     AS [nchar](3))	
															+ CAST([RECORD_NO]       AS [nchar](4))	
															+ CAST([FIELD_NAME]      AS [nchar](30))	
															+ CAST([BEFORE]          AS [nchar](30))	
															+ CAST([AFTER]           AS [nchar](30))	
															+ CAST([CUST_NO]         AS [nchar](6))	
															+ CAST([SHIPTO]          AS [nchar](6))	
															+ CAST([CUST_PO]         AS [nchar](15))  
															+ CAST([FILLER15]        AS [nchar](15)) 
															+ CAST([SALESMAN]        AS [nchar](3))   
															+ CAST([PART]            AS [nchar](20))  
															+ CAST([LOCN]            AS [nchar](2))   
															+ CAST([PROD_LINE]       AS [nchar](5))  
															+ CAST([QTY]             AS [nvarchar](13))  
															+ CAST([FILLER81]        AS [nchar](81))
															+ CAST([CHANGE_USER]     AS [nchar](8))
															+ CAST([CHANGE_PGM]      AS [nchar](8))  
                                              )


		FROM dwstage.ORDER_CHANGES 
GO


