CREATE VIEW [dwstage].[V_LoadDimCustomer]
AS
SELECT 		                                 
		  [CustomerID]				  = CAST([CUSTOMER]				AS NCHAR(6))
		, [CustomerName]			  = CAST([NAME_CUSTOMER]	    AS NVARCHAR(50))
		, [CustomerAddress1]		  = CAST([ADDRESS1]			    AS NVARCHAR(100))
		, [CustomerAddress2]		  = CAST([ADDRESS2]			    AS NVARCHAR(100))
		, [CustomerCity]			  = CAST([CITY]			     	AS NVARCHAR(100))
		, [CustomerStateOrProvince]	  = CAST([STATE]				AS NVARCHAR(10))	
		, [CustomerPostalCode]		  = CAST([ZIP] 			        AS NVARCHAR(50))
		, [CustomerCountry]  		  = CAST([COUNTRY]		        AS NVARCHAR(50))
		, [CustomerCounty]	    	  = CAST([COUNTY]			    AS NVARCHAR(50))
		, [CustomerInternationalFlag] = CAST((CASE
		                                      WHEN [INTL_ADDR] IS NOT NULL THEN 1
										       ELSE 0
                                             END) AS BIT)
        , [CustomerTerritory]         = CAST([TERRITORY]           AS NCHAR(2)) 
		, [CustomerCodeArea]		  = CAST([CODE_AREA]           AS NCHAR(2))
		, [CustomerCredit]            = CAST([CREDIT]              AS NCHAR(2)) 
		, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST([CUSTOMER]				AS NCHAR(6))
															+ CAST([NAME_CUSTOMER]	        AS NVARCHAR(50))
															+ CAST([ADDRESS1]			    AS NVARCHAR(100))
															+ CAST([ADDRESS2]			    AS NVARCHAR(100))
															+ CAST([CITY]			     	AS NVARCHAR(100))
															+ CAST([STATE]				    AS NVARCHAR(10))
															+ CAST([ZIP] 			        AS NVARCHAR(50))
															+ CAST([COUNTRY]		        AS NVARCHAR(50))
															+ CAST([COUNTY]			        AS NVARCHAR(50))
															+ CAST([INTL_ADDR]              AS NCHAR(1))
															+ CAST([TERRITORY]              AS NCHAR(2)) 
															+ CAST([CODE_AREA]              AS NCHAR(2))
															+ CAST([CREDIT]                 AS NCHAR(2)) )
	
	
	
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)



		FROM     dwstage.CUSTOMER_MASTER
		WHERE    dwstage.CUSTOMER_MASTER.REC = 1  
GO

