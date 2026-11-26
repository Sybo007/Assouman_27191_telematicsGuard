-- ============================================================================
-- Student Name : Assouman SIBOMANA
-- Student ID   : 27191
-- Group        : Group C
-- Project Name : TGuard (tguard)
-- Script       : 05_verify.sql - Verify PDB, user, tablespaces, and archivelog
-- ============================================================================

-- 1. Verify PDB exists and is READ WRITE
SELECT name AS pdb_name, open_mode, restricted
FROM v$pdbs;

-- 2. Verify archive log mode of the database
SELECT name AS cdb_name, log_mode
FROM v$database;

-- 3. Verify admin user's default and temporary tablespaces
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'ASSOUMAN_ADMIN';

-- 4. Verify each tablespace with size, autoextend setting, and max size
SELECT
  tablespace_name,
  ROUND(bytes / (1024 * 1024), 2) AS size_mb,
  autoextensible,
  ROUND(maxbytes / (1024 * 1024), 2) AS max_size_mb,
  file_name
FROM dba_data_files
WHERE tablespace_name IN ('TGUARD_DATA', 'TGUARD_IDX')
UNION ALL
SELECT
  tablespace_name,
  ROUND(bytes / (1024 * 1024), 2) AS size_mb,
  autoextensible,
  ROUND(maxbytes / (1024 * 1024), 2) AS max_size_mb,
  file_name
FROM dba_temp_files
WHERE tablespace_name = 'TGUARD_TEMP'
ORDER BY tablespace_name;