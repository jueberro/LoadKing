CREATE TABLE [dw].[DimOrderType]
(
	
	DimOrderType_Key int identity(1,1) not null
	, OrderTypeID nvarchar(1) not null
	, OrderTypeName nvarchar(50) null

	/*Hashes used for identifying changes, not required for reporting*/
	, Type1RecordHash				VARCHAR(66)				NULL	--66 allows for "0x" + 64 characater hash
	, Type2RecordHash				VARCHAR(66)				NULL	--66 allows for "0x" + 64 characater hash

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
	, constraint pk_DimOrderType primary key clustered (DimOrderType_Key)

)
