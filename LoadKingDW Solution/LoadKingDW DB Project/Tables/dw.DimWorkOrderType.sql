--USE [LK-GS-EDW]
--GO


CREATE TABLE dw.DimWorkOrderType
(
	[DimWorkOrderType_Key] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderType] varchar(50) NOT NULL,
	[WorkOrderTypeDescription] varchar(1000) NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [pk_DimWorkOrderType] PRIMARY KEY CLUSTERED 
([DimWorkOrderType_Key] ASC)
) 


