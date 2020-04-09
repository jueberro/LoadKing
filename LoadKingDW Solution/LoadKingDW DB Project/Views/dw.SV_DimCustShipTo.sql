﻿Create View
[dw].[SV_DimCustomerShipTo]
As
SELECT [DimCustomerShipTo_Key]
      ,[PrimaryCustomerID]
      ,[ShipToSeq]
      ,[ShipToCustomername]
      ,[ShipToAddress1]
      ,[ShipToAddress2]
      ,[ShipToAddress3]
      ,[ShipToAddress4]
      ,[ShipToCity]
      ,[ShipToState]
      ,[ShipToZip]
      ,[ShipToCountry]
      ,[ShipToAttention]
      ,[ShipToTelephone]
      ,[ShipToSalesperson]
      ,[ShipToShipVia]
      ,[ShipToBranch]
      ,[ShipToTaxENo]
      ,[ShipToTaxState]
      ,[ShipToTaxZip]
      ,[ShipToTax1]
      ,[ShipToTax2]
      ,[ShipToTax3]
      ,[ShipToTax4]
      ,[ShipToTax5]
      ,[ShipToWhoLastChanged]
      ,[ShipToTrmLastChanged]
      ,[ShipToDateLastChanged]
      ,[ShipToPrimaryGroup]
      ,[ShipToCarrierCD]
      ,[DWEffectiveStartDate]
      ,[DWEffectiveEndDate]
      ,[DWIsCurrent]
  FROM [dw].[DimCustomerShipTo]
GO