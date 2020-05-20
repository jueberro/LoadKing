-- USE [LK-GS-EDW]
--GO


CREATE TABLE dwstage.QUAL_MSTR_NOTES
(
	[NUMBER] [char](7) NULL,
	[SEQ] [char](3) NULL,
	[TEXT] [text] NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


