CREATE TABLE [dw].[DimSalesOrder]
(
	DimSalesOrder_Key			INT IDENTITY(1,1) NOT NULL
	, OrderNumber				NVARCHAR(10) NOT NULL	--Natural Key field
	, OrderType					NVARCHAR(1) NULL
	, OrderSuffix				NVARCHAR(4) NULL
	, CustomerPO				NVARCHAR(20) NULL

	/*Hashes used for identifying changes, not required for reporting*/
	, Type1RecordHash			VARBINARY(64)				NULL	
	, Type2RecordHash			VARBINARY(64)				NULL	

	/*DW Metadata fields, not required for reporting*/
	, SourceSystemName			NVARCHAR(100)		NOT NULL
	, DWEffectiveStartDate		DATETIME2(7)		NOT NULL
	, DWEffectiveEndDate		DATETIME2(7)		NOT NULL
	, DWIsCurrent				BIT					NOT NULL

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	, LoadLogKey				INT					NOT NULL --ID of ETL process that inserted the record
	, constraint pk_DimSalesOrder primary key clustered (DimSalesOrder_Key)
)
