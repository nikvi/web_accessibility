-- Determine Current Connections
SELECT
    *
FROM
    pg_stat_activity
WHERE
    datname = 'accessibility-reports';

-- Drop Tables
DROP TABLE categories;
DROP TABLE pages;
DROP TABLE reports;
DROP TABLE websites;
DROP TABLE descriptions;

-- Switch database
Database: postgres

-- Kill Database Connections
SELECT
    pg_terminate_backend (pg_stat_activity.pid)
FROM
    pg_stat_activity
WHERE
    pg_stat_activity.datname = 'accessibility-reports';

--get all tables in current database
SELECT * 
FROM information_schema.tables 
WHERE table_type = 'BASE TABLE' 
    AND table_schema = 'public' 
ORDER BY table_type, table_name;

-- Drop Database
DROP DATABASE "accessibility-reports";
