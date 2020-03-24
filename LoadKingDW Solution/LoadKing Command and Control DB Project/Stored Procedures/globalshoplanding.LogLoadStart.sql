CREATE PROCEDURE [globalshoplanding].[LogLoadStart]
		  @ProcessPlatformName		NVARCHAR(100)	= NULL
		, @ProcessName				NVARCHAR(100)
		, @ProcessExecutionId		UNIQUEIDENTIFIER
		, @SourceSystemName			NVARCHAR(100)
		, @SourceDataSetName		NVARCHAR(100)
		, @FullExtractFlag			BIT				= 0 --Incremental extract by default

AS

BEGIN
	/*
		- @ProcessPlatformName	- ADF, Logic App, etc
		- @ProcessName			- i.e. Name of SSIS package/ADF pipline
		- @ProcessExecutionId	- i.e. a GUID tied to a unique instance of execution (SSIS, ADF, etc.)
		- @SourceSystemName		- e.g. Global Shop, AutoQuotes, etc.
		- @SourceDataSetName	- table/object name, i.e. Budget
		- @TargetFileExtension	- i.e. Table name for a relational source
		- @FullExtractFlag		- e.g. 1 for Full Extract, 0 for incremental


		- This records a new instance of data extraction.  
		  It returns one row of data with the following fields.
			- LoadLogKey		- Used downstream to update newly created log record
			- ExtractLowDate	- Start date/time of previous execution, to be used as "Low" date for current execution
			- ExtractHighDate	- Start date/time of current execution, to be used as "High" date for current execution
	*/

	DECLARE @LoadLogKey			INT				
	DECLARE @ExtractLowDate		DATETIME		
	DECLARE @ExtractHighDate	DATETIME		

	DECLARE @PreviousLoadLogKey INT
	DECLARE @PreviousStartDate	DATETIME
	DECLARE @Message			NVARCHAR(500)
	DECLARE @StartDate			DATETIME2(7)
	DECLARE @JulianLowDate		NCHAR(6)
	DECLARE @JulianHighDate		NCHAR(6)


	-- Check to see if all previous records have EndDate (i.e. the process is finished)
	SELECT	TOP 1 @PreviousLoadLogKey = LoadLogKey
	FROM	globalshoplanding.LoadLog
	WHERE	SourceSystemName	= @SourceSystemName
	 AND	SourceDataSetName	= @SourceDataSetName
	 AND	ExecutionStatusCode = 'INPG'
	 AND	EndDate IS NULL
		
	IF @PreviousLoadLogKey IS NOT NULL
	BEGIN
		SET @Message = 'A log record for ' + @SourceSystemName + ' - ' + @SourceDataSetName + ' is still In Progress.  EndDate must be set for LoadLogKey ' + CAST(@PreviousLoadLogKey AS NVARCHAR(100)) + '.'
		RAISERROR(@Message, 16, 1)
		RETURN
	END

	-- Set StartDate
	SELECT @StartDate = GETUTCDATE() 


	IF @FullExtractFlag = 1
	BEGIN
		SELECT @PreviousStartDate = '1900-01-01'
	END

	ELSE

	BEGIN
		-- Get start time of previous successful exeuction
		-- Return 1900-01-01 if there are no entries for a service/data set
		SELECT	@PreviousStartDate = ISNULL(MAX(StartDate), '1900-01-01') 
		FROM	globalshoplanding.LoadLog
		WHERE	SourceSystemName	= @SourceSystemName
		 AND	SourceDataSetName	= @SourceDataSetName
		 AND	ExecutionStatusCode = 'SUCC'
	END


	-- Create a new entry for the current execution
	INSERT INTO globalshoplanding.LoadLog (
						  [ProcessPlatformName]
						, [ProcessName]
						, [ProcessExecutionId]
						, [SourceSystemName]
						, [SourceDataSetName]
						, [ExtractLowDate]
						, [ExecutionStatusCode]
						, [ExecutionStatusMessage]
						, [StartDate]

						)
	SELECT	  ProcessPlatformName		= @ProcessPlatformName
			, ProcessName				= @ProcessName
			, ProcessExecutionID		= @ProcessExecutionId
			, SourceSystemName			= @SourceSystemName
			, SourceDataSetName			= @SourceDataSetName
			, ExtractLowDate			= @PreviousStartDate 
			, ExecutionStatusCode		= 'INPG'
			, ExecutionStatusMessage	= 'In progress.'
			, StartDate					= @StartDate


	SELECT @LoadLogKey = @@IDENTITY


	-- Set output parameter values
	-- StartDateString sample: 20180612134232,  To be used in dynamic file name
	SELECT	  @ExtractLowDate	= @PreviousStartDate
			, @ExtractHighDate	= ISNULL(StartDate, GETUTCDATE())
			, @JulianLowDate	= CAST((DATEPART(YY, @PreviousStartDate) - 1900) * 1000 + DATEPART(DY, @PreviousStartDate) AS NCHAR(6))
			, @JulianHighDate	= CAST((DATEPART(YY, StartDate) - 1900) * 1000 + DATEPART(DY, StartDate) AS NCHAR(6))
	FROM	globalshoplanding.LoadLog
	WHERE	LoadLogKey = @LoadLogKey


	-- Return one row result set to use in SSIS package
	SELECT	  ExtractLowDate	= @PreviousStartDate
			, ExtractHighDate	= @ExtractHighDate
			, LoadLogKey		= @LoadLogKey
			, JulianLowDate		= @JulianLowDate
			, JulianHighDate	= @JulianHighDate

END
GO


