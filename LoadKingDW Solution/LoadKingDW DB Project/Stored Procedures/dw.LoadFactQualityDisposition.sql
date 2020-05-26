--USE [LK-GS-EDW]
--GO

CREATE PROCEDURE dw.sp_LoadFactQualityDisposition @LoadLogKey INT  AS

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

IF object_id('##FactQualityDisposition_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactQualityDisposition_SOURCE
	END

IF object_id('##FactQualityDisposition_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactQualityDisposition_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactQualityDisposition_SOURCE (

DimWorkOrder_Key int NOT NULL,
DimCustomer_Key int NOT NULL,
DimVendor_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimEmployee_Key int NOT NULL,
DimDepartmentEmployee_Key int NOT NULL,
DimDepartmentWorkCenter_Key int NOT NULL,
DimDate_Key int NOT NULL,
-- DEGENERATE DETAIL ATTRIBUTES ---------------
[Header_CONTROL_NUMBER] [char](7) NULL,
[Header_JOB] [char](6) NULL,
[Header_SUFFIX] [char](3) NULL,
[Header_SEQUENCE] [char](6) NULL,
[CONTROL_NUMBER] [char](7) NULL,
[DISPOSITION_SEQ] [char](3) NULL,
[DISCREPANCY] [char](3) NULL,
[DISCREP_DESC] [char](20) NULL,
[DISPOSITION_ACTION] [char](30) NULL,
[USER_DISPOSED_BY] [char](8) NULL,
[NEW_JOB] [char](6) NULL,
[NEW_SUFFIX] [char](3) NULL,
[CNC_ACTION] [char](1) NULL,
[NO_GOOD_RPT] [char](1) NULL,
[INSPECTED_BY] [char](8) NULL,
[USER1] [char](20) NULL,
[USER2] [char](20) NULL,
-- DATES --------------------------------------
[Header_DATE_QUALITY] [date] NULL,
[Header_DATE_ENTERED] [date] NULL,
[Header_F_DATE] [date] NULL,
[Header_CLOSE_DATE] [date] NULL,
[DATE_DISPOSED] [date] NULL,
[TIME_DISPOSED] [char](8) NULL,
[DATE_INSPECTED] [date] NULL,
[DATE_CNC_REQ] [date] NULL,
-- MEASURES ------------------------------------
[QTY_DISPOSED] [numeric](14, 6) NULL,
[DISPOSED_VALUE] [numeric](10, 2) NULL,
/*Hashes used for identifying changes, not required for reporting*/
[Type1RecordHash] VARBINARY(64)	NULL	--66 allows for "0x" + 64 characater hash
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactQualityDisposition_SOURCE
			SELECT * from dwstage.V_LoadFactQualityDisposition

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactQualityDisposition_TARGET 
					(
					Header_CONTROL_NUMBER CHAR(7)
					,Header_JOB CHAR(6)
					,Header_SUFFIX CHAR(3)
					,Header_SEQUENCE CHAR(6)
					,[CONTROL_NUMBER] [char](7)
					,[DISPOSITION_SEQ] [char](3)
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactQualityDisposition_TARGET
	SELECT	
					Header_CONTROL_NUMBER
					,Header_JOB
					,Header_SUFFIX
					,[Header_SEQUENCE]
					,[CONTROL_NUMBER]
					,[DISPOSITION_SEQ]
					,Type1RecordHash
	FROM	dw.FactQualityDisposition

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactQualityDisposition 
	SELECT	*
	FROM	##FactQualityDisposition_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactQualityDisposition AS TGT
						WHERE	
							TGT.Header_CONTROL_NUMBER = SRC.Header_CONTROL_NUMBER
							and TGT.Header_JOB = SRC.Header_JOB
							and TGT.Header_SUFFIX = SRC.Header_SUFFIX
							and TGT.[Header_SEQUENCE] = SRC.[Header_SEQUENCE]
							and TGT.[CONTROL_NUMBER] = SRC.[CONTROL_NUMBER]
							and TGT.[DISPOSITION_SEQ] = SRC.[DISPOSITION_SEQ]							
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
	TGT.DimWorkOrder_Key = SRC.DimWorkOrder_Key
	,TGT.DimCustomer_Key = SRC.DimCustomer_Key
	,TGT.[DimVendor_Key] = SRC.[DimVendor_Key]
	,TGT.DimInventory_Key = SRC.DimInventory_Key
	,TGT.[DimEmployee_Key] = SRC.[DimEmployee_Key]
	,TGT.[DimDepartmentEmployee_Key] = SRC.[DimDepartmentEmployee_Key]
	,TGT.[DimDepartmentWorkCenter_Key] = SRC.[DimDepartmentWorkCenter_Key]
	,TGT.DimDate_Key = SRC.DimDate_Key


	-----------------------------------
	, TGT.[DISCREPANCY] = SRC.[DISCREPANCY]
	, TGT.[DISCREP_DESC] = SRC.[DISCREP_DESC]
	, TGT.[DISPOSITION_ACTION] = SRC.[DISPOSITION_ACTION]
	, TGT.[USER_DISPOSED_BY] = SRC.[USER_DISPOSED_BY]
	, TGT.[NEW_JOB] = SRC.[NEW_JOB]
	, TGT.[NEW_SUFFIX] = SRC.[NEW_SUFFIX]
	, TGT.[CNC_ACTION] = SRC.[CNC_ACTION]
	, TGT.[NO_GOOD_RPT] = SRC.[NO_GOOD_RPT]
	, TGT.[INSPECTED_BY] = SRC.[INSPECTED_BY]
	, TGT.[USER1] = SRC.[USER1]
	, TGT.[USER2] = SRC.[USER2]

	----------------------------------
	, TGT.[Header_DATE_QUALITY] = SRC.[Header_DATE_QUALITY]
	, TGT.[Header_DATE_ENTERED] = SRC.[Header_DATE_ENTERED]
	, TGT.[Header_F_DATE] = SRC.[Header_F_DATE]
	, TGT.[Header_CLOSE_DATE] = SRC.[Header_CLOSE_DATE]
	, TGT.[DATE_DISPOSED] = SRC.[DATE_DISPOSED]
	, TGT.[TIME_DISPOSED] = SRC.[TIME_DISPOSED]
	, TGT.[DATE_INSPECTED] = SRC.[DATE_INSPECTED]
	, TGT.[DATE_CNC_REQ] = SRC.[DATE_CNC_REQ]

	--------------------------------
	, TGT.[QTY_DISPOSED] = SRC.[QTY_DISPOSED]
	, TGT.[DISPOSED_VALUE] = SRC.[DISPOSED_VALUE]

	, TGT.Type1RecordHash = SRC.Type1RecordHash
	FROM	dw.FactQualityDisposition		AS TGT
	 JOIN   ##FactQualityDisposition_SOURCE	AS SRC
			ON TGT.Header_CONTROL_NUMBER = SRC.Header_CONTROL_NUMBER
			and TGT.Header_JOB = SRC.Header_JOB
			and TGT.Header_SUFFIX = SRC.Header_SUFFIX
			and TGT.[Header_SEQUENCE] = SRC.[Header_SEQUENCE]

			and TGT.[CONTROL_NUMBER] = SRC.[CONTROL_NUMBER]
			and TGT.[DISPOSITION_SEQ] = SRC.[DISPOSITION_SEQ]

	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash
	
	--DROP temp tables

SET @RowsUpdatedCount = @@ROWCOUNT

	 DROP TABLE ##FactQualityDisposition_SOURCE		
	 DROP TABLE ##FactQualityDisposition_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount


GO


