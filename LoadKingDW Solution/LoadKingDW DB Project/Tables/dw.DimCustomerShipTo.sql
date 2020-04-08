CREATE TABLE [dw].[DimCustomerShipTo] (
   	DimCustomer_Key             INT                      NOT NULL,
	PrimaryCustomerID			NCHAR(6)                 NOT NULL, 
	ShipToSeq					NCHAR(6)                 NOT NULL, 
	ShipToCustomername			NVARCHAR(30)             NOT NULL,  
	ShipToAddress1				NVARCHAR(30)             NULL, 
	ShipToAddress2				NVARCHAR(30)             NULL,
	ShipToAddress3    			NVARCHAR(30)             NULL,
	ShipToAddress4  			NVARCHAR(30)             NULL,
	ShipToCity      			NCHAR(15)                NULL,
	ShipToState	    			NCHAR(2)                 NULL,
	ShipToZip	    			NCHAR(13)                NULL,
	ShipToCountry   			NCHAR(12)                NULL,
	ShipToAttention 			NVARCHAR(30)             NULL, 
	ShipToTelephone      		NCHAR(13)                NULL,
	ShipToSalesperson     		NCHAR(3)                 NULL,
	ShipToShipVia 		  		NCHAR(1)                 NULL,
	ShipToBranch 		  		NCHAR(2)                 NULL,
	ShipToTaxENo		  		NCHAR(20)                NULL,
	ShipToTaxState 		  		NCHAR(2)                 NULL,
	ShipToTaxZip 		  		NCHAR(13)                NULL,
	ShipToTax1 			  		NCHAR(3)                 NULL,
	ShipToTax2 			  		NCHAR(3)                 NULL,
	ShipToTax3 			  		NCHAR(3)                 NULL,
	ShipToTax4			  		NCHAR(3)                 NULL,
	ShipToTax5 			  		NCHAR(3)                 NULL,
	ShipToWhoLastChanged		NVARCHAR(8)              NULL, 
	ShipToTrmLastChanged		NUMERIC(2,0)             NULL,
	ShipToDateLastChanged		DateTime                 NULL,  
	ShipToPrimaryGroup			NCHAR(2)                 NULL,
	ShipToCarrierCD				NCHAR(6)                 NULL,  

   	/*Hashes used for identifying changes, not required for reporting*/
	Type1RecordHash				VARBINARY(64)		NULL,	
	Type2RecordHash				VARBINARY(64)		NULL,	

	/*DW Metadata fields, not required for reporting*/
	SourceSystemName			NVARCHAR(100)		NOT NULL,
	DWEffectiveStartDate		DATETIME2(7)		NOT NULL,
	DWEffectiveEndDate			DATETIME2(7)		NOT NULL,
	DWIsCurrent					BIT					NOT NULL,

	/*ETL Metadata fields, not required for reporting (DWEffectiveStartDate may not neccessarily be the same as RecordCreateDate, for example */
	LoadLogKey					INT					NOT NULL, --ID of ETL process that inserted the record    CONSTRAINT [pk_DimEmployee] PRIMARY KEY CLUSTERED ([DimEmployee_Key] ASC)

    CONSTRAINT [pk_DimCustomerShipTo] PRIMARY KEY CLUSTERED 
(
	[PrimaryCustomerID] ASC,
	[ShipToSeq] ASC)

);

