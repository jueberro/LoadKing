﻿CREATE VIEW [dwstage].[V_LoadDimWorkOrder]
AS
SELECT 		                                 
		  [WorkOrderNumber_DW]			= CAST(jh.[Job]	AS NCHAR(7)) + CAST(jh.DATE_OPENED as nchar(6))
		, [WorkOrderNumber]			    = CAST(jh.[Job]	AS NCHAR(7))
				
		, [Type1RecordHash]				= CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]				= CAST(0 AS VARBINARY(64))   
															
															

	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)



		FROM     dwstage.JOB_HEADER jh
	
GO
