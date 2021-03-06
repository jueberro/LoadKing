﻿CREATE TABLE [dbo].[_V_QualityDisp](
	[CONTROL_NUMBER] [char](7) NULL,
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[DATE_OPENED] [char](6) NULL,
	[SEQUENCE] [char](6) NULL,
	[CUSTOMER] [char](6) NULL,
	[PART] [char](20) NULL,
	[EMPLOYEE] [char](5) NULL,
	[EMPLOYEE_DEPT] [char](4) NULL,
	[WORKCENTER] [char](4) NULL,
	[VENDOR] [char](6) NULL,
	[DISPOSITION_SEQ] [char](3) NULL,
	[DISCREPANCY] [char](3) NULL,
	[DISCREP_DESC] [char](20) NULL,
	[DISPOSITION_ACTION] [char](30) NULL,
	[USER_DISPOSED_BY] [char](8) NULL,
	[NEW_JOB] [char](6) NULL,
	[NEW_SUFFIX] [char](3) NULL,
	[CNC_ACTION] [char](1) NULL,
	[NO_GOOD_RPT] [char](1) NULL,
	[INSPECTED_BY] [char](8) NULL,
	[USER1] [char](20) NULL,
	[USER2] [char](20) NULL,
	[DATE_QUALITY] [char](6) NULL,
	[DATE_ENTERED] [char](8) NULL,
	[F_DATE] [char](6) NULL,
	[CLOSE_DATE] [date] NULL,
	[DATE_DISPOSED] [char](8) NULL,
	[TIME_DISPOSED] [char](8) NULL,
	[DATE_INSPECTED] [char](6) NULL,
	[DATE_CNC_REQ] [char](6) NULL,
	[QTY_DISPOSED] [numeric](14, 6) NULL,
	[DISPOSED_VALUE] [numeric](10, 2) NULL
) ON [PRIMARY]

GO


