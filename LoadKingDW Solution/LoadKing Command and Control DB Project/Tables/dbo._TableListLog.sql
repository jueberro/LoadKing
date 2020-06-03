
CREATE TABLE [dbo].[_TablelistLog](
	[TableNbr] [int] NOT NULL,
	[TABLE_CAT] [nvarchar](255) NULL,
	[TABLE_SCHEM] [nvarchar](255) NULL,
	[TABLE_NAME] [nvarchar](255) NULL,
	[TABLE_TYPE] [nvarchar](255) NULL,
	[REMARKS] [nvarchar](255) NULL,
	[VIEW_NAME] [nvarchar](255) NULL,
	[SourceStoredproc] [nvarchar](255) NULL,
	[ETL_Start] [datetime] NULL,
	[ETL_Completed] [datetime] NULL,
	[Status] [nvarchar](255) NULL,
	[Recordcount] [int] NULL,
	[CurRunFlag] [nvarchar](255) NULL,
	[RunPriority] [int] NULL,
	[MasterRunFlag] [nvarchar](255) NULL,
	[LastBatch] [int] NULL,
	[ServerName] [nvarchar](255) NULL,
	[DBname] [nvarchar](255) NULL,
	[WinUsername] [nvarchar](255) NULL,
	[SqlUsername] [nvarchar](255) NULL,
	[Procname] [nvarchar](255) NULL
) ON [PRIMARY]
GO


