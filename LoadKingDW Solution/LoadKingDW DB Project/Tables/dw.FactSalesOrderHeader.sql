CREATE TABLE [dw].[FactSalesOrderHeader]
(
	FactSalesOrderHeader_Key int identity(1,1) 
	, DimCustomer_Key int not null
	, Order_DimDate_Key int not null
	, Due_DimDate_Key int not null
	, DimSalesOrder int not null


	/*Hash used for identifying changes, not required for reporting*/
	,RecordHash					VARCHAR(66)			NULL

	/*DW Metadata fields, not required for reporting*/
	,SourceSystemName			NVARCHAR(100)		NOT NULL

	/*ETL Metadata fields, not required for reporting */
	,LoadLogKey					INT					NOT NULL	--ID of ETL process that inserted the record
	,constraint pk_FactSalesOrderHeader primary key nonclustered (FactSalesOrderHeader_Key)
)
