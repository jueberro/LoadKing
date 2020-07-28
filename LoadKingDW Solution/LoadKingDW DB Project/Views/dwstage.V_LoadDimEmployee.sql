--USE [LK-GS-EDW]
--GO

CREATE VIEW dwstage.V_LoadDimEmployee
AS
SELECT 		
		  [EmployeeID]				= CAST(EMPLOYEE				AS NCHAR(5))
		, [EmployeeRecordType]		= CAST(RECORD_TYPE			AS NCHAR(1))
		, [EmployeeName]			= CAST([NAME]				AS NVARCHAR(100))
		, [EmployeeAddress]			= CAST([ADDRESS]			AS NVARCHAR(100))
		, [EmployeeCity]			= CAST(CITY					AS NVARCHAR(50))
		, [EmployeeState]			= CAST([STATE]				AS NCHAR(2))	
		, [EmployeePostalCode]		= CAST(ZIP_CODE				AS NCHAR(9))
		, [EmployeeGender]			= CAST(SEX					AS NCHAR(1))
		, [EmployeeHireDate]		= dwstage.udf_cv_nvarchar6_to_date(DATE_HIRE)
		, [EmployeeTerminationDate]	= dwstage.udf_cv_nvarchar6_to_date(DATE_TERMINATION)
		, [EmployeeDepartment]		= CAST(DEPT_EMPLOYEE		AS NCHAR(4))
		, [EmployeeIsSalesperson]	= CAST(0					AS BIT) 	
		, [EmployeeInitials]        = CAST([EMPL_INITIALS]      AS NVARCHAR(3))

		,[PAY_TYPE] 
		,[FREQUENCY] 
		,[RATE] 
		,[SHIFT] 




		, [Type1RecordHash]			= CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			= HASHBYTES('SHA2_256', CAST(EMPLOYEE		AS NCHAR(5))
															+ CAST(RECORD_TYPE		AS NCHAR(1))
															+ CAST([NAME]			AS NVARCHAR(100))
															+ CAST([ADDRESS]		AS NVARCHAR(100))
															+ CAST(CITY				AS NVARCHAR(50))
															+ CAST([STATE]			AS NCHAR(2))	
															+ CAST(ZIP_CODE			AS NCHAR(9))
															+ CAST(SEX				AS NCHAR(1))
															+ CAST(dwstage.udf_cv_nvarchar6_to_date(DATE_HIRE)  AS NVARCHAR(12))
															+ CAST(dwstage.udf_cv_nvarchar6_to_date(DATE_TERMINATION)  AS NVARCHAR(12))
															+ CAST(DEPT_EMPLOYEE	AS NCHAR(4))
															+ CAST(0				AS NCHAR(1))
															+ CAST([EMPL_INITIALS]  AS NVARCHAR(3))

															+ CAST([PAY_TYPE]		AS NCHAR(1))
															+ CAST([FREQUENCY]		AS NVARCHAR(1))
															+ CAST([RATE]			AS NVARCHAR(20))
															+ CAST([SHIFT]			AS NVARCHAR(1))
															)
		
		, [SourceSystemName]		= CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	= CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		= '2100-01-01'
		, [DWIsCurrent]				= CAST(1					AS BIT)
		
		, [LoadLogKey]				= CAST(0                    AS INT)
		FROM dwstage.EMPLOYEE_MSTR 
GO


