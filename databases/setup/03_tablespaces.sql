-- ============================================================================
-- Student Name : Assouman SIBOMANA
-- Student ID   : 27191
-- Group        : Group C
-- Project Name : TGuard (tguard)
-- Script       : 03_tablespaces.sql - Create data, index, and temp tablespaces
-- ============================================================================

ALTER SESSION SET CONTAINER = c_27191_assouman_tguard_db;

-- 1. Data tablespace: 100M, AUTOEXTEND ON NEXT 10M MAXSIZE 1G
CREATE TABLESPACE tguard_data
  DATAFILE 'C:\APP\LENOVO\PRODUCT\26AI\ORADATA\FREE\C_27191_ASSOUMAN_TGUARD_DB\tguard_data01.dbf'
  SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

-- 2. Index tablespace: 50M, AUTOEXTEND ON NEXT 10M MAXSIZE 500M
CREATE TABLESPACE tguard_idx
  DATAFILE 'C:\APP\LENOVO\PRODUCT\26AI\ORADATA\FREE\C_27191_ASSOUMAN_TGUARD_DB\tguard_idx01.dbf'
  SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

-- 3. Temporary tablespace: 50M, AUTOEXTEND ON NEXT 10M MAXSIZE 500M
CREATE TEMPORARY TABLESPACE tguard_temp
  TEMPFILE 'C:\APP\LENOVO\PRODUCT\26AI\ORADATA\FREE\C_27191_ASSOUMAN_TGUARD_DB\tguard_temp01.dbf'
  SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

-- Assign default/temp tablespaces and unlimited quotas to assouman_admin
ALTER USER assouman_admin
  DEFAULT TABLESPACE tguard_data
  TEMPORARY TABLESPACE tguard_temp
  QUOTA UNLIMITED ON tguard_data
  QUOTA UNLIMITED ON tguard_idx;