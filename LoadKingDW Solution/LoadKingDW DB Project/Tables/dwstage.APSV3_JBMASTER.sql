USE [LK-GS-EDW]
GO


CREATE TABLE dwstage.APSV3_JBMASTER
(
	[JS] [char](9) NOT NULL,
	[SCENARIO] [int] NOT NULL,
	[JOB] [char](6) NULL,
	[SFX] [char](3) NULL,
	[PROJECT] [char](50) NULL,
	[PARENT] [char](9) NULL,
	[PART] [char](20) NULL,
	[LOC] [char](2) NULL,
	[DESCRIPTION] [char](40) NULL,
	[CUSTNAME] [char](30) NULL,
	[CUSTNO] [char](6) NULL,
	[ORDERDATE] [datetime2](7) NULL,
	[DUEDATE] [datetime2](7) NULL,
	[SCHEDDATE] [datetime2](7) NULL,
	[SCHEDDIR] [int] NULL,
	[BOMPARENT] [bit] NOT NULL,
	[BOMCHILD] [bit] NOT NULL,
	[LOCKED] [bit] NOT NULL,
	[SSLD] [bit] NOT NULL,
	[HOLD] [bit] NOT NULL,
	[PRIORITY] [int] NULL,
	[JOBTYPE] [int] NULL,
	[DSD] [int] NULL,
	[PCSTOPROD] [real] NULL,
	[PCSCOMPL] [real] NULL,
	[PCSREMAIN] [real] NULL,
	[PRODSTARTED] [datetime2](7) NULL,
	[PAPERDIST] [bit] NOT NULL,
	[PAPERPRINT] [bit] NOT NULL,
	[SPR] [bit] NOT NULL,
	[LASTSCHEDDATE] [datetime2](7) NULL,
	[LASTSCHEDUSER] [char](8) NULL,
	[SCHEDLATE] [bit] NOT NULL,
	[MSTART] [datetime2](7) NULL,
	[LSTART] [datetime2](7) NULL,
	[OFFSETTYPE] [int] NULL,
	[OFFSETAMT] [int] NULL,
	[OFFSETPOINT] [char](10) NULL,
	[RESCHEDULE] [bit] NOT NULL,
	[SCHEDSTART] [datetime2](7) NULL,
	[SCHEDEND] [datetime2](7) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]
GO

