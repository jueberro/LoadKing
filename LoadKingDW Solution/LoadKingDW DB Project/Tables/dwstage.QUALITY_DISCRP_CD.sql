-- USE [LK-GS-EDW]
--GO


CREATE TABLE dwstage.QUALITY_DISCRP_CD
(
	[SYS] [char](3) NULL,
	[SUB_SYS] [char](3) NULL,
	[DISCREP_CODE] [char](3) NULL,
	[FILLER11] [char](11) NULL,
	[DISCREP_DESC] [char](20) NULL,
	[FILLER] [char](82) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO


