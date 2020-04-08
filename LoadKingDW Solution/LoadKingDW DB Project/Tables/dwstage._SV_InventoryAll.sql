CREATE TABLE [dwstage].[_SV_InventoryAll](
	[PartID] [nchar](20) NULL,
	[PartLocation] [nchar](2) NULL,
	[PartCodeABC] [nchar](1) NULL,
	[PartProductLine] [nchar](2) NULL,
	[PartBin] [nchar](6) NULL,
	[PartDescription] [nvarchar](100) NULL,
	[PartPrice] [numeric](13, 5) NULL,
	[PartObsoleteFlag] [bit] NULL,
	[PartCodeBOM] [nchar](1) NULL,
	[PartCodeDiscount] [nchar](1) NULL,
	[PartCodeTotal] [nchar](1) NULL,
	[PartCodeSort] [nchar](10) NULL,
	[PartVendorName] [nvarchar](50) NULL,
	[PartDescription2] [nvarchar](100) NULL,
	[PartDescription3] [nvarchar](100) NULL,
	[PartVatProductType] [nchar](5) NULL,
	[PartTaxExemptFlag] [nchar](1) NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO