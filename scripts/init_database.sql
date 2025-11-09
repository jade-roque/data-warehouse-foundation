/*
=============================================================
DATABASE SETUP SCRIPT
=============================================================
What this script does:
    1. Creates a new database called 'JdrrDW2025'
    2. Sets up three schemas: bronze, silver, and gold
    3. If the database already exists, it deletes it first
=============================================================
*/

-- Step 1: Switch to master database
USE master;
GO

-- Step 2: Check if database exists and delete it
-- This prevents errors if we run the script multiple times
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'JdrrDW2025')
BEGIN
    -- Disconnect all users from the database
    ALTER DATABASE JdrrDW2025 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Delete the database
    DROP DATABASE JdrrDW2025;
    
    PRINT 'Old JdrrDW2025 database deleted successfully.';
END;
GO

-- Step 3: Create database
CREATE DATABASE JdrrDW2025;
PRINT 'JdrrDW2025 database created successfully.';
GO

-- Step 4: Switch to the new database
USE JdrrDW2025;
GO

-- Step 5: Create schemas for data layers
-- Bronze = Raw data (as-is from source)
CREATE SCHEMA bronze;
GO
PRINT 'Bronze schema created (for raw data).';
GO

-- Silver = Cleaned data (transformed and standardized)
CREATE SCHEMA silver;
GO
PRINT 'Silver schema created (for cleaned data).';
GO

-- Gold = Analytics-ready data (star schema for reporting)
CREATE SCHEMA gold;
GO
PRINT 'Gold schema created (for analytics data).';
GO

PRINT '=============================================================';
PRINT 'Setup complete! Database and schemas are ready to use.';
PRINT '=============================================================';
