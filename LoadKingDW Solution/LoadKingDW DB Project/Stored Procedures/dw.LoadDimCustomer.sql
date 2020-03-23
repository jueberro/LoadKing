CREATE PROCEDURE [dw].[LoadDimCustomer] @LoadLogKey INT

AS

BEGIN

	/*
	TRUNCATE TABLE dwstage.DimCustomer

	
	INSERT INTO dwstage.DimCustomer
	SELECT alkfjaljfkd
			, afjlakfjlksd
			, afljlak
			, Type1RecordHash = '0x' + CONVERT(VARCHAR(66),HASHBYTES('SHA2_256',CONCAT(Field1, Field2...)),2)

	FROM	globalshoplanding.Customer AS Landing
	LEFT OUTER JOIN dwlookup.somelookuptable ...


	MERGE INTO dw.DimCustomer...
	UPDATE/EXPIRE OLD Items
	INSERT NEW items and new versions of existing items
	  Include LoadLogKey/ETLBatchID

	

	*/

	SELECT 1

END
