CREATE TABLE [ods_globalshop].[LoadLog](
	[LoadLogKey] [int] IDENTITY(1,1) NOT NULL,
	[ProcessPlatformName] [nvarchar](100) NULL,
	[ProcessName] [nvarchar](100) NULL,
	[ProcessExecutionId] [uniqueidentifier] NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[SourceDataSetName] [nvarchar](100) NOT NULL,
	[ExecutionStatusCode] [varchar](25) NOT NULL,
	[ExecutionStatusMessage] [nvarchar](1500) NOT NULL,
	[ExtractLowDate] [datetime] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[SourceRecordCount] [int] NULL,
	[RecordCreateDate] [datetime2](7) NOT NULL,
	[RecordLastUpdatedDate] [datetime2](7) NOT NULL,
	[RecordCreatedByName] [nvarchar](100) NOT NULL,
	[RecordLastUpdatedByName] [nvarchar](100) NOT NULL,
	[SysStartTime] [datetime2](7) NULL,
	[SysEndTime] [datetime2](7) NULL,
 CONSTRAINT [PK_ods_globalshop_LoadLog] PRIMARY KEY CLUSTERED 
(
	[LoadLogKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [ods_globalshop].[LoadLog] ADD  CONSTRAINT [DF_ods_globalshop_LoadLog_RecordCreateDate]  DEFAULT (getutcdate()) FOR [RecordCreateDate]
GO

ALTER TABLE [ods_globalshop].[LoadLog] ADD  CONSTRAINT [DF_ods_globalshop_LoadLog_RecordLastUpdatedDate]  DEFAULT (getutcdate()) FOR [RecordLastUpdatedDate]
GO

ALTER TABLE [ods_globalshop].[LoadLog] ADD  CONSTRAINT [DF_ods_globalshop_LoadLog_RecordCreatedByName]  DEFAULT (suser_sname()) FOR [RecordCreatedByName]
GO

ALTER TABLE [ods_globalshop].[LoadLog] ADD  CONSTRAINT [DF_ods_globalshop_LoadLog_RecordLastUpdatedByName]  DEFAULT (suser_sname()) FOR [RecordLastUpdatedByName]
GO
