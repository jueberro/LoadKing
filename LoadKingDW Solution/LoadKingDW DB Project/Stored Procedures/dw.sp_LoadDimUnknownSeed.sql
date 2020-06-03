
-- =============================================
-- Author:           Edwin Davis
-- Create date: 4/27/2020
-- Description: Creates and populates Unknowns
-- =============================================
-- exec dw.[sp_LoadDimUnknownSeed] 

CREATE PROCEDURE dw.sp_LoadDimUnknownSeed 
       

AS
BEGIN




       SET NOCOUNT ON;
-- BEGIN Dim 1  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimCustomer where DimCustomer_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimCustomer ON

		   insert into dw.DimCustomer
		   (
		   DimCustomer_Key 
		   , CustomerID, CustomerName
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk000', 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimCustomer OFF

       END

ELSE 

       BEGIN
		Print 'DimCustomer Exists'
       END 
-- END Dim 1 -----------------------------------------------------------------------------------

-- BEGIN Dim 2  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimCustomerShipTo where DimCustomerShipTo_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimCustomerShipTo ON

		   insert into dw.DimCustomerShipTo
		   (
		   DimCustomerShipTo_Key 
		   , PrimaryCustomerID, ShipToSeq, ShipToCustomername
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk000', 'Unk000', 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimCustomerShipTo OFF

       END

ELSE 

       BEGIN
		Print 'DimCustomerShipTo Exists'
       END 
-- END Dim 2 -----------------------------------------------------------------------------------
-- BEGIN Dim 3  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimEmployee where DimEmployee_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimEmployee ON

		   insert into dw.DimEmployee
		   (
		   DimEmployee_Key 
		   , EmployeeID
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk00'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimEmployee OFF

       END

ELSE 

       BEGIN
		Print 'DimEmployee Exists'
       END 
-- END Dim 3 -----------------------------------------------------------------------------------

-- BEGIN Dim 4  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimGLAccount where DimGLAccount_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimGLAccount ON

		   insert into dw.DimGLAccount
		   (
		   DimGLAccount_Key 
		   , GLAccount, Descr, Dept, RetainedAcct, ZeroAtYrEnd
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unknown', 'Unknown', 'Unk0', 'Unknown', '0'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimGLAccount OFF

       END

ELSE 

       BEGIN
		Print 'DimGLAccount Exists'
       END 
-- END Dim 4 -----------------------------------------------------------------------------------

-- BEGIN Dim 5  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimInventory where DimInventory_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimInventory ON

		   insert into dw.DimInventory
		   (
		   DimInventory_Key 
		   , PartID, PartDescription
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unknown', 'Un'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimInventory OFF

       END

ELSE 

       BEGIN
		Print 'DimInventory Exists'
       END 
-- END Dim 5 -----------------------------------------------------------------------------------

-- BEGIN Dim 6  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimQuote where DimQuote_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimQuote ON

		   insert into dw.DimQuote
		   (
		   DimQuote_Key 
		   , QuoteNumber
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimQuote OFF

       END

ELSE 

       BEGIN
		Print 'DimQuote Exists'
       END 
-- END Dim 6 -----------------------------------------------------------------------------------

-- BEGIN Dim 7  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimSalesOrder where DimSalesOrder_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimSalesOrder ON

		   insert into dw.DimSalesOrder
		   (
		   DimSalesOrder_Key 
		   , SalesOrderNumber, SalesOrderLine
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unknown', 'Unk0'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimSalesOrder OFF

       END

ELSE 

       BEGIN
		Print 'DimSalesOrder Exists'
       END 
-- END Dim 7 -----------------------------------------------------------------------------------

-- BEGIN Dim 8  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimSalesPerson where DimSalesPerson_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimSalesPerson ON

		   insert into dw.DimSalesPerson
		   (
		   DimSalesPerson_Key 
		   , SalesPersonID, [Name], Email
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk', 'Unknown', 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimSalesPerson OFF

       END

ELSE 

       BEGIN
		Print 'DimSalesPerson Exists'
       END 
-- END Dim 8 -----------------------------------------------------------------------------------
-- BEGIN Dim 9  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimProductLIne where DimProductLIne_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimProductLine ON

		   insert into dw.DimProductLine
		   (
		   DimProductLIne_Key 
		   , ProductLine, ProductLineName
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , '-1', 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimProductLine OFF

       END

ELSE 

       BEGIN
		Print 'DimProductLine Exists'
       END 
-- END Dim 9 -----------------------------------------------------------------------------------
-- BEGIN Dim 10  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimWorkOrderType where DimWorkOrderType_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimWorkOrderType ON

		   insert into dw.DimWorkOrderType
		   (
		   DimWorkOrderType_Key 
		   , WorkOrderType, WorkOrderTypeDescription
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk000', 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimWorkOrderType OFF

       END

ELSE 

       BEGIN
		Print 'DimWorkOrderType Exists'
       END 
-- END Dim 10 -----------------------------------------------------------------------------------
-- BEGIN Dim 11  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimDepartment where DimDepartment_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimDepartment ON

		   insert into dw.DimDepartment
		   (
		   DimDepartment_Key 
		   , DepartmentID, DepartmentName
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk0', 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimDepartment OFF

       END

ELSE 

       BEGIN
		Print 'DimDepartment Exists'
       END 
-- END Dim 11 -----------------------------------------------------------------------------------
-- BEGIN Dim 12  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimWorkCenter where DimWorkCenter_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimWorkCenter ON

		   insert into dw.DimWorkCenter
		   (
		   DimWorkCenter_Key 
		   , Machine, WorkCenterName, WorkCenterDepartment
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk0', 'Unknown', 'Unk0'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimWorkCenter OFF

       END

ELSE 

       BEGIN
		Print 'DimWorkCenter Exists'
       END 
-- END Dim 12 -----------------------------------------------------------------------------------
-- BEGIN Dim 13  ---------------------------------------------------------------------------------      
IF NOT Exists (Select * from dw.DimVendor where DimVendor_Key = -1)

       BEGIN

		   SET IDENTITY_INSERT dw.DimVendor ON

		   insert into dw.DimVendor
		   (
		   DimVendor_Key 
		   , Vendor, VendorName
		   , SourceSystemName 
		   , DWEffectiveStartDate, DWEffectiveEndDate
		   , DWIsCurrent
		   , LoadLogKey
		   )
		   values
		   (
		   -1
		   , 'Unk000', 'Unknown'
		   , 'Global Shop'
		   , getutcdate(), '2100-01-01'
		   , 1
		   , -1
		   )

		   SET IDENTITY_INSERT dw.DimVendor OFF

       END

ELSE 

       BEGIN
		Print 'DimVendor Exists'
       END 
-- END Dim 13 -----------------------------------------------------------------------------------


END
