CREATE TABLE [dw].[DimDate] (
    [DimDate_Key]  INT          NOT NULL,
    [Date]         DATETIME     NOT NULL,
    [Day]          TINYINT      NOT NULL,
    [DaySuffix]    VARCHAR (4)  NOT NULL,
    [DayOfWeek]    VARCHAR (9)  NOT NULL,
    [DOWInMonth]   TINYINT      NOT NULL,
    [DayOfYear]    INT          NOT NULL,
    [WeekOfYear]   TINYINT      NOT NULL,
    [WeekOfMonth]  TINYINT      NOT NULL,
    [Month]        TINYINT      NOT NULL,
    [MonthName]    VARCHAR (9)  NOT NULL,
    [Quarter]      TINYINT      NOT NULL,
    [QuarterName]  VARCHAR (6)  NOT NULL,
    [Year]         CHAR (4)     NOT NULL,
    [StandardDate] VARCHAR (10) NULL,
    [HolidayText]  VARCHAR (50) NULL,
    CONSTRAINT [pk_DimDate] PRIMARY KEY CLUSTERED ([DimDate_Key] ASC)
);

