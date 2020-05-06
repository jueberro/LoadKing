CREATE VIEW [dwstage].[V_LoadFactInvoice]
	AS
    SELECT          [SalesOrderNumber]   
				,   [SalesOrderLine] 
				,   [OHOrderSuffix] 
				,   [OLOrderSuffix] 
				,   [OLInvoiceNumber] 
				,   [OLDateShipped] 
				,   [OLDateLineInvoiced] 
				,   [QtyOrdered]               
				,   [QtyShipped]               
				,   [QtyBO]                    
				,   [QtyOriginal]              
				,   [Cost]                     
				,   [CostMaterial]             
				,   [CostLabor]                
				,   [CostOutside]              
				,   [CostOverhead]             
				,   [CostOther]                
				,   [Margin]                   
				,   [Price]                    
				,   [ExtendedPrice]            
				,   [TaxApply1]                
				,   [TaxApply2]                
				,   [TaxAmt1]                  
				,   [TaxAmt2]                  
					    
                ,   [Type1RecordHash]			  = HASHBYTES('SHA2_256',        
                                                                             cast([OLDateShipped]           as nvarchar(26))
																		 +   cast([OLDateLineInvoiced]      as nvarchar(26))
																		 +   cast([QtyOrdered]              as nvarchar(16))      
																		 +   cast([QtyShipped]              as nvarchar(16))
																		 +   cast([QtyBO]                   as nvarchar(16))
																		 +   cast([QtyOriginal]             as nvarchar(16))
																		 +   cast([Cost]                    as nvarchar(16))
																		 +   cast([CostMaterial]            as nvarchar(16))
																		 +   cast([CostLabor]               as nvarchar(16))
																		 +   cast([CostOutside]             as nvarchar(16))
																		 +   cast([CostOverhead]            as nvarchar(16))
																		 +   cast([CostOther]               as nvarchar(16))
																		 +   cast([Margin]                  as nvarchar(16))
																		 +   cast([Price]                   as nvarchar(16))
																		 +   cast([ExtendedPrice]           as nvarchar(16))
																		 +   cast([TaxApply1]               as nvarchar(16))
																		 +   cast([TaxApply2]               as nvarchar(16))
																		 +   cast([TaxAmt1]                 as nvarchar(16))
																		 +   cast([TaxAmt2]                 as nvarchar(16))
																		 
	                 ) 
                                                                             
                ,   [SourceSystemName]		      = CAST('Global Shop'        AS NVARCHAR(100))
		        ,   [DWEffectiveStartDate]	      = CAST(Getdate()            AS DATETIME2(7))
		        ,   [DWEffectiveEndDate]		  = '2100-01-01'
		        ,   [DWIsCurrent]				  = CAST(1					  AS BIT)
		        ,   [LoadLogKey]				  = CAST(0                    AS INT)
FROM            dwstage._V_Invoice

