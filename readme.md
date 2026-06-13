# Freight Logistics Database — SQL & MongoDB

**A relational database for a freight/haulage company — schema, data manipulation, analytical queries, JSON generation, and a MongoDB document model.** Built on an Oracle base schema (customers, trucks, trailers, truck-trailer combinations); this work adds the employee/job/quote core and a full set of querying tasks.

> 🔒 **Private portfolio repo.** This is original coursework (Monash FIT2094). Kept private to respect academic-integrity rules; shared directly with reviewers on request.

---

## Domain

A transport company quotes customers for freight jobs, schedules them, and assigns a driver, a truck, and a trailer. Employees are drivers, dispatchers, mechanics, or managers (with a self-referencing manager hierarchy). Trucks are serviced by mechanics against defined tasks.

## What I built (Tasks 1–6)

| File | Task | Skills shown |
|---|---|---|
| `T1-brm-schema.sql` | **Schema** — `employee`, `job`, `quote` + all FKs | PK/`CHECK`/`UNIQUE` constraints, a **self-referencing FK** (employee → manager), a **composite FK** (trailer + truck → valid combination) |
| `T2-brm-insert.sql` | **Data load** | `INSERT` population of the model |
| `T3-brm-dm.sql` | **Data manipulation** | `SEQUENCE`s with `nextval`/`currval`, **subquery-driven inserts** (look up people by name, never hard-coded IDs), `UPDATE` and `DELETE` via correlated subqueries |
| `T4-brm-mods.sql` | **Schema evolution** | `ALTER TABLE` (new column with `DEFAULT` + `CHECK`), data back-fill, and a new 3-table servicing subsystem (`service`, `task_lookup`, `service_task`) with FKs |
| `T5-brm-select.sql` | **Analytical queries** | see below |
| `T6-brm-json.sql` | **Relational → JSON** | `JSON_OBJECT` / `JSON_ARRAYAGG` building nested customer documents with computed paid/unpaid totals |
| `T6-brm-mongo.mongodb.js` | **MongoDB** | document model: `insertMany` (nested docs + arrays), `find` with `$gt` on a nested field + regex + projection, `insertOne`, `updateOne` with `$push` / `$set` |

## The analytical queries (T5)

1. **High-value customers** — customers with more than one quote *and* an average quote cost above the system-wide average. Uses `GROUP BY`, `HAVING`, a correlated subquery, `NVL` (business-name fallback), and `$`-formatted output.
2. **Employee roster with manager** — a **self-join** (`LEFT OUTER JOIN employee → manager`), role-code decoding via `CASE`, and a **scalar subquery** counting jobs each dispatcher scheduled.
3. **Truck-trailer utilisation** — a multi-table join across `combination`, `truck`, `trailer`, `job`, `quote`; counts jobs per combination, sums quoted revenue, and classifies each combo as *Never Used / Standard Use / High Use* against the **computed average usage**, with `LEFT OUTER JOIN`s so unused combinations still appear.

## Highlights

- **SQL across the full lifecycle** — design (DDL), populate (DML), evolve (`ALTER`), and analyse (`SELECT`).
- **Lookups by natural key, not magic numbers** — inserts resolve people/customers by name via subqueries, so the scripts are robust to changing IDs.
- **Same data, two paradigms** — the customer view is produced both as relational-generated **JSON** (Oracle) and as a native **MongoDB** document collection, showing the relational ↔ document mapping.

## How to run

**Oracle (Tasks 1–6 JSON):** in SQL Developer, run the files in `scripts/sql/` in order —
`brm-schema-insert.sql` (base) → `T1` → `T2` → `T3` → `T4` → `T5` → `T6-brm-json.sql`.

**MongoDB (Task 6):** open `scripts/mongodb/T6-brm-mongo.mongodb.js` in the MongoDB shell / VS Code MongoDB extension and run against your database.

## Repository structure

```
.
├── scripts/
│   ├── sql/
│   │   ├── brm-schema-insert.sql   # provided base schema + data
│   │   ├── T1-brm-schema.sql       # schema: employee, job, quote + FKs
│   │   ├── T2-brm-insert.sql       # data load
│   │   ├── T3-brm-dm.sql           # sequences, inserts, update, delete
│   │   ├── T4-brm-mods.sql         # ALTER + servicing subsystem
│   │   ├── T5-brm-select.sql       # 3 analytical queries
│   │   └── T6-brm-json.sql         # relational -> JSON
│   └── mongodb/
│       └── T6-brm-mongo.mongodb.js # MongoDB document model + queries
├── readme.md
└── .gitignore
```

## Skills shown

Oracle SQL (DDL · DML · `ALTER`) · constraints & referential integrity · self-referencing & composite FKs · sequences · analytical `SELECT` (joins, `GROUP BY`/`HAVING`, correlated & scalar subqueries, `CASE`, window-style categorisation) · `JSON_OBJECT`/`JSON_ARRAYAGG` · **MongoDB** (document modelling, CRUD, nested updates).

## Author

**Tuan Ngoc Chu** — FIT2094 Databases, Monash University (Semester 1, 2026).
