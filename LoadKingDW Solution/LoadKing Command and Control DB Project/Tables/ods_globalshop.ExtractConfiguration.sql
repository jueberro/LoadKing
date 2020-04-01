CREATE TABLE [ods_globalshop].[ExtractConfiguration]
(
	[SourceTableName]			NVARCHAR(100)		NOT NULL,
	[TargetTableName]			NVARCHAR(100)		NOT NULL,
	[SourceSQLString]			NVARCHAR(4000)			NULL,
	[ExtractEnabledFlag]		BIT						NULL, -- A switch to enable/diable a table load
    
	/*Temporal Table Requirements*/
	[SysStartTime]	DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL , 
	[SysEndTime]	DATETIME2 GENERATED ALWAYS AS ROW END	HIDDEN NOT NULL , 
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime),
	
	CONSTRAINT [PK_ods_globalshop_ExtractConfiguration] PRIMARY KEY ([SourceTableName])
)

WITH	(
			SYSTEM_VERSIONING = ON (HISTORY_TABLE = ods_globalshop.ExtractConfiguration_history) --New or existing table
		)

GO

