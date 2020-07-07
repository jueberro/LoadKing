CREATE TABLE [dw].[LkpOrderChanges](
	[ORDER_NO] [char](7) NULL,
	[CHANGE_DATE] [char](8) NULL,
	[CHANGE_TIME] [char](6) NULL,
	[TERMINAL_NO] [char](3) NULL,
	[RECORD_NO] [char](4) NULL,
	[FIELD_NAME] [char](30) NULL,
	[BEFORE] [char](30) NULL,
	[AFTER] [char](30) NULL,
	[CUST_NO] [char](6) NULL,
	[SHIPTO] [char](6) NULL,
	[CUST_PO] [char](15) NULL,
	[FILLER15] [char](15) NULL,
	[SALESMAN] [char](3) NULL,
	[PART] [char](20) NULL,
	[LOCN] [char](2) NULL,
	[PROD_LINE] [char](5) NULL,
	[QTY] [numeric](13, 4) NULL,
	[FILLER81] [char](81) NULL,
	[CHANGE_USER] [char](8) NULL,
	[CHANGE_PGM] [char](8) NULL,
	[Type1RecordHash] [varbinary](64) NULL
	
 ) ON [PRIMARY]
GO