-- Initialize Odoo 18 Enterprise Test Database
-- This script runs automatically when PostgreSQL container starts for the first time

-- Create additional test databases for parallel testing
CREATE DATABASE odoo18_test_unit;
CREATE DATABASE odoo18_test_integration;
CREATE DATABASE odoo18_test_e2e;

-- Grant permissions to odoo user for all test databases
GRANT ALL PRIVILEGES ON DATABASE odoo18_test TO odoo;
GRANT ALL PRIVILEGES ON DATABASE odoo18_test_unit TO odoo;
GRANT ALL PRIVILEGES ON DATABASE odoo18_test_integration TO odoo;
GRANT ALL PRIVILEGES ON DATABASE odoo18_test_e2e TO odoo;

-- Create extensions needed by Odoo
\c odoo18_test;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "unaccent";

\c odoo18_test_unit;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "unaccent";

\c odoo18_test_integration;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "unaccent";

\c odoo18_test_e2e;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "unaccent";

-- Set default timezone
SET timezone = 'UTC';

-- Optimize PostgreSQL for Odoo
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET effective_io_concurrency = 200;

-- Reload configuration
SELECT pg_reload_conf();