CREATE PROCEDURE [globalshoplanding].[GetTablesToExtract]

AS

BEGIN
	/*
		Retrieve a list of Global Shop tables from which to extract data
	*/

	SELECT	SourceTableName
			, TargetTableName
			, SourceSQLString
	FROM	globalshoplanding.ExtractConfiguration
	WHERE	ExtractEnabledFlag = 1

END
