CREATE TABLE [dw].[DimWorkgroupHead](
	[DimWorkGroupHead_Key] [int] IDENTITY(1,1) NOT NULL,
	Work_Group				NCHAR(4) NULL,
	Descr  	            NVARCHAR(20) NULL,
	Prototype_WC            NCHAR(4) NULL,
	Type                    NCHAR(1) NULL,
	Nesting                 NCHAR(1) NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [pk_DimWorkGroupHead] PRIMARY KEY CLUSTERED 
(
	[DimWorkGroupHead_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
