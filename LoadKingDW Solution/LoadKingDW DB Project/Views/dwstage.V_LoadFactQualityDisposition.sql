--USE [LK-GS-EDW]
--GO

CREATE VIEW dwstage.V_LoadFactQualityDisposition
AS
SELECT
-1 as DimWorkOrder_Key -- ISNULL(wo.DimWorkOrder_Key, -1) as DimWorkOrder_Key
,ISNULL(c.DimCustomer_Key, -1) as DimCustomer_Key
,-1 as DimVendor_Key
,ISNULL(i.DimInventory_Key, -1) as DimInventory_Key
,ISNULL(e.DimEmployee_Key, -1) as DimEmployee_Key
,ISNULL(de.DimDepartment_Key, -1) as DimDepartmentEmployee_Key
,ISNULL(dw.DimDepartment_Key, -1) as DimDepartmentWorkCenter_Key
,ISNULL(d.DimDate_Key, -1) as DimDate_Key

,quality.CONTROL_NUMBER as Header_CONTROL_NUMBER
,quality.[JOB] as Header_JOB
,quality.[SUFFIX] as Header_SUFFIX
,quality.[SEQUENCE] as Header_SEQUENCE

,qd.CONTROL_NUMBER
,qd.DISPOSITION_SEQ
,qd.DISCREPANCY
,qdc.DISCREP_DESC
,qd.DISPOSITION_ACTION
,qd.USER_DISPOSED_BY
,qd.NEW_JOB
,qd.NEW_SUFFIX
,qd.CNC_ACTION
,qd.NO_GOOD_RPT
,qd.INSPECTED_BY
,qd.USER1
,qd.USER2

-- DATES--------------------------------
,dwstage.udf_cv_nvarchar6_to_date(quality.DATE_QUALITY) as Header_DATE_QUALITY
,dwstage.udf_cv_nvarchar8_to_date(quality.DATE_ENTERED) as Header_DATE_ENTERED
,dwstage.udf_cv_nvarchar6_to_date(qa.F_DATE) as Header_F_DATE
,dwstage.udf_cv_nvarchar8_to_date(qa.CLOSE_DATE) as Header_CLOSE_DATE

,dwstage.udf_cv_nvarchar8_to_date(qd.DATE_DISPOSED) as DATE_DISPOSED
,qd.TIME_DISPOSED
,dwstage.udf_cv_nvarchar6_to_date(qd.DATE_INSPECTED) as DATE_INSPECTED
,dwstage.udf_cv_nvarchar6_to_date(qd.DATE_CNC_REQ) as DATE_CNC_REQ

-- MEASURES------------------------------
,qd.QTY_DISPOSED
,qd.DISPOSED_VALUE

, [Type1RecordHash]	 = CAST(HASHBYTES('SHA2_256',
+ quality.CONTROL_NUMBER
+ quality.[JOB]
+ quality.[SUFFIX]
+ quality.[SEQUENCE]

+ qd.CONTROL_NUMBER
+ qd.DISPOSITION_SEQ
+ qd.DISCREPANCY
+ qdc.DISCREP_DESC
+ qd.DISPOSITION_ACTION
+ qd.USER_DISPOSED_BY
+ qd.NEW_JOB
+ qd.NEW_SUFFIX
+ qd.CNC_ACTION
+ qd.NO_GOOD_RPT
+ qd.INSPECTED_BY
+ qd.USER1
+ qd.USER2

+ CAST(dwstage.udf_cv_nvarchar6_to_date(quality.DATE_QUALITY) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar8_to_date(quality.DATE_ENTERED) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar6_to_date(qa.F_DATE) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar8_to_date(qa.CLOSE_DATE) AS NVARCHAR(20))

+ CAST(dwstage.udf_cv_nvarchar8_to_date(qd.DATE_DISPOSED) AS NVARCHAR(20))
+ CAST(qd.TIME_DISPOSED AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar6_to_date(qd.DATE_INSPECTED) AS NVARCHAR(20))
+ CAST(dwstage.udf_cv_nvarchar6_to_date(qd.DATE_CNC_REQ) AS NVARCHAR(20))

+ CAST(qd.QTY_DISPOSED AS NVARCHAR(20))
+ CAST(qd.DISPOSED_VALUE AS NVARCHAR(20))
) AS VARBINARY (64))

-- SELECT COUNT(*)
FROM
dwstage.QUALITY_DISP qd 
LEFT JOIN dwstage.quality -- Header Level Info
on qd.CONTROL_NUMBER = quality.CONTROL_NUMBER

LEFT JOIN dwstage.QUALITY_ADDL qa
ON quality.CONTROL_NUMBER = qa.CONTROL_NUM

LEFT JOIN (SELECT [SYS], DISCREP_CODE, DISCREP_DESC FROM dwstage.QUALITY_DISCRP_CD WHERE [SYS] = 'QUA' GROUP BY [SYS], DISCREP_CODE, DISCREP_DESC) qdc
ON qd.DISCREPANCY = qdc.DISCREP_CODE

LEFT OUTER JOIN dw.DimInventory AS i
ON    quality.PART = i.PartID
AND  i.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimCustomer AS c
ON    quality.CUSTOMER = c.CustomerID
AND  c.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimEmployee AS e
ON	quality.Employee = e.EmployeeID
AND  e.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimDepartment AS de
ON	quality.EMPLOYEE_DEPT = de.DepartmentID		
AND  de.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimDepartment AS dw
ON	quality.WORKCENTER = de.DepartmentID		
AND  dw.DWIsCurrent = 1

-- Join to table APSV3_JBMASTER producting 808 dups where Job has a BOM Parent = 1 
LEFT JOIN (select max(JOB) as JOB, 1 as BOMPARENT from dwstage.APSV3_JBMASTER where BOMPARENT = 1 group by JOB, BOMPARENT) m
ON quality.JOB = m.JOB
and m.BOMPARENT = 1

LEFT OUTER JOIN dw.DimDate AS d
ON	dwstage.udf_cv_nvarchar8_to_date(quality.DATE_ENTERED)  = d.[Date]			


		
GO


