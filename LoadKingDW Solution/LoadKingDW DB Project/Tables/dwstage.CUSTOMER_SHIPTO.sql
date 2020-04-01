CREATE TABLE [dwstage].[CUSTOMER_SHIPTO](
	[CUSTOMER] [char](6) NULL,
	[REC] [char](1) NULL,
	[NAME_CUSTOMER_SHIP] [char](30) NULL,
	[ADDRESS1_SHIP] [char](30) NULL,
	[ADDRESS2_SHIP] [char](30) NULL,
	[CITY_SHIP] [char](15) NULL,
	[STATE_SHIP] [char](2) NULL,
	[CODE_ZIP_SHIP] [char](13) NULL,
	[COUNTRY_SHIP] [char](12) NULL,
	[COUNTY_SHIP] [char](12) NULL,
	[ATTENTION_SHIP] [char](30) NULL,
	[SHIP_VIA] [char](1) NULL,
	[CODE_SHIP_COLLECT] [char](1) NULL,
	[FLAG_EDI_ASN] [char](1) NULL,
	[FLAG_EDI_INVOICE] [char](1) NULL,
	[FRT_ZONE] [char](10) NULL,
	[INTL_ADRS] [char](1) NULL,
	[T_COUNTRY] [char](3) NULL,
	[AREA] [char](3) NULL,
	[TELE] [char](7) NULL,
	[FAX] [char](15) NULL,
	[FILLER] [char](2) NULL,
	[DISCOUNT] [numeric](5, 4) NULL,
	[BOL_MULTI_ID] [char](6) NULL,
	[INTL_CITY_FLD] [char](1) NULL,
	[INTL_CRTY_FLD] [char](1) NULL,
	[ETL_TblNbr] [int] NULL,
	[ETL_Batch] [int] NULL,
	[ETL_Completed] [datetime] NULL
) ON [PRIMARY]

GO


