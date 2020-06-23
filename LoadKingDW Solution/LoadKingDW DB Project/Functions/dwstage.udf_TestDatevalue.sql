CREATE FUNCTION [dwstage].[udf_testdatevalue]


--======================================================================================
-- Created By Pragmaticworks - Joe Ueberroth - 5/8/2020
--
-- Use:  Some date formatted pervasive fields have bad dates stuffed into them?   
--       When I tried saving into a datetime field the conversion to datetime failed     
--       because SQL Server didnt like the date. because it was 0542-66-77.  How
--       Pervasive allowed that I have no idea, but it doesnt matter.  This is a simple 
--       ISDATE test of a date field that returns 1899-01-01 when it sees a junk date.
--======================================================================================
    


(
      @datestring nvarchar(26) -- take in the date as a charstring, and pass it back as datetime
	  
)

RETURNS datetime

AS

BEGIN
      -- Convert date string passed in to a date formatted string

    
	  DECLARE @DatePassedback datetime
	  
	  Set     @datestring = ISNULL(@datestring,' ')

	  Set     @datepassedback = convert(datetime,case when isdate(@datestring) = 1 then @datestring else '12-31-1999'  end ,120)
	
       RETURN(@DatePassedBack)

END