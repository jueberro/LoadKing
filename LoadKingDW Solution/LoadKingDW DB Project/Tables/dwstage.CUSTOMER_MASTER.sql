CREATE TABLE [dwstage].[CUSTOMER_MASTER](
	[CUSTOMER] [char](255) NULL,
	[REC] [char](255) NULL,
	[NAME_CUSTOMER] [char](255) NULL,
	[ADDRESS1] [char](255) NULL,
	[ADDRESS2] [char](255) NULL,
	[CITY] [char](255) NULL,
	[STATE] [char](255) NULL,
	[ZIP] [char](255) NULL,
	[COUNTRY] [char](255) NULL,
	[COUNTY] [char](255) NULL,
	[ATTENTION] [char](255) NULL,
	[SALESPERSON] [char](255) NULL,
	[INTL_ADDR] [char](255) NULL,
	[TERRITORY] [char](255) NULL,
	[CODE_AREA] [char](255) NULL,
	[CREDIT] [char](255) NULL,
	[TELEPHONE] [char](255) NULL,
	[FILLER] [char](255) NULL,
	[CRM_RES_LEV] [numeric](1, 0) NULL,
	[ASSGN_USR_GRP] [char](255) NULL,
	[NORMAL_GL_ACCOUNT] [char](255) NULL,
	[FLAG_BALANCE_FWD] [char](255) NULL,
	[FLAG_PRINT_STATE] [char](255) NULL,
	[FLAG_CREDIT_HOLD] [char](255) NULL,
	[FILLER2] [char](255) NULL,
	[CHANGE_MODE] [char](255) NULL,
	[INTERCOMPANY] [char](255) NULL,
	[ETL_TblNbr] [int] NOT NULL,
	[ETL_Batch] [int] NOT NULL,
	[ETL_Completed] [datetime] NOT NULL
) ON [PRIMARY]
GO



