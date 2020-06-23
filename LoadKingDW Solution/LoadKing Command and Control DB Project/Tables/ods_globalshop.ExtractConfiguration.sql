CREATE TABLE [ods_globalshop].[ExtractConfiguration](
	[SourceTableName] [nvarchar](100) NOT NULL,
	[TargetTableName] [nvarchar](100) NOT NULL,
	[SourceSQLString] [nvarchar](4000) NULL,
	[ExtractEnabledFlag] [bit] NULL,
	[SysStartTime] [datetime2](7) NOT NULL,
	[SysEndTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ods_globalshop_ExtractConfiguration] PRIMARY KEY CLUSTERED 
(
	[SourceTableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
