CREATE TABLE [dwstage].[SALESPERSONS](
	[SalespersonID] [char](3) NULL,
	[NAME] [char](50) NULL,
	[EMAIL] [char](80) NULL,
	[FILLER] [char](20) NULL,
	[LAST_DATE_CHG] [char](8) NULL,
	[LAST_TIME_CHG] [char](8) NULL,
	[LAST_USER_CHG] [char](8) NULL,
	[LAST_PRGM_CHG] [char](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
)