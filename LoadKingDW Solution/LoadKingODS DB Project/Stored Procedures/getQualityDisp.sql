﻿CREATE PROCEDURE [dbo].[getQualityDisp]
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime, @LinkedServer varchar(100) = 'LK_GS'	
AS

BEGIN

/* DEBUGGING
DECLARE
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime, @LinkedServer varchar(100) = 'LK_GS'	

SELECT 
@SourceTableName = '_V_Quality'
,@LoadLogKey = 0
,@StartDate = '1/1/1900'
,@EndDate = getdate() 	
*/


SET NOCOUNT ON;


Declare @TblNbr       as Int
Declare @TblName      as varchar(100)
Declare @Reccnt       as int
Declare @ETLStarted   as datetime
Declare @Servername   as varchar(255)
Declare @Databasename as varchar(255)
Declare @WinUsername  as varchar(255)
Declare @SQLUsername  as varchar(255)
Declare @Procname     as varchar(255)
Declare @Batch        as int
Declare @LastBatch    as int
Declare @ETLCompleted as datetime
Declare @TestDate     as nvarchar(255)
Declare @CNCdatabase  as nvarchar(255)
Declare @EDWdatabase  as nvarchar(100)
Declare @ODSdatabase  as nvarchar(100)
Declare @ActiveTable  as nvarchar(100)
Declare @TblNamePath  as nvarchar(100)
Declare @Viewname     as nvarchar(100)

Set @Servername   = @@SERVERNAME  
Set @Databasename = DB_NAME()     
Set @WinUsername  = SYSTEM_USER   
Set @SQLUsername  = SUSER_NAME()  
Set @Procname     = ISNULL(OBJECT_NAME(@@PROCID) , 'Running Manually')
Set @CNCdatabase  = '[LK-GS-CNC].dbo.'
Set @EDWdatabase  = '[LK-GS-EDW].dbo.'
Set @ODSdatabase  = '[LK-GS-ODS].dbo.'


Select @TblNbr = TableNbr,@Tblname = Table_Name,@Viewname = View_Name,@LastBatch = LastBatch 
from 
[LK-GS-CNC].dbo._TableList tl
JOIN [LK-GS-CNC].ods_globalshop.ExtractConfiguration ec 
ON tl.TABLE_NAME = @SourceTableName -- ec.SourceTableName
where 
MasterRunFlag = 'Y' and CurRunFlag  <> 'Y' and ec.ExtractEnabledFlag = 1
order by runpriority, tablenbr asc


BEGIN TRY

Set @ETLStarted = getdate()
set @TestDate = convert(varchar,@ETLStarted,120) -- use for ETLCompleted in batch insert on tables.

--Update destination tablename to reflect the LK-GS-EDW database since we are in ODS->EDW TSQL
Set  @TblNamePath = @ODSdatabase + @tblname -- Rev4 i.

 -- Increment the last Batch ID
Set @Batch = @LoadLogKey --@LastBatch +1

 -- Insert the  the Start Time of the ETL into the table record
  
 Update [LK-GS-CNC].dbo._Tablelist  -- Rev4 c.
    Set ETL_Start       = @ETLStarted,
	    ETL_Completed   = NULL,
	    Status          = 'Started',
        LastBatch       =  @Batch,
        ServerName      =  @Servername,
	    DBName          =  @DataBaseName,
	    WinUsername     =  @Winusername,
		SQLUsername     =  @SQLUsername,  
		Procname        =  @Procname,  
		CurRunFlag      = 'Y'
		Where Table_name = @TblName
   
    Insert Into [LK-GS-CNC].dbo._TableListLog 
	
	select 
	[TableNbr], [TABLE_CAT], [TABLE_SCHEM], [TABLE_NAME], [TABLE_TYPE], 'SSIS Framework Pkg' as [REMARKS], [VIEW_NAME],SourceStoredProc, [ETL_Start], [ETL_Completed]
	, [Status], [Recordcount], [CurRunFlag], [RunPriority], [MasterRunFlag], [LastBatch], [ServerName], [DBname], [WinUsername], [SqlUsername], [Procname] 
	from [LK-GS-CNC].dbo._TableList Where Table_Name = @TblName 


-- ***** BEGIN MULTI SOURCE TABLE LOAD LOGIC *********************************************

