

CREATE TABLE dwstage._V_QUOTE
(
	[QH_QUOTE_NO] [char](7) NULL,
	[QH_RECORD_TYPE] [char](1) NULL,
	[QH_CUSTOMER] [char](6) NULL,
	[QH_SHIPTO] [char](6) NULL,
	[QH_INVOICE] [char](6) NULL,
	[QH_FILL_INVOICE] [char](1) NULL,
	[QH_QUOTE_TYPE] [char](1) NULL,
	[QH_QUOTE_SUFFIX] [char](4) NULL,
	[QH_CUSTOMER_PO] [char](15) NULL,
	[QH_MARK_INFO] [char](30) NULL,
	[QH_CODE_FOB] [char](14) NULL,
	[QH_TERMS] [char](10) NULL,
	[QH_LAST_REC_NO] [numeric](4, 0) NULL,
	[QH_DATE_SHIPPED] [char](6) NULL,
	[QH_CODE_SORT] [char](20) NULL,
	[QH_EXPIRATION] [char](10) NULL,
	[QH_SALESPERSON] [char](3) NULL,
	[QH_BRANCH] [char](2) NULL,
	[QH_SHIP_VIA] [char](20) NULL,
	[QH_QUOTE_SORT_2] [char](30) NULL,
	[QH_QUOTE] [char](7) NULL,
	[QH_QUOTE_LOCATION] [char](2) NULL,
	[QH_FLAG_SPCD] [char](1) NULL,
	[QH_QUOTE_CURRENCY] [char](3) NULL,
	[QH_QTE_CREATED_BY] [char](8) NULL,
	[QH_PRIMARY_GRP] [char](2) NULL,
	[QH_CARRIER_CD] [char](6) NULL,
-----------------------------------------------------------------
	[QH_DATE_LAST_CHG] datetime NULL, -- DATE
	[QH_DATE_DUE] datetime NULL, -- DATE
	[QH_DATE_QUOTE_CNV] datetime NULL, -- DATE
	[QH_DATE_DUE_CNV] datetime NULL, -- DATE
	[QH_QTE_CREATED_DATE] datetime NULL, -- DATE
	[QH_QUOTE_WON_LOSS_DATE] datetime NULL, -- DATE
	[QH_MUST_DLVR_BY_DATE] datetime NULL, -- DATE
-----------------------------------------------------------------
--CREATE TABLE [dbo].[QUOTE_LINES]

	[QL_QUOTE_NO] [char](7) NULL,
	[QL_RECORD_NO] [char](4) NULL,
	[QL_RECORD_TYPE] [char](1) NULL,
	[QL_DESCRIPTION] [char](30) NULL,
	[QL_FILL_CUST] [char](1) NULL,
	[QL_SHIP_ID] [char](6) NULL,
	[QL_FILL_INV] [char](1) NULL,
	[QL_LINE_TYPE] [char](1) NULL,
	[QL_UM_QUOTE] [char](2) NULL,
	[QL_PART] [char](20) NULL,
	[QL_QUOTE_WON] [char](1) NULL,
	[QL_UM_INVENTORY] [char](2) NULL,
	[QL_USER_1] [char](30) NULL,
	[QL_USER_2] [char](30) NULL,
	[QL_USER_3] [char](30) NULL,
	[QL_FLAG_BILLING_PRICE] [char](1) NULL,
	[QL_PRICE_CODE] [char](2) NULL,
	[QL_FLAG_REQ_CREATED] [char](1) NULL,
	[QL_FLAG_USE_MQD] [char](1) NULL,
	[QL_GL_ACCOUNT] [char](15) NULL,
	[QL_TAX_SOURCE] [char](1) NULL,
	[QL_TAX_STATE] [char](2) NULL,
	[QL_TAX_ZIP] [char](13) NULL,
	[QL_TAX_GEO_CODE] [char](2) NULL,
	[QL_TAX_1] [char](3) NULL,
	[QL_TAX_2] [char](3) NULL,
	[QL_TAX_3] [char](3) NULL,
	[QL_TAX_APPLY_1] [char](1) NULL,
	[QL_TAX_APPLY_2] [char](1) NULL,
	[QL_TAX_APPLY_3] [char](1) NULL,
	[QL_FLAG_REWORK] [char](1) NULL,
	[QL_BIN] [char](6) NULL,
	[QL_FLAG_COGS] [char](1) NULL,
	[QL_FLAG_TAX_STATUS] [char](1) NULL,
	[QL_CUSTOMER_PART] [char](20) NULL,
	[QL_FILL_CUST_PART] [char](12) NULL,
	[QL_FLAG_RMA] [char](1) NULL,
	[QL_INFO_1] [char](20) NULL,
	[QL_INFO_2] [char](20) NULL,
	[QL_FLAG_PURCHASED] [char](1) NULL,
	[QL_QUOTE_CURR_CD] [char](3) NULL,
	[QL_MXD_CRTNS] [bit] NULL,
	[QL_MXD_PLLTS] [bit] NULL,
	[QL_NON_INV] [bit] NULL,
	[QL_PALLET_FLAG] [bit] NULL,
	[QL_INACTIVE] [bit] NULL,
	[QL_XTNL_ORD_DISC_FLG] [bit] NULL,
	[QL_FLAG_BOM] [char](1) NULL,
	[QL_BOM_PARENT] [char](4) NULL,
	[QL_PRODUCT_LINE] [char](2) NULL,
	[QL_ADD_BY_PGM] [char](8) NULL,
	[QL_LOTBIN_FLG] [char](1) NULL,
	[QL_PRICE_BOM_COMP_FLG] [char](1) NULL,
	[QL_MANUAL_TAX_FLG] [bit] NULL,
	[QL_FILLER133] [char](133) NULL,
	[QL_TAX_ASGN_SRC] [numeric](6, 0) NULL,
	[QL_TAX_IMPORT_FLG] [numeric](3, 0) NULL,
	[QL_FILLER6] [char](6) NULL,
	[QL_FLAG_ALWAYS_DISCOUNT] [char](1) NULL,
---------------------------------------------------------------------
	[QL_DATE_SHIP] datetime NULL, -- DATE
	[QL_DATE_QUOTE] datetime NULL, -- DATE
	[QL_DATE_ITEM_PROM] datetime NULL, -- DATE
	[QL_ITEM_PROMISE_DT] datetime NULL, -- DATE
	[QL_DATE_LAST_INVOICE] datetime NULL, -- DATE
	[QL_DATE_LAST_CHG] datetime NULL, -- DATE
--Possible Measure ---------------------------------------------------------
	[QL_QTY_QUOTED] [numeric](13, 4) NULL, -- M
	[QL_QTY_SHIPPED] [numeric](13, 4) NULL, -- M
	[QL_QTY_BO] [numeric](13, 4) NULL, -- M
	[QL_WEIGHT] [numeric](10, 3) NULL, -- M
	[QL_PRICE] [numeric](16, 6) NULL, -- M
	[QL_COST] [numeric](16, 6) NULL, -- M
	[QL_DISCOUNT] [numeric](5, 4) NULL, -- M
	[QL_QTY_ORIGINAL] [numeric](13, 4) NULL, -- M
	[QL_EXTENSION] [numeric](16, 2) NULL, -- M
	[QL_MARGIN] [numeric](7, 4) NULL, -- M
	[QL_DISCOUNT_PRICE] [numeric](16, 6) NULL, -- M
	[QL_PRICE_QUOTE] [numeric](16, 6) NULL, -- M
	[QL_PRICE_DISC_ORD] [numeric](16, 6) NULL, -- M
	[QL_EXTENSION_QUOTE] [numeric](16, 2) NULL, -- M
-------------------------------------------------------------
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO
