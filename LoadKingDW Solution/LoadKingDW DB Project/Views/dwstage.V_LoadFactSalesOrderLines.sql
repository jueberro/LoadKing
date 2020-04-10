CREATE VIEW [dwstage].[V_LoadFactSalesOrderLines] AS

SELECT    DimSalesOrder_Key			= ISNULL(DSO.DimSalesOrder_Key, -1)
	    , DimCustomer_Key			= ISNULL(DC.DimCustomer_Key, -1)
		, OrderDateDimDate_Key 		= ISNULL(OrderDate.DimDate_Key, -1)
		, ShipDateDimDate_Key 		= ISNULL(ShipDate.DimDate_Key, -1)
		, DimCustomerShipTo_Key 	= ISNULL(DCST.DimCustomerShipTo_Key, -1)
		, DimPart_Key 				= ISNULL(DI.DimPart_Key, -1)

		--, DimProduct_Key 			    = -1	--ISNULL(DPR.DimProduct_Key, -1) /*JOIN needs more info*/
		--, DimEmployee_Key 			= ISNULL(DE.DimEmployee_Key, -1) In ORDER_HEADER
		--, DimOrderType_Key 			= -1
		
		--Key Attributes
		, OrderNumber               = CAST(Stage.ORDER_NO				AS nchar(7))
		, OrderLine                 = CAST(Stage.RECORD_NO              AS nchar(4))
		, ShipToId                  = CAST(Stage.SHIP_ID                AS nchar(6))
		, OrderDate                 = dwstage.udf_cv_nvarchar8_to_date(Stage.DATE_ORDER)
		, Shipdate                  = dwstage.udf_cv_nvarchar6_to_date(Stage.DATE_SHIP)
		, Customer                  = CAST(Stage.CUSTOMER               AS nchar(6))
		, Part                      = CAST(Stage.PART                   AS nchar(20))

		-- measures					
		, QuantityOrdered			= CAST(Stage.QTY_ORDERED			AS DECIMAL(13, 4))
		, Cost  					= CAST(Stage.COST					AS DECIMAL(16, 4))
	   	, Margin 					= CAST(Stage.MARGIN					AS DECIMAL(16, 4))
		, Price 					= CAST(Stage.PRICE					AS DECIMAL(16, 4))
		, PriceDiscount 			= CAST(Stage.DISCOUNT_PRICE			AS DECIMAL(16, 4))
		, PricePerPound 			= CAST(Stage.PRICE_LB				AS DECIMAL(16, 4))			
		, DiscountAmount 			= CAST(Stage.AMT_DISCOUNT			AS DECIMAL(16, 4))
		, OrderDiscount 			= CAST(Stage.ORDER_DISC_AMT		    AS DECIMAL(16, 4))	/*CHECK THIS FIELD*/
		, PriceClassDiscount 		= CAST(Stage.PRICE_CLASS_DISC		AS DECIMAL(16, 4))
		, ProductLineDiscount 		= CAST(Stage.PROD_LINE_DISC			AS DECIMAL(16, 4))
		, OrderDiscountAmount 		= CAST(Stage.AMT_DISC_ORDER			AS DECIMAL(16, 4))		/*CHECK THIS FIELD*/
		, ProductClassDiscountAmount= CAST(Stage.AMT_DISC_PR_CL_ORD		AS DECIMAL(16, 4))
		, ProductLineDiscountAmount = CAST(Stage.PROD_LINE_DISC			AS DECIMAL(16, 4))
		, OrderPrice 				= CAST(Stage.PRICE_ORDER			AS DECIMAL(16, 4))
		, OrderDiscountPrice 		= CAST(Stage.PRICE_DISC_ORD	        AS DECIMAL(16, 4))
		, OrderPricePerPound 		= CAST(Stage.PRICE_LB_ORDER			AS DECIMAL(16, 4))

		/*Hash used for identifying changes, not required for reporting*/
		, RecordHash				= CAST(0 AS VARBINARY(64)) 

		/*DW Metadata fields, not required for reporting*/
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)

FROM	dwstage.ORDER_LINES AS Stage
   --      Where Stage.RECORD_TYPE = 'L'

 LEFT OUTER JOIN dw.DimSalesOrder AS DSO
  ON	CAST(Stage.ORDER_NO AS NCHAR(7)) = DSO.OrderNumber
   AND	DSO.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    CAST(Stage.CUSTOMER	AS NCHAR(6)) = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimInventory AS DI
  ON    CAST(Stage.PART	AS NCHAR(20)) = DC.CustomerID
   AND  DI.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS OrderDate
  ON	dwstage.udf_cv_nvarchar8_to_date(Stage.DATE_ORDER) = OrderDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimDate AS ShipDate
  ON	dwstage.udf_cv_nvarchar6_to_date(Stage.DATE_SHIP) = ShipDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimCustomerShipTo AS DCST
  ON	CAST(stage.SHIP_ID AS NCHAR(6)) = DCST.ShipToSeq
   AND	DCST.DWIsCurrent = 1

    --LEFT OUTER JOIN dw.DimProduct AS DPR
 -- ON	< TBD >

 /*--- In Header
 LEFT OUTER JOIN dw.DimEmployee AS DE
  ON	CAST(Stage.SALESPERSON AS NCHAR(5)) = DE.EmployeeID
   AND	DE.DWIsCurrent = 1
*/
