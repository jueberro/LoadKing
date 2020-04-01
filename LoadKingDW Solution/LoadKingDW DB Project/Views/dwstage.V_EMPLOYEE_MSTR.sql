CREATE VIEW [dwstage].[V_Employee_Mstr]
AS
SELECT        EMPLOYEE, RECORD_TYPE, NAME, ADDRESS, CITY, STATE, ZIP_CODE, PHONE, SOCIAL_SECURITY_NO, SEX, dwstage.udf_cv_nvarchar6_to_date(BIRTHDATE) AS BIRTHDATE, 
                         dwstage.udf_cv_nvarchar6_to_date(DATE_HIRE) AS DATE_HIRE, dwstage.udf_cv_nvarchar6_to_date(DATE_TERMINATION) AS DATE_TERMINATION, dwstage.udf_cv_nvarchar6_to_date(DATE_RAISE) AS DATE_RAISE, 
                         dwstage.udf_cv_nvarchar6_to_date(PR_CARRY_OVER_YMD) AS PR_CARRY_OVER_YMD, dwstage.udf_cv_nvarchar6_to_date(ELIG_HOL_DATE) AS ELIG_HOL_DATE, dwstage.udf_cv_nvarchar8_to_date(ELIG_DT_401K) 
                         AS ELIG_DT_401K, COMMENTS_1, COMMENTS_2, COMMENTS_3, RATE_PREVIOUS, DEPT_EMPLOYEE, WORKMAN_COMP, PAY_TYPE, FREQUENCY, RATE, SHIFT, DIFFERENTIAL, MARITAL_STATUS, 
                         STATE_CODE, SUI, EMAIL_ADDR, ALPHA_SORT, VACATION_LEFT, SICK_LEFT, ETL_Batch, ETL_Completed
FROM            dwstage.EMPLOYEE_MSTR AS EMPLOYEE_MSTR
GO


