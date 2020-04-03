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
	, Cost decimal (16,4) 
	, MaterialCost decimal (16,4)
	, LaborCost decimal (16,4)
	, OutsideCost decimal (16,4)
	, OverheadCost decimal (16,4)
	, OtherCost decimal(16,4)
	, Margin decimal(16,4)
	, Price decimal(16,4)
	, PriceDiscount decimal(16,4)
	, PricePerPound decimal(16,4)
	, DiscountAmount decimal(16,4)
	, OrderDiscount decimal(5,4)
	, PriceClassDiscount decimal(5,4) 
	, ProductLineDiscount decimal(5,4)
	, OrderDiscountAmount decimal(16,4)
	, ProductClassDiscountAmount decimal(16,4)
	, ProductLineDiscoutnAmount decimal(16,4)
	, OrderPrice decimal(16,4)
	, OrderDiscountPrice decimal(16,4)
	, OrderPricePerPound decimal(16,4)

	/*Hash used for identifying changes, not required for reporting*/
	,RecordHash					VARBINARY(64)			NULL

	/*DW Metadata fields, not required for reporting*/
	,SourceSystemName			NVARCHAR(100)		NOT NULL

	/*ETL Metadata fields, not required for reporting */
	,LoadLogKey					INT					NOT NULL	--ID of ETL process that inserted the record
	, constraint pk_FactSalesOrderLine primary key nonclustered (FactSalesOrderLine_Key)
)
