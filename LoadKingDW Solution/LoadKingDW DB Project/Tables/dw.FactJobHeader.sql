USE [LK-GS-EDW]
GO


CREATE TABLE dw.FactJobHeader
(
DimSalesOrder_Key int NOT NULL,
DimWorkOrderType_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimCustomer_Key int NOT NULL,
DimSalesPerson_Key int NOT NULL,
DimProductLine_Key int NOT NULL,
DimDate_Key int NOT NULL,
-- DEGENERATE ATTRIBUTES ----------------------------------------------
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
-- LIKELY NOT CRITICAL --------------------------------------------------
	--[FILLER1] [char](1) NULL,
	--[LOCATION] [char](2) NULL,
	--[SALESPERSON_OLD] [char](2) NULL,
	--[COMMENTS_2] [char](70) NULL,
	--[COMMENTS_3] [char](70) NULL,
	--[FLAG_PURGE] [char](1) NULL,
	--[PART_CUSTOMER] [char](20) NULL,
	--[DRAWING_CUSTOMER] [char](20) NULL,
	--[CODE_SORT] [char](20) NULL,
	--[CODE_SORT_OTHER] [char](20) NULL,
	--[USER_SCHEDULE] [char](1) NULL,
	--[SALESPERSON] [char](3) NULL,
	--[SCH_GRP] [char](9) NULL,
	--[FILLER3] [char](1) NULL,
	--[PART_DESCRIPTION] [char](30) NULL,
	--[PROJECT] [char](7) NULL,
	--[DUE_OFFSET] [numeric](2, 0) NULL,
	--[SCHEDULE_DIR] [char](1) NULL,
	--[CREATE_FROM_QUALITY] [char](1) NULL,
	--[TRAV_REV] [char](2) NULL,
	--[SPECIAL_START_SEQ] [char](6) NULL,
	--[SPECIAL_STOP_SEQ] [char](6) NULL,
	--[PMAINT_FLAG] [char](1) NULL,
	--[SHIPTO_ID] [char](6) NULL,
	--[LOT_TO_LOT] [char](1) NULL,
	--[EXPORTED] [char](1) NULL,
	--[PHASE] [char](4) NULL,
	--[JOB_TYPE] [char](1) NULL,
	--[PRE_RELEASE] [char](1) NULL,
	--[PROCESS_GRP] [char](1) NULL,
	--[SHIPD_FLG] [char](1) NULL,--OK
	--[FILLER4] [char](6) NULL,
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
	[OUTS] [numeric](12, 4) NULL
--MOSTLY BLANK ---------------------------------------------------
	--[HOUR_START] [numeric](5, 3) NULL,
	--[SYSTEM_PRIORITY] [numeric](3, 0) NULL,
	--[FREIGHT] [numeric](12, 4) NULL,
	--[PARTIAL_FREIGHT] [numeric](12, 4) NULL,
	--[QTY_SHIP_2] [numeric](9, 2) NULL,
	--[QTY_SHIP_3] [numeric](9, 2) NULL,
	--[QTY_SHIP_4] [numeric](9, 2) NULL,
	--[OTHER] [numeric](12, 4) NULL,
	--[PARTIAL_OTHER] [numeric](12, 4) NULL,
) ON [PRIMARY]
GO

-- select top 10000 * from [LK-GS-ODS].dbo.JOB_HEADER
