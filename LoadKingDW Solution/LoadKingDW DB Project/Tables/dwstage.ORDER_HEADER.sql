﻿CREATE TABLE [dwstage].[ORDER_HEADER](
	[ORDER_NO] [nvarchar](7) NULL,
	[RECORD_NO] [nvarchar](4) NULL,
	[ORDER_SHIP_ID] [nvarchar](6) NULL,
	[RECORD_TYPE] [nvarchar](1) NULL,
	[CUSTOMER] [nvarchar](6) NULL,
	[FILL_CUSTOMER] [nvarchar](1) NULL,
	[SHIP_ID] [nvarchar](6) NULL,
	[INVOICE] [nvarchar](6) NULL,
	[FILL_INVOICE] [nvarchar](1) NULL,
	[DATE_ORDER] [nvarchar](6) NULL,
	[DATE_DUE] [nvarchar](6) NULL,
	[INSURANCE] [nvarchar](1) NULL,
	[ORDER_TYPE] [nvarchar](1) NULL,
	[ORDER_SUFFIX] [nvarchar](4) NULL,
	[CUSTOMER_PO] [nvarchar](15) NULL,
	[FILL_CUST_PO] [nvarchar](15) NULL,
	[MARK_INFO] [nvarchar](30) NULL,
	[CODE_FOB] [nvarchar](14) NULL,
	[TERMS] [nvarchar](10) NULL,
	[WAY_BILL] [nvarchar](19) NULL,
	[LAST_REC_NO] [bigint] NULL,
	[DATE_SHIPPED] [nvarchar](6) NULL,
	[FLAG_PRINT] [nvarchar](1) NULL,
	[CODE_SORT] [nvarchar](20) NULL,
	[FLAG_SHIPPED] [nvarchar](1) NULL,
	[TRANS_METHOD] [nvarchar](10) NULL,
	[CERT_ENCL] [nvarchar](1) NULL,
	[EXPIRATION] [nvarchar](10) NULL,
	[WHO_GOT_IT] [nvarchar](20) NULL,
	[USER_1] [nvarchar](30) NULL,
	[USER_2] [nvarchar](30) NULL,
	[USER_3] [nvarchar](30) NULL,
	[USER_4] [nvarchar](30) NULL,
	[USER_5] [nvarchar](30) NULL,
	[FLAG_NO_BACKORDER] [nvarchar](1) NULL,
	[SALESPERSON] [nvarchar](3) NULL,
	[BRANCH] [nvarchar](2) NULL,
	[AREA] [nvarchar](2) NULL,
	[FREIGHT_ZONE] [nvarchar](10) NULL,
	[SHIP_VIA] [nvarchar](20) NULL,
	[ORDER_DISCOUNT] [decimal](5, 4) NULL,
	[PRICE_CLASS] [nvarchar](1) NULL,
	[PRICE_CLASS_DISC] [decimal](5, 4) NULL,
	[TYPE_COMMISSION] [nvarchar](5) NULL,
	[GL_ACCOUNT] [nvarchar](15) NULL,
	[TAX_SOURCE] [nvarchar](1) NULL,
	[TAX_STATE] [nvarchar](2) NULL,
	[TAX_ZIP] [nvarchar](13) NULL,
	[TAX_GEO_CODE] [nvarchar](2) NULL,
	[TAX_1] [nvarchar](3) NULL,
	[TAX_2] [nvarchar](3) NULL,
	[TAX_3] [nvarchar](3) NULL,
	[TAX_4] [nvarchar](3) NULL,
	[TAX_5] [nvarchar](3) NULL,
	[TAX_6] [nvarchar](3) NULL,
	[TAX_7] [nvarchar](3) NULL,
	[TAX_8] [nvarchar](3) NULL,
	[TAX_9] [nvarchar](3) NULL,
	[TAX_10] [nvarchar](3) NULL,
	[TAX_APPLY_1] [nvarchar](1) NULL,
	[TAX_APPLY_2] [nvarchar](1) NULL,
	[TAX_APPLY_3] [nvarchar](1) NULL,
	[TAX_APPLY_4] [nvarchar](1) NULL,
	[TAX_APPLY_5] [nvarchar](1) NULL,
	[TAX_APPLY_6] [nvarchar](1) NULL,
	[TAX_APPLY_7] [nvarchar](1) NULL,
	[TAX_APPLY_8] [nvarchar](1) NULL,
	[TAX_APPLY_9] [nvarchar](1) NULL,
	[TAX_APPLY_10] [nvarchar](1) NULL,
	[CONTRACT] [bigint] NULL,
	[ORDER_SORT_2] [nvarchar](30) NULL,
	[QUOTE] [nvarchar](7) NULL,
	[FLAG_TIME_MATL] [nvarchar](1) NULL,
	[DATE_ORDER_CNV] [nvarchar](8) NULL,
	[DATE_DUE_CNV] [nvarchar](8) NULL,
	[FLAG_PICKLIST] [nvarchar](1) NULL,
	[ORDER_LOCATION] [nvarchar](2) NULL,
	[FLAG_IN_PROCESS] [nvarchar](1) NULL,
	[DATE_PO_EXPIRE] [nvarchar](8) NULL,
	[PRICE_SCHED_ID] [nvarchar](9) NULL,
	[QUOTE_APPROVED_BY] [nvarchar](8) NULL,
	[DATE_QUOTE_APPROVED] [nvarchar](8) NULL,
	[FLAG_PL_TYPE] [nvarchar](1) NULL,
	[FLAG_SPCD] [nvarchar](1) NULL,
	[PRICE_CATEGORY] [nvarchar](2) NULL,
	[COMPANY_CURRENCY] [nvarchar](3) NULL,
	[CATALOG_CURRENCY] [nvarchar](3) NULL,
	[ORDER_CURRENCY] [nvarchar](3) NULL,
	[DATE_EXCH_FO_TC] [nvarchar](8) NULL,
	[EXCH_RATE_FO_TC] [decimal](10, 5) NULL,
	[DATE_EXCH_FC_TO] [nvarchar](8) NULL,
	[EXCH_RATE_FC_TO] [decimal](10, 5) NULL,
	[DATE_EXCH_FL_TO] [nvarchar](8) NULL,
	[EXCH_RATE_FL_TO] [decimal](10, 5) NULL,
	[DATE_EXCH_FL_TC] [nvarchar](8) NULL,
	[EXCH_RATE_FL_TC] [decimal](10, 5) NULL,
	[BUY_GRP_CUST_NO] [nvarchar](6) NULL,
	[FILL_BG_CUST_NO] [nvarchar](1) NULL,
	[BUY_GRP_ADRS_FLG] [nvarchar](1) NULL,
	[PAYMENT_TYPE] [nvarchar](2) NULL,
	[ICV_RESPONSE] [nvarchar](1) NULL,
	[ICV_STATUS] [nvarchar](1) NULL,
	[PREPAID_INVOICE] [nvarchar](1) NULL,
	[CC_FAIL_FLAG] [nvarchar](1) NULL,
	[CMEMO_TYPE] [nvarchar](1) NULL,
	[PAYMENT_REQUEST] [nvarchar](1) NULL,
	[SPAWNED_SHPMT_FLAG] [nvarchar](1) NULL,
	[ORIG_SHPMT_SEQ] [nvarchar](4) NULL,
	[PRO_NO] [nvarchar](20) NULL,
	[LUMP_SUM_FLAG] [nvarchar](1) NULL,
	[FILL_LSA] [bigint] NULL,
	[LUMP_SUM_AMT] [decimal](15, 2) NULL,
	[QTE_CREATED_BY] [nvarchar](8) NULL,
	[QTE_CREATED_DATE] [nvarchar](8) NULL,
	[LANG_CD] [nvarchar](3) NULL,
	[PRGBILL_ONLY_FLAG] [nvarchar](1) NULL,
	[SHP_HLD_FLAG] [nvarchar](2) NULL,
	[BLANKET_NO] [nvarchar](7) NULL,
	[TRACKING_NO] [nvarchar](30) NULL,
	[TRACKING_FLAG] [nvarchar](1) NULL,
	[ETA_DATE] [nvarchar](8) NULL,
	[CARTONS] [bigint] NULL,
	[WEIGHT] [decimal](12, 4) NULL,
	[COMPLETE_SHIP] [nvarchar](1) NULL,
	[TRMS_DSC_DUE_DT] [nvarchar](8) NULL,
	[TRMS_DSC_AMT] [decimal](10, 2) NULL,
	[TRMS_DSC_CUR_AMT] [decimal](10, 2) NULL,
	[LINE_TEXT_FLAG] [nvarchar](1) NULL,
	[PREPAY_APPLY_FLAG] [nvarchar](1) NULL,
	[IVC_ASSIGN_FLAG] [nvarchar](1) NULL,
	[AUTO_FRT_FLAG] [nvarchar](1) NULL,
	[QUOTE_WON_LOSS_DATE] [nvarchar](8) NULL,
	[FACILITY] [nvarchar](3) NULL,
	[FRT_REQRD_FLG] [bit] NULL,
	[TRNSFR_BIN_OPT] [bigint] NULL,
	[TRNSFR_TO_BIN] [nvarchar](6) NULL,
	[FILLER254] [nvarchar](254) NULL,
	[NO_DLVR_BEFORE_DATE] [nvarchar](8) NULL,
	[MUST_DLVR_BY_DATE] [nvarchar](8) NULL,
	[TRNSFR_LOCN] [nvarchar](2) NULL,
	[INTRANSIT_AUTO] [bigint] NULL,
	[TRANSIT_NO] [bigint] NULL,
	[PALLETS] [bigint] NULL,
	[NET_WEIGHT] [decimal](12, 4) NULL,
	[FILLER154] [nvarchar](154) NULL,
	[TAX_ORGN_ADR] [bigint] NULL,
	[TAX_ZONE_1] [nvarchar](2) NULL,
	[TAX_ZONE_2] [nvarchar](2) NULL,
	[TAX_ZONE_3] [nvarchar](2) NULL,
	[TAX_ZONE_4] [nvarchar](2) NULL,
	[TAX_ZONE_5] [nvarchar](2) NULL,
	[TAX_ZONE_6] [nvarchar](2) NULL,
	[TAX_ZONE_7] [nvarchar](2) NULL,
	[TAX_ZONE_8] [nvarchar](2) NULL,
	[TAX_ZONE_9] [nvarchar](2) NULL,
	[TAX_ZONE_10] [nvarchar](2) NULL,
	[PRE_QUOTE] [nvarchar](1) NULL,
	[SCRIPT_FLG] [nvarchar](1) NULL,
	[IVC_HLD_FLG] [bigint] NULL,
	[PROJECT] [nvarchar](7) NULL,
	[CARRIER_ACCT] [nvarchar](25) NULL,
	[PROCESS_GRP] [nvarchar](1) NULL,
	[SHIP_ID_INT] [int] NULL,
	[CONTRACT_FLG] [nvarchar](1) NULL,
	[PRICE_CATG_FLG] [nvarchar](1) NULL,
	[TAX_INDX_FLG] [nvarchar](1) NULL,
	[FILLER2] [nvarchar](1) NULL,
	[NO_OVER_SHP_QTY] [bit] NULL,
	[PRIMARY_GRP] [nvarchar](2) NULL,
	[SECONDARY_GRP] [nvarchar](2) NULL,
	[SRVC_TYPE] [smallint] NULL,
	[VAT_RULE_ID] [tinyint] NULL,
	[VAT_EXEMPT_TYPE] [tinyint] NULL,
	[TAX_IN_PRC_FLG] [bit] NULL,
	[TAX_IMPORT_FLG] [tinyint] NULL,
	[ORIG_PCK_NO] [nvarchar](7) NULL,
	[CNV_SHIP_DATE] [nvarchar](8) NULL,
	[PCK_NO] [nvarchar](7) NULL,
	[SHP_STATUS] [nvarchar](1) NULL,
	[IVC_BATCH] [nvarchar](5) NULL,
	[THRD_PRTY_FRT_CUST] [nvarchar](7) NULL,
	[CARRIER_CD] [nvarchar](6) NULL,
	[FLAG_DATA_CNV] [nvarchar](1) NULL,
	[FLAG_ALWAYS_DISCOUNT] [nvarchar](1) NULL,
	[DATE_LAST_CHG] [nvarchar](8) NULL,
	[TIME_LAST_CHG] [nvarchar](8) NULL,
	[LAST_CHG_BY] [nvarchar](8) NULL,
	[LAST_CHG_PGM] [nvarchar](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) 
