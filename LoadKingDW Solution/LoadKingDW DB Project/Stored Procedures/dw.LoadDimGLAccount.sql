CREATE PROCEDURE [dw].[sp_LoadDimGLAccount] @LoadLogKey INT  AS

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

	BEGIN TRY DROP TABLE #DimGLAccount_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DimGLAccount_current	END TRY BEGIN CATCH END CATCH

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE #DIMGLAccount_work (
		[GLAccount]					[char](15) NOT NULL,
		[DESCR]						[char](30) NOT NULL,
		[DEPT]						[char](4) NOT NULL,
		[RetainedAcct]				[char](15) NOT NULL,
		[ZeroAtYrEnd]				[char](1) NOT NULL,
		[User1]						[char](30) NULL,
		[User2]						[char](30) NULL,
		[User3]						[char](30) NULL,
		[User4]						[char](30) NULL,
		[User5]						[char](30) NULL,

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
	INSERT INTO #DimGLAccount_work
			SELECT 		
				 * from dwstage.V_LoadDimGLAccount
    
    Update #DimGLAccount_work Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE #DimGLAccount_current (GLAccount CHAR(15)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO #DimGLAccount_current
	SELECT	GLAccount
			,Type2RecordHash
	FROM	dw.DimGLAccount
	WHERE	DWIsCurrent = 1


	--select * from #DimGLAccount_current

	--INSERT NEW Dimension Items
	INSERT INTO dw.DimGLAccount 
	SELECT	*
	FROM	#DimGLAccount_work AS Work
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimGLAccount AS DIM
						WHERE	DIM.GLAccount = Work.GLAccount 
						)
SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimGLAccount		AS DIM
	 JOIN   #DIMGLAccount_work	AS Work
	  ON	Dim.GLAccount  = Work.GLAccount 
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT

	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimGLAccount
	SELECT	Work.*
	FROM	#DimGLAccount_current AS DIM
	 JOIN   #DIMGLAccount_work    AS Work
	  ON	Dim.GLAccount = Work.GLAccount
	WHERE	DIM.Type2RecordHash <> Work.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE #DIMGLAccount_work		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE #DIMGLAccount_current	END TRY BEGIN CATCH END CATCH

End


SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO