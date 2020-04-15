CREATE TABLE [dw].[FactSalesOrderLine]
(
	
	FactSalesOrderLine_Key int identity(1,1) not null
	-- dimensions
	, DimSalesOrder_Key int not null
	, DimCustomer_Key int not null
	, OrderDateDimDate_Key int not null
	, ShipDateDimDate_Key int not null
	, DimCustomerShipTo_Key int not null
	, FactInventory_Key int not null
	, DimGLMaster_Key int not null
	, DimSalesperson_Key int not null
	, DimSalesOrderAttribute_Key int not null
	, DimQuote_Key int not null
	--New


	-- Key Attributes 

	, OrderNumber               nchar(7)
	, OrderLine                 nchar(4)
	, OLDateOrder               datetime 
	, OLDateShipped             datetime

	--NewKeyAttributes
	, User1                     varchar(30) --[USER_1] [char](30) NULL,	User1
    , User2                     varchar(30) --[USER_2] [char](30) NULL,	User2
    , TrackingNotes             varchar(30) --[USER_3] [char](30) NULL,	TrackingNotes
    , User4                     varchar(30) --[USER_4] [char](30) NULL,	User3
    , LineShipVia               varchar(30) --[USER_5] [char](30) NULL,	LineShipVia
	
	--Measure Sources

	, QuantityOrdered decimal (13,4) -- should quantity be decimal??
	, Cost decimal (16,4) 
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
	, ProductLineDiscountAmount decimal(16,4)
	, OrderPrice decimal(16,4)
	, OrderDiscountPrice decimal(16,4)
	, OrderPricePerPound decimal(16,4)

	/*Hash used for identifying changes, not required for reporting*/
	,RecordHash					VARBINARY(64)			NULL

	/*DW Metadata fields, not required for reporting*/
	,SourceSystemName			NVARCHAR(100)		NOT NULL
    ,DWEffectiveStartDate		DATETIME2(7)		NOT NULL
	,DWEffectiveEndDate			DATETIME2(7)		NOT NULL
	,DWIsCurrent					BIT				NOT NULL

	/*ETL Metadata fields, not required for reporting */
	,LoadLogKey					INT					NOT NULL	--ID of ETL process that inserted the record
	,
    constraint pk_FactSalesOrderLine primary key nonclustered (FactSalesOrderLine_Key)
)
