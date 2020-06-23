/****** Script for SelectTopNRows command from SSMS  ******/

-- SELECT 'USE [LK-GS-EDW];' + CHAR(13)+ 'GO'+ CHAR(13)

  -- UPDATE EC SET [ExtractEnabledFlag] = 1  FROM [ods_globalshop].[ExtractConfiguration] EC WHERE [TargetTableName] = ''
  -- UPDATE EC SET [LoadDWTableFlag] = 1  FROM [ods_globalshop].[ExtractConfiguration] EC WHERE [DWTableName] = ''
    
  
   -- DELETE FROM [LK-GS-CNC].[ods_globalshop].[LoadLog];
   -- DELETE FROM [dwetl].[LoadLog];
/*
-- TRUNCATE ODS
SET NOCOUNT ON;
SELECT 'USE [LK-GS-ODS];' + CHAR(13)+ 'GO'

SELECT 'TRUNCATE TABLE '  +[ODSTableName] +';'
  FROM [LK-GS-CNC].[dwetl].[DWTableSource]
  WHERE [LoadDWTableFlag] = 1

-- TRUNCATE DWSTAGE  [StageTableName]
--SET NOCOUNT ON;
SELECT 'USE  [LK-GS-EDW];' + CHAR(13)+ 'GO'

SELECT 'TRUNCATE TABLE '  +[StageTableName] +';'
  FROM [LK-GS-CNC].[dwetl].[DWTableSource]
  WHERE [LoadDWTableFlag] = 1


-- TRUNCATE DW
--SET NOCOUNT ON;
SELECT 'USE [LK-GS-EDW];' + CHAR(13)+ 'GO'

SELECT 'TRUNCATE TABLE ' +'dw.' +[DWTableName] +';'
  FROM [LK-GS-CNC].[dwetl].[DWTableSource]
  WHERE [LoadDWTableFlag] = 1

*/