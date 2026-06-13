# Data Model

The BigRig Movers database is modelled as seven related tables.

<!-- Save the ER diagram image as docs/data_model.png so it renders here -->
![BRM data model](data_model.png)

## Entities

| Table | Holds | Key points |
|---|---|---|
| **TRUCK** | Prime movers owned by the business | PK `truck_vin`; records rego, total km, last-service km, purchase cost & date |
| **TRAILER** | Trailers owned by the business | PK `trailer_code` (e.g. `REF08`); purchase cost & date |
| **COMBINATION** | Valid truck + trailer pairings | Composite PK (`truck_vin`, `trailer_code`); both columns are foreign keys |
| **EMPLOYEE** | Staff and their reporting line | PK `emp_no`; role ∈ Manager/Dispatcher/Mechanic/Driver; self-referencing `emp_no_manager` |
| **CUSTOMER** | People/businesses requesting hires | PK `cust_no`; name, optional business name, address, contact |
| **QUOTE** | Price quotes prepared by a dispatcher | PK `quote_no`; start/end locations, cost, prepared date; FK to customer & employee |
| **JOB** | A quote that has been scheduled | PK `job_no`; pickup/drop-off times, revised cost, payment flag; FK to quote, combination, scheduling dispatcher & driver |

## Relationships

- **TRUCK** *is used in* many **COMBINATION**s; **TRAILER** *is combined* in many **COMBINATION**s.
- A **COMBINATION** *is used for* many **JOB**s (a job references its truck+trailer combination).
- **EMPLOYEE** *manages* **EMPLOYEE** — a self-referencing reporting line; every non-manager reports to a manager.
- **EMPLOYEE** *schedules* and *drives* **JOB**s (two separate roles: `sched_emp_no`, `driver_emp_no`), and *prepares* **QUOTE**s.
- **CUSTOMER** *requests* many **QUOTE**s; each **QUOTE** *becomes* at most one **JOB** (`quote_no` is unique on `JOB`).

## Business rules enforced in the schema

- `employee.emp_role` restricted to `B` (Manager), `T` (Dispatcher), `M` (Mechanic), `D` (Driver).
- `job.job_payment_made` restricted to `Y`/`N`.
- `job.job_intended_dropoff_dt` must be later than `job_pickup_dt`.
- A quote maps to one job at most (`UNIQUE (quote_no)` on `JOB`).
- Driver contact number and licence number are unique.

See [`scripts/sql/01_create_schema.sql`](../scripts/sql/01_create_schema.sql) for the full DDL.
