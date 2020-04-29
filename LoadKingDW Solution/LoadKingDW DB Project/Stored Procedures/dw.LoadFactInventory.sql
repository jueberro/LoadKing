CREATE PROCEDURE [dw].[sp_LoadFactInventory] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

    SELECT		@CurrentTimestamp = GETUTCDATE()
	
	--Set @LoadLogKey = 21

	BEGIN TRY DROP TABLE #FactInventory_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #FactInventory_current	    END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #FactInventory_work (
  
  -- dimensions

	DimInventory_Key int not null,
	
		
	PartID					nchar(20)			NOT NULL,
	DateLastUsage			datetime			NOT NULL,      
	DateLastAudit			datetime			NOT NULL, 		  
	Location				nchar(2)				NULL,
	DateLastChg				datetime				NULL,
	WhoChgLast				datetime				NULL,
	BIN						nchar(6)			    NULL, 
	DateCycle				nchar(1)                NULL,
	CodeBOM					nchar(1)        	  	NULL,
	CodeDiscount			nchar(1)          		NULL,
	CodeTotal				decimal(7, 0)      		NULL,
	PriorUsage				decimal(16, 6)	  		NULL,
	AltCostAmt				decimal(12, 4)      	NULL,
	MinMultiple				decimal(12, 4)          NULL,
	FloorStockingLevel		decimal(12, 4)  	  	NULL,
	QtyOnHand				decimal(12, 4)      	NULL,
	QtyReorder				decimal(12, 4)      	NULL, 
	QtyOnOrderPO			decimal(12, 4)      	NULL,  
	QtyOnOrderWO			decimal(12, 4)      	NULL,  
	QtyRequired				decimal(12, 4)      	NULL,
	AmtCost  				decimal(7,0) 	    	NULL,
	UsageJanuary			decimal(7,0) 	  		NULL,
	UsageFebruary			decimal(7,0) 	  		NULL,
	UsageMarch				decimal(7,0) 	    	NULL,
	UsageApril				decimal(7,0) 	    	NULL,
	UsageMay				decimal(7,0) 	        NULL,
	UsageJune				decimal(7,0) 	    	NULL,
	UsageJuly				decimal(7,0) 	    	NULL,
	UsageAugust				decimal(7,0) 	    	NULL,
	UsageSeptember			decimal(7,0) 	  		NULL,
	UsageOctober			decimal(7,0) 	  		NULL,
	UsageNovember			decimal(7,0) 	  		NULL,
	UsageDecember			decimal(7,0)    		NULL,
		
	/*Hash used for identifying changes, not required for reporting*/
	RecordHash					VARBINARY(64)			NULL,

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
    DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent			     	BIT				    NOT NULL,
	
	/*ETL Metadata fields, not required for reporting */
	LoadLogKey					INT					NOT NULL	--ID of ETL process that inserted the record
	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO #FactInventory_work
			SELECT 		
				 * from dwstage.V_LoadFactInventory
				     
    
    Update #FactInventory_work 
	Set 
	[DWEffectiveStartDate] = @CurrentTimestamp, 
	[LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #FactInventory_current ( PartID NCHAR(20)
	                                        ,  Location   NCHAR(2)
									    	,  RecordHash   VARBINARY(64)
										     )

	--Load temp table with NK and Type2RecordHash for CURRENT Extension records
	INSERT INTO #FactInventory_current
	SELECT		PartID, 
	            Location, 
				RecordHash

	FROM	dw.FactInventory
	WHERE	DWIsCurrent = 1


	--INSERT NEW Fact Items
	INSERT INTO dw.FactInventory
	SELECT	*
	FROM	#FactInventory_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactInventory AS Fact
						WHERE	Fact.PartID = Work.PartID
						 AND    Fact.Location   = Work.Location
						 
						)


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	Fact
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.FactInventory		AS Fact
	 JOIN   #FactInventory_work	AS Work
	  ON	fact.PartID = Work.PartID
	      AND fact.Location = Work.Location
	        AND	fact.DWIsCurrent = 1
	WHERE	Fact.RecordHash <> Work.RecordHash


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.FactInventory
	SELECT	Work.*
	FROM	#FactInventory_current AS Fact
	 JOIN   #FactInventory_work    AS Work
	  ON	Fact.PartID = Work.PartID
	    AND   Fact.Location = Work.Location
	  
	WHERE	Fact.RecordHash <> Work.RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #FactInventory_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #FactInventory_current	END TRY BEGIN CATCH END CATCH
	 

END

