--USE [LK-GS-ODS]
--GO



--==============================================
--Procedure Name: [LK-GS-ODS].dbo.getSalesOrder
--       Created: Pragmatic Works, Edwin Davis 4/24/2020
--       Purpose: Insert a new Batch into ODS File [LK-GS-ODS].ods._V_SalesOrder 
-- r1 - Joe U - 5/19/2020 - Added logic to use Order_header record type L to get GL
-- r2 - Joe U - 6/18/2020 - Modified date Last Changed logic to use datetime udf

--==============================================

CREATE PROCEDURE [dbo].[getSalesOrder]
@SourceTableName varchar(255)
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime, @LinkedServer varchar(100) = 'LK_GS'	
AS

BEGIN

/*DECLARE
@SourceTableName varchar(255)  --There is already an object named '##tmp_Order_Header' in the database.
,@LoadLogKey int
,@StartDate datetime
,@EndDate datetime, @LinkedServer varchar(100) = 'LK_GS'	

SELECT 
@SourceTableName = '_V_SalesOrder'
,@LoadLogKey = 0
,@StartDate = '1/1/1900'
,@EndDate = getdate() 	
--*/

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
ON tl.TABLE_NAME =  @SourceTableName --'_V_SalesOrder'
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

IF object_id('##tmp_Order_Header', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Order_Header
	END

IF object_id('##tmp_Order_HeaderL', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Order_HeaderL
	END


IF object_id('##tmp_Order_Lines', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_Order_Lines
	END

IF object_id('##tmp_SalesOrder', 'U') is not null -- if table exists
	BEGIN
		Drop table ##tmp_SalesOrder
	END



Declare @Basesql      as varchar(255)
Declare @Sql          as varchar(1000) 

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  ORDER_HEADER Where RECORD_TYPE = ' + ''''+ '''' + 'A' + '''' + ''''   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
Set @Sql = 'Select * INTO ##tmp_Order_Header From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard (use record Type L to pick up GL account)
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  ORDER_HEADER Where RECORD_TYPE = ' + ''''+ '''' + 'L' + '''' + ''''   --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ')' 
	  
Set @Sql = 'Select * INTO ##tmp_Order_HeaderL From ' +  @BaseSql 

EXEC(@Sql)

  -- create the select from source table Openquery using a wildcard
Set @BaseSql = ' Openquery([' + @LinkedServer  + '],'
Set @BaseSql = @BaseSql + '''' + 'Select * from  ORDER_LINES Where RECORD_TYPE = ' + +'''' + '''' + 'L' + '''' + '''' --Rev4 n.
Set @BaseSql = @BaseSql + '''' + ' )' 
	  
Set @Sql = 'Select * INTO ##tmp_Order_Lines From ' +  @BaseSql 

EXEC(@Sql)



SELECT   SO.* INTO ##tmp_SalesOrder
	From
	(Select
	       CAST(oh.[ORDER_NO]	                              AS nchar(7))     AS SalesOrderNumber   -- [ORDER_HEADER]            
         , CAST(ol.[RECORD_NO]                                AS nchar(4))     AS SalesOrderLine     -- [ORDER_LINE]  		  
	  	 , dbo.udf_cv_nvarchar6_to_date(oh.[DATE_ORDER])  	  AS                  OHCreationDate     -- [ORDER_HEADER]    	  
         , dbo.udf_cv_nvarchar6_to_date(oh.[DATE_DUE])    	  AS                  OHDueDate          -- [ORDER_HEADER]    	  
		 , CAST(oh.CODE_SORT                          	      AS nvarchar(20)) AS OHOrderSort        -- [ORDER_HEADER] 	    	  
		 , CAST(oh.USER_2                                	  AS nvarchar(30)) AS OHProjectType      -- [ORDER_HEADER]   	  
		 , CAST(oh.BRANCH                                	  AS nchar(2))     AS OHBranch           -- [ORDER_HEADER]   	  
		 , CAST(oh.SHIP_VIA                                   AS nvarchar(20)) AS OHShipVia          -- [ORDER_HEADER]    		  
		 , CAST(oh.PRIMARY_GRP                           	  AS nchar(2))     AS OHPrimaryGroup     -- [ORDER_HEADER]   	  
		 , CAST(oh.CARRIER_CD                            	  AS nchar(6))     AS OHShippingZone     -- [ORDER_HEADER]   	  
		 , dbo.udf_cv_nvarchar8_to_date(oh.DATE_LAST_CHG)                      AS OHDateLastChanged  -- [ORDER_HEADER]
  		 , CAST(oh.LAST_CHG_BY        AS nvarchar(8))                          AS OHLastChangedBy    -- [ORDER_HEADER] 
	     , dbo.udf_cv_nvarchar8_to_date(ol.DATE_LAST_CHG)                      AS OLDateLastChanged  -- [ORDER_LINE]
  		 , CAST(ol.LAST_CHG_BY        AS nvarchar(8))                          AS OLLastChangedBy    -- [ORDER_LINE] 
	     , dbo.udf_cv_nvarchar8_to_date(ol.DATE_ORDER)                    	   AS OLDateOrder        -- [ORDER_LINE] 	  
		 , dbo.udf_cv_nvarchar6_to_date(ol.DATE_SHIP)                     	   AS OLDateShipped      -- [ORDER_LINE] 	  
	     , dbo.udf_cv_nvarchar6_to_date(ol.ITEM_PROMISE_DT)               	   AS OLItemPromiseDate  -- [ORDER_LINE] 	  
		 , dbo.udf_cv_nvarchar8_to_date(ol.DATE_ITEM_PROM)                	   AS OLDateItemProm     -- [ORDER_LINE] 	  
         , dbo.udf_cv_nvarchar8_to_date(ol.ADD_BY_DATE)                   	   AS OLDateAddedDate    -- [ORDER_LINE] 	  
         , dbo.udf_cv_nvarchar8_to_date(ol.MUST_DLVR_BY_DATE)             	   AS OLDeliverByDate    -- [ORDER_LINE] 	  
 
 --Use for Key Lookups in FACT

		 , CAST(oh.CUSTOMER          AS nchar(6))                AS OHCustomerID                      -- [ORDER_HEADER]  
		 , CAST(ol.CUSTOMER          AS nchar(6))                AS OLCustomerID                      -- [ORDER_LINE]  
		 , CAST(oh.SHIP_ID           AS nchar(6))                AS OHShipToSeq                       -- [ORDER_HEADER]
		 , CAST(ol.SHIP_ID           AS nchar(6))                AS OLShipToSeq                       -- [ORDER_LINE]
		 , CAST(oh.SALESPERSON       AS nvarchar(3))             AS OHSalespersonID                   -- [ORDER_HEADER]
         , CAST(oh.QUOTE             AS nchar(7))                AS OHQuoteNumber                     -- [ORDER_HEADER]
         , CAST(oh.GL_Account        AS nchar(15))               AS OHGLAccount                       -- [ORDER_HEADER] --Record Type L, just to get the GLAccount
	     , CAST(ol.PART              AS nchar(20))               AS OLPartID                          -- [ORDER_LINE]
		

-- Attributes
  		 , CAST(ol.CUSTOMER_PART                      	      AS nvarchar(20)) AS OLCustomerPart     -- [ORDER_LINE] 
		 , CAST(ol.INFO_1                             	      AS nvarchar(20)) AS OLPriceGroupID     -- [ORDER_LINE] 
		 , CAST(ol.INFO_2                             	      AS nvarchar(20)) AS OLSOGroupID        -- [ORDER_LINE]   
		 , CAST(ol.USER_1                             	      AS nvarchar(30)) AS OLUser1            -- [ORDER_LINE]   
		 , CAST(ol.USER_2                             	      AS nvarchar(30)) AS OLUser2            -- [ORDER_LINE]   
		 , CAST(ol.USER_3                             	      AS nvarchar(30)) AS OLTrackingNotes    -- [ORDER_LINE]   
		 , CAST(ol.USER_4                             	      AS nvarchar(30)) AS OLUser4            -- [ORDER_LINE]   
		 , CAST(ol.USER_5                             	      AS nvarchar(30)) AS OLLineShipVia      -- [ORDER_LINE]   
	  	 , CAST(ol.LINE_TYPE                          	      AS nchar(1))     AS OLLineType         -- [ORDER_LINE]   
		 , CAST(ol.FLAG_SO_TO_WO                      	      AS nchar(1))     AS OLFlagSOtoWO       -- [ORDER_LINE]   
		 , CAST(ol.FLAG_PURCHASED                     	      AS nchar(1))     AS OLFlagPurchased    -- [ORDER_LINE]   
		 , CAST(ol.INACTIVE                           	      AS bit)          AS OLInactive         -- [ORDER_LINE]   
		     	 	  
	     --Numericvalues - ORDER_LINES       
	    
		 , CAST(ol.PRICE					                                            AS DECIMAL(16, 4))                  AS Price 					     
		 , CAST(ol.COST					                                                AS DECIMAL(16, 4))      			AS Cost  					               
	     , CAST(ol.EXTENSION   			                                                AS DECIMAL(16, 4))                  AS ExtenedPrice                   
		 , CAST(ol.MARGIN					                                            AS DECIMAL(16, 4))                  AS Margin 					     
		 , CAST(ol.QTY_ORIGINAL    		                                                AS DECIMAL(16, 4))                  AS QtyOriginal                    
		 , CAST(ol.QTY_ALLOC  			                                                AS DECIMAL(16, 4))                  AS QtyAllocated                   
		 , CAST(ol.QTY_ORDERED             	                                            AS DECIMAL(16, 4))                  AS QuantityOrdered			     
		 , CAST(ol.QTY_SHIPPED                                                          AS DECIMAL(16, 4))                  AS Qty_Shipped                    
		 , CAST(ol.QTY_BO                                                               AS DECIMAL(16, 4))                  AS QtyBackOrdered                 
         , CASE WHEN Isnumeric(ol.PRICE_LB)        = 1 then  CAST(ol.PRICE_LB		    AS DECIMAL(16, 4)) ELSE NULL  END	AS PriceDiscount 			     	
		 , CAST(ol.PRICE_LB_ORDER			                                            AS DECIMAL(16, 4))                  AS PricePerPound 	     	     
		 , CASE WHEN Isnumeric(ol.AMT_DISCOUNT)    = 1 then  CAST(ol.AMT_DISCOUNT	    AS DECIMAL(16, 4)) ELSE NULL  END	AS DiscountAmount 			     	
	     , CASE WHEN Isnumeric(ol.ORDER_DISC_AMT)  = 1 then  CAST(ol.ORDER_DISC_AMT	    AS DECIMAL(16, 4)) ELSE NULL  END	AS OrderDiscount 			      
		 , CAST(ol.AMT_DISC_PR_CL_ORD		                                            AS DECIMAL(16, 4))                  AS ProductClassDiscountAmount     
		 , CASE WHEN Isnumeric(ol.PROD_LINE_DISC)  = 1 then  CAST(ol.PROD_LINE_DISC	    AS DECIMAL(16, 4)) ELSE NULL  END   AS ProductLineDiscount 		     
		 , CAST(ol.AMT_DISC_ORDER			                                            AS DECIMAL(16, 4))		            AS OrderDiscountAmount 		     
         , CASE WHEN Isnumeric(ol.PRICE_CLASS_DISC)= 1 then  CAST(ol.PRICE_CLASS_DISC	AS DECIMAL(16, 4)) ELSE NULL  END   AS PriceClassDiscount 		     
		 , CAST(ol.PRDLN_DISC_AMT			                                            AS DECIMAL(16, 4))                  AS ProductLineDiscountAmount      
		 , CASE WHEN Isnumeric(ol.PRICE_ORDER)     = 1    then  CAST(ol.PRICE_ORDER	    AS DECIMAL(16, 4)) ELSE NULL  END   AS OrderPrice 				     
		 , CAST(ol.PRICE_DISC_ORD	                                                    AS DECIMAL(16, 4))                  AS OrderDiscountPrice 		     
		 , CAST(ol.PRICE_LB_ORDER                                                       AS DECIMAL(16, 4))                  AS OrderPricePerPound
		 
		 , @TblNbr as ETL_TablNbr
		 , @Batch as ETL_Batch
		 , getdate() as ETL_Completed
	    FROM
			##tmp_Order_Header oh
			LEFT JOIN 
			##tmp_Order_Lines ol 
			ON oh.ORDER_NO = ol.ORDER_NO
			
		--	LEFT JOIN 
			--##tmp_Order_HeaderL ohl 
		--	ON oh.ORDER_NO = ohl.ORDER_NO
		   


		WHERE -- PULL ALL DELTAS
			
				(
				dbo.udf_cv_nvarchar8_to_date(oh.DATE_LAST_CHG) between @StartDate and @EndDate
				OR
                dbo.udf_cv_nvarchar8_to_date(ol.DATE_LAST_CHG) between @StartDate and @EndDate 
			    )
			

	) AS SO




Update x set x.OHGLAccount = y.GL_Account from
##tmp_SalesOrder x
INNER JOIN ##tmp_Order_HeaderL y
ON     x.SalesOrderNumber = y.Order_No
   and x.SalesOrderLine   = y.Record_No 


INSERT INTO dbo._V_SalesOrder
SELECT  * from 	 ##tmp_SalesOrder


	Drop table ##tmp_Order_Header
	Drop table ##tmp_Order_HeaderL
	Drop table ##tmp_Order_Lines
	Drop table ##tmp_SalesOrder



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

