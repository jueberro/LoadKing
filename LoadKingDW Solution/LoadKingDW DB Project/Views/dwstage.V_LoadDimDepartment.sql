CREATE VIEW dwstage.V_LoadDimDepartment
AS
SELECT 		                                 
		  [DepartmentID]			  = CAST([DEPT_ID]				AS NCHAR(4))
		, [DepartmentName]			  = CAST([DEPT_NAME]	    AS NVARCHAR(50))
		, LAST_DATE_CHG				  = dwstage.udf_cv_nvarchar8_to_date(LAST_DATE_CHG)
		, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST([DEPT_ID] AS NCHAR(6))
															+ CAST([DEPT_NAME] AS NVARCHAR(50))
															+ CAST([LAST_DATE_CHG] AS NVARCHAR(20))															
															)
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)
FROM 
	dwstage.[DEPARTMENTS]	
GO
-- INSERT INTO dwstage.DEPARTMENTS select * from [lk-gs-ods].dbo.departments
