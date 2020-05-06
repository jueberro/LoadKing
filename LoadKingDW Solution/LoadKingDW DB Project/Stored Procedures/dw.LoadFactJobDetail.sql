--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE dw.sp_LoadFactJobDetail @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

	/*
	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table
	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

IF object_id('##FactJobDetail_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactJobDetail_SOURCE
	END

IF object_id('##FactJobDetail_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactJobDetail_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactJobDetail_SOURCE (

DimSalesOrder_Key int NOT NULL,
DimWorkOrderType_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimCustomer_Key int NOT NULL,
DimSalesPerson_Key int NOT NULL,
DimProductLine_Key int NOT NULL,
DimDate_Key int NOT NULL,
DimEmployee_Key int NOT NULL,
DimDepartmentWorkCenter_Key int NOT NULL,
DimReference_Key int NOT NULL,
DimShiftShift_Key int NOT NULL,
DimShiftDepartment_Key int NOT NULL,
DimShiftGroup_Key int NOT NULL,

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

[JOB] [char](6) NULL,
[SUFFIX] [char](3) NULL,
[SEQ] [char](6) NULL,
[SEQUENCE_KEY] [char](4) NULL,
[EMPLOYEE] [char](30) NULL,
[DESCRIPTION] [char](30) NULL,
[DEPT_WORKCENTER] [char](4) NULL,
[RATE_WORKCENTER] [numeric](10, 4) NULL,
[DEPT_EMP] [char](4) NULL,
[MACHINE] [char](4) NULL,
[PART] [char](20) NULL,
[REFERENCE] [char](15) NULL,
[LMO] [char](1) NULL,
[RATE_TYPE] [char](1) NULL,
[LOCATION] [char](2) NULL,
[SHIFT_SHIFT] [char](1) NULL,
[SHIFT_DEPT] [char](4) NULL,
[SHIFT_GROUP] [char](8) NULL,

--HEADER DATES --------------------------------------------
[HEADER_DATE_OPENED] [char](6) NULL,
[HEADER_DATE_DUE] [char](6) NULL,
[HEADER_DATE_CLOSED] [char](6) NULL,
[HEADER_DATE_START] [char](6) NULL,

-- DETAIL DATES ----------------------------------------------------
[DATE_SEQUENCE] [char](6) NULL,
[CHARGE_DATE] [char](8) NULL,
[DATE_OUT] [char](6) NULL,
[DATE_LAST_CHG] [char](8) NULL,

-- DETAIL MEASURES ------------------------------------------------------
[RATE_EMPLOYEE] [numeric](10, 4) NULL,
[HOURS_WORKED] [numeric](12, 4) NULL,
[PIECES_SCRAP] [numeric](12, 4) NULL,
[PIECES_COMPLTD] [numeric](12, 4) NULL,
[AMOUNT_LABOR] [numeric](10, 2) NULL,
[AMT_OVERHEAD] [numeric](10, 2) NULL,
[AMT_STANDARD] [numeric](10, 2) NULL,
[AMT_SCRAP] [numeric](10, 2) NULL,
[MACHINE_HRS] [numeric](12, 4) NULL,
[MULTIPLE_FRACTION] [numeric](6, 5) NULL,
[START_TIME] [char](4) NULL,
[END_TIME] [char](4) NULL,

/*Hashes used for identifying changes, not required for reporting*/
[Type1RecordHash]			VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactJobDetail_SOURCE
			SELECT * from dwstage.V_LoadFactJobDetail

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactJobDetail_TARGET 
					(
					JOB CHAR(6)
					,SUFFIX CHAR(3)
					,SEQ CHAR(6)
					,SEQUENCE_KEY CHAR(4)
					,PART CHAR(20)
					,HEADER_CUSTOMER CHAR(6)
					, Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactJobDetail_TARGET
	SELECT	
			JOB
			,SUFFIX
			,SEQ
			,SEQUENCE_KEY
			,PART
			,HEADER_CUSTOMER
			, Type1RecordHash
	FROM	dw.FactJobDetail

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactJobDetail 
	SELECT	*
	FROM	##FactJobDetail_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactJobDetail AS TGT
						WHERE	
							TGT.JOB = SRC.JOB
							and TGT.SUFFIX = SRC.SUFFIX
							and TGT.SEQ = SRC.SEQ
							and TGT.SEQUENCE_KEY = SRC.SEQUENCE_KEY
							and TGT.PART = SRC.PART
							and TGT.HEADER_CUSTOMER = SRC.HEADER_CUSTOMER					
						)

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
,TGT.DimEmployee_Key = SRC.DimEmployee_Key
,TGT.DimDepartmentWorkCenter_Key = SRC.DimDepartmentWorkCenter_Key
,TGT.DimReference_Key = SRC.DimReference_Key
,TGT.DimShiftShift_Key = SRC.DimShiftShift_Key
,TGT.DimShiftDepartment_Key = SRC.DimShiftDepartment_Key
,TGT.DimShiftGroup_Key = SRC.DimShiftGroup_Key

