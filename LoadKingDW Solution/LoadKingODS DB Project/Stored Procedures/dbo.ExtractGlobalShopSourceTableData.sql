CREATE PROCEDURE [dbo].[ExtractGlobalShopSourceTableData]
			  @LoadLogKey		INT
			, @SourceTableName	NVARCHAR(100)
			, @TargetTableName	NVARCHAR(100)
			, @ExtracLowDate	DATETIME2(7)  
AS

BEGIN

	DECLARE @SourceRecordCount INT = 0

	/*
		This procedure was added as a stub/placeholder.  A few notes:
		* This procedure will extract data from one Global Shop table 
		   and insert it into a corresponding ODS table.
		* The SELECT will include the LoadLogKey value (i.e. Batch ID), which will be 
		   inserted into the ODS table.
		* The SELECT will also inlcude a WHERE clause to only pull records where
		   a last updated date (or similar) is greater/later than @ExtractLowDate
		* Date format needs to be determined
		* Paramaters and data types of parameters will likely change.
		* It will return a 
	*/

--	INSERT INTO <TargetTableName> 
	SELECT 1
--	FROM	@SourceTableName
--	WHERE	DATE_LAST_CHANGED >= @ExtractLowDate
	


	--Count records from INSERT/SELECT
	SELECT @SourceRecordCount = @@ROWCOUNT

	--Return one row, one field record set with SourceRecordCount
	SELECT SourceRecordCount = @SourceRecordCount

END
