--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE dw.sp_LoadFactJobOperations @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

DECLARE @RowsInsertedCount int
DECLARE @RowsUpdatedCount int

	/*
	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table
	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

IF object_id('##FactJobOperations_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactJobOperations_SOURCE
	END

IF object_id('##FactJobOperations_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactJobOperations_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactJobOperations_SOURCE (

DimSalesOrder_Key int NOT NULL,
DimWorkOrderType_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimCustomer_Key int NOT NULL,
DimSalesPerson_Key int NOT NULL,
DimProductLine_Key int NOT NULL,
DimDate_Key int NOT NULL,
DimWorkOrder_Key int NOT NULL,
-- DEGENERATE HEADER ATTRIBUTES ----------------------------------------------
[HEADER_JOB] [char](6) NULL,
[HEADER_SUFFIX] [char](3) NULL,
[HEADER_PART] [char](20) NULL,
[HEADER_PRODUCT_LINE] [char](2) NULL,
HEADER_SALESPERSON char(3) NULL,
[HEADER_CUSTOMER] [char](6) NULL,
[HEADER_SALES_ORDER] [char](7) NULL,
[HEADER_SALES_ORDER_LINE] [char](3) NULL,
-- DEGENERATE DETAIL ATTRIBUTES ----------------------------------------------
[JOB] [varchar](50) NULL,
[SUFFIX] [varchar](50) NULL,
[SEQ] [varchar](50) NULL,
[PROJ_GROUP] [varchar](50) NULL,
[OPERATION] [varchar](50) NULL,
[LMO] [varchar](50) NULL,
[DESCRIPTION] [varchar](50) NULL,
[UM] [varchar](50) NULL,
[PART] [varchar](50) NULL,
[ROUTER] [varchar](50) NULL,
[ROUTER_SEQ] [varchar](50) NULL,
[FLAG_CLOSED] [varchar](50) NULL,
[TIME_START] [varchar](50) NULL,
[MACHINE_HRS] [varchar](50) NULL,
[TIME_ELAPSED] [varchar](50) NULL,
[FACTOR_WORKCENTER] [varchar](50) NULL,
[SEQ_PO] [varchar](50) NULL,
[PO_ASSIGNED] [varchar](50) NULL,
[MAIN_COMMENT] [varchar](50) NULL,
[WORK_STARTED] [varchar](50) NULL,
[HOLD_PO] [varchar](50) NULL,
--HEADER DATES --------------------------------------------
[HEADER_DATE_OPENED] [char](6) NULL,
[HEADER_DATE_DUE] [char](6) NULL,
[HEADER_DATE_CLOSED] [char](6) NULL,
[HEADER_DATE_START] [char](6) NULL,
-- OPERATIONS DATES ----------------------------------------------------
[DATE_START] [varchar](50) NULL,
[DATE_DUE] [varchar](50) NULL,
[DATE_MATERIAL_DUE] [varchar](50) NULL,
[DATE_COMPLETED] [varchar](50) NULL,
[DATE_HARD] [varchar](50) NULL,
[DATE_OPER_ST_MDY] [varchar](50) NULL,
[DATE_PO_ORDER] [varchar](50) NULL,
[DATE_OPER_SK_YEAR] [varchar](50) NULL,
[DATE_OPER_SK_MDY] [varchar](50) NULL,
[DATE_OPER_ST_YEAR] [varchar](50) NULL,
-- OPERATIONS MEASURES ------------------------------------------------------
[UNITS_OPEN] [varchar](50) NULL,
[UNITS_COMPLETE] [varchar](50) NULL,
[SETUP] [varchar](50) NULL,
[UNITS] [varchar](50) NULL,
[BURDEN] [varchar](50) NULL,
[HOURS_ESTIMATED] [varchar](50) NULL,
[HOURS_ACTUAL] [varchar](50) NULL,
[DOLLARS_ESTIMATED] [varchar](50) NULL,
[DOLLARS_ACTUAL] [varchar](50) NULL,
[YIELD] [varchar](50) NULL,
[YIELD_RATIO] [varchar](50) NULL,
[CREW_SIZE] [varchar](50) NULL,
[UNIT_D6] [varchar](50) NULL,
[LEAD_TIME] [varchar](50) NULL,
/*Hashes used for identifying changes, not required for reporting*/
[Type1RecordHash]			VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactJobOperations_SOURCE
			SELECT * from dwstage.V_LoadFactJobOperations

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactJobOperations_TARGET 
					(
					JOB CHAR(6)
					,SUFFIX CHAR(3)
					,SEQ CHAR(6)
					,PART CHAR(50)
					,HEADER_CUSTOMER CHAR(6)
					, Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactJobOperations_TARGET
	SELECT	
			JOB
			,SUFFIX
			,SEQ
			,PART
			,HEADER_CUSTOMER
			, Type1RecordHash
	FROM	dw.FactJobOperations

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactJobOperations 
	SELECT	*
	FROM	##FactJobOperations_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactJobOperations AS TGT
						WHERE	
							TGT.JOB = SRC.JOB
							and TGT.SUFFIX = SRC.SUFFIX
							and TGT.SEQ = SRC.SEQ
							and TGT.PART = SRC.PART
							and TGT.HEADER_CUSTOMER = SRC.HEADER_CUSTOMER					
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
	TGT.DimSalesOrder_Key = SRC.DimSalesOrder_Key
	,TGT.DimWorkOrderType_Key = SRC.DimWorkOrderType_Key
	,TGT.DimInventory_Key = SRC.DimInventory_Key
	,TGT.DimCustomer_Key = SRC.DimCustomer_Key
	,TGT.DimSalesperson_Key = SRC.DimSalesPerson_Key
	,TGT.DimProductLine_Key = SRC.DimProductLine_Key
	,TGT.DimDate_Key = SRC.DimDate_Key
	,TGT.DimWorkOrder_Key = SRC.DimWorkOrder_Key
	-----------------------------------
	, TGT.[HEADER_JOB] = SRC.[HEADER_JOB]
	, TGT.[HEADER_SUFFIX] = SRC.[HEADER_SUFFIX]
	, TGT.[HEADER_PART] = SRC.[HEADER_PART]
	, TGT.[HEADER_PRODUCT_LINE] = SRC.[HEADER_PRODUCT_LINE]
	, TGT.HEADER_SALESPERSON = SRC.HEADER_SALESPERSON
	, TGT.[HEADER_SALES_ORDER] = SRC.[HEADER_SALES_ORDER]
	, TGT.[HEADER_SALES_ORDER_LINE] = SRC.[HEADER_SALES_ORDER_LINE]
	, TGT.[PROJ_GROUP] = SRC.[PROJ_GROUP]
	, TGT.[OPERATION] = SRC.[OPERATION]
	, TGT.[LMO] = SRC.[LMO]
	, TGT.[DESCRIPTION] = SRC.[DESCRIPTION]
	, TGT.[UM] = SRC.[UM]
	, TGT.[PART] = SRC.[PART]
	, TGT.[ROUTER] = SRC.[ROUTER]
	, TGT.[ROUTER_SEQ] = SRC.[ROUTER_SEQ]
	, TGT.[FLAG_CLOSED] = SRC.[FLAG_CLOSED]
	, TGT.[TIME_START] = SRC.[TIME_START]
	, TGT.[MACHINE_HRS] = SRC.[MACHINE_HRS]
	, TGT.[TIME_ELAPSED] = SRC.[TIME_ELAPSED]
	, TGT.[FACTOR_WORKCENTER] = SRC.[FACTOR_WORKCENTER]
	, TGT.[SEQ_PO] = SRC.[SEQ_PO]
	, TGT.[PO_ASSIGNED] = SRC.[PO_ASSIGNED]
	, TGT.[MAIN_COMMENT] = SRC.[MAIN_COMMENT]
	, TGT.[WORK_STARTED] = SRC.[WORK_STARTED]
	, TGT.[HOLD_PO] = SRC.[HOLD_PO]
	----------------------------------
	, TGT.[HEADER_DATE_OPENED] = SRC.[HEADER_DATE_OPENED]
	, TGT.[HEADER_DATE_DUE] = SRC.[HEADER_DATE_DUE]
	, TGT.[HEADER_DATE_CLOSED] = SRC.[HEADER_DATE_CLOSED]
	, TGT.[HEADER_DATE_START] = SRC.[HEADER_DATE_START]
	, TGT.[DATE_START] = SRC.[DATE_START]
	, TGT.[DATE_DUE] = SRC.[DATE_DUE]
	, TGT.[DATE_MATERIAL_DUE] = SRC.[DATE_MATERIAL_DUE]
	, TGT.[DATE_COMPLETED] = SRC.[DATE_COMPLETED]
	, TGT.[DATE_HARD] = SRC.[DATE_HARD]
	, TGT.[DATE_OPER_ST_MDY] = SRC.[DATE_OPER_ST_MDY]
	, TGT.[DATE_PO_ORDER] = SRC.[DATE_PO_ORDER]
	, TGT.[DATE_OPER_SK_YEAR] = SRC.[DATE_OPER_SK_YEAR]
	, TGT.[DATE_OPER_SK_MDY] = SRC.[DATE_OPER_SK_MDY]
	, TGT.[DATE_OPER_ST_YEAR] = SRC.[DATE_OPER_ST_YEAR]
	--------------------------------
	, TGT.[UNITS_OPEN] = SRC.[UNITS_OPEN]
	, TGT.[UNITS_COMPLETE] = SRC.[UNITS_COMPLETE]
	, TGT.[SETUP] = SRC.[SETUP]
	, TGT.[UNITS] = SRC.[UNITS]
	, TGT.[BURDEN] = SRC.[BURDEN]
	, TGT.[HOURS_ESTIMATED] = SRC.[HOURS_ESTIMATED]
	, TGT.[HOURS_ACTUAL] = SRC.[HOURS_ACTUAL]
	, TGT.[DOLLARS_ESTIMATED] = SRC.[DOLLARS_ESTIMATED]
	, TGT.[DOLLARS_ACTUAL] = SRC.[DOLLARS_ACTUAL]
	, TGT.[YIELD] = SRC.[YIELD]
	, TGT.[YIELD_RATIO] = SRC.[YIELD_RATIO]
	, TGT.[CREW_SIZE] = SRC.[CREW_SIZE]
	, TGT.[UNIT_D6] = SRC.[UNIT_D6]
	, TGT.[LEAD_TIME] = SRC.[LEAD_TIME]
	, TGT.Type1RecordHash = SRC.Type1RecordHash
	FROM	dw.FactJobOperations		AS TGT
	 JOIN   ##FactJobOperations_SOURCE	AS SRC
			ON TGT.JOB = SRC.JOB
			and TGT.SUFFIX = SRC.SUFFIX
			and TGT.SEQ = SRC.SEQ
			and TGT.PART = SRC.PART
			and TGT.HEADER_CUSTOMER = SRC.HEADER_CUSTOMER					
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash
	
	--DROP temp tables

SET @RowsUpdatedCount = @@ROWCOUNT

	 DROP TABLE ##FactJobOperations_SOURCE		
	 DROP TABLE ##FactJobOperations_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO


