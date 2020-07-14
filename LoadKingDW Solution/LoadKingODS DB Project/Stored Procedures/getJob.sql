--USE [LK-GS-ODS]
--GO


--==============================================
--Procedure Name: [LK-GS-ODS].dbo.getJob
--       Created: Pragmatic Works, Edwin Davis 5/5/2020
--       Purpose: Insert a new Batch into ODS File [LK-GS-ODS].ods._V_Job
--             r1. JEU 6/16/2020 - Changed where to use datetime udf
--             r2. ELD 6/22/2020 - Added History tables
--			   r3. ELD 7/9/20220 - Added column FLAG_INDIRECT			   

--==============================================

CREATE PROCEDURE dbo.getJob
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
,@EndDate datetime, @LinkedServer varchar(100) = 'LK-GS-01'	

SELECT 
@SourceTableName = '_V_job'
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

IF object_id('##tmp1_JOB_HEADER', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp1_JOB_HEADER
	END

IF object_id('##tmp1_JOB_DETAIL', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp1_JOB_DETAIL
	END

IF object_id('##tmp1_JOB_HIST_MAST', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp1_JOB_HIST_MAST
	END

IF object_id('##tmp1_JOB_HIST_DTL', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp1_JOB_HIST_DTL
	END


Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'select m.JOB JBMASTER_JOB, m.sfx JBMASTER_SFX, m.bomparent JBMASTER_BOMPARENT, h.* from job_header h left join APSV3_JBMASTER m on h.JOB = m.job and h.suffix = m.sfx and m.bomparent = 1 '   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
 

Set @Sql = 'Select * INTO ##tmp1_JOB_HEADER From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  JOB_DETAIL '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp1_JOB_DETAIL From ' +  @BaseSql 

EXEC(@Sql)

-- 6/22/2020 ELD Extract the history data

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'select m.JOB JBMASTER_JOB, m.sfx JBMASTER_SFX, m.bomparent JBMASTER_BOMPARENT, h.* from JOB_HIST_MAST h left join APSV3_JBMASTER m on h.JOB = m.job and h.suffix = m.sfx and m.bomparent = 1 '   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
 

Set @Sql = 'Select * INTO ##tmp1_JOB_HIST_MAST From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  JOB_HIST_DTL '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp1_JOB_HIST_DTL From ' +  @BaseSql 

EXEC(@Sql)


INSERT INTO dbo._V_Job

SELECT   *
	--INTO [LK-GS-ODS].dbo._V_Job
	From
(
	Select
	   h.[JBMASTER_JOB]
	  ,h.[JBMASTER_SFX]
	  ,h.[JBMASTER_BOMPARENT]
	  ,h.JOB as [HEADER_JOB]
      , h.SUFFIX as [HEADER_SUFFIX]
      , h.PART as [HEADER_PART]
      , h.PRODUCT_LINE as [HEADER_PRODUCT_LINE]
      , h.SALESPERSON as [HEADER_SALESPERSON]
      , h.CUSTOMER as [HEADER_CUSTOMER]
	  , h.SALES_ORDER as [HEADER_SALES_ORDER]
	  , h.SALES_ORDER_LINE as [HEADER_SALES_ORDER_LINE]
      ,d.[JOB]
      ,d.[SUFFIX]
      ,d.[SEQ]
      ,d.[SEQUENCE_KEY]
      ,d.[EMPLOYEE]
      ,d.[DESCRIPTION]
      ,d.[DEPT_WORKCENTER]
      ,d.[RATE_WORKCENTER]
      ,d.[DEPT_EMP]
      ,d.[MACHINE]
      ,d.[PART]
      ,d.[REFERENCE]
      ,d.[LMO]
      ,d.[RATE_TYPE]
      ,d.[LOCATION]
      ,d.[SHIFT_SHIFT]
      ,d.[SHIFT_DEPT]
      ,d.[SHIFT_GROUP]
      , h.DATE_OPENED as [HEADER_DATE_OPENED]
      , h.DATE_DUE as [HEADER_DATE_DUE]
      , h.DATE_CLOSED as [HEADER_DATE_CLOSED]
      , h.DATE_START as [HEADER_DATE_START]
      ,d.[DATE_SEQUENCE]
      ,d.[CHARGE_DATE]
      ,d.[DATE_OUT]
      ,d.[DATE_LAST_CHG]
      ,d.[RATE_EMPLOYEE]
      ,d.[HOURS_WORKED]
      ,d.[PIECES_SCRAP]
      ,d.[PIECES_COMPLTD]
      ,d.[AMOUNT_LABOR]
      ,d.[AMT_OVERHEAD]
      ,d.[AMT_STANDARD]
      ,d.[AMT_SCRAP]
      ,d.[MACHINE_HRS]
      ,d.[MULTIPLE_FRACTION]
      ,d.[START_TIME]
      ,d.[END_TIME]
	  ,d.FLAG_INDIRECT
	 
			 , @TblNbr as ETL_TablNbr
			 , @Batch as ETL_Batch
			 , getdate() as ETL_Completed -- select count(*)
		FROM
		##tmp1_JOB_HEADER h
		LEFT JOIN 
		##tmp1_JOB_DETAIL d 
		ON h.JOB = d.JOB
		AND h.SUFFIX = d.SUFFIX

		WHERE -- PULL ALL DELTAS
			(
				dbo.udf_cv_nvarchar8_to_date(d.DATE_LAST_CHG) between @StartDate and @EndDate
			)

UNION ALL

	Select
	   h.[JBMASTER_JOB]
	  ,h.[JBMASTER_SFX]
	  ,h.[JBMASTER_BOMPARENT]
	  ,h.JOB as [HEADER_JOB]
      , h.SUFFIX as [HEADER_SUFFIX]
      , h.PART as [HEADER_PART]
      , h.PRODUCT_LINE as [HEADER_PRODUCT_LINE]
      , h.SALESPERSON as [HEADER_SALESPERSON]
      , h.CUSTOMER as [HEADER_CUSTOMER]
	  , h.SALES_ORDER as [HEADER_SALES_ORDER]
	  , h.SALES_ORDER_LINE as [HEADER_SALES_ORDER_LINE]
      ,d.[JOB]
      ,d.[SUFFIX]
      ,d.[SEQ]
      ,d.[SEQUENCE_KEY]
      ,d.[EMPLOYEE]
      ,d.[DESCRIPTION]
      ,NULL --d.[DEPT_WORKCENTER]
      ,d.[RATE_WORKCENTER]
      ,left(d.Dept_EMPLOYEE, 4) -- d.[DEPT_EMP]
      ,d.[MACHINE]
      ,d.[PART]
      ,d.[REFERENCE]
      ,d.[LMO]
      ,d.[RATE_TYPE]
      ,d.LOC
      ,d.[SHIFT_SHIFT]
      ,d.[SHIFT_DEPT]
      ,d.[SHIFT_GROUP]
      , h.DATE_OPENED as [HEADER_DATE_OPENED]
      , h.DATE_DUE as [HEADER_DATE_DUE]
      , h.DATE_CLOSED as [HEADER_DATE_CLOSED]
      , h.DATE_START as [HEADER_DATE_START]
      ,d.[DATE_SEQUENCE]
      ,d.[CHARGE_DATE]
      ,d.[DATE_OUT]
      ,d.[DATE_LAST_CHG]
      ,d.[RATE_EMPLOYEE]
      ,d.[HOURS_WORKED]
      ,d.[PIECES_SCRAP]
      ,d.[PIECES_COMPLTD]
      ,d.[AMOUNT_LABOR]
      ,d.[AMT_OVERHEAD]
      ,d.[AMT_STANDARD]
      ,d.[AMT_SCRAP]
      ,d.MACHINE_HOURS
      ,d.[MULTIPLE_FRACTION]
      ,d.[START_TIME]
      ,d.[END_TIME]
	  ,d.FLAG_INDIRECT
	 
			 , @TblNbr as ETL_TablNbr
			 , @Batch as ETL_Batch
			 , getdate() as ETL_Completed -- select count(*)
		FROM
		##tmp1_JOB_HIST_MAST h
		LEFT JOIN 
		##tmp1_JOB_HIST_DTL d 
		ON h.JOB = d.JOB
		AND h.SUFFIX = d.SUFFIX

		WHERE -- PULL ALL DELTAS
			(
				dbo.udf_cv_nvarchar8_to_date(d.DATE_LAST_CHG) between @StartDate and @EndDate
			)
) CurrentAndHistory

	Drop table ##tmp1_JOB_HEADER -- select count(*) from ##tmp1_JOB_HEADER
	Drop table ##tmp1_JOB_DETAIL -- select count(*) from ##tmp1_JOB_DETAIL

	Drop table ##tmp1_JOB_HIST_MAST -- select count(*) from ##tmp1_JOB_HIST_MAST
	Drop table ##tmp1_JOB_HIST_DTL -- select count(*) from ##tmp1_JOB_HIST_DTL



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


