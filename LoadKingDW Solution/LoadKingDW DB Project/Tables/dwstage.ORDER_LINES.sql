﻿CREATE TABLE [dwstage].[ORDER_LINES](
	[ORDER_NO] [char](7) NULL,
	[RECORD_NO] [char](4) NULL,
	[ORDER_SHIP_ID] [char](6) NULL,
	[RECORD_TYPE] [char](1) NULL,
	[CUSTOMER] [char](6) NULL,
	[SHIP_ID] [char](6) NULL,
	[INVOICE] [char](6) NULL,
	[LINE_TYPE] [char](1) NULL,
	[QTY_ORDERED] [numeric](13, 4) NULL,
	[QTY_SHIPPED] [numeric](13, 4) NULL,
	[QTY_BO] [numeric](13, 4) NULL,
	[WEIGHT] [numeric](10, 3) NULL,
	[UM_ORDER] [char](2) NULL,
	[PART] [char](20) NULL,
	[ORDER_WON] [char](1) NULL,
	[PRICE] [numeric](16, 6) NULL,
	[COST] [numeric](16, 6) NULL,
	[UM_INVENTORY] [char](2) NULL,
	[DATE_SHIP] [date] NULL,
	[CODE_SORT] [char](12) NULL,
	[FLAG_SO_TO_WO] [char](1) NULL,
	[DESCRIPTION] [char](30) NULL,
	[USER_1] [char](30) NULL,
	[USER_2] [char](30) NULL,
	[USER_3] [char](30) NULL,
	[USER_4] [char](30) NULL,
	[USER_5] [char](30) NULL,
	[FLAG_BILLING_PRICE] [char](1) NULL,
	[LOCATION] [char](2) NULL,
	[PRICE_LB] [numeric](16, 6) NULL,
	[GOT_IT_PRICE] [numeric](16, 6) NULL,
	[PRICE_CODE] [char](2) NULL,
	[FLAG_REQ_CREATED] [char](1) NULL,
	[DISCOUNT] [numeric](5, 4) NULL,
	[FLAG_USE_MQD] [char](1) NULL,
	[PRICE_CLASS_DISC] [numeric](5, 4) NULL,
	[COMMISSION_TYPE] [char](5) NULL,
	[GL_ACCOUNT] [char](15) NULL,
	[TAX_SOURCE] [char](1) NULL,
	[TAX_STATE] [char](2) NULL,
	[TAX_ZIP] [char](13) NULL,
	[TAX_GEO_CODE] [char](2) NULL,
	[TAX_1] [char](3) NULL,
	[TAX_2] [char](3) NULL,
	[TAX_3] [char](3) NULL,
	[TAX_4] [char](3) NULL,
	[TAX_5] [char](3) NULL,
	[TAX_6] [char](3) NULL,
	[TAX_7] [char](3) NULL,
	[TAX_8] [char](3) NULL,
	[TAX_9] [char](3) NULL,
	[TAX_10] [char](3) NULL,
	[TAX_APPLY_1] [char](1) NULL,
	[TAX_APPLY_2] [char](1) NULL,
	[TAX_APPLY_3] [char](1) NULL,
	[TAX_APPLY_4] [char](1) NULL,
	[TAX_APPLY_5] [char](1) NULL,
	[TAX_APPLY_6] [char](1) NULL,
	[TAX_APPLY_7] [char](1) NULL,
	[TAX_APPLY_8] [char](1) NULL,
	[TAX_APPLY_9] [char](1) NULL,
	[TAX_APPLY_10] [char](1) NULL,
	[ORIG_ORDER_LINE] [char](4) NULL,
	[SO_LINE] [varchar](3) NULL,
	[QTY_ORIGINAL] [numeric](13, 4) NULL,
	[FLAG_REWORK] [char](1) NULL,
	[BIN] [char](6) NULL,
	[GROUP_LINES] [char](10) NULL,
	[EQUIPMENT_NO] [char](10) NULL,
	[DATE_ORDER] [date] NULL,
	[DATE_ITEM_PROM] [date] NULL,
	[ITEM_PROMISE_DT] [date] NULL,
	[FLAG_COGS] [char](1) NULL,
	[FLAG_TAX_STATUS] [char](1) NULL,
	[PART_ORIGINAL] [char](20) NULL,
	[CUSTOMER_PART] [char](20) NULL,
	[FLAG_RMA] [char](1) NULL,
	[INFO_1] [char](20) NULL,
	[INFO_2] [char](20) NULL,
	[FLAG_PURCHASED] [char](1) NULL,
	[CNSGN_QTY_IVC] [numeric](13, 4) NULL,
	[BLANKET_NO] [char](7) NULL,
	[BLANKET_LINE] [char](4) NULL,
	[ORDER_CURR_CD] [char](3) NULL,
	[TRNSFR_LOCN] [char](2) NULL,
	[TRANSIT_NO] [numeric](7, 0) NULL,
	[ADD_BY_DATE] [date] NULL,
	[ADD_BY_TIME] [time](0) NULL,
	[STAGED] [numeric](1, 0) NULL,
	[MXD_CRTNS] [bit] NULL,
	[MXD_PLLTS] [bit] NULL,
	[NON_INV] [bit] NULL,
	[QTY_UNPACKED] [numeric](13, 4) NULL,
	[PKGD_BY] [char](1) NULL,
	[PALLET_FLAG] [bit] NULL,
	[INACTIVE] [bit] NULL,
	[XTNL_ORD_DISC_FLG] [bit] NULL,
	[SURVEY_FLG] [char](1) NULL,
	[PRICE_CATG] [char](2) NULL,
	[QTY_ORDERED_INV] [numeric](13, 4) NULL,
	[QTY_SHIPPED_INV] [numeric](13, 4) NULL,
	[QTY_BO_INV] [numeric](13, 4) NULL,
	[EXTENSION] [numeric](16, 2) NULL,
	[MARGIN] [numeric](7, 4) NULL,
	[FLAG_BOM] [char](1) NULL,
	[BOM_PARENT] [char](4) NULL,
	[PRODUCT_LINE] [char](2) NULL,
	[PROD_LINE_DISC] [numeric](5, 4) NULL,
	[REPEAT_FREQUENCY] [char](1) NULL,
	[REPEAT_BILL_DAY] [char](2) NULL,
	[DATE_LAST_INVOICE] [date] NULL,
	[FREIGHT_PER_PIECE] [numeric](11, 6) NULL,
	[AMT_DISCOUNT] [numeric](12, 2) NULL,
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[PRICE_EFF_DATE] [date] NULL,
	[LIKELY_TO_WIN] [char](1) NULL,
	[DISCOUNT_PRICE] [numeric](16, 6) NULL,
	[ORDER_DISC_AMT] [numeric](12, 2) NULL,
	[PRCCLS_DISC_AMT] [numeric](12, 2) NULL,
	[PRDLN_DISC_AMT] [numeric](12, 2) NULL,
	[FLAG_DETAIL_BILL] [char](1) NULL,
	[FLAG_TEXTILE] [char](1) NULL,
	[FRT_PER_PIECE_ORD] [numeric](11, 6) NULL,
	[PRICE_ORDER] [numeric](16, 6) NULL,
	[PRICE_DISC_ORD] [numeric](16, 6) NULL,
	[PRICE_LB_ORDER] [numeric](16, 6) NULL,
	[EXTENSION_ORDER] [numeric](16, 2) NULL,
	[AMT_DISC_ORDER] [numeric](12, 2) NULL,
	[AMT_DISC_ORD_ORDER] [numeric](12, 2) NULL,
	[AMT_DISC_PR_CL_ORD] [numeric](12, 2) NULL,
	[AMT_DISC_PROD_LN_ORD] [numeric](12, 2) NULL,
	[CURR_FLG] [char](1) NULL,
	[PART_PRICE_CODE] [char](3) NULL,
	[PICK_LIST_PRINTED] [char](1) NULL,
	[FRT_FROM_ORDER_FLG] [char](1) NULL,
	[ADD_BY_PGM] [char](8) NULL,
	[LOTBIN_FLG] [char](1) NULL,
	[APPLY_MATL_SCHRG] [char](1) NULL,
	[MATL_SCHRG_FLG] [char](1) NULL,
	[PRICE_BOM_COMP_FLG] [char](1) NULL,
	[SHIP_CHRG_FLAG] [char](1) NULL,
	[NO_DLVR_BEFORE_DATE] [date] NULL,
	[MUST_DLVR_BY_DATE] [date] NULL,
	[CARTONS] [numeric](8, 0) NULL,
	[PKGD_WEIGHT] [numeric](12, 4) NULL,
	[SCRIPT_FLG] [char](1) NULL,
	[MATL_SCHRG_DATE] [date] NULL,
	[QTE_CALC_COST] [numeric](16, 6) NULL,
	[PHASE] [char](4) NULL,
	[LFIFO_FLG] [char](1) NULL,
	[MANUAL_TAX_FLG] [bit] NULL,
	[CRTN_CD] [char](11) NULL,
	[QTY_PER_CRTN] [numeric](13, 4) NULL,
	[PLLT_CD] [char](11) NULL,
	[QTY_PER_PLLT] [numeric](13, 4) NULL,
	[GROSS_PER_CRTN] [numeric](12, 4) NULL,
	[GROSS_PER_PLLT] [numeric](12, 4) NULL,
	[PALLETS] [numeric](8, 0) NULL,
	[QTY_ALLOC] [numeric](13, 4) NULL,
	[TAX_ORGN_ADR] [numeric](2, 0) NULL,
	[TAX_ZONE_1] [char](2) NULL,
	[TAX_ZONE_2] [char](2) NULL,
	[TAX_ZONE_3] [char](2) NULL,
	[TAX_ZONE_4] [char](2) NULL,
	[TAX_ZONE_5] [char](2) NULL,
	[TAX_ZONE_6] [char](2) NULL,
	[TAX_ZONE_7] [char](2) NULL,
	[TAX_ZONE_8] [char](2) NULL,
	[TAX_ZONE_9] [char](2) NULL,
	[TAX_ZONE_10] [char](2) NULL,
	[TAX_INDX_FLG] [char](1) NULL,
	[TAX_ASGN_SRC] [numeric](6, 0) NULL,
	[SIGN_OPT] [numeric](3, 0) NULL,
	[VAT_RULE_ID] [numeric](3, 0) NULL,
	[VAT_EXEMPT_TYPE] [numeric](3, 0) NULL,
	[TAX_IN_PRC_FLG] [bit] NULL,
	[TAX_IMPORT_FLG] [numeric](3, 0) NULL,
	[ORIG_PCK_NO] [numeric](7, 0) NULL,
	[CNV_SHIP_DATE] [date] NULL,
	[PCK_NO] [numeric](7, 0) NULL,
	[SHP_STAT] [char](1) NULL,
	[IVC_BATCH] [char](5) NULL,
	[NO_OVER_SHP_QTY] [bit] NULL,
	[CONTRACT] [char](6) NULL,
	[FLAG_DATA_CNV] [char](1) NULL,
	[FLAG_ALWAYS_DISCOUNT] [char](1) NULL,
	[DATE_LAST_CHG] [date] NULL,
	[TIME_LAST_CHG] [time](0) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[LAST_CHG_PGM] [char](8) NULL,
	[ETL_TblNbr] [varchar](3) NOT NULL,
	[ETL_Batch] [varchar](2) NOT NULL,
	[ETL_Completed] [varchar](19) NOT NULL
)