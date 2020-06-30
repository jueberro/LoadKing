--USE [LK-GS-EDW]
--GO

CREATE TABLE [dw].[FactPurchaseOrder](
	[DimPurchaseOrder_Key] [int] NOT NULL,
	[DimInventory_Key] [int] NOT NULL,
	[DimVendor_Key] [int] NOT NULL,
	[DimGLAccount_Key] [int] NOT NULL,
	[DimPaymentTerms_Key] [int] NOT NULL,
	[DimDate_Key] [int] NOT NULL,
	[POL_PURCHASE_ORDER] [char](7) NULL,
	[POL_RECORD_NO] [char](4) NULL,
	[POH_DATE_ORDER] [datetime] NULL,
	[POH_DATE_REQ] [datetime] NULL,
	[POH_DATE_DUE] [datetime] NULL,
	[POL_DATE_LAST_RECEIVED] [datetime] NULL,
	[POL_DATE_LAST_CHG] [datetime] NULL,
	[POH_CHANGE_DATE] [datetime] NULL,
	[POH_SHIP_DATE] [datetime] NULL,
	[POL_COST] [numeric](14, 4) NULL,
	[POL_QTY_ORDER] [numeric](14, 4) NULL,
	[POL_EXTENSION] [numeric](15, 2) NULL,
	[POL_QTY_RECEIVED] [numeric](14, 4) NULL,
	[POL_VEN_TAX] [numeric](15, 2) NULL,
	[POL_PUR_TAX] [numeric](15, 2) NULL,
	[POL_ROLL_QTY] [numeric](7, 0) NULL,
	[POL_INV_COST] [numeric](15, 6) NULL,
	[POL_SHIPPED_QTY] [numeric](14, 4) NULL,
	[POL_EXCHANGE_COST2] [numeric](15, 6) NULL,
	[POL_EXCHANGE_RATE] [numeric](10, 5) NULL,
	[POL_COST_6_DEC] [numeric](15, 6) NULL,
	[POL_EXCHANGE_EXT] [numeric](15, 2) NULL,
	[POL_VEN_TAX_PER_PIECE] [numeric](15, 6) NULL,
	[POL_QTY_ALT_ORDER] [numeric](14, 4) NULL,
	[POL_QTY_RECD_NOT_INSP] [numeric](14, 4) NULL,
	[POL_DISCOUNT] [numeric](5, 4) NULL,
	[POL_QTY_REJECT] [numeric](14, 4) NULL,
	[POL_QTY_RECV_ALT] [numeric](14, 4) NULL,
	[POL_PUR_TAX_PER_PIECE] [numeric](15, 6) NULL,
	[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO

/*
select * from [LK-GS-EDW].dwstage._v_purchaseorder -- 6182
select * from [LK-GS-EDW].dw.DimEmployee where EmployeeID
IN -- POH_USER_2 values [are these employees?]
(
'28762'
,'28671'
,'28349'
,'28224'
,'28464'
,'28452'
)
select distinct POL_PO_TYPE from [LK-GS-EDW].dwstage._v_purchaseorder -- 6182
*/