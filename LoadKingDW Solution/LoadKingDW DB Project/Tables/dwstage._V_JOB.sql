--USE [LK-GS-EDW]
--GO



CREATE TABLE dwstage._V_JOB
(
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
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[SEQ] [char](6) NULL,
	[SEQUENCE_KEY] [char](4) NULL,
	[EMPLOYEE] [char](30) NULL,
	[DESCRIPTION] [char](30) NULL,
	[DEPT_WORKCENTER] [char](4) NULL,
	[RATE_WORKCENTER] [numeric](10, 4) NULL,
	[DEPT_EMP] [char](4) NULL,
	[MACHINE] [char](4) NULL,
	[PART] [char](20) NULL,
	[REFERENCE] [char](15) NULL,
	[LMO] [char](1) NULL,
	[RATE_TYPE] [char](1) NULL,
	[LOCATION] [char](2) NULL,
	[SHIFT_SHIFT] [char](1) NULL,
	[SHIFT_DEPT] [char](4) NULL,
	[SHIFT_GROUP] [char](8) NULL,
	[HEADER_DATE_OPENED] [char](6) NULL,
	[HEADER_DATE_DUE] [char](6) NULL,
	[HEADER_DATE_CLOSED] [char](6) NULL,
	[HEADER_DATE_START] [char](6) NULL,
	[DATE_SEQUENCE] [char](6) NULL,
	[CHARGE_DATE] [char](8) NULL,
	[DATE_OUT] [char](6) NULL,
	[DATE_LAST_CHG] [char](8) NULL,
	[RATE_EMPLOYEE] [numeric](10, 4) NULL,
	[HOURS_WORKED] [numeric](12, 4) NULL,
	[PIECES_SCRAP] [numeric](12, 4) NULL,
	[PIECES_COMPLTD] [numeric](12, 4) NULL,
	[AMOUNT_LABOR] [numeric](10, 2) NULL,
	[AMT_OVERHEAD] [numeric](10, 2) NULL,
	[AMT_STANDARD] [numeric](10, 2) NULL,
	[AMT_SCRAP] [numeric](10, 2) NULL,
	[MACHINE_HRS] [numeric](12, 4) NULL,
	[MULTIPLE_FRACTION] [numeric](6, 5) NULL,
	[START_TIME] [char](4) NULL,
	[END_TIME] [char](4) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


