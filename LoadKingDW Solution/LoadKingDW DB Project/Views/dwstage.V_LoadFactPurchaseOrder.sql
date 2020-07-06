--USE [LK-GS-EDW]
--GO

CREATE VIEW [dwstage].[V_LoadFactPurchaseOrder] 
AS

SELECT    
	 isnull(po.DimPurchaseOrder_Key, -1)  		as DimPurchaseOrder_Key 
	,isnull(i.DimInventory_Key, -1)				as DimInventory_Key
	,isnull(v.DimVendor_Key, -1)				as DimVendor_Key
	,isnull(gl.DimGLAccount_Key, -1)			as DimGLAccount_Key
	,-1											as DimPaymentTerms_Key
	,isnull(DateDue.DimDate_Key, -1)	        as DimDate_Key
        --Attributes
	, Stage.[POL_PURCHASE_ORDER]             
	, Stage.[POL_RECORD_NO]					 
	, Stage.[POH_DATE_ORDER]				 
	, Stage.[POH_DATE_REQ]					 
	, Stage.[POH_DATE_DUE]					 
	, Stage.[POL_DATE_LAST_RECEIVED]         
	, Stage.[POL_DATE_LAST_CHG] 
	, Stage.[POH_CHANGE_DATE]   
	, Stage.[POH_SHIP_DATE]       
		
	--Measures							 
	, Stage.[POL_COST]
	, Stage.[POL_QTY_ORDER]                  
	, Stage.[POL_EXTENSION]                  
	, Stage.[POL_QTY_RECEIVED] 				 
	, Stage.[POL_VEN_TAX]                 
	, Stage.[POL_PUR_TAX]                
	, Stage.[POL_ROLL_QTY]			   
	, Stage.[POL_INV_COST]                 
	, Stage.[POL_SHIPPED_QTY]              
	, Stage.[POL_EXCHANGE_COST2] 			   
	, Stage.[POL_EXCHANGE_RATE] 	     	   
	, Stage.[POL_COST_6_DEC] 			   
	, Stage.[POL_EXCHANGE_EXT] 			   
	, Stage.[POL_VEN_TAX_PER_PIECE]  
	, Stage.[POL_QTY_ALT_ORDER] 		   
	, Stage.[POL_QTY_RECD_NOT_INSP] 		   
	, Stage.[POL_DISCOUNT] 		   
	, Stage.[POL_QTY_REJECT]   
	, Stage.[POL_QTY_RECV_ALT] 				   
	, Stage.[POL_PUR_TAX_PER_PIECE] 		   
		
	, [Type1RecordHash]			  = HASHBYTES('SHA2_256',                                                                  
				cast(stage.[POL_PURCHASE_ORDER]     as nvarchar(7))
		    +   cast(stage.[POL_RECORD_NO]			as nvarchar(4))		
			+   cast(stage.[POH_DATE_ORDER]         as nvarchar(20))			
			+   cast(stage.[POH_DATE_REQ]           as nvarchar(20))      		
			+   cast(stage.[POH_DATE_DUE]           as nvarchar(20))
			+   cast(stage.[POL_DATE_LAST_RECEIVED] as nvarchar(20))
            +   cast(Stage.[POL_DATE_LAST_CHG]      as nvarchar(20))
			+   cast(Stage.[POH_CHANGE_DATE]        as nvarchar(20))
			+   cast(Stage.[POH_SHIP_DATE]     	    as nvarchar(20))
			+   cast(stage.[POL_COST]				as nvarchar(16))
			+   cast(stage.[POL_QTY_ORDER]          as nvarchar(16))
			+   cast(stage.[POL_EXTENSION]			as nvarchar(16))
			+   cast(stage.[POL_QTY_RECEIVED]       as nvarchar(16))
			+   cast(stage.[POL_VEN_TAX]			as nvarchar(16))
			+   cast(stage.[POL_PUR_TAX]			as nvarchar(16))
			+   cast(stage.[POL_ROLL_QTY]           as nvarchar(16))
			+   cast(stage.[POL_INV_COST]			as nvarchar(16))
			+   cast(stage.[POL_SHIPPED_QTY]        as nvarchar(16))
			+   cast(stage.[POL_EXCHANGE_COST2]		as nvarchar(16))
			+   cast(stage.[POL_EXCHANGE_RATE]		as nvarchar(16))
			+   cast(stage.[POL_COST_6_DEC]			as nvarchar(16))
			+   cast(stage.[POL_EXCHANGE_EXT]		as nvarchar(16))
			+   cast(stage.[POL_VEN_TAX_PER_PIECE]  as nvarchar(16))
			+   cast(stage.[POL_QTY_ALT_ORDER]      as nvarchar(16))
			+   cast(stage.[POL_QTY_RECD_NOT_INSP]  as nvarchar(16))
			+   cast(stage.[POL_DISCOUNT]			as nvarchar(16))
			+   cast(stage.[POL_QTY_REJECT]         as nvarchar(16))
			+   cast(stage.[POL_QTY_RECV_ALT]		as nvarchar(16))
			+   cast(stage.[POL_PUR_TAX_PER_PIECE]  as nvarchar(16))
			)
																		 
-- select count(*)
FROM	dwstage._V_PurchaseOrder as Stage
   
 LEFT OUTER JOIN dw.DimPurchaseOrder AS po
  ON	Stage.POL_PURCHASE_ORDER = po.POH_Purchase_Order
  AND	stage.POL_RECORD_NO = po.POH_RECORD_NO
  AND	po.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimInventory AS i
  ON    Stage.POL_PART = i.PartID
   AND  i.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimVendor AS v
  ON    Stage.POH_VENDOR = v.Vendor
   AND  v.DWIsCurrent = 1

  LEFT OUTER JOIN dw.DimGLAccount AS gl
  ON	Stage.POH_GL_ACCOUNT = gl.GLAccount		
   AND  gl.DWIsCurrent = 1

 LEFT OUTER JOIN dw.DimDate AS DateDue
  ON	Stage.POH_DATE_DUE = DateDue.[Date]			

 --LEFT OUTER JOIN dw.DimPaymentTerms AS pt
 -- ON	Stage.Terms = pt.PaymentTerms			
 --  AND  pt.DWIsCurrent = 1


GO





