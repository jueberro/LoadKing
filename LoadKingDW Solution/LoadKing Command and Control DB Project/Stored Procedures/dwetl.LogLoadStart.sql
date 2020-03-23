CREATE PROCEDURE [dwetl].[LogLoadStart]
		  @PipelineName				NVARCHAR(100)
		, @PipelineExecutionID		UNIQUEIDENTIFIER
		, @DWTableName				NVARCHAR(100)
		, @SourceSystemName			NVARCHAR(100)
		, @SourceDataSetName		NVARCHAR(100)
		, @SourceLoadLogKey			INT

		, @DWStageTableName			NVARCHAR(100)
		--, @LoadLogKey				INT	OUTPUT
AS

BEGIN
	/*
		This procedure logs the start of processing a data batch from 
		The ODS into a DW table.
	*/

	/*
		- @PipelineName			- Name of Pipeline executing procedure
		- @PipelineExecutionID	- GUID passed from Azure Data Factory/SSIS
		- @DWTableName			- Name of DW table to be loaded includging schema (e.g. dw.DimCustomer)
		- @SourceSystemName		- e.g. Global Shop, etc.
		- @SourceDataSetName	- e.g. Customer, Employee, SalesOrder
		- @SourceLoadLogKey		- BatchID of ODS data to be loaded into DW table

		- This procedure runs at the beginning of a pipeline execution to
		  record a new instance of a DW table load.  It returns one row
		  of data with the following fields.
			- LoadLogKey		- Used downstream to update newly created log record

	*/
	DECLARE @LoadLogKey			INT
	DECLARE @PreviousLoadLogKey INT
	DECLARE @Message			NVARCHAR(500)

	-- Check to see if all previous records have EndDate (i.e. the process is finished)
	SELECT	TOP 1 @PreviousLoadLogKey = LoadLogKey
	FROM	dwetl.LoadLog
	WHERE	DWTableName = @DWTableName
	 AND	SourceDataSetName = @SourceDataSetName
	 AND	ExecutionStatusCode = 'INPG'
	 AND	EndDate IS NULL
		
	IF @PreviousLoadLogKey IS NOT NULL
	BEGIN
		SET @Message = 'A dwetl.LoadLog record for ' + @DWTableName + ' is still In Progress.  EndDate must be set for LoadLogKey ' + CAST(@PreviousLoadLogKey AS NVARCHAR(100)) + '.'
		RAISERROR(@Message, 16, 1)
		RETURN
	END

	-- Create a new entry for the current execution
	INSERT INTO dwetl.LoadLog ([DWTableName]
							, [SourceSystemName]
							, [SourceDataSetName]
							, [SourceLoadLogKey]
							, [ExecutionStatusCode]
							, [ExecutionStatusMessage]
							, [StartDate]
						)
	SELECT	  [DWTableName]				= @DWTableName
			, [SourceSystemName]		= @SourceSystemName
			, [SourceDataSetName]		= @SourceDataSetName
			, [SourceLoadLogKey]		= @SourceLoadLogKey
			, [ExecutionStatusCode]		= 'INPG'
			, [ExecutionStatusMessage]	= 'In Progress.'
			, [StartDate]				= GETUTCDATE()
			
	SELECT @LoadLogKey = @@IDENTITY


	-- Return one row result set to used in pipeline
	SELECT	  LoadLogKey			= @LoadLogKey
			, DWStageTableName		= @DWStageTableName --only used as pass-through to ADF, not used for logging

END


