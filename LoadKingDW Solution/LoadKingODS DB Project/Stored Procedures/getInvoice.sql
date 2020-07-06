


--==============================================
--Procedure Name: [LK-GS-ODS].dbo.getInvoice
--       Created: Pragmatic Works, Edwin Davis 5/5/2020
--       Purpose: Insert a new Batch into ODS File [LK-GS-ODS].ods._V_Invoice 
--           R1 - JEU 7/6/2020 - Added Drop PO
--==============================================

CREATE PROCEDURE [dbo].[getInvoice]
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
@SourceTableName = '_V_Invoice'
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

IF object_id('##tmp_Order_Hist_Head', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Order_Hist_Head
	END

IF object_id('##tmp_Order_Hist_Line', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Order_Hist_Line
	END

IF object_id('##tmp_PODropShip', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_PODropShip
	END

Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  ORDER_HIST_HEAD '   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
 

Set @Sql = 'Select * INTO ##tmp_Order_Hist_Head From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  ORDER_HIST_LINE '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_Order_Hist_Line From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  PO_DROP_SHIP '  --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_PODropShip From ' +  @BaseSql 

EXEC(@Sql)


INSERT INTO dbo._V_Invoice

SELECT   SO.*
	--INTO [LK-GS-ODS].dbo._V_Invoice
	From

	(Select
			 CAST(ol.ORDER_NO             AS    nchar(7))           AS            SalesOrderNumber
			,CAST(ol.ORDER_LINE           AS    nchar(4))           AS            SalesOrderLine
			,CAST(ol.ORDER_SUFFIX         AS    nchar(4))           AS            OLOrderSuffix
			,CAST(oh.ORDER_SUFFIX         AS    nchar(4))           AS            OHOrderSuffix
			,CAST(ol.INVOICE              AS    nchar(7))           AS            OLInvoiceNumber
			,CAST(oh.DATE_ORDER           AS    date)               AS            OHCreationdate
			,CAST(oh.DATE_ORDER_DUE       AS    date)               AS            OHDateOrderDue
			,CAST(ol.DATE_ORDER_DUE       AS    date)               AS            OLDateOrderDue
			,CAST(oh.INVOICE              AS    nchar(7))           AS            OHInvoiceNumber
			,CAST(ol.DATE_DUE             AS    date)               AS            OLDateDue
			,CAST(oh.CODE_SORT            AS    [nvarchar](20))     AS            OHOrderSort
			,CAST(oh.USER_2               AS    [nvarchar](30))     AS            OHProjectType
			,CAST(oh.BRANCH               AS    nchar(2))           AS            OHBranch
			,CAST(oh.SHIP_VIA             AS    [nvarchar](20))     AS            OHShipVia
			,CAST(oh.PRIMARY_GRP          AS    nchar(2))           AS            OHPrimaryGroup
			,CAST(oh.CARRIER_CD           AS    nchar(6))           AS            OHShippingZone
			,CAST(ol.DATE_ORDER           AS    date)               AS            OLDateOrder
			,CAST(ol.DATE_SHIPPED         AS    date)               AS            OLDateShipped
			,CAST(ol.DATE_INVOICE         AS    date)               AS            OLDateLineInvoiced
			,CAST(ol.MUST_DLVR_DATE       AS    date)               AS            OLCustDueDate
			,CAST(ds.po                   as    nchar(7))           AS            OLDropPO           --new r1
			,CAST(ds.po_line              as    nchar(4))           AS            OLDropPOLine       --new r1
			,CAST(ol.BRANCH               AS    nchar(2))           AS            OLBranch
			,CAST(ol.SHIP_VIA             AS    [nvarchar](20))     AS            OLShipVia
			,CAST(ol.CUSTOMER_PART        AS    [nvarchar](20))     AS            OLCustomerPart
			,CAST(oh.FLAG_INTL            AS    nchar(1))           AS            OLInternationalFlag
			,CAST(ol.FLAG_BOM             AS    nchar(1))           AS            OLBOMExplodeFlag
			,CAST(ol.FLAG_TAX_STATUS      AS    nchar(1))           AS            OLFlagTaxStatus
			,CAST(ol.CREDIT_MEMO_FLAG     AS    nchar(1))           AS            OLCreditMemoFlag
			,CAST(ol.FLAG_RMA             AS    nchar(1))           AS            OLFlagRMA
			,CAST(ol.PRICE_BOM_COMP_FLAG  AS    nchar(1))           AS            OLBOMCompleteFlag
			,CAST(ol.BOM_PARENT           AS    nchar(4))           AS            OLBOMParentLineNumber
			,CAST(ol.FLAG_SERIALIZE       AS    nchar(1))           AS            OLSerializedFlag
			,CAST(ol.UM_INVENTORY         AS    nchar(2))           AS            OLUMInventory
			,CAST(ol.PRODUCT_LINE         AS    nchar(2))           AS            OLProductLine
			,CAST(ol.INFO_1               AS    [nvarchar](20))     AS            OLPriceGroupID
			,CAST(ol.INFO_2               AS    [nvarchar](20))     AS            OLSOGroupID
			,CAST(ol.USER_1               AS    [nvarchar](30))     AS            OLUser1
			,CAST(ol.USER_2               AS    [nvarchar](30))     AS            OLUser2
			,CAST(ol.USER_3               AS    [nvarchar](30))     AS            OLTrackingNotes
			,CAST(ol.USER_4               AS    [nvarchar](30))     AS            OLUser4
			,CAST(ol.USER_5               AS    [nvarchar](30))     AS            OLUser5ShipVia
			,CAST(ol.CARRIER_CD           AS    nchar(6))           AS            OLShippingZone
			,CAST(ol.PHASE                AS    nchar(4))           AS            OLPhase
			,CAST(ol.PRICE_DESCRIPTION    AS    [nvarchar](30))     AS            OLPriceDescription
			,CAST(ol.LINE_TYPE            AS    nchar(1))           AS            OLLineType
			,CAST(ol.CUSTOMER             AS    nchar(6))           AS            Customer
			,CAST(ol.CUSTOMER_SHIP        AS    nchar(6))           AS            OrderLineCustShipTo
			,CAST(oh.CUSTOMER_SHIP        AS    nchar(6))           AS            OrderCustShipTo
			,CAST(ol.PART                 AS    nvarchar(20))       AS            Part
			,CAST(ol.SALESPERSON          AS    nchar(3))           AS            SalesPerson
			,CAST(ol.GL_ACCOUNT           AS    nchar(14))          AS            GLAccount
			,CAST(ol.JOB                  AS    nchar(6))           AS            Job
			,CAST(ol.QTY_ORDERED          AS    [decimal](13, 4))   AS            QtyOrdered
			,CAST(ol.QTY_SHIPPED          AS    [decimal](13, 4))   AS            QtyShipped        
			,CAST(ol.QTY_BO               AS    [decimal](13, 4))   AS            QtyBO        
			,CAST(ol.QTY_ORIGINAL         AS    [decimal](13, 4))   AS            QtyOriginal        
			,CAST(ol.COST                 AS    [decimal](16, 6))   AS            Cost        
			,CAST(ol.COST_MATERIAL        AS    [decimal](11, 2))   AS            CostMaterial        
			,CAST(ol.COST_LABOR           AS    [decimal](11, 2))   AS            CostLabor        
			,CAST(ol.COST_OUTSIDE         AS    [decimal](11, 2))   AS            CostOutside        
			,CAST(ol.COST_OVERHEAD        AS    [decimal](11, 2))   AS            CostOverhead        
			,CAST(ol.COST_OTHER           AS    [decimal](11, 2))   AS            CostOther        
			,CAST(ol.MARGIN               AS    [decimal](7, 4))    AS            Margin
			,CAST(ol.PRICE                AS    [decimal](16, 6))   AS            Price
			,CAST(ol.EXTENSION            AS    [decimal](16, 2))   AS            ExtendedPrice
			,CAST(ol.TAX_APPLY_1          AS    nchar(1))           AS            TaxApply1
			,CAST(ol.TAX_APPLY_2          AS    nchar(1))           AS            TaxApply2
			,CAST(ol.TAX_AMT_1_ORDER      AS    [decimal](11, 2))   AS            TaxAmt1
			,CAST(ol.TAX_AMT_2            AS    [decimal](11, 2))   AS            TaxAmt2
	 
			 , @TblNbr AS ETL_TablNbr
			 , @Batch  AS ETL_Batch

			 , getdate() as ETL_Completed -- select count(*)
		FROM
		##tmp_Order_Hist_Head oh
		LEFT JOIN 
		##tmp_Order_Hist_Line ol 
		ON oh.ORDER_NO = ol.ORDER_NO
		AND oh.ORDER_SUFFIX = ol.ORDER_SUFFIX
		AND oh.INVOICE = ol.INVOICE
		LEFT JOIN
		##tmp_PODropShip ds
		on oh.Order_No = ds.Order_No
		and oh.Order_Line = ds.Order_Line
	    and ol.Part = ds.Part

		-- truncate table dbo._v_Invoice -- select * from dbo._v_Invoice

		-- WHERE -- PULL ALL DELTAS
		--	(
		--		oh.DATE_LAST_CHG between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))
		--		OR
		--		ol.DATE_LAST_CHG between cast(CAST(@StartDate as date)as varchar(19)) and cast(CAST(@EndDate as date) as varchar(19))
		--	)

	) AS SO
	
	Drop table ##tmp_Order_Hist_Head -- select count(*) from ##tmp_Order_Hist_Head
	Drop table ##tmp_Order_Hist_Line -- select count(*) from ##tmp_Order_Hist_Line


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


