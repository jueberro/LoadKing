--USE [LK-GS-EDW]
--GO


CREATE TABLE dw.FactJobDetail
(
DimSalesOrder_Key int NOT NULL,
DimWorkOrderType_Key int NOT NULL,
DimInventory_Key int NOT NULL,
DimCustomer_Key int NOT NULL,
DimSalesPerson_Key int NOT NULL,
DimProductLine_Key int NOT NULL,
DimDate_Key int NOT NULL,
DimEmployee_Key int NOT NULL,
DimDepartmentWorkCenter_Key int NOT NULL,
DimDepartmentShift_Key int NOT NULL,
DimDepartmentEmployee_Key int NOT NULL,
DimWorkOrder_Key int NOT NULL,
[HEADER_JOB] [char](6) NULL,
[HEADER_SUFFIX] [char](3) NULL,
[HEADER_PART] [char](20) NULL,
[HEADER_PRODUCT_LINE] [char](2) NULL,
HEADER_SALESPERSON char(3) NULL,
[HEADER_CUSTOMER] [char](6) NULL,
[HEADER_SALES_ORDER] [char](7) NULL,--OK
[HEADER_SALES_ORDER_LINE] [char](3) NULL,--OK
[JOB] [char](6) NULL,--ok
[SUFFIX] [char](3) NULL,--ok
[SEQ] [char](6) NULL,--ok
[SEQUENCE_KEY] [char](4) NULL,--ok
[EMPLOYEE] [char](30) NULL,--ok
[DESCRIPTION] [char](30) NULL,--ok
[RATE_WORKCENTER] [numeric](10, 4) NULL,--ok
[MACHINE] [char](4) NULL,--ok
[PART] [char](20) NULL,--ok
[REFERENCE] [char](15) NULL,--ok
[LMO] [char](1) NULL,--ok
[RATE_TYPE] [char](1) NULL,--ok
[LOCATION] [char](2) NULL,--ok
[SHIFT_SHIFT] [char](1) NULL,--ok
[SHIFT_GROUP] [char](8) NULL,--ok
[HEADER_DATE_OPENED] datetime NULL,
[HEADER_DATE_DUE] datetime NULL,
[HEADER_DATE_CLOSED] datetime NULL,
[HEADER_DATE_START] datetime NULL,
[DATE_SEQUENCE] datetime NULL,--ok
[CHARGE_DATE] datetime NULL,--ok
[DATE_OUT] datetime NULL,--ok
[DATE_LAST_CHG] datetime NULL,--ok
[RATE_EMPLOYEE] [numeric](10, 4) NULL,--ok
[HOURS_WORKED] [numeric](12, 4) NULL,--ok
[PIECES_SCRAP] [numeric](12, 4) NULL,--ok
[PIECES_COMPLTD] [numeric](12, 4) NULL,--ok
[AMOUNT_LABOR] [numeric](10, 2) NULL,--ok
[AMT_OVERHEAD] [numeric](10, 2) NULL,--ok
[AMT_STANDARD] [numeric](10, 2) NULL,--ok
[AMT_SCRAP] [numeric](10, 2) NULL,--ok
[MACHINE_HRS] [numeric](12, 4) NULL,--ok
[MULTIPLE_FRACTION] [numeric](6, 5) NULL,--ok
[START_TIME] [char](4) NULL,--ok
[END_TIME] [char](4) NULL,--ok
FLAG_INDIRECT char(1) NULL,
[Type1RecordHash] [varbinary](64) NULL
) ON [PRIMARY]
GO

