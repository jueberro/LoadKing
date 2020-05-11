CREATE PROCEDURE [dw].[sp_LoadDimInvoice] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimInvoice_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimInvoice_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimInvoice_work (                              
                                                          
	[SalesOrderNumber] [nchar](7) NULL,                   
	[SalesOrderLine] [nchar](4) NULL,	                  
	[OHOrderSuffix] [nchar](4) NULL,		              
	[OHInvoiceNumber] [nchar](7) NULL, 		              
	[OHCreationDate] [datetime] NULL,		                  
	[OHDateOrderDue] [datetime] NULL,		                  
	[OLDateOrderDue] [datetime] NULL,			              
	[OLDateDue]      [datetime] NULL,                              
	[OHOrderSort] [nvarchar](20) NULL,				   	  
	[OHProjectType] [nvarchar](30) NULL,				  
	[OHBranch] [nchar](2) NULL,						   	  
	[OHShipVia] [nvarchar](20) NULL,					  
	[OHPrimaryGroup] [nchar](2) NULL,		   			  
	[OHShippingZone] [nchar](6) NULL,				   	  
	[OLDateOrder]   [datetime] NULL,						   	  
	[OLCustDueDate] [datetime] NULL,				   		  
	[OLBranch] [nchar](2) NULL,				   			  
	[OLShipVia] [nvarchar](20) NULL,				   	  
	[OLCustomerPart] [nvarchar](20) NULL,				  
	[OLInternationalFlag] [nchar](1) NULL,				  
	[OLBOMExplodeFlag] [nchar](1) NULL,				 	  
	[OLFlagTaxStatus] [nchar](1) NULL,				 	  
	[OLCreditMemoFlag] [nchar](1) NULL,				 	  
    [OLFlagRMA] [nchar](1) NULL,				          
	[OLBOMCompleteFlag] [nchar](1) NULL,			
    [OLBOMParentLineNumber] [nchar](4) NULL,		
    [OLSerializedFlag] [nchar](1) NULL,				 
    [OLUMInventory] [nchar](2) NULL,	
    [OLProductLine] [nchar](2) NULL,				 
    [OLPriceGroupID] [nvarchar](20) NULL,			
    [OLSOGroupID] [nvarchar](20) NULL,				 
    [OLUser1] [nvarchar](30) NULL,				   	
	[OLUser2] [nvarchar](30) NULL,				   
	[OLTrackingNotes] [nvarchar](30) NULL,			
	[OLUser3] [nvarchar](30) NULL,				   
	[OLUser5_ShipVia] [nvarchar](30) NULL,			
	[OLShippingZone] [nchar](6) NULL,				 
	[OLPhase] [nchar](4) NULL,				   
	[OLPriceDescription] [nvarchar](30) NULL,		
	[OLLineType] [nchar](1) NULL,			
	
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL 
	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #DimInvoice_work
			SELECT 		
				 * from dwstage.V_LoadDimInvoice
    
    Update #DimInvoice_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimInvoice_current ( SalesOrderNumber NCHAR(7),
                                           SalesOrderLine   nchar(4) ,
										   OHOrderSuffix    nchar(4) ,
										   OHInvoiceNumber  nchar(7) ,

	                                       Type2RecordHash   VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimInvoice_current
	SELECT		SalesOrderNumber, SalesOrderLine, OHOrderSuffix , OHInvoiceNumber, Type2RecordHash

	FROM	dw.DimInvoice
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimInvoice
	SELECT	*
	FROM	#DimInvoice_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.Diminvoice AS DIM
						WHERE	DIM.SalesOrderNumber = Work.SalesOrderNumber 
						  AND   DIM.SalesOrderline   = Work.SalesOrderline
						  AND   DIM.OHOrderSuffix    = Work.OHOrderSuffix
						  AND   DIM.OHInvoiceNumber  = Work.OHInvoiceNumber
						   
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimInvoice 		AS DIM
	 JOIN   #DimInvoice_work	AS Work
	  ON	                    DIM.SalesOrderNumber = Work.SalesOrderNumber 
						  AND   DIM.SalesOrderline   = Work.SalesOrderline
						  AND   DIM.OHOrderSuffix    = Work.OHOrderSuffix
						  AND   DIM.OHInvoiceNumber  = Work.OHInvoiceNumber
	                      AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimInvoice
	SELECT	Work.*
	FROM	#DimInvoice_current AS DIM
	 JOIN   #DimInvoice_work    AS Work
	  ON	  DIM.SalesOrderNumber = Work.SalesOrderNumber 
		AND   DIM.SalesOrderline   = Work.SalesOrderline
		AND   DIM.OHOrderSuffix    = Work.OHOrderSuffix
		AND   DIM.OHInvoiceNumber  = Work.OHInvoiceNumber
	  
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimInvoice_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimInvoice_current	END TRY BEGIN CATCH END CATCH
	 

END