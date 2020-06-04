
--USE [LK-GS-EDW]
--GO

CREATE VIEW dwstage.V_LoadFactQualityDisposition
AS
SELECT
ISNULL(dwo.DimWorkOrder_Key, -1) as DimWorkOrder_Key
,ISNULL(c.DimCustomer_Key, -1) as DimCustomer_Key
,ISNULL(dv.DimVendor_Key, -1) as DimVendor_Key
,ISNULL(i.DimInventory_Key, -1) as DimInventory_Key
,ISNULL(e.DimEmployee_Key, -1) as DimEmployee_Key
,ISNULL(de.DimDepartment_Key, -1) as DimDepartmentEmployee_Key
,ISNULL(dw.DimWorkCenter_Key, -1) as DimWorkCenter_Key
,ISNULL(d.DimDate_Key, -1) as DimDate_Key

,stage.CONTROL_NUMBER as Header_CONTROL_NUMBER
,stage.[JOB] as Header_JOB
,stage.[SUFFIX] as Header_SUFFIX
,stage.[SEQUENCE] as Header_SEQUENCE

,stage.CONTROL_NUMBER
,stage.DISPOSITION_SEQ
,stage.DISCREPANCY
,stage.DISCREP_DESC
,stage.DISPOSITION_ACTION
,stage.USER_DISPOSED_BY
,stage.NEW_JOB
,stage.NEW_SUFFIX
,stage.CNC_ACTION
,stage.NO_GOOD_RPT
,stage.INSPECTED_BY
,stage.USER1
,stage.USER2

-- DATES--------------------------------
,dwstage.udf_cv_nvarchar6__yymmdd_to_date(stage.DATE_QUALITY) as Header_DATE_QUALITY
,dwstage.udf_cv_nvarchar8_to_date(stage.DATE_ENTERED) as Header_DATE_ENTERED
,dwstage.udf_cv_nvarchar6__yymmdd_to_date(stage.F_DATE) as Header_F_DATE
,dwstage.udf_cv_nvarchar8_to_date(stage.CLOSE_DATE) as Header_CLOSE_DATE

,dwstage.udf_cv_nvarchar6__yymmdd_to_date(stage.DATE_DISPOSED) as DATE_DISPOSED
,stage.TIME_DISPOSED
,dwstage.udf_cv_nvarchar6_to_date(stage.DATE_INSPECTED) as DATE_INSPECTED
,dwstage.udf_cv_nvarchar6_to_date(stage.DATE_CNC_REQ) as DATE_CNC_REQ

-- MEASURES------------------------------
,stage.QTY_DISPOSED
,stage.DISPOSED_VALUE

, [Type1RecordHash]	 = CAST(HASHBYTES('SHA2_256',
+ stage.CONTROL_NUMBER
+ stage.[JOB]
+ stage.[SUFFIX]
+ stage.[SEQUENCE]

+ stage.CONTROL_NUMBER
+ stage.DISPOSITION_SEQ
+ stage.DISCREPANCY
+ stage.DISCREP_DESC
+ stage.DISPOSITION_ACTION
+ stage.USER_DISPOSED_BY
+ stage.NEW_JOB
+ stage.NEW_SUFFIX
+ stage.CNC_ACTION
+ stage.NO_GOOD_RPT
+ stage.INSPECTED_BY
+ stage.USER1
+ stage.USER2

+ CAST(dwstage.udf_cv_nvarchar6__yymmdd_to_date(stage.DATE_QUALITY) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar8_to_date(stage.DATE_ENTERED) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar6__yymmdd_to_date(stage.F_DATE) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar8_to_date(stage.CLOSE_DATE) AS NVARCHAR(20))

+ CAST(dwstage.udf_cv_nvarchar6__yymmdd_to_date(stage.DATE_DISPOSED) AS NVARCHAR(20))
+ CAST(stage.TIME_DISPOSED AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar6_to_date(stage.DATE_INSPECTED) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar6_to_date(stage.DATE_CNC_REQ) AS NVARCHAR(20))

+ CAST(stage.QTY_DISPOSED AS NVARCHAR(20))
+ CAST(stage.DISPOSED_VALUE AS NVARCHAR(20))
) AS VARBINARY (64))

-- SELECT COUNT(*)
FROM
dwstage._V_QualityDisp as stage

LEFT OUTER JOIN dw.DimWorkOrder dwo
ON stage.JOB = dwo.WorkOrderNumber
AND stage.Suffix = dwo.Suffix
AND dwstage.udf_cv_nvarchar6_to_date(stage.Date_Opened)  = dwo.DateOpened
AND dwo.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimInventory AS i
ON    stage.PART = i.PartID
AND  i.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimCustomer AS c
ON    stage.CUSTOMER = c.CustomerID
AND  c.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimEmployee AS e
ON	stage.Employee = e.EmployeeID
AND  e.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimDepartment AS de
ON	stage.EMPLOYEE_DEPT = de.DepartmentID		
AND  de.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimWorkCenter AS dw
ON	stage.WORKCENTER = dw.Machine		
AND  dw.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimDate AS d
ON	dwstage.udf_cv_nvarchar8_to_date(stage.DATE_ENTERED)  = d.[Date]			

LEFT OUTER JOIN dw.DimVendor AS dv
ON  CAST(stage.VENDOR AS nchar(6)) = dv.VENDOR
AND  dv.DWIsCurrent = 1

		

GO


