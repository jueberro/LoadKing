CREATE TABLE [dw].[DimSample]
(
	/*Surrogate Key*/
	SampleKey					INT IDENTITY(1, 1)	NOT NULL,	--

	/*NaturalKey(s)*/
	SampleID					NVARCHAR(100)		NOT NULL,	

	/*Dimension attributes*/
	AttributeOne				NVARCHAR(100)		NOT NULL,
	AttibuteTwo					NVARCHAR(10)		NOT NULL,

	/*Hashes used for identifying changes, not required for reporting*/
	Type1RecordHash				VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash
	Type2RecordHash				VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	RecordCreateDate			DATETIME2(7)		NOT NULL,
    RecordLastUpdatedDate		DATETIME2(7)		NOT NULL,
    RecordCreatedByName			NVARCHAR (100)		NOT NULL,
    RecordLastUpdatedByName		NVARCHAR (100)		NOT NULL,
	LoadLogKey					INT					NOT NULL --ID of ETL process that inserted the record
)

GO

ALTER TABLE dw.DimSample
ADD CONSTRAINT [PK_dw_DimSample] PRIMARY KEY CLUSTERED ([SampleKey] ASC)

GO

ALTER TABLE dw.DimSample
ADD CONSTRAINT [DF_dw_DimSample_RecordCreateDate] DEFAULT (GETUTCDATE()) FOR [RecordCreateDate]

GO

ALTER TABLE dw.DimSample
ADD CONSTRAINT [DF_dw_DimSample_RecordLastUpdatedDate] DEFAULT (GETUTCDATE()) FOR [RecordLastUpdatedDate]

GO

ALTER TABLE dw.DimSample
ADD CONSTRAINT [DF_dw_DimSample_RecordCreatedByName] DEFAULT (SUSER_SNAME()) FOR [RecordCreatedByName]

GO

ALTER TABLE dw.DimSample
ADD CONSTRAINT [DF_dw_DimSample_RecordLastUpdatedByName] DEFAULT (SUSER_SNAME()) FOR [RecordLastUpdatedByName]

GO

ALTER TABLE dw.DimSample
ADD CONSTRAINT [DF_dw_DimSample_DWIsCurrent] DEFAULT 1 FOR [DWIsCurrent]

GO

/* One dimension member may appear more than once in the table, but must be unique by DWEffectiveStartDate*/
ALTER TABLE dw.DimSample
ADD CONSTRAINT [UK_dw_DimSample_SampleId_DWEffectiveStartDate] UNIQUE (SampleId, DWEffectiveStartDate)

GO

/*Add non-clustered indexes as needed*/




