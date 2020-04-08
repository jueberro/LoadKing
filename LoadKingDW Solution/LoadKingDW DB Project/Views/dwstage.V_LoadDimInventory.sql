CREATE VIEW [dwstage].[V_LoadDimInventory]
	AS
    SELECT          [PartID]
				,   [PartLocation]
				,   [PartCodeABC]
				,   [PartProductLine]
				,   [PartBin]
				,   [PartDescription]
				,   [PartPrice]
				,   [PartObsoleteFlag]
				,   [PartCodeBOM]
				,   [PartCodeDiscount]
				,   [PartCodeTotal]
				,   [PartCodeSort]
				,   [PartVendorName]
				,   [PartDescription2]
				,   [PartDescription3]
				,   [PartVatProductType]
				,   [PartTaxExemptFlag]
			
			    ,   [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		        ,   [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
		        	    												   
                                                                            [PartID]
																		 +  [PartLocation]
																		 +  [PartCodeABC]
																		 +  [PartProductLine]
																		 +  [PartBin]
																		 +  [PartDescription]
																		 +  [PartPrice]
																		 +  [PartObsoleteFlag]
																		 +  [PartCodeBOM]
																		 +  [PartCodeDiscount]
																		 +  [PartCodeTotal]
																		 +  [PartCodeSort]
																		 +  [PartVendorName]
																		 +  [PartDescription2]
																		 +  [PartDescription3]
																		 +  [PartVatProductType]
																		 +  [PartTaxExemptFlag]
																			 
																		 ) 
                                                                             
	
	
	            ,   [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		        ,   [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		        ,   [DWEffectiveEndDate]		  = '2100-01-01'
		        ,   [DWIsCurrent]				  = CAST(1					  AS BIT)
		        ,   [LoadLogKey]				  = CAST(0                    AS INT)
FROM            dwstage._SV_InventoryAll
GO
