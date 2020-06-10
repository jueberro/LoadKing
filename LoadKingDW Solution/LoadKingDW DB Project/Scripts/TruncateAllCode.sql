-------------------
USE [LK-GS-ODS];


--------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE dbo.CUSTOMER_MASTER;
TRUNCATE TABLE dbo.OE_Multi_Ship;
TRUNCATE TABLE dbo.DEPARTMENTS;
TRUNCATE TABLE dbo.EMPLOYEE_MSTR;
TRUNCATE TABLE dbo.GL_Master;
TRUNCATE TABLE dbo._V_Inventory;
TRUNCATE TABLE dbo._V_Invoice;
TRUNCATE TABLE dbo.PRODUCT_LINE;
TRUNCATE TABLE dbo.QUOTE_HEADER;
TRUNCATE TABLE dbo._V_Salesorder;
TRUNCATE TABLE dbo.SALESPERSONS;
TRUNCATE TABLE dbo.VENDOR_MASTER;
TRUNCATE TABLE dbo.WORKCENTERS;
TRUNCATE TABLE dbo.JOB_HEADER;
TRUNCATE TABLE dbo._V_Inventory;
TRUNCATE TABLE dbo._V_Invoice;
TRUNCATE TABLE dbo._V_JOB;
TRUNCATE TABLE dbo._V_JOB_HEADER;
TRUNCATE TABLE dbo._V_JobOperations;
TRUNCATE TABLE dbo._V_Quality;
TRUNCATE TABLE dbo._V_QualityDisp;
TRUNCATE TABLE dbo._V_SalesOrder;


--------------------
USE  [LK-GS-EDW];


--------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE dwstage.CUSTOMER_MASTER;
TRUNCATE TABLE dwstage.OE_MULTI_SHIP;
TRUNCATE TABLE dwstage.DEPARTMENTS;
TRUNCATE TABLE dwstage.EMPLOYEE_MSTR;
TRUNCATE TABLE dwstage.GL_Master;
TRUNCATE TABLE dwstage._V_Inventory;
TRUNCATE TABLE dwstage._V_Invoice;
TRUNCATE TABLE dwstage.PRODUCT_LINE;
TRUNCATE TABLE dwstage.QUOTE_HEADER;
TRUNCATE TABLE dwstage._V_SalesOrder;
TRUNCATE TABLE dwstage.SALESPERSONS;
TRUNCATE TABLE dwstage.VENDOR_MASTER;
TRUNCATE TABLE dwstage.WORKCENTERS;
TRUNCATE TABLE dwstage.JOB_HEADER;
TRUNCATE TABLE dwstage._V_Inventory;
TRUNCATE TABLE dwstage._V_Invoice;
TRUNCATE TABLE dwstage._V_JOB;
TRUNCATE TABLE dwstage._V_JOB_HEADER;
TRUNCATE TABLE dwstage._V_JobOperations;
TRUNCATE TABLE dwstage._V_Quality;
TRUNCATE TABLE dwstage._V_QualityDisp;
TRUNCATE TABLE dwstage._V_SalesOrder;


-------------------
USE [LK-GS-EDW];


-----------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE dw.DimCustomer;
TRUNCATE TABLE dw.DimCustomerShipTo;
TRUNCATE TABLE dw.DimDepartment;
TRUNCATE TABLE dw.DimEmployee;
TRUNCATE TABLE dw.DimGLAccount;
TRUNCATE TABLE dw.DimInventory;
TRUNCATE TABLE dw.DimInvoice;
TRUNCATE TABLE dw.DimProductLine;
TRUNCATE TABLE dw.DimQuote;
TRUNCATE TABLE dw.DimSalesOrder;
TRUNCATE TABLE dw.DimSalesPerson;
TRUNCATE TABLE dw.DimVendor;
TRUNCATE TABLE dw.DimWorkCenter;
TRUNCATE TABLE dw.DimWorkOrder;
TRUNCATE TABLE dw.FactInventory;
TRUNCATE TABLE dw.FactInvoice;
TRUNCATE TABLE dw.FactJobDetail;
TRUNCATE TABLE dw.FactJobHeader;
TRUNCATE TABLE dw.FactJobOperations;
TRUNCATE TABLE dw.FactQuality;
TRUNCATE TABLE dw.FactQualityDisposition;
TRUNCATE TABLE dw.FactSalesOrderLine;