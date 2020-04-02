CREATE TABLE [dw].[DimCustomerShipTo] (
    [DimCustomerShipTo_Key]           INT           IDENTITY (1, 1) NOT NULL,
    [DimCustomerKey]                  INT           NULL,
    [CustomerID]                      CHAR (6)      NOT NULL,
    [CustomerShipToID]                CHAR (6)      NOT NULL,
    [CustomerShipToName]              VARCHAR (50)  NOT NULL,
    [CustomerShipToAddress1]          VARCHAR (100) NULL,
    [CustomerShipToAddress2]          VARCHAR (100) NULL,
    [CustomerShipToCity]              VARCHAR (100) NULL,
    [CustomerShipToStateOrProvince]   VARCHAR (10)  NULL,
    [CustomerShipToPostalCode]        VARCHAR (50)  NULL,
    [CustomerShipToCountry]           VARCHAR (50)  NULL,
    [CustomerShipToCounty]            VARCHAR (50)  NULL,
    [CustomerShipToInternationalFlag] BIT           NULL,
    [CustomerShipToTerritory]         CHAR (2)      NULL,
    [ETL_Batch]                       VARCHAR (1)   NOT NULL,
    [ETL_Completed]                   VARCHAR (19)  NOT NULL,
    CONSTRAINT [pk_DimCustomerShipTo] PRIMARY KEY CLUSTERED ([DimCustomerShipTo_Key] ASC)
);

