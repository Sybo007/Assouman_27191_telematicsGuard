-- ============================================================================
-- Student Name : Assouman SIBOMANA
-- Student ID   : 27191
-- Group        : Group C
-- Project Name : TGuard (tguard)
-- Script       : 04_archive_log.sql - Check and enable CDB ARCHIVELOG mode
-- ============================================================================

-- Why archive logging cannot be enabled for a single PDB:
-- In Oracle Multitenant architecture, all PDBs inside a CDB share a single
-- set of online redo log files and a single redo thread managed by CDB$ROOT.
-- Because redo generation and log archiving occur at the physical CDB instance
-- level rather than per pluggable container, ARCHIVELOG mode must be configured
-- for the entire CDB as a whole.

CONNECT / AS SYSDBA
ALTER SESSION SET CONTAINER = CDB$ROOT;

-- Check current archive log mode before change
ARCHIVE LOG LIST;

-- Restart CDB in MOUNT state to enable ARCHIVELOG mode (local installation only)
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

-- Re-open all PDBs and confirm ARCHIVELOG is active
ALTER PLUGGABLE DATABASE ALL OPEN;
ARCHIVE LOG LIST;