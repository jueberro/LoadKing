CREATE VIEW [dwstage].[V_LoadDimWorkgroupHead]
AS
SELECT 		                                 
		  WorkGroup			          = CAST(Work_Group				AS NCHAR(4))
		, Descr     		          = CAST(Descr  	            AS NVARCHAR(20))
		, Prototype_WC		     	  = CAST(Prototype_WC           AS NCHAR(4))
		, Type                        = CAST(Type                   AS NCHAR(1))
		, Nesting                     = CAST(Nesting                AS NCHAR(1))
		, [Type1RecordHash]		      = CAST(0 AS VARBINARY(64))
		, [Type2RecordHash]			  = HASHBYTES('SHA2_256',        
															+ CAST(Work_group      AS NCHAR(4))
															+ CAST(Descr          AS NVARCHAR(20))
															+ CAST(Prototype_WC   AS NVARCHAR(4))
															+ CAST(Type           AS NCHAR(1))
															+ CAST(Nesting        AS NCHAR(1))
															)
	    , [SourceSystemName]		  = CAST('Global Shop'        AS NVARCHAR(100))
		, [DWEffectiveStartDate]	  = CAST(Getdate()            AS DATETIME2(7))
		, [DWEffectiveEndDate]		  = '2100-01-01'
		, [DWIsCurrent]				  = CAST(1					  AS BIT)
		, [LoadLogKey]				  = CAST(0                    AS INT)
FROM 
	dwstage.WORKGROUP_HEAD
GO



