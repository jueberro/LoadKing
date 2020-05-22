--USE [LK-GS-EDW]
--GO


CREATE TABLE dw.FactQualityDisposition
(
	[DimWorkOrder_Key] [int] NOT NULL,
	[DimCustomer_Key] [int] NOT NULL,
	[DimVendor_Key] [int] NOT NULL,
	[DimInventory_Key] [int] NOT NULL,
	[DimEmployee_Key] [int] NOT NULL,
	[DimDepartmentEmployee_Key] [int] NOT NULL,
	[DimDepartmentWorkCenter_Key] [int] NOT NULL,
	[DimDate_Key] [int] NOT NULL,
	[Header_CONTROL_NUMBER] [char](7) NULL,
	[Header_JOB] [char](6) NULL,
	[Header_SUFFIX] [char](3) NULL,
	[Header_SEQUENCE] [char](6) NULL,
	[CONTROL_NUMBER] [char](7) NULL,
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
	[Header_DATE_QUALITY] [date] NULL,
	[Header_DATE_ENTERED] [date] NULL,
	[Header_F_DATE] [date] NULL,
	[Header_CLOSE_DATE] [date] NULL,
	[DATE_DISPOSED] [date] NULL,
	[TIME_DISPOSED] [char](8) NULL,
	[DATE_INSPECTED] [date] NULL,
	[DATE_CNC_REQ] [date] NULL,
	[QTY_DISPOSED] [numeric](14, 6) NULL,
	[DISPOSED_VALUE] [numeric](10, 2) NULL,
	[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO

