﻿
CREATE VIEW [dwstage].[V_LoadDimPurchaseOrder]
	AS
    SELECT  
	                [POH_PURCHASE_ORDER]   --[char](7) NULL,
				,   [POL_RECORD_NO] --[char](4) NULL,
				,   [POA_CRITICAL_SUPPL] --[char](1) NULL,
				,   [POA_APPROVED_SUPPL] --[char](1) NULL,
				,   [POH_TERMS] --[char](12) NULL,
				,   [POH_ORDER_TAX] --[char](1) NULL,
				,   [POH_FLAG_INSURANCE] --[char](1) NULL,
				,   [POH_BUYER] --[char](3) NULL,
				,   [POH_DATE_ORDER] -- 
				,	[POH_DATE_DUE] -- 
				,   [POL_DATE_DUE_LINE]
				,   [POH_SHIP_VIA] --[char](15) NULL,
				,   [POH_CODE_FOB] --[char](15) NULL,
				,   [POH_FLAG_RECV_CLOSED] --[char](1) NULL,
				,   [POH_FLAG_ACCT_CLOSE_A] --[char](1) NULL,
				,   [POH_FLAG_PRINT] --[char](1) NULL,
				,   [POH_PO_SEQ] --[char](2) NULL,
				,   [POH_USER_2] --[char](30) NULL,
				,   [POH_FLAG_CERTS_REQD] --[char](1) NULL,
				,   [POH_TEXT_FORMAT] --[char](1) NULL,
				,   [POH_PREV_SEQ] --[char](2) NULL,
				,   [POH_DIFF_DUE_DATE] --[char](1) NULL,
				,   [POH_PHYS_CHEM] --[char](1) NULL,
				,   [POH_PAY_WITH_CCARD] --[char](1) NULL,
				,   [POH_REC_TYPE] --[char](1) NULL,
				,   [POH_PART_PD] --[numeric](14, 2) NULL,
				,   [POH_SB_PAID] --[numeric](14, 2) NULL,
				,   [POH_DISCOUNT_A] --[numeric](5, 4) NULL,
				,   [POL_PO_TYPE] --[char](1) NULL,
				,   [POL_LOCATION] --[char](2) NULL,
				,   [POL_DESCRIPTION] --[char](30) NULL,
				,   [POL_PART_MFG_NO] --[char](23) NULL,
				,   [DROPSHIPPO_FLAG] --[CHAR](1) null,
				,   [POL_FILL_EXTENSION] --[numeric](1, 0) NULL,
				,   [POL_EXTENSION] --[numeric](15, 2) NULL,
				,   [POL_FILLER10] --[char](14) NULL,
				,   [POL_FILL_EXCH_EXT] --[numeric](1, 0) NULL,
				,   [POL_REQUISITION_LINE] --[numeric](3, 0) NULL,
				,   [POL_FILL_IVCOST] --[numeric](1, 0) NULL,
				,   [POL_FILL_PT] --[numeric](1, 0) NULL,
				,   [POL_FILL_VT] --[numeric](1, 0) NULL,
				,   [POL_VAT_RULE] --[numeric](3, 0) NULL,
				,   [POL_USE_PURPOSE] --[numeric](3, 0) NULL,
				,   [POL_BOOK_USE_TAX] --[bit] NULL,
				,  	[POL_FLAG_REC_TYPE] --[char](1) NULL,
				
			    ,   [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
                ,   [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
                                                                             [POH_PURCHASE_ORDER]   --[char](7) NULL,
																		 +   [POL_RECORD_NO] --[char](4) NULL,
																		 +   [POA_CRITICAL_SUPPL] --[char](1) NULL,
																		 +   [POA_APPROVED_SUPPL] --[char](1) NULL,
																		 +   [POH_TERMS] --[char](12) NULL,
																		 +   [POH_ORDER_TAX] --[char](1) NULL,
																		 +   [POH_FLAG_INSURANCE] --[char](1) NULL,
																		 +   [POH_BUYER] --[char](3) NULL,
																		 +   cast([POH_DATE_ORDER] as nvarchar(20)) --[numeric](14, 2) NULL,
																		 +   cast([POH_DATE_DUE] as nvarchar(20)) --[numeric](14, 2) NULL,
																		 +   cast([POL_DATE_DUE_LINE] as nvarchar(20)) --[numeric](14, 2) NULL,
																		 +   [POH_SHIP_VIA] --[char](15) NULL,
																		 +   [POH_CODE_FOB] --[char](15) NULL,
																		 +   [POH_FLAG_RECV_CLOSED] --[char](1) NULL,
																		 +   [POH_FLAG_ACCT_CLOSE_A] --[char](1) NULL,
																		 +   [POH_FLAG_PRINT] --[char](1) NULL,
																		 +   [POH_PO_SEQ] --[char](2) NULL,
																		 +   [POH_USER_2] --[char](30) NULL,
																		 +   [POH_FLAG_CERTS_REQD] --[char](1) NULL,
																		 +   [POH_TEXT_FORMAT] --[char](1) NULL,
																		 +   [POH_PREV_SEQ] --[char](2) NULL,
																		 +   [POH_DIFF_DUE_DATE] --[char](1) NULL,
																		 +   [POH_PHYS_CHEM] --[char](1) NULL,
																		 +   [POH_PAY_WITH_CCARD] --[char](1) NULL,
																		 +   [POH_REC_TYPE] --[char](1) NULL,
																		 +   cast([POH_PART_PD] as nvarchar(20)) --[numeric](14, 2) NULL,
																		 +	 cast([POH_SB_PAID] as nvarchar(20)) --[numeric](14, 2) NULL,
																		 +   cast([POH_DISCOUNT_A]   as nvarchar(20)) --[numeric](5, 4) NULL,
																		 +   [POL_PO_TYPE] --[char](1) NULL,
																		 +   [POL_LOCATION] --[char](2) NULL,
																		 +   [POL_DESCRIPTION] --[char](30) NULL,
																		 +   [POL_PART_MFG_NO] --[char](23) NULL,
																		 +   [DROPSHIPPO_FLAG] --[CHAR](1) null,
																		 +   cast([POL_FILL_EXTENSION] as nvarchar(20)) --[numeric](1, 0) NULL,
																		 +   cast([POL_EXTENSION] as nvarchar(20)) --[numeric](15, 2) NULL,
																		 +   [POL_FILLER10] --[char](14) NULL,
																		 +   cast([POL_FILL_EXCH_EXT] as nvarchar(20)) --[numeric](1, 0) NULL,
																		 +   cast([POL_REQUISITION_LINE] as nvarchar(20)) --[numeric](3, 0) NULL,
																		 +   cast([POL_FILL_IVCOST] as nvarchar(20))  --[numeric](1, 0) NULL,
																		 +   cast([POL_FILL_PT] as nvarchar(20)) --[numeric](1, 0) NULL,
																		 +   cast([POL_FILL_VT] as nvarchar(20)) --[numeric](1, 0) NULL,
																		 +   cast([POL_VAT_RULE] as nvarchar(20)) --[numeric](3, 0) NULL,
																		 +   cast([POL_USE_PURPOSE] as nvarchar(20)) --[numeric](3, 0) NULL,
																		 +   cast([POL_BOOK_USE_TAX] as nvarchar(10)) --[bit] NULL,
	                    												 +	 [POL_FLAG_REC_TYPE] 
																		 )
					 --[char](1) NULL,
                                                                             
                ,   [SourceSystemName]		      = CAST('Global Shop'        AS NVARCHAR(100))
		        ,   [DWEffectiveStartDate]	      = CAST(Getdate()            AS DATETIME2(7))
		        ,   [DWEffectiveEndDate]		  = '2100-01-01'
		        ,   [DWIsCurrent]				  = CAST(1					  AS BIT)
		        ,   [LoadLogKey]				  = CAST(0                    AS INT)
FROM            dwstage._V_PurchaseOrder
--Test
GO




