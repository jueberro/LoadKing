--USE [LK-GS-EDW]
--GO



CREATE VIEW dwstage.V_LoadFactSalesOrderLine AS

SELECT    DimSalesOrder_Key			 = ISNULL(DSO.DimSalesOrder_Key,      -1)
	    , DimCustomer_Key			 = ISNULL(DC.DimCustomer_Key,         -1)
		, OrderDateDimDate_Key 		 = ISNULL(OrderDate.DimDate_Key,      -1)
		, ShipDateDimDate_Key 		 = ISNULL(ShipDate.DimDate_Key,       -1)
		, DimCustomerShipTo_Key 	 = ISNULL(DCST.DimCustomerShipTo_Key, -1)
		, DimInventory_Key 			 = ISNULL(DI.DimInventory_Key,        -1)
		, DimGLAccount_Key            = ISNULL(GLAcct.DimGLAccount_Key,    -1)
		, DimSalesperson_Key         = ISNULL(SalesP.DimSalesperson_Key,  -1)
	    , DimQuote_Key               = ISNULL(Quote.DimQuote_Key,         -1)

            --Attributes
		, Stage.SalesOrderNumber
		, Stage.SalesOrderLine  
		, Stage.OLDateOrder
	    , Stage.OLDateShipped
		
	      	--Measures
	 

	    , Stage.Price 					   
		, Stage.Cost  					   
		, Stage.ExtenedPrice                
		, Stage.Margin 					   
		, Stage.QtyOriginal                 
		, Stage.QtyAllocated                
		, Stage.QuantityOrdered			   
		, Stage.Qty_Shipped                 
		, Stage.QtyBackOrdered              
		, Stage.PriceDiscount 			   
		, Stage.PricePerPound 	     	   
		, Stage.DiscountAmount 			   
		, Stage.OrderDiscount 			   
		, Stage.ProductClassDiscountAmount  
		, Stage.ProductLineDiscount 		   
		, Stage.OrderDiscountAmount 		   
		, Stage.PriceClassDiscount 		   
		, Stage.ProductLineDiscountAmount   
		, Stage.OrderPrice 				   
		, Stage.OrderDiscountPrice 		   
		, Stage.OrderPricePerPound          
		

		  ,   [Type1RecordHash]			  = HASHBYTES('SHA2_256',                                                                  
																		     cast(stage.[OLDateOrder]       as nvarchar(26))
		                                                                 +   cast(stage.[OLDateShipped]     as nvarchar(26))		
																		 +   cast(stage.[Price]             as nvarchar(26))			
																		 +   cast([Cost]                    as nvarchar(16))      		
																		 +   cast([ExtenedPrice]            as nvarchar(16))
																		 +   cast([Margin]                  as nvarchar(16))
																		 +   cast([QtyOriginal]             as nvarchar(16))
																		 +   cast([QtyAllocated]            as nvarchar(16))
																		 +   cast([QuantityOrdered]         as nvarchar(16))
																		 +   cast([Qty_Shipped]             as nvarchar(16))
																		 +   cast([QtyBackOrdered]          as nvarchar(16))
																		 +   cast([PriceDiscount]           as nvarchar(16))
																		 +   cast([PricePerPound]           as nvarchar(16))
																		 +   cast([DiscountAmount]          as nvarchar(16))
																		 +   cast([OrderDiscount]           as nvarchar(16))
																		 +   cast([ProductClassDiscountAmount] as nvarchar(16))
																		 +   cast([ProductLineDiscount]     as nvarchar(16))
																		 +   cast([OrderDiscountAmount]     as nvarchar(16))
																		 +   cast([PriceClassDiscount]      as nvarchar(16))
																		 +   cast([ProductLineDiscountAmount]  as nvarchar(16))
																		 +   cast([Orderprice]              as nvarchar(16))
																		 +   cast([OrderDiscountPrice]      as nvarchar(16))
																		 +   cast([OrderPricePerPound]      as nvarchar(16))
																		 )
																		 
-- select count(*)
FROM	dwstage._V_SalesOrder as Stage
   
 LEFT OUTER JOIN dw.DimSalesOrder AS DSO
  ON	Stage.SalesOrderNumber = DSO.SalesOrderNumber
  AND stage.SalesOrderLine = DSO.SalesOrderLine -- ELD 5/20/2020 ADDED THIS join to the line
  AND	DSO.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    Stage.OHCustomerID = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimInventory AS DI
  ON    Stage.OLPartID = DI.PartID
   AND  DI.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS OrderDate
  ON	Stage.OLDateOrder = OrderDate.[Date]			

 LEFT OUTER JOIN dw.DimDate AS ShipDate
  ON	Stage.OLDateShipped = ShipDate.[Date]			

  LEFT OUTER JOIN dw.DimGLAccount AS GLAcct
  ON	Stage.OHGLAccount = GLAcct.GLAccount		
   AND  DI.DWIsCurrent = 1

  LEFT OUTER JOIN dw.DimSalesPerson AS SalesP
  ON	Stage.OHSalespersonID = SalesP.SalespersonID	
   AND  SalesP.DWIsCurrent = 1 -- DI.DWIsCurrent = 1 -- ELD 5/20/2020 Was joing to the wrong dim

LEFT OUTER JOIN dw.DimQuote AS Quote
  ON	Stage.OHQuoteNumber = Quote.QuoteNumber
   AND  DI.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimCustomerShipTo AS DCST
  ON	stage.OHShipToSeq = DCST.ShipToSeq
   AND     Stage.OHCustomerID  = DCST.PrimaryCustomerID
      AND	DCST.DWIsCurrent = 1
GO


