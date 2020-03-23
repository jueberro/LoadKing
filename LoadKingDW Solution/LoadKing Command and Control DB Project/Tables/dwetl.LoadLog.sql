CREATE TABLE [dwetl].[LoadLog] (
    [LoadLogKey]				INT IDENTITY (1, 1) NOT NULL,
	[DWTableName]				NVARCHAR(100)			NULL,	
	[SourceSystemName]			NVARCHAR (100)		NOT NULL,
	[SourceDataSetName]			NVARCHAR (100)		NOT NULL,
	[SourceLoadLogKey]			INT					NOT NULL,

    [ExecutionStatusCode]		VARCHAR (25)		NOT	NULL,
    [ExecutionStatusMessage]	NVARCHAR (1500)		NOT	NULL,

	[StartDate]					DATETIME2 (7)		NOT NULL,
    [EndDate]					DATETIME2 (7)			NULL,
	[SourceRecordsRead]			INT						NULL,
	[RowsInsertedCount]			INT						NULL,
	[RowsUpdatedCount]			INT						NULL,

    [RecordCreateDate]			DATETIME2 (7)		NOT NULL,
    [RecordLastUpdatedDate]		DATETIME2 (7)		NOT NULL,
    [RecordCreatedByName]		NVARCHAR (100)		NOT NULL,
    [RecordLastUpdatedByName]	NVARCHAR (100)		NOT NULL,
    CONSTRAINT [PK_dwetl_LoadLog] PRIMARY KEY CLUSTERED ([LoadLogKey] ASC)
)

GO

ALTER TABLE dwetl.LoadLog
ADD CONSTRAINT [DF_dwetl_LoadLog_RecordCreateDate] DEFAULT (GETUTCDATE()) FOR [RecordCreateDate]

GO

ALTER TABLE dwetl.LoadLog
ADD CONSTRAINT [DF_dwetl_LoadLog_RecordLastUpdatedDate] DEFAULT (GETUTCDATE()) FOR [RecordLastUpdatedDate]

GO

ALTER TABLE dwetl.LoadLog
ADD CONSTRAINT [DF_dwetl_LoadLog_RecordCreatedByName] DEFAULT (SUSER_SNAME()) FOR [RecordCreatedByName]

GO

ALTER TABLE dwetl.LoadLog
ADD CONSTRAINT [DF_dwetl_LoadLog_RecordLastUpdatedByName] DEFAULT (SUSER_SNAME()) FOR [RecordLastUpdatedByName]

GO


