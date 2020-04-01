CREATE PROCEDURE [ods_globalshop].[LogLoadSuccess] @LoadLogKey			INT
													, @SourceRecordCount	INT = 0
													
AS

BEGIN

	UPDATE	ods_globalshop.LoadLog
	SET		ExecutionStatusCode			= 'SUCC'
			, ExecutionStatusMessage	= 'Success.'
			, SourceRecordCount			= @SourceRecordCount
			, EndDate					= GETUTCDATE()
			, RecordLastUpdatedDate		= GETUTCDATE()
			, RecordLastUpdatedByName	= SUSER_SNAME()
	WHERE	LoadLogKey = @LoadLogKey
	
END
