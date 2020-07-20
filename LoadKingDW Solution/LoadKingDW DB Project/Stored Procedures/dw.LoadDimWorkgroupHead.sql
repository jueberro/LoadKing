CREATE PROCEDURE [dw].[sp_LoadDimWorkGroupHead] @LoadLogKey INT  AS

BEGIN

--DECLARE @LoadLogKey int
--SET @LoadLogKey = 0

DECLARE @RowsInsertedCount int
DECLARE @RowsUpdatedCount int


	/*

	- This procedure is called from an SSIS package
	- This procedure assumes that a stage table has been loaded with data for one and ONLY one batch of source data
	
	- @LoadLogKey	- corresponds to LoadLogKey in dwetl.LoadLog table

	*/

	DECLARE		@CurrentTimestamp DATETIME2(7)

	SELECT		@CurrentTimestamp = GETUTCDATE()

	BEGIN TRY DROP TABLE #DimWorkGroupHead_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimWorkGroupHead_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DimWorkGroupHead_work (
		Work_Group				NCHAR(4) NULL,
		Descr  	            NVARCHAR(20) NULL,
		Prototype_WC            NCHAR(4) NULL,
		Type                    NCHAR(1) NULL,
		Nesting                 NCHAR(1) NULL,

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
	INSERT INTO #DimWorkGroupHead_work
			SELECT 		
				 * from dwstage.V_LoadDimWorkGroupHead
    
    Update #DimWorkGroupHead_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimWorkGroupHead_current (Work_Group NCHAR(4)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimWorkGroupHead_current
	SELECT	 Work_Group
			,Type2RecordHash
	FROM	dw.DimWorkGroupHead
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimWorkGroupHead 
	SELECT	*
	FROM	#DimWorkGroupHead_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimWorkGroupHead AS DIM
						WHERE	DIM.Work_Group = Work.Work_Group 
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimWorkGroupHead		AS DIM
	 JOIN   #DimWorkGroupHead_work	AS Work
	  ON	Dim.Work_Group = Work.Work_Group
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimWorkGroupHead
	SELECT	Work.*
	FROM	#DimWorkGroupHead_current AS DIM
	 JOIN   #DimWorkGroupHead_work    AS Work
	  ON	Dim.Work_Group = Work.Work_Group
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DimWorkGroupHead_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimWorkGroupHead_current	END TRY BEGIN CATCH END CATCH
	 

END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO
