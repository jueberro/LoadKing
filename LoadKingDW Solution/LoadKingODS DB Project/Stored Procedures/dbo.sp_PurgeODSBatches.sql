/*USE [LK-GS-ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_ODS_ETL_LK_ODS_Load]    Script Date: 6/22/2020 4:29:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
*/
/*---------------------------------------------------------
Stored Proc: sp_PurgeODSBatches
    Purpose: JEU 6/23/2020 ---
	         Purge Batches from ODS Source tables that have 
	         been successfully loaded to the DW and are over
			 10 days old.
-----------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[sp_PurgeODSBatches] 
	
AS
BEGIN
	SET ANSI_NULLS ON
	SET NOCOUNT ON


-- 
Declare @TblNbr         as Int
Declare @TblName        as varchar(100)
Declare @Basesql        as varchar(255)
Declare @Sql            as varchar(1000) 
Declare @Reccnt         as int
Declare @ETLStarted     as datetime
Declare @Servername     as varchar(255)
Declare @Databasename   as varchar(255)
Declare @WinUsername    as varchar(255)
Declare @SQLUsername    as varchar(255)
Declare @Procname       as varchar(255)
Declare @Batch          as int
Declare @LastBatch      as int
Declare @ETLCompleted   as datetime
Declare @TestDate       as nvarchar(255)
Declare @CNCdatabase    as nvarchar(255)
Declare @EDWdatabase    as nvarchar(100)
Declare @ODSdatabase    as nvarchar(100)
Declare @ActiveTable    as nvarchar(100)
Declare @TblNamePath    as nvarchar(100)
Declare @Viewname       as nvarchar(100)
Declare @BaseSQLTblName as nvarchar(100) --Rev4 n.
Declare @Sourcedatasetname as nvarchar(100)
Declare @Executionstatuscode as nvarchar(100)
Declare @Enddate as datetime



Set @Servername   = @@SERVERNAME  
Set @Databasename = DB_NAME()     
Set @WinUsername  = SYSTEM_USER   
Set @SQLUsername  = SUSER_NAME()  
Set @Procname     = ISNULL(OBJECT_NAME(@@PROCID) , 'Running Manually')
Set @CNCdatabase  = '[LK-GS-CNC].dbo.'
Set @EDWdatabase  = '[LK-GS-EDW].dbo.'
Set @ODSdatabase  = '[LK-GS-ODS].dbo.'



DECLARE TBLList CURSOR FOR    -- Create a CURSOR of Sourcedatsetnames to process from [LK-GS-CNC].ods_globalshop.ExtractConfiguration table     
                              -- and examine EXECUTIONSTATUSCODE and if = SUCC, and the EndDate of the extract is over 10 days old
							  -- then delete that batch from that sourcedataset.

Select SourceDataSetName,ExecutionStatusCode,Enddate,LoadLogKey from [LK-GS-CNC].ods_globalshop.LoadLog
       
OPEN TBLList            
FETCH NEXT FROM TBLList INTO @Sourcedatasetname,@Executionstatuscode,@Enddate,@Batch     
            
WHILE @@fetch_status = 0            
BEGIN  

  IF @executionstatuscode = 'SUCC' and datediff(day, @enddate, getdate()) > 10
   BEGIN
    Set @sql = 'delete from [LK-GS-ODS].dbo.' + @sourcedatasetname + ' where ETL_Batch = ' + convert(nvarchar(6),@Batch)
	Exec(@sql)
    END	
  FETCH NEXT FROM TBLList INTO  @Sourcedatasetname,@Executionstatuscode,@Enddate,@Batch    
  
END            
CLOSE TblList           
DEALLOCATE TBLList    
    
END
GO


