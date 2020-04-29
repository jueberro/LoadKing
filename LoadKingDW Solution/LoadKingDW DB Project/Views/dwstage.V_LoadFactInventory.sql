
Create VIEW [dwstage].[V_LoadFactInventory] AS

SELECT     DimInventory_Key			   = ISNULL(DIN.DimInventory_Key,      -1)
	   
          ,Stage.PartID
		  ,Stage.DateLastUsage	      
		  ,Stage.DateLastAudit	
		  ,Stage.Location				
		  ,Stage.DateLastChg					      
		  ,Stage.WhoChgLast				     	  
		  ,Stage.BIN	
		  ,Stage.DateCycle	
		  ,Stage.CodeBOM	    
		  ,Stage.CodeDiscount
		  ,Stage.CodeTotal	          
		  ,Stage.PriorUsage		 	  
		  ,Stage.AltCostAmt		      
		  ,Stage.MinMultiple		      
		  ,Stage.FloorStockingLevel	  
		  ,Stage.QtyOnHand		      
		  ,Stage.QtyReorder		      
		  ,Stage.QtyOnOrderPO          
		  ,Stage.QtyOnOrderWO          
		  ,Stage.QtyRequired		      
		  ,Stage.AmtCost  		      
		  ,Stage.UsageJanuary		  
		  ,Stage.UsageFebruary		  
		  ,Stage.UsageMarch		      
		  ,Stage.UsageApril		      
		  ,Stage.UsageMay		      
		  ,Stage.UsageJune		      
		  ,Stage.UsageJuly		      
		  ,Stage.UsageAugust		      
		  ,Stage.UsageSeptember		  
		  ,Stage.UsageOctober		  
		  ,Stage.UsageNovember		  
		  ,Stage.UsageDecember          
		--just a change to force a refresh
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

 

  

