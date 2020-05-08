--USE [LK-GS-EDW]
--GO


CREATE TABLE dwstage.DEPARTMENTS
(
	[DEPT_ID] [char](4) NULL,
	[DEPT_NAME] [char](50) NULL,
	[FILLER] [char](100) NULL,
	[LAST_DATE_CHG] [char](8) NULL,
	[LAST_TIME_CHG] [char](8) NULL,
	[LAST_USER_CHG] [char](8) NULL,
	[LAST_PRGM_CHG] [char](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


