CREATE TABLE [dw].[DimGLMaster](
	[DimGLMaster_Key] [int] IDENTITY(1,1) NOT NULL,
	[GLAccount] [char](15) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[Dept] [char](4) NOT NULL,
	[RetainedAcct] [char](15) NOT NULL,
	[ZeroAtYrEnd] [char](1) NOT NULL,
	[User1] [char](30) NULL,
	[User2] [char](30) NULL,
	[User3] [char](30) NULL,
	[User4] [char](30) NULL,
	[User5] [char](30) NULL,
	[Type1RecordHash] [varbinary](64) NOT NULL,
	[Type2RecordHash] [varbinary](64) NOT NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [PK_DimGLMaster] PRIMARY KEY CLUSTERED 
(
	[DimGLMaster_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]