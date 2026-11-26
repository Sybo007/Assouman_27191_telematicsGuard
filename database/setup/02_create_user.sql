-- ============================================================================
-- Student Name : Assouman SIBOMANA
-- Student ID   : 27191
-- Group        : Group C
-- Project Name : TGuard (tguard)
-- Script       : 02_create_user.sql - Create PDB admin user and grant DBA
-- ============================================================================

ALTER SESSION SET CONTAINER = c_27191_assouman_tguard_db;

CREATE USER assouman_admin IDENTIFIED BY assouman
  CONTAINER = CURRENT;

GRANT DBA TO assouman_admin CONTAINER = CURRENT;

-- Confirm connection as assouman_admin
CONNECT assouman_admin/assouman@localhost:1521/c_27191_assouman_tguard_db
SHOW USER;
SHOW CON_NAME;