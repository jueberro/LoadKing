CREATE TABLE [dw].[DimPart] (
    [DimPart_Key]        INT             IDENTITY (1, 1) NOT NULL,
    [PartID]             CHAR (20)       NULL,
    [PartLocation]       CHAR (2)        NULL,
    [PartCodeAbc]        CHAR (1)        NULL,
    [PartProductLine]    CHAR (2)        NULL,
    [PartBin]            CHAR (6)        NULL,
    [PartDescription]    VARCHAR (100)   NULL,
    [PartPrice]          NUMERIC (13, 5) NULL,
    [PartObsoleteFlag]   BIT             NULL,
    [PartCodeBom]        CHAR (1)        NULL,
    [PartCodeDiscount]   CHAR (1)        NULL,
    [PartCodeTotal]      CHAR (1)        NULL,
    [PartCodeSort]       CHAR (10)       NULL,
    [PartVendorName]     VARCHAR (50)    NULL,
    [PartDescription2]   VARCHAR (100)   NULL,
    [PartDescription3]   VARCHAR (100)   NULL,
    [PartVatProductType] CHAR (5)        NULL,
    [PartTaxExemptFlag]  CHAR (1)        NULL,

	/*Hashes used for identifying changes, not required for reporting*/
	Type1RecordHash				VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash
	Type2RecordHash				VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	LoadLogKey					INT					NOT NULL, --ID of ETL process that inserted the record    CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED ([DimEmployee_Key] ASC)

    CONSTRAINT [PK_DimInventory_SK] PRIMARY KEY CLUSTERED ([DimPart_Key] ASC)
);

