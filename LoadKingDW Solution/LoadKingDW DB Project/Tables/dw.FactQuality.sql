--USE [LK-GS-EDW]
--GO
CREATE TABLE dw.FactQuality
(
	DimWorkOrder_Key int NOT NULL,
	[DimCustomer_Key] [int] NOT NULL,
	DimVendor_Key int NOT NULL,
	[DimInventory_Key] [int] NOT NULL,
	[DimEmployee_Key] [int] NOT NULL,
	[DimDepartmentEmployee_Key] [int] NOT NULL,
	[DimWorkCenter_Key] [int] NOT NULL,
	[DimDate_Key] [int] NOT NULL,
-----------------------------------------------------------------
	--[CUSTOMER] [char](6) NULL, -- SK
	--[VENDOR] [char](6) NULL, -- SK
	--[PART] [char](20) NULL, -- SK
	--[EMPLOYEE] [char](5) NULL, -- SK
	--[EMPLOYEE_DEPT] [char](4) NULL, -- SK
	--[WORKCENTER] [char](4) NULL,-- -- SK
-----------------------------------------------------------------
	[CONTROL_NUMBER] [char](7) NULL, -- SK -- DK
	[JOB] [char](6) NULL, -- SK -- DK
	[SUFFIX] [char](3) NULL, -- SK -- DK
    [JOB_DATE_OPENED] [char](6) NULL,
	[SEQUENCE] [char](6) NULL, -- SK -- DK
	[KEY_SEQ] [char](4) NULL, -- DK
	[PO_LINE] [char](4) NULL, -- DK
	[CUSTOMER_PO] [char](20) NULL, -- DK
	[SCRAP_CODE] [char](2) NULL, -- DK
	[ORIGINATOR] [char](8) NULL, -- DK

	[DATE_QUALITY] datetime NULL,
	[DATE_ENTERED] datetime NULL,
	[TIME_ENTERED] [char](8) NULL,
	[F_DATE] datetime NULL,
	[CLOSE_DATE] datetime NULL,

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
    [Type1RecordHash] VARBINARY(64)	NULL
) ON [PRIMARY]
GO


