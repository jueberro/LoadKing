CREATE TABLE [dw].[DimCustomer] (
    [DimCustomer_Key]           INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]                CHAR (6)      NOT NULL,
    [CustomerName]              VARCHAR (50)  NOT NULL,
    [CustomerAddress1]          VARCHAR (100) NULL,
    [CustomerAddress2]          VARCHAR (100) NULL,
    [CustomerCity]              VARCHAR (100) NULL,
    [CustomerStateOrProvince]   VARCHAR (10)  NULL,
    [CustomerPostalCode]        VARCHAR (50)  NULL,
    [CustomerCountry]           VARCHAR (50)  NULL,
    [CustomerCounty]            VARCHAR (50)  NULL,
    [CustomerInternationalFlag] BIT           NULL,
    [CustomerTerritory]         CHAR (2)      NULL,
    [CustomerCodeArea]          CHAR (2)      NULL,
    [CustomerCredit]            CHAR (2)      NULL,
    [ETL_Batch]                 VARCHAR (1)   NOT NULL,
    [ETL_Completed]             VARCHAR (19)  NOT NULL,
    CONSTRAINT [pk_DimCustomer] PRIMARY KEY CLUSTERED ([DimCustomer_Key] ASC)
);

