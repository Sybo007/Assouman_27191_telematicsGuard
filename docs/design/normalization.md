 Logical Data Dictionary (3NF) — TelematicsGuard

 1. Entity-Relationship Cardinality & Optionality Summary (Crow's-Foot Notation)
 `VEHICLES` (1) —— (0..1) `TELEMATICS_DEVICES`: Each vehicle has zero or one active OBD-II device installed; each device is mounted in exactly one vehicle[cite: 7].
 `VEHICLES` (1) —— (0..) `TRIPS`: Each vehicle may undertake zero or many trips; each trip uses exactly one vehicle[cite: 7].
 `DRIVERS` (1) —— (0..) `TRIPS`: Each driver may be assigned to zero or many trips; each trip is operated by exactly one driver[cite: 7].
 `TELEMATICS_DEVICES` (1) —— (0..) `TELEMETRY_READINGS`: Each telematics device transmits zero or many sensor packets; each reading originates from exactly one device[cite: 7].
 `TRIPS` (0..1) —— (0..) `TELEMETRY_READINGS`: A trip generates zero or many telemetry readings; a reading may belong to zero or one active trip (idle/yard diagnostics can occur outside an active dispatch)[cite: 7].
 `TELEMETRY_READINGS` (1) —— (0..) `SAFETY_AND_FAULT_ALERTS`: A single telemetry reading may trigger zero or many alerts (e.g., simultaneous engine overheat and low oil pressure); each alert is triggered by one reading[cite: 7].
 `VEHICLES` (1) —— (0..) `SAFETY_AND_FAULT_ALERTS`: Each vehicle accumulates zero or many safety/fault alerts; each alert belongs to exactly one vehicle[cite: 7].
 `SAFETY_AND_FAULT_ALERTS` (0..1) —— (0..1) `MAINTENANCE_ORDERS`: A critical alert generates zero or one maintenance order; a maintenance order may reference one triggering alert (or none if scheduled preventively by mileage)[cite: 7].
 `VEHICLES` (1) —— (0..) `MAINTENANCE_ORDERS`: Each vehicle undergoes zero or many maintenance orders; each maintenance order services exactly one vehicle[cite: 7].
 `SYSTEM_AUDIT_LOG` (Standalone): Captures database-level trigger audit events across tables without foreign-key cascade dependencies so audit history remains immutable[cite: 7].

---

 2. Table & Column Definitions

 Table 1: `VEHICLES`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `vehicle_id` | PK | Yes | Yes | Unique system identifier for each commercial fleet vehicle (`VEH0000`–`VEH0049`)[cite: 7, 8]. |
| `brand` | — | Yes | No | Vehicle manufacturer brand name (e.g., BMW, Toyota, Audi, Ford, Kia)[cite: 7, 8]. |
| `plate_number` | — | Yes | Yes | Official government registration license plate number[cite: 7, 8]. |
| `current_odometer` | — | Yes | No | Latest validated cumulative distance traveled in kilometers[cite: 7, 8]. |
| `operational_status` | — | Yes | No | Current dispatch eligibility (`ACTIVE`, `MAINTENANCE_HOLD`, `RETIRED`)[cite: 7, 8]. |

 Table 2: `TELEMATICS_DEVICES`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `device_id` | PK | Yes | Yes | Unique identifier for each physical OBD-II hardware unit[cite: 7, 8]. |
| `vehicle_id` | FK | Yes | Yes | References `VEHICLES.vehicle_id`; enforces one active device per vehicle[cite: 7, 8]. |
| `imei_serial` | — | Yes | Yes | Hardware International Mobile Equipment Identity / serial number[cite: 7, 8]. |
| `firmware_version` | — | Yes | No | Installed device firmware release version[cite: 7, 8]. |
| `device_status` | — | Yes | No | Hardware connectivity state (`ONLINE`, `OFFLINE`, `FAULTY`)[cite: 7, 8]. |

 Table 3: `DRIVERS`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `driver_id` | PK | Yes | Yes | Unique anonymized identifier for each fleet operator[cite: 7, 8]. |
| `driver_code` | — | Yes | Yes | Internal HR/dispatch badge code (anonymized, no PII)[cite: 7, 8]. |
| `license_category` | — | Yes | No | Authorized commercial driving license class (e.g., B, C, D)[cite: 7, 8]. |
| `safety_score` | — | Yes | No | Computed 0–100 behavioral safety index updated by PL/SQL functions[cite: 7, 8]. |
| `driver_status` | — | Yes | No | Employment/eligibility state (`ACTIVE`, `SUSPENDED`, `INACTIVE`)[cite: 7, 8]. |

 Table 4: `TRIPS`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `trip_id` | PK | Yes | Yes | Unique identifier for each scheduled or completed fleet journey[cite: 7, 8]. |
| `vehicle_id` | FK | Yes | No | References `VEHICLES.vehicle_id` assigned to execute the trip[cite: 7, 8]. |
| `driver_id` | FK | Yes | No | References `DRIVERS.driver_id` operating the vehicle on the trip[cite: 7, 8]. |
| `start_time` | — | Yes | No | Date and time the trip commenced[cite: 7, 8]. |
| `end_time` | — | No | No | Date and time the trip concluded (`NULL` while trip is in progress)[cite: 7, 8]. |
| `origin_zone` | — | Yes | No | Departure depot, hub, or geographic zone[cite: 7, 8]. |
| `destination_zone` | — | Yes | No | Arrival depot, customer site, or geographic zone[cite: 7, 8]. |
| `trip_status` | — | Yes | No | Lifecycle status (`SCHEDULED`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED`)[cite: 7, 8]. |

 Table 5: `TELEMETRY_READINGS`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `reading_id` | PK | Yes | Yes | Surrogate primary key identifying each individual OBD-II sensor packet[cite: 7, 8]. |
| `device_id` | FK | Yes | No | References `TELEMATICS_DEVICES.device_id` that transmitted the packet[cite: 7, 8]. |
| `trip_id` | FK | No | No | References `TRIPS.trip_id` if recorded during an active dispatch[cite: 7, 8]. |
| `recorded_at` | — | Yes | No | Exact timestamp when the OBD-II packet was captured[cite: 7, 8]. |
| `odometer_km` | — | Yes | No | Cumulative odometer distance in kilometers reported in that packet[cite: 7, 8]. |
| `engine_temp_c` | — | Yes | No | Engine operating temperature in degrees Celsius[cite: 7, 8]. |
| `engine_rpm` | — | Yes | No | Engine crankshaft rotational speed in revolutions per minute[cite: 7, 8]. |
| `oil_pressure_psi` | — | Yes | No | Engine lubricating oil pressure in pounds per square inch (PSI)[cite: 7, 8]. |
| `coolant_temp_c` | — | Yes | No | Radiator coolant temperature in degrees Celsius[cite: 7, 8]. |
| `fuel_level_pct` | — | Yes | No | Remaining fuel tank capacity expressed as a percentage (0–100%)[cite: 7, 8]. |
| `fuel_consumption_lph` | — | Yes | No | Instantaneous fuel burn rate in liters per hour (LPH)[cite: 7, 8]. |

 Table 6: `SAFETY_AND_FAULT_ALERTS`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `alert_id` | PK | Yes | Yes | Unique identifier for each detected sensor breach or fault alert[cite: 7, 8]. |
| `reading_id` | FK | Yes | No | References `TELEMETRY_READINGS.reading_id` that triggered the alert[cite: 7, 8]. |
| `vehicle_id` | FK | Yes | No | References `VEHICLES.vehicle_id` experiencing the fault or violation[cite: 7, 8]. |
| `alert_category` | — | Yes | No | Classification (`ENGINE_OVERHEAT`, `LOW_OIL_PRESSURE`, `COOLANT_HIGH`, `LOW_FUEL`)[cite: 7, 8]. |
| `severity_level` | — | Yes | No | Urgency tier (`INFO`, `WARNING`, `CRITICAL`)[cite: 7, 8]. |
| `is_resolved` | — | Yes | No | Resolution flag (`Y` or `N`); unresolved `CRITICAL` rows block vehicle dispatch[cite: 7, 8]. |
| `created_at` | — | Yes | No | Timestamp when the alert was generated[cite: 7, 8]. |

 Table 7: `MAINTENANCE_ORDERS`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `order_id` | PK | Yes | Yes | Unique identifier for each workshop repair or service ticket[cite: 7, 8]. |
| `vehicle_id` | FK | Yes | No | References `VEHICLES.vehicle_id` scheduled for servicing[cite: 7, 8]. |
| `alert_id` | FK | No | Unique | References `SAFETY_AND_FAULT_ALERTS.alert_id` if triggered by a fault alert[cite: 7, 8]. |
| `component_type` | — | Yes | No | Target subsystem (`COOLING_AND_ENGINE`, `OIL_SYSTEM`, `ROUTINE_SERVICE`)[cite: 7, 8]. |
| `scheduled_date` | — | Yes | No | Target date for workshop intake[cite: 7, 8]. |
| `completed_date` | — | No | No | Actual date repairs were verified complete (`NULL` until closed)[cite: 7, 8]. |
| `repair_cost` | — | Yes | No | Total maintenance expenditure in local currency (RWF)[cite: 7, 8]. |
| `order_status` | — | Yes | No | Ticket workflow state (`OPEN`, `IN_PROGRESS`, `COMPLETED`)[cite: 7, 8]. |

 Table 8: `SYSTEM_AUDIT_LOG`
| Column Name | Key | Required | Unique | Business Meaning |
|---|---|---|---|---|
| `audit_id` | PK | Yes | Yes | Unique sequence identifier for each logged security/DML event[cite: 7, 8]. |
| `table_name` | — | Yes | No | Name of the database table targeted by the DML operation[cite: 7, 8]. |
| `operation_type` | — | Yes | No | SQL action attempted (`INSERT`, `UPDATE`, `DELETE`)[cite: 7, 8]. |
| `db_user` | — | Yes | No | Oracle session username executing the action[cite: 7, 8]. |
| `action_timestamp` | — | Yes | No | Exact date and time the action was intercepted[cite: 7, 8]. |
| `status_flag` | — | Yes | No | Outcome enforced by trigger (`ALLOWED` or `DENIED`)[cite: 7, 8]. |
| `details` | — | Yes | No | Descriptive explanation of the business rule or violation logged[cite: 7, 8]. |