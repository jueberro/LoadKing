CREATE TABLE [dw].[FactSalesOrderLine]
(
	
	FactSalesOrderLine_Key			INT IDENTITY(1,1)	NOT NULL
	-- dimensions
	, OrderNumber					NVARCHAR(10)		NOT NULL		--UNIQUE KEY
	, OrderLineNumber				NVARCHAR(4)			NOT NULL--UNIQUE KEY

	, DimSalesOrder_Key				INT					NOT NULL
	, DimCustomer_Key				INT					NOT NULL
	, OrderDimDate_Key				INT					NOT NULL
	, DueDimDate_Key				INT					NOT NULL
	, ShippedDate_Key				INT					NOT NULL

	, DimProduct_Key				INT					NOT NULL
	, DimPart_Key					INT					NOT NULL
	, DimEmployee_Key				INT					NOT NULL
	, DimCustomerShipTo_Key			INT					NOT NULL
	, DimOrderType_Key				INT					NOT NULL
	
	-- measures
	, QuantityOrdered				DECIMAL (13,4) -- Should quantity be decimal??
	, Cost							DECIMAL (16,4) 
	, MaterialCost					DECIMAL (16,4)
	, LaborCost						DECIMAL (16,4)
	, OutsideCost					DECIMAL (16,4)
	, OverheadCost					DECIMAL (16,4)
	, OtherCost						DECIMAL(16,4)
	, Margin						DECIMAL(16,4)
	, Price							DECIMAL(16,4)
	, PriceDiscount					DECIMAL(16,4)
	, PricePerPound					DECIMAL(16,4)
	, DiscountAmount				DECIMAL(16,4)
	, OrderDiscount					DECIMAL(5,4)
	, PriceClassDiscount			DECIMAL(5,4) 
	, ProductLineDiscount			DECIMAL(5,4)
	, OrderDiscountAmount			DECIMAL(16,4)
	, ProductClassDiscountAmount	DECIMAL(16,4)
	, ProductLineDiscountAmount		DECIMAL(16,4)
	, OrderPrice					DECIMAL(16,4)
	, OrderDiscountPrice			DECIMAL(16,4)
	, OrderPricePerPound			DECIMAL(16,4)

	/*Hash used for identifying changes, not required for reporting*/
	,RecordHash						VARBINARY(64)			NULL

	/*DW Metadata fields, not required for reporting*/
	,SourceSystemName				NVARCHAR(100)		NOT NULL

	/*ETL Metadata fields, not required for reporting */
	,LoadLogKey						INT					NOT NULL	--ID of ETL process that inserted the record
	, constraint pk_FactSalesOrderLine primary key nonclustered (FactSalesOrderLine_Key)
)
