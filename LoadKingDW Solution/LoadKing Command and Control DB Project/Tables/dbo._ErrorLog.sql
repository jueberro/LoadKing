

CREATE TABLE [dbo].[_Errorlog](
	[Batch] [int] NULL,
	[Tbl1Nbr] [int] NULL,
	[Tbl1Name] [nvarchar](255) NULL,
	[ErrorProc] [nvarchar](255) NULL,
	[ETLStarted] [datetime] NULL,
	[ErrorDateTime] [datetime] NULL,
	[ErrorLine] [int] NULL,
	[ErrorNum] [int] NULL,
	[ErrorMsg] [nvarchar](255) NULL,
	[Var1name] [nvarchar](255) NULL,
	[Var1Val] [nvarchar](255) NULL,
	[Var2Name] [nvarchar](255) NULL,
	[Var2Val] [nvarchar](255) NULL,
	[Var3Name] [nvarchar](255) NULL,
	[Var3Val] [nvarchar](255) NULL,
	[Code] [nvarchar](255) NULL,
	[ServerName] [nvarchar](255) NULL,
	[DBname] [nvarchar](255) NULL,
	[WinUsername] [nvarchar](255) NULL,
	[SqlUsername] [nvarchar](255) NULL,
	[Procname] [nvarchar](255) NULL,
	[Tbl2Nbr] [int] NULL,
	[Tbl2Name] [nvarchar](255) NULL
) ON [PRIMARY]
GO

