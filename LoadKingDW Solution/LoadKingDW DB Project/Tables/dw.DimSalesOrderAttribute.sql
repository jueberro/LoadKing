CREATE TABLE [dbo].[DimSalesOrderAttribute]
( [DimSalesOrderAttribute_Key] Int IDENTITY(1,1) NOT NULL,
  -- Order_Header

[ProjectType] [nvarchar](30) NULL,
[Branch] [nvarchar](2) NULL,
[ShipVia] [nvarchar](20) NULL,


   --SalesOrdeLine

[LineType] [char](1) NULL,	      
[FlagSOtoWO] [char](1) NULL,	
[FLAG_PURCHASED] [char](1) NULL,
[INACTIVE] bit NULL,	



	/*Hashes used for identifying changes, not required for reporting*/
	Type1RecordHash				VARBINARY(64)				NULL,
	Type2RecordHash				VARBINARY(64)				NULL,

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	LoadLogKey					INT					NOT NULL, --ID of ETL process that inserted the record    CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED ([DimEmployee_Key] ASC)

    CONSTRAINT [pk_DimSalesOrderAttribute] PRIMARY KEY CLUSTERED ([DimSalesOrderAttribute_Key] ASC)

)
