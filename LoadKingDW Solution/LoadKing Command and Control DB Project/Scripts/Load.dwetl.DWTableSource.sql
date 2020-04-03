IF NOT EXISTS(SELECT 1 FROM dwetl.DWTableSource 
			WHERE	DWTableName			= 'dw.DimEmployee'
			 AND	SourceSystemName	= 'Global Shop'
			 AND	SourceDataSetName	= 'Employee'
			)

BEGIN
	INSERT INTO dwetl.DWTableSource (DWTableName, DWTableType, SourceSystemName, SourceDataSetName, StoredProcedureName)
	VALUES ('dw.DimEmployee', 'Dimension', 'Global Shop', 'Employee', 'dw.LoadDimEmployee')

END

IF NOT EXISTS(SELECT 1 FROM dwetl.DWTableSource 
			WHERE	DWTableName			= 'dw.DimCustomer'
			 AND	SourceSystemName	= 'Global Shop'
			 AND	SourceDataSetName	= 'Customer'
			)

BEGIN
	INSERT INTO dwetl.DWTableSource (DWTableName, DWTableType, SourceSystemName, SourceDataSetName, StoredProcedureName)
	VALUES ('dw.DimCustomer', 'Dimension', 'Global Shop', 'Customer', 'dw.LoadDimCustomer')

END