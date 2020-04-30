USE [LK-GS-EDW]
GO

CREATE TABLE dwstage.JOB_DETAIL
(
	[JOB] [char](6) NULL,
	[SUFFIX] [char](3) NULL,
	[SEQ] [char](6) NULL,
	[FILL] [char](1) NULL,
	[DATE_SEQUENCE] [char](6) NULL,
	[SEQUENCE_KEY] [char](4) NULL,
	[EMPLOYEE] [char](30) NULL,
	[DESCRIPTION] [char](30) NULL,
	[DEPT_WORKCENTER] [char](4) NULL,
	[RATE_WORKCENTER] [numeric](10, 4) NULL,
	[DEPT_EMP] [char](4) NULL,
	[RATE_EMPLOYEE] [numeric](10, 4) NULL,
	[TRAN] [numeric](2, 0) NULL,
	[IDENTIFIER] [char](20) NULL,
	[EMPL] [char](5) NULL,
	[MACHINE] [char](4) NULL,
	[PART] [char](20) NULL,
	[FILL_PART] [char](18) NULL,
	[HOURS_WORKED] [numeric](12, 4) NULL,
	[FLAG_OPT] [char](1) NULL,
	[PIECES_SCRAP] [numeric](12, 4) NULL,
	[PIECES_COMPLTD] [numeric](12, 4) NULL,
	[AMOUNT_LABOR] [numeric](10, 2) NULL,
	[AMT_OVERHEAD] [numeric](10, 2) NULL,
	[AMT_STANDARD] [numeric](10, 2) NULL,
	[REFERENCE] [char](15) NULL,
	[FLAG_CLOSED] [char](1) NULL,
	[UM] [char](2) NULL,
	[FLAG_INDIRECT] [char](1) NULL,
	[LMO] [char](1) NULL,
	[RATE_TYPE] [char](1) NULL,
	[AMT_SCRAP] [numeric](10, 2) NULL,
	[LOCATION] [char](2) NULL,
	[QTY_COMMITTED] [numeric](14, 4) NULL,
	[AMT_COMMITTED] [numeric](14, 2) NULL,
	[LINE_BILLED] [char](1) NULL,
	[BILL_DATE] [char](8) NULL,
	[QUALITY_NUMBER] [char](7) NULL,
	[DTL_TYPE_FLAG] [char](1) NULL,
	[EDITED_WO_DTL] [char](1) NULL,
	[START_MIN] [numeric](12, 4) NULL,
	[END_MIN] [numeric](12, 4) NULL,
	[SCRAP_REASON] [char](2) NULL,
	[CREW_ID] [char](4) NULL,
	[SPECIAL_OVHD] [char](1) NULL,
	[FILLER] [char](13) NULL,
	[MACHINE_HRS] [numeric](12, 4) NULL,
	[TYPE_TIME] [char](1) NULL,
	[BALANCED_AS_DATE] [char](8) NULL,
	[MULTIPLE_FLAG] [char](1) NULL,
	[CHARGE_DATE] [char](8) NULL,
	[LUNCH_TAKEN] [char](1) NULL,
	[BRK1_TAKEN] [char](1) NULL,
	[BRK2_TAKEN] [char](1) NULL,
	[BRK3_TAKEN] [char](1) NULL,
	[BRK4_TAKEN] [char](1) NULL,
	[MULTIPLE_FRACTION] [numeric](6, 5) NULL,
	[MATL_AMT_CLS] [numeric](10, 2) NULL,
	[LABR_AMT_CLS] [numeric](10, 2) NULL,
	[OVHD_AMT_CLS] [numeric](10, 2) NULL,
	[START_TIME] [char](4) NULL,
	[END_TIME] [char](4) NULL,
	[DATE_OUT] [char](6) NULL,
	[RATE_SCALE] [char](2) NULL,
	[EARNINGS_CODE] [char](2) NULL,
	[LBR_BATCH_NO] [char](5) NULL,
	[LBR_FILE_STAT] [char](1) NULL,
	[SHIFT_SHIFT] [char](1) NULL,
	[SHIFT_DEPT] [char](4) NULL,
	[SHIFT_GROUP] [char](8) NULL,
	[NEG_WIP_FG_DONE] [char](1) NULL,
	[EXPORTED] [char](1) NULL,
	[EDIT_NOT_ALLOWED] [char](1) NULL,
	[EDITED_FOR_OT] [char](1) NULL,
	[LTLQL_ID] [numeric](9, 0) NULL,
	[NEG_ISSUE_DONE] [char](1) NULL,
	[ABSENCE] [char](1) NULL,
	[PAID] [char](1) NULL,
	[EXCUSED] [char](1) NULL,
	[SCRAP_RECS_EXIST] [numeric](1, 0) NULL,
	[PAYROLL_LOCK] [bit] NULL,
	[WIP_TO_FG_QTY] [numeric](12, 4) NULL,
	[OUTS_AMT_CLS] [numeric](10, 2) NULL,
	[FRGT_AMT_CLS] [numeric](10, 2) NULL,
	[OTH_AMT_CLS] [numeric](10, 2) NULL,
	[FILLER2] [char](29) NULL,
	[DATE_LAST_CHG] [char](8) NULL,
	[TIME_LAST_CHG] [char](8) NULL,
	[LAST_CHG_BY] [char](8) NULL,
	[LAST_CHG_PROG] [char](8) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


