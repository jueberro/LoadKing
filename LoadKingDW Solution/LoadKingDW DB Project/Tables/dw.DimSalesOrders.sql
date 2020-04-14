CREATE TABLE [dw].[DimSalesOrders](
	[DimSalesOrder_Key] [int] IDENTITY(1,1) NOT NULL,
	[DimCustomer_Key] [int] NOT NULL,
	[DimCustomerShipTo_Key] [int] NOT NULL,
	[OrderDateDimDate_Key] [int] NULL,
	[DueDateDimDate_Key] [int] NULL,
	[QuoteCreateDimDate_Key] [int] NULL,
	[QuoteWonLostDimDate] [int] NULL,
	[SONumber] [nchar](7) NOT NULL,
	[CustomerID] [nchar](6) NOT NULL,
	[CustomerName] [nvarchar](50) NULL,
	[ShipToID] [nchar](6) NOT NULL,
	[SOCreationDate] [date] NULL,
	[SODueDate] [date] NULL,
	[OrderSort] [nvarchar](20) NULL,
	[ProjectType] [nvarchar](30) NULL,
	[SalesPerson] [nvarchar](50) NULL,
	[Branch] [nvarchar](2) NULL,
	[ShipVia] [nvarchar](20) NULL,
	[QuoteNumber] [nchar](7) NULL,
	[QuoteCreationDate] [date] NULL,
	[QuoteWonLostDate] [date] NULL,
	[PrimaryGroup] [nchar](2) NULL,
	[ShippingZone] [nchar](6) NULL,
	[SODatelastChanged] [date] NULL,
	[SOLastChangeBy] [nvarchar](8) NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL, CONSTRAINT [pk_DimSalesOrders] PRIMARY KEY CLUSTERED 
(
	[DimSalesOrder_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO