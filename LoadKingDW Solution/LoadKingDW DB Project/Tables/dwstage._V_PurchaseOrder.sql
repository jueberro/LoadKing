CREATE TABLE dwstage._V_PurchaseOrder
(
	[POH_PURCHASE_ORDER] [char](7) NULL,
	[POH_RECORD_NO] [char](4) NULL,
	[POH_TERMS] [char](12) NULL, -- Pay Terms --  Dim candidate key
	[POH_VENDOR] [char](6) NULL, -- Dim candidate key
	[POH_GL_ACCOUNT] [char](15) NULL, --  Dim candidate key
----------------------------------------------------------------
	[POH_ORDER_TAX] [char](1) NULL,
	[POH_FLAG_INSURANCE] [char](1) NULL,
	[POH_BUYER] [char](3) NULL,
	[POH_SHIP_VIA] [char](15) NULL,
	[POH_CODE_FOB] [char](15) NULL,
	[POH_FLAG_RECV_CLOSED] [char](1) NULL,
	[POH_FLAG_ACCT_CLOSE_A] [char](1) NULL,
	[POH_FLAG_PRINT] [char](1) NULL,
	[POH_PO_SEQ] [char](2) NULL,
	[POH_USER_2] [char](30) NULL,
	[POH_FLAG_CERTS_REQD] [char](1) NULL,
	[POH_TEXT_FORMAT] [char](1) NULL,
	[POH_PREV_SEQ] [char](2) NULL,
	[POH_DIFF_DUE_DATE] [char](1) NULL,
	[POH_PHYS_CHEM] [char](1) NULL,
	[POH_PAY_WITH_CCARD] [char](1) NULL,
	[POH_REC_TYPE] [char](1) NULL,
-------------------------------------------------------------
	[POH_CHANGE_DATE] datetime NULL,
	[POH_SHIP_DATE] datetime NULL,
	[POH_DATE_ORDER] datetime NULL,
	[POH_DATE_REQ] datetime NULL,
	[POH_DATE_DUE] datetime NULL,
---------------------------------------------------------
	[POH_PART_PD] [numeric](14, 2) NULL, -- Measure
	[POH_SB_PAID] [numeric](14, 2) NULL, -- Measure
	[POH_DISCOUNT_A] [numeric](5, 4) NULL, -- Measure
----------------------------------------------------------------
	[POL_PURCHASE_ORDER] [char](7) NULL,
	[POL_RECORD_NO] [char](4) NULL,
	[POL_PO_TYPE] [char](1) NULL,
	[POL_PART] [char](20) NULL, -- Not a actual Part
	[POL_LOCATION] [char](2) NULL,
	[POL_DESCRIPTION] [char](30) NULL, -- Pay Terms (miss parsed with Location)
	[POL_PART_MFG_NO] [char](23) NULL, --possible part
-----------------------------------------------------------------------------------
	[POL_FILL_EXTENSION] [numeric](1, 0) NULL,
	[POL_EXTENSION] [numeric](15, 2) NULL,
	[POL_FILLER10] [char](14) NULL,
	[POL_FILL_EXCH_EXT] [numeric](1, 0) NULL,
	[POL_REQUISITION_LINE] [numeric](3, 0) NULL,
	[POL_FILL_IVCOST] [numeric](1, 0) NULL,
	[POL_FILL_PT] [numeric](1, 0) NULL,
	[POL_FILL_VT] [numeric](1, 0) NULL,
	[POL_VAT_RULE] [numeric](3, 0) NULL,
	[POL_USE_PURPOSE] [numeric](3, 0) NULL,
	[POL_BOOK_USE_TAX] [bit] NULL,
	[POL_FLAG_REC_TYPE] [char](1) NULL,
-----------------------------------------------------------------------------------
	[POL_DATE_LAST_RECEIVED] datetime NULL, -- This is a Flag
	[POL_DATE_LAST_CHG] datetime NULL, -- not populated
--------------------------------------------------------------
	[POL_VEN_TAX] [numeric](15, 2) NULL, -- Measure
	[POL_PUR_TAX] [numeric](15, 2) NULL, -- Measure
	[POL_ROLL_QTY] [numeric](7, 0) NULL, -- Measure
	[POL_INV_COST] [numeric](15, 6) NULL, -- Measure
	[POL_SHIPPED_QTY] [numeric](14, 4) NULL, -- Measure
	[POL_EXCHANGE_COST2] [numeric](15, 6) NULL, -- Measure
	[POL_EXCHANGE_RATE] [numeric](10, 5) NULL, -- Measure
	[POL_COST_6_DEC] [numeric](15, 6) NULL, -- Measure
	[POL_EXCHANGE_EXT] [numeric](15, 2) NULL, -- Measure
	[POL_VEN_TAX_PER_PIECE] [numeric](15, 6) NULL, -- Measure
	[POL_QTY_ALT_ORDER] [numeric](14, 4) NULL, -- Measure
	[POL_QTY_RECD_NOT_INSP] [numeric](14, 4) NULL, -- Measure
	[POL_COST] [numeric](14, 4) NULL, -- Measure
	[POL_DISCOUNT] [numeric](5, 4) NULL, -- Measure
	[POL_QTY_ORDER] [numeric](14, 4) NULL, -- Measure
	[POL_QTY_RECEIVED] [numeric](14, 4) NULL, -- Measure
	[POL_QTY_REJECT] [numeric](14, 4) NULL, -- Measure
	[POL_QTY_RECV_ALT] [numeric](14, 4) NULL, -- Measure
	[POL_PUR_TAX_PER_PIECE] [numeric](15, 6) NULL, -- Measure
	ETL_TblNbr int NULL,
	ETL_Batch int NULL,
	ETL_Completed datetime NULL

) ON [PRIMARY]
