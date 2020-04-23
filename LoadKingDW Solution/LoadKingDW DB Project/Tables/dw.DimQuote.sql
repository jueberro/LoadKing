CREATE TABLE [dw].[DimQuote](
	[DimQuote_Key] [int] IDENTITY(1,1) NOT NULL,
	[QuoteNumber] [nchar](7) NULL,
	[QuoteCreationDate] [datetime] NULL,
	[QuoteWonLostDate] [datetime] NULL,
	[Type1RecordHash] [varbinary](64) NULL,
	[Type2RecordHash] [varbinary](64) NULL,
	[SourceSystemName] [nvarchar](100) NOT NULL,
	[DWEffectiveStartDate] [datetime2](7) NOT NULL,
	[DWEffectiveEndDate] [datetime2](7) NOT NULL,
	[DWIsCurrent] [bit] NOT NULL,
	[LoadLogKey] [int] NOT NULL,
 CONSTRAINT [pk_DimQuote] PRIMARY KEY CLUSTERED 
(
	[DimQuote_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
