CREATE VIEW [dwstage].[V_LoadDimQuote]
AS
SELECT 		                                 


  qh_QUOTE_NO
, qh_RECORD_TYPE
, qh_CUSTOMER
, qh_SHIPTO
, qh_INVOICE
, qh_FILL_INVOICE
, qh_QUOTE_TYPE
, qh_QUOTE_SUFFIX
, qh_CUSTOMER_PO
, qh_MARK_INFO
, qh_CODE_FOB
, qh_TERMS
, qh_LAST_REC_NO
, qh_DATE_SHIPPED
, qh_CODE_SORT
, qh_EXPIRATION
, qh_SALESPERSON
, qh_BRANCH
, qh_SHIP_VIA
, qh_QUOTE_SORT_2
, qh_QUOTE
, qh_QUOTE_LOCATION
, qh_FLAG_SPCD
, qh_QUOTE_CURRENCY
, qh_QTE_CREATED_BY
, qh_PRIMARY_GRP
, qh_CARRIER_CD
, qh_DATE_LAST_CHG
, qh_DATE_DUE
, qh_DATE_QUOTE_CNV
, qh_DATE_DUE_CNV
, qh_QTE_CREATED_DATE
, qh_QUOTE_WON_LOSS_DATE
, qh_MUST_DLVR_BY_DATE
, ql_QUOTE_NO as ql_QUOTE_NO
, ql_RECORD_NO
, ql_RECORD_TYPE as ql_RECORD_TYPE
, ql_DESCRIPTION
, ql_FILL_CUST
, ql_SHIP_ID
, ql_FILL_INV
, ql_LINE_TYPE
, ql_UM_QUOTE
, ql_PART
, ql_QUOTE_WON
, ql_UM_INVENTORY
, ql_USER_1
, ql_USER_2
, ql_USER_3
, ql_FLAG_BILLING_PRICE
, ql_PRICE_CODE
, ql_FLAG_REQ_CREATED
, ql_FLAG_USE_MQD
, ql_GL_ACCOUNT
, ql_TAX_SOURCE
, ql_TAX_STATE
, ql_TAX_ZIP
, ql_TAX_GEO_CODE
, ql_TAX_1
, ql_TAX_2
, ql_TAX_3
, ql_TAX_APPLY_1
, ql_TAX_APPLY_2
, ql_TAX_APPLY_3
, ql_FLAG_REWORK
, ql_BIN
, ql_FLAG_COGS
, ql_FLAG_TAX_STATUS
, ql_CUSTOMER_PART
, ql_FILL_CUST_PART
, ql_FLAG_RMA
, ql_INFO_1
, ql_INFO_2
, ql_FLAG_PURCHASED
, ql_QUOTE_CURR_CD
, ql_MXD_CRTNS
, ql_MXD_PLLTS
, ql_NON_INV
, ql_PALLET_FLAG
, ql_INACTIVE
, ql_XTNL_ORD_DISC_FLG
, ql_FLAG_BOM
, ql_BOM_PARENT
, ql_PRODUCT_LINE
, ql_ADD_BY_PGM
, ql_LOTBIN_FLG
, ql_PRICE_BOM_COMP_FLG
, ql_MANUAL_TAX_FLG
, ql_FILLER133
, ql_TAX_ASGN_SRC
, ql_TAX_IMPORT_FLG
, ql_FILLER6
, ql_FLAG_ALWAYS_DISCOUNT
, ql_DATE_SHIP
, ql_DATE_QUOTE
, ql_DATE_ITEM_PROM
, ql_ITEM_PROMISE_DT
, ql_DATE_LAST_INVOICE
, ql_DATE_LAST_CHG
, ql_QTY_QUOTED
, ql_QTY_SHIPPED
, ql_QTY_BO
, ql_WEIGHT
, ql_PRICE
, ql_COST
, ql_DISCOUNT
, ql_QTY_ORIGINAL
, ql_EXTENSION
, ql_MARGIN
, ql_DISCOUNT_PRICE
, ql_PRICE_QUOTE
, ql_PRICE_DISC_ORD
, ql_EXTENSION_QUOTE
		, [Type1RecordHash]				= CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]				= HASHBYTES('SHA2_256'    , qh_QUOTE_NO                                         
																  + qh_RECORD_TYPE										
																  + qh_CUSTOMER										
																  + qh_SHIPTO											
																  + qh_INVOICE											
																  + qh_FILL_INVOICE									
																  + qh_QUOTE_TYPE										
																  + qh_QUOTE_SUFFIX									
																  + qh_CUSTOMER_PO										
																  + qh_MARK_INFO										
																  + qh_CODE_FOB										
																  + qh_TERMS											
																  + CAST(qh_LAST_REC_NO			   as nvarchar(20))			
																  + qh_DATE_SHIPPED									
																  + qh_CODE_SORT										
																  + qh_EXPIRATION										
																  + qh_SALESPERSON										
																  + qh_BRANCH											
																  + qh_SHIP_VIA										
																  + qh_QUOTE_SORT_2									
																  + qh_QUOTE											
																  + qh_QUOTE_LOCATION									
																  + qh_FLAG_SPCD										
																  + qh_QUOTE_CURRENCY									
																  + qh_QTE_CREATED_BY									
																  + qh_PRIMARY_GRP										
																  + qh_CARRIER_CD										
																  + CAST(qh_DATE_LAST_CHG			as nvarchar(26))		
																  + CAST(qh_DATE_DUE				as nvarchar(26))		
																  + CAST(qh_DATE_QUOTE_CNV			as nvarchar(26))		
																  + CAST(qh_DATE_DUE_CNV			as nvarchar(26))		
																  + CAST(qh_QTE_CREATED_DATE		as nvarchar(26))		
																  + CAST(qh_QUOTE_WON_LOSS_DATE		as nvarchar(26))		
																  + CAST(qh_MUST_DLVR_BY_DATE		as nvarchar(26))		
																  + ql_QUOTE_NO 						
																  + ql_RECORD_NO										
																  + ql_RECORD_TYPE 			
																  + ql_DESCRIPTION										
																  + ql_FILL_CUST										
																  + ql_SHIP_ID											
																  + ql_FILL_INV										
																  + ql_LINE_TYPE										
																  + ql_UM_QUOTE										
																  + ql_PART											
																  + ql_QUOTE_WON										
																  + ql_UM_INVENTORY									
																  + ql_USER_1											
																  + ql_USER_2											
																  + ql_USER_3											
																  + ql_FLAG_BILLING_PRICE								
																  + ql_PRICE_CODE										
																  + ql_FLAG_REQ_CREATED								
																  + ql_FLAG_USE_MQD									
																  + ql_GL_ACCOUNT										
																  + ql_TAX_SOURCE										
																  + ql_TAX_STATE										
																  + ql_TAX_ZIP											
																  + ql_TAX_GEO_CODE									
																  + ql_TAX_1											
																  + ql_TAX_2											
																  + ql_TAX_3											
																  + ql_TAX_APPLY_1										
																  + ql_TAX_APPLY_2										
																  + ql_TAX_APPLY_3										
																  + ql_FLAG_REWORK										
																  + ql_BIN												
																  + ql_FLAG_COGS										
																  + ql_FLAG_TAX_STATUS									
																  + ql_CUSTOMER_PART									
																  + ql_FILL_CUST_PART									
																  + ql_FLAG_RMA										
																  + ql_INFO_1											
																  + ql_INFO_2											
																  + ql_FLAG_PURCHASED									
																  + ql_QUOTE_CURR_CD									
																  + CAST(ql_MXD_CRTNS		  as nvarchar(20))				
																  + CAST(ql_MXD_PLLTS		  as nvarchar(20))				
																  + CAST(ql_NON_INV			  as nvarchar(20))				
																  + CAST(ql_PALLET_FLAG		  as nvarchar(20))				
																  + CAST(ql_INACTIVE		  as nvarchar(20))		
																  + CAST(ql_XTNL_ORD_DISC_FLG as nvarchar(20))				
																  + ql_FLAG_BOM										
																  + ql_BOM_PARENT										
																  + ql_PRODUCT_LINE									
																  + ql_ADD_BY_PGM										
																  + ql_LOTBIN_FLG										
																  + ql_PRICE_BOM_COMP_FLG								
																  + CAST(ql_MANUAL_TAX_FLG	  as nvarchar(20))				
																  + ql_FILLER133			 							
																  + CAST(ql_TAX_ASGN_SRC	  as nvarchar(20))				
																  + CAST(ql_TAX_IMPORT_FLG	  as nvarchar(20))				
																  + ql_FILLER6											
																  + ql_FLAG_ALWAYS_DISCOUNT							
																  + CAST(ql_DATE_SHIP		  as nvarchar(26))				
																  + CAST(ql_DATE_QUOTE	      as nvarchar(26))				
																  + CAST(ql_DATE_ITEM_PROM    as nvarchar(26))				
																  + CAST(ql_ITEM_PROMISE_DT	  as nvarchar(26))				
																  + CAST(ql_DATE_LAST_INVOICE as nvarchar(26))				
																  + CAST(ql_DATE_LAST_CHG	  as nvarchar(26))				
																  + CAST(ql_QTY_QUOTED	      as nvarchar(20))				
																  + CAST(ql_QTY_SHIPPED	      as nvarchar(20))				
																  + CAST(ql_QTY_BO			  as nvarchar(20))				
																  + CAST(ql_WEIGHT			  as nvarchar(20))				
																  + CAST(ql_PRICE		      as nvarchar(20))				
																  + CAST(ql_COST		      as nvarchar(20))				
																  + CAST(ql_DISCOUNT	      as nvarchar(20))				
																  + cast(ql_QTY_ORIGINAL	  as nvarchar(20)) 				
																  + CAST(ql_EXTENSION		  as nvarchar(20))				
																  + CAST(ql_MARGIN		      as nvarchar(20))				
																  + CAST(ql_DISCOUNT_PRICE    as nvarchar(20))				
																  + CAST(ql_PRICE_QUOTE	      as nvarchar(20))				
																  + CAST(ql_PRICE_DISC_ORD	  as nvarchar(20))				
																  + CAST(ql_EXTENSION_QUOTE   as nvarchar(20)))				


	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)



		FROM     [LK-GS-EDW].dwstage._V_QUOTE 


		
GO



