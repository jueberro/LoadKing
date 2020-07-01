--USE [LK-GS-EDW]
--GO



CREATE TABLE dwstage.PO_RECEIVER
(
	[RECEIVER_NO] [char](6) NULL,
	[PURCHASE_ORDER] [char](7) NULL,
	[PO_LINE] [char](3) NULL,
	[DATE_RECEIVED] [char](8) NULL,
	[PART] [char](20) NULL,
	[FILL_PART] [char](18) NULL,
	[LOCATION] [char](2) NULL,
	[EXTENDED_COST] [numeric](16, 2) NULL,
	[QTY_RECEIVED] [numeric](13, 4) NULL,
	[GL_ACCOUNT] [char](15) NULL,
	[JOB] [char](7) NULL,
	[SUFFIX] [char](4) NULL,
	[SEQUENCE] [char](6) NULL,
	[VENDOR] [char](6) NULL,
	[FILL_VEND] [char](1) NULL,
	[DESCRIPTION] [char](30) NULL,
	[FILL_DESC] [char](20) NULL,
	[QTY_INVOICED] [numeric](13, 4) NULL,
	[COST_INVOICED] [numeric](16, 2) NULL,
	[EXTENDED_STD_COST] [numeric](16, 2) NULL,
	[FLAG_OPN_ITM_POST] [char](1) NULL,
	[DATE_TRANSACTION] [char](6) NULL,
	[TIME_TRANSACTION] [char](8) NULL,
	[FLAG_RCVR_SALES_ORD] [char](1) NULL,
	[EXCHANGE_CURRENCY] [char](3) NULL,
	[DATE_EXCHANGE] [char](8) NULL,
	[EXCHANGE_RATE] [numeric](10, 5) NULL,
	[EXCH_EXT_COST] [numeric](16, 2) NULL,
	[EXCH_COST_INV] [numeric](16, 2) NULL,
	[EXCH_EXT_STD_COST] [numeric](16, 2) NULL,
	[PACK_LIST] [char](16) NULL,
	[PAY_WITH_CCARD] [char](1) NULL,
	[CC_VENDOR] [char](6) NULL,
	[TAXABLE] [bit] NULL,
	[BOOK_USE_TAX] [bit] NULL,
	[TAX_CODE] [char](5) NULL,
	[VAT_RULE] [numeric](3, 0) NULL,
	[USE_PURPOSE] [numeric](3, 0) NULL,
	[INVC_STATUS_FLAG] [char](1) NULL,
	[FILLER] [char](3) NULL,
	[DATE_LAST_CHG] [char](8) NULL,
	[TIME_LAST_CHG] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[LAST_CHG_PROG] [char](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


