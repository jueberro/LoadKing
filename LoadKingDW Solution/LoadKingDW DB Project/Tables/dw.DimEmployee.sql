CREATE TABLE [dw].[DimEmployee] (
    [DimEmployee_Key]         INT           IDENTITY (1, 1) NOT NULL,
    [EmployeeID]              NCHAR (5)      NOT NULL,
    [EmployeeRecordType]      NCHAR (1)      NULL,
    [EmployeeName]            NVARCHAR (100) NULL,
    [EmployeeAddress]         NVARCHAR (100) NULL,
    [EmployeeCity]            NVARCHAR (50)  NULL,
    [EmployeeState]           NCHAR (2)      NULL,
    [EmployeePostalCode]      NCHAR (9)      NULL,
    [EmployeeGender]          NCHAR (1)      NULL,
    [EmployeeHireDate]        DATE          NULL,
    [EmployeeTerminationDate] DATE          NULL,
    [EmployeeDepartment]      NCHAR (4)      NULL,
    EmployeeIsSalesperson     bit   null,

	/*Hashes used for identifying changes, not required for reporting*/
	Type1RecordHash				VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash
	Type2RecordHash				VARCHAR(66)				NULL,	--66 allows for "0x" + 64 characater hash

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	LoadLogKey					INT					NOT NULL, --ID of ETL process that inserted the record    
    CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED ([DimEmployee_Key] ASC)
);

