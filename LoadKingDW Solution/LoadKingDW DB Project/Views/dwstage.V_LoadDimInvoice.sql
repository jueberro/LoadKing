CREATE VIEW [dwstage].[V_LoadDimInvoice]
	AS
    SELECT          SalesOrderNumber      
				,   SalesOrderLine        
				,   OLOrderSuffix         
				,   OHOrderSuffix         
				,   OLInvoiceNumber       
				,   OHCreationdate        
				,   DateOrderDue          
				,   OHDuedate             
				,   OHInvoiceNumber       
				,   OLDateDue             
				,   OHOrderSort           	
				,   OHProjectType         	
				,   OHBranch              
				,   OrderShipVia          	
				,   OHPrimaryGroup        
				,   OHShippingZone        
				,   OLDateOrder           
				,   OLDateShipped         
				,   OLDateLineInvoiced    
				,   OLCustDueDate         
				,   OLBranch              
				,   OLShipVia             	
				,   OLCustomerPart        	
				,   OLInternationalFlag     
				,   OLBOMExplodeFlag      
				,   OLFlagTaxStatus       
				,   OLCreditMemoFlag      
				,   OLFlagRMA             
				,   OLBOMCompleteFlag     
				,   OLBOMParentLineNumber 
				,   OLSerializedFlag      
				,   OLUMInventory         
				,   OLProductLine         
				,   OLPriceGroupID        	
				,   OLSOGroupID           	
				,   OLUser1               	
				,   OLUser2               	
				,   OLTrackingNotes       	
				,   OLUser4               	
				,   OLUser5ShipVia        	
				,   OLShippingZone        
				,   OLPhase               
				,   OLPriceDescription    	
				,   OLLineType            
			    ,   [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		        ,   [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
                                                                             SalesOrderNumber      
																		 +   SalesOrderLine        
																		 +   OLOrderSuffix         
																		 +   OHOrderSuffix         
																		 +   OLInvoiceNumber       
																		 +   cast(OHCreationdate     as nvarchar(26))
																		 +   cast(DateOrderDue       as nvarchar(26))      
																		 +   cast(OHDuedate          as nvarchar(26))        
																		 +   OHInvoiceNumber       
																		 +   cast(OLDateDue          as nvarchar(26))       
																		 +   OHOrderSort           	
																		 +   OHProjectType         	
																		 +   OHBranch              
																		 +   OrderShipVia          	
																		 +   OHPrimaryGroup        
																		 +   OHShippingZone        
																		 +   cast(OLDateOrder        as nvarchar(26))       
																		 +   cast(OLDateShipped      as nvarchar(26))      
																		 +   cast(OLDateLineInvoiced as nvarchar(26))   
																		 +   cast(OLCustDueDate      as nvarchar(26))      
																		 +   OLBranch              
																		 +   OLShipVia             	
																		 +   OLCustomerPart        	
																		 +   OLInternationalFlag     
																		 +   OLBOMExplodeFlag      
																		 +   OLFlagTaxStatus       
																		 +   OLCreditMemoFlag      
																		 +   OLFlagRMA             
																		 +   OLBOMCompleteFlag     
																		 +   OLBOMParentLineNumber 
																		 +   OLSerializedFlag      
																		 +   OLUMInventory         
																		 +   OLProductLine         
																		 +   OLPriceGroupID        	
																		 +   OLSOGroupID           	
																		 +   OLUser1               	
																		 +   OLUser2               	
																		 +   OLTrackingNotes       	
																		 +   OLUser4               	
																		 +   OLUser5ShipVia        	
																		 +   OLShippingZone        
																		 +   OLPhase               
																		 +   OLPriceDescription    	
																		 +   OLLineType            
																	 ) 
                                                                             
                ,   [SourceSystemName]		      = CAST('Global Shop'        AS NVARCHAR(100))
		        ,   [DWEffectiveStartDate]	      = CAST(Getdate()            AS DATETIME2(7))
		        ,   [DWEffectiveEndDate]		  = '2100-01-01'
		        ,   [DWIsCurrent]				  = CAST(1					  AS BIT)
		        ,   [LoadLogKey]				  = CAST(0                    AS INT)
FROM            dwstage._V_Invoice

