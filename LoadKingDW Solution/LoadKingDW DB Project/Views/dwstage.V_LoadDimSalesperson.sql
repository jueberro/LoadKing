CREATE VIEW [dwstage].[V_LoadDimSalesperson]
AS
SELECT 		                                 
		  [SalespersonID]	  = CAST([ID]	AS NVARCHAR(3))
		, [Name]			  = CAST([NAME]				AS NVARCHAR(100))
		, [EMAIL]			  = CAST([EMAIL]			AS NVARCHAR(100))

		, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST([ID]				AS NVARCHAR(3))
															+ CAST([NAME]	        AS NVARCHAR(100))
															+ CAST([EMAIL]			AS NVARCHAR(100))
 )
	
	
	
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)



		FROM     dwstage.SALESPERSONS
		
GO


