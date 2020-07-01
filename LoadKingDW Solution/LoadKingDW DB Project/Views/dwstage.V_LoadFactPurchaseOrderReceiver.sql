--USE [LK-GS-EDW]
--GO

CREATE VIEW dwstage.V_LoadFactPurchaseOrderReceiver 
AS

SELECT    
	isnull(po.DimPurchaseOrder_Key, -1)			as DimPurchaseOrder_Key 
	,isnull(i.DimInventory_Key, -1)				as DimInventory_Key
	,isnull(v.DimVendor_Key, -1)				as DimVendor_Key
	,isnull(gl.DimGLAccount_Key, -1)			as DimGLAccount_Key
	,isnull(d.DimDate_Key, -1)					as DimDate_Key
        --Attributes
	, stage.[RECEIVER_NO]
	, stage.[PURCHASE_ORDER]
	, stage.[PO_LINE]
	, stage.[PART]
	, stage.[GL_ACCOUNT]
	, stage.[JOB]
	, stage.[SUFFIX]
	, stage.[SEQUENCE]
	, stage.[VENDOR]
	, stage.[DESCRIPTION]
	, stage.[FLAG_OPN_ITM_POST]
	, stage.[PAY_WITH_CCARD]
	, stage.[TAXABLE]
	, stage.[BOOK_USE_TAX]
	, stage.[VAT_RULE]
	, stage.[USE_PURPOSE]
	, dwstage.udf_cv_nvarchar8_to_date(DATE_RECEIVED)		[DATE_RECEIVED]
	, dwstage.udf_cv_nvarchar6__yymmdd_to_date(DATE_TRANSACTION)	[DATE_TRANSACTION]
	, stage.[TIME_TRANSACTION]
	, dwstage.udf_cv_nvarchar8_to_date(DATE_EXCHANGE)		[DATE_EXCHANGE]
	, dwstage.udf_cv_nvarchar8_to_date(DATE_LAST_CHG)		[DATE_LAST_CHG]
	, stage.[EXTENDED_COST]
	, stage.[QTY_RECEIVED]
	, stage.[QTY_INVOICED]
	, stage.[COST_INVOICED]
	, stage.[EXTENDED_STD_COST]
	, stage.[EXCHANGE_RATE]
	, stage.[EXCH_EXT_COST]
	, stage.[EXCH_COST_INV]
	, stage.[EXCH_EXT_STD_COST]
	, [Type1RecordHash]			  = HASHBYTES('SHA2_256',                                                                  
				cast(stage.[RECEIVER_NO]			as nvarchar(6))
		    +   cast(stage.[PURCHASE_ORDER]			as nvarchar(7))		
			+   cast(stage.[PO_LINE]				as nvarchar(3))			
			+   cast(stage.[PART]					as nvarchar(20))      		
			+   cast(stage.[GL_ACCOUNT]				as nvarchar(15))
			+   cast(stage.[JOB]					as nvarchar(7))
			+   cast(stage.[SUFFIX]					as nvarchar(4))
			+   cast(stage.[SEQUENCE]				as nvarchar(6))
			+   cast(stage.[VENDOR]					as nvarchar(6))
			+   cast(stage.[DESCRIPTION]			as nvarchar(30))
			+   cast(stage.[FLAG_OPN_ITM_POST]		as nvarchar(1))
			+   cast(stage.[PAY_WITH_CCARD]			as nvarchar(1))
			+   cast(stage.[TAXABLE]				as nvarchar(1))
			+   cast(stage.[BOOK_USE_TAX]			as nvarchar(1))
			+   cast(stage.[VAT_RULE]				as nvarchar(16))
			+   cast(stage.[USE_PURPOSE]			as nvarchar(16))
			+   cast(stage.[DATE_RECEIVED]			as nvarchar(20))
			+   cast(stage.[DATE_TRANSACTION]		as nvarchar(20))
			+   cast(stage.[TIME_TRANSACTION]		as nvarchar(20))
			+   cast(stage.[DATE_EXCHANGE]			as nvarchar(20))
			+   cast(stage.[DATE_LAST_CHG]			as nvarchar(20))
			+   cast(stage.[EXTENDED_COST]			as nvarchar(16))
			+   cast(stage.[QTY_RECEIVED]			as nvarchar(16))
			+   cast(stage.[QTY_INVOICED]			as nvarchar(16))
			+   cast(stage.[COST_INVOICED]			as nvarchar(16))
			+   cast(stage.[EXTENDED_STD_COST]		as nvarchar(16))
			+   cast(stage.[EXCHANGE_RATE]			as nvarchar(16))
			+   cast(stage.[EXCH_EXT_COST]			as nvarchar(16))
			+   cast(stage.[EXCH_COST_INV]			as nvarchar(16))
			+   cast(stage.[EXCH_EXT_STD_COST]		as nvarchar(16))
			)
																		 
-- select count(*)
FROM	dwstage.PO_RECEIVER as Stage -- 
   
 LEFT OUTER JOIN dw.DimPurchaseOrder AS po
  ON	Stage.Purchase_Order = po.POH_PURCHASE_ORDER
  AND	stage.PO_Line = po.POH_RECORD_NO 
  AND	po.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimInventory AS i
  ON    Stage.PART = i.PartID
   AND  i.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimVendor AS v
  ON    Stage.VENDOR = v.Vendor
   AND  v.DWIsCurrent = 1

  LEFT OUTER JOIN dw.DimGLAccount AS gl
  ON	Stage.GL_ACCOUNT = gl.GLAccount		
   AND  gl.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS d
  ON	Stage.DATE_RECEIVED = d.[Date]			



GO


