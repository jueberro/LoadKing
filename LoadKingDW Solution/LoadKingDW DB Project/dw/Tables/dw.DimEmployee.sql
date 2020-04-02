CREATE TABLE [dw].[DimEmployee] (
    [DimEmployee_Key]         INT           IDENTITY (1, 1) NOT NULL,
    [EmployeeID]              CHAR (5)      NOT NULL,
    [EmployeeRecordType]      CHAR (1)      NULL,
    [EmployeeName]            VARCHAR (100) NULL,
    [EmployeeAddress]         VARCHAR (100) NULL,
    [EmployeeCity]            VARCHAR (50)  NULL,
    [EmployeeState]           CHAR (2)      NULL,
    [EmployeePostalCode]      CHAR (9)      NULL,
    [EmployeeGender]          CHAR (1)      NULL,
    [EmployeeHireDate]        DATE          NULL,
    [EmployeeTerminationDate] DATE          NULL,
    [EmployeeDepartment]      CHAR (4)      NULL,
    [ETL_Batch]               VARCHAR (1)   NOT NULL,
    [ETL_Completed]           VARCHAR (19)  NOT NULL,
    [effective_date]          DATETIME      NOT NULL,
    [End_date]                DATETIME      NULL,
    [IsEffective]             VARCHAR (1)   NOT NULL,
    CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED ([DimEmployee_Key] ASC)
);

