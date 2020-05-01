﻿CREATE TABLE [dw].[FactSalesOrderLine](
	[FactSalesOrderLine_Key] [int] IDENTITY(1,1) NOT NULL,
	[DimSalesOrder_Key] [int] NOT NULL,
	[DimCustomer_Key] [int] NOT NULL,
	[OrderDateDimDate_Key] [int] NOT NULL,
	[ShipDateDimDate_Key] [int] NOT NULL,
	[DimCustomerShipTo_Key] [int] NOT NULL,
	[FactInventory_Key] [int] NOT NULL,
	[DimGLMaster_Key] [int] NOT NULL,
	[DimSalesperson_Key] [int] NOT NULL,
	[DimQuote_Key] [int] NOT NULL,
	[OrderNumber] [nchar](7) NOT NULL,
	[OrderLine] [nchar](4) NULL DEFAULT 0,
	[OLDateOrder] [datetime] NULL,
	[OLDateShipped] [datetime] NULL,
	[Price] [decimal](16, 4) NULL,
	[Cost] [decimal](16, 4) NULL,
	[ExtenedPrice] [decimal](16, 4) NULL,
	[Margin] [decimal](16, 4) NULL,
	[QtyOriginal] [decimal](16, 4) NULL,
	[QtyAllocated] [decimal](16, 4) NULL,
	[QuantityOrdered] [decimal](16, 4) NULL,
	[Qty_Shipped] [decimal](16, 4) NULL,
	[QtyBackOrdered] [decimal](16, 4) NULL,
	[PriceDiscount] [decimal](16, 4) NULL,
	[PricePerPound] [decimal](16, 4) NULL,
	[DiscountAmount] [decimal](16, 4) NULL,
	[OrderDiscount] [decimal](16, 4) NULL,
	[ProductClassDiscountAmount] [decimal](16, 4) NULL,
	[ProductLineDiscount] [decimal](16, 4) NULL,
	[OrderDiscountAmount] [decimal](16, 4) NULL,
	[PriceClassDiscount] [decimal](16, 4) NULL,
	[ProductLineDiscountAmount] [decimal](16, 4) NULL,
	[OrderPrice] [decimal](16, 4) NULL,
	[OrderDiscountPrice] [decimal](16, 4) NULL,
	[OrderPricePerPound] [decimal](16, 4) NULL,
	[RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 
 CONSTRAINT [pk_FactSalesOrderLine] PRIMARY KEY NONCLUSTERED 

(
	[FactSalesOrderLine_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)