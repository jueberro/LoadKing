CREATE PROCEDURE [dwetl].[GetBatchesToProcess]
	@DWTableName			NVARCHAR(100),
	@SourceSystemName		NVARCHAR(100),
	@SourceDataSetName		NVARCHAR(100)

AS
BEGIN


	/*
		- Retrieve a list of BatchIds (LoadLogKey) from ODS Execution Log 
		  to be staged and loaded in DW table.  List is in order
		  in which extracts occurred.
	
		- Only consider previous succesful executions.

	*/

	/*
		PARAMETERS
		@DWTableName		- Name of DW table to load, including schema (i.e. dw.DimProjectRole)
		@SourceSystemName	- Name of originating data source (i.e. Global Shop, Procore, Paycom)
		@SourceDataSetName	- Name data set from source system (i.e. Pro, ProjectRole)

	*/


	SELECT	SourceLoadLogKey	= ODS.LoadLogKey
	FROM	landing.LoadLog		  AS ODS		--This view combines records from multiple log tables
	WHERE	SourceSystemName	= @SourceSystemName
		AND	SourceDataSetName	= @SourceDataSetName
		AND	ExecutionStatusCode	= 'SUCC'
		AND	ExecutionStatusMessage = 'Success.'
		AND NOT EXISTS (SELECT 1
					FROM	dwetl.LoadLog AS stage
					WHERE	DWTableName					= @DWTableName
						AND	stage.SourceSystemName		= @SourceSystemName
						AND	stage.SourceDataSetName		= @SourceDataSetName
						AND stage.SourceLoadLogKey		= ODS.LoadLogKey
						AND	stage.ExecutionStatusCode = 'SUCC') 
	ORDER BY ODS.StartDate ASC					

END
