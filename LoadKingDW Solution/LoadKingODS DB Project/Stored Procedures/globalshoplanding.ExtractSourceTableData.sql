CREATE PROCEDURE [globalshoplanding].[ExtractSourceTableData]
			  @SourceTableName	NVARCHAR(100)
			, @TargetTableName	NVARCHAR(100)
			, @ExtracLowDate	DATETIME2(7)  
AS

BEGIN

	SELECT 1
--	FROM	@SourceTableName
--	WHERE	DATE_LAST_CHANGED >= @ExtractLowDate

END
