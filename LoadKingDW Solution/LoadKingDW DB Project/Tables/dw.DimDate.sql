CREATE TABLE [dw].[DimDate] (
    [DimDate_Key]  INT          NOT NULL,
    [Date]         DATETIME     NOT NULL,
    [Day]          TINYINT      NOT NULL,
    [DaySuffix]    NVARCHAR (4)  NOT NULL,
    [DayOfWeek]    NVARCHAR (9)  NOT NULL,
    [DOWInMonth]   TINYINT      NOT NULL,
    [DayOfYear]    INT          NOT NULL,
    [WeekOfYear]   TINYINT      NOT NULL,
    [WeekOfMonth]  TINYINT      NOT NULL,
    [Month]        TINYINT      NOT NULL,
    [MonthName]    NVARCHAR (9)  NOT NULL,
    [Quarter]      TINYINT      NOT NULL,
    [QuarterName]  NVARCHAR (6)  NOT NULL,
    [Year]         CHAR (4)     NOT NULL,
    [StandardDate] NVARCHAR (10) NULL,
    [HolidayText]  NVARCHAR (50) NULL,

    CONSTRAINT [pk_DimDate] PRIMARY KEY CLUSTERED ([DimDate_Key] ASC)
);

