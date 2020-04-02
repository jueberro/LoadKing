CREATE TABLE [dw].[DimCustomer] (
    [DimCustomer_Key]           INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]                NCHAR (6)      NOT NULL,
    [CustomerName]              NVARCHAR (50)  NOT NULL,
    [CustomerAddress1]          NVARCHAR (100) NULL,
    [CustomerAddress2]          NVARCHAR (100) NULL,
    [CustomerCity]              NVARCHAR (100) NULL,
    [CustomerStateOrProvince]   NVARCHAR (10)  NULL,
    [CustomerPostalCode]        NVARCHAR (50)  NULL,
    [CustomerCountry]           NVARCHAR (50)  NULL,
    [CustomerCounty]            NVARCHAR (50)  NULL,
    [CustomerInternationalFlag] BIT           NULL,
    [CustomerTerritory]         NCHAR (2)      NULL,
    [CustomerCodeArea]          NCHAR (2)      NULL,
    [CustomerCredit]            NCHAR (2)      NULL,
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

    CONSTRAINT [pk_DimCustomer] PRIMARY KEY CLUSTERED ([DimCustomer_Key] ASC)
);

