--USE [LK-GS-EDW]
--GO

CREATE VIEW dwstage.V_LoadFactInventoryMovement 
AS

SELECT
isnull(i.DimInventory_Key, -1)				as DimInventory_Key
,isnull(gl.DimGLAccount_Key, -1)			as DimGLAccount_Key
,isnull(pl.DimProductLine_Key, -1)				as DimProductLine_Key
,isnull(wo.DimWorkOrder_key, -1)			as DimWorkOrder_Key
,isnull(v.DimVendor_Key, -1)				as DimVendor_Key
,isnull(d.DimDate_Key, -1)					as DimDate_Key

, stage.[PART]
, stage.[GL_ACCOUNT]
, stage.[PRODUCT_LINE]
, stage.[JOB]
, stage.[SUFFIX]
, stage.[SEQ]
, stage.[VENDOR_NO]
, stage.[VENDOR_NAME]
, stage.[DATE_ACCT_YR]
, stage.[DATE_ACCT_MO]
, stage.[LOCATION]
, stage.[CODE_TRANSACTION]
, stage.[TRANSACTION_DESC]
, stage.[REFER_2]
, stage.[BIN]
, stage.[JCM_CLOSED]
, stage.[DEBIT_PROD_LN]
, stage.[A50_CUSTOMER]
, stage.[A50_SHIPTO]
, stage.[PROGRAM_A]
, stage.[IGNORE_FOR_USAGE]
, stage.[USERID]
, stage.[FG_CLOSE]
, stage.[RECEIVER]
, stage.[COST_NOT_UPD]
, stage.[DTL_KEY_SEQ]
, stage.[T10_FRGT]
, stage.[T10_FRGT_ACCT]
, stage.[FILLER]

, dwstage.udf_cv_nvarchar6__yymmdd_to_date(DATE_HISTORY)	[DATE_HISTORY]
, stage.[INV_HIST_TIME]
, dwstage.udf_cv_nvarchar6_to_date(DATE_ACTION)				[DATE_ACTION]

, stage.[QUANTITY]
, stage.[COST]
, stage.[NEW_ONHAND]
, stage.[OLD_ONHAND]
, stage.[OLD_INV_COST]
, stage.[NEW_INV_COST]
, stage.[COST_MATERIAL]
, stage.[COST_LABOR]
, stage.[COST_OVERHEAD]
, stage.[OUTS_COST]
, stage.[FREIGHT_COST]
, stage.[OTHER_COST]
, stage.[MATL_VAR]
, stage.[LABR_VAR]
, stage.[OVHD_VAR]
, stage.[OUTS_VAR]
, stage.[FRGT_VAR]
, stage.[OTH_VAR]
, stage.[OLD_MATL]
, stage.[OLD_LABR]
, stage.[OLD_OVHD]
, stage.[OLD_OUTS]
, stage.[OLD_FRGT]
, stage.[OLD_OTH]
, stage.[NEW_MATL]
, stage.[NEW_LABR]
, stage.[NEW_OVHD]
, stage.[NEW_OUTS]
, stage.[NEW_FRGT]
, stage.[NEW_OTH]

