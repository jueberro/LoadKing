﻿CREATE TABLE [dw].[FactInvoice](
	[FactSalesOrderLine_Key] [int] IDENTITY(1,1) NOT NULL,
	[DimSalesOrder_Key] [int] NOT NULL,
	[DimCustomer_Key] [int] NOT NULL,
	[OrderDateDimDate_Key] [int] NOT NULL,
	[ShipDateDimDate_Key] [int] NOT NULL,
	[DimCustomerShipTo_Key] [int] NOT NULL,
	[FactInventory_Key] [int] NOT NULL,
	[DimGLMaster_Key] [int] NOT NULL,
	[DimSalesperson_Key] [int] NOT NULL,
    

	[SalesOrderNumber] [nchar](7) NULL,   
    [SalesOrderLine] [nchar](4) NULL,	
    [OHOrderSuffix] [nchar](4) NULL,      
    [OLOrderSuffix] [nchar](4) NULL,		
    [OLInvoiceNumber] [nchar](7) NULL,	 
    [OLDateShipped] DATETIME NULL,			
    [OLDateLineInvoiced] DATETIME NULL,	
    [QtyOrdered] [decimal](13, 4) NULL,
    [QtyShipped] [decimal](13, 4) NULL,
    [QtyBO] [decimal](13, 4) NULL,
    [QtyOriginal] [decimal](13, 4) NULL,
    [Cost] [decimal](16, 6) NULL,
    [CostMaterial] [decimal](11, 2) NULL,
    [CostLabor] [decimal](11, 2) NULL,
    [CostOutside] [decimal](11, 2) NULL,
    [CostOverhead] [decimal](11, 2) NULL,
    [CostOther] [decimal](11, 2) NULL,
    [Margin] [decimal](7, 4) NULL,
    [Price] [decimal](16, 6) NULL,
    [ExtendedPrice] [decimal](16, 2) NULL,
    [TaxApply1] [nchar](1) NULL,
    [TaxApply2] [nchar](1) NULL,
    [TaxAmt1] [decimal](11, 2) NULL,
    [TaxAmt2] [decimal](11, 2) NULL,	
     
    Type1RecordHash varbinary(64)

) ON [PRIMARY]
GO
