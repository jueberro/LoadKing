CREATE PROCEDURE [dw].[sp_LoadDimWorkOrder] @LoadLogKey INT  AS

BEGIN


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimWorkOrder_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimWorkOrder_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimWorkOrder_work (
		[WorkOrderNumber_DW]				[nchar](13) NOT NULL,
		[WorkOrderNumber]			        [nchar](7)  NULL,
		

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
	INSERT INTO #DimWorkOrder_work
			SELECT 		
				 * from dwstage.V_LoadDimWorkOrder
    
    Update #DimWorkOrder_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimWorkOrder_current (WorkOrderNumber_DW NVARCHAR(6))

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimWorkOrder_Current
	SELECT	WorkOrderNumber_DW
			
	FROM	dw.DimWorkOrder
	WHERE	[DWIsCurrent] = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimWorkOrder 
	SELECT	*
	FROM	#DimWorkOrder_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimWorkOrder AS DIM
						WHERE	DIM.WorkOrderNumber_DW = Work.WorkOrderNumber_DW )


	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimWorkOrder		AS DIM
	 JOIN   #DimWorkOrder_work	AS Work
	  ON	DIM.WorkOrderNumber_DW  = Work.WorkOrderNumber_DW
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.WorkOrderNumber_DW <> Work.WorkOrderNumber_DW


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimWorkOrder
	SELECT	Work.*
	FROM	#DimWorkOrder_current AS DIM
	 JOIN   #DimWorkOrder_work    AS Work
	  ON	Dim.WorkOrderNumber_DW = Work.WorkOrderNumber_DW
	WHERE	DIM.WorkOrderNumber_DW <> Work.WorkOrderNumber_DW
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimWorkOrder_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimWorkOrder_current	END TRY BEGIN CATCH END CATCH
	 

END
GO
