﻿CREATE PROCEDURE [dwetl].[LogLoadFailure] @LoadLogKey	INT
										, @Message		NVARCHAR (1500)

AS
BEGIN

	UPDATE	dwetl.LoadLog
	SET		ExecutionStatusCode			= 'FAIL'
			, ExecutionStatusMessage	= REPLACE(REPLACE(@Message, '&apos;', ''''), '&#44;', ',')
			, EndDate					= GETUTCDATE()
			, RecordLastUpdatedDate		= GETUTCDATE()
			, RecordLastUpdatedByName	= SUSER_SNAME()
	WHERE	LoadLogKey = @LoadLogKey
	 AND	EndDate IS NULL
	
END
