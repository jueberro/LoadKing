
IF NOT EXISTS(SELECT 1 FROM dwetl.DWTableSource 
			WHERE	DWTableName			= 'dw.DimCustomer'
			 AND	SourceSystemName	= 'GlobalShop'
			 AND	SourceDataSetName	= 'Customer'
			)

BEGIN
	INSERT INTO dwetl.DWTableSource (DWTableName, DWTableType, SourceSystemName, SourceDataSetName, SSISPackageName, StoredProcedureName)
	VALUES ('dw.DimCustomer', 'Dimension', 'Global Shop', 'Customer', 'DWLoadDimCustomer.dtsx', 'dw.LoadDimCustomer')

END