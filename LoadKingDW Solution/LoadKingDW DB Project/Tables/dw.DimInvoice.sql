CREATE TABLE [dw].[DimInvoice](
	[DimInvoice_Key] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderNumber] [nchar](7) NULL,
	[SalesOrderLine] [nchar](4) NULL,
	[OHOrderSuffix] [nchar](4) NULL,
	[OHInvoiceNumber] [nchar](7) NULL,
	[OHCreationDate] [datetime] NULL,
	[OHDateOrderDue] [datetime] NULL,
	[OLDateOrderDue] [datetime] NULL,
	[OLDateDue] [datetime] NULL,
	[OHOrderSort] [nvarchar](20) NULL,
	[OHProjectType] [nvarchar](30) NULL,
	[OHBranch] [nchar](2) NULL,
	[OHShipVia] [nvarchar](20) NULL,
	[OHPrimaryGroup] [nchar](2) NULL,
	[OHShippingZone] [nchar](6) NULL,
	[OLDateOrder] [datetime] NULL,
	[OLCustDueDate] [datetime] NULL,
	[OLBranch] [nchar](2) NULL,
	[OLShipVia] [nvarchar](20) NULL,
	[OLCustomerPart] [nvarchar](20) NULL,
	[OLInternationalFlag] [nchar](1) NULL,
	[OLBOMExplodeFlag] [nchar](1) NULL,
	[OLFlagTaxStatus] [nchar](1) NULL,
	[OLCreditMemoFlag] [nchar](1) NULL,
	[OLFlagRMA] [nchar](1) NULL,
	[OLBOMCompleteFlag] [nchar](1) NULL,
	[OLBOMParentLineNumber] [nchar](4) NULL,
	[OLSerializedFlag] [nchar](1) NULL,
	[OLUMInventory] [nchar](2) NULL,
	[OLProductLine] [nchar](2) NULL,
	[OLPriceGroupID] [nvarchar](20) NULL,
	[OLSOGroupID] [nvarchar](20) NULL,
	[OLUser1] [nvarchar](30) NULL,
	[OLUser2] [nvarchar](30) NULL,
	[OLTrackingNotes] [nvarchar](30) NULL,
	[OLUser4] [nvarchar](30) NULL,
	[OLUser5_ShipVia] [nvarchar](30) NULL,
	[OLShippingZone] [nchar](6) NULL,
	[OLPhase] [nchar](4) NULL,
	[OLPriceDescription] [nvarchar](30) NULL,
	[OLLineType] [nchar](1) NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [pk_DimInvoice] PRIMARY KEY CLUSTERED 
(
	[DimInvoice_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO














































































