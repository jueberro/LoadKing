
Create VIEW [dwstage].[V_LoadFactInventory] AS

SELECT    DimInventory_Key			   = ISNULL(DIN.DimInventory_Key,      -1)
	   
          ,DateLastUsage	      
		  ,DateLastAudit		  
		  ,DateCycle		      
		  ,CodeBOM	         	  
		  ,CodeDiscount		  
		  ,CodeTotal	          
		  ,PriorUsage		 	  
		  ,AltCostAmt		      
		  ,MinMultiple		      
		  ,FloorStockingLevel	  
		  ,QtyOnHand		      
		  ,QtyReorder		      
		  ,QtyOnOrderPO          
		  ,QtyOnOrderWO          
		  ,QtyRequired		      
		  ,AmtCost  		      
		  ,UsageJanuary		  
		  ,UsageFebruary		  
		  ,UsageMarch		      
		  ,UsageApril		      
		  ,UsageMay		      
		  ,UsageJune		      
		  ,UsageJuly		      
		  ,UsageAugust		      
		  ,UsageSeptember		  
		  ,UsageOctober		  
		  ,UsageNovember		  
		  ,UsageDecember          
		

		/*Hash used for identifying changes, not required for reporting*/
		, RecordHash				  = CAST(0 AS VARBINARY(64)) 

		/*DW Metadata fields, not required for reporting*/
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)

FROM	dwstage._V_Inventory as Stage
   
  LEFT OUTER JOIN dw.DimInventory AS DIN
  ON    Stage.PartID = DIN.PartID
   AND  DIN.DWIsCurrent = 1

 

  

