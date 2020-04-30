--USE [LK-GS-ODS]
--GO



--==============================================
--Procedure Name: [LK-GS-ODS].dbo.getInventory
--       Created: Pragmatic Works, Edwin Davis 4/28/2020
--       Purpose: Insert a new Batch into ODS File [LK-GS-ODS].ods._V_Inventory 
--==============================================

CREATE PROCEDURE dbo.getInventory
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime	
AS

BEGIN

/* DEBUGGING
DECLARE
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime	

SELECT 
@SourceTableName = '_V_Inventory'
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


Select @TblName = TableNbr,@TblName = Table_Name, @Viewname = View_Name, @LastBatch = LastBatch 
from 
[LK-GS-CNC].dbo._TableList tl
LEFT JOIN [LK-GS-CNC].ods_globalshop.ExtractConfiguration ec 
ON tl.TABLE_NAME = ec.SourceTableName --'_V_Inventory' --@SourceTableName -- ec.SourceTableName
where 
tl.MasterRunFlag = 'Y' and tl.CurRunFlag  <> 'Y' and tl.TABLE_NAME = '_V_Inventory' and ec.ExtractEnabledFlag = 1
order by tl.runpriority, tl.tablenbr asc



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

IF object_id('##tmp_Inventory_Mstr', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Inventory_Mstr
	END

IF object_id('##tmp_Inventory_Mst2', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Inventory_Mst2
	END

IF object_id('##tmp_Inventory_Mst3', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Inventory_Mst3
	END

Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

 -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([LK_GS],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  INVENTORY_MSTR '+ ''''   
Set @BaseSql = @BaseSql + ')' 
	  
 

Set @Sql = 'Select * INTO ##tmp_Inventory_Mstr From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([LK_GS],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  INVENTORY_MST2 '+ '''' 
Set @BaseSql = @BaseSql + ')' 
	  
 

Set @Sql = 'Select * INTO ##tmp_Inventory_Mst2 From ' +  @BaseSql 

EXEC(@Sql)

   -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([LK_GS],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  INVENTORY_MST3 '+ '''' 
Set @BaseSql = @BaseSql + ')' 
	  
 

Set @Sql = 'Select * INTO ##tmp_Inventory_Mst3 From ' +  @BaseSql 

EXEC(@Sql)


INSERT INTO dbo._V_Inventory
SELECT   IM.*
	--INTO [LK-GS-ODS].dbo._V_Inventory
	From

	(Select
                 CAST(im.[PART]	                                AS nchar(20))       AS  PartID                 --B       INVENTORY_MSTR    
                ,dbo.udf_cv_nvarchar6_to_date([DATE_LAST_CHG])	                    AS  DateLastChg		 	   --B	     INVENTORY_MSTR	
                ,CAST([WHO_CHG_LAST]                            AS nchar(6))        AS  WhoChgLast		 	   --B	     INVENTORY_MSTR	
                ,CAST(im.[AMT_PRICE]                            AS decimal(13, 5))  AS  Price	               --D		 INVENTORY_MSTR
                ,CAST(im.[CODE_ABC]                 			AS nchar(1))	    AS  CodeABC	         	   --D		 INVENTORY_MSTR
                ,CAST(im.[PRODUCT_LINE]             			AS nchar(2))        AS  ProductLine	     	   --D		 INVENTORY_MSTR
                ,CAST(im.[DESCRIPTION] 	            			AS nvarchar(100))   AS  PartDescription	 	   --D		 INVENTORY_MSTR
                ,CAST(im.[UM_INVENTORY] 	            		AS nchar(3))        AS  UM	             	   --D		 INVENTORY_MSTR
                ,CAST(im.[OBSOLETE_FLAG]                        AS nchar(1))             AS  Obsolete           	   --D		 INVENTORY_MSTR
                ,CAST(im.[CODE_SORT]                            AS nchar(10))       AS  CodeSort           	   --D		 INVENTORY_MSTR
                ,CAST(im.[TIME_MATERIAL_LEAD]                   AS decimal(4, 0))   AS  MaterialLeadTime	   --D		 INVENTORY_MSTR
                ,CAST(im.[FLAG_SERIALIZE]                       AS nchar(1))	    AS  SerializeFlag		   --D		 INVENTORY_MSTR
                ,CAST(i2.[CODE_SOURCE]                          AS nchar(12)) 	    AS  SourceCode		 	   --D		 INVENTORY_MST2	
                ,CAST(i2.[NAME_VENDOR]                          AS nchar(20)) 	    AS  PrimaryVendor	   	   --D		 INVENTORY_MST2	
                ,CAST(i2.[TEXT_INFO1]                           AS nchar(20))       AS  PriceGroupID	       --D		 INVENTORY_MST2	
                ,CAST(i2.[TEXT_INFO2]                           AS nchar(20)) 	    AS  SOGroupID		   	   --D		 INVENTORY_MST2	
                ,CAST(i2.[DESCRIPTION_2]                        AS nchar(30)) 	    AS  AltDescription1	 	   --D		 INVENTORY_MST2	
                ,CAST(i2.[DESCRIPTION_3]                        AS nchar(30)) 	    AS  AltDescription2	 	   --D		 INVENTORY_MST2	
                ,CAST(i2.[REQUIRES_INSP]                        AS nchar(1)) 	    AS  RequiresInspection 	   --D		 INVENTORY_MST2	
                ,CAST(i3.[SHELF_LIFE]                           AS nchar(1))        AS  ShelfLife		       --D		 INVENTORY_MST3	
                ,CAST(i3.[VAT_PRODUCT_TYP]                      AS nchar(5))        AS  VatProductType	 	   --D		 INVENTORY_MST3	
                ,CAST(i3.[TAX_EXEMPT_FLG]                       AS nchar(1)) 	    AS  TaxExemptFlag	       --D		 INVENTORY_MST3	
                ,CAST(im.[LOCATION]                             AS nchar(2))        AS  Location	       	   --F		 INVENTORY_MSTR	
                ,CAST(im.[BIN]                                  AS nchar(6))        AS  BIN		         	   --F		 INVENTORY_MSTR	
                ,dbo.udf_cv_nvarchar6_to_date(DATE_LAST_USAGE)                      AS  DateLastUsage	       --F		 INVENTORY_MSTR	
                ,dbo.udf_cv_nvarchar6_to_date(DATE_LAST_AUDIT)                      AS  DateLastAudit		   --F		 INVENTORY_MSTR	
                ,dbo.udf_cv_nvarchar6_to_date(DATE_CYCLE)                           AS  DateCycle		       --F		 INVENTORY_MST2	
                ,CAST(im.[CODE_BOM]                             AS nchar(1))        AS  CodeBOM	         	   --F		 INVENTORY_MSTR	
                ,CAST(im.[CODE_DISCOUNT]                        AS nchar(1))        AS  CodeDiscount		   --F		 INVENTORY_MSTR	
                ,CAST(im.[CODE_TOTAL]                           AS nchar(1))        AS  CodeTotal	           --F		 INVENTORY_MSTR	
                ,CAST(im.[PRIOR_USAGE]                          AS decimal(7, 0))   AS  PriorUsage		 	   --F		 INVENTORY_MSTR	
				,CAST(im.[AMT_ALT_COST]                         AS decimal(16, 6))  AS  AltCostAmt		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_ORDER]							AS decimal(12, 4))  AS  MinMultiple		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_SAFETY]							AS decimal(12, 4))  AS  FloorStockingLevel	   --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_ONHAND]							AS decimal(12, 4))  AS  QtyOnHand		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_REORDER]							AS decimal(12, 4))  AS  QtyReorder		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_ONORDER_PO]						AS decimal(12, 4))  AS  QtyOnOrderPO           --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_ONORDER_WO]						AS decimal(12, 4))  AS  QtyOnOrderWO           --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_REQUIRED]							AS decimal(12, 4))  AS  QtyRequired		       --F		 INVENTORY_MSTR	
                ,CAST(im.[AMT_COST]								AS decimal(12, 4))  AS  AmtCost  		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_01]						AS decimal(7,0)) 	AS  UsageJanuary		   --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_02]						AS decimal(7,0)) 	AS  UsageFebruary		   --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_03]						AS decimal(7,0)) 	AS  UsageMarch		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_04]						AS decimal(7,0)) 	AS  UsageApril		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_05]						AS decimal(7,0)) 	AS  UsageMay		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_06]						AS decimal(7,0)) 	AS  UsageJune		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_07]						AS decimal(7,0)) 	AS  UsageJuly		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_08]						AS decimal(7,0)) 	AS  UsageAugust		       --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_09]						AS decimal(7,0)) 	AS  UsageSeptember		   --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_10]						AS decimal(7,0)) 	AS  UsageOctober		   --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_11]						AS decimal(7,0)) 	AS  UsageNovember		   --F		 INVENTORY_MSTR	
                ,CAST(im.[QTY_USAGE_MO_12]						AS decimal(7,0)) 	AS  UsageDecember          --F		 INVENTORY_MSTR	
		 
				 , @TblNbr as ETL_TablNbr
				 , @Batch as ETL_Batch
				 , getdate() as ETL_Completed
	    FROM
				##tmp_Inventory_Mstr im
				LEFT JOIN 
				##tmp_Inventory_Mst2 i2
				ON im.Part = i2.Part and im.Location = i2.Location
				LEFT JOIN 
				##tmp_Inventory_Mst3 i3
				ON i2.Part = i3.Part and i2.Location = i3.Location

		WHERE -- PULL ALL DELTAS	
				im.DATE_LAST_CHG between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))

	) AS IM
	
Drop table ##tmp_Inventory_Mstr -- select count(*) from ##tmp_Inventory_Mstr
Drop table ##tmp_Inventory_Mst2 -- select count(*) from ##tmp_Inventory_Mst2
Drop table ##tmp_Inventory_Mst3 -- select count(*) from ##tmp_Inventory_Mst3


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

-- ELD added Record Count
SET @Reccnt = 
(Select RecordCount from [LK-GS-CNC].dbo._Tablelist Where Table_Name = @TblName and Lastbatch = @Batch)

--select @Reccnt as 'Reccnt'

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


