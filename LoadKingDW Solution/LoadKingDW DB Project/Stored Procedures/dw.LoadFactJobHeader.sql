--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE [dw].[sp_LoadFactJobHeader] @LoadLogKey INT  AS

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

	--BEGIN TRY DROP TABLE ##FactJobHeader_SOURCE		END TRY BEGIN CATCH END CATCH
	--BEGIN TRY DROP TABLE ##FactJobHeader_TARGET	END TRY BEGIN CATCH END CATCH

IF object_id('##FactJobHeader_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactJobHeader_SOURCE
	END

IF object_id('##FactJobHeader_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactJobHeader_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactJobHeader_SOURCE (

DimSalesOrder_Key int NOT NULL,
DimWorkOrderType_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimCustomer_Key int NOT NULL,
DimSalesPerson_Key int NOT NULL,
DimProductLine_Key int NOT NULL,
DimDate_Key int NOT NULL,
DimWorkOrder_Key int NOT NULL,

	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[PART] [char](20) NULL,
	[PRODUCT_LINE] [char](2) NULL,
	[ROUTER] [char](20) NULL,
	[PRIORITY] [char](3) NULL,
	[DESCRIPTION] [char](30) NULL,
	[CUSTOMER] [char](6) NULL,
	[CUSTOMER_PO] [char](20) NULL,
	[COMMENTS_1] [char](70) NULL,
	[BIN] [char](6) NULL,
	[FLAG_WO_RELEASED] [char](1) NULL,--OK
	[FLAG_WO_PRTD] [char](1) NULL,--OK
	[FLAG_HOLD] [char](1) NULL,--OK
	[PARENT_WO] [char](6) NULL,--OK
	[PARENT_SUFFIX_PARENT] [char](3) NULL,--OK
	[SALES_ORDER] [char](7) NULL,--OK
	[SALES_ORDER_LINE] [char](3) NULL,--OK
	[FLAG_SERIALIZE] [char](1) NULL,--OK
	[JOB_LOCKED] [char](1) NULL, --OK
----------------------------------------------
	[DATE_OPENED] [char](6) NULL,
	[DATE_DUE] [char](6) NULL,
	[DATE_CLOSED] [char](6) NULL,
	[DATE_START] [char](6) NULL,
	[DATE_SCH_CMPL_INF] [char](6) NULL,
	[DATE_SCH_CMPL_FIN] [char](6) NULL,
	[DATE_LAST_SCH_INF] [char](6) NULL,
	[DATE_ORIG_DUE] [char](6) NULL,
	[DATE_START_OTHER] [char](6) NULL,
	[DATE_SHIP_1] [char](6) NULL,
	[DATE_SHIP_2] [char](6) NULL,
	[DATE_SHIP_3] [char](6) NULL,
	[DATE_SHIP_4] [char](6) NULL,
	[DATE_LAST_SCH_FIN] [char](6) NULL,
	[DATE_DUE_NEW] [char](6) NULL,
	[CTR_DATE_REVUE_DUE] [numeric](2, 0) NULL,
	[CTR_DATE_DUE_NEW] [numeric](2, 0) NULL,
	[DATE_MATERIAL_DUE] [char](6) NULL,
	[CTR_DATE_MATL_DUE] [numeric](2, 0) NULL,
	[DATE_MATL_ORDER] [char](6) NULL,
	[DATE_RELEASED] [char](6) NULL,
	[SCHEDULED_DUE_DATE] [char](6) NULL,
----------------------------------------------------
	[QTY_ORDER] [numeric](12, 4) NULL,
	[QTY_COMPLETED] [numeric](12, 4) NULL,
	[AMT_PRICE_PER_UNIT] [numeric](12, 4) NULL,
	[AMT_SALES] [numeric](12, 4) NULL,
	[AMT_MATERIAL] [numeric](12, 4) NULL,
	[NUM_HOURS] [numeric](12, 4) NULL,
	[AMT_LABOR] [numeric](12, 4) NULL,
	[AMT_OVERHEAD] [numeric](12, 4) NULL,
	[AMT_PARTIAL_SHPMNT] [numeric](12, 4) NULL,
	[QTY_SHIP_1] [numeric](9, 2) NULL,
	[QTY_CUSTOMER] [numeric](12, 4) NULL,
	[PARTIAL_MATERIAL] [numeric](12, 4) NULL,
	[PARTIAL_LABOR] [numeric](12, 4) NULL,
	[PARTIAL_OVERHEAD] [numeric](12, 4) NULL,
	[PARTIAL_OUTSIDE] [numeric](12, 4) NULL,
	[OUTS] [numeric](12, 4) NULL,

		/*Hashes used for identifying changes, not required for reporting*/
		[Type1RecordHash]			VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash

		/*DW Metadata fields, not required for reporting*/
		--[SourceSystemName]			NVARCHAR(100)		NOT NULL,
		--[DWEffectiveStartDate]		DATETIME2(7)		NOT NULL,
		--[DWEffectiveEndDate]		DATETIME2(7)		NOT NULL,
		--[DWIsCurrent]				BIT					NOT NULL,

		/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
		--[LoadLogKey]				INT
	)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactJobHeader_SOURCE
			SELECT * from dwstage.V_LoadFactJobHeader

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactJobHeader_TARGET 
					(
					JOB CHAR(6)
					,SUFFIX CHAR(3)
					,PART CHAR(20)
					,CUSTOMER CHAR(6)
					, Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactJobHeader_TARGET
	SELECT	
			JOB
			,SUFFIX
			,PART
			,CUSTOMER
			, Type1RecordHash
	FROM	dw.FactJobHeader

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactJobHeader 
	SELECT	*
	FROM	##FactJobHeader_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactJobHeader AS TGT
						WHERE	
							TGT.JOB = SRC.JOB
							and TGT.SUFFIX = SRC.SUFFIX
							and TGT.PART = SRC.PART
							and TGT.CUSTOMER = SRC.CUSTOMER					
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
--, JOB			-- NK
--, SUFFIX		-- NK
--, PART		-- NK

, TGT.PRODUCT_LINE = SRC.PRODUCT_LINE
, TGT.ROUTER = SRC.ROUTER
, TGT.PRIORITY = SRC.PRIORITY
, TGT.DESCRIPTION = SRC.DESCRIPTION

--, CUSTOMER	-- NK

, TGT.CUSTOMER_PO = SRC.CUSTOMER_PO
, TGT.COMMENTS_1 = SRC.COMMENTS_1
, TGT.BIN = SRC.BIN
, TGT.FLAG_WO_RELEASED = SRC.FLAG_WO_RELEASED
, TGT.FLAG_WO_PRTD = SRC.FLAG_WO_PRTD
, TGT.FLAG_HOLD = SRC.FLAG_HOLD
, TGT.PARENT_WO = SRC.PARENT_WO
, TGT.PARENT_SUFFIX_PARENT = SRC.PARENT_SUFFIX_PARENT
, TGT.SALES_ORDER = SRC.SALES_ORDER
, TGT.SALES_ORDER_LINE = SRC.SALES_ORDER_LINE
, TGT.FLAG_SERIALIZE = SRC.FLAG_SERIALIZE
, TGT.JOB_LOCKED = SRC.JOB_LOCKED
----------------------------------
, TGT.DATE_OPENED = SRC.DATE_OPENED
, TGT.DATE_DUE = SRC.DATE_DUE
, TGT.DATE_CLOSED = SRC.DATE_CLOSED
, TGT.DATE_START = SRC.DATE_START
, TGT.DATE_SCH_CMPL_INF = SRC.DATE_SCH_CMPL_INF
, TGT.DATE_SCH_CMPL_FIN = SRC.DATE_SCH_CMPL_FIN
, TGT.DATE_LAST_SCH_INF = SRC.DATE_LAST_SCH_INF
, TGT.DATE_ORIG_DUE = SRC.DATE_ORIG_DUE
, TGT.DATE_START_OTHER = SRC.DATE_START_OTHER
, TGT.DATE_SHIP_1 = SRC.DATE_SHIP_1
, TGT.DATE_SHIP_2 = SRC.DATE_SHIP_2
, TGT.DATE_SHIP_3 = SRC.DATE_SHIP_3
, TGT.DATE_SHIP_4 = SRC.DATE_SHIP_4
, TGT.DATE_LAST_SCH_FIN = SRC.DATE_LAST_SCH_FIN
, TGT.DATE_DUE_NEW = SRC.DATE_DUE_NEW
, TGT.CTR_DATE_REVUE_DUE = SRC.CTR_DATE_REVUE_DUE
, TGT.CTR_DATE_DUE_NEW = SRC.CTR_DATE_DUE_NEW
, TGT.DATE_MATERIAL_DUE = SRC.DATE_MATERIAL_DUE
, TGT.CTR_DATE_MATL_DUE = SRC.CTR_DATE_MATL_DUE
, TGT.DATE_MATL_ORDER = SRC.DATE_MATL_ORDER
, TGT.DATE_RELEASED = SRC.DATE_RELEASED
--------------------------------
, TGT.SCHEDULED_DUE_DATE = SRC.SCHEDULED_DUE_DATE
, TGT.QTY_ORDER = SRC.QTY_ORDER
, TGT.QTY_COMPLETED = SRC.QTY_COMPLETED
, TGT.AMT_PRICE_PER_UNIT = SRC.AMT_PRICE_PER_UNIT
, TGT.AMT_SALES = SRC.AMT_SALES
, TGT.AMT_MATERIAL = SRC.AMT_MATERIAL
, TGT.NUM_HOURS = SRC.NUM_HOURS
, TGT.AMT_LABOR = SRC.AMT_LABOR
, TGT.AMT_OVERHEAD = SRC.AMT_OVERHEAD
, TGT.AMT_PARTIAL_SHPMNT = SRC.AMT_PARTIAL_SHPMNT
, TGT.QTY_SHIP_1 = SRC.QTY_SHIP_1
, TGT.QTY_CUSTOMER = SRC.QTY_CUSTOMER
, TGT.PARTIAL_MATERIAL = SRC.PARTIAL_MATERIAL
, TGT.PARTIAL_LABOR = SRC.PARTIAL_LABOR
, TGT.PARTIAL_OVERHEAD = SRC.PARTIAL_OVERHEAD
, TGT.PARTIAL_OUTSIDE = SRC.PARTIAL_OUTSIDE
, TGT.OUTS = SRC.OUTS

	FROM	dw.FactJobHeader		AS TGT
	 JOIN   ##FactJobHeader_SOURCE	AS SRC
			ON TGT.JOB = SRC.JOB
			and TGT.SUFFIX = SRC.SUFFIX
			and TGT.PART = SRC.PART
			and TGT.CUSTOMER = SRC.CUSTOMER					
	   --AND	Dim.DWIsCurrent = 1
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactJobHeader_SOURCE		
	 DROP TABLE ##FactJobHeader_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO




