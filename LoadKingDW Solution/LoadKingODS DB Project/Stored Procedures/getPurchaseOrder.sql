--USE [LK-GS-ODS]
--GO



--==============================================
--Procedure Name: [LK-GS-ODS].dbo.getSalesOrder
--       Created: Pragmatic Works, Edwin Davis 6/12/2020
--       Purpose: Insert a new Batch into ODS File [LK-GS-ODS].ods._V_PurchaseOrder 
--==============================================

CREATE PROCEDURE dbo.getPurchaseOrder
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
@SourceTableName = '_V_PurchaseOrder'
,@LoadLogKey = 0
,@StartDate = '1/1/1900'
,@EndDate = getdate() 
,@LinkedServer = 'LK_GS'
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

IF object_id('##tmp_PO_Header', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_PO_Header
	END

IF object_id('##tmp_PO_Lines', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_PO_Lines
	END

IF object_id('##tmp_POHIST_HEAD', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_POHIST_HEAD
	END

IF object_id('##tmp_POHIST_LINES', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_POHIST_LINES
	END

Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  PO_HEADER Where REC_TYPE = ' + ''''+ '''' + 'A' + '''' + ''''   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
Set @Sql = 'Select * INTO ##tmp_PO_Header From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  PO_LINES Where FLAG_REC_TYPE = ' + +'''' + '''' + 'L' + '''' + '''' --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_PO_Lines From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  POHIST_HEAD Where FLAG_REC_TYPE = ' + ''''+ '''' + 'A' + '''' + ''''   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
Set @Sql = 'Select * INTO ##tmp_POHIST_HEAD From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  POHIST_LINES Where FLAG_REC_TYPE = ' + +'''' + '''' + 'L' + '''' + '''' --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_POHIST_LINES From ' +  @BaseSql 


EXEC(@Sql)

Set @ETLCompleted = getdate()

INSERT INTO dbo._V_PurchaseOrder

SELECT   PO.*
	--INTO [LK-GS-ODS].dbo._V_PurchaseOrder
	From
	(
	Select
	oh.[PURCHASE_ORDER]									as POH_PURCHASE_ORDER ,
	oh.[RECORD_NO]										as POH_RECORD_NO ,
	oh.[TERMS]											as POH_TERMS , -- Pay Terms --  Dim candidate key
	oh.[VENDOR]											as POH_VENDOR , -- Dim candidate key
	oh.[GL_ACCOUNT]										as POH_GL_ACCOUNT , --  Dim candidate key
	----------------------------------------------------------------
	oh.[ORDER_TAX]										as POH_ORDER_TAX ,
	oh.[FLAG_INSURANCE]									as POH_FLAG_INSURANCE ,
	oh.[BUYER]											as POH_BUYER ,
	oh.[SHIP_VIA]										as POH_SHIP_VIA ,
	oh.[CODE_FOB]										as POH_CODE_FOB,
	oh.[FLAG_RECV_CLOSED]								as POH_FLAG_RECV_CLOSED,
	oh.[FLAG_ACCT_CLOSE_A]								as POH_FLAG_ACCT_CLOSE_A,
	oh.[FLAG_PRINT]										as POH_FLAG_PRINT,
	oh.[PO_SEQ]											as POH_PO_SEQ,
	oh.[USER_2]											as POH_USER_2,
	oh.[FLAG_CERTS_REQD]								as POH_FLAG_CERTS_REQD,
	oh.[TEXT_FORMAT]									as POH_TEXT_FORMAT,
	oh.[PREV_SEQ]										as POH_PREV_SEQ,
	oh.[DIFF_DUE_DATE]									as POH_DIFF_DUE_DATE,
	oh.[PHYS_CHEM]										as POH_PHYS_CHEM,
	oh.[PAY_WITH_CCARD]									as POH_PAY_WITH_CCARD,
	oh.[REC_TYPE]										as POH_REC_TYPE,
	-------------------------------------------------------------
	dbo.udf_cv_nvarchar6_to_date(oh.CHANGE_DATE)		as POH_CHANGE_DATE,
	dbo.udf_cv_nvarchar8_to_date(oh.SHIP_DATE)			as POH_SHIP_DATE,
	dbo.udf_cv_nvarchar6_to_date(oh.DATE_ORDER)			as POH_DATE_ORDER,
	dbo.udf_cv_nvarchar6_to_date(oh.DATE_REQ)			as POH_DATE_REQ,
	dbo.udf_cv_nvarchar6_to_date(oh.DATE_DUE)			as POH_DATE_DUE,
	---------------------------------------------------------
	oh.[PART_PD]										as POH_PART_PD, -- Measure candidate
	oh.[SB_PAID]										as POH_SB_PAID, -- Measure candidate
	oh.[DISCOUNT_A]										as POH_DISCOUNT_A, -- Measure candidate

--PO_LINES -----------------------------------------------------------------------

	ol.[PURCHASE_ORDER]									as POL_PURCHASE_ORDER,
	ol.[RECORD_NO]										as POL_RECORD_NO,
	ol.[PO_TYPE]										as POL_PO_TYPE,
	ol.[PART]											as POL_PART, -- Not a actual Part
	ol.[LOCATION]										as POL_LOCATION,
	ol.[DESCRIPTION]									as POL_DESCRIPTION, -- Pay Terms (miss parsed with Location)
	ol.[PART_MFG_NO]									as POL_PART_MFG_NO, --possible part
-----------------------------------------------------------------------------------
	ol.[FILL_EXTENSION]									as POL_FILL_EXTENSION,
	ol.[EXTENSION]										as POL_EXTENSION,
	ol.[FILLER10]										as POL_FILLER10,
	ol.[FILL_EXCH_EXT]									as POL_FILL_EXCH_EXT,
	ol.[REQUISITION_LINE]								as POL_REQUISITION_LINE,
	ol.[FILL_IVCOST]									as POL_FILL_IVCOST,
	ol.[FILL_PT]										as POL_FILL_PT,
	ol.[FILL_VT]										as POL_FILL_VT,
	ol.[VAT_RULE]										as POL_VAT_RULE,
	ol.[USE_PURPOSE]									as POL_USE_PURPOSE,
	ol.[BOOK_USE_TAX]									as POL_BOOK_USE_TAX,
	ol.[FLAG_REC_TYPE]									as POL_FLAG_REC_TYPE,
-----------------------------------------------------------------------------------
	dbo.udf_cv_nvarchar6_to_date(ol.DATE_LAST_RECEIVED)	as POL_DATE_LAST_RECEIVED, 
	dbo.udf_cv_nvarchar8_to_date(ol.DATE_LAST_CHG)		as POL_DATE_LAST_CHG, 
--------------------------------------------------------------
	ol.[VEN_TAX]										as POL_VEN_TAX, -- Measure
	ol.[PUR_TAX]										as POL_PUR_TAX, -- Measure
	ol.[ROLL_QTY]										as POL_ROLL_QTY, -- Measure
	ol.[INV_COST]										as POL_INV_COST, -- Measure
	ol.[SHIPPED_QTY]									as POL_SHIPPED_QTY, -- Measure
	ol.[EXCHANGE_COST2]									as POL_EXCHANGE_COST2, -- Measure
	ol.[EXCHANGE_RATE]									as POL_EXCHANGE_RATE, -- Measure
	ol.[COST_6_DEC]										as POL_COST_6_DEC, -- Measure
	ol.[EXCHANGE_EXT]									as POL_EXCHANGE_EXT, -- Measure
	ol.[VEN_TAX_PER_PIECE]								as POL_VEN_TAX_PER_PIECE, -- Measure
	ol.[QTY_ALT_ORDER]									as POL_QTY_ALT_ORDER, -- Measure
	ol.[QTY_RECD_NOT_INSP]								as POL_QTY_RECD_NOT_INSP, -- Measure
	ol.[COST]											as POL_COST, -- Measure
	ol.[DISCOUNT]										as POL_DISCOUNT, -- Measure
	ol.[QTY_ORDER]										as POL_QTY_ORDER, -- Measure
	ol.[QTY_RECEIVED]									as POL_QTY_RECEIVED, -- Measure
	ol.[QTY_REJECT]										as POL_QTY_REJECT, -- Measure
	ol.[QTY_RECV_ALT]									as POL_RECV_ALT, -- Measure
	ol.[PUR_TAX_PER_PIECE]								as POL_PUR_TAX_PER_PIECE -- Measure

	, @TblNbr as ETL_TblNbr
	, @Batch as ETL_Batch
	, @ETLCompleted as ETL_Completed

	    FROM
			##tmp_PO_Header oh
			LEFT JOIN 
			##tmp_PO_Lines ol 
			ON oh.PURCHASE_ORDER = ol.PURCHASE_ORDER

		WHERE -- PULL ALL DELTAS -- *** Header CHANGE_DATE not being populated, will force all record to need to be pulled ***
			(
				oh.CHANGE_DATE between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))
				OR
				ol.DATE_LAST_CHG between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))
			)

UNION ALL -- Get Header and Lines data from History versions 

	Select
	ohh.[PURCHASE_ORDER]								as POH_PURCHASE_ORDER ,
	ohh.LINE											as POH_RECORD_NO ,
	ohh.[TERMS]											as POH_TERMS , -- Pay Terms --  Dim candidate key
	ohh.[VENDOR]										as POH_VENDOR , -- Dim candidate key
	ohh.[GL_ACCOUNT]									as POH_GL_ACCOUNT , --  Dim candidate key
	----------------------------------------------------------------
	ohh.[ORDER_TAX]										as POH_ORDER_TAX ,
	ohh.[FLAG_INSURANCE]								as POH_FLAG_INSURANCE ,
	ohh.[BUYER]											as POH_BUYER ,
	ohh.[SHIP_VIA]										as POH_SHIP_VIA ,
	ohh.[CODE_FOB]										as POH_CODE_FOB,
	ohh.[FLAG_RECV_CLOSED]								as POH_FLAG_RECV_CLOSED,
	ohh.[FLAG_ACCT_CLOSE_A]								as POH_FLAG_ACCT_CLOSE_A,
	ohh.[FLAG_PRINT]									as POH_FLAG_PRINT,
	ohh.[PO_SEQ]										as POH_PO_SEQ,
	ohh.[USER_2]										as POH_USER_2,
	ohh.[FLAG_CERTS_REQD]								as POH_FLAG_CERTS_REQD,
	ohh.[TEXT_FORMAT]									as POH_TEXT_FORMAT,
	ohh.[PREV_SEQ]										as POH_PREV_SEQ,
	ohh.[DIFF_DUE_DATE]									as POH_DIFF_DUE_DATE,
	ohh.[PHYS_CHEM]										as POH_PHYS_CHEM,
	ohh.[PAY_WITH_CCARD]								as POH_PAY_WITH_CCARD,
	ohh.[FLAG_REC_TYPE]									as POH_REC_TYPE,
	-------------------------------------------------------------
	dbo.udf_cv_nvarchar6_to_date(ohh.CHANGE_DATE)		as POH_CHANGE_DATE,
	dbo.udf_cv_nvarchar8_to_date(ohh.SHIP_DATE)			as POH_SHIP_DATE,
	dbo.udf_cv_nvarchar6_to_date(ohh.DATE_ORDER)		as POH_DATE_ORDER,
	dbo.udf_cv_nvarchar6_to_date(ohh.DATE_REQ)			as POH_DATE_REQ,
	dbo.udf_cv_nvarchar6_to_date(ohh.DATE_DUE)			as POH_DATE_DUE,
	---------------------------------------------------------
	ohh.[PART_PD]										as POH_PART_PD, -- Measure candidate
	ohh.[SB_PAID]										as POH_SB_PAID, -- Measure candidate
	ohh.[DISCOUNT_A]									as POH_DISCOUNT_A, -- Measure candidate

--PO_LINES -----------------------------------------------------------------------

	olh.[PURCHASE_ORDER]								as POL_PURCHASE_ORDER,
	olh.LINE											as POL_RECORD_NO,
	olh.[PO_TYPE]										as POL_PO_TYPE,
	olh.[PART]											as POL_PART, -- Not a actual Part
	olh.[LOCATION]										as POL_LOCATION,
	olh.[DESCRIPTION]									as POL_DESCRIPTION, -- Pay Terms (miss parsed with Location)
	olh.[PART_MFG_NO]									as POL_PART_MFG_NO, --possible part
-----------------------------------------------------------------------------------
	NULL												as POL_FILL_EXTENSION,
	olh.[EXTENSION]										as POL_EXTENSION,
	olh.[FILLER10]										as POL_FILLER10,
	NULL												as POL_FILL_EXCH_EXT,
	olh.[REQUISITION_LINE]								as POL_REQUISITION_LINE,
	NULL												as POL_FILL_IVCOST,
	NULL												as POL_FILL_PT,
	NULL												as POL_FILL_VT,
	NULL												as POL_VAT_RULE,
	NULL												as POL_USE_PURPOSE,
	olh.[LIN_BOOK_USE_TAX]								as POL_BOOK_USE_TAX,
	olh.[FLAG_REC_TYPE]									as POL_FLAG_REC_TYPE,
-----------------------------------------------------------------------------------
	dbo.udf_cv_nvarchar6_to_date(olh.DATE_LAST_RECEIVED)as POL_DATE_LAST_RECEIVED, 
	dbo.udf_cv_nvarchar8_to_date(olh.DATE_LAST_CHG)		as POL_DATE_LAST_CHG, 
--------------------------------------------------------------
	olh.[LIN_VEN_TAX]									as POL_VEN_TAX, -- Measure
	olh.[LIN_PUR_TAX]									as POL_PUR_TAX, -- Measure
	olh.[ROLL_QTY]										as POL_ROLL_QTY, -- Measure
	olh.[INV_COST]										as POL_INV_COST, -- Measure
	olh.[SHIPPED_QTY]									as POL_SHIPPED_QTY, -- Measure
	olh.[EXCHANGE_COST2]								as POL_EXCHANGE_COST2, -- Measure
	olh.[EXCHANGE_RATE]									as POL_EXCHANGE_RATE, -- Measure
	olh.[COST_6_DEC]									as POL_COST_6_DEC, -- Measure
	olh.[EXCHANGE_EXT]									as POL_EXCHANGE_EXT, -- Measure
	olh.VEN_TAX_PER_PIECE								as POL_VEN_TAX_PER_PIECE, -- Measure
	olh.[QTY_ALT_ORDER]									as POL_QTY_ALT_ORDER, -- Measure
	olh.[QTY_RECD_NOT_INSP]								as POL_QTY_RECD_NOT_INSP, -- Measure
	olh.[COST]											as POL_COST, -- Measure
	olh.[DISCOUNT]										as POL_DISCOUNT, -- Measure
	olh.[QTY_ORDER]										as POL_QTY_ORDER, -- Measure
	olh.[QTY_RECEIVED]									as POL_QTY_RECEIVED, -- Measure
	olh.[QTY_REJECT]									as POL_QTY_REJECT, -- Measure
	olh.[QTY_RECV_ALT]									as POL_RECV_ALT, -- Measure
	olh.PUR_TAX_PER_PIECE								as POL_PUR_TAX_PER_PIECE -- Measure

	, @TblNbr as ETL_TblNbr
	, @Batch as ETL_Batch
	, @ETLCompleted as ETL_Completed

	    FROM
			##tmp_POHIST_HEAD ohh
			LEFT JOIN 
			##tmp_POHIST_LINES olh 
			ON ohh.PURCHASE_ORDER = olh.PURCHASE_ORDER

		WHERE -- PULL ALL DELTAS -- *** Header CHANGE_DATE not being populated, will force all record to need to be pulled ***
			(
				ohh.CHANGE_DATE between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))
				OR
				olh.DATE_LAST_CHG between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))
			)

	) AS PO
	
	Drop table ##tmp_PO_Header -- select * from ##tmp_PO_Header -- 2,622
	Drop table ##tmp_PO_Lines -- select * from ##tmp_PO_LINES -- 6,585

	Drop table ##tmp_POHIST_HEAD -- select * from ##tmp_POHIST_HEAD
	Drop table ##tmp_POHIST_LINES -- select * from ##tmp_POHIST_LINES


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


