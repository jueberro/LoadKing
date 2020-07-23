--USE [LK-GS-ODS]
--GO


CREATE TABLE dbo.GL_BALANCES
(
	[FISCAL_YR] [char](4) NULL,
	[TYPE] [char](1) NULL,
	[ACCT] [char](15) NULL,
	[COMP9_START_YR] [numeric](4, 0) NULL,
	[BEG_BAL] [numeric](13, 2) NULL,
	[FILLER] [char](100) NULL,
	[LAST_CHG_DATE] [char](8) NULL,
	[LAST_CHG_TIME] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[LAST_CHG_PGM] [char](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


