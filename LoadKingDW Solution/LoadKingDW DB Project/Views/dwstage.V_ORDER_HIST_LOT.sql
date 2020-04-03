﻿CREATE VIEW [dwstage].[V_Order_Hist_Lot]
AS
SELECT        INVOICE, ORDER_NO, ORDER_SUFFIX, ORDER_LINE, KEY_SEQ, LOT, BIN, HEAT, SERIAL, QTY_SHIPPED, dwstage.udf_cv_nvarchar6_to_date(DATE_SHIPPED) AS DATE_SHIPPED, CREDIT_MEMO_FLAG, COST, 
                         HISTORY_VER, dwstage.udf_cv_nvarchar6_to_date(DATE_LAST_CHG) AS DATE_LAST_CHG, LAST_CHG_BY, LAST_CHG_PGM, JOB, SUFFIX, SPAWNED_FLAG, ORIG_SHPMT_SEQ, ORIG_SHPMT_BIN, 
                         COUNTRY_OF_ORIGIN, ALLOC_TYPE, ALLOC_TO, MATL_COST, LABOR_COST, OVHD_COST, OUTS_COST, FRGT_COST, OTH_COST, PART, LOCN, UM_LENGTH, UM_WIDTH, LENGTH, WIDTH, ETL_Batch, 
                         ETL_Completed
FROM            dwstage.ORDER_HIST_LOT AS ORDER_HIST_LOT
GO
