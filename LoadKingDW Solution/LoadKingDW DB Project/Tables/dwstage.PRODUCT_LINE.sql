


CREATE TABLE dwstage.PRODUCT_LINE
(
	[KEY_DATA] [char](9) NULL,
	[PRODUCT_LINE] [char](2) NULL,
	[FILLER] [char](1) NULL,
	[LINE] [char](3) NULL,
	[FILLER2] [char](5) NULL,
	[PRODUCT_LINE_DESC] [char](10) NULL,
	[PRODUCT_LINE_NAME] [char](30) NULL,
	[F_DECIMAL] [decimal](5, 4) NULL,
	[SALES_ACCOUNT] [char](15) NULL,
	[FILLER3] [char](5) NULL,
	[PURCHASING_ACCOUNT] [char](15) NULL,
	[ACCT_REST] [char](5) NULL,
	[PULL_FROM_STOCK] [char](1) NULL,
	[APPLY_MATL_OVHD] [char](1) NULL,
	[MFG_PART_AUTO_WO] [char](1) NULL,
	[NESTING_INTERFACE] [char](1) NULL,
	[NO_VAR_PO_RCPTS] [char](1) NULL,
	[ISSUE_LOT_COST_STD] [char](1) NULL,
	[NO_VAR_WIP_TO_FG] [char](1) NULL,
	[FILLER4] [char](10) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


