CREATE FUNCTION [dwstage].[udf_cv_nvarchar6__yymmdd_to_date]
(
      @datestring nvarchar(6) 
)

RETURNS date

AS

BEGIN
     
      DECLARE @DatePassedtest nvarchar(11)
	  DECLARE @DatePassedback date
	 
	  Set @datestring = ISNULL(@datestring,' ')

      Set @datePassedtest =    -- create a dd-mm-yyyy formatted string from the mmddyy string and determine century to append to year

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
		   '12-31-1999'  -- not at least a 6 char string so stuff it with an error date - I will use '01-01-1899' to tell me it had
		                 -- a tring too short for our requirment in this function of a 6 char mmddyy string to test for validity 
      End
      
          --  Verify that we have a valid date in thius 6 char string
          set @datepassedback = convert(date,case when isdate(@datepassedtest) = 1 then @datepassedtest else '12-31-1999' end)

      RETURN(@DatePassedBack)

END

GO
