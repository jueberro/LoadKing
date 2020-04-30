CREATE TABLE [dw].[DimInventory] ( 
    [DimInventory_Key]     INT              IDENTITY (1, 1) NOT NULL,
    PartID                 nchar(20)        NULL,
    DateLastChg		 	   datetime         NULL,
    WhoChgLast		 	   nchar(6)         NULL,
    Price	               decimal(13, 5)   NULL,
    CodeABC	         	   nchar(1)	        NULL,
    ProductLine	     	   nchar(2)         NULL,
    PartDescription	 	   nvarchar(100)    NULL,
    UM	             	   nchar(3)         NULL,
    Obsolete           	   nchar(1)         NULL,
    CodeSort           	   nchar(10)        NULL,
    MaterialLeadTime	   decimal(4, 0)    NULL,
    SerializeFlag		   nchar(1)	        NULL,
    SourceCode		 	   nchar(12) 	    NULL,
    PrimaryVendor	   	   nchar(20) 	    NULL,
    PriceGroupID	       nchar(20)        NULL,
    SOGroupID		   	   nchar(20) 	    NULL,
    AltDescription1	 	   nchar(30) 	    NULL,
    AltDescription2	 	   nchar(30) 	    NULL,
    RequiresInspection 	   nchar(1) 	    NULL,
    ShelfLife		       nchar(1)         NULL,
    VatProductType	 	   nchar(5)         NULL,
    TaxExemptFlag	       nchar(1) 	    NULL,

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

    CONSTRAINT [PK_DimInventory_SK] PRIMARY KEY CLUSTERED ([DimInventory_Key] ASC)
);

