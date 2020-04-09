CREATE VIEW [dwstage].[V_FactSalesOrderLine] AS

SELECT    DimSalesOrder_Key			= ISNULL(DSO.DimSalesOrder_Key, -1)
		, DimCustomer_Key			= ISNULL(DC.DimCustomer_Key, -1)
		, OrderDimDate_Key 			= ISNULL(OrderDate.DimDate_Key, -1)
		, DueDimDate_Key 			= ISNULL(DueDate.DimDate_Key, -1)
		, DimProduct_Key 			= -1	--ISNULL(DPR.DimProduct_Key, -1) /*JOIN needs more info*/
		, DimPart_Key 				= -1
		, DimEmployee_Key 			= ISNULL(DE.DimEmployee_Key, -1)
		, DimCustomerShipTo_Key 	= ISNULL(DCST.DimCustomerShipTo_Key, -1)
		, DimOrderType_Key 			= -1
									
		-- measures					
		, QuantityOrdered			= CAST(Stage.QTY_ORDERED			AS DECIMAL(13, 4))
		, Cost  					= CAST(Stage.COST					AS DECIMAL(16, 4))
		, MaterialCost 				= CAST(Stage.COST_MATERIAL			AS DECIMAL(16, 4))
		, LaborCost 				= CAST(Stage.COST_LABOR				AS DECIMAL(16, 4))
		, OutsideCost 				= CAST(Stage.COST_OUTSIDE			AS DECIMAL(16, 4))
		, OverheadCost 				= CAST(Stage.COST_OVERHEAD			AS DECIMAL(16, 4))
		, OtherCost 				= CAST(Stage.COST_OTHER				AS DECIMAL(16, 4))
		, Margin 					= CAST(Stage.MARGIN					AS DECIMAL(16, 4))
		, Price 					= CAST(Stage.PRICE					AS DECIMAL(16, 4))
		, PriceDiscount 			= CAST(Stage.PRICE_DISCOUNT			AS DECIMAL(16, 4))
		, PricePerPound 			= CAST(Stage.PRICE_LB				AS DECIMAL(16, 4))			
		, DiscountAmount 			= CAST(Stage.AMT_DISCOUNT			AS DECIMAL(16, 4))
		, OrderDiscount 			= CAST(Stage.AMT_DISCOUNT_ORDER		AS DECIMAL(16, 4))	/*CHECK THIS FIELD*/
		, PriceClassDiscount 		= CAST(Stage.PRICE_CLASS_DISC		AS DECIMAL(16, 4))
		, ProductLineDiscount 		= CAST(Stage.PROD_LINE_DISC			AS DECIMAL(16, 4))
		, OrderDiscountAmount 		= CAST(Stage.AMT_DISC_ORDER			AS DECIMAL(16, 4))		/*CHECK THIS FIELD*/
		, ProductClassDiscountAmount= CAST(Stage.AMT_DISC_PR_CLASS		AS DECIMAL(16, 4))
		, ProductLineDiscountAmount = CAST(Stage.PROD_LINE_DISC			AS DECIMAL(16, 4))
		, OrderPrice 				= CAST(Stage.PRICE_ORDER			AS DECIMAL(16, 4))
		, OrderDiscountPrice 		= CAST(Stage.PRICE_DISCOUNT_ORDER	AS DECIMAL(16, 4))
		, OrderPricePerPound 		= CAST(Stage.PRICE_LB_ORDER			AS DECIMAL(16, 4))

		/*Hash used for identifying changes, not required for reporting*/
		, RecordHash				= CAST(0 AS VARBINARY(64)) 

		/*DW Metadata fields, not required for reporting*/
	    , [SourceSystemName]		= CAST('Global Shop'        AS NVARCHAR(100))
		, [LoadLogKey]				= CAST(0                    AS INT)

FROM	dwstage.ORDER_HIST_LINE AS Stage

 LEFT OUTER JOIN dw.DimSalesOrder AS DSO
  ON	CAST(Stage.ORDER_NO AS NVARCHAR(10)) = DSO.OrderNumber
   AND	DSO.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    CAST(Stage.CUSTOMER	AS NCHAR(6)) = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS OrderDate
  ON	Stage.DATE_ORDER = OrderDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimDate AS DueDate
  ON	Stage.DATE_DUE = DueDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 --LEFT OUTER JOIN dw.DimProduct AS DPR
 -- ON	< TBD >

 LEFT OUTER JOIN dw.DimEmployee AS DE
  ON	CAST(Stage.SALESPERSON AS NCHAR(5)) = DE.EmployeeID
   AND	DE.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimCustomerShipTo AS DCST
  ON	CAST(stage.CUSTOMER_SHIP AS NCHAR(6)) = DCST.CustomerShipToID
   AND	DCST.DWIsCurrent = 1