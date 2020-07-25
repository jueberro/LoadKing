﻿CREATE TABLE [dw].[FactInventory](
	[DimInventory_Key] [int] NOT NULL,
	[DimLastChgDate_Key] [int] NULL,
	[DimLastUsageDate_Key] [int] NULL,
	[DimLastAuditDate_Key] [int] NULL,
	[DimCycleDate_Key] [int] NULL,
	[PartID] [nchar](20) NOT NULL,
	[DateLastUsage] [datetime] NOT NULL,
	[DateLastAudit] [datetime] NOT NULL,
	[Location] [nchar](2) NULL,
	[DateLastChg] [datetime] NULL,
	[WhoChgLast] [nchar](8) NULL,
	[BIN] [nchar](6) NULL,
	[DateCycle] [datetime] NULL,
	[CodeBOM] [nchar](1) NULL,
	[CodeDiscount] [nchar](1) NULL,
	[CodeTotal] [nchar](1) NULL,
	[PriorUsage] [decimal](7, 0) NULL,
	[AltCostAmt] [decimal](16, 6) NULL,
	[MinMultiple] [decimal](12, 4) NULL,
	[FloorStockingLevel] [decimal](12, 4) NULL,
	[QtyOnHand] [decimal](12, 4) NULL,
	[QtyReorder] [decimal](12, 4) NULL,
	[QtyOnOrderPO] [decimal](12, 4) NULL,
	[QtyOnOrderWO] [decimal](12, 4) NULL,
	[QtyRequired] [decimal](12, 4) NULL,
	[AmtCost] [decimal](12, 4) NULL,
	[UsageJanuary] [decimal](7, 0) NULL,
	[UsageFebruary] [decimal](7, 0) NULL,
	[UsageMarch] [decimal](7, 0) NULL,
	[UsageApril] [decimal](7, 0) NULL,
	[UsageMay] [decimal](7, 0) NULL,
	[UsageJune] [decimal](7, 0) NULL,
	[UsageJuly] [decimal](7, 0) NULL,
	[UsageAugust] [decimal](7, 0) NULL,
	[UsageSeptember] [decimal](7, 0) NULL,
	[UsageOctober] [decimal](7, 0) NULL,
	[UsageNovember] [decimal](7, 0) NULL,
	[UsageDecember] [decimal](7, 0) NULL,
	[Qty_Allocated] [decimal](15, 6) NULL,
	[RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO