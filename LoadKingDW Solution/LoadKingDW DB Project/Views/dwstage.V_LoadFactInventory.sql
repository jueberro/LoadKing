
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
		  , RecordHash				  = HASHBYTES('SHA2_256',        													
                                                                             cast(stage.[DateLastUsage]     as nvarchar(26))		
																		 +   cast(stage.[DateLastAudit]     as nvarchar(26))	
																		 +   cast(stage.[DateLastChg]       as nvarchar(26))	
																		 +   stage.[WhoChgLast] 		
																		 +   [BIN]     		
																		 +   cast(stage.[DateCycle] as nvarchar(26))
																		 +   [CodeBOM]
																		 +   [CodeDiscount]
																		 +   [CodeTotal]
																		 +   cast([PriorUsage]              as nvarchar(16))
																		 +   cast([AltCostAmt]              as nvarchar(12))
																		 +   cast([MinMultiple]             as nvarchar(12))
																		 +   cast([FloorStockingLevel]      as nvarchar(12))
																		 +   cast([QtyOnHand]               as nvarchar(12))
																		 +   cast([QtyReorder]              as nvarchar(12))
																		 +   cast([QtyOnOrderPO]            as nvarchar(12))
																		 +   cast([QtyOnOrderWO]            as nvarchar(12))
																		 +   cast([QtyRequired]             as nvarchar(12))
																		 +   cast([AmtCost]                 as nvarchar(12))
																		 +   cast([UsageJanuary]            as nvarchar(7))
																		 +   cast([UsageFebruary]           as nvarchar(7))
																		 +   cast([UsageMarch]              as nvarchar(7))
																		 +   cast([UsageApril]              as nvarchar(7))
																		 +   cast([UsageMay]                as nvarchar(7))
																		 +   cast([UsageJune]               as nvarchar(7))
																		 +   cast([UsageJuly]               as nvarchar(7))
																		 +   cast([UsageAugust]             as nvarchar(7))
																		 +   cast([UsageSeptember]          as nvarchar(7))
																		 +   cast([UsageOctober]            as nvarchar(7))
																		 +   cast([UsageNovember]           as nvarchar(7))
																		 +   cast([UsageDecember]           as nvarchar(7)))

		
FROM	dwstage._V_Inventory as Stage
   
  LEFT OUTER JOIN dw.DimInventory AS DIN
  ON    Stage.PartID = DIN.PartID
   AND  DIN.DWIsCurrent = 1

 

  

