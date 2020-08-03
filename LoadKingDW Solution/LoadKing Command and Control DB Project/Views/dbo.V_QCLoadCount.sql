CREATE VIEW  [dbo].[v_QCLoadCount]
AS
WITH DWLL
AS
(
SELECT [LoadLogKey] AS DWLoadLogKey
	  ,[DWTableName]
	  ,[RowsInsertedCount] AS DWRowsInserted
      ,[RowsUpdatedCount]  AS DWRowsUpdated
	  ,Lead([RowsInsertedCount]) OVER(PARTITION BY DWTableName  order by DWTableName,LoadLogKey desc) as prev_DWRowsInserted
	  ,Lead([RowsUpdatedCount]) OVER(PARTITION BY DWTableName  order by DWTableName,LoadLogKey desc) as prev_DWRowsUpdated
	  ,[ExecutionStatusCode]	AS DWStatusCode
	  ,[ExecutionStatusMessage]	AS DWStatusMessage
	  ,Lead([ExecutionStatusCode]) OVER(PARTITION BY DWTableName  order by DWTableName,LoadLogKey desc) as prev_DWStatusCode
	  ,Lead([ExecutionStatusMessage]) OVER(PARTITION BY DWTableName  order by DWTableName,LoadLogKey desc) as prev_DWStatusMessage
	  ,[StartDate]	AS DWStartDate
      ,[EndDate]	AS DWEndDate 
	  ,CONVERT(VARCHAR(8), DATEADD(Minute, DATEDIFF(Minute, [StartDate], [EndDate]), 0), 108)AS DWDuration
	  ,Lead(StartDate)	OVER(PARTITION BY DWTableName  order by DWTableName,LoadLogKey desc) as prev_DWStartDate
	  ,Lead(EndDate)	OVER(PARTITION BY DWTableName  order by DWTableName,LoadLogKey desc) as prev_DWEndDate
	  ,[SourceLoadLogKey]  AS ODSLoadLogKey
  --  ,[SourceDataSetName] AS ODSDataSetName
	  ,RANK() OVER(PARTITION BY DWTableName  order by DWTableName,LoadLogKey desc) as DWrnk
  FROM [LK-GS-CNC].[dwetl].[LoadLog]
  ),
  ODSLL
  AS
 (
  SELECT [LoadLogKey] as [ODSLoadLogKey]
      ,[SourceDataSetName]		AS ODSDataSetName
      ,[ExecutionStatusCode]	AS ODSStatusCode
      ,[ExecutionStatusMessage] AS ODSStatusMessage
	  ,Lead([ExecutionStatusCode]) OVER(PARTITION BY SourceDataSetName  order by SourceDataSetName,LoadLogKey desc) as prev_ODSStatusCode
	  ,Lead([ExecutionStatusMessage]) OVER(PARTITION BY SourceDataSetName  order by SourceDataSetName,LoadLogKey desc) as prev_ODSStatusMessage
      ,[StartDate]	AS ODSStartDate
      ,[EndDate]	AS ODSEnDate
	  ,CONVERT(VARCHAR(8), DATEADD(Minute, DATEDIFF(Minute, [StartDate], [EndDate]), 0), 108)AS ODSDuration
	  ,Lead(StartDate)	OVER(PARTITION BY SourceDataSetName  order by SourceDataSetName,LoadLogKey desc) as prev_ODSStartDate
	  ,Lead(EndDate)	OVER(PARTITION BY SourceDataSetName  order by SourceDataSetName,LoadLogKey desc) as prev_ODSEndDate
      ,[SourceRecordCount] AS ODSCount
	  ,Lead(SourceRecordCount) OVER(PARTITION BY SourceDataSetName  order by SourceDataSetName,LoadLogKey desc) as prev_ODSCount
	  ,RANK() OVER(PARTITION BY [SourceDataSetName]  order by [SourceDataSetName],LoadLogKey desc) as ODSRNK
  FROM [LK-GS-CNC].[ods_globalshop].[LoadLog]
 )
  SELECT 
	 DWLoadLogKey
	,DWTableName
	,DWRowsInserted
    ,DWRowsUpdated
	,prev_DWRowsInserted
	,prev_DWRowsUpdated
	,Total_DWRows = DWRowsInserted + DWRowsUpdated
	,Total_prev_DWRows =  prev_DWRowsInserted + prev_DWRowsUpdated
	,DWStatusCode
	,DWStatusMessage
	,prev_DWStatusCode
	,prev_DWStatusMessage
	,DWStartDate
    ,DWEndDate 
    ,DWDuration
	,prev_DWStartDate
	,prev_DWEndDate
	,CONVERT(VARCHAR(8), DATEADD(Minute, DATEDIFF(Minute, prev_DWStartDate, prev_DWEndDate), 0), 108) as prev_DWDuration
	,prev_ODSStartDate
	,prev_ODSEndDate
	,CONVERT(VARCHAR(8), DATEADD(Minute, DATEDIFF(Minute, prev_ODSStartDate, prev_ODSEndDate), 0), 108) as prev_ODSDuration
	,ODSDataSetName
    ,ODSStatusCode
    ,ODSStatusMessage
	,prev_ODSStatusCode
    ,prev_ODSStatusMessage
    ,ODSStartDate
    ,ODSEnDate
    ,ODSDuration
    ,ODSCount
	,prev_ODSCount
 FROM DWLL 
 LEFT JOIN ODSLL
 ON DWLL.ODSLoadLogKey = ODSLL.ODSLoadLogKey AND DWRnk = ODSRNK 
 WHERE DWrnk = 1 AND ODSRNK = 1
 GO
