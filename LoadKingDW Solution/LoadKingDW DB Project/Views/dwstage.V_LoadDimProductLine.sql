CREATE VIEW dwstage.V_LoadDimProductLine
AS
SELECT 		                                 
		  [ProductLine]				  = CAST([PRODUCT_LINE]				AS NCHAR(6))
		, [ProductLineName]			  = CAST([PRODUCT_LINE_NAME]	    AS NVARCHAR(50))
		, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST([PRODUCT_LINE]				AS NCHAR(6))
															+ CAST([PRODUCT_LINE_NAME]	        AS NVARCHAR(50)))
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)
FROM 
	dwstage.[PRODUCT_LINE]
WHERE 
	NESTING_INTERFACE = 'N' 
	AND PRODUCT_LINE <> '  '
	AND PRODUCT_LINE IN (select distinct product_line from dwstage._V_JOB_HEADER)
GROUP BY 
	PRODUCT_LINE, PRODUCT_LINE_NAME


		
GO
