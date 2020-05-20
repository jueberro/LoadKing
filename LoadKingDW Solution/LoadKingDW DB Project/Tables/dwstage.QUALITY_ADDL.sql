-- USE [LK-GS-EDW]
--GO


CREATE TABLE dwstage.QUALITY_ADDL
(
	[CONTROL_NUM] [char](7) NULL,
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[SEQ] [char](6) NULL,
	[FILL1] [char](1) NULL,
	[F_DATE] [char](6) NULL,
	[KEY_SEQ] [char](4) NULL,
	[EMPLOYEE] [char](5) NULL,
	[EMPL_DEPT] [char](4) NULL,
	[EMPL_NAME] [char](30) NULL,
	[WC] [char](4) NULL,
	[OP_CODE] [char](6) NULL,
	[DATE_ENTERED] [char](8) NULL,
	[TIME_ENTERED] [char](8) NULL,
	[CLOSED] [numeric](1, 0) NULL,
	[CLOSED_BY] [char](8) NULL,
	[CLOSE_DATE] [date] NULL,
	[FILLER] [char](189) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


