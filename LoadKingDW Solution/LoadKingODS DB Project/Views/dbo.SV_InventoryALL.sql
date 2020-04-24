

CREATE VIEW dbo.SV_InventoryALL
AS
SELECT    CAST(A.PART AS nchar(20))                                          AS PartID,  
          CAST(A.LOCATION AS nchar(2))                                       AS PartLocation, 
		  CAST(A.CODE_ABC AS nchar(1))                                       AS PartCodeABC, 
		  CAST(A.PRODUCT_LINE AS nchar(2))                                   AS PartProductLine, 
		  CAST(A.BIN AS nchar(6))                                            AS PartBin, 
		  CAST(A.DESCRIPTION AS nvarchar(100))                               AS PartDescription, 
		  CAST(A.AMT_PRICE AS numeric(13, 5))                                AS PartPrice, 
		  CAST(CASE WHEN A.OBSOLETE_FLAG = 'Y' THEN 1 ELSE 0 END AS BIT)     AS PartObsoleteFlag,
		  CAST(A.CODE_BOM AS nchar(1))                                       AS PartCodeBOM,
		  CAST(A.CODE_DISCOUNT AS nchar(1))                                  AS PartCodeDiscount,
		  CAST(A.CODE_TOTAL AS nchar(1))                                     AS PartCodeTotal, 
          CAST(A.CODE_SORT AS nchar(10))                                     AS PartCodeSort, 
		  CAST(B.NAME_VENDOR AS nvarchar(50))                                AS PartVendorName, 
		  CAST(B.DESCRIPTION_2 AS nvarchar(100))                             AS PartDescription2, 
          CAST(B.DESCRIPTION_3 AS nvarchar(100))                             AS PartDescription3, 
		  CAST(C.VAT_PRODUCT_TYP AS nchar(5))                                AS PartVatProductType, 
		  CAST(C.TAX_EXEMPT_FLG AS nchar(1))                                 AS PartTaxExemptFlag, 
		  A.ETL_Batch, 
          A.ETL_Completed

--FROM  dbo.V_Inventory_All -- Read From source tables not an additional view
FROM            
dbo.INVENTORY_MSTR AS A
LEFT OUTER JOIN dbo.INVENTORY_MST2 AS B 
ON A.PART = B.PART 
AND A.LOCATION = B.LOCATION 
LEFT OUTER JOIN dbo.INVENTORY_MST3 AS C 
ON A.PART = C.PART 
AND A.LOCATION = C.LOCATION
