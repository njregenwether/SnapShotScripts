use master;
Go 

IF OBJECT_ID (N'[dbo].[SNAPSHOTTHEDB]') IS NOT NULL
	DROP PROCEDURE dbo.SNAPSHOTTHEDB; 

Go

CREATE PROCEDURE SNAPSHOTTHEDB 
@DBNAME nvarchar(255) = '',
@FOLDER nvarchar(512) = '',
@SNAPSHOTNAME nvarchar(255) = ''
AS 
DECLARE @SNAPSHOTLINES nvarchar(max) = ''

DECLARE @SCRIPTTEMPLATE nvarchar(max) = '
IF EXISTS (SELECT database_id FROM sys.databases  
    WHERE NAME=''<SNAPSHOTNAME>'')  
    DROP DATABASE <SNAPSHOTNAME>;  


CREATE DATABASE <SNAPSHOTNAME>
ON
<DBFILESLINES>

AS SNAPSHOT OF <DBNAME>;';




SELECT @SNAPSHOTLINES =  SUBSTRING(
(SELECT
 --   db.name AS DBName,
 --   type_desc AS FileType,
 --   Physical_Name AS Location, 
	--mf.name, 
	',' + char(10) +  '( NAME = ' + mf.name + ', FILENAME = ''' + @FOLDER + mf.name + '.ss'')'


FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id
--WHERE db.name = 'BBInfinity' AND mf.type <> 1 
WHERE db.name = @DBNAME AND mf.type <> 1 
FOR XML PATH('')),2,200000) 

--replace(@SCRIPTTEMPLATE, '<>', @FOLDER )
SET @SCRIPTTEMPLATE = replace(@SCRIPTTEMPLATE, '<SNAPSHOTNAME>', @SNAPSHOTNAME )
SET @SCRIPTTEMPLATE = replace(@SCRIPTTEMPLATE, '<DBNAME>', @DBNAME )
SET @SCRIPTTEMPLATE = replace(@SCRIPTTEMPLATE, '<DBFILESLINES>', @SNAPSHOTLINES )


Execute sp_executesql @SCRIPTTEMPLATE