CREATE VIEW [dwstage].[V_LoadDimSalesOrder] AS

SELECT   
		
	    [SalesOrderNumber]                       --[nchar](7) NULL,                 
	,   [SalesOrderLine]                         --[nchar](4) NULL,					
	,   [OHCreationDate]                         --[datetime] NULL,					
	,   [OHDueDate]                              --[datetime] NULL,						
	,   [OHOrderSort]                            --[nvarchar](20) NULL,					
	,   [OHProjectType]                          --[nvarchar](30) NULL,				
	,   [OHBranch]                               --[nchar](2) NULL,							
	,   [OHShipVia]                              --[nvarchar](20) NULL,					
	,   [OHPrimaryGroup]                         --[nchar](2) NULL,					
	,   [OHShippingZone]                         --[nchar](6) NULL,					
	,   [OHDateLastChanged]                      --[datetime] NULL,				
	,   [OHLastChangedBy]                        --[nvarchar](8) NULL,				
	,   [OLDateLastChanged]                      --[datetime] NULL,				
	,   [OLLastChangedBy]                         --[nvarchar](8) NULL,				
	,   [OLDateOrder]                            --[datetime] NULL,						
	,   [OLDateShipped]                          --[datetime] NULL,					
	,   [OLItemPromiseDate]                      --[datetime] NULL,				
	,   [OLDateItemProm]                         --[datetime] NULL,					
	,   [OLDateAddedDate]                        --[datetime] NULL,					
	,   [OLDeliverByDate]                        --[datetime] NULL,					
    ,   [OHCustomerID]                           --[nchar](6) NULL,                     
    ,   [OLCustomerID]                           --[nchar](6) NULL,						
    ,   [OHShipToSeq]                            --[nchar](6) NULL,                      
	,   [OLShipToSeq]                            --[nchar](6) NULL,						
    ,   [OHSalespersonID]                        --[nvarchar](3) NULL,				
    ,   [OHQuoteNumber]                          --[nchar](7) NULL,					
    ,   [OHGLAccount]                            --[nchar](15) NULL,						
    ,   [OLPartID]                               --[nchar](20) NULL,						
	,   [OLCustomerPart]                         --[nvarchar](20) NULL,				
	,   [OLPriceGroupID]                         --[nvarchar](20) NULL,				
	,   [OLSOGroupID]                            --[nvarchar](20) NULL,					
	,   [OLUser1]                                --[nvarchar](30) NULL,						
	,   [OLUser2]                                --[nvarchar](30) NULL,						
	,   [OLTrackingNotes]                        --[nvarchar](30) NULL,				
	,   [OLUser4]                                --[nvarchar](30) NULL,						
	,   [OLLineShipVia]                          --[nvarchar](30) NULL,				
	,   [OLLineType]                             --[nchar](1) NULL,						
	,   [OLFlagSOtoWO]                           --[nchar](1) NULL,						
	,   [OLFlagPurchased]                        --[nchar](1) NULL,					
	,   [OLInactive]                             --[bit] NULL,					


	,   [Type1RecordHash]		       = CAST(0 AS VARBINARY(64))
	,   [Type2RecordHash]			   = HASHBYTES('SHA2_256',             SalesOrderNumber
 	    					 						                     + CAST(OHDateLastChanged         AS VARCHAR(10))  )  
  
		/*DW Metadata fields, not required for reporting*/
	,   [SourceSystemName]		      = CAST('Global Shop'        AS NVARCHAR(100))
	,   [DWEffectiveStartDate]	      = CAST(Getdate()            AS DATETIME2(7))
	,   [DWEffectiveEndDate]		  = '2100-01-01'
	,   [DWIsCurrent]				  = CAST(1					  AS BIT)
	,   [LoadLogKey]				  = CAST(0                    AS INT)

FROM	dwstage._V_SalesOrder 
   
       -- Where Stage.RECORD_TYPE = 'A' -- Already In stored proc that populates ODS database _V_SalesOrder
GO