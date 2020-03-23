CREATE PROCEDURE [dwetl].[LogLoadSuccess] @LoadLogKey				INT
										, @SourceRecordsRead		INT = 0
										, @RowsInsertedCount		INT = 0
										, @RowsUpdatedCount			INT = 0
AS

BEGIN

	UPDATE	dwetl.LoadLog
	SET		ExecutionStatusCode			= 'SUCC'
			, ExecutionStatusMessage	= 'Success.'
			, SourceRecordsRead			= @SourceRecordsRead
			, RowsInsertedCount			= @RowsInsertedCount
			, RowsUpdatedCount			= @RowsUpdatedCount
			, EndDate					= GETUTCDATE()
			, RecordLastUpdatedDate		= GETUTCDATE()
			, RecordLastUpdatedByName	= SUSER_SNAME()
	WHERE	LoadLogKey = @LoadLogKey
	
END
