CREATE TABLE [dw].[DimVendor](
	[DimVendor_Key] [int] IDENTITY(1,1) NOT NULL,
	[Vendor] [nchar](6) NOT NULL,
	[VendorName] [nvarchar](30) NOT NULL,
	[VendorAddress1] [nvarchar](30) NULL,
	[VendorAddress2] [nvarchar](30) NULL,
	[VendorCity] [nvarchar](20) NULL,
	[VendorState] [nchar](2) NULL,
	[VendorPostalCode] [nchar](13) NULL,
	[VendorCountry] [nchar](12) NULL,
	[VendorCounty] [nchar](12) NULL,
	[VendorIntlFlag] [nchar](1) NULL,
	[VendorTerritory] [nchar](2) NULL,
	[VendorCodeArea] [nchar](2) NULL,
	[VendorEmail] [nvarchar](30) NULL,
	[VendorApproved_Suppl] [nchar](1) NULL,
	[VendorCritical_Suppl] [nchar](1) NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [pk_DimVendor] PRIMARY KEY CLUSTERED 
(
	[DimVendor_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


