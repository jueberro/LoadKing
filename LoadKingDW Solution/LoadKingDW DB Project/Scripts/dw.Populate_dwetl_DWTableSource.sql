INSERT INTO dwetl.DWTableSource
	(
	[DWTableName]
	, [DWTableType]
	, [SourceSystemName]
	, [SourceDataSetName]
	, [ODSTableName]
	, [StageTableName]
	, [SSISPackageName]
	, [StoredProcedureName]
	, [LoadDWTableFlag]
	)
VALUES ('DimCustomer', 'Dimension', 'Global Shop', 'Customer', 'dbo.V_Customer_Master'
		, 'dwstage.CUSTOMER_MASTER', 'DWLoadDimCustomer.dtsx', 'dw.LoadDimCustomer', 1)
GO
