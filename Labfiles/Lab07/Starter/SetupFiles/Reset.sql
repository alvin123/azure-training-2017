USE master
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE [name] = 'Sales')
BEGIN
	ALTER DATABASE Sales SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Sales;
END
GO



