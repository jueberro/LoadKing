﻿CREATE TABLE [dwstage].[EMPLOYEE_MSTR](
	[EMPLOYEE] [char](5) NULL,
	[RECORD_TYPE] [char](1) NULL,
	[NAME] [char](30) NULL,
	[ADDRESS] [char](30) NULL,
	[CITY] [char](24) NULL,
	[STATE] [char](2) NULL,
	[ZIP_CODE] [char](9) NULL,
	[PHONE] [numeric](10, 0) NULL,
	[SOCIAL_SECURITY_NO] [char](9) NULL,
	[BIRTHDATE] [char](6) NULL,
	[SEX] [char](1) NULL,
	[COMMENTS_1] [char](40) NULL,
	[COMMENTS_2] [char](30) NULL,
	[COMMENTS_3] [char](20) NULL,
	[DATE_HIRE] [char](6) NULL,
	[DATE_TERMINATION] [char](6) NULL,
	[DATE_RAISE] [char](6) NULL,
	[RATE_PREVIOUS] [numeric](9, 3) NULL,
	[DEPT_EMPLOYEE] [char](4) NULL,
	[WORKMAN_COMP] [numeric](4, 0) NULL,
	[PAY_TYPE] [char](1) NULL,
	[FREQUENCY] [char](1) NULL,
	[RATE] [numeric](9, 3) NULL,
	[SHIFT] [char](1) NULL,
	[DIFFERENTIAL] [numeric](4, 2) NULL,
	[MARITAL_STATUS] [char](1) NULL,
	[FILLER10] [char](10) NULL,
	[STATE_CODE] [char](2) NULL,
	[FILLER8] [char](8) NULL,
	[SUI] [char](2) NULL,
	[CODE_LOCAL_1] [char](3) NULL,
	[CODE_LOCAL_2] [char](3) NULL,
	[DEDUCT_1] [numeric](8, 2) NULL,
	[DEDUCT_2] [numeric](8, 2) NULL,
	[DEDUCT_3] [numeric](8, 2) NULL,
	[DEDUCT_4] [numeric](8, 2) NULL,
	[DEDUCT_5] [numeric](8, 2) NULL,
	[DEDUCT_6] [numeric](8, 2) NULL,
	[DEDUCT_7] [numeric](8, 2) NULL,
	[BALANCE_7] [numeric](8, 2) NULL,
	[DEDUCT_8] [numeric](8, 2) NULL,
	[BALANCE_8] [numeric](8, 2) NULL,
	[DEDUCT_9] [numeric](8, 2) NULL,
	[BALANCE_9] [numeric](8, 2) NULL,
	[DEDUCT_10] [numeric](8, 2) NULL,
	[BALANCE_10] [numeric](8, 2) NULL,
	[IRA_PERCENT] [numeric](5, 4) NULL,
	[DEDUCT_11] [numeric](8, 2) NULL,
	[BALANCE_11] [numeric](8, 2) NULL,
	[DEDUCT_12] [numeric](8, 2) NULL,
	[BALANCE_12] [numeric](8, 2) NULL,
	[DEDUCT_13] [numeric](8, 2) NULL,
	[BALANCE_13] [numeric](8, 2) NULL,
	[DEDUCT_14] [numeric](8, 2) NULL,
	[BALANCE_14] [numeric](8, 2) NULL,
	[DEDUCT_15] [numeric](8, 2) NULL,
	[BALANCE_15] [numeric](8, 2) NULL,
	[DEDUCT_16] [numeric](8, 2) NULL,
	[BALANCE_16] [numeric](8, 2) NULL,
	[DEDUCT_17] [numeric](8, 2) NULL,
	[BALANCE_17] [numeric](8, 2) NULL,
	[DEDUCT_18] [numeric](8, 2) NULL,
	[BALANCE_18] [numeric](8, 2) NULL,
	[DEDUCT_19] [numeric](8, 2) NULL,
	[BALANCE_19] [numeric](8, 2) NULL,
	[DEDUCT_20] [numeric](8, 2) NULL,
	[BALANCE_20] [numeric](8, 2) NULL,
	[DEDUCT_21] [numeric](7, 4) NULL,
	[DEDUCT_22] [numeric](7, 4) NULL,
	[PRE_TAX_DED_1] [numeric](8, 2) NULL,
	[PRE_TAX_DED_2] [numeric](8, 2) NULL,
	[PRE_TAX_DED_3] [numeric](8, 2) NULL,
	[PRE_TAX_DED_4] [numeric](8, 2) NULL,
	[PRE_TAX_DED_5] [numeric](8, 2) NULL,
	[PRE_TAX_DED_6] [numeric](8, 2) NULL,
	[PRE_TAX_DED_7] [numeric](8, 2) NULL,
	[PRE_TAX_DED_8] [numeric](8, 2) NULL,
	[PRE_TAX_DED_9] [numeric](8, 2) NULL,
	[PRE_TAX_DED_10] [numeric](8, 2) NULL,
	[GARN_1] [numeric](8, 2) NULL,
	[GARN_2] [numeric](8, 2) NULL,
	[GARN_3] [numeric](8, 2) NULL,
	[GARN_4] [numeric](8, 2) NULL,
	[GARN_5] [numeric](8, 2) NULL,
	[GARN_BAL_1] [numeric](8, 2) NULL,
	[GARN_BAL_2] [numeric](8, 2) NULL,
	[GARN_BAL_3] [numeric](8, 2) NULL,
	[GARN_BAL_4] [numeric](8, 2) NULL,
	[GARN_BAL_5] [numeric](8, 2) NULL,
	[EMPLR_HC_1] [numeric](8, 2) NULL,
	[EMPLR_HC_2] [numeric](8, 2) NULL,
	[EMPLR_HC_3] [numeric](8, 2) NULL,
	[EMPLR_HC_4] [numeric](8, 2) NULL,
	[EMPLR_HC_5] [numeric](8, 2) NULL,
	[EMPLR_HC_6] [numeric](8, 2) NULL,
	[EMPLR_HC_7] [numeric](8, 2) NULL,
	[EMPLR_HC_8] [numeric](8, 2) NULL,
	[EMPLR_HC_9] [numeric](8, 2) NULL,
	[EMPLR_HC_10] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_1] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_2] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_3] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_4] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_5] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_6] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_7] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_8] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_9] [numeric](8, 2) NULL,
	[EMPLR_HC_ADL_10] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_1] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_2] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_3] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_4] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_5] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_6] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_7] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_8] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_9] [numeric](8, 2) NULL,
	[EMPLR_HC_PT_10] [numeric](8, 2) NULL,
	[FILLER485] [char](485) NULL,
	[SOC_SEC_ENC] [char](20) NULL,
	[SOC_SEC_ENC_FLG] [char](1) NULL,
	[EMAIL_ADDR] [char](100) NULL,
	[MAX_VAC_HOUR] [numeric](4, 0) NULL,
	[STD_EARN_8] [numeric](8, 2) NULL,
	[STD_EARN_9] [numeric](8, 2) NULL,
	[STD_EARN_10] [numeric](8, 2) NULL,
	[FILLER38] [char](38) NULL,
	[ALPHA_SORT] [char](12) NULL,
	[VACATION_LEFT] [numeric](5, 2) NULL,
	[SICK_LEFT] [numeric](5, 2) NULL,
	[FILLER1] [char](1) NULL,
	[EMPL_INITIALS] [char](3) NULL,
	[USQL_401K_MATCH] [numeric](8, 2) NULL,
	[PR_401K_MATCH_PCT] [char](1) NULL,
	[FILLER2] [char](2) NULL,
	[PR_BILL_RATE] [numeric](13, 5) NULL,
	[PR_USE_IN_SCHED] [char](1) NULL,
	[PR_GROUPING] [numeric](3, 0) NULL,
	[PR_PROTOTYPE] [char](5) NULL,
	[PR_PURGE_DAYS] [numeric](3, 0) NULL,
	[PR_USER_ID] [char](8) NULL,
	[PR_BALANCE_GROUP] [char](8) NULL,
	[PR_EMPL_STATUS] [char](2) NULL,
	[PR_DD_TYPE] [char](1) NULL,
	[PR_CARRY_OVER_YMD] [char](6) NULL,
	[PR_RATE_SCALE] [char](2) NULL,
	[PR_RES_ALIEN] [char](1) NULL,
	[PR_EXCL_PC_RT_CALC] [char](1) NULL,
	[PR_NOT_ELIG_HOL] [char](1) NULL,
	[ELIG_HOL_DATE] [char](6) NULL,
	[PAY_GROUP] [char](1) NULL,
	[FUTA_EXEMPT] [char](1) NULL,
	[PRIMARY_LANG_CD] [char](3) NULL,
	[SEC_LANG_CD] [char](3) NULL,
	[FILLER5] [char](5) NULL,
	[SS_TAX_CREDIT] [char](1) NULL,
	[FILLER7] [char](7) NULL,
	[BOAT_EMPLOYEE] [char](1) NULL,
	[BRANCH] [char](2) NULL,
	[ALIEN_DED_FICA] [char](1) NULL,
	[ALIEN_DED_MEDI] [char](1) NULL,
	[ALIEN_DED_FIT] [char](1) NULL,
	[ALIEN_DED_SIT] [char](1) NULL,
	[GUI_SECURITY] [numeric](2, 0) NULL,
	[FICA_EXEMPT] [char](1) NULL,
	[MEDI_EXEMPT] [char](1) NULL,
	[PORT_CAPTAIN] [char](1) NULL,
	[ELIG_DT_401K] [char](8) NULL,
	[FILLER6B] [char](6) NULL,
	[EXCL_BIO] [bit] NULL,
	[CONTRACT_EMP] [char](1) NULL,
	[EMAIL_DIR_DEP] [char](1) NULL,
	[SICK_ANNUAL_CRRYOVR] [numeric](5, 2) NULL,
	[FILLER] [char](72) NULL,
	[ETL_TblNbr] [varchar](3) NOT NULL,
	[ETL_Batch] [varchar](1) NOT NULL,
	[ETL_Completed] [varchar](19) NOT NULL
) ON [PRIMARY]

GO

