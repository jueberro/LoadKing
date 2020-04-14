CREATE VIEW [dwstage].[V_LoadDimSalesOrders] AS

SELECT   
	
	  DimCustomer_Key			= ISNULL(DC.DimCustomer_Key, -1)                  --Join on DimCustomer Using CAST(Customer AS nchar(6))          = DimCustomer.CustomerID           
	 ,DimCustomerShipTo_Key    	= ISNULL(DCST.DimCustomerShipTo_Key, -1)          --Join on DimCustomerShipTo Using CAST(SHIP_ID AS nchar(6))     = DimCustomerShipTo.ShipToSeq
	 ,OrderDateDimDate_Key 		= ISNULL(OrderDate.DimDate_Key, -1)
	 ,DueDateDimDate_Key 		= ISNULL(DueDate.DimDate_Key, -1)
	 ,QuoteCreateDimDate_Key 	= ISNULL(QuoteCreateDate.DimDate_Key, -1)
	 ,QuoteWonLostDimDate_Key 	= ISNULL(QuoteWonLostDate.DimDate_Key, -1)

	
	 ,SONumber                  = CAST(stage.ORDER_NO      AS nchar(7))     --ORDER_NO      
	 ,CustomerID                = CAST(stage.CUSTOMER      AS nchar(6))     --CUSTOMER      
	 ,CustomerName              = DC.CustomerName                           --Join on DimCustomer Using CAST(Customer AS nchar(6)) = DimCustomer.CustomerID
	 ,ShipToID                  = CAST(stage.SHIP_ID       AS nchar(6))     --SHIP_ID        
	 ,SOCreationDate            = stage.DATE_ORDER                          --DATE_ORDER     
	 ,SODueDate                 = stage.DATE_DUE                            --DATE_DUE      
	 ,OrderSort                 = CAST(stage.CODE_SORT     AS nvarchar(20))  --ORDER_SORT
	 ,ProjectType               = CAST(stage.USER_2        AS nvarchar(30))--USER2           
	 ,SalesPerson               = CAST(SP.NAME             AS nvarchar(50)) --Customer (Tanner) wants the SalesPersona Name is this record
	                                                                        --and does not see a need for DimSalesPerson so we will need to 
																            --Create An SSIS package that brings over SalesPersons from ODS just for this data.
																            --Join  on dwstage.SALESPERSON using SALESPERSON = dwstage.SALESPERSON.ID
	 ,Branch                    = CAST(stage.BRANCH        AS nvarchar(2))  --BRANCH
	 ,ShipVia                   = CAST(stage.SHIP_VIA      AS nchar(20))     --SHIP_VIA
	 ,QuoteNumber               = CAST(stage.QUOTE         AS nchar(7))     --QUOTE            
	 ,QuoteCreationDate         = stage.QTE_CREATED_DATE                    --QTE_CREATED_DATE    (needs nvarchar8 udf)
	 ,QuoteWonLostDate          = stage.QUOTE_WON_LOSS_DATE                 --QUOTE_WON_LOST_DATE (needs nvarchar8 udf)
	 ,PrimaryGroup              = CAST(stage.PRIMARY_GRP       AS nchar(2))     --PRIMARY_GRP
	 ,ShippingZone              = CAST(stage.CARRIER_CD        AS nchar(6))     --CARRIER_CD
	 ,SODateLastChanged         = stage.DATE_LAST_CHG
											                                 --DATE_LAST_CHANGE, TIME_LAST_CHANGE (use Full date conversion udf)
	, [LastChangeBy]            = CAST(stage.LAST_CHG_BY AS nvarchar(8))     --LAST_CHG_BY




	,   [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
	,   [Type2RecordHash]			  = HASHBYTES('SHA2_256',             CAST(stage.ORDER_NO			AS    NCHAR(7))
		        	    											    + CAST([DATE_LAST_CHG]          AS VARCHAR(10))  )  
                                                                                      
                                                                              
	
	

		/*DW Metadata fields, not required for reporting*/
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)

FROM	dwstage.ORDER_HEADER AS Stage
   
 LEFT OUTER JOIN dw.DimSalesOrders AS DSO
  ON	CAST(Stage.ORDER_NO AS NCHAR(7)) = DSO.SONumber
   AND	DSO.DWIsCurrent = 1 

 LEFT OUTER JOIN dw.DimCustomer AS DC
  ON    CAST(Stage.CUSTOMER	AS NCHAR(6)) = DC.CustomerID
   AND  DC.DWIsCurrent = 1

 LEFT OUTER JOIN dwstage.SALESPERSONS AS SP
  ON    CAST(Stage.SALESPERSON AS NCHAR(3)) = SP.ID
 

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
