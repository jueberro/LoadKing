CREATE TABLE [dw].[DimQuote]
(
	[DimQuote_Key] int IDENTITY(1,1),
	[QuoteNumber] [nchar](7) NULL,
	[QuoteCreationDate] CHAR(6) NULL,
	[QuoteWonLostDate] CHAR(8) NULL,

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

    CONSTRAINT [pk_DimQuote] PRIMARY KEY CLUSTERED ([DimQuote_Key] ASC))
