--USE [LK-GS-EDW]
--GO

CREATE TABLE dw.FactInventoryMovement
(
	DimInventory_Key int NOT NULL,
	DimGLAccount_Key int NOT NULL,
	DimProductLine_Key int NOT NULL,
	DimWorkOrder_Key int NOT NULL,
	DimVendor_Key int NOT NULL,
	DimDate_Key int NOT NULL,
	[PART] [char](20) NULL,
	[GL_ACCOUNT] [char](15) NULL,
	[PRODUCT_LINE] [char](2) NULL,
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[SEQ] [char](6) NULL,
	[VENDOR_NO] [char](6) NULL,
	[VENDOR_NAME] [char](30) NULL,
	[DATE_ACCT_YR] [char](2) NULL,
	[DATE_ACCT_MO] [char](2) NULL,
	[LOCATION] [char](2) NULL,
	[CODE_TRANSACTION] [char](3) NULL,
	[TRANSACTION_DESC] [char](15) NULL,
	[REFER_2] [char](15) NULL,
	[BIN] [char](6) NULL,
	[JCM_CLOSED] [char](1) NULL,
	[DEBIT_PROD_LN] [char](2) NULL,
	[A50_CUSTOMER] [char](6) NULL,
	[A50_SHIPTO] [char](6) NULL,
	[PROGRAM_A] [char](8) NULL,
	[IGNORE_FOR_USAGE] [bit] NULL,
	[USERID] [char](8) NULL,
	[FG_CLOSE] [char](1) NULL,
	[RECEIVER] [char](6) NULL,
	[COST_NOT_UPD] [bit] NULL,
	[DTL_KEY_SEQ] [numeric](4, 0) NULL,
	[T10_FRGT] [numeric](14, 6) NULL,
	[T10_FRGT_ACCT] [char](15) NULL,
	[FILLER] [char](37) NULL,
	[DATE_HISTORY] datetime NULL,
	[INV_HIST_TIME] [char](8) NULL,
	[DATE_ACTION] datetime NULL,
	[QUANTITY] [numeric](15, 6) NULL,
	[COST] [numeric](16, 6) NULL,
	[NEW_ONHAND] [numeric](15, 6) NULL,
	[OLD_ONHAND] [numeric](15, 6) NULL,
	[OLD_INV_COST] [numeric](16, 6) NULL,
	[NEW_INV_COST] [numeric](16, 6) NULL,
	[COST_MATERIAL] [numeric](16, 6) NULL,
	[COST_LABOR] [numeric](16, 6) NULL,
	[COST_OVERHEAD] [numeric](16, 6) NULL,
	[OUTS_COST] [numeric](16, 6) NULL,
	[FREIGHT_COST] [numeric](16, 6) NULL,
	[OTHER_COST] [numeric](16, 6) NULL,
	[MATL_VAR] [numeric](16, 6) NULL,
	[LABR_VAR] [numeric](16, 6) NULL,
	[OVHD_VAR] [numeric](16, 6) NULL,
	[OUTS_VAR] [numeric](16, 6) NULL,
	[FRGT_VAR] [numeric](16, 6) NULL,
	[OTH_VAR] [numeric](16, 6) NULL,
	[OLD_MATL] [numeric](16, 6) NULL,
	[OLD_LABR] [numeric](16, 6) NULL,
	[OLD_OVHD] [numeric](16, 6) NULL,
	[OLD_OUTS] [numeric](16, 6) NULL,
	[OLD_FRGT] [numeric](16, 6) NULL,
	[OLD_OTH] [numeric](16, 6) NULL,
	[NEW_MATL] [numeric](16, 6) NULL,
	[NEW_LABR] [numeric](16, 6) NULL,
	[NEW_OVHD] [numeric](16, 6) NULL,
	[NEW_OUTS] [numeric](16, 6) NULL,
	[NEW_FRGT] [numeric](16, 6) NULL,
	[NEW_OTH] [numeric](16, 6) NULL,
	[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO


