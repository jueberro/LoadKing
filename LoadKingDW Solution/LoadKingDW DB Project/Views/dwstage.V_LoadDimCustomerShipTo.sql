CREATE VIEW [dwstage].[V_LoadDimCustomerShipTo]
	AS
    SELECT   
                    PrimaryCustomerID       = CAST(cs.CUSTOMER           AS NCHAR(6)    )   
                ,   ShipToSeq               = CAST(cs.SHIP_SEQ           AS NCHAR(6)    )
                ,   ShipToCustomername      = CAST(cs.CUSTOMER_NAME      AS NVARCHAR(30))
                ,   ShipToAddress1          = CAST(cs.SHIP_ADDRESS1      AS NVARCHAR(30))
                ,   ShipToAddress2          = CAST(cs.SHIP_ADDRESS2      AS NVARCHAR(30))
                ,   ShipToAddress3          = CAST(cs.SHIP_ADDRESS3      AS NVARCHAR(30))
                ,   ShipToAddress4          = CAST(cs.SHIP_ADDRESS4      AS NVARCHAR(30))
                ,   ShipToCity              = CAST(cs.SHIP_CITY          AS NCHAR(15)   )
                ,   ShipToState             = CAST(cs.SHIP_STATE         AS NCHAR(2)    )
                ,   ShipToZip               = CAST(cs.SHIP_ZIP           AS NCHAR(13)   )
                ,   ShipToCountry           = CAST(cs.SHIP_COUNTRY       AS NCHAR(12)   )
                ,   ShipToAttention         = CAST(cs.SHIP_ATTENTION     AS NVARCHAR(30))
                ,   ShipToTelephone         = CAST(cs.SHIP_TELEPHONE     AS NCHAR(13)   )
                ,   ShipToSalesperson       = CAST(cs.SHIP_SALESPERSON   AS NCHAR(3)    )
                ,   ShipToShipVia           = CAST(cs.SHIP_VIA           AS NCHAR(1)    )
                ,   ShipToBranch            = CAST(cs.SHIP_BRANCH        AS NCHAR(2)    )
                ,   ShipToTaxENo            = CAST(cs.SHIP_TAX_E_NO      AS NCHAR(20)   )
                ,   ShipToTaxState          = CAST(cs.SHIP_TAX_STATE     AS NCHAR(2)    )
                ,   ShipToTaxZip            = CAST(cs.SHIP_TAX_ZIP       AS NCHAR(13)   )
                ,   ShipToTax1              = CAST(cs.SHIP_TAX_1         AS NCHAR(3)    )
                ,   ShipToTax2              = CAST(cs.SHIP_TAX_2         AS NCHAR(3)    )
                ,   ShipToTax3              = CAST(cs.SHIP_TAX_3         AS NCHAR(3)    )
                ,   ShipToTax4              = CAST(cs.SHIP_TAX_4         AS NCHAR(3)    )
                ,   ShipToTax5              = CAST(cs.SHIP_TAX_5         AS NCHAR(3)    )
                ,   ShipToWhoLastChanged    = CAST(cs.WHO_LAST_CHG       AS NVARCHAR(8) )
                ,   ShipToTrmLastChanged    = CAST(cs.TRM_LAST_CHG       AS NUMERIC(2,0))
                ,   ShipToDateLastChanged   = dwstage.udf_cv_nvarchar6__yymmdd_to_date(cs.DATE_LAST_CHG)
				,   ShipToPrimaryGroup      = CAST(cs.PRIMARY_GRP        AS NCHAR(2)    )
                ,   ShipToCarrierCD         = CAST(cs.CARRIER_CD         AS NCHAR(6)    )
                ,   [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		        ,   [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
		        	    												+ CAST([CUSTOMER]				AS NCHAR(6))
		        	    												+ CAST([SHIP_SEQ]	            AS NCHAR(6))
		        	    												+ CAST(dwstage.udf_cv_nvarchar6__yymmdd_to_date(
                                                                                        cs.DATE_LAST_CHG      
                                                                                       ) 
                                                                              AS NVARCHAR(24)))
	
	
	            ,   [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		        ,   [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		        ,   [DWEffectiveEndDate]		  = '2100-01-01'
		        ,   [DWIsCurrent]				  = CAST(1					  AS BIT)
		        ,   [LoadLogKey]				  = CAST(0                    AS INT)
FROM            dwstage.OE_MULTI_SHIP cs
GO
