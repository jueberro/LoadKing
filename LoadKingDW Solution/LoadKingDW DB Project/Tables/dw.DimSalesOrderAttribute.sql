CREATE TABLE [dbo].[DimSalesOrderAttribute]
( [DimSalesOrderAttribute_Key] Int IDENTITY(1,1) NOT NULL,
-- Order_Header
[OrderSort] [nvarchar](20) NULL,
[ProjectType] [nvarchar](30) NULL,
[Branch] [nvarchar](2) NULL,
[ShipVia] [nvarchar](20) NULL,


	---FactSalesOrdeLine

--[LineType] [char](1) NULL,	      
--[FlagSOtoWO] [char](1) NULL,	
--[CUSTOMER_PART] [char](20) NULL,	CustomerPart
--[INFO_1] [char](20) NULL,	PriceGroupID
--[INFO_2] [char](20) NULL,	SOGroupID
--[FLAG_PURCHASED] [char](1) NULL,	FlagPurchased
--[INACTIVE] bit NULL,	FlagInactive
--[FLAG_BOM] [char](1) NULL,	FlagBOM
--[PRICE_BOM_COMP_FLG] [char](1) NULL,	FlagBOMComplete
--[BOM_PARENT] [char](4) NULL,	BOMParent
--[PRODUCT_LINE] [char](2) NULL,	ProductLine
--[DATE_ITEM_PROM] date NULL,	ItemPromiseDateDimDate
--[ITEM_PROMISE_DT] date NULL,	PromiseDateDimDate
--[ADD_BY_DATE] date NULL,	DateAddedDateDimDate
--[MUST_DLVR_BY_DATE] date NULL,	DeliverByDateDimDate
--[EXTENSION] Numeric(16,2) NULL,	ExtendedPrice
--[QTY_ORIGINAL] [numeric](13,4) NULL,	QtyOriginal
--[QTY_ALLOC] [numeric](13,4) NULL,	QtyAllocated
--[QTY_SHIPPED] [numeric](13,4) NULL,	QtyShipped
--[QTY_BO] [numeric](13,4) NULL,	QtyBackOrdered
--[DATE_LAST_CHG] date NULL,	DateLastChanged
--[TIME_LAST_CHG] [varchar](50) NULL,	*Just Use Date
--[LAST_CHG_BY] [char](8) NULL,	LastChangedBy


	/*Hashes used for identifying changes, not required for reporting*/
	Type1RecordHash				VARBINARY(64)				NULL,
	Type2RecordHash				VARBINARY(64)				NULL,

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	LoadLogKey					INT					NOT NULL, --ID of ETL process that inserted the record    CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED ([DimEmployee_Key] ASC)

    CONSTRAINT [pk_DimSalesOrderAttribute] PRIMARY KEY CLUSTERED ([DimSalesOrderAttribute_Key] ASC)

)
