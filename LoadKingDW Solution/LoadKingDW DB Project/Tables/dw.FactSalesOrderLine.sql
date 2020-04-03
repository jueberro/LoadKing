CREATE TABLE [dw].[FactSalesOrderLine]
(
	
	FactSalesOrderLine_Key int identity(1,1) not null
	-- dimensions
	, DimSalesOrder_Key int not null
	, DimCustomer_Key int not null
	, OrderDimDate_Key int not null
	, DueDimDate_Key int not null
	, DimProduct_Key int not null
	, DimPart_Key int not null
	, DimEmployee_Key int not null
	, DimCustomerShipTo_Key int not null
	, DimOrderType_Key int not null
	
	-- measures
	, QuantityOrdered decimal (13,4) -- should quantity be decimal??
	, Cost decimal (16,6) 
	, MaterialCost decimal (11,2)
	, LaborCost decimal (11,2)
	, OutsideCost decimal (11,2)
	, OverheadCost decimal (11,2)
	, OtherCost decimal(11,2)
	, Margin decimal(7,4)
	, Price decimal(16,6)
	, PriceDiscount decimal(16,6)
	, PricePerPound decimal(16,6)
	, DiscountAmount decimal(12,2)
	, OrderDiscount decimal(5,4)
	, PriceClassDiscount decimal(5,4) 
	, ProductLineDiscount decimal(5,4)
	, OrderDiscountAmount decimal(12,2)
	, ProductClassDiscountAmount decimal(12,2)
	, ProductLineDiscoutnAmount decimal(12,2)
	, OrderPrice decimal(16,6)
	, OrderDiscountPrice decimal(16,6)
	, OrderPricePerPound decimal(16,6)

	/*Hash used for identifying changes, not required for reporting*/
	,RecordHash					VARCHAR(66)			NULL

	/*DW Metadata fields, not required for reporting*/
	,SourceSystemName			NVARCHAR(100)		NOT NULL

	/*ETL Metadata fields, not required for reporting */
	,LoadLogKey					INT					NOT NULL	--ID of ETL process that inserted the record
	, constraint pk_FactSalesOrderLine primary key nonclustered (FactSalesOrderLine_Key)
)
