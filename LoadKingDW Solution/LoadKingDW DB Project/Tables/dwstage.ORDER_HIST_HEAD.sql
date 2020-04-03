﻿CREATE TABLE [dwstage].[ORDER_HIST_HEAD](
	[INVOICE] [nvarchar](7) NULL,
	[ORDER_NO] [nvarchar](7) NULL,
	[ORDER_SUFFIX] [nvarchar](4) NULL,
	[ORDER_TYPE] [nvarchar](1) NULL,
	[CUSTOMER] [nvarchar](6) NULL,
	[BUY_GROUP_CUST] [nvarchar](6) NULL,
	[FLAG_BUY_GROUP] [nvarchar](1) NULL,
	[DATE_ORDER] [datetime2](0) NULL,
	[DATE_ORDER_DUE] [datetime2](0) NULL,
	[DATE_PO_EXPIRE] [datetime2](0) NULL,
	[CUSTOMER_PO] [nvarchar](15) NULL,
	[CONTRACT] [bigint] NULL,
	[NAME_CUSTOMER] [nvarchar](30) NULL,
	[ADDRESS1] [nvarchar](30) NULL,
	[ADDRESS2] [nvarchar](30) NULL,
	[ADDRESS3] [nvarchar](30) NULL,
	[ADDRESS4] [nvarchar](30) NULL,
	[ADDRESS5] [nvarchar](30) NULL,
	[CITY] [nvarchar](15) NULL,
	[STATE] [nvarchar](3) NULL,
	[ZIP] [nvarchar](13) NULL,
	[COUNTRY] [nvarchar](12) NULL,
	[FLAG_INTL] [nvarchar](1) NULL,
	[ATTENTION] [nvarchar](30) NULL,
	[CONTACT] [nvarchar](30) NULL,
	[CONTACT_PHONE] [nvarchar](20) NULL,
	[CONTACT_EMAIL] [nvarchar](100) NULL,
	[CODE_SORT] [nvarchar](20) NULL,
	[ORDER_SORT_2] [nvarchar](30) NULL,
	[USER_1] [nvarchar](30) NULL,
	[USER_2] [nvarchar](30) NULL,
	[USER_3] [nvarchar](30) NULL,
	[USER_4] [nvarchar](30) NULL,
	[USER_5] [nvarchar](30) NULL,
	[QUOTE] [nvarchar](7) NULL,
	[TERMS] [nvarchar](10) NULL,
	[FLAG_TIME_MATL] [nvarchar](1) NULL,
	[LOCATION] [nvarchar](2) NULL,
	[FLAG_ALWAYS_DISC] [nvarchar](1) NULL,
	[FLAG_SPCD] [nvarchar](1) NULL,
	[PRICE_SCHEDULE] [nvarchar](9) NULL,
	[COMPANY_CURRENCY] [nvarchar](3) NULL,
	[CATALOG_CURRENCY] [nvarchar](3) NULL,
	[ORDER_CURRENCY] [nvarchar](3) NULL,
	[DATE_EXCHANGE_FO_TC] [datetime2](0) NULL,
	[EXCHANGE_RATE_FO_TC] [decimal](10, 5) NULL,
	[DATE_EXCHANGE_FC_TO] [datetime2](0) NULL,
	[EXCHANGE_RATE_FC_TO] [decimal](10, 5) NULL,
	[DATE_EXCHANGE_FL_TO] [datetime2](0) NULL,
	[EXCHANGE_RATE_FL_TO] [decimal](10, 5) NULL,
	[DATE_EXCHANGE_FL_TC] [datetime2](0) NULL,
	[EXCHANGE_RATE_FL_TC] [decimal](10, 5) NULL,
	[DATE_SHIPPED] [datetime2](0) NULL,
	[CUSTOMER_SHIP] [nvarchar](6) NULL,
	[NAME_CUSTOMER_SHIP] [nvarchar](30) NULL,
	[ADDRESS1_SHIP] [nvarchar](30) NULL,
	[ADDRESS2_SHIP] [nvarchar](30) NULL,
	[ADDRESS3_SHIP] [nvarchar](30) NULL,
	[ADDRESS4_SHIP] [nvarchar](30) NULL,
	[ADDRESS5_SHIP] [nvarchar](30) NULL,
	[CITY_SHIP] [nvarchar](15) NULL,
	[STATE_SHIP] [nvarchar](3) NULL,
	[ZIP_SHIP] [nvarchar](13) NULL,
	[COUNTRY_SHIP] [nvarchar](12) NULL,
	[FLAG_INTL_SHIP] [nvarchar](1) NULL,
	[ATTENTION_SHIP] [nvarchar](30) NULL,
	[FLAG_INS] [nvarchar](1) NULL,
	[FLAG_CERT_ENCL] [nvarchar](1) NULL,
	[MARK_INFO] [nvarchar](30) NULL,
	[FOB_INFO] [nvarchar](14) NULL,
	[WAYBILL] [nvarchar](19) NULL,
	[BATCH] [nvarchar](5) NULL,
	[DATE_INVOICE] [datetime2](0) NULL,
	[COMPLEMENT_DATE_INV] [nvarchar](8) NULL,
	[FLAG_EXCL_BOM_COMP] [nvarchar](1) NULL,
	[FLAG_1_INV_ORDER] [nvarchar](1) NULL,
	[FLAG_1_INV_CUST] [nvarchar](1) NULL,
	[FLAG_1_INV_SORT] [nvarchar](1) NULL,
	[FLAG_1_INV_ITEM] [nvarchar](1) NULL,
	[FLAG_1_INV_PART] [nvarchar](1) NULL,
	[COST_MATERIAL] [decimal](11, 2) NULL,
	[COST_LABOR] [decimal](11, 2) NULL,
	[COST_OUTSIDE] [decimal](11, 2) NULL,
	[COST_OVERHEAD] [decimal](11, 2) NULL,
	[COST_OTHER] [decimal](11, 2) NULL,
	[JOB] [nvarchar](6) NULL,
	[SUFFIX] [nvarchar](3) NULL,
	[PRODUCT_CODE] [nvarchar](3) NULL,
	[JOB_DESCRIPTION] [nvarchar](30) NULL,
	[FLAG_JOB_CLOSE] [nvarchar](1) NULL,
	[PART_JOB] [nvarchar](20) NULL,
	[LOCATION_JOB] [nvarchar](2) NULL,
	[QTY_JOB] [decimal](13, 4) NULL,
	[FLAG_PRICE_AT_COST] [nvarchar](1) NULL,
	[CREDIT_MEMO_FLAG] [nvarchar](1) NULL,
	[INVOICE_ORIGINAL] [nvarchar](6) NULL,
	[DATE_ORIG_INVOICE] [datetime2](0) NULL,
	[FLAG_TAX_ADJ] [nvarchar](1) NULL,
	[ORDER_SOURCE] [nvarchar](1) NULL,
	[HISTORY_SOURCE] [nvarchar](1) NULL,
	[HISTORY_VERSION] [nvarchar](2) NULL,
	[FREIGHT_ZONE] [nvarchar](10) NULL,
	[FLAG_COMPL_SHIP] [nvarchar](1) NULL,
	[PAYMENT_TYPE] [nvarchar](2) NULL,
	[PLST_FLAG] [nvarchar](1) NULL,
	[CREDIT_MEMO_TYPE] [nvarchar](1) NULL,
	[DD250_FLAG] [nvarchar](1) NULL,
	[LUMP_SUM_FLAG] [nvarchar](1) NULL,
	[LUMP_SUM_AMT] [decimal](15, 2) NULL,
	[LANG_CD] [nvarchar](3) NULL,
	[CARRIER_CD] [nvarchar](6) NULL,
	[THRD_PRTY_FRT_CUST] [nvarchar](7) NULL,
	[PCK_NO] [nvarchar](7) NULL,
	[TRACKING_NO] [nvarchar](30) NULL,
	[TRACKING_FLAG] [nvarchar](1) NULL,
	[ETA_DATE] [datetime2](0) NULL,
	[TRANS_METHOD] [nvarchar](10) NULL,
	[TERMS_DISC_DUE_DATE] [datetime2](0) NULL,
	[TERMS_DISC_AMT] [decimal](10, 2) NULL,
	[TERMS_DISC_AMT_ORDER] [decimal](10, 2) NULL,
	[PROJECT] [nvarchar](7) NULL,
	[CARRIER_ACCT] [nvarchar](25) NULL,
	[IVC_UPD_SCRIPT_FLG] [nvarchar](1) NULL,
	[CARTONS] [bigint] NULL,
	[WEIGHT] [decimal](12, 4) NULL,
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
	[PRO_NO] [nvarchar](20) NULL,
	[PRGBILL_ONLY_FLG] [nvarchar](1) NULL,
	[IVC_ALL_COMMENTS] [nvarchar](1) NULL,
	[SPAWNED_SHPMT_FLG] [nvarchar](1) NULL,
	[ORIG_SHPMT_SEQ] [nvarchar](4) NULL,
	[HAS_SPAWNED_FLG] [nvarchar](1) NULL,
	[SHIP_DATE_9CMP] [nvarchar](8) NULL,
	[BILL_PHONE_CNTRY] [nvarchar](3) NULL,
	[BILL_PHONE_AREA] [nvarchar](3) NULL,
	[BILL_PHONE_MAIN] [nvarchar](7) NULL,
	[ORIG_PCK_NO] [nvarchar](7) NULL,
	[PREPAY_APPLY_FLG] [nvarchar](1) NULL,
	[IVC_BATCH_COMB_SHPMT] [nvarchar](1) NULL,
	[IVC_ASSIGN_FLAG] [nvarchar](1) NULL,
	[SAR_SOURCE_FLG] [nvarchar](1) NULL,
	[BLANKET_NO] [nvarchar](7) NULL,
	[FACILITY] [nvarchar](3) NULL,
	[SRVC_TYPE] [smallint] NULL,
	[SHIPMENT_ID] [int] NULL,
	[SALESMAN] [nvarchar](3) NULL,
	[CONTRACT_FLG] [nvarchar](1) NULL,
	[PRICE_CATG_FLG] [nvarchar](1) NULL,
	[REPAIR_FRT_COST] [decimal](11, 2) NULL,
	[SIX_DEC_TAX_FLG] [nvarchar](1) NULL,
	[TAX_ADJMT_FLG] [nvarchar](1) NULL,
	[EINVOICE_FLG] [nvarchar](1) NULL,
	[ONE_PER_BLANKET] [nvarchar](1) NULL,
	[PRICE_CLASS] [nvarchar](1) NULL,
	[AREA] [nvarchar](2) NULL,
	[BRANCH] [nvarchar](2) NULL,
	[PRIMARY_GRP] [nvarchar](2) NULL,
	[SECONDARY_GRP] [nvarchar](2) NULL,
	[SHIP_VIA] [nvarchar](20) NULL,
	[VAT_EC_FLG] [bit] NULL,
	[VAT_CNTRY_CD] [nvarchar](3) NULL,
	[FILLER] [nvarchar](117) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]

GO
