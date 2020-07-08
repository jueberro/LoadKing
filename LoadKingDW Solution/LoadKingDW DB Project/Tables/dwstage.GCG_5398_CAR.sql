﻿CREATE TABLE [dwstage].[GCG_5398_CAR](
	[CCA_NO] [bigint] NULL,
	[DATE_ENTERED] [date] NULL,
	[COMPLETED_DATE] [date] NULL,
	[ORIG_USER] [char](8) NULL,
	[PROJECT_TYPE] [char](30) NULL,
	[PART] [char](20) NULL,
	[WO] [char](10) NULL,
	[SO] [char](12) NULL,
	[ISSUE] [char](50) NULL,
	[DESCRIPTION] [text] NULL,
	[ROOT_CAUSE] [text] NULL,
	[ACTION_PLAN] [text] NULL,
	[STATUS] [char](30) NULL,
	[ASSIGNED_DEPT] [char](4) NULL,
	[ASSIGNED_TO] [char](8) NULL,
	[SOURCE] [char](30) NULL,
	[DUE_DATE] [date] NULL,
	[PRIORITY] [char](8) NULL,
	[ECR_REQUIRED] [bit] NULL,
	[ECR] [bigint] NULL,
	[EST_COST_INC] [float] NULL,
	[WORKGROUP] [char](15) NULL,
	[QA_SIGNOFF] [bit] NULL,
	[QA_USER] [char](8) NULL,
	[ADD_GROUP_1] [char](5) NULL,
	[GROUP_1_SIGNOFF] [bit] NULL,
	[GROUP_1_USER] [char](8) NULL,
	[ADD_GROUP_2] [char](5) NULL,
	[GROUP_2_SIGNOFF] [bit] NULL,
	[GROUP_2_USER] [char](8) NULL,
	[EMAIL_SENT] [bit] NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]