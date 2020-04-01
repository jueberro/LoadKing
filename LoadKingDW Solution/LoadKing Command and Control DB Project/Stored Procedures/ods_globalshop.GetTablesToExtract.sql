CREATE PROCEDURE [ods_globalshop].[GetTablesToExtract]

AS

BEGIN
	/*
		Retrieve a list of Global Shop tables from which to extract data
	*/

	SELECT	SourceTableName
			, TargetTableName
			, SourceSQLString
	FROM	ods_globalshop.ExtractConfiguration
	WHERE	ExtractEnabledFlag = 1

END
