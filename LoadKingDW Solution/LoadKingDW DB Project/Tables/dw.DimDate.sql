CREATE TABLE [dw].[DimDate](
	[DimDate_Key] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Day] [tinyint] NOT NULL,
	[DaySuffix] [varchar](4) NOT NULL,
	[DayOfWeek] [varchar](9) NOT NULL,
	[DOWInMonth] [tinyint] NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[MonthName] [varchar](9) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[Year] [char](4) NOT NULL,
	[StandardDate] [varchar](10) NULL,
	[HolidayText] [varchar](50) NULL,
	[FiscalMonth] [int] NULL,
	[FiscalQuarter] [int] NULL,
	[FiscalQuarterName] [varchar](6) NULL,
	[FiscalYear] [char](10) NULL,
 CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED 
(
	[DimDate_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
