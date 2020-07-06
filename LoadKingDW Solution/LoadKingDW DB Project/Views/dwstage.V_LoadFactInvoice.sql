CREATE VIEW [dwstage].[V_LoadFactInvoice]
	AS
    SELECT       
	                DimInvoice_Key			     = ISNULL(DSO.DimInvoice_Key,      -1)                                          
	            ,   DimCustomer_Key			     = ISNULL(DC.DimCustomer_Key,         -1)											
		        ,   OrderDateDimDate_Key 		 = ISNULL(OrderDate.DimDate_Key,      -1)											
		        ,   ShipDateDimDate_Key 		 = ISNULL(ShipDate.DimDate_Key,       -1)											
		        ,   DimCustomerShipTo_Key     	 = ISNULL(DCST.DimCustomerShipTo_Key, -1)											
		        ,   DimInventory_Key 			 = ISNULL(DI.DimInventory_Key,        -1)											
		        ,   DimGLAccount_Key             = ISNULL(GLAcct.DimGLAccount_Key,    -1)											
		        ,   DimSalesperson_Key           = ISNULL(SalesP.DimSalesperson_Key,  -1)	
				,   DimDropShipPO_Key            = ISNULL(DropShip.DimPurchaseOrder_Key, -1)

	            ,   stage.[SalesOrderNumber]   	AS SalesOrderNumber																					
				,   stage.[SalesOrderLine] 		AS SalesOrderLine																					
				,   stage.[OHOrderSuffix] 		AS OHOrderSuffix																						
				,   [OLOrderSuffix] 																								
				,   [OLInvoiceNumber] 																								
				,   dwstage.udf_testdatevalue(stage.[OLDateShipped]) 		AS OLDateShipped																					
				,   dwstage.udf_testdatevalue([OLDateLineInvoiced])	AS OLDateLineInvoiced																						
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
				,   stage.[Price]               AS Price     																				
				,   [ExtendedPrice]            																						
				,   [TaxApply1]                																						
				,   [TaxApply2]                																						
				,   [TaxAmt1]                  																						
				,   [TaxAmt2]                  																						
					    																											
                ,   [Type1RecordHash]			  = HASHBYTES('SHA2_256',        													
                                                                             cast(stage.[OLDateShipped]     as nvarchar(26))		
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
																		 +   cast(stage.[Price]             as nvarchar(16))
																		 +   cast([ExtendedPrice]           as nvarchar(16))
																		 +   cast([TaxApply1]               as nvarchar(16))
																		 +   cast([TaxApply2]               as nvarchar(16))
																		 +   cast([TaxAmt1]                 as nvarchar(16))
																		 +   cast([TaxAmt2]                 as nvarchar(16))
																		 
	                 ) 
                                                                             
            


FROM            dwstage._V_Invoice Stage

LEFT OUTER JOIN dw.DimInvoice AS DSO
  ON	Stage.SalesOrderNumber = DSO.SalesOrderNumber   
   AND  Stage.SalesOrderLine   = DSO.SalesOrderLine
   AND  Stage.OHOrderSuffix    = DSO.OHOrderSuffix
   AND  Stage.OHInvoiceNumber  = DSO.OHInvoiceNumber
   AND	DSO.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    Stage.OLCustomer = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimInventory AS DI
  ON    Stage.OLPart = DI.PartID
   AND  DI.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS OrderDate
  ON	Stage.OLDateOrder = OrderDate.[Date]			

 LEFT OUTER JOIN dw.DimDate AS ShipDate
  ON	Stage.OLDateShipped = ShipDate.[Date]			

  LEFT OUTER JOIN dw.DimGLAccount AS GLAcct
  ON	Stage.OLGLAccount = GLAcct.GLAccount		
   AND  GLAcct.DWIsCurrent = 1

  LEFT OUTER JOIN dw.DimSalesPerson AS SalesP
  ON	Stage.OLSalesperson = SalesP.SalespersonID	
   AND  SalesP.DWIsCurrent = 1

  LEFT OUTER JOIN dw.DimCustomerShipTo AS DCST
  ON	stage.OLCustShipTo = DCST.ShipToSeq
   AND     Stage.OLCustomer = DCST.PrimaryCustomerID
      AND	DCST.DWIsCurrent = 1
  
  LEFT OUTER JOIN dw.DimPurchaseOrder  AS DropShip
  ON    stage.OLDropPO = Dropship.POH_PURCHASE_ORDER
   AND    stage.OLDropPOLine = Dropship.POH_RECORD_NO
      AND	DCST.DWIsCurrent = 1

GO