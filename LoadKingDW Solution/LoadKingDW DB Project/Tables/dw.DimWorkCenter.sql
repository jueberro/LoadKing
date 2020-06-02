
--USE [LK-GS-EDW]
--GO

CREATE TABLE dw.DimWorkCenter 
(
[DimWorkCenter_Key] INT IDENTITY (1, 1) NOT NULL,
Machine CHAR(4) NOT NULL,
WorkCenterName CHAR(20) NULL,
WorkCenterDepartment CHAR(4) NOT NULL,
/*Hashes used for identifying changes, not required for reporting*/
Type1RecordHash				VARBINARY(64)				NULL,	--66 allows for "0x" + 64 characater hash
Type2RecordHash				VARBINARY(64)				NULL,	--66 allows for "0x" + 64 characater hash

/*DW Metadata fields, not required for reporting*/
SourceSystemName			NVARCHAR(100)		NOT NULL,
DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
DWIsCurrent					BIT					NOT NULL,

/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
LoadLogKey					INT					NOT NULL, --ID of ETL process that inserted the record    
CONSTRAINT [pk_DimWorkCenter] PRIMARY KEY CLUSTERED ([DimWorkCenter_Key] ASC)
)

GO

