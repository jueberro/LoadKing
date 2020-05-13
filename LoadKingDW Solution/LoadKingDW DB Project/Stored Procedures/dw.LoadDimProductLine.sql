--USE [LK-GS-EDW]
--GO


CREATE PROCEDURE dw.sp_LoadDimProductLine @LoadLogKey INT  AS

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

	--BEGIN TRY DROP TABLE ##DimProductLine_SOURCE		END TRY BEGIN CATCH END CATCH
	--BEGIN TRY DROP TABLE ##DimProductLine_TARGET	END TRY BEGIN CATCH END CATCH

IF object_id('##DimProductLine_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##DimProductLine_SOURCE
	END

IF object_id('##DimProductLine_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##DimProductLine_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##DimProductLine_SOURCE (
		[ProductLine]				[nchar](6) NOT NULL,
		[ProductLineName]				[nvarchar](50) NOT NULL,

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

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##DimProductLine_SOURCE
			SELECT 		
				 * from dwstage.V_LoadDimProductLine

/*
INSERT INTO dwstage.JOB_HEADER
SELECT * FROM [LK-GS-ODS].dbo.JOB_HEADER

INSERT INTO dwstage.PRODUCT_LINE
SELECT * FROM [LK-GS-ODS].dbo.PRODUCT_LINE
*/

--SELECT * FROM ##DimProductLine_SOURCE



    Update ##DimProductLine_SOURCE Set [DWEffectiveStartDate] = @CurrentTimestamp, [LoadLogKey]	 = @LoadLogKey

    ----  UPDATE The 
	--CREATE TEMP table to be used below for identifying records with Type 2 changes
	CREATE TABLE ##DimProductLine_TARGET (ProductLine NCHAR(5)
										, Type2RecordHash VARBINARY(64)
										)

	--Load temp table with NK and Type2RecordHash for CURRENT dimension records
	INSERT INTO ##DimProductLine_TARGET
	SELECT	ProductLine
			, Type2RecordHash
	FROM	dw.DimProductLine
	WHERE	DWIsCurrent = 1


	--INSERT NEW Dimension Items
	INSERT INTO dw.DimProductLine 
	SELECT	*
	FROM	##DimProductLine_SOURCE AS SOURCE
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.DimProductLine AS DIM
						WHERE	DIM.ProductLine = SOURCE.ProductLine 
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE/Expire Existing Items that have Type 2 changes
	UPDATE	DIM
	SET		DWEffectiveEndDate = @CurrentTimestamp
			, DWIsCurrent = 0
	FROM	dw.DimProductLine		AS DIM
	 JOIN   ##DimProductLine_SOURCE	AS SOURCE
	  ON	Dim.ProductLine = SOURCE.ProductLine
	   AND	Dim.DWIsCurrent = 1
	WHERE	DIM.Type2RecordHash <> SOURCE.Type2RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT


	--INSERT New versions of expired records that have Type 2 changes
	INSERT INTO dw.DimProductLine
	SELECT	SOURCE.*
	FROM	##DimProductLine_TARGET AS DIM
	 JOIN   ##DimProductLine_SOURCE    AS SOURCE
	  ON	Dim.ProductLine = SOURCE.ProductLine
	WHERE	DIM.Type2RecordHash <> SOURCE.Type2RecordHash
	
	--DROP temp tables
	BEGIN TRY DROP TABLE ##DimProductLine_SOURCE		END TRY BEGIN CATCH END CATCH
	BEGIN TRY DROP TABLE ##DimProductLine_TARGET	END TRY BEGIN CATCH END CATCH
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO


