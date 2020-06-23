CREATE TABLE [dwetl].[DWTableSource](
	[DWTableName] [nvarchar](100) NOT NULL,
	[DWTableType] [nvarchar](100) NOT NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[SourceDataSetName] [nvarchar](100) NOT NULL,
	[ODSTableName] [nvarchar](100) NULL,
	[StageTableName] [nvarchar](100) NULL,
	[SSISPackageName] [nvarchar](100) NULL,
	[StoredProcedureName] [nvarchar](100) NULL,
	[LoadDWTableFlag] [bit] NULL,
	[SysStartTime] [datetime2](7) NOT NULL,
	[SysEndTime] [datetime2](7) NOT NULL,
	[Sort] [int] NULL,
 CONSTRAINT [PK_dwetl_DWTableSource] PRIMARY KEY CLUSTERED 
(
	[DWTableName] ASC,
	[SourceSystemName] ASC,
	[SourceDataSetName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dwetl].[DWTableSource] ADD  CONSTRAINT [DF_dwetl_DWTableSource_LoadDWTableFlag]  DEFAULT ((1)) FOR [LoadDWTableFlag]
GO

ALTER TABLE [dwetl].[DWTableSource] ADD  DEFAULT ((999)) FOR [Sort]
GO