-----------------------------------

, TGT.[HEADER_JOB] = SRC.[HEADER_JOB]
, TGT.[HEADER_SUFFIX] = SRC.[HEADER_SUFFIX]
, TGT.[HEADER_PART] = SRC.[HEADER_PART]
, TGT.[HEADER_PRODUCT_LINE] = SRC.[HEADER_PRODUCT_LINE]
, TGT.HEADER_SALESPERSON = SRC.HEADER_SALESPERSON
, TGT.[HEADER_SALES_ORDER] = SRC.[HEADER_SALES_ORDER]
, TGT.[HEADER_SALES_ORDER_LINE] = SRC.[HEADER_SALES_ORDER_LINE]
, TGT.[EMPLOYEE] = SRC.[EMPLOYEE]
, TGT.[DESCRIPTION] = SRC.[DESCRIPTION]
, TGT.[DEPT_WORKCENTER] = SRC.[DEPT_WORKCENTER]
, TGT.[RATE_WORKCENTER] = SRC.[RATE_WORKCENTER]
, TGT.[DEPT_EMP] = SRC.[DEPT_EMP]
, TGT.[MACHINE] = SRC.[MACHINE]
, TGT.[REFERENCE] = SRC.[REFERENCE]
, TGT.[LMO] = SRC.[LMO]
, TGT.[RATE_TYPE] = SRC.[RATE_TYPE]
, TGT.[LOCATION] = SRC.[LOCATION]
, TGT.[SHIFT_SHIFT] = SRC.[SHIFT_SHIFT]
, TGT.[SHIFT_DEPT] = SRC.[SHIFT_DEPT]
, TGT.[SHIFT_GROUP] = SRC.[SHIFT_GROUP]

----------------------------------
, TGT.[HEADER_DATE_OPENED] = SRC.[HEADER_DATE_OPENED]
, TGT.[HEADER_DATE_DUE] = SRC.[HEADER_DATE_DUE]
, TGT.[HEADER_DATE_CLOSED] = SRC.[HEADER_DATE_CLOSED]
, TGT.[HEADER_DATE_START] = SRC.[HEADER_DATE_START]
, TGT.[DATE_SEQUENCE] = SRC.[DATE_SEQUENCE]
, TGT.[CHARGE_DATE] = SRC.[CHARGE_DATE]
, TGT.[DATE_OUT] = SRC.[DATE_OUT]
, TGT.[DATE_LAST_CHG] = SRC.[DATE_LAST_CHG]

--------------------------------
, TGT.[RATE_EMPLOYEE] = SRC.[RATE_EMPLOYEE]
, TGT.[HOURS_WORKED] = SRC.[HOURS_WORKED]
, TGT.[PIECES_SCRAP] = SRC.[PIECES_SCRAP]
, TGT.[PIECES_COMPLTD] = SRC.[PIECES_COMPLTD]
, TGT.[AMOUNT_LABOR] = SRC.[AMOUNT_LABOR]
, TGT.[AMT_OVERHEAD] = SRC.[AMT_OVERHEAD]
, TGT.[AMT_STANDARD] = SRC.[AMT_STANDARD]
, TGT.[AMT_SCRAP] = SRC.[AMT_SCRAP]
, TGT.[MACHINE_HRS] = SRC.[MACHINE_HRS]
, TGT.[MULTIPLE_FRACTION] = SRC.[MULTIPLE_FRACTION]
, TGT.[START_TIME] = SRC.[START_TIME]
, TGT.[END_TIME] = SRC.[END_TIME]

	FROM	dw.FactJobDetail		AS TGT
	 JOIN   ##FactJobDetail_SOURCE	AS SRC
			ON TGT.JOB = SRC.JOB
			and TGT.SUFFIX = SRC.SUFFIX
			and TGT.SEQ = SRC.SEQ
			and TGT.SEQUENCE_KEY = SRC.SEQUENCE_KEY
			and TGT.PART = SRC.PART
			and TGT.HEADER_CUSTOMER = SRC.HEADER_CUSTOMER					
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash
	
	--DROP temp tables

	 DROP TABLE ##FactJobDetail_SOURCE		
	 DROP TABLE ##FactJobDetail_TARGET	
	 
END
GO

