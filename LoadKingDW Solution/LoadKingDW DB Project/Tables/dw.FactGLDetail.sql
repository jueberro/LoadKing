﻿CREATE TABLE [dw].[FactGLDetail](
	[DimDatePostDateSql_Key] [int] NOT NULL,
	[DimDateTransDateSql_Key] [int] NOT NULL,
	[DimDateInvcDateSql_Key] [int] NOT NULL,
	[DimDateInvcDueDateSql_Key] [int] NOT NULL,
	[DimDateDiscDueDateSql_Key] [int] NOT NULL,
	[DimDateLastChgDateSql_Key] [int] NOT NULL,
	[DimGLAccount_Key] [int] NOT NULL,
	[GL_NUMBER] [char](15) NULL,
	[BATCH] [char](5) NULL,
	[LINE] [numeric](5, 0) NULL,
	[SEQ] [numeric](8, 0) NULL,
	[POST_DATE_SQL] [date] NULL,
	[TRANS_DATE_SQL] [date] NULL,
	[REVERSE_FLAG] [bit] NULL,
	[REVERSE_DATE_SQL] [date] NULL,
	[PERIOD] [numeric](2, 0) NULL,
	[PERIOD_BEG_DATE_SQL] [date] NULL,
	[PERIOD_END_DATE_SQL] [date] NULL,
	[REFERENCE] [char](15) NULL,
	[DESCRIPTION] [char](30) NULL,
	[VOUCHER] [char](7) NULL,
	[DB_CR_FLAG] [bit] NULL,
	[AMOUNT_CMPNY] [numeric](16, 2) NULL,
	[APPL_TYPE] [numeric](2, 0) NULL,
	[TRAN_TYPE] [numeric](2, 0) NULL,
	[DATA_CNV_FLAG] [numeric](2, 0) NULL,
	[ASSET] [char](6) NULL,
	[PERIOD_13_FLAG] [bit] NULL,
	[USERID] [char](8) NULL,
	[DEPT] [char](4) NULL,
	[BRANCH] [char](2) NULL,
	[SYSTEM] [numeric](2, 0) NULL,
	[EXPORT_TO_EXT_SYS] [bit] NULL,
	[INCL_IN_VAT_RPT] [bit] NULL,
	[VAT_BOX] [char](2) NULL,
	[FILLER] [char](50) NULL,
	[TRMNL] [char](3) NULL,
	[LAST_CHG_DATE] [date] NULL,
	[LAST_CHG_TIME] [time](0) NULL,
	[LAST_CHG_PGM] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO