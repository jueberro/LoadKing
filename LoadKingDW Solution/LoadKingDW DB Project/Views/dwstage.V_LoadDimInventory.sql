CREATE VIEW [dwstage].[V_LoadDimInventory]
	AS
    SELECT          PartID               
				,   DateLastChg		 	 
				,   WhoChgLast		 	 
				,   Price	             
				,   CodeABC	         	 
				,   ProductLine	     	 
				,   PartDescription	 	 
				,   UM	             	 
				,   Obsolete           	 
				,   CodeSort           	 
				,   MaterialLeadTime	 
				,   SerializeFlag		 
				,   SourceCode		 	 
				,   PrimaryVendor	   	 
				,   PriceGroupID	     
				,   SOGroupID		   	 
				,   AltDescription1	 	 
				,	AltDescription2	 	 
				,	RequiresInspection 	 
				,	ShelfLife		     
				,	VatProductType	 	 
				,	TaxExemptFlag	     

			    ,   [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		        ,   [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
                                                                            PartID               
																		 +  CAST(DateLastChg AS nvarchar(26))	 	 
																		 +  CAST(WhoChgLast	AS nvarchar(26))	 	 
																		 +  CAST(Price AS nvarchar(12))	             
																		 +  CodeABC	         	 
																		 +  ProductLine	     	 
																		 +  PartDescription	 	 
																		 +  UM	             	  
																		 +  Obsolete           	 
																		 +  CodeSort           	 
																		 +  CAST(MaterialLeadTime AS nvarchar(12) )
																		 +  SerializeFlag		 
																		 +  SourceCode		 	 
																		 +  PrimaryVendor	   	 
																		 +  PriceGroupID	     
																		 +  SOGroupID		   	 
																		 +  AltDescription1	 	 
																		 +	AltDescription2	 	 
																		 +	RequiresInspection 	 
																		 +	ShelfLife		     
																		 +	VatProductType	 	 
																		 +	TaxExemptFlag	     
																		 
																		 ) 
                                                                             
	            ,   [SourceSystemName]		      = CAST('Global Shop'        AS NVARCHAR(100))
		        ,   [DWEffectiveStartDate]	      = CAST(Getdate()            AS DATETIME2(7))
		        ,   [DWEffectiveEndDate]		  = '2100-01-01'
		        ,   [DWIsCurrent]				  = CAST(1					  AS BIT)
		        ,   [LoadLogKey]				  = CAST(0                    AS INT)
FROM            dwstage._V_Inventory

