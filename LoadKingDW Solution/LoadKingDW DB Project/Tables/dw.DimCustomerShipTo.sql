CREATE TABLE [dw].[DimCustomerShipTo] (
    [DimCustomerShipTo_Key]           INT           IDENTITY (1, 1) NOT NULL,
    [DimCustomerKey]                  INT           NULL,
    [CustomerID]                      NCHAR (6)      NOT NULL,
    [CustomerShipToID]                NCHAR (6)      NOT NULL,
    [CustomerShipToName]              NVARCHAR (50)  NOT NULL,
    [CustomerShipToAddress1]          NVARCHAR (100) NULL,
    [CustomerShipToAddress2]          NVARCHAR (100) NULL,
    [CustomerShipToCity]              NVARCHAR (100) NULL,
    [CustomerShipToStateOrProvince]   NVARCHAR (10)  NULL,
    [CustomerShipToPostalCode]        NVARCHAR (50)  NULL,
    [CustomerShipToCountry]           NVARCHAR (50)  NULL,
    [CustomerShipToCounty]            NVARCHAR (50)  NULL,
    [CustomerShipToInternationalFlag] BIT           NULL,
    [CustomerShipToTerritory]         NCHAR (2)      NULL,

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

    CONSTRAINT [pk_DimCustomerShipTo] PRIMARY KEY CLUSTERED ([DimCustomerShipTo_Key] ASC)
);

