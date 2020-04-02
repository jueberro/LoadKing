/* This dimension uses "OfDay" and similar techniques to not confuse the data with reserved words.*/


CREATE TABLE [dw].[DimTime]
(
	DimTime_Key INT NOT NULL
	, TimeOfDay nchar(8) not null
	, HourOfDay nchar(2) not null
	, MilitaryHourOfDay nchar(2) not null
	, MinuteOfHour nchar(2) not null
	, SecondOfMinute nchar(2) not null
	, AmPm nchar(2) not null
	, StandardType nchar(11) not null
	, constraint pk_DimTime primary key clustered (DimTime_Key)

)
