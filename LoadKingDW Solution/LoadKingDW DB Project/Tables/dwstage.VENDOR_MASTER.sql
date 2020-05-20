-- USE [LK-GS-EDW]
--GO


CREATE TABLE dwstage.VENDOR_MASTER
(
	[VENDOR] [char](6) NULL,
	[RESV] [char](1) NULL,
	[REC] [char](1) NULL,
	[NAME_VENDOR] [char](30) NULL,
	[ADDRESS1] [char](30) NULL,
	[ADDRESS2] [char](30) NULL,
	[CITY] [char](20) NULL,
	[STATE] [char](2) NULL,
	[CODE_ZIP] [char](13) NULL,
	[COUNTRY] [char](12) NULL,
	[COUNTY] [char](12) NULL,
	[ATTENTION] [char](30) NULL,
	[BUYER] [char](3) NULL,
	[TERRITORY] [char](2) NULL,
	[CODE_AREA] [char](2) NULL,
	[FILL_PHONE] [char](13) NULL,
	[NORMAL_GL_ACCOUNT] [char](15) NULL,
	[CODE_SORT] [char](12) NULL,
	[CODE_SORT_2] [char](12) NULL,
	[OTHER] [char](20) NULL,
	[FLAG_MISC_VENDOR] [char](1) NULL,
	[INTERCOMPANY] [char](1) NULL,
	[INTL_ADRS] [char](1) NULL,
	[TAX1] [char](3) NULL,
	[TAX2] [char](3) NULL,
	[TAX3] [char](3) NULL,
	[TAX4] [char](3) NULL,
	[TAX_STATE] [char](2) NULL,
	[TAX_ZIP] [char](13) NULL,
	[RECEIPT_TO_INVC] [char](1) NULL,
	[FILLER] [char](3) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


