CREATE VIEW [dwstage].[V_LoadFactAPOpenItems]
AS
SELECT 
 ISNULL(v.DimVendor_Key, -1) as DimVendor_Key
,ISNULL(gl.DimGLAccount_Key, -1) as DimGLAccount_Key
,ISNULL(di.DimDate_Key, -1) as DimDateInvoice_key
,ISNULL(did.DimDate_Key, -1) as DimDateInvoiceDue_Key
,ap.VENDOR
,[INVOICE]
,[BATCH_CODE]
,[BATCH_NUM]
,[BATCH_LINE]
,CAST(dwstage.udf_cv_nvarchar6_to_date(ap.[DATE_BATCH]) AS DATE) AS [DATE_BATCH]
,[AREA]
,[GL_ACCOUNT]
,CAST(dwstage.udf_cv_nvarchar6_to_date(ap.DATE_INVOICE) AS DATE) AS DATE_INVOICE
,[AMT_INVOICE]
,CAST(dwstage.udf_cv_nvarchar6_to_date(ap.DATE_INVOICE_DUE) AS DATE) AS DATE_INVOICE_DUE
,[DISCOUNT_INVOICE]
,[PURCHASE_ORDER]
,[BUYER]
,[CHECK_NUM]
,CAST(dwstage.udf_cv_nvarchar6_to_date(ap.[DATE_CHECK]) AS DATE) AS [DATE_CHECK]
,[CHECK_CODE]
,[RECEIVER]
,[JOB]
,[SUFFIX]
,[SEQ]
,[CHECK_DESC]
,[VOUCHER]
,[PAYMENT_SEQ]
,[PO_LINE]
,[AMT_TRANSACTION]
,[FLAG_PAY_SELECT]
,[FLAG_CK_CLEARED]
,[USERID]
,[PAY_ACH]
,[INVC_TAXABLE_AMT]
,[Type1RecordHash] =
	HASHBYTES( 'SHA2_256',
				  [AREA]
				+ [GL_ACCOUNT]
				+ CAST(dwstage.udf_cv_nvarchar6_to_date(ap.DATE_INVOICE) AS NVARCHAR(20) )
				+ CAST([AMT_INVOICE] AS NVARCHAR(16))
				+ CAST(dwstage.udf_cv_nvarchar6_to_date(ap.DATE_INVOICE_DUE) AS NVARCHAR(20) )
				+ CAST([DISCOUNT_INVOICE] AS NVARCHAR(10))
				+ [PURCHASE_ORDER]
				+ [BUYER]
				+ [CHECK_NUM]
				+ CAST(dwstage.udf_cv_nvarchar6_to_date(ap.[DATE_CHECK]) AS NVARCHAR(20) )
				+ [CHECK_CODE]
				+ [RECEIVER]
				+ [JOB]
				+ [SUFFIX]
				+ [SEQ]
				+ [CHECK_DESC]
				+ [VOUCHER]
				+ [PAYMENT_SEQ]
				+ [PO_LINE]
				+ CAST([AMT_TRANSACTION] AS NVARCHAR(16))
				+ [FLAG_PAY_SELECT]
				+ [FLAG_CK_CLEARED]
				+ [USERID]
				+ [PAY_ACH]
				+ CAST([INVC_TAXABLE_AMT] AS NVARCHAR(16))
			  )
FROM dwstage.AP_OPEN_ITEMS ap
LEFT OUTER JOIN dw.DimVendor AS v
ON v.Vendor = ap.vendor AND v.DWIsCurrent = 1
LEFT OUTER JOIN dw.DimGLAccount AS gl
ON gl.GLAccount = ap.GL_ACCOUNT AND gl.DWIsCurrent = 1
LEFT OUTER JOIN dw.DimDate AS di
ON	dwstage.udf_cv_nvarchar6_to_date(ap.DATE_INVOICE)  = di.[Date]
LEFT OUTER JOIN dw.DimDate AS did
ON	dwstage.udf_cv_nvarchar6_to_date(ap.DATE_INVOICE_DUE)  = did.[Date]

GO