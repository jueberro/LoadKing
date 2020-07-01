CREATE VIEW [dwstage].[V_LoadDimVendor]
AS
SELECT 		                                 
		    [Vendor]            = CAST(vm.[Vendor]         AS [nchar](6))
	      , [VendorName]        = CAST(vm.[NAME_VENDOR]    AS [nvarchar](30))
	      , [VendorAddress1]    = CAST(vm.[Address1]       AS [nvarchar](30))
	      , [VendorAddress2]    = CAST(vm.[Address2]       AS [nvarchar](30))
	      , [VendorCity]        = CAST(vm.[City]           AS [nvarchar](20))
	      , [VendorState]       = CAST(vm.[State]          AS [nchar](2))
	      , [VendorPostalCode]  = CAST(vm.[Code_Zip]       AS [nchar](13))
	      , [VendorCountry]     = CAST(vm.[Country]        AS [nchar](12))
	      , [VendorCounty]      = CAST(vm.[County]         AS [nchar](12))
	      , [VendorIntlFlag]    = CAST(vm.[INTL_ADRS]      AS [nchar](1))
	      , [VendorTerritory]   = CAST(vm.[Territory]      AS [nchar](2))
	      , [VendorCodeArea]    = CAST(vm.[Code_Area]      AS [nchar](2))
		  , [VendorEmail]       = CAST(vm2.[Address2]   AS [nvarchar](30))
		  , [VendorApproved_Suppl] =  CAST(vm2.[Approved_Suppl]  AS [nchar](1))
		  , [VendorCritical_Suppl] =  CAST(vm2.[Critical_Suppl]  AS [nchar](1))
		  , [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		  , [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST(vm.[Vendor]         AS [nchar](6))
															+ CAST(vm.[NAME_VENDOR]    AS [nvarchar](30))
															+ CAST(vm.[Address1]       AS [nvarchar](30))
															+ CAST(vm.[Address2]       AS [nvarchar](30))
															+ CAST(vm.[City]           AS [nvarchar](20))
															+ CAST(vm.[State]          AS [nchar](2))
															+ CAST(vm.[Code_Zip]       AS [nchar](13))
															+ CAST(vm.[Country]        AS [nchar](12))
															+ CAST(vm.[County]         AS [nchar](12))
															+ CAST(vm.[INTL_ADRS]      AS [nchar](1))
															+ CAST(vm.[Territory]      AS [nchar](2))
															+ CAST(vm.[Code_Area]      AS [nchar](2))
															+ CAST(vm2.[Address2]      AS [nvarchar](30))
															+ CAST(vm2.[Approved_Suppl]  AS [nchar](1))
															+ CAST(vm2.[Critical_Suppl]  AS [nchar](1))
	                                                    )
	
	
	     , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		 , [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		 , [DWEffectiveEndDate]		  = '2100-01-01'
		 , [DWIsCurrent]			  = CAST(1					  AS BIT)
		 , [LoadLogKey]				  = CAST(0                    AS INT)



		FROM         (Select * from dwstage._V_Vendor WHERE   dwstage._V_Vendor.REC = 1) as vm
		INNER JOIN   (Select * from dwstage._V_Vendor WHERE   dwstage._V_Vendor.REC = 3) as vm2
		ON vm.Vendor = vm2.Vendor
GO