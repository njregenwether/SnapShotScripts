use master;

DECLARE @snapshotname nvarchar(255) = 'BBINFINITY_SS_WITHDEDUPE'





DECLARE @sql nvarchar(max) = 'DROP DATABASE <SNAPSHOTNAME>;'

SET @sql = replace(@sql, '<SNAPSHOTNAME>', @snapshotname); 

EXECUTE sp_executesql @sql; 