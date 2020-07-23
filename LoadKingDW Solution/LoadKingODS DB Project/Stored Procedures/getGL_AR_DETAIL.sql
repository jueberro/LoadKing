﻿CREATE PROCEDURE [dbo].[getGL_AR_DETAIL]
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime, @LinkedServer varchar(100) = 'LK-GS-01'
AS

BEGIN

/*
DECLARE @SourceTableName varchar(255)
DECLARE @LoadLogKey int
DECLARE @StartDate datetime
DECLARE @EndDate datetime, @LinkedServer varchar(100) = 'LK-GS-01'

SET @SourceTableName = 'GL_AR_DETAIL'
SET @LoadLogKey  = 0
SET @StartDate  = '1/1/1900'
SET @EndDate  = getdate()
*/

	SET ANSI_NULLS ON
	SET NOCOUNT ON

Declare @TblNbr       as Int
Declare @TblName      as varchar(100)
Declare @Basesql      as varchar(4000)
Declare @Sql          as varchar(4000) 
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
Declare @BaseSQLTblName as nvarchar(100) --Rev4 n.

Set @Servername   = @@SERVERNAME  
Set @Databasename = DB_NAME()     
Set @WinUsername  = SYSTEM_USER   
Set @SQLUsername  = SUSER_NAME()  
Set @Procname     = ISNULL(OBJECT_NAME(@@PROCID) , 'Running Manually')
Set @CNCdatabase  = '[LK-GS-CNC].dbo.'
Set @EDWdatabase  = '[LK-GS-EDW].dbo.'
Set @ODSdatabase  = '[LK-GS-ODS].dbo.'


--DECLARE TBLList CURSOR FOR    -- Create a CURSOR of TableNbr's to process from _TableList table     
 
Select @TblName = TABLE_NAME, @TblNbr = TableNbr, @Viewname = View_Name, @LastBatch = LastBatch 
from 
[LK-GS-CNC].dbo._TableList tl
JOIN [LK-GS-CNC].ods_globalshop.ExtractConfiguration ec 
ON tl.TABLE_NAME = ec.SourceTableName
where 
MasterRunFlag = 'Y' and CurRunFlag  <> 'Y' and  tl.TABLE_NAME = 'GL_AR_DETAIL' and ec.ExtractEnabledFlag = 1
and ec.SourceTableName = @SourceTableName
order by runpriority, tablenbr asc
       
--OPEN TBLList            
--FETCH NEXT FROM TBLList INTO @TblNbr,@Tblname,@Viewname,@LastBatch       -- rev4 e.    

--WHILE @@fetch_status = 0            
BEGIN  
BEGIN TRY

    -- Use a View if refernced in the __Tablelist to extract data
    Set @BaseSQLTblname = ISNULL(@Viewname,@Tblname) --Rev4 n.

    Set @ETLStarted = getdate()
	  
	set @TestDate = convert(varchar,@ETLStarted,120) -- use for ETLCompleted in batch insert on tables.
  
    --Update destination tablename to reflect the LK-GS-EDW database since we are in ODS->EDW TSQL

    Set  @TblNamePath = @ODSdatabase + @tblname -- Rev4 i.

    -- Increment the last Batch ID

	Set @Batch = @LoadLogKey -- @LastBatch +1

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

