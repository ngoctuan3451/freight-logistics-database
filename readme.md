# BigRig Movers — Freight Logistics Database (SQL & MongoDB)

**A relational database for a truck-and-trailer hire company — schema, sample data, analytical queries, relational-to-JSON export, and a MongoDB document model.** Built from a business scenario and data model, in Oracle SQL with a parallel MongoDB version.

---

## Scenario

**BigRig Movers (BRM)** hires out prime movers (trucks) and trailers so customers can move goods between locations. Trucks and trailers are owned and purchased separately, and are paired into **combinations** as each customer's needs require.

Staff each hold one of four roles — **Manager, Truck Dispatcher, Mechanic, or Driver** — and report up a management line to the business owner. A **Truck Dispatcher** quotes a customer based on the preferred start date, pickup and drop-off locations; the quote records its cost, date, and the dispatcher who prepared it. If the customer accepts, the quote **becomes a job**: a truck-trailer combination and a driver are assigned, pickup and drop-off times are negotiated, a (sometimes revised) cost is set, and payment is tracked. Quotes that are never accepted simply remain unfulfilled.

The database gives BRM a single source of truth to manage fleet, staff, quotes, and jobs — and to answer operational questions like *which customers are most valuable, who is scheduling the work,* and *how heavily each truck-trailer combination is used.*

## Data model

Seven related tables — `TRUCK`, `TRAILER`, `COMBINATION`, `EMPLOYEE`, `CUSTOMER`, `QUOTE`, `JOB` — with a self-referencing employee hierarchy and a composite truck+trailer key.

📐 **See [`docs/data-model.md`](docs/data-model.md)** for the full entity/relationship breakdown and the ER diagram.

## What this project does

| Step | File | Highlights |
|---|---|---|
| **1. Schema** | `scripts/sql/01_create_schema.sql` | All 7 tables with PKs, FKs, `CHECK`/`UNIQUE` constraints, a **self-referencing FK** (employee → manager) and a **composite FK** (job → valid truck+trailer combination) |
| **2. Sample data** | `scripts/sql/02_sample_data.sql` | A small synthetic dataset that populates every table |
| **3. Analysis** | `scripts/sql/03_analysis.sql` | Three business questions (see below) |
| **4. JSON export** | `scripts/sql/04_json_export.sql` | `JSON_OBJECT` / `JSON_ARRAYAGG` build a nested customer document straight from the relational tables |
| **5. MongoDB** | `scripts/mongodb/customers.mongodb.js` | The same customer view as native documents: `insertMany`, `find` with `$gt` on a nested field + regex + projection, `insertOne`, `updateOne` with `$push` / `$set` |

## The analytical questions

1. **High-value customers** — customers with more than one quote *and* an average quote cost above the system-wide average (`GROUP BY` + `HAVING` + a subquery).
2. **Employee roster & reporting line** — each employee, their decoded role, who they report to (a **self-join**), and how many jobs each dispatcher has scheduled (a **scalar subquery**).
3. **Truck-trailer utilisation** — jobs and quoted revenue per combination, classified *Never used / Standard use / High use* against the average, with `LEFT JOIN`s so unused combinations still appear.

## How to run

**Oracle (SQL Developer or any 12c+ connection)** — run in order:
```sql
@scripts/sql/01_create_schema.sql
@scripts/sql/02_sample_data.sql
@scripts/sql/03_analysis.sql
@scripts/sql/04_json_export.sql
```

**MongoDB** — open `scripts/mongodb/customers.mongodb.js` in the MongoDB shell or the VS Code MongoDB extension and run it against your database.

## Repository structure

```
.
├── scripts/
│   ├── sql/
│   │   ├── 01_create_schema.sql   # 7-table schema + constraints
│   │   ├── 02_sample_data.sql     # synthetic sample dataset
│   │   ├── 03_analysis.sql        # 3 analytical queries
│   │   └── 04_json_export.sql     # relational -> JSON
│   └── mongodb/
│       └── customers.mongodb.js   # MongoDB document model + queries
├── docs/
│   ├── data-model.md              # entities, relationships, ER diagram
│   └── data_model.png             # ER diagram image
├── readme.md
└── .gitignore
```

## Skills shown

Relational schema design from a brief · constraints & referential integrity · self-referencing & composite foreign keys · analytical SQL (joins, `GROUP BY`/`HAVING`, correlated & scalar subqueries, `CASE`, usage categorisation) · `JSON_OBJECT`/`JSON_ARRAYAGG` · **MongoDB** document modelling and CRUD.

## Author

**Tuan Ngoc Chu** — based on coursework for FIT2094 Databases, Monash University, reworked and documented as a portfolio project.
