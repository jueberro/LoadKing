CREATE VIEW [dwstage].[V_LoadFactSalesOrderLine] AS

SELECT    DimSalesOrder_Key			= ISNULL(DSO.DimSalesOrder_Key, -1)
	    , DimCustomer_Key			= ISNULL(DC.DimCustomer_Key, -1)
		, OrderDateDimDate_Key 		= ISNULL(OrderDate.DimDate_Key, -1)
		, ShipDateDimDate_Key 		= ISNULL(ShipDate.DimDate_Key, -1)
		, DimCustomerShipTo_Key 	= ISNULL(DCST.DimCustomerShipTo_Key, -1)
		, DimInventory_Key 			= ISNULL(DI.DimInventory_Key, -1)

		--Key Attributes
		, OrderNumber               = CAST(Stage.ORDER_NO				AS nchar(7))
		, OrderLine                 = CAST(Stage.RECORD_NO              AS nchar(4))
		

		-- measures					
		, QuantityOrdered			= CAST(Stage.QTY_ORDERED			AS DECIMAL(16, 4))
		, Cost  					= CAST(Stage.COST					AS DECIMAL(16, 4))
	    , Margin 					= CAST(Stage.MARGIN					AS DECIMAL(16, 4))
	    , Price 					= CAST(Stage.PRICE					AS DECIMAL(16, 4))
	    , PriceDiscount 			= CASE WHEN Isnumeric(Stage.DISCOUNT_PRICE) = 1 then CAST(Stage.DISCOUNT_PRICE	        AS NUMERIC(16,4))  ELSE NULL  END
	    , PricePerPound 			= CASE WHEN Isnumeric(Stage.PRICE_LB) = 1    then CAST(Stage.PRICE_LB				    AS DECIMAL(16, 4)) ELSE NULL END		
		, DiscountAmount 			= CASE WHEN Isnumeric(Stage.AMT_DISCOUNT) = 1 then CAST(Stage.AMT_DISCOUNT				AS DECIMAL(16, 4)) ELSE NULL END		
	    , OrderDiscount 			= CASE WHEN Isnumeric(Stage.ORDER_DISC_AMT) = 1 then CAST(Stage.ORDER_DISC_AMT		    AS DECIMAL(16, 4))	ELSE NULL END	 
		, PriceClassDiscount 		= CASE WHEN Isnumeric(Stage.PRICE_CLASS_DISC) = 1 then CAST(Stage.PRICE_CLASS_DISC		AS DECIMAL(16, 4))	ELSE NULL END
        , ProductLineDiscount 		= CASE WHEN Isnumeric(Stage.PROD_LINE_DISC) = 1 then  CAST(Stage.PROD_LINE_DISC			AS DECIMAL(16, 4)) ELSE NULL END
		, OrderDiscountAmount 		= CAST(Stage.AMT_DISC_ORDER			AS DECIMAL(16, 4))		
		, ProductClassDiscountAmount= CAST(Stage.AMT_DISC_PR_CL_ORD		AS DECIMAL(16, 4))
		, ProductLineDiscountAmount = CAST(Stage.PRDLN_DISC_AMT			AS DECIMAL(16, 4))
		, OrderPrice 				= CASE WHEN Isnumeric(Stage.PRICE_ORDER) = 1 then   CAST(Stage.PRICE_ORDER		     	AS DECIMAL(16, 4)) ELSE NULL END
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
   
 LEFT OUTER JOIN dw.DimSalesOrder AS DSO
  ON	CAST(Stage.ORDER_NO AS NCHAR(7)) = DSO.SalesOrderNumber   AND	DSO.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    CAST(Stage.CUSTOMER	AS NCHAR(6)) = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimInventory AS DI
  ON    CAST(Stage.PART	AS NCHAR(20)) = DI.PartID
   AND  DI.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS OrderDate
  ON	CAST(Stage.DATE_ORDER as datetime) = OrderDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimDate AS ShipDate
  ON	CAST(Stage.DATE_SHIP as Datetime) = ShipDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimCustomerShipTo AS DCST
  ON	CAST(stage.SHIP_ID AS NCHAR(6)) = DCST.ShipToSeq
   AND     CAST(Stage.CUSTOMER AS nchar(6)) = DCST.PrimaryCustomerID
      AND	DCST.DWIsCurrent = 1

      Where Stage.RECORD_TYPE = 'L'

