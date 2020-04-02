﻿CREATE TABLE [dw].[DimPart] (
    [DimPart_Key]        INT             IDENTITY (1, 1) NOT NULL,
    [PartID]             CHAR (20)       NULL,
    [PartLocation]       CHAR (2)        NULL,
    [PartCodeAbc]        CHAR (1)        NULL,
    [PartProductLine]    CHAR (2)        NULL,
    [PartBin]            CHAR (6)        NULL,
    [PartDescription]    VARCHAR (100)   NULL,
    [PartPrice]          NUMERIC (13, 5) NULL,
    [PartObsoleteFlag]   BIT             NULL,
    [PartCodeBom]        CHAR (1)        NULL,
    [PartCodeDiscount]   CHAR (1)        NULL,
    [PartCodeTotal]      CHAR (1)        NULL,
    [PartCodeSort]       CHAR (10)       NULL,
    [PartVendorName]     VARCHAR (50)    NULL,
    [PartDescription2]   VARCHAR (100)   NULL,
    [PartDescription3]   VARCHAR (100)   NULL,
    [PartVatProductType] CHAR (5)        NULL,
    [PartTaxExemptFlag]  CHAR (1)        NULL,
    [ETL_Batch]          INT             NULL,
    [ETL_Completed]      DATETIME        NULL,
    [effective_date]     DATETIME        NOT NULL,
    [End_date]           DATETIME        NULL,
    [IsEffective]        VARCHAR (1)     NOT NULL,
    CONSTRAINT [PK_DimInventory_SK] PRIMARY KEY CLUSTERED ([DimPart_Key] ASC)
);

