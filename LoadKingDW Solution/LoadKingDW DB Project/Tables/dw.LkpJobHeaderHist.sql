﻿CREATE TABLE [dw].[LkpJobHeaderHist](
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
	[WO_RTR_RELEASED] [char](1) NULL,
	[FLAG_WO_PRTD] [char](1) NULL,
	[FLAG_HOLD] [char](1) NULL,
	[PARENT_WO] [char](6) NULL,
	[PARENT_SUFFIX_PARENT] [char](3) NULL,
	[SALES_ORDER] [char](7) NULL,
	[SALES_ORDER_LINE] [char](3) NULL,
	[FLAG_SERIALIZE] [char](1) NULL,
	[JOB_LOCKED] [char](1) NULL,
	[DATE_OPENED] [char](6) NULL,
	[DATE_DUE] [char](6) NULL,
	[DATE_CLOSED] [char](6) NULL,
	[DATE_START] [char](6) NULL,
	[DATE_SCH_CMPL_INF] [char](6) NULL,
	[DATE_SCH_CMPL_FIN] [char](6) NULL,
	[DATE_LAST_SCH_INF] [char](6) NULL,
	[DATE_DTE_DUE_REV] [char](6) NULL,
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
	[SCHED_DUE_DATE] [char](6) NULL,
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
	[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO


