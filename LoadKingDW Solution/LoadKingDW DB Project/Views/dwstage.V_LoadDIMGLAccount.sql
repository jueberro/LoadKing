CREATE VIEW [dwstage].[V_LoadDimGLAccount]
AS
SELECT 		                                 
		  [GLAccount]			= CAST([GL_Account]			AS CHAR(15))
		, [Descr]				= CAST([DESCR]				AS CHAR(30))
		, [Dept]				= CAST([DEPT]				AS CHAR(4))
		, [RetainedAcct]		= CAST([RETAINED_ACCT]		AS CHAR(15))
		, [ZeroAtYrEnd]			= CAST([ZERO_AT_YR_END]		AS CHAR(1))
		, [User1]				= Cast([USER_1]				AS CHAR(30))
		, [User2]				= Cast([USER_2]				AS CHAR(30))
		, [User3]				= Cast([USER_3]				AS CHAR(30))
		, [User4]				= Cast([USER_4]				AS CHAR(30))
		, [User5]				= Cast([USER_5]				AS CHAR(30))

		, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST([GL_ACCOUNT]				AS CHAR(15))
															+ CAST([Descr]					AS CHAR(30))
															+ CAST([Dept]					AS CHAR(4))
															+ CAST([ZERO_AT_YR_END]			AS CHAR(1))
															+ CAST([USER_1]					AS CHAR(30))
															+ CAST([USER_2]					AS CHAR(30))
															+ CAST([USER_3]					AS CHAR(30))
															+ CAST([USER_4]					AS CHAR(30))
															+ CAST([USER_5]					AS CHAR(30))
 )
	
	
	
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)



		FROM     dwstage.GL_MASTER
		
GO


