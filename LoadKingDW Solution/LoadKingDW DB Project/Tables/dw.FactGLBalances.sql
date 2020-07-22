--USE [LK-GS-EDW]
--GO

CREATE TABLE dw.FactGLBalances
(
	[DimDateLastChgDateSql_Key]  [int] NOT NULL,
	[DimGLAccount_Key]           [int] NOT NULL,
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
	[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO


