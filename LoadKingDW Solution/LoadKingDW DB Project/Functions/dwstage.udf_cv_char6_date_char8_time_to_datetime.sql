CREATE FUNCTION [dwstage].[udf_cv_char6_date_char8_time_to_datetime]


--======================================================================================
-- Created By Pragmaticworks - Joe Ueberroth - 2/26/2020
--
-- Use:  convert char(6) value date fields in yymmdd and a char(8) time field 
--       to datetime.
--'Finally!!!'
--======================================================================================

         


(
      @datestring nvarchar(6), -- 6 char date field
	  @timestring nvarchar(8) -- 8 char time field of which we will only use the first 6 for hh:mm:ss
)

RETURNS datetime

AS

BEGIN
      -- Convert date string passed in to a date formatted string

      DECLARE @DatePassedtest nvarchar(11)
	  DECLARE @DatePassedback datetime
	  
	  Set @datestring = ISNULL(@datestring,' ')

      Set @datePassedtest =    -- create a mm-dd-yyyy formatted string from the yymmdd formatted string and determine century to append to year

	  Case 
	     When len(ltrim(rtrim(@datestring))) = 6  and ISNUMERIC(@datestring) = 1 Then  --  make sure we have 6 characters
		    Concat(substring(@datestring,3,2),'-', substring(@datestring,5,2),'-',
		      Concat(Case 
			                 When convert(int,substring(@datestring,1,1)) > 5 then '19' else '20'
			         End,
					 substring(@datestring,1,2)
					 )
		  ) 	-- This would be first yr digit and If the year starts with a 5 it occurred in the 1900's else 2000's
	  Else   
		   '01-01-1900'  -- not at least a 6 char string or its not numeric data, 6 char mmddyy string to test for validity  
      End

	  -- Convert time string passed in a date time formatted string

      DECLARE @Timepassedtest varchar(9)
      
	  -- DECLARE @DatePassedback date
	  
	  Set @timestring = ISNULL(@timestring,' ')

      Set @timePassedtest =    -- create a hh:mm:ss formatted string from the hhmmssmm formatted string and determine century to append to year

	  Case 
	     When len(ltrim(rtrim(@timestring))) = 8  and ISNUMERIC(@timestring) = 1 Then  --  make sure we have 6 characters
		  Concat(substring(@timestring,1,2),':', substring(@timestring,3,2),':', substring(@timestring,5,2))
		 	-- Only use first 6.. doont need milliseconds
	     Else   
		   ' 00:00:00'  -- not at least a 6 char string or its not numeric data, 6 char mmddyy string to test for validity  
      End

      --  Verify that we have a valid date else default to '1900-01-01 00:00:00'
     -- set    @datepassedback = convert(datetime,case when isdate(@datepassedtest) = 1 then @datepassedtest + ' ' + @TimePassedtest else '01-01-1900 ' + @Timepassedtest end,120)
	 set    @datepassedback = convert(datetime,case when isdate(@datepassedtest) = 1 then @datepassedtest + ' ' + @TimePassedtest else '01-01-1900 ' + @Timepassedtest end ,120)
  
     RETURN(@DatePassedBack)

END


