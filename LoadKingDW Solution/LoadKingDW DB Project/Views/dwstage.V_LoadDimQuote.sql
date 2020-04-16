CREATE VIEW [dwstage].[V_LoadDimQuote]
AS
SELECT 		                                 
		  [QuoteNumber]					= CAST([QuoteNo]	AS CHAR(7))
		, [QuoteCreationDate]			= CAST([DATE_QUOTE]	AS char(6))
		, [QuoteWonLossDate]			= CAST([QUOTE_WON_LOSS_DATE] AS CHAR(8))
		
		, [Type1RecordHash]				= CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]				= HASHBYTES('SHA2_256',        
															+ CAST([QuoteNo]				AS CHAR(7))
															+ CAST([DATE_QUOTE]	        AS CHAR(6))
															+ CAST([QUOTE_WON_LOSS_DATE]			AS CHAR(8))
 )
	
	
	
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)



		FROM     dwstage.DimQuote
		
GO


