CREATE TABLE [dw].[DimGLMaster](
	[DimGLMaster_Key] [int] IDENTITY(1,1) NOT NULL,
	[GL_ACCOUNT] [char](15) NULL,
	[DESCR] [char](30) NULL,
	[DEPT] [char](4) NULL,
	[RETAINED_ACCT] [char](15) NULL,
	[ZERO_AT_YR_END] [char](1) NULL,
	[USER_1] [char](30) NULL,
	[USER_2] [char](30) NULL,
	[USER_3] [char](30) NULL,
	[USER_4] [char](30) NULL,
	[USER_5] [char](30) NULL,
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