﻿CREATE TABLE [dwstage].[_V_Quality](
	[CONTROL_NUMBER] [char](7) NULL,
	[JOB] [char](6) NULL,
	[JOB_SUFFIX] [char](3) NULL,
	[JOB_DATE_OPENED] [char](6) NULL,
	[SEQUENCE] [char](6) NULL,
	[KEY_SEQ] [char](4) NULL,
	[PO_LINE] [char](4) NULL,
	[CUSTOMER_PO] [char](20) NULL,
	[SCRAP_CODE] [char](2) NULL,
	[ORIGINATOR] [char](8) NULL,
	[DATE_QUALITY] [char](6) NULL,
	[DATE_ENTERED] [char](8) NULL,
	[TIME_ENTERED] [char](8) NULL,
	[F_DATE] [char](6) NULL,
	[CLOSE_DATE] [date] NULL,
	[CUSTOMER] [nchar](6) NULL,
	[PART] [char](20) NULL,
	[EMPLOYEE] [char](5) NULL,
	[EMPLOYEE_DEPT] [char](4) NULL,
	[WORKCENTER] [char](4) NULL,
	[QTY_REJECTED] [numeric](14, 6) NULL,
	[ORIG_SCRAP_VALUE] [numeric](12, 2) NULL,
	[QTY_REMAINING] [numeric](14, 6) NULL,
	[REMAINING_VALUE] [numeric](12, 2) NULL,
	[UNIT_COST_MATL] [numeric](16, 6) NULL,
	[UNIT_COST_LABOR] [numeric](16, 6) NULL,
	[UNIT_COST_OVHD] [numeric](16, 6) NULL,
	[UNIT_COST_OUTSIDE] [numeric](16, 6) NULL,
	[FREIGHT_COST] [numeric](16, 6) NULL,
	[OTHER_COST] [numeric](16, 6) NULL,
	[CONV_FACTOR] [numeric](11, 5) NULL,
	[ETL_TablNbr] [int] NOT NULL,
	[ETL_Batch] [int] NOT NULL,
	[ETL_Completed] [datetime] NOT NULL
) ON [PRIMARY]
GO