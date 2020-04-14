CREATE TABLE [dw].[DimSalesOrder_BobsVersion](
	[DimSalesOrderBobs_Key] [int] IDENTITY(1,1) NOT NULL,
	[DimCustomer_Key] [int] NOT NULL,
	[DimEmployee_Key] [int] NOT NULL,
	[OrderNumber] [nchar](7) NOT NULL,
	[InvoiceNumber] [nvarchar](10) NOT NULL,
	[OrderDate] [date] NULL,
	[DueDate] [date] NULL,
	[OrderType] [nvarchar](1) NULL,
	[OrderSuffix] [nvarchar](4) NULL,
	[CustomerPO] [nvarchar](20) NULL,
	[FillCustomerPO] [nvarchar](20) NULL,
	[MarkInfo] [nvarchar](30) NULL,
	[CodeFOB] [nvarchar](14) NULL,
	[Terms] [nvarchar](10) NULL,
	[WayBill] [nvarchar](19) NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [pk_DimSalesOrderBobs] PRIMARY KEY CLUSTERED 
(
	[DimSalesOrderBobs_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]