CREATE PROCEDURE [dbo].[TestStoredProcedure]
	@param1 int = 0,
	@param2 int
AS
	SELECT * from Dim_Customer
RETURN 0
