CREATE VIEW [dwstage].[V_LoadDimInvoice]
	AS
    SELECT  
	                [SalesOrderNumber]		
				,   [SalesOrderLine]		
				,   [OHOrderSuffix]			
				,   [OHInvoiceNumber]		
				,   dwstage.udf_testdatevalue([OHCreationDate]) AS  [OHCreationDate]
				,   dwstage.udf_testdatevalue([OHDateOrderDue]) AS  [OHDateOrderDue]	
				,   dwstage.udf_testdatevalue([OLDateOrderDue]) AS  [OLDateOrderDue] 	
				,   dwstage.udf_testdatevalue([OLDateDue])      AS  [OLDateDue]				
				,   [OHOrderSort]			
				,   [OHProjectType]			
				,   [OHBranch]				
				,   [OHShipVia]				
				,   [OHPrimaryGroup]		
				,   [OHShippingZone]		
				,   dwstage.udf_testdatevalue([OLDateOrder])   AS   [OLDateOrder]			
				,   dwstage.udf_testdatevalue([OLCustDueDate]) AS   [OLCustDueDate]			
				,   [OLBranch]				
				,   [OLShipVia]				
				,   [OLCustomerPart]		
				,   [OLInternationalFlag]   
				,   [OLBOMExplodeFlag]		
				,   [OLFlagTaxStatus]		
				,   [OLCreditMemoFlag]		
				,   [OLFlagRMA]				
				,   [OLBOMCompleteFlag]		
				,   [OLBOMParentLineNumber] 
				,   [OLSerializedFlag]		
				,   [OLUMInventory]			
				,   [OLProductLine]			
				,   [OLPriceGroupID]		
				,   [OLSOGroupID]			
				,   [OLUser1]				
				,   [OLUser2]				
				,   [OLTrackingNotes]		
				,   [OLUser4]				
				,   [OLUser5_ShipVia]		
				,   [OLShippingZone]		
				,   [OLPhase]				
				,   [OLPriceDescription]	
				,   [OLLineType]			
				   
				
			    ,   [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
                ,   [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
                                                                             [SalesOrderNumber]		
																		 +   [SalesOrderLine]		
																		 +   [OHOrderSuffix]			
																		 +   [OHInvoiceNumber]		
																		 +   cast([OHCreationDate]		as nvarchar(26))
																		 +   cast([OHDateOrderDue]		as nvarchar(26))
																		 +   cast([OLDateOrderDue]		as nvarchar(26))
																		 +   cast([OLDateDue]		    as nvarchar(26))		  
																		 +   [OHOrderSort]		 	
																		 +   [OHProjectType]			 
																		 +   [OHBranch]				
																		 +   [OHShipVia]				
																		 +   [OHPrimaryGroup]		
																		 +   [OHShippingZone]		
																		 +   cast([OLDateOrder]		    as nvarchar(26))	
																		 +   cast([OLCustDueDate]		as nvarchar(26))	
																		 +   [OLBranch]				 
																		 +   [OLShipVia]				
																		 +   [OLCustomerPart]		
																		 +   [OLInternationalFlag]   
																		 +   [OLBOMExplodeFlag]		
																		 +   [OLFlagTaxStatus]		
																		 +   [OLCreditMemoFlag]		
																		 +   [OLFlagRMA]				
																		 +   [OLBOMCompleteFlag]		
																		 +   [OLBOMParentLineNumber] 
																		 +   [OLSerializedFlag]		
																		 +   [OLUMInventory]			
																		 +   [OLProductLine]			
																		 +   [OLPriceGroupID]		
																		 +   [OLSOGroupID]			
																		 +   [OLUser1]				
																		 +   [OLUser2]				
																		 +   [OLTrackingNotes]		
																		 +   [OLUser3]				
																		 +   [OLUser5_ShipVia]		
																		 +   [OLShippingZone]		
																		 +   [OLPhase]				
																		 +   [OLPriceDescription]	
																		 +   [OLLineType]			
	                 ) 
                                                                             
                ,   [SourceSystemName]		      = CAST('Global Shop'        AS NVARCHAR(100))
		        ,   [DWEffectiveStartDate]	      = CAST(Getdate()            AS DATETIME2(7))
		        ,   [DWEffectiveEndDate]		  = '2100-01-01'
		        ,   [DWIsCurrent]				  = CAST(1					  AS BIT)
		        ,   [LoadLogKey]				  = CAST(0                    AS INT)
FROM            dwstage._V_Invoice
--Test
GO

