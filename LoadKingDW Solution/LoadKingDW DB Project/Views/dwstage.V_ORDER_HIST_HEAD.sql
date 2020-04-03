﻿CREATE VIEW [dwstage].[V_Order_Hist_Head]
AS
SELECT        INVOICE, ORDER_NO, ORDER_SUFFIX, ORDER_TYPE, CUSTOMER, BUY_GROUP_CUST, FLAG_BUY_GROUP, DATE_ORDER, DATE_ORDER_DUE, DATE_PO_EXPIRE, CUSTOMER_PO, CONTRACT, 
                         NAME_CUSTOMER, ADDRESS1, ADDRESS2, ADDRESS3, ADDRESS4, ADDRESS5, CITY, STATE, ZIP, COUNTRY, FLAG_INTL, ATTENTION, CONTACT, CONTACT_PHONE, CONTACT_EMAIL, CODE_SORT, 
                         ORDER_SORT_2, USER_1, USER_2, USER_3, USER_4, USER_5, QUOTE, TERMS, FLAG_TIME_MATL, LOCATION, FLAG_ALWAYS_DISC, FLAG_SPCD, PRICE_SCHEDULE, COMPANY_CURRENCY, 
                         CATALOG_CURRENCY, ORDER_CURRENCY, DATE_EXCHANGE_FO_TC, EXCHANGE_RATE_FO_TC, DATE_EXCHANGE_FC_TO, EXCHANGE_RATE_FC_TO, DATE_EXCHANGE_FL_TO, EXCHANGE_RATE_FL_TO, 
                         DATE_EXCHANGE_FL_TC, EXCHANGE_RATE_FL_TC, DATE_SHIPPED, CUSTOMER_SHIP, NAME_CUSTOMER_SHIP, ADDRESS1_SHIP, ADDRESS2_SHIP, ADDRESS3_SHIP, ADDRESS4_SHIP, ADDRESS5_SHIP, 
                         CITY_SHIP, STATE_SHIP, ZIP_SHIP, COUNTRY_SHIP, FLAG_INTL_SHIP, ATTENTION_SHIP, FLAG_INS, FLAG_CERT_ENCL, MARK_INFO, FOB_INFO, WAYBILL, BATCH, DATE_INVOICE, COMPLEMENT_DATE_INV, 
                         FLAG_EXCL_BOM_COMP, FLAG_1_INV_ORDER, FLAG_1_INV_CUST, FLAG_1_INV_SORT, FLAG_1_INV_ITEM, FLAG_1_INV_PART, COST_MATERIAL, COST_LABOR, COST_OUTSIDE, COST_OVERHEAD, 
                         COST_OTHER, JOB, SUFFIX, PRODUCT_CODE, JOB_DESCRIPTION, FLAG_JOB_CLOSE, PART_JOB, LOCATION_JOB, QTY_JOB, FLAG_PRICE_AT_COST, CREDIT_MEMO_FLAG, INVOICE_ORIGINAL, 
                         DATE_ORIG_INVOICE, FLAG_TAX_ADJ, ORDER_SOURCE, HISTORY_SOURCE, HISTORY_VERSION, FREIGHT_ZONE, FLAG_COMPL_SHIP, PAYMENT_TYPE, PLST_FLAG, CREDIT_MEMO_TYPE, DD250_FLAG, 
                         LUMP_SUM_FLAG, LUMP_SUM_AMT, LANG_CD, CARRIER_CD, THRD_PRTY_FRT_CUST, PCK_NO, TRACKING_NO, TRACKING_FLAG, ETA_DATE, TRANS_METHOD, TERMS_DISC_DUE_DATE, TERMS_DISC_AMT, 
                         TERMS_DISC_AMT_ORDER, PROJECT, CARRIER_ACCT, IVC_UPD_SCRIPT_FLG, CARTONS, WEIGHT, TAX_APPLY_1, TAX_APPLY_2, TAX_APPLY_3, TAX_APPLY_4, TAX_APPLY_5, TAX_APPLY_6, TAX_APPLY_7, 
                         TAX_APPLY_8, TAX_APPLY_9, TAX_APPLY_10, PRO_NO, PRGBILL_ONLY_FLG, IVC_ALL_COMMENTS, SPAWNED_SHPMT_FLG, ORIG_SHPMT_SEQ, HAS_SPAWNED_FLG, SHIP_DATE_9CMP, 
                         BILL_PHONE_CNTRY, BILL_PHONE_AREA, BILL_PHONE_MAIN, ORIG_PCK_NO, PREPAY_APPLY_FLG, IVC_BATCH_COMB_SHPMT, IVC_ASSIGN_FLAG, SAR_SOURCE_FLG, BLANKET_NO, FACILITY, 
                         SRVC_TYPE, SHIPMENT_ID, SALESMAN, CONTRACT_FLG, PRICE_CATG_FLG, REPAIR_FRT_COST, SIX_DEC_TAX_FLG, TAX_ADJMT_FLG, EINVOICE_FLG, ONE_PER_BLANKET, PRICE_CLASS, AREA, BRANCH, 
                         PRIMARY_GRP, SECONDARY_GRP, SHIP_VIA, VAT_EC_FLG, VAT_CNTRY_CD, ETL_Batch, ETL_Completed
FROM           dwstage.ORDER_HIST_HEAD AS ORDER_HIST_HEAD
GO
