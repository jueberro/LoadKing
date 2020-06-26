--USE [LK-GS-ODS]
--GO



--==============================================
--Procedure Name: [LK-GS-ODS].dbo.getJob_Header
--       Created: Pragmatic Works, Edwin Davis 5/28/2020
--       Purpose: Insert a new Batch into ODS File [LK-GS-ODS].ods._V_Job_Header
--==============================================

CREATE PROCEDURE dbo.getJob_Header
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
@SourceTableName = '_V_Job_Header'
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

IF object_id('##tmp_JOB_HEADER', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_JOB_HEADER
	END

--IF object_id('##tmp_JOB_DETAIL', 'U') is not null -- if table exists
--	BEGIN
--		Drop table ##tmp_JOB_DETAIL
--	END


Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'select m.JOB JBMASTER_JOB, m.sfx JBMASTER_SFX, m.bomparent JBMASTER_BOMPARENT, h.* from job_header h left join APSV3_JBMASTER m on h.JOB = m.job and h.suffix = m.sfx and m.bomparent = 1 '   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
 

Set @Sql = 'Select * INTO ##tmp_JOB_HEADER From ' +  @BaseSql 

EXEC(@Sql)

--  -- create the select from source table Openquery using a wildcard
--Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
--Set @BaseSql = @BaseSql + '''' + 'Select * from  JOB_DETAIL '  --Rev4 n.
--Set @BaseSql = @BaseSql + '''' + ' )' 
	  
--Set @Sql = 'Select * INTO ##tmp_JOB_DETAIL From ' +  @BaseSql 

--EXEC(@Sql)


INSERT INTO dbo._V_Job_Header

SELECT   SO.*
	--INTO [LK-GS-ODS].dbo._V_Job_Header
	From

	(Select
			[JBMASTER_JOB]
			, [JBMASTER_SFX]
			, [JBMASTER_BOMPARENT]

			, [JOB], [SUFFIX], [FILLER1], [PART], [LOCATION]
			, [PRODUCT_LINE], [ROUTER], [PRIORITY], [DESCRIPTION], [CUSTOMER], [SALESPERSON_OLD], [CUSTOMER_PO]
			, [QTY_ORDER], [QTY_COMPLETED], [DATE_OPENED], [DATE_DUE], [DATE_CLOSED], [DATE_START], [DATE_SCH_CMPL_INF]
			, [DATE_SCH_CMPL_FIN], [DATE_LAST_SCH_INF], [DATE_ORIG_DUE], [AMT_PRICE_PER_UNIT], [AMT_SALES], [AMT_MATERIAL]
			, [NUM_HOURS], [AMT_LABOR], [AMT_OVERHEAD], [COMMENTS_1], [COMMENTS_2], [FLAG_PURGE], [PART_CUSTOMER]
			, [DRAWING_CUSTOMER], [AMT_PARTIAL_SHPMNT], [CODE_SORT], [CODE_SORT_OTHER], [DATE_START_OTHER], [HOUR_START]
			, [SYSTEM_PRIORITY], [USER_SCHEDULE], [FREIGHT], [PARTIAL_FREIGHT], [DATE_SHIP_1], [DATE_SHIP_2], [DATE_SHIP_3]
			, [DATE_SHIP_4], [QTY_SHIP_1], [QTY_SHIP_2], [QTY_SHIP_3], [QTY_SHIP_4], [DATE_LAST_SCH_FIN], [BIN], [OTHER]
			, [PARTIAL_OTHER], [DATE_DUE_NEW], [CTR_DATE_REVUE_DUE], [CTR_DATE_DUE_NEW], [FLAG_WO_PRTD], [QTY_CUSTOMER]
			, [DATE_MATERIAL_DUE], [CTR_DATE_MATL_DUE], [COMMENTS_3], [DATE_MATL_ORDER], [PARTIAL_MATERIAL], [PARTIAL_LABOR]
			, [PARTIAL_OVERHEAD], [FLAG_HOLD], [SALESPERSON], [SCH_GRP], [FLAG_WO_RELEASED], [FILLER3], [PARENT_WO]
			, [PARENT_SUFFIX_PARENT], [DATE_RELEASED], [PART_DESCRIPTION], [SALES_ORDER], [SALES_ORDER_LINE], [FLAG_SERIALIZE]
			, [OUTS], [PARTIAL_OUTSIDE], [SCHEDULED_DUE_DATE], [PROJECT], [DUE_OFFSET], [JOB_LOCKED], [SCHEDULE_DIR], [CREATE_FROM_QUALITY]
			, [TRAV_REV], [SPECIAL_START_SEQ], [SPECIAL_STOP_SEQ], [PMAINT_FLAG], [SHIPTO_ID], [LOT_TO_LOT], [EXPORTED], [PHASE]
			, [JOB_TYPE], [PRE_RELEASE], [PROCESS_GRP], [SHIPD_FLG], [FILLER4] 	 
			 , @TblNbr as ETL_TablNbr
			 , @Batch as ETL_Batch
			 , getdate() as ETL_Completed -- select count(*)
		FROM
		##tmp_JOB_HEADER h

		--LEFT JOIN 
		--##tmp_JOB_DETAIL d 
		--ON h.JOB = d.JOB
		--AND h.SUFFIX = d.SUFFIX

		--WHERE -- PULL ALL DELTAS
		--	(
		--		d.DATE_LAST_CHG between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))
		--	)

	) AS SO


	Drop table ##tmp_JOB_HEADER -- select count(*) from ##tmp_JOB_HEADER



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


