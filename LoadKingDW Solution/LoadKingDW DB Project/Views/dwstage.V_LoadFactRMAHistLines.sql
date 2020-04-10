CREATE VIEW [dwstage].[V_LoadFactRMAHistLines]
AS
SELECT        TOP (100) PERCENT rh.REC_TYPE AS HeaderRecType, rl.REC_TYPE AS LineRecType, CAST(rh.RMA_ID AS nchar(7)) AS RMAID, CAST(rh.RMA_LINE AS nchar(6)) AS RMALine, CAST(rh.CUSTOMER AS nchar(6)) 
                         AS RMACustomer, CAST(rh.ORDER_NO AS nchar(7)) AS RMASalesOrde, CAST(rh.ORDER_SUFFIX AS nchar(4)) AS RMASalesOrderSuffix, CAST(rl.ORDER_LINE AS nchar(4)) AS RMASalesOrderLine, 
                         dwstage.udf_cv_nvarchar8_to_date(rl.DATE_RECEIVED) AS RMADateReceived, CAST(rl.PART AS varchar(50)) AS RMAPart, CAST(rl.PART_DESCRIPTION AS varchar(30)) AS RMAPartDescription, 
                         CAST(rl.LOCATION AS nchar(2)) AS RMAPartLocation, CAST(rl.CUSTOMER_PART AS nchar(20)) AS RMACustomerPart, CAST(rl.SERVICE_REQUESTED AS nchar(3)) AS RMAServiceRequested, 
                         CAST(rl.QTY_PERF_SCHED AS decimal(13, 4)) AS RMAQtyPerfSchedule, CAST(rl.QTY_PERF_COMPLETE AS decimal(13, 4)) AS RMAQtyPerfComplete, CAST(rl.QTY_SHIPPED AS decimal(13, 4)) AS RMAQtyShipped, 
                         CAST(rl.QTY_RECEIVED AS decimal(13, 4)) AS RMAQtyReceived, CAST(rl.QTY_RETURNED AS decimal(13, 4)) AS RMAQtyReturned, 
                         CASE WHEN rh.ETL_Batch > rl.ETL_Batch THEN rh.ETL_Batch ELSE rl.ETL_Batch END AS RMAETL_Batch, 
                         CASE WHEN rh.ETL_Batch > rl.ETL_Batch THEN rh.ETL_Completed ELSE rl.ETL_Completed END AS RMAETL_Completed
FROM            dwstage.RMA_HEADER AS rh LEFT OUTER JOIN
                         dwstage.RMA_LINES AS rl ON rh.RMA_ID = rl.RMA_ID AND rh.RMA_LINE = rl.RMA_LINE
WHERE        (rh.REC_TYPE = 'L') AND (rl.REC_TYPE = 'L')
ORDER BY RMASalesOrde, RMASalesOrderLine
