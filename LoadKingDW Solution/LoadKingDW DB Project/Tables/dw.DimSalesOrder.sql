CREATE TABLE [dw].[DimSalesOrder]
(
	DimSalesOrder_Key int identity(1,1) not null
	, DimCustomer_Key int not null
	, DimEmployee_Key int not null
	, OrderNumber NCHAR(7) not null
	, InvoiceNumber nvarchar(10) not null
	, OrderDate date null
	, DueDate date null
	, OrderType nvarchar(1) null
	, OrderSuffix nvarchar(4) null
	, CustomerPO nvarchar(20) null
	, FillCustomerPO nvarchar(20) null
	, MarkInfo nvarchar(30) null
	, CodeFOB nvarchar(14) null
	, Terms nvarchar(10) null
	, WayBill nvarchar(19) null
	


	/*Hashes used for identifying changes, not required for reporting*/
	, Type1RecordHash				VARBINARY(64)				NULL	
	, Type2RecordHash				VARBINARY(64)				NULL	

	/*DW Metadata fields, not required for reporting*/
	, SourceSystemName			NVARCHAR(100)		NOT NULL
	, DWEffectiveStartDate		DATETIME2(7)		NOT NULL
	, DWEffectiveEndDate			DATETIME2(7)		NOT NULL
	, DWIsCurrent					BIT					NOT NULL

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example 
	 Commented fields not required for this project due to use of ETL control table*/
	--RecordCreateDate			DATETIME2(7)		NOT NULL,
 --   RecordLastUpdatedDate		DATETIME2(7)		NOT NULL,
 --   RecordCreatedByName			NVARCHAR (100)		NOT NULL,
 --   RecordLastUpdatedByName		NVARCHAR (100)		NOT NULL,
	, LoadLogKey					INT					NOT NULL --ID of ETL process that inserted the record
	, constraint pk_DimSalesOrder primary key clustered (DimSalesOrder_Key)
)
