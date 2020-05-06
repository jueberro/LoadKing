CREATE PROCEDURE [dw].[sp_LoadDimSalesOrder] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimSalesOrders_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimSalesOrders_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimSalesOrders_work (
  
		
	[SalesOrderNumber] [nchar](7) NULL,
	[SalesOrderLine] [nchar](4) NULL,
	[OHCreationDate] [datetime] NULL,
	[OHDueDate] [datetime] NULL,
	[OHOrderSort] [nvarchar](20) NULL,
	[OHProjectType] [nvarchar](30) NULL,
	[OHBranch] [nchar](2) NULL,
	[OHShipVia] [nvarchar](20) NULL,
	[OHPrimaryGroup] [nchar](2) NULL,
	[OHShippingZone] [nchar](6) NULL,
	[OHDateLastChanged] [datetime] NULL,
	[OHLastChangedBy] [nvarchar](8) NULL,
	[OLDateLastChanged] [datetime] NULL,
	[OLastChangedBy] [nvarchar](8) NULL,
	[OLDateOrder] [datetime] NULL,
	[OLDateShipped] [datetime] NULL,
	[OLItemPromiseDate] [datetime] NULL,
	[OLDateItemProm] [datetime] NULL,
	[OLDateAddedDate] [datetime] NULL,
	[OLDeliverByDate] [datetime] NULL,
	[OHCustomerID] [nchar](6) NULL,
	[OLCustomerID] [nchar](6) NULL,
	[OHShipToSeq] [nchar](6) NULL,
	[OLShipToSeq] [nchar](6) NULL,
	[OHSalespersonID] [nvarchar](3) NULL,
	[OHQuoteNumber] [nchar](7) NULL,
	[OHGLAccount] [nchar](15) NULL,
	[OLPartID] [nchar](20) NULL,
	[OLCustomerPart] [nvarchar](20) NULL,
	[OLPriceGroupID] [nvarchar](20) NULL,
	[OLSOGroupID] [nvarchar](20) NULL,
	[OLUser1] [nvarchar](30) NULL,
	[OLUser2] [nvarchar](30) NULL,
	[OLTrackingNotes] [nvarchar](30) NULL,
	[OLUser4] [nvarchar](30) NULL,
	[OLLineShipVia] [nvarchar](30) NULL,
	[OLLineType] [nchar](1) NULL,
	[OLFlagSOtoWO] [nchar](1) NULL,
	[OLFlagPurchased] [nchar](1) NULL,
	[OLInactive] [bit] NULL,

	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL 
	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #DimSalesOrders_work
			SELECT 		
				 * from dwstage.V_LoadDimSalesOrder
    
    Update #DimSalesOrders_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimSalesOrders_current ( SalesOrderNumber NCHAR(7),
                                           SalesOrderLine   nchar(4) NULL,
	                                       Type2RecordHash   VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimSalesOrders_current
	SELECT		SalesOrderNumber, SalesOrderLine, Type2RecordHash

	FROM	dw.DimSalesOrder
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimSalesOrder
	SELECT	*
	FROM	#DimSalesOrders_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimSalesOrder AS DIM
						WHERE	DIM.SalesOrderNumber = Work.SalesOrderNumber 
						  AND   DIM.SalesOrderline   = Work.SalesOrderline
						   
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimSalesOrder		AS DIM
	 JOIN   #DimSalesOrders_work	AS Work
	  ON	    Dim.SalesOrderNumber = Work.SalesOrderNumber
	     AND    Dim.SalesOrderline   = Work.Salesorderline
	     AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimSalesOrder
	SELECT	Work.*
	FROM	#DimSalesOrders_current AS DIM
	 JOIN   #DimSalesOrders_work    AS Work
	  ON	  Dim.SalesOrderNumber = Work.SalesOrderNumber
	   AND    Dim.SalesOrderline   = Work.Salesorderline
	  
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimSalesOrders_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimSalesOrders_current	END TRY BEGIN CATCH END CATCH
	 

END