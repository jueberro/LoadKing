﻿CREATE TABLE [dwstage].[_V_JobOperations_Hist](
	[JBMASTER_JOB] [char](6) NULL,
	[JBMASTER_SFX] [char](3) NULL,
	[JBMASTER_BOMPARENT] [bit] NULL,
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
	[PROJ_GROUP] [varchar](50) NULL,
	[SEQ_PO] [varchar](50) NULL,
	[PO_ASSIGNED] [varchar](50) NULL,
	[MAIN_COMMENT] [varchar](50) NULL,
	[WORK_STARTED] [varchar](50) NULL,
	[HOLD_PO] [varchar](50) NULL,
	[HEADER_DATE_OPENED] [char](6) NULL,
	[HEADER_DATE_DUE] [char](6) NULL,
	[HEADER_DATE_CLOSED] [char](6) NULL,
	[HEADER_DATE_START] [char](6) NULL,
	[DATE_START] [varchar](50) NULL,
	[DATE_DUE] [varchar](50) NULL,
	[DATE_MATERIAL_DUE] [varchar](50) NULL,
	[DATE_COMPLETED] [varchar](50) NULL,
	[DATE_HARD] [varchar](50) NULL,
	[DATE_OPER_ST_MDY] [varchar](50) NULL,
	[DATE_PO_ORDER] [varchar](50) NULL,
	[DATE_OPER_SK_YEAR] [varchar](50) NULL,
	[DATE_OPER_SK_MDY] [varchar](50) NULL,
	[DATE_OPER_ST_YEAR] [varchar](50) NULL,
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
	[ETL_TablNbr] [int] NOT NULL,
	[ETL_Batch] [int] NOT NULL,
	[ETL_Completed] [datetime] NOT NULL
) ON [PRIMARY]
GO

