CREATE PROCEDURE [dbo].[TestStoredProcedure]
	@param1 int = 0,
	@param2 int
AS
	SELECT * from Dim_Customer
	--added this to show joe how to commit
RETURN 0
