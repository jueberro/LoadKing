﻿CREATE TABLE [dbo].[GL_MASTER](
	[GL_ACCOUNT] [char](15) NULL,
	[DESCR] [char](30) NULL,
	[DEPT] [char](4) NULL,
	[RETAINED_ACCT] [char](15) NULL,
	[ACCT_TYPE] [char](2) NULL,
	[ACCT_CAT] [char](2) NULL,
	[FILLER2] [char](2) NULL,
	[MATL_POOL] [char](1) NULL,
	[OH_POOL] [char](5) NULL,
	[ZERO_AT_YR_END] [char](1) NULL,
	[USER_1] [char](30) NULL,
	[USER_2] [char](30) NULL,
	[USER_3] [char](30) NULL,
	[USER_4] [char](30) NULL,
	[USER_5] [char](30) NULL,
	[INACTIVE_DATE] [char](8) NULL,
	[COST_POOL] [char](5) NULL,
	[FILLER] [char](195) NULL,
	[LAST_DATE_CHG] [char](8) NULL,
	[LAST_TIME_CHG] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[LAST_CHG_PGM] [char](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]