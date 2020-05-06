--USE [LK-GS-EDW]
--GO


CREATE VIEW dwstage.V_LoadFactJobDetail
AS
SELECT 
ISNULL(so.DimSalesOrder_Key, -1) as DimSalesOrder_Key
,ISNULL(wo.DimWorkOrderType_Key, -1) as DimWorkOrderType_Key
,ISNULL(i.DimInventory_Key, -1) as DimInventory_Key
,ISNULL(c.DimCustomer_Key, -1) as DimCustomer_Key
,ISNULL(sp.DimSalesperson_Key, -1) as DimSalesPerson_Key
,ISNULL(pl.DimProductLine_Key, -1) as DimProductLine_Key
,ISNULL(do.DimDate_Key, -1) as DimDate_Key

,-1 as DimEmployee_Key -- ISNULL(e.DimEmployee_Key, -1) as DimEmployee_Key
,-1 as DimDepartmentWorkCenter_Key --ISNULL(do.DimDepartmentWorkCenter_Key, -1) as DimDepartmentWorkCenter_Key
,-1 as DimReference_Key --ISNULL(do.DimReference_Key, -1) as DimReference_Key
,-1 as DimShiftShift_Key --ISNULL(do.DimShiftShift_Key, -1) as DimShiftShift_Key
,-1 as DimShiftDepartment_Key --ISNULL(do.DimShiftDepartment_Key, -1) as DimShiftDepartment_Key
,-1 as DimShiftGroup_Key --ISNULL(do.DimShiftGroup_Key, -1) as DimShiftGroup_Key

,[HEADER_JOB]
,[HEADER_SUFFIX]
,[HEADER_PART]
,[HEADER_PRODUCT_LINE]
,[HEADER_SALESPERSON]
,[HEADER_CUSTOMER]
,HEADER_SALES_ORDER
,HEADER_SALES_ORDER_LINE

,stage.[JOB]
,[SUFFIX]
,[SEQ] 
,[SEQUENCE_KEY]
,[EMPLOYEE] 
,stage.[DESCRIPTION]
,[DEPT_WORKCENTER]
,[RATE_WORKCENTER]--
,[DEPT_EMP]
,[MACHINE]
,stage.[PART] 
,[REFERENCE]
,[LMO] 
,[RATE_TYPE]
,[LOCATION]
,[SHIFT_SHIFT] 
,[SHIFT_DEPT]
,[SHIFT_GROUP]

----------------------------------
,[HEADER_DATE_OPENED]
,[HEADER_DATE_DUE]
,[HEADER_DATE_CLOSED]
,[HEADER_DATE_START]
,[DATE_SEQUENCE]
,[CHARGE_DATE]
,[DATE_OUT]
,[DATE_LAST_CHG] 

--------------------------------
,[RATE_EMPLOYEE]
,[HOURS_WORKED]
,[PIECES_SCRAP]
,[PIECES_COMPLTD]
,[AMOUNT_LABOR] 
,[AMT_OVERHEAD]
,[AMT_STANDARD]
,[AMT_SCRAP]
,[MACHINE_HRS]
,[MULTIPLE_FRACTION]
,[START_TIME]
,[END_TIME]

, [Type1RecordHash]	 = HASHBYTES('SHA2_256',

+ [HEADER_JOB]
+ [HEADER_SUFFIX]
+ [HEADER_PART]
+ [HEADER_PRODUCT_LINE]
+ [HEADER_SALESPERSON]
+ [HEADER_CUSTOMER]
+ HEADER_SALES_ORDER
+ HEADER_SALES_ORDER_LINE
																	
+ stage.[JOB]
+ [SUFFIX]
+ [SEQ] 
+ [SEQUENCE_KEY]
+ [EMPLOYEE] 
+ stage.[DESCRIPTION]
+ [DEPT_WORKCENTER]
+ CAST([RATE_WORKCENTER] AS NVARCHAR(12))
+ [DEPT_EMP]
+ [MACHINE]
+ stage.[PART] 
+ [REFERENCE]
+ [LMO] 
+ [RATE_TYPE]
+ [LOCATION]
+ [SHIFT_SHIFT] 
+ [SHIFT_DEPT]
+ [SHIFT_GROUP]

+ CAST([HEADER_DATE_OPENED] AS NVARCHAR(20))
+ CAST([HEADER_DATE_DUE] AS NVARCHAR(20))
+ CAST([HEADER_DATE_CLOSED] AS NVARCHAR(20))
+ CAST([HEADER_DATE_START] AS NVARCHAR(20))
+ CAST([DATE_SEQUENCE] AS NVARCHAR(20))
+ CAST([CHARGE_DATE] AS NVARCHAR(20))
+ CAST([DATE_OUT] AS NVARCHAR(20))
+ CAST([DATE_LAST_CHG] AS NVARCHAR(20))

+ CAST([RATE_EMPLOYEE] AS NVARCHAR(20))
+ CAST([HOURS_WORKED] AS NVARCHAR(20))
+ CAST([PIECES_SCRAP] AS NVARCHAR(20))
+ CAST([PIECES_COMPLTD] AS NVARCHAR(20))
+ CAST([AMOUNT_LABOR] AS NVARCHAR(20))
+ CAST([AMT_OVERHEAD] AS NVARCHAR(20))
+ CAST([AMT_STANDARD] AS NVARCHAR(20))
+ CAST([AMT_SCRAP] AS NVARCHAR(20))
+ CAST([MACHINE_HRS] AS NVARCHAR(20))
+ CAST([MULTIPLE_FRACTION] AS NVARCHAR(20))
+ CAST([START_TIME] AS NVARCHAR(20))
+ CAST([END_TIME] AS NVARCHAR(20))														
)
-- Insert into dwstage._v_job select * from [lk-gs-ods].dbo._v_job
-- SELECT COUNT(*)
FROM 
	dwstage._V_JOB Stage

LEFT OUTER JOIN (select SalesOrderNumber, min(DimSalesOrder_Key) DimSalesOrder_Key, min(SalesOrderLine) SalesOrderLine, 1 as DWIsCurrent from dw.DimSalesOrder group by SalesOrderNumber)  AS so
ON	Stage.HEADER_SALES_ORDER = so.SalesOrderNumber AND	so.DWIsCurrent = 1 

-- select top 1000 * from [LK-GS-ODS].dbo.ORDER_HEADER order by Order_No, order_suffix


LEFT OUTER JOIN dw.DimInventory AS i
ON    Stage.PART = i.PartID
AND  i.DWIsCurrent = 1

-- ******* REMOVE THIS subquery once DimCustomer is reloaded *******************************

LEFT OUTER JOIN (select min(CustomerID) CustomerID, min(DimCustomer_Key) DimCustomer_Key, 1 as DWIsCurrent from dw.DimCustomer group by CustomerID)  AS c
ON    Stage.HEADER_CUSTOMER = c.CustomerID
AND  c.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimSalesPerson AS sp
ON	Stage.HEADER_SALESPERSON = sp.SalespersonID	
AND  sp.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimProductLine AS pl
ON	Stage.HEADER_PRODUCT_LINE = pl.ProductLine		
AND  pl.DWIsCurrent = 1

-- Insert into dwstage.APSV3_JBMASTER select * from [lk-gs-ods].dbo.APSV3_JBMASTER
LEFT JOIN dwstage.APSV3_JBMASTER m
ON stage.JOB = m.JOB
and m.BOMPARENT = 1

LEFT OUTER JOIN dw.DimWorkOrderType AS wo
ON	
(CASE WHEN substring(so.SalesOrderNumber, 4,4) = substring(stage.job, 1, 4) THEN 'Sales Order'
WHEN m.BOMPARENT = 1 THEN 'BOM'
ELSE 'Other'
END) = wo.WorkOrderType		
AND  wo.DWIsCurrent = 1
AND	so.DWIsCurrent = 1 

LEFT OUTER JOIN dw.DimDate AS do
ON	dwstage.udf_cv_nvarchar6_to_date(Stage.HEADER_DATE_OPENED)  = do.[Date]			

LEFT OUTER JOIN dw.DimEmployee AS e
ON	Stage.EMPLOYEE = e.EmployeeID	
AND  sp.DWIsCurrent = 1

		
GO


