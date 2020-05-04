CREATE VIEW dwstage.V_LoadDimWorkOrderType
AS

/* 5/4/2020 This view data is static and does not come from a source dwstage table.  It is derived from the below Business Rules:
There can be 5 Types of Work Orders/Jobs:
-	Single Level: Creates the Work Order from an Estimate/Router [need more clarification on this]
-	BOM: Creates the Work Order from Bill Of Material list, and Estimate/Router is still used to create the Work Order Structure
-	Single Level – Order Entry: Creates the Work Order from a Sales Order/Line using the Estimate/Router
-	BOM – Order Entry: Creates the Work Order from  a Sales Order/Line using the Bill Of Material list of components
-	Single Level – Split: Splits out the quantity of an existing Work Order
*/

SELECT WorkOrderType = 'Other', WorkOrderTypeDescription = 'Work Order Type exists but not defined'
, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
													+ CAST('Other'				AS NCHAR(50))
													+ CAST('Work Order Type exists but not defined'	        AS NVARCHAR(1000)))
, [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
, [DWEffectiveEndDate]		  = '2100-01-01'
, [DWIsCurrent]				  = CAST(1					  AS BIT)
, [LoadLogKey]				  = CAST(0                    AS INT)

UNION ALL 

SELECT WorkOrderType = 'Sales Order', WorkOrderTypeDescription = 'Single Level – Order Entry: Creates the Work Order from a Sales Order/Line using the Estimate/Router'
, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
													+ CAST('Sales Order'				AS NCHAR(50))
													+ CAST('Single Level – Order Entry: Creates the Work Order from a Sales Order/Line using the Estimate/Router'        AS NVARCHAR(1000)))
, [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
, [DWEffectiveEndDate]		  = '2100-01-01'
, [DWIsCurrent]				  = CAST(1					  AS BIT)
, [LoadLogKey]				  = CAST(0                    AS INT)

UNION ALL

SELECT WorkOrderType = 'BOM', WorkOrderTypeDescription =  'BOM: Creates the Work Order from Bill Of Material list, and Estimate/Router is still used to create the Work Order Structure'
, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
													+ CAST('BOM'				AS NCHAR(50))
													+ CAST('BOM: Creates the Work Order from Bill Of Material list, and Estimate/Router is still used to create the Work Order Structure'	        AS NVARCHAR(1000)))
, [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
, [DWEffectiveEndDate]		  = '2100-01-01'
, [DWIsCurrent]				  = CAST(1					  AS BIT)
, [LoadLogKey]				  = CAST(0                    AS INT)

UNION ALL

SELECT WorkOrderType = 'BOM – Order Entry', WorkOrderTypeDescription =  'BOM – Order Entry: Creates the Work Order from  a Sales Order/Line using the Bill Of Material list of components'
, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
													+ CAST('BOM – Order Entry'				AS NCHAR(50))
													+ CAST('BOM – Order Entry: Creates the Work Order from  a Sales Order/Line using the Bill Of Material list of components'	        AS NVARCHAR(1000)))
, [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
, [DWEffectiveEndDate]		  = '2100-01-01'
, [DWIsCurrent]				  = CAST(1					  AS BIT)
, [LoadLogKey]				  = CAST(0                    AS INT)

UNION ALL

SELECT WorkOrderType = 'Single Level', WorkOrderTypeDescription =  'Single Level: Creates the Work Order from an Estimate/Router'
, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
													+ CAST('Single Level'				AS NCHAR(50))
													+ CAST('Single Level: Creates the Work Order from an Estimate/Router'	        AS NVARCHAR(1000)))
, [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
, [DWEffectiveEndDate]		  = '2100-01-01'
, [DWIsCurrent]				  = CAST(1					  AS BIT)
, [LoadLogKey]				  = CAST(0                    AS INT)

UNION ALL

SELECT WorkOrderType = 'Single Level – Split', WorkOrderTypeDescription =  'Single Level – Split: Splits out the quantity of an existing Work Order'
, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
													+ CAST('Single Level – Split'				AS NCHAR(50))
													+ CAST('Single Level – Split: Splits out the quantity of an existing Work Order'	        AS NVARCHAR(1000)))
, [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
, [DWEffectiveEndDate]		  = '2100-01-01'
, [DWIsCurrent]				  = CAST(1					  AS BIT)
, [LoadLogKey]				  = CAST(0                    AS INT)

GO

/*
INSERT INTO dw.DimWorkOrderType (WorkOrderType, WorkOrderTypeDescription)
VALUES ('Other', 'Work Order Type exists but not defined')
GO
INSERT INTO dw.DimWorkOrderType (WorkOrderType, WorkOrderTypeDescription)
VALUES ('Sales Order', 'Single Level – Order Entry: Creates the Work Order from a Sales Order/Line using the Estimate/Router')
GO
INSERT INTO dw.DimWorkOrderType (WorkOrderType, WorkOrderTypeDescription)
VALUES ('BOM', 'BOM: Creates the Work Order from Bill Of Material list, and Estimate/Router is still used to create the Work Order Structure')
GO
INSERT INTO dw.DimWorkOrderType (WorkOrderType, WorkOrderTypeDescription)
VALUES ('BOM – Order Entry', 'BOM – Order Entry: Creates the Work Order from  a Sales Order/Line using the Bill Of Material list of components')
GO
INSERT INTO dw.DimWorkOrderType (WorkOrderType, WorkOrderTypeDescription)
VALUES ('Single Level', 'Single Level: Creates the Work Order from an Estimate/Router')
GO
INSERT INTO dw.DimWorkOrderType (WorkOrderType, WorkOrderTypeDescription)
VALUES ('Single Level – Split', 'Single Level – Split: Splits out the quantity of an existing Work Order')
GO

*/



