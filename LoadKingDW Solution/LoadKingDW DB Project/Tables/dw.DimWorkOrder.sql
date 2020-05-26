CREATE TABLE [dw].[DimWorkOrder](
	[DimWorkOrder_Key] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderNumber_DW] [nvarchar](15) NULL,
	[WorkOrderNumber] [nchar](6) NULL,
	[Suffix] [nchar](3) NULL,
	[DateOpened] [datetime] NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NULL,
	[DWEffectiveStartDate] [datetime2](7) NULL,
	[DWEffectiveEndDate] [datetime2](7) NULL,
	[DWIsCurrent] [bit] NULL,
	[LoadLogKey] [int] NULL,
 CONSTRAINT [pk_DimWorkOrder] PRIMARY KEY CLUSTERED 
(
	[DimWorkOrder_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

