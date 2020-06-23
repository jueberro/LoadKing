﻿CREATE TABLE dw.LkpJobOperationsHist
(
--------------------------------------------------------
	[HEADER_JOB] [char](6) NULL,
	[HEADER_SUFFIX] [char](3) NULL,
	[HEADER_PART] [char](20) NULL,
	[HEADER_PRODUCT_LINE] [char](2) NULL,
	[HEADER_SALESPERSON] [char](3) NULL,
	[HEADER_CUSTOMER] [char](6) NULL,
	[HEADER_SALES_ORDER] [char](7) NULL,
	[HEADER_SALES_ORDER_LINE] [char](3) NULL,
	[JOB] [varchar](50) NULL,
	[SUFFIX] [varchar](50) NULL,
	[SEQ] [varchar](50) NULL,
	[PROJ_GROUP] [varchar](50) NULL,
	[OPERATION] [varchar](50) NULL,
	[LMO] [varchar](50) NULL,
	[DESCRIPTION] [varchar](50) NULL,
	[UM] [varchar](50) NULL,
	[PART] [varchar](50) NULL,
	[ROUTER] [varchar](50) NULL,
	[ROUTER_SEQ] [varchar](50) NULL,
	[FLAG_CLOSED] [varchar](50) NULL,
	[TIME_START] [varchar](50) NULL,
	[MACHINE_HOURS] [varchar](50) NULL,
	[TIME_ELAPSED] [varchar](50) NULL,
	[FACTOR_WORKCENTER] [varchar](50) NULL,
	[SEQ_PO] [varchar](50) NULL,
	[PO_ASSIGNED] [varchar](50) NULL,
	[MAIN_COMMENT] [varchar](50) NULL,
	[WORK_STARTED] [varchar](50) NULL,
	[HOLD_PO] [varchar](50) NULL,
-----------------------------------------------------
	[HEADER_DATE_OPENED] datetime NULL,
	[HEADER_DATE_DUE] datetime NULL,
	[HEADER_DATE_CLOSED] datetime NULL,
	[HEADER_DATE_START] datetime NULL,
	[DATE_START] datetime NULL,
	[DATE_DUE] datetime NULL,
	[DATE_MATERIAL_DUE] datetime NULL,
	[DATE_COMPLETED] datetime NULL,
	[DATE_HARD] datetime NULL,
	[DATE_OPER_ST_MDY] datetime NULL,
	[DATE_PO_ORDER] datetime NULL,
	[DATE_OPER_SK_YEAR] [varchar](50) NULL,
	[DATE_OPER_SK_MDY] datetime NULL,
	[DATE_OPER_ST_YEAR] [varchar](50) NULL,
----------------------------------------------------
	[UNITS_OPEN] [varchar](50) NULL,
	[UNITS_COMPLETE] [varchar](50) NULL,
	[SETUP] [varchar](50) NULL,
	[UNITS] [varchar](50) NULL,
	[BURDEN] [varchar](50) NULL,
	[HOURS_ESTIMATED] [varchar](50) NULL,
	[HOURS_ACTUAL] [varchar](50) NULL,
	[DOLLARS_ESTIMATED] [varchar](50) NULL,
	[DOLLARS_ACTUAL] [varchar](50) NULL,
	[YIELD] [varchar](50) NULL,
	[YIELD_RATIO] [varchar](50) NULL,
	[CREW_SIZE] [varchar](50) NULL,
	[UNIT_D6] [varchar](50) NULL,
	[LEAD_TIME] [varchar](50) NULL,
	[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO
