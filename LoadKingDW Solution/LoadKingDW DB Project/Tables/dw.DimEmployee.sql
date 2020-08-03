--USE [LK-GS-EDW]
--GO


CREATE TABLE dw.DimEmployee
(
	[DimEmployee_Key] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [nchar](5) NOT NULL,
	[EmployeeRecordType] [nchar](1) NULL,
	[EmployeeName] [nvarchar](100) NULL,
	[EmployeeAddress] [nvarchar](100) NULL,
	[EmployeeCity] [nvarchar](50) NULL,
	[EmployeeState] [nchar](2) NULL,
	[EmployeePostalCode] [nchar](9) NULL,
	[EmployeeGender] [nchar](1) NULL,
	[EmployeeHireDate] [date] NULL,
	[EmployeeTerminationDate] [date] NULL,
	[EmployeeDepartment] [nchar](4) NULL,
	[EmployeeIsSalesperson] [bit] NULL,
	[EmployeeInitials] [nvarchar](3) NULL,
	[PAY_TYPE] char(1) NULL,
	[FREQUENCY] char(1) NULL,
	[RATE] numeric(9,3) NULL,
	[SHIFT] char(1) NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED 
(
	[DimEmployee_Key] ASC
)
) ON [PRIMARY]
GO


