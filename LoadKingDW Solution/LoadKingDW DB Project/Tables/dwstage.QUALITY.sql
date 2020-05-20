-- USE [LK-GS-EDW]
--GO


CREATE TABLE dwstage.QUALITY
(
	[CONTROL_NUMBER] [char](7) NULL,
	[CUSTOMER] [char](6) NULL,
	[VENDOR] [char](6) NULL,
	[NAME] [char](30) NULL,
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[SEQUENCE] [char](6) NULL,
	[QUAL_FILL] [char](1) NULL,
	[DATE_QUALITY] [char](6) NULL,
	[KEY_SEQ] [char](4) NULL,
	[PART] [char](20) NULL,
	[LOCATION] [char](2) NULL,
	[DESCRIPTION] [char](30) NULL,
	[EMPLOYEE] [char](5) NULL,
	[EMPLOYEE_DEPT] [char](4) NULL,
	[EMPLOYEE_NAME] [char](30) NULL,
	[WORKCENTER] [char](4) NULL,
	[PURCHASE_ORDER] [char](7) NULL,
	[PO_LINE] [char](4) NULL,
	[RECEIVER] [char](6) NULL,
	[CUSTOMER_PO] [char](20) NULL,
	[SCRAP_CODE] [char](2) NULL,
	[FLAG_SERIALIZE] [char](1) NULL,
	[QTY_REJECTED] [numeric](14, 6) NULL,
	[ORIG_SCRAP_VALUE] [numeric](12, 2) NULL,
	[QTY_REMAINING] [numeric](14, 6) NULL,
	[REMAINING_VALUE] [numeric](12, 2) NULL,
	[DATE_ENTERED] [char](8) NULL,
	[TIME_ENTERED] [char](8) NULL,
	[OP_CODE] [char](6) NULL,
	[UNIT_COST_MATL] [numeric](16, 6) NULL,
	[UNIT_COST_LABOR] [numeric](16, 6) NULL,
	[UNIT_COST_OVHD] [numeric](16, 6) NULL,
	[UNIT_COST_OUTSIDE] [numeric](16, 6) NULL,
	[USER1] [char](20) NULL,
	[USER2] [char](20) NULL,
	[ORIGINATOR] [char](8) NULL,
	[CUST_GEN] [char](1) NULL,
	[CREATED_FROM_INV] [char](1) NULL,
	[RESPONSIBILITY_CHGD] [char](1) NULL,
	[WO_IN_HIST] [char](1) NULL,
	[FREIGHT_COST] [numeric](16, 6) NULL,
	[OTHER_COST] [numeric](16, 6) NULL,
	[CONV_FACTOR] [numeric](11, 5) NULL,
	[FILLER] [char](39) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


