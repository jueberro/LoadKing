--USE [LK-GS-EDW]
--GO

CREATE TABLE dw.FactPurchaseOrderReceiver
(
	DimPurchaseOrder_Key int NOT NULL,
	DimInventory_Key int NOT NULL,
	DimVendor_Key int NOT NULL,
	DimGLAccount_Key int NOT NULL,
	DimDate_Key int NOT NULL,
	[RECEIVER_NO] [char](6) NULL,
	[PURCHASE_ORDER] [char](7) NULL, 
	[PO_LINE] [char](3) NULL, 
	[PART] [char](20) NULL, 
	[GL_ACCOUNT] [char](15) NULL, 
	[JOB] [char](7) NULL, 
	[SUFFIX] [char](4) NULL, 
	[SEQUENCE] [char](6) NULL, 
	[VENDOR] [char](6) NULL, 
	[DESCRIPTION] [char](30) NULL,
	[FLAG_OPN_ITM_POST] [char](1) NULL,
	[PAY_WITH_CCARD] [char](1) NULL,
	[TAXABLE] [bit] NULL,
	[BOOK_USE_TAX] [bit] NULL,
	[VAT_RULE] [numeric](3, 0) NULL,
	[USE_PURPOSE] [numeric](3, 0) NULL,
	[DATE_RECEIVED] datetime NULL, -- Date -- [char](8)
	[DATE_TRANSACTION] datetime NULL, -- Date -- [char](6)
	[TIME_TRANSACTION] [char](8) NULL, 
	[DATE_EXCHANGE] datetime NULL, -- Date -- [char](8)
	[DATE_LAST_CHG] datetime NULL, -- Date -- [char](8)
	[EXTENDED_COST] [numeric](16, 2) NULL, -- Measure
	[QTY_RECEIVED] [numeric](13, 4) NULL, -- Measure
	[QTY_INVOICED] [numeric](13, 4) NULL, -- Measure
	[COST_INVOICED] [numeric](16, 2) NULL, -- Measure
	[EXTENDED_STD_COST] [numeric](16, 2) NULL, -- Measure
	[EXCHANGE_RATE] [numeric](10, 5) NULL, -- Measure
	[EXCH_EXT_COST] [numeric](16, 2) NULL, -- Measure
	[EXCH_COST_INV] [numeric](16, 2) NULL, -- Measure
	[EXCH_EXT_STD_COST] [numeric](16, 2) NULL, -- Measure
	[Type1RecordHash] [varbinary](64) NULL
	) ON [PRIMARY]
GO

