CREATE PROCEDURE [dw].[sp_LoadDimInventory] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimCustomerShipTo_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimCustomerShipTo_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimInventory_work (
    [PartID]             NCHAR (20)       NULL,
    [PartLocation]       NCHAR (2)        NULL,
    [PartCodeAbc]        NCHAR (1)        NULL,
    [PartProductLine]    NCHAR (2)        NULL,
    [PartBin]            NCHAR (6)        NULL,
    [PartDescription]    NVARCHAR (100)   NULL,
    [PartPrice]          NUMERIC (13, 5) NULL,
    [PartObsoleteFlag]   BIT             NULL,
    [PartCodeBom]        NCHAR (1)        NULL,
    [PartCodeDiscount]   NCHAR (1)        NULL,
    [PartCodeTotal]      NCHAR (1)        NULL,
    [PartCodeSort]       NCHAR (10)       NULL,
    [PartVendorName]     NVARCHAR (50)    NULL,
    [PartDescription2]   NVARCHAR (100)   NULL,
    [PartDescription3]   NVARCHAR (100)   NULL,
    [PartVatProductType] NCHAR (5)        NULL,
    [PartTaxExemptFlag]  NCHAR (1)        NULL,

	/*Hashes used for identifying changes, not required for reporting*/
	Type1RecordHash				VARBINARY(64)				NULL,	
	Type2RecordHash				VARBINARY(64)				NULL,	

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	LoadLogKey					INT					NOT NULL, --ID of ETL process that inserted the record    CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED ([DimEmployee_Key] ASC)

	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #DimInventory_work
			SELECT 		
				 * from dwstage.V_LoadDimInventory
    
    Update #DimInventory_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimInventory_current ( PartID NCHAR(20)
	                                        
									    	, Type2RecordHash   VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimInventory_current
	SELECT		PartID, Type2RecordHash

	FROM	dw.DimInventory
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimCustomerShipTo 
	SELECT	*
	FROM	#DimCustomerShipTo_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimCustomerShipTo AS DIM
						WHERE	DIM.PrimaryCustomerID = Work.PrimaryCustomerID 
						    and DIM.ShipToSeq         = Work.ShipToSeq
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimCustomerShipTo		AS DIM
	 JOIN   #DimCustomerShipTo_work	AS Work
	  ON	Dim.PrimaryCustomerID = Work.PrimaryCustomerID
	   AND  Dim.ShipToSeq         = Work.ShipToSeq
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimCustomerShipTo
	SELECT	Work.*
	FROM	#DimCustomerShipTo_current AS DIM
	 JOIN   #DimCustomerShipTo_work    AS Work
	  ON	Dim.PrimaryCustomerID = Work.PrimaryCustomerID
	   AND  Dim.ShipToSeq         = Work.ShipToSeq
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimCustomerShipTo_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimCustomerShipTo_current	END TRY BEGIN CATCH END CATCH
	 

END