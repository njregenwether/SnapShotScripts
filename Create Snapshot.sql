Use master;
Go

DECLARE @DBNAME nvarchar(255) = 'BBInfinity'
DECLARE @FOLDER nvarchar(512) = 'C:\SnapshotDirectory\'
DECLARE @SNAPSHOTNAME nvarchar(255) = 'BBInfinity_Snapshot'


Execute dbo.SNAPSHOTTHEDB @DBNAME , @FOLDER , @SNAPSHOTNAME 