IF object_id('##tmp_Quality', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Quality
	END

IF object_id('##tmp_Quality_Addl', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Quality_Addl
	END

IF object_id('##tmp_JobHeader', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_JobHeader
	END

IF object_id('##tmp_Quality_Disp', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Quality_Disp
	END

IF object_id('##tmp_Quality_DiscrpCd', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Quality_DiscrpCd
	END


Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  Quality '   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 

Set @Sql = 'Select * INTO ##tmp_Quality From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  Quality_Addl '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_Quality_Addl From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  Job_Header '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_JobHeader From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  Quality_Disp '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_Quality_Disp From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  Quality_Discrp_Cd '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_Quality_DiscrpCd From ' +  @BaseSql 

EXEC(@Sql)

INSERT INTO dbo._V_QualityDisp

SELECT   QUAL.*
	
	From

(Select 

q.CONTROL_NUMBER
,q.JOB
,q.SUFFIX
,q.SEQUENCE
,jh.DATE_OPENED


,q.CUSTOMER
,q.PART
,q.EMPLOYEE
,q.EMPLOYEE_DEPT
,q.WORKCENTER
,q.VENDOR

,qd.DISPOSITION_SEQ
,qd.DISCREPANCY
,qdc.DISCREP_DESC
,qd.DISPOSITION_ACTION
,qd.USER_DISPOSED_BY
,qd.NEW_JOB
,qd.NEW_SUFFIX
,qd.CNC_ACTION
,qd.NO_GOOD_RPT
,qd.INSPECTED_BY
,qd.USER1
,qd.USER2

,q.DATE_QUALITY
,q.DATE_ENTERED

,qa.F_DATE
,qa.CLOSE_DATE
,qd.DATE_DISPOSED
,qd.TIME_DISPOSED
,qd.DATE_INSPECTED
,qd.DATE_CNC_REQ

,qd.QTY_DISPOSED
,qd.DISPOSED_VALUE

, @TblNbr   as ETL_TablNbr
, @Batch    as ETL_Batch
, getdate() as ETL_Completed

FROM ##tmp_Quality_Disp qd

LEFT JOIN ##tmp_Quality q
ON qd.CONTROL_NUMBER = q.CONTROL_NUMBER

LEFT JOIN ##tmp_Quality_Addl qa
ON qd.CONTROL_NUMBER = qa.CONTROL_NUM

LEFT JOIN (SELECT [SYS], DISCREP_CODE, DISCREP_DESC
FROM ##tmp_Quality_DiscrpCd 
WHERE [SYS] = 'QUA' 
GROUP BY [SYS], DISCREP_CODE, DISCREP_DESC) qdc 
ON qd.DISCREPANCY = qdc.DISCREP_CODE

LEFT JOIN ##tmp_JobHeader jh
ON  q.JOB     = jh.JOB
AND q.SUFFIX  = jh.SUFFIX

) AS QUAL
	
	Drop table ##tmp_Quality      
	Drop table ##tmp_Quality_Addl 
	Drop table ##tmp_JobHeader
	Drop Table ##tmp_Quality_Disp
	Drop Table ##tmp_Quality_DiscrpCd

-- ***** END MULTI SOURCE TABLE LOAD LOGIC ***********************************************


--Log to TableList and Tablelistlog

	
Set @SQL = 'Update [LK-GS-CNC].dbo._TablelistLOG '
	        + 'Set  RecordCount  = (Select count(*) from ' + @TblNamePath  + ' Where ETL_Batch = ' + rtrim(ltrim(convert(nvarchar(4),@Batch))) + ') 
					Where  Table_Name   = ' + '''' + @TblName + '''' 
				+ '     and Lastbatch = ' + rtrim(ltrim(convert(nvarchar(4),@Batch))) -- Rev4 l
    
EXEC(@Sql)

Set @SQL = 'Update [LK-GS-CNC].dbo._TableList '
	        + 'Set  RecordCount  = (Select count(*) from ' + @TblNamePath  + ' Where ETL_Batch = ' + rtrim(ltrim(convert(nvarchar(4),@Batch))) + ') 
					Where  Table_Name   = ' + '''' + @TblName + ''''  -- Rev4 l

EXEC(@Sql)

-- ELD added Record Count
SET @Reccnt = 
(Select RecordCount from [LK-GS-CNC].dbo._Tablelist Where Table_Name = @TblName and Lastbatch = @Batch)


EXEC(@Sql)

	Update  [LK-GS-CNC].dbo._TableList  -- Rev4 c.
        Set ETL_Start       =  @ETLStarted,
	        ETL_Completed   =  getdate(),
	        Status          =  'Completed',
            LastBatch       =  @Batch,
            ServerName      =  @Servername,
	        DBName          =  @DataBaseName,
	        WinUsername     =  @Winusername,
		    SQLUsername     =  @SQLUsername,  
		    Procname        =  @Procname,  
		    CurRunFlag      =  'N',
			Remarks         = 'Full Load'
	     	Where Table_Name  = @Tblname

	Update [LK-GS-CNC].dbo._TablelistLOG  -- Rev4 c.
	        Set ETL_Start   =  @ETLStarted,
	        ETL_Completed   =  getdate(),
	        Status          =  'Completed',
            ServerName      =  @Servername,
	        DBName          =  @DataBaseName,
	        WinUsername     =  @Winusername,
		    SQLUsername     =  @SQLUsername,  
		    Procname        =  @Procname,  
		    CurRunFlag      =  'N',
			Remarks         = 'Full Load'
	     	Where Table_Name  = @Tblname and LastBatch = @Batch
END TRY

 BEGIN CATCH  --ERROR TRAPPING
 
	 INSERT INTO [LK-GS-CNC].dbo._ErrorLog
	(
	Batch,
	Tbl1Nbr,
	Tbl1name,
	ETLStarted,
	ErrorNum,
	ErrorProc,
	ErrorLine,
	ErrorMsg,
	DbName,
	WinUsername,
	SQLUsername,
	Procname
	)
	SELECT
	     @Batch
		,@TblNbr
		,@Tblname 
		,@ETLStarted
		,cast (ERROR_NUMBER() as Int)
		,@Procname
		,cast (ERROR_LINE() as Int)
		,cast (ERROR_MESSAGE() as nvarchar(255))
		,@Databasename
		,@WinUsername
		,@SQLUsername
		,@Procname
	
		-- Complete the Logging for _TableList and _TablelistLOG to show Error Status  -- rev4 g.5
		 
		 --If @Batch <> @LastBatch Set @Batch = @LastBatch  --Rev4 r.2

	   Set @SQL = 'Update [LK-GS-CNC].dbo._TablelistLOG '
	              + 'Set  RecordCount  = (Select count(*) from ' + @TblNamePath  + ' Where ETL_Batch = ' + rtrim(ltrim(convert(nvarchar(4),@Batch))) + ') 
					      Where  Table_Name   = ' + '''' + @TblName + '''' 
					 + '     and LastBatch = ' + rtrim(ltrim(convert(nvarchar(4),@Batch))) -- Rev4 l
    
	   EXEC(@Sql)

	   Set @SQL = 'Update [LK-GS-CNC].dbo._TableList '
	              + 'Set  RecordCount  = (Select count(*) from ' + @TblNamePath  + ' Where ETL_Batch = ' + rtrim(ltrim(convert(nvarchar(4),@Batch))) + ') 
					      Where  Table_Name   = ' + '''' + @TblName + ''''  -- Rev4 l
    
	   EXEC(@Sql)
   
		 Update  [LK-GS-CNC].dbo._TableList  -- Rev4 g.
        Set ETL_Start       =  @ETLStarted,
	        ETL_Completed   =  getdate(),
	        Status          =  'Error',
            LastBatch       =  @LastBatch,
            ServerName      =  @Servername,
	        DBName          =  @DataBaseName,
	        WinUsername     =  @Winusername,
		    SQLUsername     =  @SQLUsername,  
		    Procname        =  @Procname,  
		    CurRunFlag      =  'N',
			Remarks         = cast (ERROR_MESSAGE() as nvarchar(255))
	     	Where Table_Name  = @Tblname

	Update [LK-GS-CNC].dbo._TablelistLOG  -- Rev4 g.
	        Set ETL_Start   =  @ETLStarted,
	        ETL_Completed   =  getdate(),
	        Status          =  'Error',
			LastBatch       =  @LastBatch,
            ServerName      =  @Servername,
	        DBName          =  @DataBaseName,
	        WinUsername     =  @Winusername,
		    SQLUsername     =  @SQLUsername,  
		    Procname        =  @Procname,  
		    CurRunFlag      =  'N',
			Remarks         =  cast (ERROR_MESSAGE() as nvarchar(255))
	     	Where Table_Name  = @Tblname and LastBatch = @Batch

 END CATCH    
 
-- Return one row result set to use in SSIS package
SELECT SourceRecordCount = @Reccnt
 


END








GO

