CREATE VIEW [landing].[LoadLog] AS 

	/*
		This view combines entries from multiple log tables
		that track extracts from different data sources.	
	*/

	/*
		Pull from landing.LoadLog (JDE)
	*/
	SELECT LoadLogKey
		 , SourceSystemName
		 , SourceDataSetName
		 , ExecutionStatusCode
		 , ExecutionStatusMessage
		 , StartDate
		 , EndDate
		 , LogTableName = 'globalshoplanding.LoadLog'
	FROM globalshoplanding.LoadLog


--	UNION
--	SELECT	LoadLogKey
		 --, SourceSystemName
		 --, SourceDataSetName
		 --, ExecutionStatusCode
		 --, ExecutionStatusMessage
		 --, StartDate
		 --, EndDate
		 --, LogTableName = 'sourcesystemxlanding.LoadLog'
--	FROM	sourcesystemxlanding.LoadLog