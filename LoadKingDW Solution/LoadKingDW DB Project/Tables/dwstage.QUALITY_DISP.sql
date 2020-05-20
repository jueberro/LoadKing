-- USE [LK-GS-EDW]
--GO

CREATE TABLE dwstage.QUALITY_DISP
(
	[CONTROL_NUMBER] [char](7) NULL,
	[DISPOSITION_SEQ] [char](3) NULL,
	[QTY_DISPOSED] [numeric](14, 6) NULL,
	[DISPOSED_VALUE] [numeric](10, 2) NULL,
	[DISCREPANCY] [char](3) NULL,
	[DISPOSITION_ACTION] [char](30) NULL,
	[USER_DISPOSED_BY] [char](8) NULL,
	[DATE_DISPOSED] [char](8) NULL,
	[TIME_DISPOSED] [char](8) NULL,
	[NEW_PO_NUMBER] [char](7) NULL,
	[NEW_PO_LINE] [char](4) NULL,
	[NEW_JOB] [char](6) NULL,
	[NEW_SUFFIX] [char](3) NULL,
	[INSPECTED_BY] [char](8) NULL,
	[DATE_INSPECTED] [char](6) NULL,
	[USER1] [char](20) NULL,
	[USER2] [char](20) NULL,
	[CNC_ACTION] [char](1) NULL,
	[DATE_CNC_REQ] [char](6) NULL,
	[CNC_BY_USER] [char](8) NULL,
	[NO_GOOD_RPT] [char](1) NULL,
	[FILLER] [char](20) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


