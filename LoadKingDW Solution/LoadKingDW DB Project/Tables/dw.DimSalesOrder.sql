CREATE TABLE [dw].[DimSalesOrder](
	[DimSalesOrder_Key] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderNumber] [nchar](7) NOT NULL,
	[SOCreationDate] [date] NULL,
	[SODueDate] [date] NULL,
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