CREATE FUNCTION [dwstage].[udf_cv_nvarchar8_to_date]

--======================================================================================
-- Created By Pragmaticworks - Joe Ueberroth - 3/24/2020
--
-- Use:  nvarchar 8 value date fields to datetimevalue
--       assumes yyyymmdd nvarchar string being passed
--
--======================================================================================

         


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
	     When len(ltrim(rtrim(@datestring))) = 8 and ISNUMERIC(@datestring) =  1 Then  --  make sure we have 8 characters and numerics only
		 Case 
		  When substring(@datestring,1,2) = 00 Then
		      case
			    when convert(int,substring(@datestring,3,1)) > 5 then '19' else '20' + substring(@datestring,3,2)
			  end
		  else
		  substring(@datestring,1,4)
		 end
		 + '-' + substring(@datestring,5,2) + '-' 
		 + substring(@datestring,7,2)
  	
	  Else   
		   '01-01-1900'  -- not at least a 6 char string so stuff it with an error date - I will use '01-01-1900' to tell me it had
		                 -- a tring too short for our requirment in this function of a 6 char mmddyy string to test for validity 
      End
      
          --  Verify that we have a valid date in thius 6 char string
      Set @datepassedback = convert(date,case when isdate(@datepassedtest) = 1 then @datepassedtest else '01-01-1900' end)

      RETURN(@DatePassedBack)

END

GO

