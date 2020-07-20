CREATE TABLE [dwstage].[WORKGROUP_HEAD](
	[WORK_GROUP] [char](4) NULL,
	[DESCR] [char](20) NULL,
	[PROTOTYPE_WC] [char](4) NULL,
	[TYPE] [numeric](1, 0) NULL,
	[NESTING] [numeric](1, 0) NULL,
	[FILLER] [char](99) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO