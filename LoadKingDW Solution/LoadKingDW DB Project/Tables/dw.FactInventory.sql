CREATE TABLE [dw].[FactInventory](
	[FactInventory_Key] [int] IDENTITY(1,1) NOT NULL,
	[DimInventory_Key] [int] NOT NULL,
	
	PartID					nchar(20)			NOT NULL,
	DateLastUsage			datetime			NOT NULL,      
	DateLastAudit			datetime			NOT NULL, 		  
	Location				nchar(2)				NULL,
	DateLastChg				datetime				NULL,
	WhoChgLast				datetime				NULL,
	BIN						nchar(6)			    NULL, 
	DateCycle				nchar(1)                NULL,
	CodeBOM					nchar(1)        	  	NULL,
	CodeDiscount			nchar(1)          		NULL,
	CodeTotal				decimal(7, 0)      		NULL,
	PriorUsage				decimal(16, 6)	  		NULL,
	AltCostAmt				decimal(12, 4)      	NULL,
	MinMultiple				decimal(12, 4)          NULL,
	FloorStockingLevel		decimal(12, 4)  	  	NULL,
	QtyOnHand				decimal(12, 4)      	NULL,
	QtyReorder				decimal(12, 4)      	NULL, 
	QtyOnOrderPO			decimal(12, 4)      	NULL,  
	QtyOnOrderWO			decimal(12, 4)      	NULL,  
	QtyRequired				decimal(12, 4)      	NULL,
	AmtCost  				decimal(7,0) 	    	NULL,
	UsageJanuary			decimal(7,0) 	  		NULL,
	UsageFebruary			decimal(7,0) 	  		NULL,
	UsageMarch				decimal(7,0) 	    	NULL,
	UsageApril				decimal(7,0) 	    	NULL,
	UsageMay				decimal(7,0) 	        NULL,
	UsageJune				decimal(7,0) 	    	NULL,
	UsageJuly				decimal(7,0) 	    	NULL,
	UsageAugust				decimal(7,0) 	    	NULL,
	UsageSeptember			decimal(7,0) 	  		NULL,
	UsageOctober			decimal(7,0) 	  		NULL,
	UsageNovember			decimal(7,0) 	  		NULL,
	UsageDecember			decimal(7,0)    		NULL,
	[RecordHash]            [varbinary](64)         NULL,	
	[SourceSystemName]      [nvarchar](100)         NOT NULL,
	[DWEffectiveStartDate]  [datetime2](7)          NOT NULL,
	[DWEffectiveEndDate]    [datetime2](7)          NOT NULL,
	[DWIsCurrent]           [bit]                   NOT NULL,
	[LoadLogKey]            [int]                   NOT NULL
 CONSTRAINT [pk_Inventory] PRIMARY KEY NONCLUSTERED 
(
	[FactInventory_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
