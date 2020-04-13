CREATE VIEW [dwstage].[V_LoadDimSalesOrder] AS

SELECT   DISTINCT
		  OrderNumber				= CAST(Stage.ORDER_NO		AS NVARCHAR(10))
		, OrderType					= CAST(Stage.ORDER_TYPE		AS NVARCHAR(1))
		, OrderSuffix				= CAST(Stage.ORDER_SUFFIX	AS NVARCHAR(4))
		, CustomerPO				= CAST(Stage.CUSTOMER_PO	AS NVARCHAR(20))
		/*Hash used for identifying changes, not required for reporting*/
		, RecordHash				= CAST(HASHBYTES('SHA2_256',   CAST(Stage.ORDER_NO		AS NVARCHAR(10))
															+ CAST(Stage.ORDER_TYPE	AS NVARCHAR(1))
															+ CAST(Stage.ORDER_SUFFIX	AS NVARCHAR(4))
															+ CAST(Stage.CUSTOMER_PO	AS NVARCHAR(20))
											) AS VARBINARY(64))

		/*DW Metadata fields, not required for reporting*/
	    , [SourceSystemName]		= CAST('Global Shop'        AS NVARCHAR(100))
		, [LoadLogKey]				= CAST(0                    AS INT)

FROM	dwstage.ORDER_HEADER AS Stage


