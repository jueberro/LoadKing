CREATE PROCEDURE [dw].[sp_LoadDimPurchaseOrder] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	DECLARE @RowsInsertedCount int
    DECLARE @RowsUpdatedCount int



	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimPurchaseOrder_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimPurchaseOrder_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimPurchaseOrder_work (                              
                                                          
	[POH_PURCHASE_ORDER] [char](7) NULL,      
	[POH_RECORD_NO] [char](4) NULL,      
	[POA_CRITICAL_SUPPL] [char](1) NULL,      
	[POA_APPROVED_SUPPL] [char](1) NULL,              
	[POH_TERMS] [char](12) NULL,          
	[POH_ORDER_TAX] [char](1) NULL,          
	[POH_FLAG_INSURANCE] [char](1) NULL,          
	[POH_BUYER] [char](3) NULL, 
	[POH_DATE_ORDER] [datetime] NULL,
	[POH_DATE_DUE] [datetime] NULL,
	[POH_SHIP_VIA] [char](15) NULL,   	  
	[POH_CODE_FOB] [char](15) NULL,	  
	[POH_FLAG_RECV_CLOSED] [char](1) NULL,   	  
	[POH_FLAG_ACCT_CLOSE_A] [char](1) NULL,	  
	[POH_FLAG_PRINT] [char](1) NULL,	  
	[POH_PO_SEQ] [char](2) NULL,   	  
	[POH_USER_2] [char](30) NULL,		   	  
	[POH_FLAG_CERTS_REQD] [char](1) NULL,   		  
	[POH_TEXT_FORMAT] [char](1) NULL,	  
	[POH_PREV_SEQ] [char](2) NULL,   	  
	[POH_DIFF_DUE_DATE] [char](1) NULL,	  
	[POH_PHYS_CHEM] [char](1) NULL,	  
	[POH_PAY_WITH_CCARD] [char](1) NULL, 	  
	[POH_REC_TYPE] [char](1) NULL, 	  
	[POH_PART_PD] [numeric](14, 2) NULL, 	  
    [POH_SB_PAID] [numeric](14, 2) NULL,      
	[POH_DISCOUNT_A] [numeric](5, 4) NULL,
    [POL_PO_TYPE] [char](1) NULL,
    [POL_LOCATION] [char](2) NULL, 
    [POL_DESCRIPTION] [char](30) NULL,
    [POL_PART_MFG_NO] [char](23) NULL, 
    [dropshippo_flag] [CHAR](1) null,
	[POL_FILL_EXTENSION] [numeric](1, 0) NULL,
    [POL_EXTENSION] [numeric](15, 2) NULL, 
    [POL_FILLER10] [char](14) NULL,
	[POL_FILL_EXCH_EXT] [numeric](1, 0) NULL,
	[POL_REQUISITION_LINE] [numeric](3, 0) NULL,
	[POL_FILL_IVCOST] [numeric](1, 0) NULL,
	[POL_FILL_PT] [numeric](1, 0) NULL,
	[POL_FILL_VT] [numeric](1, 0) NULL, 
	[POL_VAT_RULE] [numeric](3, 0) NULL,
	[POL_USE_PURPOSE] [numeric](3, 0) NULL,
	[POL_BOOK_USE_TAX] [bit] NULL,
	[POL_FLAG_REC_TYPE] [char](1) NULL,

	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL 
	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #DimPurchaseOrder_work
			SELECT 		
				 * from dwstage.V_LoadDimPurchaseOrder
    
    Update #DimPurchaseOrder_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimPurchaseOrder_current ( POH_PURCHASE_ORDER CHAR(7),
                                             POH_RECORD_NO      char(4) ,
										     Type2RecordHash   VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimPurchaseOrder_current
	SELECT		POH_PURCHASE_ORDER, POH_RECORD_NO, Type2RecordHash

	FROM	dw.DimPurchaseOrder
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimPurchaseOrder
	SELECT	*
	FROM	#DimPurchaseOrder_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimPurchaseOrder AS DIM
						WHERE	DIM.POH_PURCHASE_ORDER = Work.POH_PURCHASE_ORDER
						  AND   DIM.POH_RECORD_NO   = Work.POH_RECORD_NO
						
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimPurchaseOrder 		AS DIM
	 JOIN   #DimPurchaseOrder_work	AS Work
	  ON	                    DIM.POH_PURCHASE_ORDER = Work.POH_PURCHASE_ORDER
						  AND   DIM.POH_RECORD_NO   = Work.POH_RECORD_NO
	                      AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


SET @RowsUpdatedCount = @@ROWCOUNT

	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimPurchaseOrder
	SELECT	Work.*
	FROM	#DimPurchaseOrder_current AS DIM
	 JOIN   #DimPurchaseOrder_work    AS Work
	  ON	  DIM.POH_PURCHASE_ORDER = Work.POH_PURCHASE_ORDER
		AND   DIM.POH_RECORD_NO   = Work.POH_RECORD_NO
		
	  
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimPurchaseOrder_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimPurchaseOrder_current	END TRY BEGIN CATCH END CATCH
	 

END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO

