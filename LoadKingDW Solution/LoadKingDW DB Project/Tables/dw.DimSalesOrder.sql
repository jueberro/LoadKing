CREATE TABLE [dw].[DimSalesOrder](

	 [DimSalesOrder_Key]           [int] IDENTITY(1,1) NOT NULL
	,[SalesOrderNumber]            [nchar](7)          NOT NULL     --[ORDER_NO]          [char](7)     NOT NULL, --SalesOrderNumber                 -- ORDER_HEADER    
	,[SalesOrderLine]              [nchar](4)          NOT NUll     --[RECORD_NO]         [char](4)     NOT NULL, --SalesOrderLine                   -- ORDER_LINE
	,[SOCreationDate]              datetime                NULL     --[DATE_ORDER]        [date]            NULL, --SOCreationDate                   -- ORDER_HEADER
	,[SODueDate]                   datetime                NULL     --[DATE_ORDER_DUE]    [date]            NULL, --SODueDate                        -- ORDER_HEADER
	
	,[OrderSort]                   varchar(20)             NULL     --[CODE_SORT]         [nvarchar](20)    NULL, --OrderSort                        -- ORDER_HEADER
	,[DateOrder]                   datetime				   NULL     --[DATE_ORDER]        [nvarchar](6)     NULL, --DateShipped - Use nvarchar6 udf  -- ORDER_LINE 
	,[DateShipped]                 datetime				   NULL     --[DATE_SHIP]         [nvarchar](6)     NULL, --DateShipped - Use nvrachar6 udf  -- ORDER_LINE
	,[PromiseDate]                 datetime				   NULL     --[ITEM_PROMISE_DT]   [date]            NULL, --PromiseDateDimDate               -- ORDER_LINE
    ,[DateAddedDate]               datetime				   NULL     --[ADD_BY_DATE]       [date]            NULL, --DateAddedDateDimDate             -- ORDER_LINE
    ,[DeliverByDate]               datetime				   NULL     --[MUST_DLVR_BY_DATE] [date]            NULL, --DeliverByDateDimDate             -- ORDER_LINE
    ,[DateLastChanged]             datetime  			   NULL     --[DATE_LAST_CHG]     [date]            NULL, --DateLastChanged                  -- ORDER_LINE

	--KeyAttributes
     
	,[SLLastChangeBy]              [nvarchar](8)           NULL
	,[User1]                       varchar(30)             NULL     --[USER_1]            [char](30)        NULL, --User1                            -- ORDER_LINE
    ,[User2]                       varchar(30)             NULL     --[USER_2]            [char](30)        NULL, --User2                            -- ORDER_LINE
    ,[TrackingNotes]               varchar(30)             NULL     --[USER_3]            [char](30)        NULL, --TrackingNotes                    -- ORDER_LINE
    ,[User4]                       varchar(30)             NULL     --[USER_4]            [char](30)        NULL, --User3                            -- ORDER_LINE
    ,[LineShipVia]                 varchar(30)             NULL     --[USER_5]            [char](30)        NULL, --LineShipVia                      -- ORDER_LINE
	,[CustomerPart]                varchar(20)             NULL     --[CUSTOMER_PART]     [char](20)        NULL, --CustomerPart                     -- ORDER_LINE
    ,[PriceGrpID]                  varchar(20)             NULL     --[INFO_1]            [char](20)        NULL, --PriceGroupID                     -- ORDER_LINE
	,[GroupID]                     varchar(20)             NULL     --[INFO_2]            [char](20)        NULL, --GroupID                          -- ORDER_LINE
	
	,[Type1RecordHash] [varbinary](64)           NULL
	,[Type2RecordHash] [varbinary](64)           NULL
	,[SourceSystemName] [nvarchar](100)          NOT NULL
	,[DWEffectiveStartDate] [datetime2](7)       NOT NULL
	,[DWEffectiveEndDate] [datetime2](7)         NOT NULL
	,[DWIsCurrent] [bit]                         NOT NULL
	,[LoadLogKey] [int]                          NOT NULL 
	CONSTRAINT [pk_DimSalesOrders] PRIMARY KEY CLUSTERED 
	(
	[DimSalesOrder_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO