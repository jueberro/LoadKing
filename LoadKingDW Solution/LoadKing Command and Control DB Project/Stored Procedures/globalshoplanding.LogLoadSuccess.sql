CREATE PROCEDURE [globalshoplanding].[LogLoadSuccess] @LoadLogKey			INT
													, @SourceRecordsRead	INT = 0
													, @TargetRecordsWritten INT = 0
AS

BEGIN

	UPDATE	globalshoplanding.LoadLog
	SET		ExecutionStatusCode			= 'SUCC'
			, ExecutionStatusMessage	= 'Success.'
			, SourceRecordsRead			= @SourceRecordsRead
			, TargetRecordsWritten		= @TargetRecordsWritten
			, EndDate					= GETUTCDATE()
			, RecordLastUpdatedDate		= GETUTCDATE()
			, RecordLastUpdatedByName	= SUSER_SNAME()
	WHERE	LoadLogKey = @LoadLogKey
	
END
