CREATE TABLE dw.FactSample
(
	/*Fact surrogate key*/
	FactSample_Key				INT IDENTITY(1, 1)	NOT NULL,

	/*Source identifier*/
	--WorkOrderNumber
	--SalesOrderNumber


	/* Foreign Key Fields */
	SampleKey					INT					NOT NULL,	--FK to DimSample

	/* Measures */
	SampleSalesAmount					DECIMAL(15, 2)	NOT NULL,
	SampleUnits						DECIMAL(15, 2)	NOT NULL,

	/*Hash used for identifying changes, not required for reporting*/
	RecordHash					VARCHAR(66)			NULL,

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting */
	--RecordCreateDate			DATETIME2(7)		NOT NULL,
 --   RecordLastUpdatedDate		DATETIME2(7)		NOT NULL,
 --   RecordCreatedByName			NVARCHAR (100)		NOT NULL,
 --   RecordLastUpdatedByName		NVARCHAR (100)		NOT NULL,
	LoadLogKey					INT					NOT NULL	--ID of ETL process that inserted the record
)

GO

ALTER TABLE dw.FactSample
ADD CONSTRAINT PK_dw_FactSample PRIMARY KEY CLUSTERED (FactSampleKey ASC)

GO

ALTER TABLE dw.FactSample
ADD CONSTRAINT [DF_dw_FactSample_LoadLogKey] DEFAULT 0 FOR [LoadLogKey]

GO


ALTER TABLE dw.FactSample
ADD CONSTRAINT DF_dw_FactSample_RecordCreateDate DEFAULT (GETUTCDATE()) FOR RecordCreateDate

GO

ALTER TABLE dw.FactSample
ADD CONSTRAINT DF_dw_FactSample_RecordLastUpdatedDate DEFAULT (GETUTCDATE()) FOR RecordLastUpdatedDate

GO

ALTER TABLE dw.FactSample
ADD CONSTRAINT DF_dw_FactSample_RecordCreatedByName DEFAULT (SUSER_SNAME()) FOR RecordCreatedByName

GO

ALTER TABLE dw.FactSample
ADD CONSTRAINT DF_dw_FactSample_RecordLastUpdatedByName DEFAULT (SUSER_SNAME()) FOR RecordLastUpdatedByName

GO

ALTER TABLE dw.FactSample
ADD CONSTRAINT [DF_dw_FactSample_DWIsCurrent] DEFAULT (1) FOR [DWIsCurrent]

GO

/* Create unique index */
CREATE UNIQUE NONCLUSTERED INDEX UK_dw_FactSample_DocumentNumber_JournalEntryLineNumber_DocTypeCode_GLDate_RecordCreateDate
ON dw.FactSample (DocumentNumber, JournalEntryLineNumber, DocumentTypeCode, GLDate, RecordCreateDate)

GO

/* Create dimension foreign keys */

ALTER TABLE dw.FactSample
ADD CONSTRAINT FK_dw_FactSample_ProjectKey FOREIGN KEY (ProjectKey)
REFERENCES dw.DimProject(ProjectKey)

GO





/* Create indexes on FK fields */
CREATE NONCLUSTERED INDEX IX_dw_FactProjectCost_ProjectKey 
ON dw.FactProjectCost (ProjectKey)

GO

CREATE NONCLUSTERED INDEX IX_dw_FactProjectCost_CustomerKey 
ON dw.FactProjectCost (CustomerKey)

GO

CREATE NONCLUSTERED INDEX IX_dw_FactProjectCost_CostCodeKey 
ON dw.FactProjectCost (CostCodeKey)

GO

CREATE NONCLUSTERED INDEX IX_dw_FactProjectCost_PersonKey 
ON dw.FactProjectCost (PersonKey)

GO

CREATE NONCLUSTERED INDEX IX_dw_FactProjectCost_GLDateKey 
ON dw.FactProjectCost (GLDateKey)
GO

CREATE NONCLUSTERED INDEX IX_dw_FactProjectCost_ProjectCostKey
ON dw.FactProjectCost (ProjectCostKey)
GO

CREATE NONCLUSTERED INDEX IX_dw_FactProjectCost_VendorKey
ON dw.FactProjectCost (VendorKey)
GO