-- ***** CREATE temp table to do Delta test *********************************************

    IF object_id('##tmp_GL_AR_DETAIL', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_GL_AR_DETAIL
	END

	IF object_id('##tmp_GL_AR_DETAIL_HIST', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_GL_AR_DETAIL_HIST
	END

	   -- create the select from source table Openquery using a wildcard
    Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
    Set @BaseSql = @BaseSql + '''' + 'select 
GL_NUMBER               ,
POST_DATE               ,
BATCH					,
LINE					,
SEQ						,
USERID					,
CUST					,
CUST_NAME				,
INVOICE_NO				,
TRANS_DATE				,
RETAIN_DATE				,
INVC_DATE				,
INVC_DTE_J				,
INVC_DUE_DATE			,
INVC_DUE_DTE_J			,
DISC_DUE_DATE			,
DISC_DUE_DTE_J			,
TRAN_TYPE				,
TRTY_BRANCH				,
RETAIN					,
SALSM					,
REFN					,
AREA					,
STATE					,
FACTOR_FLAG				,
TERMS_CODE				,
PAYMENT_TYPE			,
PREPAID_FLAG			,
EXCH_VARIANCE_FLAG		,
TAXABLE_FLG				,
ORDER_NUM				,
ORDER_SEQ				,
EXCH_DATE				,
EXCH_OE_CURR			,
EXCH_OE_RATE			,
EXCH_CMPNY_CURR			,
EXCH_CMPNY_RATE			,
DB_CR_FLAG				,
AMOUNT_CMPNY			,
COST_CMPNY				,
INVTOT_CMPNY			,
FRT_AMT_CMPNY			,
TAX_AMT_CMPNY			,
INVC_DISC_CMPNY			,
TAXABLE_AMT_CMPNY		,
RETENTION_CMPNY			,
AMOUNT_OE				,
COST_OE					,
INVTOT_OE				,
FRT_AMT_OE				,
TAX_AMT_OE				,
INVC_DISC_OE			,
TAXABL_AMT_OE			,
RETENTION_OE			,
EXPORT_TO_EXT_SYS		,
PAYMENT_CURR			,
FILLER					,
TRMNL					,
LAST_CHG_DATE			,
LAST_CHG_TIME			,
LAST_CHG_PGM			,
LAST_CHG_BY		        

from GL_AR_DETAIL'  --Rev4 n.


    Set @BaseSql = @BaseSql + '''' + ' )' 
	  
    Set @Sql = 'Select * INTO ##tmp_GL_AR_DETAIL From '   +  @BaseSql 

    EXEC(@Sql)


	   -- create the select from source table Openquery using a wildcard
    Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
    Set @BaseSql = @BaseSql + '''' + 'select 
GL_NUMBER               ,
POST_DATE               ,
BATCH					,
LINE					,
SEQ						,
USERID					,
CUST					,
CUST_NAME				,
INVOICE_NO				,
TRANS_DATE				,
RETAIN_DATE				,
INVC_DATE				,
INVC_DTE_J				,
INVC_DUE_DATE			,
INVC_DUE_DTE_J			,
DISC_DUE_DATE			,
DISC_DUE_DTE_J			,
TRAN_TYPE				,
TRTY_BRANCH				,
RETAIN					,
SALSM					,
REFN					,
AREA					,
STATE					,
FACTOR_FLAG				,
TERMS_CODE				,
PAYMENT_TYPE			,
PREPAID_FLAG			,
EXCH_VARIANCE_FLAG		,
TAXABLE_FLG				,
ORDER_NUM				,
ORDER_SEQ				,
EXCH_DATE				,
EXCH_OE_CURR			,
EXCH_OE_RATE			,
EXCH_CMPNY_CURR			,
EXCH_CMPNY_RATE			,
DB_CR_FLAG				,
AMOUNT_CMPNY			,
COST_CMPNY				,
INVTOT_CMPNY			,
FRT_AMT_CMPNY			,
TAX_AMT_CMPNY			,
INVC_DISC_CMPNY			,
TAXABLE_AMT_CMPNY		,
RETENTION_CMPNY			,
AMOUNT_OE				,
COST_OE					,
INVTOT_OE				,
FRT_AMT_OE				,
TAX_AMT_OE				,
INVC_DISC_OE			,
TAXABL_AMT_OE			,
RETENTION_OE			,
EXPORT_TO_EXT_SYS		,
PAYMENT_CURR			,
FILLER					,
TRMNL					,
LAST_CHG_DATE			,
LAST_CHG_TIME			,
LAST_CHG_PGM			,
LAST_CHG_BY		        

from GL_AR_DETAIL_HIST'  --Rev4 n.

    Set @BaseSql = @BaseSql + '''' + ' )' 
	  
    Set @Sql = 'Select * INTO ##tmp_GL_AR_DETAIL_HIST From ' +  @BaseSql 

    EXEC(@Sql)
	
    -- If The Table Exists, truncate table and Insert the records from Source, else create table from source

    IF object_id(@TblName, 'U') is not null -- if table exists
      
	  BEGIN

	  --INSERT New ODS Recs (Append with new Batch ID)

    INSERT INTO dbo.GL_AR_DETAIL

    SELECT   GL.*
	
	From

	(Select
	 
		ARd.*    
	    , @TblNbr as ETL_TablNbr
	    , @Batch as ETL_Batch
	    , getdate() as ETL_Completed 
	
	    FROM
		##tmp_GL_AR_DETAIL  ARd
				WHERE -- PULL ALL DELTAS
			(
				LAST_CHG_DATE between @StartDate and @EndDate
			)
  
   
   
  UNION ALL
  
       Select
	 
		ARdh.*    
	    , @TblNbr as ETL_TablNbr
	    , @Batch as ETL_Batch
	    , getdate() as ETL_Completed 
	
	    FROM
		##tmp_GL_AR_DETAIL_HIST ARdh
				WHERE -- PULL ALL DELTAS
			(
				LAST_CHG_DATE between @StartDate and @EndDate
			)

	) AS GL
	 
	Drop table ##tmp_GL_AR_DETAIL 
    Drop table ##tmp_GL_AR_DETAIL_HIST


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
      
      END

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
   
-- Print @Tblname
    --FETCH NEXT FROM TBLList INTO  @TblNbr,@Tblname, @Viewname,@LastBatch     -- rev4 e.  
END            
--CLOSE TblList           
--DEALLOCATE TBLList    

-- Return one row result set to use in SSIS package
SELECT SourceRecordCount = @Reccnt

END
GO

