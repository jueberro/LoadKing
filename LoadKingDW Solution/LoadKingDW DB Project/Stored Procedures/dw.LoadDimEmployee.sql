CREATE PROCEDURE [dw].[sp_LoadDimEmployee] AS

BEGIN

	DECLARE @CurrentTimestamp DATETIME2(7)
	SELECT @CurrentTimestamp = GETUTCDATE()

	MERGE INTO dbo.Dim_Employee AS TRG
	USING dwstage.V_EMPLOYEE_MSTR AS SRC
	 ON	TRG.EMPLOYEE = SRC.EMPLOYEE 
	  AND TRG.IsEffective = 'y'

	WHEN MATCHED
	   AND (SRC.[RECORD_TYPE]		   <> TRG.[RECORD_TYPE]		  
		  OR SRC.[NAME]			   <> TRG.[NAME]			  
		  OR SRC.[ADDRESS]			   <> TRG.[ADDRESS]			  
		  OR SRC.[CITY]			   <> TRG.[CITY]			  
		  OR SRC.[STATE]			   <> TRG.[STATE]			  
		  OR SRC.[ZIP_CODE]		   <> TRG.[ZIP_CODE]		  
		  OR SRC.[PHONE]			   <> TRG.[PHONE]			  
		  OR SRC.[SOCIAL_SECURITY_NO] <> TRG.[SOCIAL_SECURITY_NO]
		  OR SRC.[SEX]				   <> TRG.[SEX]				  
		  OR SRC.[BIRTHDATE]		   <> TRG.[BIRTHDATE]		  
		  OR SRC.[DATE_HIRE]		   <> TRG.[DATE_HIRE]		  
		  OR SRC.[DATE_TERMINATION]   <> TRG.[DATE_TERMINATION]  
		  OR SRC.[DATE_RAISE]		   <> TRG.[DATE_RAISE]		  
		  OR SRC.[PR_CARRY_OVER_YMD]  <> TRG.[PR_CARRY_OVER_YMD] 
		  OR SRC.[ELIG_HOL_DATE]	   <> TRG.[ELIG_HOL_DATE]	  
		  OR SRC.[ELIG_DT_401K]	   <> TRG.[ELIG_DT_401K]	  
		  OR SRC.[COMMENTS_1]		   <> TRG.[COMMENTS_1]		  
		  OR SRC.[COMMENTS_2]		   <> TRG.[COMMENTS_2]		  
		  OR SRC.[COMMENTS_3]		   <> TRG.[COMMENTS_3]		  
		  OR SRC.[RATE_PREVIOUS]	   <> TRG.[RATE_PREVIOUS]	  
		  OR SRC.[DEPT_EMPLOYEE]	   <> TRG.[DEPT_EMPLOYEE]	  
		  OR SRC.[WORKMAN_COMP]	   <> TRG.[WORKMAN_COMP]	  
		  OR SRC.[PAY_TYPE]		   <> TRG.[PAY_TYPE]		  
		  OR SRC.[FREQUENCY]		   <> TRG.[FREQUENCY]		  
		  OR SRC.[RATE]			   <> TRG.[RATE]			  
		  OR SRC.[SHIFT]			   <> TRG.[SHIFT]			  
		  OR SRC.[DIFFERENTIAL]	   <> TRG.[DIFFERENTIAL]	  
		  OR SRC.[MARITAL_STATUS]	   <> TRG.[MARITAL_STATUS]	  
		  OR SRC.[STATE_CODE]		   <> TRG.[STATE_CODE]		  
		  OR SRC.[SUI]				   <> TRG.[SUI]				  
		  OR SRC.[EMAIL_ADDR]		   <> TRG.[EMAIL_ADDR]		  
		  OR SRC.[ALPHA_SORT]		   <> TRG.[ALPHA_SORT]		  
		  OR SRC.[VACATION_LEFT]	   <> TRG.[VACATION_LEFT]	 
		  OR SRC.[SICK_LEFT]		   <> TRG.[SICK_LEFT]) 

		THEN --UPDATE/EXPIRE current version of records for which a new version will be INSERTED later
			 UPDATE SET TRG.IsEffective = 'n', TRG.End_date =  @CurrentTimestamp        


		WHEN NOT MATCHED --Insert *N E W* employee records
		THEN 
		INSERT 
			(		
			  [EMPLOYEE]
			  ,[RECORD_TYPE]
			  ,[NAME]
			  ,[ADDRESS]
			  ,[CITY]
			  ,[STATE]
			  ,[ZIP_CODE]
			  ,[PHONE]
			  ,[SOCIAL_SECURITY_NO]
			  ,[SEX]
			  ,[BIRTHDATE]
			  ,[DATE_HIRE]
			  ,[DATE_TERMINATION]
			  ,[DATE_RAISE]
			  ,[PR_CARRY_OVER_YMD]
			  ,[ELIG_HOL_DATE]
			  ,[ELIG_DT_401K]
			  ,[COMMENTS_1]
			  ,[COMMENTS_2]
			  ,[COMMENTS_3]
			  ,[RATE_PREVIOUS]
			  ,[DEPT_EMPLOYEE]
			  ,[WORKMAN_COMP]
			  ,[PAY_TYPE]
			  ,[FREQUENCY]
			  ,[RATE]
			  ,[SHIFT]
			  ,[DIFFERENTIAL]
			  ,[MARITAL_STATUS]
			  ,[STATE_CODE]
			  ,[SUI]
			  ,[EMAIL_ADDR]
			  ,[ALPHA_SORT]
			  ,[VACATION_LEFT]
			  ,[SICK_LEFT]
			  ,[ETL_Batch]
			  ,[ETL_Completed]
			  ,[Effective_Date]
			  ,[End_Date]
			  ,IsEffective)

			  VALUES(
			  	SRC.[EMPLOYEE]
			  ,SRC.[RECORD_TYPE]
			  ,SRC.[NAME]
			  ,SRC.[ADDRESS]
			  ,SRC.[CITY]
			  ,SRC.[STATE]
			  ,SRC.[ZIP_CODE]
			  ,SRC.[PHONE]
			  ,SRC.[SOCIAL_SECURITY_NO]
			  ,SRC.[SEX]
			  ,SRC.[BIRTHDATE]
			  ,SRC.[DATE_HIRE]
			  ,SRC.[DATE_TERMINATION]
			  ,SRC.[DATE_RAISE]
			  ,SRC.[PR_CARRY_OVER_YMD]
			  ,SRC.[ELIG_HOL_DATE]
			  ,SRC.[ELIG_DT_401K]
			  ,SRC.[COMMENTS_1]
			  ,SRC.[COMMENTS_2]
			  ,SRC.[COMMENTS_3]
			  ,SRC.[RATE_PREVIOUS]
			  ,SRC.[DEPT_EMPLOYEE]
			  ,SRC.[WORKMAN_COMP]
			  ,SRC.[PAY_TYPE]
			  ,SRC.[FREQUENCY]
			  ,SRC.[RATE]
			  ,SRC.[SHIFT]
			  ,SRC.[DIFFERENTIAL]
			  ,SRC.[MARITAL_STATUS]
			  ,SRC.[STATE_CODE]
			  ,SRC.[SUI]
			  ,SRC.[EMAIL_ADDR]
			  ,SRC.[ALPHA_SORT]
			  ,SRC.[VACATION_LEFT]
			  ,SRC.[SICK_LEFT]
			  ,SRC.[ETL_Batch]
			  ,SRC.[ETL_Completed]
			  , @CurrentTimestamp
			  ,convert(datetime,'2100-01-01',120)
			  , 'y'
			  );


END





/*

 - INSERT NEW Items
 - UPDATE existing dim records IF SRC member exists and one or more fields have changed (EffectiveEndDate, IsCurrent = N)
 - INSERT new version of matched record with new field values






*/
GO

