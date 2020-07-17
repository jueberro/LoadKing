CREATE PROCEDURE [dw].[sp_LoadFactEngineeringECR] @LoadLogKey INT  AS

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

IF object_id('##FactEngineeringECR_SOURCE', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactEngineeringECR_SOURCE
	END

IF object_id('##FactEngineeringECR_TARGET', 'U') is not null -- if table exists
	BEGIN
		Drop table ##FactEngineeringECR_TARGET
	END

	--CREATE TEMP table With SAME structure as destination table (except for IDENTITY field)
	CREATE TABLE ##FactEngineeringECR_SOURCE (
	[ECR] [bigint] NULL,
	[DATE_ENTERED] [date] NULL,
	[COMPLETED_DATE] [date] NULL,
	[ORIG_USER] [char](8) NULL,
	[PROJECT_TYPE] [char](30) NULL,
	[ECC] [char](15) NULL,
	[PART] [char](20) NULL,
	[WO] [char](10) NULL,
	[SO] [char](12) NULL,
	[ISSUE] [char](50) NULL,
	[DESCRIPTION] [varchar](128) NULL,
	[ROOT_CAUSE] [varchar](256) NULL,
	[ACTION_PLAN] [varchar](256) NULL,
	[STATUS] [char](30) NULL,
	[ASSIGNED_DEPT] [char](4) NULL,
	[ASSIGNED_TO] [char](8) NULL,
	[SOURCE] [char](30) NULL,
	[DUE_DATE] [date] NULL,
	[PRIORITY] [char](8) NULL,
	[EST_COST_INC] [float] NULL,
	[WORKGROUP] [char](15) NULL,
	[QA_SIGNOFF] [bit] NULL,
	[QA_USER] [char](8) NULL,
	[ADD_GROUP_1] [char](5) NULL,
	[GROUP_1_SIGNOFF] [bit] NULL,
	[GROUP_1_USER] [char](8) NULL,
	[ADD_GROUP_2] [char](5) NULL,
	[GROUP_2_SIGNOFF] [bit] NULL,
	[GROUP_2_USER] [char](8) NULL,
	[ORIG_DRAWNBY] [char](8) NULL,
	[ORIG_CHECKBY] [char](8) NULL,
	[ORIG_MODELBY] [char](8) NULL,
	[EMAIL_SENT] [bit] NULL,
	[Type1RecordHash] [varbinary](64) NULL
)

	--Load #SOURCE table with data in the format in which it will appear in the dimension
	INSERT INTO ##FactEngineeringECR_SOURCE
			SELECT * from dwstage.V_LoadFactEngineeringECR

--CREATE TEMP table to be used below for identifying records with CHANGES 

	CREATE TABLE ##FactEngineeringECR_TARGET 
					(
					[ECR] [bigint] 
					,Type1RecordHash VARBINARY(64)
					)

	--Load temp table with NK and Type1RecordHash for CURRENT records
	INSERT INTO ##FactEngineeringECR_TARGET
	SELECT	
		  [ECR]
  		, Type1RecordHash
	FROM	dw.FactEngineeringECR

	--INSERT NEW TARGET Items
	INSERT INTO dw.FactEngineeringECR 
	SELECT	*
	FROM	##FactEngineeringECR_SOURCE AS SRC
	WHERE	NOT EXISTS(	SELECT  1
						FROM	dw.FactEngineeringECR AS TGT
						WHERE	
							TGT.[ECR] = SRC.[ECR]
			
						)

SET @RowsInsertedCount = @@ROWCOUNT

	--UPDATE Existing Items that have CHANGES

	UPDATE	TGT
	SET
       TGT.[DATE_ENTERED]		= SRC.[DATE_ENTERED]
      ,TGT.[COMPLETED_DATE]		= SRC.[COMPLETED_DATE]
      ,TGT.[ORIG_USER]			= SRC.[ORIG_USER]
      ,TGT.[PROJECT_TYPE]		= SRC.[PROJECT_TYPE]
	  ,TGT.[ECC]				= SRC.[ECC]
      ,TGT.[PART]				= SRC.[PART]
      ,TGT.[WO]					= SRC.[WO]
      ,TGT.[SO]					= SRC.[SO]
      ,TGT.[ISSUE]				= SRC.[ISSUE]
      ,TGT.[DESCRIPTION]		= SRC.[DESCRIPTION]
      ,TGT.[ROOT_CAUSE]			= SRC.[ROOT_CAUSE]
      ,TGT.[ACTION_PLAN]		= SRC.[ACTION_PLAN]
      ,TGT.[STATUS]				= SRC.[STATUS]
      ,TGT.[ASSIGNED_DEPT]		= SRC.[ASSIGNED_DEPT]
      ,TGT.[ASSIGNED_TO]		= SRC.[ASSIGNED_TO]
      ,TGT.[SOURCE]				= SRC.[SOURCE]
      ,TGT.[DUE_DATE]			= SRC.[DUE_DATE]
      ,TGT.[PRIORITY]			= SRC.[PRIORITY]
      ,TGT.[EST_COST_INC]		= SRC.[EST_COST_INC]
      ,TGT.[WORKGROUP]			= SRC.[WORKGROUP]
      ,TGT.[QA_SIGNOFF]			= SRC.[QA_SIGNOFF]
      ,TGT.[QA_USER]			= SRC.[QA_USER]
      ,TGT.[ADD_GROUP_1]		= SRC.[ADD_GROUP_1]
      ,TGT.[GROUP_1_SIGNOFF]	= SRC.[GROUP_1_SIGNOFF]
      ,TGT.[GROUP_1_USER]		= SRC.[GROUP_1_USER]
      ,TGT.[ADD_GROUP_2]		= SRC.[ADD_GROUP_2]
      ,TGT.[GROUP_2_SIGNOFF]	= SRC.[GROUP_2_SIGNOFF]
      ,TGT.[GROUP_2_USER]		= SRC.[GROUP_2_USER]
	  ,TGT.[ORIG_DRAWNBY]		= SRC.[ORIG_DRAWNBY]
	  ,TGT.[ORIG_CHECKBY]		= SRC.[ORIG_CHECKBY]
	  ,TGT.[ORIG_MODELBY]		= SRC.[ORIG_MODELBY]
      ,TGT.[EMAIL_SENT]			= SRC.[EMAIL_SENT]
      ,TGT.[Type1RecordHash]	= SRC.[Type1RecordHash]
	FROM	dw.FactEngineeringECR		AS TGT
	 JOIN   ##FactEngineeringECR_SOURCE	AS SRC
			ON TGT.[ECR] = SRC.[ECR]
	WHERE	TGT.Type1RecordHash <> SRC.Type1RecordHash

SET @RowsUpdatedCount = @@ROWCOUNT
	
	--DROP temp tables

	 DROP TABLE ##FactEngineeringECR_SOURCE		
	 DROP TABLE ##FactEngineeringECR_TARGET	
	 
END

SELECT RowsInsertedCount = @RowsInsertedCount, RowsUpdatedCount = @RowsUpdatedCount

GO
