﻿CREATE VIEW [dwstage].[V_LoadLkpJobOperationsHist]
AS
SELECT 


[HEADER_JOB]
,[HEADER_SUFFIX]
,[HEADER_PART]
,[HEADER_PRODUCT_LINE]
,[HEADER_SALESPERSON]
,[HEADER_CUSTOMER]
,HEADER_SALES_ORDER
,HEADER_SALES_ORDER_LINE

,stage.[JOB]
,stage.[SUFFIX]
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
,[MACHINE_HOURS]
,[TIME_ELAPSED]
,[FACTOR_WORKCENTER]
,[SEQ_PO]
,[PO_ASSIGNED]
,[MAIN_COMMENT]
,[WORK_STARTED]
,[HOLD_PO]

----------------------------------
,dwstage.udf_cv_nvarchar6_to_date(HEADER_DATE_OPENED)		[HEADER_DATE_OPENED]
,dwstage.udf_cv_nvarchar6_to_date(HEADER_DATE_DUE)			[HEADER_DATE_DUE]
,dwstage.udf_cv_nvarchar6_to_date(HEADER_DATE_CLOSED)		[HEADER_DATE_CLOSED]
,dwstage.udf_cv_nvarchar6_to_date(HEADER_DATE_START)		[HEADER_DATE_START]

,dwstage.udf_cv_nvarchar6_to_date(DATE_START)				[DATE_START]
,dwstage.udf_cv_nvarchar6_to_date(DATE_DUE)					[DATE_DUE]
,dwstage.udf_cv_nvarchar6_to_date(DATE_MATERIAL_DUE)		[DATE_MATERIAL_DUE]
,dwstage.udf_cv_nvarchar6_to_date(DATE_COMPLETED)			[DATE_COMPLETED]
,dwstage.udf_cv_nvarchar6_to_date(DATE_HARD)				[DATE_HARD]
,dwstage.udf_cv_nvarchar6_to_date(DATE_OPER_ST_MDY)			[DATE_OPER_ST_MDY]
,dwstage.udf_cv_nvarchar6_to_date(DATE_PO_ORDER)			[DATE_PO_ORDER]
,[DATE_OPER_SK_YEAR]
,dwstage.udf_cv_nvarchar6_to_date(DATE_OPER_SK_MDY)			[DATE_OPER_SK_MDY]
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
+ stage.[SUFFIX]
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
+ [MACHINE_HOURS]
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
	dwstage._V_JobOperations_Hist Stage

-- insert into dwstage._V_JobOperations select * from [lk-gs-ods].dbo._V_JobOperations where etl_batch <> 0

	
GO
