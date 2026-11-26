 Dataset Card: Synthetic Vehicle Telematics Data

 1. Dataset Overview
- Dataset File Name: `synthetic_telemetry_data-selected-columns.csv` (stored unmodified in `data/raw/`)
- Source & Origin: Synthetic OBD-II / Commercial Fleet Telematics Sensor Dataset (Kaggle / Synthetic Telematics Benchmark)
- License: Public / Educational Use Permitted
- Format: Comma-Separated Values (`.csv`)
- File Size & Dimensions: 316,071 bytes (~308.7 KB) — 1,970 records × 10 columns (exceeds the 500-record minimum requirement)
- Date Collected / Downloaded: November 2026
- Granularity (What One Record Represents): One record represents a single timestamped OBD-II telematics sensor snapshot captured from one of 50 commercial fleet vehicles (`VEH0000`–`VEH0049`), recording vehicle brand, odometer reading, engine temperature, engine RPM, oil pressure, coolant temperature, fuel tank percentage, and fuel consumption rate (liters per hour).
- Privacy & Anonymization Status: Contains zero Personally Identifiable Information (PII)—no driver names, phone numbers, national IDs, or home addresses are present. Vehicles are identified solely by anonymized codes (`VEH0000` through `VEH0049`).

 2. Raw Data Quality Audit (Unmodified Inspection)
*Per Phase II instructions, no records or values have been modified in `data/raw/`. The following exact counts document real anomalies detected during inspection to be cleaned in Phase IV:*

| Quality Dimension | Column(s) Checked | Exact Issue Count | Specific Observation & Phase IV Cleaning Plan |
|---|---|---|---|
| Missing / Null Cells | All 10 columns | 0 missing cells (`0` nulls across all 1,970 rows) | Dataset is structurally complete; `NOT NULL` constraints can be safely enforced after type casting. |
| Exact Full-Row Duplicates | All 10 columns combined | 0 exact duplicate rows | No byte-for-byte identical rows exist. |
| Duplicate Entity-Timestamp Keys | `(vehicle_id, timestamp)` | 40 duplicate pairs | Two different sensor snapshots share the exact same `vehicle_id` and `timestamp` (e.g., `VEH0000` at `2023-01-01 00:00:00` or overlapping minute-level logs); requires surrogate `reading_id` PK and deduplication/resolution logic in Phase IV. |
| Out-of-Order Timestamps in Raw Sequence | `timestamp` grouped by `vehicle_id` | 847 row transitions | Rows are ordered by ascending `odometer_reading` rather than chronological `timestamp` (e.g., row 2 is `01:28:00` at `31428.09 km` while row 3 is `01:27:00` at `31463.27 km`). |
| Odometer Decreases When Sorted Chronologically | `odometer_reading` sorted by `timestamp` | 834 odometer drops | Because raw rows were generated sequentially by odometer while timestamps jittered within trip windows, sorting strictly by `timestamp` causes apparent odometer rollbacks; Phase IV ingestion must validate monotonic odometer progression. |
| Data Type Formatting (Text & High-Precision Floats) | `timestamp`, numeric sensor columns | 1,970 text timestamps; 1,970 6-decimal floats | `timestamp` is stored as plain text (`YYYY-MM-DD HH:MM:SS`) requiring `TO_TIMESTAMP()`; sensor values contain 6+ decimal places (`31381.561743`) requiring `ROUND(..., 2)` for clean Oracle `NUMBER` storage. |
| Operational Threshold Breaches (Alert Candidates) | `engine_temp_c`, `oil_pressure_psi`, `coolant_temp_c`, `fuel_level_percent` | 61 high engine temp (`>105°C`), 17 low oil pressure (`<20 psi`), 9 high coolant temp (`>98°C`), 225 low fuel (`<10%`) | Valid operational telemetry anomalies that PL/SQL ingestion procedures will automatically convert into `SAFETY_AND_FAULT_ALERTS` records. |
| Zero Fuel Consumption While Engine Running | `fuel_consumption_lph` & `engine_rpm` | 106 rows (`fuel_consumption_lph = 0.0` while `engine_rpm >= 700`) | Represents fuel-cut coasting or sensor zero-dropouts; requires sensor validation rule in Phase IV. |