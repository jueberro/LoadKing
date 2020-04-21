
Create VIEW [dwstage].[V_LoadFactSalesOrderLine] AS

SELECT    DimSalesOrder_Key			 = ISNULL(DSO.DimSalesOrder_Key,      -1)
	    , DimCustomer_Key			 = ISNULL(DC.DimCustomer_Key,         -1)
		, OrderDateDimDate_Key 		 = ISNULL(OrderDate.DimDate_Key,      -1)
		, ShipDateDimDate_Key 		 = ISNULL(ShipDate.DimDate_Key,       -1)
		, DimCustomerShipTo_Key 	 = ISNULL(DCST.DimCustomerShipTo_Key, -1)
		, DimInventory_Key 			 = ISNULL(DI.DimInventory_Key,        -1)
		, DimGLMaster_Key            =  -1
		, DimSalesperson_Key         =  -1
	    , DimQuote_Key               =  -1

            --Attributes
		, Stage.SalesOrderNumber
		, Stage.SalesOrderLine  
		
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
		

		/*Hash used for identifying changes, not required for reporting*/
		, RecordHash				= CAST(0 AS VARBINARY(64)) 

		/*DW Metadata fields, not required for reporting*/
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)

FROM	dwstage._V_SalesOrder as Stage
   
 LEFT OUTER JOIN dw.DimSalesOrder AS DSO
  ON	Stage.SalesOrderNumber = DSO.SalesOrderNumber   AND	DSO.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    Stage.OHCustomerID = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimInventory AS DI
  ON    Stage.OLPartID = DI.PartID
   AND  DI.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS OrderDate
  ON	CAST(Stage.DATE_ORDER as datetime) = OrderDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimDate AS ShipDate
  ON	CAST(Stage.DATE_SHIP as Datetime) = ShipDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimCustomerShipTo AS DCST
  ON	CAST(stage.SHIP_ID AS NCHAR(6)) = DCST.ShipToSeq
   AND     CAST(Stage.CUSTOMER AS nchar(6)) = DCST.PrimaryCustomerID
      AND	DCST.DWIsCurrent = 1

   --   Where Stage.RECORD_TYPE = 'L'  --Proc That builds ODS - dbo_V_SalesOrder already contains this!

