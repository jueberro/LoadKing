--USE [LK-GS-EDW]
--GO

CREATE VIEW [dwstage].[V_LoadFactQuality]
AS
SELECT
ISNULL(dwo.DimWorkOrder_Key, -1) as DimWorkOrder_Key
,ISNULL(c.DimCustomer_Key, -1) as DimCustomer_Key
,-1 as DimVendor_Key
,ISNULL(i.DimInventory_Key, -1) as DimInventory_Key
,ISNULL(e.DimEmployee_Key, -1) as DimEmployee_Key
,ISNULL(de.DimDepartment_Key, -1) as DimDepartmentEmployee_Key
,ISNULL(dw.DimDepartment_Key, -1) as DimDepartmentWorkCenter_Key
,ISNULL(d.DimDate_Key, -1) as DimDate_Key

,stage.CONTROL_NUMBER
,stage.[JOB]
,stage.[JOB_SUFFIX]
,stage.[JOB_DATE_OPENED]
,stage.[SEQUENCE] 
,stage.[KEY_SEQ]
,stage.[PO_LINE]
,stage.[CUSTOMER_PO]
,stage.[SCRAP_CODE] 
,stage.[ORIGINATOR]

-- DATES--------------------------------
,dwstage.udf_cv_nvarchar6_to_date(Stage.DATE_QUALITY) as DATE_QUALITY
,dwstage.udf_cv_nvarchar8_to_date(Stage.DATE_ENTERED) as DATE_ENTERED
,stage.[TIME_ENTERED]
,dwstage.udf_cv_nvarchar6_to_date(stage.F_DATE) as F_DATE
,dwstage.udf_cv_nvarchar8_to_date(stage.CLOSE_DATE) as CLOSE_DATE

-- MEASURES------------------------------
,stage.[QTY_REJECTED]
,stage.[ORIG_SCRAP_VALUE]
,stage.[QTY_REMAINING] 
,stage.[REMAINING_VALUE] 
,stage.[UNIT_COST_MATL] 
,stage.[UNIT_COST_LABOR] 
,stage.[UNIT_COST_OVHD]
,stage.[UNIT_COST_OUTSIDE] 
,stage.[FREIGHT_COST] 
,stage.[OTHER_COST] 
,stage.[CONV_FACTOR] 

, [Type1RecordHash]	 = CAST(HASHBYTES('SHA2_256',
+ stage.CONTROL_NUMBER
+ stage.[JOB]
+ stage.[JOB_SUFFIX]
+ stage.[SEQUENCE]
+ stage.[KEY_SEQ]
+ [PO_LINE]
+ [CUSTOMER_PO]
+ [SCRAP_CODE]
+ [ORIGINATOR]
																	
+ CAST(dwstage.udf_cv_nvarchar6_to_date(Stage.DATE_QUALITY) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar8_to_date(Stage.DATE_ENTERED) AS NVARCHAR(20))
+ CAST(stage.[TIME_ENTERED] AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar6_to_date(stage.F_DATE) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar8_to_date(stage.CLOSE_DATE) AS NVARCHAR(20))

+ CAST([QTY_REJECTED] AS NVARCHAR(20))
+ CAST([ORIG_SCRAP_VALUE] AS NVARCHAR(20))
+ CAST([QTY_REMAINING] AS NVARCHAR(20))
+ CAST([REMAINING_VALUE] AS NVARCHAR(20))
+ CAST([UNIT_COST_MATL] AS NVARCHAR(20))
+ CAST([UNIT_COST_LABOR] AS NVARCHAR(20))
+ CAST([UNIT_COST_OVHD] AS NVARCHAR(20))
+ CAST([UNIT_COST_OUTSIDE] AS NVARCHAR(20))
+ CAST([FREIGHT_COST] AS NVARCHAR(20))
+ CAST([OTHER_COST] AS NVARCHAR(20))
+ CAST([CONV_FACTOR] AS NVARCHAR(20))
) AS VARBINARY (64))

-- SELECT COUNT(*)
FROM 
	dwstage._V_Quality Stage

-- insert into dwstage.QUALITY select * from [lk-gs-ods].dbo.QUALITY where etl_batch <> 1
-- insert into dwstage.QUALITY_ADDL select * from [lk-gs-ods].dbo.QUALITY_ADDL where etl_batch <> 1

LEFT OUTER JOIN dw.DimWorkOrder dwo
ON stage.JOB = dwo.WorkOrderNumber
AND stage.Job_Suffix = dwo.Suffix
AND dwstage.udf_cv_nvarchar6_to_date(stage.Job_Date_Opened)  = dwo.DateOpened
AND dwo.DWIsCurrent = 1


LEFT OUTER JOIN dw.DimInventory AS i
ON    Stage.PART = i.PartID
AND  i.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimCustomer AS c
ON    Stage.CUSTOMER = c.CustomerID
AND  c.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimEmployee AS e
ON	Stage.Employee = e.EmployeeID
AND  e.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimDepartment AS de
ON	Stage.EMPLOYEE_DEPT = de.DepartmentID		
AND  de.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimDepartment AS dw
ON	Stage.WORKCENTER = de.DepartmentID		
AND  dw.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimDate AS d
ON	dwstage.udf_cv_nvarchar8_to_date(Stage.DATE_ENTERED)  = d.[Date]			


		

GO

