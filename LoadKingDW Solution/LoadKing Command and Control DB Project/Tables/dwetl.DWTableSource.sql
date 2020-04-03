CREATE TABLE [dwetl].[DWTableSource]
(
	[DWTableName]				NVARCHAR(100)		NOT NULL,
	[DWTableType]				NVARCHAR(100)		NOT NULL,
	[SourceSystemName]			NVARCHAR(100)		NOT NULL,
	[SourceDataSetName]			NVARCHAR(100)		NOT NULL,
	[SourceSQLString]			NVARCHAR(4000)			NULL,
	[StageTableName]			NVARCHAR(400)			NULL,
	[SSISPackageName]			NVARCHAR(100)			NULL,
	[StoredProcedureName]		NVARCHAR(100)			NULL,
	[LoadDWTableFlag]			BIT						NULL, -- A switch to enable/diable a table load

	/*Temporal Table Requirements*/
	[SysStartTime]	DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL , 
	[SysEndTime]	DATETIME2 GENERATED ALWAYS AS ROW END	HIDDEN NOT NULL , 
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH	(
			SYSTEM_VERSIONING = ON (HISTORY_TABLE = dwetl.DWTableSource_history) --New or existing table
		)


GO

ALTER TABLE dwetl.DWTableSource
ADD CONSTRAINT [PK_dwetl_DWTableSource] PRIMARY KEY ([DWTableName], [SourceSystemName], [SourceDataSetName])

GO

ALTER TABLE dwetl.DWTableSource
ADD CONSTRAINT [DF_dwetl_DWTableSource_LoadDWTableFlag] DEFAULT (1) FOR LoadDWTableFlag