, [Type1RecordHash]			  = HASHBYTES('SHA2_256',                                                                  
				cast(stage.[PART]					as nvarchar(20))
		    +   cast(stage.[GL_ACCOUNT]				as nvarchar(15))		
			+   cast(stage.[PRODUCT_LINE]			as nvarchar(2))			
			+   cast(stage.[JOB]					as nvarchar(6))      		
			+   cast(stage.[SUFFIX]					as nvarchar(3))
			+   cast(stage.[SEQ]					as nvarchar(6))
			+   cast(stage.[VENDOR_NO]				as nvarchar(6))
			+   cast(stage.[VENDOR_NAME]			as nvarchar(30))

			+   cast(stage.[DATE_ACCT_YR]			as nvarchar(2))
			+   cast(stage.[DATE_ACCT_MO]			as nvarchar(2))
			+   cast(stage.[LOCATION]				as nvarchar(2))
			+   cast(stage.[CODE_TRANSACTION]		as nvarchar(3))
			+   cast(stage.[TRANSACTION_DESC]		as nvarchar(15))
			+   cast(stage.[REFER_2]				as nvarchar(15))
			+   cast(stage.[BIN]					as nvarchar(6))
			+   cast(stage.[JCM_CLOSED]				as nvarchar(1))
			+   cast(stage.[DEBIT_PROD_LN]			as nvarchar(2))
			+   cast(stage.[A50_CUSTOMER]			as nvarchar(6))
			+   cast(stage.[A50_SHIPTO]				as nvarchar(6))
			+   cast(stage.[PROGRAM_A]				as nvarchar(8))
			+   cast(stage.[IGNORE_FOR_USAGE]		as nvarchar(1))
			+   cast(stage.[USERID]					as nvarchar(8))
			+   cast(stage.[FG_CLOSE]				as nvarchar(1))
			+   cast(stage.[RECEIVER]				as nvarchar(6))
			+   cast(stage.[COST_NOT_UPD]			as nvarchar(1))
			+   cast(stage.[DTL_KEY_SEQ]			as nvarchar(16))
			+   cast(stage.[T10_FRGT]				as nvarchar(16))
			+   cast(stage.[T10_FRGT_ACCT]			as nvarchar(15))
			+   cast(stage.[FILLER]					as nvarchar(37))

			+	cast(stage.[DATE_HISTORY]			as nvarchar(20))
		    +   cast(stage.[INV_HIST_TIME]			as nvarchar(20))		
			+   cast(stage.[DATE_ACTION]			as nvarchar(20))		
			
			+   cast(stage.[QUANTITY]				as nvarchar(16))
			+   cast(stage.[COST]					as nvarchar(16))
			+   cast(stage.[NEW_ONHAND]				as nvarchar(16))
			+   cast(stage.[OLD_ONHAND]				as nvarchar(16))
			+   cast(stage.[OLD_INV_COST]			as nvarchar(16))
			+   cast(stage.[NEW_INV_COST]			as nvarchar(16))
			+   cast(stage.[COST_MATERIAL]			as nvarchar(16))
			+   cast(stage.[COST_LABOR]				as nvarchar(16))
			+   cast(stage.[COST_OVERHEAD]			as nvarchar(16))
			+   cast(stage.[OUTS_COST]				as nvarchar(16))
			+   cast(stage.[FREIGHT_COST]			as nvarchar(16))
			+   cast(stage.[OTHER_COST]				as nvarchar(16))
			+   cast(stage.[MATL_VAR]				as nvarchar(16))
			+   cast(stage.[LABR_VAR]				as nvarchar(16))
			+   cast(stage.[OVHD_VAR]				as nvarchar(16))
			+   cast(stage.[OUTS_VAR]				as nvarchar(16))
			+   cast(stage.[FRGT_VAR]				as nvarchar(16))
			+   cast(stage.[OTH_VAR]				as nvarchar(16))
			+   cast(stage.[OLD_MATL]				as nvarchar(16))
			+   cast(stage.[OLD_LABR]				as nvarchar(16))
			+   cast(stage.[OLD_OVHD]				as nvarchar(16))
			+   cast(stage.[OLD_OUTS]				as nvarchar(16))
			+   cast(stage.[OLD_FRGT]				as nvarchar(16))
			+   cast(stage.[OLD_OTH]				as nvarchar(16))
			+   cast(stage.[NEW_MATL]				as nvarchar(16))
			+   cast(stage.[NEW_LABR]				as nvarchar(16))
			+   cast(stage.[NEW_OVHD]				as nvarchar(16))
			+   cast(stage.[NEW_OUTS]				as nvarchar(16))
			+   cast(stage.[NEW_FRGT]				as nvarchar(16))
			+   cast(stage.[NEW_OTH]				as nvarchar(16))
			)
																		 
-- select count(*)
FROM	dwstage.INVENTORY_HIST as Stage 
 LEFT OUTER JOIN dw.DimInventory AS i
  ON    Stage.PART = i.PartID
   AND  i.DWIsCurrent = 1

  LEFT OUTER JOIN dw.DimGLAccount AS gl
  ON	Stage.GL_ACCOUNT = gl.GLAccount		
   AND  gl.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimProductLine AS pl
  ON	Stage.Product_Line = pl.ProductLine
  AND	pl.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimWorkOrder AS wo
  ON	Stage.Job = wo.WorkOrderNumber
  AND	stage.SUFFIX = wo.SUFFIX 
  AND	wo.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimVendor AS v
  ON    Stage.VENDOR_NO = v.Vendor
   AND  v.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS d
  ON	dwstage.udf_cv_nvarchar6_to_date(DATE_ACTION) = d.[Date]			





