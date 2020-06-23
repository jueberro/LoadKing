CREATE FUNCTION [dbo].[udf_cv_nvarchar6_to_date]
(
      @datestring nvarchar(8) -- max modified on 3.24.20
)

RETURNS date

AS

BEGIN
     
      DECLARE @DatePassedtest nvarchar(11)
	  DECLARE @DatePassedback date
	 
	  Set @datestring = ISNULL(@datestring,' ')

      Set @datePassedtest =    -- create a mm-dd-yyyy formatted string from the mmddyy string and determine century to append to year

	  Case 
	     When len(ltrim(rtrim(@datestring))) = 6  and ISNUMERIC(@datestring) = 1 Then  --  make sure we have 6 characters
		  Concat(substring(@datestring,1,2),'-', substring(@datestring,3,2),'-',
		      Concat(Case 
			                 When convert(int,substring(@datestring,5,1)) > 5 then '19' else '20'
			         End,
					 substring(@datestring,5,2)
					 )
		  ) 	-- This would be first yr digit and If the year starts with a 5 it occurred in the 1900's else 2000's
	  Else   
		   '12-31-1999'  
      End
      
          --  Verify that we have a valid date in thius 6 char string
          set @datepassedback = convert(date,case when isdate(@datepassedtest) = 1 then @datepassedtest else '12-31-1999' end)

      RETURN(@DatePassedBack)

END
GO