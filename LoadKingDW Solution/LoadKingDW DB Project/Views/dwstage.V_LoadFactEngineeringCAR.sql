CREATE VIEW [dwstage].[V_LoadFactEngineeringCAR] 
AS

SELECT    
       [CCA_NO]
      ,[DATE_ENTERED]
      ,[COMPLETED_DATE]
      ,[ORIG_USER]
      ,[PROJECT_TYPE]
      ,[PART]
      ,[WO]
      ,[SO]
      ,[ISSUE]
      ,CAST([DESCRIPTION]	AS VARCHAR(128))	AS [DESCRIPTION]
      ,CAST([ROOT_CAUSE]	AS VARCHAR(256))	AS [ROOT_CAUSE]
	  ,CAST([ACTION_PLAN]	AS VARCHAR(256))	AS [ACTION_PLAN]
      ,[STATUS]
      ,[ASSIGNED_DEPT]
      ,[ASSIGNED_TO]
      ,[SOURCE]
      ,[DUE_DATE]
      ,[PRIORITY]
      ,[ECR_REQUIRED]
      ,[ECR]
      ,[EST_COST_INC]
      ,[WORKGROUP]
      ,[QA_SIGNOFF]
      ,[QA_USER]
      ,[ADD_GROUP_1]
      ,[GROUP_1_SIGNOFF]
      ,[GROUP_1_USER]
      ,[ADD_GROUP_2]
      ,[GROUP_2_SIGNOFF]
      ,[GROUP_2_USER]
      ,[EMAIL_SENT]
	  	, [Type1RecordHash]			  = HASHBYTES('SHA2_256',                                                                  
			cast([CCA_NO]				AS nvarchar(16)) 
		+	cast([DATE_ENTERED]			AS nvarchar(20))
		+	cast([COMPLETED_DATE]		AS nvarchar(20))
		+	cast([ORIG_USER]			AS nvarchar(8))
		+	cast([PROJECT_TYPE]			AS nvarchar(30))
		+	cast([PART]					AS nvarchar(20))
		+	cast([WO]					AS nvarchar(10))
		+	cast([SO]					AS nvarchar(12))
		+	cast([ISSUE]				AS nvarchar(50))
		+	cast([DESCRIPTION]			AS nvarchar(128))
		+	cast([ROOT_CAUSE]			AS nvarchar(256))
		+	cast([ACTION_PLAN]			AS nvarchar(256))
		+	cast([STATUS]				AS nvarchar(30))
		+	cast([ASSIGNED_DEPT]		AS nvarchar(4))
		+	cast([ASSIGNED_TO]			AS nvarchar(8))
		+	cast([SOURCE]				AS nvarchar(30))
		+	cast([DUE_DATE]				AS nvarchar(20))
		+	cast([PRIORITY]				AS nvarchar(8))
		+	cast([ECR]					AS nvarchar(16))
		+	cast([EST_COST_INC] 		AS nvarchar(16))
		+	cast([WORKGROUP] 			AS nvarchar(15))
		+	cast([QA_USER] 				AS nvarchar(8))
		+	cast([ADD_GROUP_1] 			AS nvarchar(5))
		+	cast([GROUP_1_USER]			AS nvarchar(8))
		+	cast([ADD_GROUP_2]			AS nvarchar(5))
		+	cast([GROUP_2_USER]			AS nvarchar(8))
		)
																		
-- select count(*)
FROM [dwstage].[GCG_5398_CAR] CAR
GO