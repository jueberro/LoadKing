CREATE VIEW [dwstage].[V_LoadFactAROpenItems]
AS
SELECT 
	 ISNULL(c.DimCustomer_Key,-1) as DimCustomer_Key
	,ISNULL(gl.DimGLAccount_Key, -1) as DimGLAccount_Key
	,ISNULL(di.DimDate_Key, -1) as DimDateInvoice_key
	,ISNULL(dt.DimDate_Key, -1) as [DimDateTransaction_key]
	,ISNULL(sp.DimSalesperson_Key, -1) as [DimSalesperson_Key]
    ,[CUSTOMER]
    ,[INVOICE]
    ,[BATCH_CODE]
    ,[BATCH_NUM]
    ,[BATCH_LINE]
	,CAST(dwstage.udf_cv_nvarchar6_to_date(ar.DATE_INVOICE) AS DATE) AS DATE_INVOICE
	,CAST(dwstage.udf_cv_nvarchar6_to_date(ar.DATE_TRANSACTION) AS DATE) AS DATE_TRANSACTION
    ,[AMT_TRANS_TOTAL]
    ,[GL_ACCOUNT]
    ,[AMT_INVOICE]
    ,[SALESPERSON]
    ,[REFERENCE]
    ,[TERRITORY]
    ,[STATE]
    ,[EXCHANGE_AMT]
    ,[EXCHANGE_AMT_TOT]
    ,[ORDER_NO]
    ,[ORDER_SUFFIX]
    ,[TERMS_CODE]
    ,CAST(dwstage.udf_cv_nvarchar8_to_date(DUE_DATE) AS DATE) AS DUE_DATE
	,CAST(dwstage.udf_cv_nvarchar8_to_date([DISC_DATE]) AS DATE) AS [DISC_DATE]
    ,[FRT_AMT_CO_CURR]
    ,[TAX_AMT_CO_CURR]
    ,[FRT_AMT_OE_CURR]
    ,[TAX_AMT_OE_CURR]
    ,[PCK_NO]
    ,[TAXABLE_FLG]
    ,[Type1RecordHash] =
	HASHBYTES( 'SHA2_256',
		  CAST(dwstage.udf_cv_nvarchar6_to_date(ar.DATE_INVOICE) AS NVARCHAR(20))
		+ CAST(dwstage.udf_cv_nvarchar6_to_date(ar.DATE_TRANSACTION) AS NVARCHAR(20))
		+ CAST([AMT_TRANS_TOTAL] AS NVARCHAR(16))
		+ [GL_ACCOUNT]
		+ CAST([AMT_INVOICE] AS NVARCHAR(16))
		+ [SALESPERSON]
		+ [REFERENCE]
		+ [TERRITORY]
		+ [STATE]
		+ CAST([EXCHANGE_AMT] AS NVARCHAR(16))
		+ CAST([EXCHANGE_AMT_TOT] AS NVARCHAR(16))
		+ [ORDER_NO]
        + [ORDER_SUFFIX]
		+ [TERMS_CODE]
		+ CAST(dwstage.udf_cv_nvarchar8_to_date(DUE_DATE) AS NVARCHAR(20))
		+ CAST(dwstage.udf_cv_nvarchar8_to_date(DISC_DATE) AS NVARCHAR(20))
		+ CAST([FRT_AMT_CO_CURR] AS NVARCHAR(11))
		+ CAST([TAX_AMT_CO_CURR] AS NVARCHAR(11))
		+ CAST([FRT_AMT_OE_CURR] AS NVARCHAR(11))
		+ CAST([TAX_AMT_OE_CURR] AS NVARCHAR(11))
		+ CAST([PCK_NO] AS NVARCHAR(7))
		+ CAST([TAXABLE_FLG] AS NCHAR(1))
	)
FROM dwstage.AR_OPEN_ITEMS ar
LEFT OUTER JOIN dw.DimCustomer AS c
ON c.CustomerID = ar.Customer AND c.DWIsCurrent = 1
LEFT OUTER JOIN dw.DimGLAccount AS gl
ON gl.GLAccount = ar.GL_ACCOUNT AND gl.DWIsCurrent = 1
LEFT OUTER JOIN dw.DimSalesPerson AS sp
ON sp.SalespersonID = ar.SALESPERSON AND sp.DWIsCurrent = 1
LEFT OUTER JOIN dw.DimDate AS di
ON	dwstage.udf_cv_nvarchar6_to_date(ar.DATE_INVOICE) = di.[Date]
LEFT OUTER JOIN dw.DimDate AS dt
ON	dwstage.udf_cv_nvarchar6_to_date(ar.DATE_TRANSACTION) = dt.[Date]
GO