--USE [LK-GS-ODS]
--GO



CREATE PROCEDURE dbo.getQUOTE
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime
,@LinkedServer varchar(100) = 'LK_GS'
AS

BEGIN

/* DEBUGGING
DECLARE
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime	
,@LinkedServer varchar(100)

SELECT 
@SourceTableName = '_V_QUOTE'
,@LoadLogKey = 0
,@StartDate = '1/1/1900'
,@EndDate = getdate() 
,@LinkedServer = 'LK-GS-01'
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

IF object_id('##tmp_QUOTE_HEADER', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_QUOTE_HEADER
	END

IF object_id('##tmp_QUOTE_LINES', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_QUOTE_LINES
	END

Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  QUOTE_HEADER Where RECORD_TYPE = ' + ''''+ '''' + 'A' + '''' + ''''   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
Set @Sql = 'Select * INTO ##tmp_QUOTE_HEADER From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  QUOTE_LINES Where RECORD_TYPE = ' + +'''' + '''' + 'L' + '''' + '''' --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_QUOTE_LINES From ' +  @BaseSql 

EXEC(@Sql)


Set @ETLCompleted = getdate()

INSERT INTO dbo._V_QUOTE

SELECT   Q.*
	--INTO [LK-GS-ODS].dbo._V_QUOTE
	From
	(
	Select

qh.QUOTE_NO
, qh.RECORD_TYPE
, qh.CUSTOMER
, qh.SHIPTO
, qh.INVOICE
, qh.FILL_INVOICE
, qh.QUOTE_TYPE
, qh.QUOTE_SUFFIX
, qh.CUSTOMER_PO
, qh.MARK_INFO
, qh.CODE_FOB
, qh.TERMS
, qh.LAST_REC_NO
, qh.DATE_SHIPPED
, qh.CODE_SORT
, qh.EXPIRATION
, qh.SALESPERSON
, qh.BRANCH
, qh.SHIP_VIA
, qh.QUOTE_SORT_2
, qh.QUOTE
, qh.QUOTE_LOCATION
, qh.FLAG_SPCD
, qh.QUOTE_CURRENCY
, qh.QTE_CREATED_BY
, qh.PRIMARY_GRP
, qh.CARRIER_CD

, dbo.udf_cv_nvarchar8_to_date(qh.DATE_LAST_CHG)		as qh_DATE_LAST_CHG
, dbo.udf_cv_nvarchar6_to_date(qh.DATE_DUE)				as qh_DATE_DUE
, dbo.udf_cv_nvarchar8_to_date(qh.DATE_QUOTE_CNV)		as qh_DATE_QUOTE_CNV
, dbo.udf_cv_nvarchar8_to_date(qh.DATE_DUE_CNV)			as qh_DATE_DUE_CNV
, dbo.udf_cv_nvarchar8_to_date(qh.QTE_CREATED_DATE)		as qh_QTE_CREATED_DATE
, dbo.udf_cv_nvarchar8_to_date(qh.QUOTE_WON_LOSS_DATE)	as qh_QUOTE_WON_LOSS_DATE
, dbo.udf_cv_nvarchar8_to_date(qh.MUST_DLVR_BY_DATE)	as qh_MUST_DLVR_BY_DATE

, ql.QUOTE_NO as ql_QUOTE_NO
, ql.RECORD_NO
, ql.RECORD_TYPE as ql_RECORD_TYPE
, ql.DESCRIPTION
, ql.FILL_CUST
, ql.SHIP_ID
, ql.FILL_INV
, ql.LINE_TYPE
, ql.UM_QUOTE
, ql.PART
, ql.QUOTE_WON
, ql.UM_INVENTORY
, ql.USER_1
, ql.USER_2
, ql.USER_3
, ql.FLAG_BILLING_PRICE
, ql.PRICE_CODE
, ql.FLAG_REQ_CREATED
, ql.FLAG_USE_MQD
, ql.GL_ACCOUNT
, ql.TAX_SOURCE
, ql.TAX_STATE
, ql.TAX_ZIP
, ql.TAX_GEO_CODE
, ql.TAX_1
, ql.TAX_2
, ql.TAX_3
, ql.TAX_APPLY_1
, ql.TAX_APPLY_2
, ql.TAX_APPLY_3
, ql.FLAG_REWORK
, ql.BIN
, ql.FLAG_COGS
, ql.FLAG_TAX_STATUS
, ql.CUSTOMER_PART
, ql.FILL_CUST_PART
, ql.FLAG_RMA
, ql.INFO_1
, ql.INFO_2
, ql.FLAG_PURCHASED
, ql.QUOTE_CURR_CD
, ql.MXD_CRTNS
, ql.MXD_PLLTS
, ql.NON_INV
, ql.PALLET_FLAG
, ql.INACTIVE
, ql.XTNL_ORD_DISC_FLG
, ql.FLAG_BOM
, ql.BOM_PARENT
, ql.PRODUCT_LINE
, ql.ADD_BY_PGM
, ql.LOTBIN_FLG
, ql.PRICE_BOM_COMP_FLG
, ql.MANUAL_TAX_FLG
, ql.FILLER133
, ql.TAX_ASGN_SRC
, ql.TAX_IMPORT_FLG
, ql.FILLER6
, ql.FLAG_ALWAYS_DISCOUNT

, dbo.udf_cv_nvarchar6_to_date(ql.DATE_SHIP)			as ql_DATE_SHIP
, dbo.udf_cv_nvarchar8_to_date(ql.DATE_QUOTE)			as ql_DATE_QUOTE
, dbo.udf_cv_nvarchar8_to_date(ql.DATE_ITEM_PROM)		as ql_DATE_ITEM_PROM
, dbo.udf_cv_nvarchar6_to_date(ql.ITEM_PROMISE_DT)		as ql_ITEM_PROMISE_DT
, dbo.udf_cv_nvarchar8_to_date(ql.DATE_LAST_INVOICE)	as ql_DATE_LAST_INVOICE
, dbo.udf_cv_nvarchar8_to_date(ql.DATE_LAST_CHG)		as ql_DATE_LAST_CHG

, ql.QTY_QUOTED
, ql.QTY_SHIPPED
, ql.QTY_BO
, ql.WEIGHT
, ql.PRICE
, ql.COST
, ql.DISCOUNT
, ql.QTY_ORIGINAL
, ql.EXTENSION
, ql.MARGIN
, ql.DISCOUNT_PRICE
, ql.PRICE_QUOTE
, ql.PRICE_DISC_ORD
, ql.EXTENSION_QUOTE

	, @TblNbr as ETL_TblNbr
	, @Batch as ETL_Batch
	, @ETLCompleted as ETL_Completed

	    FROM
			##tmp_QUOTE_HEADER qh
			LEFT JOIN 
			##tmp_QUOTE_LINES ql 
			ON qh.QUOTE_NO = ql.QUOTE_NO

		--WHERE -- PULL ALL DELTAS -- *** Header CHANGE_DATE not being populated, will force all record to need to be pulled ***
			
			
		--		(
		--		dbo.udf_cv_nvarchar8_to_date(qh.CHANGE_DATE) between @StartDate and @EndDate
		--		OR
		--		dbo.udf_cv_nvarchar8_to_date(ql.DATE_LAST_CHG) between @StartDate and @EndDate
		--   	    )
		   
	) AS Q
	
	Drop table ##tmp_QUOTE_HEADER -- select * from ##tmp_QUOTE_HEADER -- 
	Drop table ##tmp_QUOTE_LINES -- select * from ##tmp_QUOTE_LINES -- 

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

