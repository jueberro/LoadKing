CREATE VIEW [dwstage].[V_LoadDimSalesOrder] AS

SELECT   
	
	
	      [SalesOrderNumber]          = CAST(stage.ORDER_NO      AS nchar(7))     --ORDER_NO      
	    , [SOCreationDate]            = stage.DATE_ORDER                          --DATE_ORDER     
	    , [SODueDate]                 = stage.DATE_DUE                            --DATE_DUE      
        , [SODateLastChanged]         = stage.DATE_LAST_CHG                       --DATE_LAST_CHANGE, TIME_LAST_CHANGE (use Full date conversion udf)
	  									                                      
	    , [LastChangeBy]              = CAST(stage.LAST_CHG_BY AS nvarchar(8))    --LAST_CHG_BY

	    , [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
	    , [Type2RecordHash]		      = HASHBYTES('SHA2_256',             CAST(stage.ORDER_NO			AS    NCHAR(7))
          	    					 						            + CAST([DATE_LAST_CHG]          AS VARCHAR(10))  )  

		/*DW Metadata fields, not required for reporting*/
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)

FROM	dwstage.ORDER_HEADER AS Stage
   
 LEFT OUTER JOIN dw.DimSalesOrder AS DSO
  ON	CAST(Stage.ORDER_NO AS NCHAR(7)) = DSO.SalesOrderNumber
   AND	DSO.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    CAST(Stage.CUSTOMER	AS NCHAR(6)) = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dwstage.SALESPERSON AS SP
  ON    CAST(Stage.SALESPERSON AS NCHAR(3)) = SP.SalespersonID
 

 LEFT OUTER JOIN dw.DimDate AS OrderDate
  ON	CAST(Stage.DATE_ORDER as datetime) = OrderDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimDate AS DueDate
  ON	CAST(Stage.DATE_DUE as Datetime) = DueDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/
 
 LEFT OUTER JOIN dw.DimDate AS QuoteCreateDate
  ON	CAST(Stage.QTE_CREATED_DATE as datetime) = QuoteCreateDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimDate AS QuoteWonLostDate
  ON	CAST(Stage.QUOTE_WON_LOSS_DATE as datetime) = QuoteWonLostDate.[Date]			/*CHANGE DATE FORMAT IN JOIN CONDITION*/

 LEFT OUTER JOIN dw.DimCustomerShipTo AS DCST
  ON	CAST(stage.SHIP_ID AS NCHAR(6)) = DCST.ShipToSeq
   AND     CAST(Stage.CUSTOMER AS nchar(6)) = DCST.PrimaryCustomerID
      AND	DCST.DWIsCurrent = 1

      Where Stage.RECORD_TYPE = 'A'

GO
