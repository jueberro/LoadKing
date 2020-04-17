﻿CREATE TABLE [dwstage].[ORDER](
	--ORDER_HEADER Fields
	[HEADER_ORDER_NO] [char](7) NULL,
	[HEADER_RECORD_NO] [char](4) NULL,
	[HEADER_ORDER_SHIP_ID] [char](6) NULL,
	[HEADER_RECORD_TYPE] [char](1) NULL,
	[HEADER_CUSTOMER] [char](6) NULL,
	[HEADER_SHIP_ID] [char](6) NULL,
	[HEADER_INVOICE] [char](6) NULL,
	[HEADER_DATE_ORDER] [date] NULL,
	[HEADER_DATE_DUE] [date] NULL,
	[HEADER_INSURANCE] [char](1) NULL,
	[HEADER_ORDER_TYPE] [char](1) NULL,
	[HEADER_ORDER_SUFFIX] [char](4) NULL,
	[HEADER_CUSTOMER_PO] [char](15) NULL,
	[HEADER_FILL_CUST_PO] [char](15) NULL,
	[HEADER_MARK_INFO] [char](30) NULL,
	[HEADER_CODE_FOB] [char](14) NULL,
	[HEADER_TERMS] [char](10) NULL,
	[HEADER_WAY_BILL] [char](19) NULL,
	[HEADER_LAST_REC_NO] [numeric](4, 0) NULL,
	[HEADER_DATE_SHIPPED] [date] NULL,
	[HEADER_FLAG_PRINT] [char](1) NULL,
	[HEADER_CODE_SORT] [char](20) NULL,
	[HEADER_FLAG_SHIPPED] [char](1) NULL,
	[HEADER_TRANS_METHOD] [char](10) NULL,
	[HEADER_CERT_ENCL] [char](1) NULL,
	[HEADER_EXPIRATION] [char](10) NULL,
	[HEADER_WHO_GOT_IT] [char](20) NULL,
	[HEADER_USER_1] [char](30) NULL,
	[HEADER_USER_2] [char](30) NULL,
	[HEADER_USER_3] [char](30) NULL,
	[HEADER_USER_4] [char](30) NULL,
	[HEADER_USER_5] [char](30) NULL,
	[HEADER_FLAG_NO_BACKORDER] [char](1) NULL,
	[HEADER_SALESPERSON] [char](3) NULL,
	[HEADER_BRANCH] [char](2) NULL,
	[HEADER_AREA] [char](2) NULL,
	[HEADER_FREIGHT_ZONE] [char](10) NULL,
	[HEADER_SHIP_VIA] [char](20) NULL,
	[HEADER_ORDER_DISCOUNT] [numeric](5, 4) NULL,
	[HEADER_PRICE_CLASS] [char](1) NULL,
	[HEADER_PRICE_CLASS_DISC] [numeric](5, 4) NULL,
	[HEADER_TYPE_COMMISSION] [char](5) NULL,
	[HEADER_GL_ACCOUNT] [char](15) NULL,
	[HEADER_TAX_SOURCE] [char](1) NULL,
	[HEADER_TAX_STATE] [char](2) NULL,
	[HEADER_TAX_ZIP] [char](13) NULL,
	[HEADER_TAX_GEO_CODE] [char](2) NULL,
	[HEADER_TAX_1] [char](3) NULL,
	[HEADER_TAX_2] [char](3) NULL,
	[HEADER_TAX_3] [char](3) NULL,
	[HEADER_TAX_4] [char](3) NULL,
	[HEADER_TAX_5] [char](3) NULL,
	[HEADER_TAX_6] [char](3) NULL,
	[HEADER_TAX_7] [char](3) NULL,
	[HEADER_TAX_8] [char](3) NULL,
	[HEADER_TAX_9] [char](3) NULL,
	[HEADER_TAX_10] [char](3) NULL,
	[HEADER_TAX_APPLY_1] [char](1) NULL,
	[HEADER_TAX_APPLY_2] [char](1) NULL,
	[HEADER_TAX_APPLY_3] [char](1) NULL,
	[HEADER_TAX_APPLY_4] [char](1) NULL,
	[HEADER_TAX_APPLY_5] [char](1) NULL,
	[HEADER_TAX_APPLY_6] [char](1) NULL,
	[HEADER_TAX_APPLY_7] [char](1) NULL,
	[HEADER_TAX_APPLY_8] [char](1) NULL,
	[HEADER_TAX_APPLY_9] [char](1) NULL,
	[HEADER_TAX_APPLY_10] [char](1) NULL,
	[HEADER_CONTRACT] [numeric](6, 0) NULL,
	[HEADER_ORDER_SORT_2] [char](30) NULL,
	[HEADER_QUOTE] [char](7) NULL,
	[HEADER_FLAG_TIME_MATL] [char](1) NULL,
	[HEADER_DATE_ORDER_CNV] [date] NULL,
	[HEADER_DATE_DUE_CNV] [date] NULL,
	[HEADER_FLAG_PICKLIST] [char](1) NULL,
	[HEADER_ORDER_LOCATION] [char](2) NULL,
	[HEADER_FLAG_IN_PROCESS] [char](1) NULL,
	[HEADER_DATE_PO_EXPIRE] [date] NULL,
	[HEADER_PRICE_SCHED_ID] [char](9) NULL,
	[HEADER_QUOTE_APPROVED_BY] [char](8) NULL,
	[HEADER_DATE_QUOTE_APPROVED] [date] NULL,
	[HEADER_FLAG_PL_TYPE] [char](1) NULL,
	[HEADER_FLAG_SPCD] [char](1) NULL,
	[HEADER_PRICE_CATEGORY] [char](2) NULL,
	[HEADER_COMPANY_CURRENCY] [char](3) NULL,
	[HEADER_CATALOG_CURRENCY] [char](3) NULL,
	[HEADER_ORDER_CURRENCY] [char](3) NULL,
	[HEADER_DATE_EXCH_FO_TC] [date] NULL,
	[HEADER_EXCH_RATE_FO_TC] [numeric](10, 5) NULL,
	[HEADER_DATE_EXCH_FC_TO] [date] NULL,
	[HEADER_EXCH_RATE_FC_TO] [numeric](10, 5) NULL,
	[HEADER_DATE_EXCH_FL_TO] [date] NULL,
	[HEADER_EXCH_RATE_FL_TO] [numeric](10, 5) NULL,
	[HEADER_DATE_EXCH_FL_TC] [date] NULL,
	[HEADER_EXCH_RATE_FL_TC] [numeric](10, 5) NULL,
	[HEADER_BUY_GRP_CUST_NO] [char](6) NULL,
	[HEADER_BUY_GRP_ADRS_FLG] [char](1) NULL,
	[HEADER_PAYMENT_TYPE] [char](2) NULL,
	[HEADER_ICV_RESPONSE] [char](1) NULL,
	[HEADER_ICV_STATUS] [char](1) NULL,
	[HEADER_PREPAID_INVOICE] [char](1) NULL,
	[HEADER_CC_FAIL_FLAG] [char](1) NULL,
	[HEADER_CMEMO_TYPE] [char](1) NULL,
	[HEADER_PAYMENT_REQUEST] [char](1) NULL,
	[HEADER_SPAWNED_SHPMT_FLAG] [char](1) NULL,
	[HEADER_ORIG_SHPMT_SEQ] [char](4) NULL,
	[HEADER_PRO_NO] [char](20) NULL,
	[HEADER_LUMP_SUM_FLAG] [char](1) NULL,
	[HEADER_LUMP_SUM_AMT] [numeric](15, 2) NULL,
	[HEADER_QTE_CREATED_BY] [char](8) NULL,
	[HEADER_QTE_CREATED_DATE] [date] NULL,
	[HEADER_LANG_CD] [char](3) NULL,
	[HEADER_PRGBILL_ONLY_FLAG] [char](1) NULL,
	[HEADER_SHP_HLD_FLAG] [char](2) NULL,
	[HEADER_BLANKET_NO] [char](7) NULL,
	[HEADER_TRACKING_NO] [char](30) NULL,
	[HEADER_TRACKING_FLAG] [char](1) NULL,
	[HEADER_ETA_DATE] [date] NULL,
	[HEADER_CARTONS] [numeric](8, 0) NULL,
	[HEADER_WEIGHT] [numeric](12, 4) NULL,
	[HEADER_COMPLETE_SHIP] [char](1) NULL,
	[HEADER_TRMS_DSC_DUE_DT] [date] NULL,
	[HEADER_TRMS_DSC_AMT] [numeric](10, 2) NULL,
	[HEADER_TRMS_DSC_CUR_AMT] [numeric](10, 2) NULL,
	[HEADER_LINE_TEXT_FLAG] [char](1) NULL,
	[HEADER_PREPAY_APPLY_FLAG] [char](1) NULL,
	[HEADER_IVC_ASSIGN_FLAG] [char](1) NULL,
	[HEADER_AUTO_FRT_FLAG] [char](1) NULL,
	[HEADER_QUOTE_WON_LOSS_DATE] [date] NULL,
	[HEADER_FACILITY] [char](3) NULL,
	[HEADER_FRT_REQRD_FLG] [bit] NULL,
	[HEADER_TRNSFR_BIN_OPT] [numeric](1, 0) NULL,
	[HEADER_TRNSFR_TO_BIN] [char](6) NULL,
	[HEADER_NO_DLVR_BEFORE_DATE] [date] NULL,
	[HEADER_MUST_DLVR_BY_DATE] [date] NULL,
	[HEADER_TRNSFR_LOCN] [char](2) NULL,
	[HEADER_INTRANSIT_AUTO] [numeric](1, 0) NULL,
	[HEADER_TRANSIT_NO] [numeric](7, 0) NULL,
	[HEADER_PALLETS] [numeric](8, 0) NULL,
	[HEADER_NET_WEIGHT] [numeric](12, 4) NULL,
	[HEADER_TAX_ORGN_ADR] [numeric](2, 0) NULL,
	[HEADER_TAX_ZONE_1] [char](2) NULL,
	[HEADER_TAX_ZONE_2] [char](2) NULL,
	[HEADER_TAX_ZONE_3] [char](2) NULL,
	[HEADER_TAX_ZONE_4] [char](2) NULL,
	[HEADER_TAX_ZONE_5] [char](2) NULL,
	[HEADER_TAX_ZONE_6] [char](2) NULL,
	[HEADER_TAX_ZONE_7] [char](2) NULL,
	[HEADER_TAX_ZONE_8] [char](2) NULL,
	[HEADER_TAX_ZONE_9] [char](2) NULL,
	[HEADER_TAX_ZONE_10] [char](2) NULL,
	[HEADER_PRE_QUOTE] [char](1) NULL,
	[HEADER_SCRIPT_FLG] [char](1) NULL,
	[HEADER_IVC_HLD_FLG] [numeric](6, 0) NULL,
	[HEADER_PROJECT] [char](7) NULL,
	[HEADER_CARRIER_ACCT] [char](25) NULL,
	[HEADER_PROCESS_GRP] [char](1) NULL,
	[HEADER_SHIP_ID_INT] [int] NULL,
	[HEADER_CONTRACT_FLG] [char](1) NULL,
	[HEADER_PRICE_CATG_FLG] [char](1) NULL,
	[HEADER_TAX_INDX_FLG] [char](1) NULL,
	[HEADER_NO_OVER_SHP_QTY] [bit] NULL,
	[HEADER_PRIMARY_GRP] [char](2) NULL,
	[HEADER_SECONDARY_GRP] [char](2) NULL,
	[HEADER_SRVC_TYPE] [smallint] NULL,
	[HEADER_VAT_RULE_ID] [numeric](3, 0) NULL,
	[HEADER_VAT_EXEMPT_TYPE] [numeric](3, 0) NULL,
	[HEADER_TAX_IN_PRC_FLG] [bit] NULL,
	[HEADER_TAX_IMPORT_FLG] [numeric](3, 0) NULL,
	[HEADER_ORIG_PCK_NO] [char](7) NULL,
	[HEADER_CNV_SHIP_DATE] [date] NULL,
	[HEADER_PCK_NO] [char](7) NULL,
	[HEADER_SHP_STATUS] [char](1) NULL,
	[HEADER_IVC_BATCH] [char](5) NULL,
	[HEADER_THRD_PRTY_FRT_CUST] [char](7) NULL,
	[HEADER_CARRIER_CD] [char](6) NULL,
	[HEADER_FLAG_DATA_CNV] [char](1) NULL,
	[HEADER_FLAG_ALWAYS_DISCOUNT] [char](1) NULL,
	[HEADER_DATE_LAST_CHG] [date] NULL,
	[HEADER_TIME_LAST_CHG] [time](0) NULL,
	[HEADER_LAST_CHG_BY] [char](8) NULL,
	[HEADER_LAST_CHG_PGM] [char](8) NULL,

	--ORDER_LINES Fields
	[LINE_ORDER_NO] [char](7) NULL,
	[LINE_RECORD_NO] [char](4) NULL,
	[LINE_ORDER_SHIP_ID] [char](6) NULL,
	[LINE_RECORD_TYPE] [char](1) NULL,
	[LINE_CUSTOMER] [char](6) NULL,
	[LINE_SHIP_ID] [char](6) NULL,
	[LINE_INVOICE] [char](6) NULL,
	[LINE_LINE_TYPE] [char](1) NULL,
	[LINE_QTY_ORDERED] [numeric](13, 4) NULL,
	[LINE_QTY_SHIPPED] [numeric](13, 4) NULL,
	[LINE_QTY_BO] [numeric](13, 4) NULL,
	[LINE_WEIGHT] [numeric](10, 3) NULL,
	[LINE_UM_ORDER] [char](2) NULL,
	[LINE_PART] [char](20) NULL,
	[LINE_ORDER_WON] [char](1) NULL,
	[LINE_PRICE] [numeric](16, 6) NULL,
	[LINE_COST] [numeric](16, 6) NULL,
	[LINE_UM_INVENTORY] [char](2) NULL,
	[LINE_DATE_SHIP] [date] NULL,
	[LINE_CODE_SORT] [char](12) NULL,
	[LINE_FLAG_SO_TO_WO] [char](1) NULL,
	[LINE_DESCRIPTION] [char](30) NULL,
	[LINE_USER_1] [char](30) NULL,
	[LINE_USER_2] [char](30) NULL,
	[LINE_USER_3] [char](30) NULL,
	[LINE_USER_4] [char](30) NULL,
	[LINE_USER_5] [char](30) NULL,
	[LINE_FLAG_BILLING_PRICE] [char](1) NULL,
	[LINE_LOCATION] [char](2) NULL,
	[LINE_PRICE_LB] [numeric](16, 6) NULL,
	[LINE_GOT_IT_PRICE] [numeric](16, 6) NULL,
	[LINE_PRICE_CODE] [char](2) NULL,
	[LINE_FLAG_REQ_CREATED] [char](1) NULL,
	[LINE_DISCOUNT] [numeric](5, 4) NULL,
	[LINE_FLAG_USE_MQD] [char](1) NULL,
	[LINE_PRICE_CLASS_DISC] [numeric](5, 4) NULL,
	[LINE_COMMISSION_TYPE] [char](5) NULL,
	[LINE_GL_ACCOUNT] [char](15) NULL,
	[LINE_TAX_SOURCE] [char](1) NULL,
	[LINE_TAX_STATE] [char](2) NULL,
	[LINE_TAX_ZIP] [char](13) NULL,
	[LINE_TAX_GEO_CODE] [char](2) NULL,
	[LINE_TAX_1] [char](3) NULL,
	[LINE_TAX_2] [char](3) NULL,
	[LINE_TAX_3] [char](3) NULL,
	[LINE_TAX_4] [char](3) NULL,
	[LINE_TAX_5] [char](3) NULL,
	[LINE_TAX_6] [char](3) NULL,
	[LINE_TAX_7] [char](3) NULL,
	[LINE_TAX_8] [char](3) NULL,
	[LINE_TAX_9] [char](3) NULL,
	[LINE_TAX_10] [char](3) NULL,
	[LINE_TAX_APPLY_1] [char](1) NULL,
	[LINE_TAX_APPLY_2] [char](1) NULL,
	[LINE_TAX_APPLY_3] [char](1) NULL,
	[LINE_TAX_APPLY_4] [char](1) NULL,
	[LINE_TAX_APPLY_5] [char](1) NULL,
	[LINE_TAX_APPLY_6] [char](1) NULL,
	[LINE_TAX_APPLY_7] [char](1) NULL,
	[LINE_TAX_APPLY_8] [char](1) NULL,
	[LINE_TAX_APPLY_9] [char](1) NULL,
	[LINE_TAX_APPLY_10] [char](1) NULL,
	[LINE_ORIG_ORDER_LINE] [char](4) NULL,
	[LINE_SO_LINE] [varchar](3) NULL,
	[LINE_QTY_ORIGINAL] [numeric](13, 4) NULL,
	[LINE_FLAG_REWORK] [char](1) NULL,
	[LINE_BIN] [char](6) NULL,
	[LINE_GROUP_LINES] [char](10) NULL,
	[LINE_EQUIPMENT_NO] [char](10) NULL,
	[LINE_DATE_ORDER] [date] NULL,
	[LINE_DATE_ITEM_PROM] [date] NULL,
	[LINE_ITEM_PROMISE_DT] [date] NULL,
	[LINE_FLAG_COGS] [char](1) NULL,
	[LINE_FLAG_TAX_STATUS] [char](1) NULL,
	[LINE_PART_ORIGINAL] [char](20) NULL,
	[LINE_CUSTOMER_PART] [char](20) NULL,
	[LINE_FLAG_RMA] [char](1) NULL,
	[LINE_INFO_1] [char](20) NULL,
	[LINE_INFO_2] [char](20) NULL,
	[LINE_FLAG_PURCHASED] [char](1) NULL,
	[LINE_CNSGN_QTY_IVC] [numeric](13, 4) NULL,
	[LINE_BLANKET_NO] [char](7) NULL,
	[LINE_BLANKET_LINE] [char](4) NULL,
	[LINE_ORDER_CURR_CD] [char](3) NULL,
	[LINE_TRNSFR_LOCN] [char](2) NULL,
	[LINE_TRANSIT_NO] [numeric](7, 0) NULL,
	[LINE_ADD_BY_DATE] [date] NULL,
	[LINE_ADD_BY_TIME] [time](0) NULL,
	[LINE_STAGED] [numeric](1, 0) NULL,
	[LINE_MXD_CRTNS] [bit] NULL,
	[LINE_MXD_PLLTS] [bit] NULL,
	[LINE_NON_INV] [bit] NULL,
	[LINE_QTY_UNPACKED] [numeric](13, 4) NULL,
	[LINE_PKGD_BY] [char](1) NULL,
	[LINE_PALLET_FLAG] [bit] NULL,
	[LINE_INACTIVE] [bit] NULL,
	[LINE_XTNL_ORD_DISC_FLG] [bit] NULL,
	[LINE_SURVEY_FLG] [char](1) NULL,
	[LINE_PRICE_CATG] [char](2) NULL,
	[LINE_QTY_ORDERED_INV] [numeric](13, 4) NULL,
	[LINE_QTY_SHIPPED_INV] [numeric](13, 4) NULL,
	[LINE_QTY_BO_INV] [numeric](13, 4) NULL,
	[LINE_EXTENSION] [numeric](16, 2) NULL,
	[LINE_MARGIN] [numeric](7, 4) NULL,
	[LINE_FLAG_BOM] [char](1) NULL,
	[LINE_BOM_PARENT] [char](4) NULL,
	[LINE_PRODUCT_LINE] [char](2) NULL,
	[LINE_PROD_LINE_DISC] [numeric](5, 4) NULL,
	[LINE_REPEAT_FREQUENCY] [char](1) NULL,
	[LINE_REPEAT_BILL_DAY] [char](2) NULL,
	[LINE_DATE_LAST_INVOICE] [date] NULL,
	[LINE_FREIGHT_PER_PIECE] [numeric](11, 6) NULL,
	[LINE_AMT_DISCOUNT] [numeric](12, 2) NULL,
	[LINE_JOB] [char](6) NULL,
	[LINE_SUFFIX] [char](3) NULL,
	[LINE_PRICE_EFF_DATE] [date] NULL,
	[LINE_LIKELY_TO_WIN] [char](1) NULL,
	[LINE_DISCOUNT_PRICE] [numeric](16, 6) NULL,
	[LINE_ORDER_DISC_AMT] [numeric](12, 2) NULL,
	[LINE_PRCCLS_DISC_AMT] [numeric](12, 2) NULL,
	[LINE_PRDLN_DISC_AMT] [numeric](12, 2) NULL,
	[LINE_FLAG_DETAIL_BILL] [char](1) NULL,
	[LINE_FLAG_TEXTILE] [char](1) NULL,
	[LINE_FRT_PER_PIECE_ORD] [numeric](11, 6) NULL,
	[LINE_PRICE_ORDER] [numeric](16, 6) NULL,
	[LINE_PRICE_DISC_ORD] [numeric](16, 6) NULL,
	[LINE_PRICE_LB_ORDER] [numeric](16, 6) NULL,
	[LINE_EXTENSION_ORDER] [numeric](16, 2) NULL,
	[LINE_AMT_DISC_ORDER] [numeric](12, 2) NULL,
	[LINE_AMT_DISC_ORD_ORDER] [numeric](12, 2) NULL,
	[LINE_AMT_DISC_PR_CL_ORD] [numeric](12, 2) NULL,
	[LINE_AMT_DISC_PROD_LN_ORD] [numeric](12, 2) NULL,
	[LINE_CURR_FLG] [char](1) NULL,
	[LINE_PART_PRICE_CODE] [char](3) NULL,
	[LINE_PICK_LIST_PRINTED] [char](1) NULL,
	[LINE_FRT_FROM_ORDER_FLG] [char](1) NULL,
	[LINE_ADD_BY_PGM] [char](8) NULL,
	[LINE_LOTBIN_FLG] [char](1) NULL,
	[LINE_APPLY_MATL_SCHRG] [char](1) NULL,
	[LINE_MATL_SCHRG_FLG] [char](1) NULL,
	[LINE_PRICE_BOM_COMP_FLG] [char](1) NULL,
	[LINE_SHIP_CHRG_FLAG] [char](1) NULL,
	[LINE_NO_DLVR_BEFORE_DATE] [date] NULL,
	[LINE_MUST_DLVR_BY_DATE] [date] NULL,
	[LINE_CARTONS] [numeric](8, 0) NULL,
	[LINE_PKGD_WEIGHT] [numeric](12, 4) NULL,
	[LINE_SCRIPT_FLG] [char](1) NULL,
	[LINE_MATL_SCHRG_DATE] [date] NULL,
	[LINE_QTE_CALC_COST] [numeric](16, 6) NULL,
	[LINE_PHASE] [char](4) NULL,
	[LINE_LFIFO_FLG] [char](1) NULL,
	[LINE_MANUAL_TAX_FLG] [bit] NULL,
	[LINE_CRTN_CD] [char](11) NULL,
	[LINE_QTY_PER_CRTN] [numeric](13, 4) NULL,
	[LINE_PLLT_CD] [char](11) NULL,
	[LINE_QTY_PER_PLLT] [numeric](13, 4) NULL,
	[LINE_GROSS_PER_CRTN] [numeric](12, 4) NULL,
	[LINE_GROSS_PER_PLLT] [numeric](12, 4) NULL,
	[LINE_PALLETS] [numeric](8, 0) NULL,
	[LINE_QTY_ALLOC] [numeric](13, 4) NULL,
	[LINE_TAX_ORGN_ADR] [numeric](2, 0) NULL,
	[LINE_TAX_ZONE_1] [char](2) NULL,
	[LINE_TAX_ZONE_2] [char](2) NULL,
	[LINE_TAX_ZONE_3] [char](2) NULL,
	[LINE_TAX_ZONE_4] [char](2) NULL,
	[LINE_TAX_ZONE_5] [char](2) NULL,
	[LINE_TAX_ZONE_6] [char](2) NULL,
	[LINE_TAX_ZONE_7] [char](2) NULL,
	[LINE_TAX_ZONE_8] [char](2) NULL,
	[LINE_TAX_ZONE_9] [char](2) NULL,
	[LINE_TAX_ZONE_10] [char](2) NULL,
	[LINE_TAX_INDX_FLG] [char](1) NULL,
	[LINE_TAX_ASGN_SRC] [numeric](6, 0) NULL,
	[LINE_SIGN_OPT] [numeric](3, 0) NULL,
	[LINE_VAT_RULE_ID] [numeric](3, 0) NULL,
	[LINE_VAT_EXEMPT_TYPE] [numeric](3, 0) NULL,
	[LINE_TAX_IN_PRC_FLG] [bit] NULL,
	[LINE_TAX_IMPORT_FLG] [numeric](3, 0) NULL,
	[LINE_ORIG_PCK_NO] [numeric](7, 0) NULL,
	[LINE_CNV_SHIP_DATE] [date] NULL,
	[LINE_PCK_NO] [numeric](7, 0) NULL,
	[LINE_SHP_STAT] [char](1) NULL,
	[LINE_IVC_BATCH] [char](5) NULL,
	[LINE_NO_OVER_SHP_QTY] [bit] NULL,
	[LINE_CONTRACT] [char](6) NULL,
	[LINE_FLAG_DATA_CNV] [char](1) NULL,
	[LINE_FLAG_ALWAYS_DISCOUNT] [char](1) NULL,
	[LINE_DATE_LAST_CHG] [date] NULL,
	[LINE_TIME_LAST_CHG] [time](0) NULL,
	[LINE_LAST_CHG_BY] [char](8) NULL,
	[LINE_LAST_CHG_PGM] [char](8) NULL,

	--ETL Metadata
	[ETL_TblNbr] [varchar](3) NOT NULL,
	[ETL_Batch] [varchar](2) NOT NULL,
	[ETL_Completed] [varchar](19) NOT NULL
) 