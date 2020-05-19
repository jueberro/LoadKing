CREATE PROCEDURE [dw].[sp_LoadFactInventory] @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

	/*
	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table
	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	DECLARE     @RowsInsertedCount int
    DECLARE     @RowsUpdatedCount int


	SELECT		@CurrentTimestamp = GETUTCDATE()

	--BEGIN TRY DROP TABLE ##Factinventory_SOURCE		END TRY BEGIN CATCH END CATCH
	--BEGIN TRY DROP TABLE ##FactInventory_TARGET	    END TRY BEGIN CATCH END CATCH

IF object_id('##FactInventory_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactInventory_SOURCE
	END

IF object_id('##FactInventory_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactInventory_TARGET
	END


	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactInventory_SOURCE (
  
  -- dimensions

	DimInventory_Key int not null,
	
		
	PartID					nchar(20)			NOT NULL,
	DateLastUsage			datetime			NOT NULL,      
	DateLastAudit			datetime			NOT NULL, 		  
	Location				nchar(2)				NULL,
	DateLastChg				datetime				NULL,
	WhoChgLast				nchar(8)				NULL,
	BIN						nchar(6)			    NULL, 
	DateCycle				datetime                NULL,
	CodeBOM					nchar(1)        	  	NULL,
	CodeDiscount			nchar(1)          		NULL,
	CodeTotal				nchar(1)         		NULL,
	PriorUsage				decimal(16, 6)	  		NULL,
	AltCostAmt				decimal(12, 4)      	NULL,
	MinMultiple				decimal(12, 4)          NULL,
	FloorStockingLevel		decimal(12, 4)  	  	NULL,
	QtyOnHand				decimal(12, 4)      	NULL,
	QtyReorder				decimal(12, 4)      	NULL, 
	QtyOnOrderPO			decimal(12, 4)      	NULL,  
	QtyOnOrderWO			decimal(12, 4)      	NULL,  
	QtyRequired				decimal(12, 4)      	NULL,
	AmtCost  				decimal(12,4) 	    	NULL,
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
    RecordHash              Varbinary(64)	        NULL

	)

	--Load #work table with data in the format in which it will appear in the dimension
	INSERT INTO  ##FactInventory_SOURCE
			SELECT 		
				 * from dwstage.V_LoadFactInventory

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactInventory_TARGET 
					(
					                       PartID           NCHAR(20),
                                           Location         nchar(2) ,
	                                       RecordHash   VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactInventory_TARGET
	SELECT	
			 PartID
			,Location 
            ,RecordHash


	FROM	dw.FactInventory

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactInventory
	SELECT	*
	FROM	##FactInventory_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactInventory AS TGT
						WHERE	
							    TGT.PartID = SRC.PartID
							and TGT.Location   = SRC.Location 
								
						)

SET @RowsInsertedCount = @@ROWCOUNT


	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET

    TGT.[DimInventory_Key]              = SRC.DimInventory_Key     ,
	TGT.PartID				             = SRC.PartID				,
	TGT.DateLastUsage					 = SRC.DateLastUsage		,
	TGT.DateLastAudit					 = SRC.DateLastAudit		,
	TGT.Location						 = SRC.Location				,
	TGT.DateLastChg						 = SRC.DateLastChg			,
	TGT.WhoChgLast						 = SRC.WhoChgLast			,
	TGT.BIN								 = SRC.BIN					,
	TGT.DateCycle						 = SRC.DateCycle			,
	TGT.CodeBOM							 = SRC.CodeBOM				,
	TGT.CodeDiscount					 = SRC.CodeDiscount			,
	TGT.CodeTotal						 = SRC.CodeTotal			,
	TGT.PriorUsage						 = SRC.PriorUsage			,
	TGT.AltCostAmt						 = SRC.AltCostAmt			,
	TGT.MinMultiple						 = SRC.MinMultiple			,
	TGT.FloorStockingLevel				 = SRC.FloorStockingLevel	,
	TGT.QtyOnHand						 = SRC.QtyOnHand			,
	TGT.QtyReorder						 = SRC.QtyReorder			,
	TGT.QtyOnOrderPO					 = SRC.QtyOnOrderPO			,
	TGT.QtyOnOrderWO					 = SRC.QtyOnOrderWO			,
	TGT.QtyRequired						 = SRC.QtyRequired			,
	TGT.AmtCost  						 = SRC.AmtCost  			,
	TGT.UsageJanuary					 = SRC.UsageJanuary			,
	TGT.UsageFebruary					 = SRC.UsageFebruary		,
	TGT.UsageMarch						 = SRC.UsageMarch			,
	TGT.UsageApril						 = SRC.UsageApril			,
	TGT.UsageMay						 = SRC.UsageMay				,
	TGT.UsageJune						 = SRC.UsageJune			,
	TGT.UsageJuly						 = SRC.UsageJuly			,
	TGT.UsageAugust						 = SRC.UsageAugust			,
	TGT.UsageSeptember					 = SRC.UsageSeptember		,
	TGT.UsageOctober					 = SRC.UsageOctober			,
	TGT.UsageNovember					 = SRC.UsageNovember		,
	TGT.UsageDecember					 = SRC.UsageDecember		,
	TGT.RecordHash           			 = SRC.RecordHash          	


FROM	dw.FactInventory		    AS TGT
	 JOIN   ##FactInventory_SOURCE	AS SRC
			ON  TGT.PartID = SRC.PartID
			and TGT.Location  = SRC.Location 
				   
	WHERE	TGT.RecordHash <> SRC.RecordHash
	

SET @RowsUpdatedCount = @@ROWCOUNT




   
	
	--DROP temp tables
	BEGIN TRY DROP TABLE ##FactInventory_SOURCE		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE ##FactInventory_TARGET	END TRY BEGIN CATCH END CATCH
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO
