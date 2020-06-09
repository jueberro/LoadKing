CREATE PROCEDURE [dwetl].[GetDWTableConfigInfo] @DWTableType NVARCHAR(100)

AS

BEGIN
	/*
		- Executed by SSIS Package to return list of source and target info
		  to be processed.  Process is designed to run all dimensions, followed
		  by all facts.
		- Output of this procedure will be used in a ForEach activity to loop
		  through a list of dimensions or facts to process.

	*/

	/*
		Parameters
		- @TableType - Dimension, Fact, Lookup
	*/

	SELECT  ds.DWTableName
		  , ds.SourceSystemName
		  , ds.SourceDataSetName
		  , ds.SSISPackageName
	FROM	dwetl.DWTableSource ds
	LEFT JOIN dwetl.DWTableSourceSort dsd
	ON  ds.DWTableName = dsd.DWTableName
	WHERE	ds.DWTableType = @DWTableType
	 AND	LoadDWTableFlag = 1			-- Used primarily during testing to enable/disable loads
	Order By dsd.Sort

END

