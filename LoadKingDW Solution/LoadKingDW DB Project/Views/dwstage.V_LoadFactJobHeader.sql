--USE [LK-GS-EDW]
--GO


CREATE VIEW [dwstage].[V_LoadFactJobHeader]
AS
SELECT 
ISNULL(so.DimSalesOrder_Key, -1) as DimSalesOrder_Key
,ISNULL(wo.DimWorkOrderType_Key, -1) as DimWorkOrderType_Key
,ISNULL(i.DimInventory_Key, -1) as DimInventory_Key
,ISNULL(c.DimCustomer_Key, -1) as DimCustomer_Key
,ISNULL(sp.DimSalesperson_Key, -1) as DimSalesPerson_Key
,ISNULL(pl.DimProductLine_Key, -1) as DimProductLine_Key
,ISNULL(do.DimDate_Key, -1) as DimDate_Key
,ISNULL(dwo.DimWorkOrder_Key, -1) as DimWorkOrder_Key

, stage.JOB                              
, stage.SUFFIX							 
, stage.PART							 
, PRODUCT_LINE							 
, ROUTER								 
, stage.[PRIORITY]						 
, stage.[DESCRIPTION]					 
, CUSTOMER								 
, CUSTOMER_PO							 
, COMMENTS_1							 
, BIN									 
, FLAG_WO_RELEASED						 
, FLAG_WO_PRTD							 
, FLAG_HOLD								 
, PARENT_WO								 
, PARENT_SUFFIX_PARENT					 
, SALES_ORDER							 
, SALES_ORDER_LINE						 
, FLAG_SERIALIZE						 
, JOB_LOCKED							 
----------------------------------		 
, DATE_OPENED							 
, DATE_DUE								 
, DATE_CLOSED							 
, DATE_START							 
, DATE_SCH_CMPL_INF						 
, DATE_SCH_CMPL_FIN						 
, DATE_LAST_SCH_INF						 
, DATE_ORIG_DUE							 
, DATE_START_OTHER						 
, DATE_SHIP_1							 
, DATE_SHIP_2							 
, DATE_SHIP_3							 
, DATE_SHIP_4							 
, DATE_LAST_SCH_FIN						 
, DATE_DUE_NEW							 
, CTR_DATE_REVUE_DUE					 
, CTR_DATE_DUE_NEW						 
, DATE_MATERIAL_DUE						 
, CTR_DATE_MATL_DUE						 
, DATE_MATL_ORDER						 
, DATE_RELEASED							 
--------------------------------		 
, SCHEDULED_DUE_DATE					 
, QTY_ORDER								 
, QTY_COMPLETED							 
, AMT_PRICE_PER_UNIT					 
, AMT_SALES								 
, AMT_MATERIAL							 
, NUM_HOURS								 
, AMT_LABOR								 
, AMT_OVERHEAD							 
, AMT_PARTIAL_SHPMNT					 
, QTY_SHIP_1							 
, QTY_CUSTOMER							 
, PARTIAL_MATERIAL						 
, PARTIAL_LABOR							 
, PARTIAL_OVERHEAD						 
, PARTIAL_OUTSIDE						 
, OUTS									 

--, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
, [Type1RecordHash]			  = HASHBYTES('SHA2_256',
																	
+ stage.JOB
+ stage.SUFFIX
+ stage.PART
+ PRODUCT_LINE
+ ROUTER
+ stage.[PRIORITY]
+ stage.[DESCRIPTION]
+ CUSTOMER
+ CUSTOMER_PO
+ COMMENTS_1
+ BIN
+ FLAG_WO_RELEASED
+ FLAG_WO_PRTD
+ FLAG_HOLD
+ PARENT_WO
+ PARENT_SUFFIX_PARENT
+ SALES_ORDER
+ SALES_ORDER_LINE
+ FLAG_SERIALIZE
+ JOB_LOCKED


+ CAST(DATE_OPENED AS NVARCHAR(20))
+ CAST(DATE_DUE AS NVARCHAR(20))
+ CAST(DATE_CLOSED AS NVARCHAR(20))
+ CAST(DATE_START AS NVARCHAR(20))
+ CAST(DATE_SCH_CMPL_INF AS NVARCHAR(20))
+ CAST(DATE_SCH_CMPL_FIN AS NVARCHAR(20))
+ CAST(DATE_LAST_SCH_INF AS NVARCHAR(20))
+ CAST(DATE_ORIG_DUE AS NVARCHAR(20))
+ CAST(DATE_START_OTHER AS NVARCHAR(20))
+ CAST(DATE_SHIP_1 AS NVARCHAR(20))
+ CAST(DATE_SHIP_2 AS NVARCHAR(20))
+ CAST(DATE_SHIP_3 AS NVARCHAR(20))
+ CAST(DATE_SHIP_4 AS NVARCHAR(20))
+ CAST(DATE_LAST_SCH_FIN AS NVARCHAR(20))
+ CAST(DATE_DUE_NEW AS NVARCHAR(20))
+ CAST(CTR_DATE_REVUE_DUE AS NVARCHAR(20))
+ CAST(CTR_DATE_DUE_NEW AS NVARCHAR(20))
+ CAST(DATE_MATERIAL_DUE AS NVARCHAR(20))
+ CAST(CTR_DATE_MATL_DUE AS NVARCHAR(20))
+ CAST(DATE_MATL_ORDER AS NVARCHAR(20))
+ CAST(DATE_RELEASED AS NVARCHAR(20))


+ CAST(SCHEDULED_DUE_DATE AS NVARCHAR(20))
+ CAST(QTY_ORDER AS NVARCHAR(20))
+ CAST(QTY_COMPLETED AS NVARCHAR(20))
+ CAST(AMT_PRICE_PER_UNIT AS NVARCHAR(20))
+ CAST(AMT_SALES AS NVARCHAR(20))
+ CAST(AMT_MATERIAL AS NVARCHAR(20))
+ CAST(NUM_HOURS AS NVARCHAR(20))
+ CAST(AMT_LABOR AS NVARCHAR(20))
+ CAST(AMT_OVERHEAD AS NVARCHAR(20))
+ CAST(AMT_PARTIAL_SHPMNT AS NVARCHAR(20))
+ CAST(QTY_SHIP_1 AS NVARCHAR(20))
+ CAST(QTY_CUSTOMER AS NVARCHAR(20))
+ CAST(PARTIAL_MATERIAL AS NVARCHAR(20))
+ CAST(PARTIAL_LABOR AS NVARCHAR(20))
+ CAST(PARTIAL_OVERHEAD AS NVARCHAR(20))
+ CAST(PARTIAL_OUTSIDE AS NVARCHAR(20))
+ CAST(OUTS AS NVARCHAR(20))
															
)

	 --   , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		--, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		--, [DWEffectiveEndDate]		  = '2100-01-01'
		--, [DWIsCurrent]				  = CAST(1					  AS BIT)
		--, [LoadLogKey]				  = CAST(0                    AS INT)
-- SELECT COUNT(*)
FROM 
	--dwstage.JOB_HEADER Stage
	(Select * from dwstage._V_JOB_HEADER   
	 UNION ALL
	 Select * from dwstage._V_JOB_HEADER_HIST  )  as stage
	


LEFT OUTER JOIN (select SalesOrderNumber, min(DimSalesOrder_Key) DimSalesOrder_Key, min(SalesOrderLine) SalesOrderLine, 1 as DWIsCurrent from dw.DimSalesOrder group by SalesOrderNumber)  AS so
ON	Stage.SALES_ORDER = so.SalesOrderNumber AND	so.DWIsCurrent = 1 

-- select top 1000 * from [LK-GS-ODS].dbo.ORDER_HEADER order by Order_No, order_suffix


LEFT OUTER JOIN dw.DimInventory AS i
ON    Stage.PART = i.PartID
AND  i.DWIsCurrent = 1

-- ******* REMOVE THIS subquery once DimCustomer is reloaded *******************************

LEFT OUTER JOIN (select min(CustomerID) CustomerID, min(DimCustomer_Key) DimCustomer_Key, 1 as DWIsCurrent from dw.DimCustomer group by CustomerID)  AS c
ON    Stage.CUSTOMER = c.CustomerID
AND  c.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimSalesPerson AS sp
ON	Stage.SALESPERSON = sp.SalespersonID	
AND  sp.DWIsCurrent = 1

LEFT OUTER JOIN dw.DimProductLine AS pl
ON	Stage.PRODUCT_LINE = pl.ProductLine		
AND  pl.DWIsCurrent = 1

--LEFT JOIN dwstage.APSV3_JBMASTER m
--ON stage.JOB = m.JOB
--and m.BOMPARENT = 1

LEFT OUTER JOIN dw.DimWorkOrderType AS wo
ON	
(CASE WHEN substring(so.SalesOrderNumber, 4,4) = substring(stage.job, 1, 4) THEN 'Sales Order'
--WHEN m.BOMPARENT = 1 THEN 'BOM'
WHEN stage.JBMASTER_BOMPARENT = 1 THEN 'BOM'
ELSE 'Other'
END) = wo.WorkOrderType		
AND  wo.DWIsCurrent = 1
AND	so.DWIsCurrent = 1 

LEFT OUTER JOIN dw.DimDate AS do
ON	dwstage.udf_cv_nvarchar6_to_date(Stage.DATE_OPENED)  = do.[Date]

LEFT OUTER JOIN dw.DimWorkOrder dwo
ON stage.JOB = dwo.WorkOrderNumber
AND stage.Suffix = dwo.Suffix
AND dwstage.udf_cv_nvarchar6_to_date(stage.DATE_OPENED)  = dwo.DateOpened
AND dwo.DWIsCurrent = 1



