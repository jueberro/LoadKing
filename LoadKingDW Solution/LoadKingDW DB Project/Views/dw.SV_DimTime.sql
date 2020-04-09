Create View
[dw].[SV_DimTime]
As
SELECT [DimTime_Key]
      ,[TimeOfDay]
      ,[HourOfDay]
      ,[MilitaryHourOfDay]
      ,[MinuteOfHour]
      ,[SecondOfMinute]
      ,[AmPm]
      ,[StandardType]
  FROM [dw].[DimTime]
GO
