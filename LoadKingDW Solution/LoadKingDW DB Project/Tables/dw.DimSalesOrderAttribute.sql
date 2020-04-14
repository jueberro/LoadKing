CREATE TABLE [dbo].[DimSalesOrderAttribute]
(
-- Order_Header
--[OrderSort] [nvarchar](20) NULL,
--[ProjectType] [nvarchar](30) NULL,
--[SalesPerson] [nvarchar](50) NULL,
--[Branch] [nvarchar](2) NULL,
--[ShipVia] [nvarchar](20) NULL,
--[QuoteNumber] [nchar](7) NULL,
--[QuoteCreationDate] [date] NULL,
--[QuoteWonLostDate] [date] NULL,

	---FactSalesOrdeLine

--[LINE_TYPE] [char](1) NULL,	LineType
--[FLAG_SO_TO_WO] [char](1) NULL,	FlagSOtoWO
--[DESCRIPTION] [char](30) NULL,	NOT REQ-InDimInventory
--[USER_1] [char](30) NULL,	User1
--[USER_2] [char](30) NULL,	User2
--[USER_3] [char](30) NULL,	TrackingNotes
--[USER_4] [char](30) NULL,	User3
--[USER_5] [char](30) NULL,	LineShipVia
--[GL_ACCOUNT] [char](15) NULL,	GLAccount-Makeit a Key
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
	Dummy Int
)
