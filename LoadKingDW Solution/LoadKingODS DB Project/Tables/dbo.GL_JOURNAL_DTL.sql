--USE [LK-GS-ODS]
--GO



CREATE TABLE dbo.GL_JOURNAL_DTL
(
	[GL_NUMBER] [char](15) NULL,
	[POST_DATE] [char](8) NULL,
	[BATCH] [char](5) NULL,
	[LINE] [numeric](5, 0) NULL,
	[SEQ] [numeric](8, 0) NULL,
	[POST_DATE_SQL] [date] NULL,
	[TRANS_DATE] [char](8) NULL,
	[TRANS_DATE_SQL] [date] NULL,
	[REVERSE_FLAG] [bit] NULL,
	[REVERSE_DATE] [char](8) NULL,
	[REVERSE_DATE_SQL] [date] NULL,
	[PERIOD] [numeric](2, 0) NULL,
	[PERIOD_BEG_DATE_SQL] [date] NULL,
	[PERIOD_END_DATE_SQL] [date] NULL,
	[REFERENCE] [char](15) NULL,
	[DESCRIPTION] [char](30) NULL,
	[VOUCHER] [char](7) NULL,
	[DB_CR_FLAG] [bit] NULL,
	[AMOUNT_CMPNY] [numeric](16, 2) NULL,
	[TYPE] [numeric](2, 0) NULL,
	[DATA_CNV_FLAG] [numeric](2, 0) NULL,
	[ASSET] [char](6) NULL,
	[THIRTEENTH_FLAG] [bit] NULL,
	[USERID] [char](8) NULL,
	[DEPT] [char](4) NULL,
	[BRANCH] [char](2) NULL,
	[EXPORT_TO_EXT_SYS] [bit] NULL,
	[INCL_IN_VAT_RPT] [bit] NULL,
	[VAT_BOX] [char](2) NULL,
	[FILLER] [char](50) NULL,
	[TRMNL] [char](3) NULL,
	[LAST_CHG_DATE] [date] NULL,
	[LAST_CHG_TIME] [time](0) NULL,
	[LAST_CHG_PGM] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


