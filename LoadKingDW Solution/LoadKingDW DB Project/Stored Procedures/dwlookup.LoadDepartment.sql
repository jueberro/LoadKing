CREATE PROCEDURE [dwlookup].[LoadDepartment] @SourceLoadLogKey INT

AS

BEGIN

	/*
		- Loads lkp table with most recent version of <Departments>
		- Lkp table is persisted (not TRUNCATEd and reloaded)
		- Lkp table is used as a reference when loading <dw.DimCustomer>
	*/

	/*
		Delete records to be replaced with new staged records
	*/
	--DELETE	L
	--FROM	dwlookup.Department  AS LKP
	-- JOIN	globalshoplanding.Department AS Landing
	--  ON	LKP.DepartmentId = Landing.DepartmentID
	--   AND	Landing.LoadLogKey = @SourceLoadLogKey


	/*
		Insert new versions of Departments projects from landing table
	*/
	--INSERT INTO dwldwlookup.Department(
	--		  [id]
	--		, [name]
	--		, [display_name]
	--		, [LoadLogKey])
	--SELECT    [id]
	--		, [name]
	--		, [display_name]
	--		, @SourceLoadLogKey
	--FROM	globalshoplanding.Department
	--WHERE	LoadLogKey = @SourceLoadLogKey


	SELECT 1

END

