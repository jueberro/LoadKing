--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE dw.sp_LoadFactQuality @LoadLogKey INT  AS

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

IF object_id('##FactQuality_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactQuality_SOURCE
	END

IF object_id('##FactQuality_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactQuality_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactQuality_SOURCE (

DimQualityDisposition_Key int NOT NULL,
DimWorkOrder_Key int NOT NULL,
DimCustomer_Key int NOT NULL,
DimVendor_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimEmployee_Key int NOT NULL,
DimDepartmentEmployee_Key int NOT NULL,
DimDepartmentWorkCenter_Key int NOT NULL,
DimDate_Key int NOT NULL,
-- DEGENERATE DETAIL ATTRIBUTES ---------------
[CONTROL_NUMBER] char(7),
[JOB] [varchar](50) NULL,
[SUFFIX] [varchar](50) NULL,
[SEQUENCE] [char](6) NULL,
[KEY_SEQ] [char](4) NULL, -- DK
[PO_LINE] [char](4) NULL, -- DK
[CUSTOMER_PO] [char](20) NULL, -- DK
[SCRAP_CODE] [char](2) NULL, -- DK
[ORIGINATOR] [char](8) NULL, -- DK
-- DATES --------------------------------------
[DATE_QUALITY] datetime NULL,
[DATE_ENTERED] datetime NULL,
[TIME_ENTERED] [char](8) NULL,
[F_DATE] datetime NULL,
[CLOSE_DATE] datetime NULL,
-- MEASURES ------------------------------------
[QTY_REJECTED] [numeric](14, 6) NULL,
[ORIG_SCRAP_VALUE] [numeric](12, 2) NULL,
[QTY_REMAINING] [numeric](14, 6) NULL,
[REMAINING_VALUE] [numeric](12, 2) NULL,
[UNIT_COST_MATL] [numeric](16, 6) NULL,
[UNIT_COST_LABOR] [numeric](16, 6) NULL,
[UNIT_COST_OVHD] [numeric](16, 6) NULL,
[UNIT_COST_OUTSIDE] [numeric](16, 6) NULL,
[FREIGHT_COST] [numeric](16, 6) NULL,
[OTHER_COST] [numeric](16, 6) NULL,
[CONV_FACTOR] [numeric](11, 5) NULL,
/*Hashes used for identifying changes, not required for reporting*/
[Type1RecordHash] VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactQuality_SOURCE
			SELECT * from dwstage.V_LoadFactQuality

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactQuality_TARGET 
					(
					CONTROL_NUMBER CHAR(7)
					,JOB CHAR(6)
					,SUFFIX CHAR(3)
					,SEQUENCE CHAR(6)
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactQuality_TARGET
	SELECT	
					CONTROL_NUMBER
					,JOB
					,SUFFIX
					,[SEQUENCE]
					,Type1RecordHash
	FROM	dw.FactQuality

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactQuality 
	SELECT	*
	FROM	##FactQuality_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactQuality AS TGT
						WHERE	
							TGT.CONTROL_NUMBER = SRC.CONTROL_NUMBER
							and TGT.JOB = SRC.JOB
							and TGT.SUFFIX = SRC.SUFFIX
							and TGT.[SEQUENCE] = SRC.[SEQUENCE]					
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
	TGT.DimQualityDisposition_Key = SRC.DimQualityDisposition_Key
	,TGT.DimWorkOrder_Key = SRC.DimWorkOrder_Key
	,TGT.DimCustomer_Key = SRC.DimCustomer_Key
	,TGT.[DimVendor_Key] = SRC.[DimVendor_Key]
	,TGT.DimInventory_Key = SRC.DimInventory_Key
	,TGT.[DimEmployee_Key] = SRC.[DimEmployee_Key]
	,TGT.[DimDepartmentEmployee_Key] = SRC.[DimDepartmentEmployee_Key]
	,TGT.[DimDepartmentWorkCenter_Key] = SRC.[DimDepartmentWorkCenter_Key]
	,TGT.DimDate_Key = SRC.DimDate_Key


	-----------------------------------
	, TGT.[KEY_SEQ] = SRC.[KEY_SEQ]
	, TGT.[PO_LINE] = SRC.[PO_LINE]
	, TGT.[CUSTOMER_PO] = SRC.[CUSTOMER_PO]
	, TGT.[SCRAP_CODE] = SRC.[SCRAP_CODE]
	, TGT.[ORIGINATOR] = SRC.[ORIGINATOR]

	----------------------------------
	, TGT.DATE_QUALITY = SRC.DATE_QUALITY
	, TGT.DATE_ENTERED = SRC.DATE_ENTERED
	, TGT.[TIME_ENTERED] = SRC.[TIME_ENTERED]
	, TGT.F_DATE = SRC.F_DATE
	, TGT.CLOSE_DATE = SRC.CLOSE_DATE

	--------------------------------
	, TGT.[QTY_REJECTED] = SRC.[QTY_REJECTED]
	, TGT.[ORIG_SCRAP_VALUE] = SRC.[ORIG_SCRAP_VALUE]
	, TGT.[QTY_REMAINING] = SRC.[QTY_REMAINING]
	, TGT.[REMAINING_VALUE] = SRC.[REMAINING_VALUE]
	, TGT.[UNIT_COST_MATL] = SRC.[UNIT_COST_MATL]
	, TGT.[UNIT_COST_LABOR] = SRC.[UNIT_COST_LABOR]
	, TGT.[UNIT_COST_OVHD] = SRC.[UNIT_COST_OVHD]
	, TGT.[UNIT_COST_OUTSIDE] = SRC.[UNIT_COST_OUTSIDE]
	, TGT.[FREIGHT_COST] = SRC.[FREIGHT_COST]
	, TGT.[OTHER_COST] = SRC.[OTHER_COST]
	, TGT.[CONV_FACTOR] = SRC.[CONV_FACTOR]
	, TGT.Type1RecordHash = SRC.Type1RecordHash
	FROM	dw.FactQuality		AS TGT
	 JOIN   ##FactQuality_SOURCE	AS SRC
			ON TGT.CONTROL_NUMBER = SRC.CONTROL_NUMBER
			and TGT.JOB = SRC.JOB
			and TGT.SUFFIX = SRC.SUFFIX
			and TGT.[SEQUENCE] = SRC.[SEQUENCE]
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash
	
	--DROP temp tables

SET @RowsUpdatedCount = @@ROWCOUNT

	 DROP TABLE ##FactQuality_SOURCE		
	 DROP TABLE ##FactQuality_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO


