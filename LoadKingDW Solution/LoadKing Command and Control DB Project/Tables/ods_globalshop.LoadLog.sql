CREATE TABLE [ods_globalshop].[LoadLog]
(
    [LoadLogKey]				INT IDENTITY (1, 1) NOT NULL,
	[ProcessPlatformName]		NVARCHAR(100)			NULL,	-- e.g. SSIS, Data Factory, Logic App, etc
	[ProcessName]				NVARCHAR(100)			NULL,	-- e.g. Package/Pipeline name, Procore Extract App name, etc.
	[ProcessExecutionId]		UNIQUEIDENTIFIER		NULL,	-- i.e. a GUID tied to a unique instance of execution (SSIS, ADF, etc.)
    [SourceSystemName]			NVARCHAR (100)		NOT NULL,	-- e.g. Global Shop, AutoQuotes, etc.
    [SourceDataSetName]			NVARCHAR (100)		NOT NULL,	-- i.e. Table name for a relational source
    [ExecutionStatusCode]		VARCHAR (25)		NOT	NULL,	-- e.g. INPG, SUCC, FAIL
    [ExecutionStatusMessage]	NVARCHAR (1500)		NOT	NULL,
	[ExtractLowDate]			DATETIME				NULL,
    [StartDate]					DATETIME			NOT NULL,
    [EndDate]					DATETIME				NULL,

	[SourceRecordCount]			INT						NULL,

    [RecordCreateDate]			DATETIME2 (7)		NOT NULL,
    [RecordLastUpdatedDate]		DATETIME2 (7)		NOT NULL,
    [RecordCreatedByName]		NVARCHAR (100)		NOT NULL,
    [RecordLastUpdatedByName]	NVARCHAR (100)		NOT NULL,

	/*Temporal Table Requirements*/
	[SysStartTime]	DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL , 
	[SysEndTime]	DATETIME2 GENERATED ALWAYS AS ROW END	HIDDEN NOT NULL , 
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)


WITH	(
			SYSTEM_VERSIONING = ON (HISTORY_TABLE = ods_globalshop.LoadLog_history) --New or existing table
		)

GO

ALTER TABLE ods_globalshop.LoadLog
ADD CONSTRAINT [PK_ods_globalshop_LoadLog] PRIMARY KEY CLUSTERED ([LoadLogKey] ASC)

GO

ALTER TABLE ods_globalshop.LoadLog
ADD CONSTRAINT [DF_ods_globalshop_LoadLog_RecordCreateDate] DEFAULT (GETUTCDATE()) FOR [RecordCreateDate]

GO

ALTER TABLE ods_globalshop.LoadLog
ADD CONSTRAINT [DF_ods_globalshop_LoadLog_RecordLastUpdatedDate] DEFAULT (GETUTCDATE()) FOR [RecordLastUpdatedDate]

GO

ALTER TABLE ods_globalshop.LoadLog
ADD CONSTRAINT [DF_ods_globalshop_LoadLog_RecordCreatedByName] DEFAULT (SUSER_SNAME()) FOR [RecordCreatedByName]

GO

ALTER TABLE ods_globalshop.LoadLog
ADD CONSTRAINT [DF_ods_globalshop_LoadLog_RecordLastUpdatedByName] DEFAULT (SUSER_SNAME()) FOR [RecordLastUpdatedByName]

GO

