CREATE PROCEDURE [ods_globalshop].[LogLoadFailure] @LoadLogKey	INT
													, @Message		NVARCHAR(1500)
AS
BEGIN

	UPDATE	ods_globalshop.LoadLog
	SET		ExecutionStatusCode			= 'FAIL'
			, ExecutionStatusMessage	= REPLACE(REPLACE(@Message, '&apos;', ''''), '&#44;', ',')
			, EndDate					= GETUTCDATE()
			, RecordLastUpdatedDate		= GETUTCDATE()
			, RecordLastUpdatedByName	= SUSER_SNAME()
	WHERE	LoadLogKey = @LoadLogKey
		AND	EndDate IS NULL	--Do not re-update if the EndDate has been stamped previously
	
END



