CREATE VIEW [dwstage].[V_LoadDimQuote]
AS
SELECT                                 
		  [QuoteNumber]					= CAST(qh.[QUOTE_NO]	AS NCHAR(7))
		, [QuoteCreationDate]			= dwstage.udf_cv_nvarchar6_to_date(qh.[DATE_QUOTE])
		, [QuoteWonLossDate]			= dwstage.udf_cv_nvarchar8_to_date(qh.[QUOTE_WON_LOSS_DATE])
		
		, [Type1RecordHash]				= CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]				= HASHBYTES('SHA2_256',        
															  CAST(qh.[Quote_No] AS NCHAR(7))
															+ CAST(dwstage.udf_cv_nvarchar6_to_date(qh.[DATE_QUOTE]) AS Varchar(10))
															+ CAST(dwstage.udf_cv_nvarchar8_to_date(qh.[QUOTE_WON_LOSS_DATE]) AS Varchar(10))
 )
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)



		FROM     dwstage.QUOTE_HEADER qh
		WHERE    qh.[RECORD_TYPE] = 'A' 
		
GO


