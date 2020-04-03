/* Not sure how this is different from the part dimension */

CREATE TABLE [dw].[DimProduct]
(
	DimProduct_Key INT NOT NULL 

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
	, constraint pk_DimProduct primary key clustered (DimProduct_Key)
)
