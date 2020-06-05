CREATE PROCEDURE [dw].[sp_LoadDimCustomerShipTo] @LoadLogKey INT  AS

BEGIN

DECLARE @RowsInsertedCount int
DECLARE @RowsUpdatedCount int
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
	CREATE TABLE #DimCustomerShipTo_work (
   	PrimaryCustomerID			NCHAR(6)                      NOT NULL, 
	ShipToSeq					NCHAR(6)                      NOT NULL, 
	ShipToCustomername			NVARCHAR(30)                  NOT NULL,  
	ShipToAddress1				NVARCHAR(30)             NULL, 
	ShipToAddress2				NVARCHAR(30)             NULL,
	ShipToAddress3    			NVARCHAR(30)             NULL,
	ShipToAddress4  			NVARCHAR(30)             NULL,
	ShipToCity      			NCHAR(15)                NULL,
	ShipToState	    			NCHAR(2)                 NULL,
	ShipToZip	    			NCHAR(13)                NULL,
	ShipToCountry   			NCHAR(12)                NULL,
	ShipToAttention 			NVARCHAR(30)             NULL, 
	ShipToTelephone      		NCHAR(13)                NULL,
	ShipToSalesperson     		NCHAR(3)                 NULL,
	ShipToShipVia 		  		NCHAR(1)                 NULL,
	ShipToBranch 		  		NCHAR(2)                 NULL,
	ShipToTaxENo		  		NCHAR(20)                NULL,
	ShipToTaxState 		  		NCHAR(2)                 NULL,
	ShipToTaxZip 		  		NCHAR(13)                NULL,
	ShipToTax1 			  		NCHAR(3)                 NULL,
	ShipToTax2 			  		NCHAR(3)                 NULL,
	ShipToTax3 			  		NCHAR(3)                 NULL,
	ShipToTax4			  		NCHAR(3)                 NULL,
	ShipToTax5 			  		NCHAR(3)                 NULL,
	ShipToWhoLastChanged		NVARCHAR(8)              NULL, 
	ShipToTrmLastChanged		NUMERIC(2,0)             NULL,
	ShipToDateLastChanged		DateTime                 NULL,  
	ShipToPrimaryGroup			NCHAR(2)                 NULL,
	ShipToCarrierCD				NCHAR(6)                 NULL,  


		/*Hashes used for identifying changes, not required for reporting*/
		[Type1RecordHash]			VARBINARY(64)  	NULL,	--66 allows for "0x" + 64 characater hash
		[Type2RecordHash]			VARBINARY(64)	NULL,	--66 allows for "0x" + 64 characater hash

		/*DW Metadata fields, not required for reporting*/
		[SourceSystemName]			NVARCHAR(100)		NOT NULL,
		[DWEffectiveStartDate]		DATETIME2(7)		NOT NULL,
		[DWEffectiveEndDate]		DATETIME2(7)		NOT NULL,
		[DWIsCurrent]				BIT					NOT NULL,

		/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
		[LoadLogKey]				INT
	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #DimCustomerShipTo_work
			SELECT 		
				 * from dwstage.V_LoadDimCustomerShipTo
    
    Update #DimCustomerShipTo_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimCustomerShipTo_current ( PrimaryCustomerID NCHAR(6)
	                                        , ShipToSeq         NCHAR(6) 
									    	, Type2RecordHash   VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimCustomerShipTo_current
	SELECT		PrimaryCustomerID,  ShipToSeq, Type2RecordHash

	FROM	dw.DimCustomerShipTo
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
SET @RowsInsertedCount = @@ROWCOUNT

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

SET @RowsUpdatedCount = @@ROWCOUNT


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

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO
