--USE [LK-GS-EDW]
--GO

CREATE VIEW dwstage.V_LoadFactJobOperations
AS
SELECT 
ISNULL(so.DimSalesOrder_Key, -1) as DimSalesOrder_Key
,ISNULL(wo.DimWorkOrderType_Key, -1) as DimWorkOrderType_Key
,ISNULL(i.DimInventory_Key, -1) as DimInventory_Key
,ISNULL(c.DimCustomer_Key, -1) as DimCustomer_Key
,ISNULL(sp.DimSalesperson_Key, -1) as DimSalesPerson_Key
,ISNULL(pl.DimProductLine_Key, -1) as DimProductLine_Key
,ISNULL(do.DimDate_Key, -1) as DimDate_Key

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

,[PROJ_GROUP]
,[OPERATION]
,[LMO]
,stage.[DESCRIPTION]
,stage.[UM]
,stage.[PART]
,[ROUTER]
,[ROUTER_SEQ]
,[FLAG_CLOSED]
,[TIME_START]
,[MACHINE_HRS]
,[TIME_ELAPSED]
,[FACTOR_WORKCENTER]
,[SEQ_PO]
,[PO_ASSIGNED]
,[MAIN_COMMENT]
,[WORK_STARTED]
,[HOLD_PO]

----------------------------------
,[HEADER_DATE_OPENED]
,[HEADER_DATE_DUE]
,[HEADER_DATE_CLOSED]
,[HEADER_DATE_START]

,[DATE_START]
,[DATE_DUE]
,[DATE_MATERIAL_DUE]
,[DATE_COMPLETED]
,[DATE_HARD]
,[DATE_OPER_ST_MDY]
,[DATE_PO_ORDER]
,[DATE_OPER_SK_YEAR]
,[DATE_OPER_SK_MDY]
,[DATE_OPER_ST_YEAR]

--------------------------------
,[UNITS_OPEN]
,[UNITS_COMPLETE]
,[SETUP]
,[UNITS]
,[BURDEN]
,[HOURS_ESTIMATED]
,[HOURS_ACTUAL]
,[DOLLARS_ESTIMATED]
,[DOLLARS_ACTUAL]
,[YIELD]
,[YIELD_RATIO]
,[CREW_SIZE]
,[UNIT_D6] 
,[LEAD_TIME] 

, [Type1RecordHash]	 = CAST(HASHBYTES('SHA2_256',
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

+ [PROJ_GROUP]
+ [OPERATION]
+ [LMO]
+ stage.[DESCRIPTION]
+ stage.[UM]
+ stage.[PART]
+ [ROUTER]
+ [ROUTER_SEQ]
+ [FLAG_CLOSED]
+ [TIME_START]
+ [MACHINE_HRS]
+ [TIME_ELAPSED]
+ [FACTOR_WORKCENTER]
+ [SEQ_PO]
+ [PO_ASSIGNED]
+ [MAIN_COMMENT]
+ [WORK_STARTED]
+ [HOLD_PO]

+ CAST([HEADER_DATE_OPENED] AS NVARCHAR(20))
+ CAST([HEADER_DATE_DUE] AS NVARCHAR(20))
+ CAST([HEADER_DATE_CLOSED] AS NVARCHAR(20))
+ CAST([HEADER_DATE_START] AS NVARCHAR(20))
+ CAST([DATE_START] AS NVARCHAR(20))
+ CAST([DATE_DUE] AS NVARCHAR(20))
+ CAST([DATE_MATERIAL_DUE] AS NVARCHAR(20))
+ CAST([DATE_COMPLETED] AS NVARCHAR(20))
+ CAST([DATE_HARD] AS NVARCHAR(20))
+ CAST([DATE_OPER_ST_MDY] AS NVARCHAR(20))
+ CAST([DATE_PO_ORDER] AS NVARCHAR(20))
+ CAST([DATE_OPER_SK_YEAR] AS NVARCHAR(20))
+ CAST([DATE_OPER_SK_MDY] AS NVARCHAR(20))
+ CAST([DATE_OPER_ST_YEAR] AS NVARCHAR(20))

+ CAST([UNITS_OPEN] AS NVARCHAR(20))
+ CAST([UNITS_COMPLETE] AS NVARCHAR(20))
+ CAST([SETUP] AS NVARCHAR(20))
+ CAST([UNITS] AS NVARCHAR(20))
+ CAST([BURDEN] AS NVARCHAR(20))
+ CAST([HOURS_ESTIMATED] AS NVARCHAR(20))
+ CAST([HOURS_ACTUAL] AS NVARCHAR(20))
+ CAST([DOLLARS_ESTIMATED] AS NVARCHAR(20))
+ CAST([DOLLARS_ACTUAL] AS NVARCHAR(20))
+ CAST([YIELD] AS NVARCHAR(20))
+ CAST([YIELD_RATIO] AS NVARCHAR(20))
+ CAST([CREW_SIZE] AS NVARCHAR(20))
+ CAST([UNIT_D6] AS NVARCHAR(20))
+ CAST([LEAD_TIME] AS NVARCHAR(20))
) AS VARBINARY (64))

-- Insert into dwstage._v_job select * from [lk-gs-ods].dbo._v_job
-- SELECT COUNT(*)
FROM 
	dwstage._V_JobOperations Stage

-- insert into dwstage._V_JobOperations select * from [lk-gs-ods].dbo._V_JobOperations where etl_batch <> 0

LEFT OUTER JOIN (select SalesOrderNumber, min(DimSalesOrder_Key) DimSalesOrder_Key, min(SalesOrderLine) SalesOrderLine, 1 as DWIsCurrent from dw.DimSalesOrder group by SalesOrderNumber)  AS so
ON	Stage.HEADER_SALES_ORDER = so.SalesOrderNumber AND	so.DWIsCurrent = 1 

LEFT OUTER JOIN dw.DimInventory AS i
ON    Stage.PART = i.PartID
AND  i.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimCustomer AS c
-- ******* REMOVE THIS subquery once DimCustomer is reloaded *******************************
--(select min(CustomerID) CustomerID, min(DimCustomer_Key) DimCustomer_Key, 1 as DWIsCurrent from dw.DimCustomer group by CustomerID)  AS c
ON    Stage.HEADER_CUSTOMER = c.CustomerID
AND  c.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimSalesPerson AS sp
ON	Stage.HEADER_SALESPERSON = sp.SalespersonID	
AND  sp.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimProductLine AS pl
ON	Stage.HEADER_PRODUCT_LINE = pl.ProductLine		
AND  pl.DWIsCurrent = 1

-- Join to table APSV3_JBMASTER producting 808 dups where Job has a BOM Parent = 1 
LEFT JOIN (select max(JOB) as JOB, 1 as BOMPARENT from dwstage.APSV3_JBMASTER where BOMPARENT = 1 group by JOB, BOMPARENT) m
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


		
GO


