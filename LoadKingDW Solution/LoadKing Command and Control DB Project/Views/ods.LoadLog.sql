CREATE VIEW [ods].[LoadLog] AS 

	/*
		This view combines entries from multiple log tables
		that track extracts from different data sources.	
	*/

	/*
		Pull from globalshoplanding.LoadLog (Global Shop)
	*/
	SELECT LoadLogKey
		 , SourceSystemName
		 , SourceDataSetName
		 , ExecutionStatusCode
		 , ExecutionStatusMessage
		 , StartDate
		 , EndDate
		 , LogTableName = 'globalshoplanding.LoadLog'
	FROM ods_globalshop.LoadLog


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