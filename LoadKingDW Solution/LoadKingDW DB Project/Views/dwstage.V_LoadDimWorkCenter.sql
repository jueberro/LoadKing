CREATE VIEW dwstage.V_LoadDimWorkCenter
AS
SELECT 		                                 
		  MACHINE			  = CAST(MACHINE				AS NCHAR(4))
		, WorkCenterName			  = CAST([WC_NAME]	    AS NVARCHAR(20))
		, WorkCenterDepartment			  = CAST([WC_DEPT]	    AS NVARCHAR(4))
		, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST(MACHINE AS NCHAR(4))
															+ CAST([WC_NAME] AS NVARCHAR(20))
															+ CAST([WC_DEPT] AS NVARCHAR(4))															
															)
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)
FROM 
	dwstage.WORKCENTERS
GO
-- INSERT INTO dwstage.WORKCENTERS select * from [lk-gs-ods].dbo.workcenters
