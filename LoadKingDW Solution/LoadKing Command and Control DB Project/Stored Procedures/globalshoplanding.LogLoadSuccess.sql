CREATE PROCEDURE [globalshoplanding].[LogLoadSuccess] @LoadLogKey			INT
													, @SourceRecordCount	INT = 0
													
AS

BEGIN

	UPDATE	globalshoplanding.LoadLog
	SET		ExecutionStatusCode			= 'SUCC'
			, ExecutionStatusMessage	= 'Success.'
			, SourceRecordCount			= @SourceRecordCount
			, EndDate					= GETUTCDATE()
			, RecordLastUpdatedDate		= GETUTCDATE()
			, RecordLastUpdatedByName	= SUSER_SNAME()
	WHERE	LoadLogKey = @LoadLogKey
	
END
