-- =====================================================================
--  BigRig Movers (BRM) — Freight Logistics Database
--  01 · Physical schema (Oracle 12c+)
--  ---------------------------------------------------------------------
--  Tables and constraints model the BRM scenario and data model exactly:
--    TRUCK, TRAILER, COMBINATION, EMPLOYEE, CUSTOMER, QUOTE, JOB
--  Run this first, then 02_sample_data.sql.
-- =====================================================================

-- Drop in reverse dependency order so foreign keys never block a drop
DROP TABLE job         CASCADE CONSTRAINTS PURGE;
DROP TABLE quote       CASCADE CONSTRAINTS PURGE;
DROP TABLE combination CASCADE CONSTRAINTS PURGE;
DROP TABLE employee    CASCADE CONSTRAINTS PURGE;
DROP TABLE customer    CASCADE CONSTRAINTS PURGE;
DROP TABLE trailer     CASCADE CONSTRAINTS PURGE;
DROP TABLE truck       CASCADE CONSTRAINTS PURGE;


-- TRUCK ---------------------------------------------------------------
CREATE TABLE truck (
    truck_vin              CHAR(17)    NOT NULL,
    truck_rego             CHAR(6)     NOT NULL,
    truck_kms              NUMBER(6)   NOT NULL,
    truck_last_service_kms NUMBER(6),   -- null until the truck's first service
    truck_purchase_cost    NUMBER(8,2) NOT NULL,
    truck_date_purchased   DATE        NOT NULL,
    CONSTRAINT truck_pk PRIMARY KEY ( truck_vin )
);
COMMENT ON COLUMN truck.truck_vin              IS 'Vehicle Identification Number (unique truck identifier)';
COMMENT ON COLUMN truck.truck_rego            IS 'Registration number';
COMMENT ON COLUMN truck.truck_kms             IS 'Total kilometres travelled';
COMMENT ON COLUMN truck.truck_last_service_kms IS 'Odometer reading at last service';
COMMENT ON COLUMN truck.truck_purchase_cost   IS 'Purchase price';
COMMENT ON COLUMN truck.truck_date_purchased  IS 'Date the business purchased the truck';


-- TRAILER -------------------------------------------------------------
CREATE TABLE trailer (
    trailer_code           CHAR(5)     NOT NULL,
    trailer_purchase_cost  NUMBER(8,2) NOT NULL,
    trailer_date_purchased DATE        NOT NULL,
    CONSTRAINT trailer_pk PRIMARY KEY ( trailer_code )
);
COMMENT ON COLUMN trailer.trailer_code           IS 'Five-character trailer code, e.g. REF08';
COMMENT ON COLUMN trailer.trailer_purchase_cost  IS 'Purchase price';
COMMENT ON COLUMN trailer.trailer_date_purchased IS 'Date the business purchased the trailer';


-- CUSTOMER ------------------------------------------------------------
CREATE TABLE customer (
    cust_no         NUMBER(4)    NOT NULL,
    cust_gname      VARCHAR2(30),
    cust_fname      VARCHAR2(30),
    cust_bname      VARCHAR2(40),         -- business name, where applicable
    cust_contact_no CHAR(10)     NOT NULL,
    cust_street     VARCHAR2(40) NOT NULL,
    cust_town       VARCHAR2(30) NOT NULL,
    cust_pcode      CHAR(4)      NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY ( cust_no )
);
COMMENT ON COLUMN customer.cust_no         IS 'Unique customer number';
COMMENT ON COLUMN customer.cust_gname      IS 'Customer given name';
COMMENT ON COLUMN customer.cust_fname      IS 'Customer family name';
COMMENT ON COLUMN customer.cust_bname      IS 'Business name (if applicable)';
COMMENT ON COLUMN customer.cust_contact_no IS 'Contact number';


-- EMPLOYEE (self-referencing reporting line) --------------------------
CREATE TABLE employee (
    emp_no         NUMBER(3)    NOT NULL,
    emp_gname      VARCHAR2(30),
    emp_fname      VARCHAR2(30),
    emp_contact_no CHAR(10)     NOT NULL,
    emp_licenceno  VARCHAR2(11),          -- only recorded for drivers
    emp_role       CHAR(1)      NOT NULL,
    emp_no_manager NUMBER(3),             -- null for managers (who report to the owner)
    CONSTRAINT employee_pk PRIMARY KEY ( emp_no ),
    CONSTRAINT employee_role_ck CHECK ( emp_role IN ( 'B', 'T', 'M', 'D' ) ),
    CONSTRAINT employee_contact_uq UNIQUE ( emp_contact_no ),
    CONSTRAINT employee_licence_uq UNIQUE ( emp_licenceno )
);
COMMENT ON COLUMN employee.emp_no         IS 'Unique employee number';
COMMENT ON COLUMN employee.emp_role       IS 'Role: Manager (B), Truck Dispatcher (T), Mechanic (M), Driver (D)';
COMMENT ON COLUMN employee.emp_licenceno  IS 'Driver licence number (drivers only)';
COMMENT ON COLUMN employee.emp_no_manager IS 'Manager this employee reports to (self-reference)';


-- COMBINATION (a valid truck + trailer pairing) -----------------------
CREATE TABLE combination (
    truck_vin    CHAR(17) NOT NULL,
    trailer_code CHAR(5)  NOT NULL,
    CONSTRAINT combination_pk PRIMARY KEY ( truck_vin, trailer_code )
);
COMMENT ON COLUMN combination.truck_vin    IS 'Truck in the pairing';
COMMENT ON COLUMN combination.trailer_code IS 'Trailer in the pairing';


-- QUOTE ---------------------------------------------------------------
CREATE TABLE quote (
    quote_no             NUMBER(5)    NOT NULL,
    quote_prepared_date  DATE         NOT NULL,
    quote_pref_start_date DATE        NOT NULL,
    quote_start_location VARCHAR2(50) NOT NULL,
    quote_end_location   VARCHAR2(60) NOT NULL,
    quote_cost           NUMBER(6,2)  NOT NULL,
    cust_no              NUMBER(4)    NOT NULL,
    emp_no               NUMBER(3)    NOT NULL,    -- dispatcher who prepared the quote
    CONSTRAINT quote_pk PRIMARY KEY ( quote_no )
);
COMMENT ON COLUMN quote.quote_no             IS 'Unique quote number';
COMMENT ON COLUMN quote.quote_prepared_date  IS 'Date the quote was prepared';
COMMENT ON COLUMN quote.quote_pref_start_date IS 'Customer preferred booking start date';
COMMENT ON COLUMN quote.quote_cost           IS 'Quoted cost';
COMMENT ON COLUMN quote.emp_no               IS 'Truck Dispatcher who prepared the quote';


-- JOB (a quote that has been scheduled) -------------------------------
CREATE TABLE job (
    job_no                  NUMBER(5)   NOT NULL,
    job_pickup_dt           DATE        NOT NULL,
    job_intended_dropoff_dt DATE        NOT NULL,
    job_cost                NUMBER(6,2),            -- revised cost; null when same as quote
    job_payment_made        CHAR(1)     NOT NULL,
    quote_no                NUMBER(5)   NOT NULL,
    sched_emp_no            NUMBER(3)   NOT NULL,   -- dispatcher who scheduled the job
    driver_emp_no           NUMBER(3)   NOT NULL,   -- driver assigned
    trailer_code            CHAR(5)     NOT NULL,
    truck_vin               CHAR(17)    NOT NULL,
    CONSTRAINT job_pk PRIMARY KEY ( job_no ),
    CONSTRAINT job_payment_ck CHECK ( job_payment_made IN ( 'Y', 'N' ) ),
    CONSTRAINT job_dropoff_ck CHECK ( job_intended_dropoff_dt > job_pickup_dt ),
    CONSTRAINT job_quote_uq   UNIQUE ( quote_no )   -- each quote becomes at most one job
);
COMMENT ON COLUMN job.job_no           IS 'Unique job number';
COMMENT ON COLUMN job.job_cost         IS 'Revised job cost (recorded only when it differs from the quote)';
COMMENT ON COLUMN job.job_payment_made IS 'Whether the customer has paid (Y/N)';
COMMENT ON COLUMN job.sched_emp_no     IS 'Truck Dispatcher who assigned the quote to a job';
COMMENT ON COLUMN job.driver_emp_no    IS 'Driver assigned to the job';


-- FOREIGN KEYS --------------------------------------------------------
ALTER TABLE employee
    ADD CONSTRAINT employee_manager_fk FOREIGN KEY ( emp_no_manager )
        REFERENCES employee ( emp_no );

ALTER TABLE combination
    ADD CONSTRAINT combination_truck_fk FOREIGN KEY ( truck_vin )
        REFERENCES truck ( truck_vin );
ALTER TABLE combination
    ADD CONSTRAINT combination_trailer_fk FOREIGN KEY ( trailer_code )
        REFERENCES trailer ( trailer_code );

ALTER TABLE quote
    ADD CONSTRAINT quote_customer_fk FOREIGN KEY ( cust_no )
        REFERENCES customer ( cust_no );
ALTER TABLE quote
    ADD CONSTRAINT quote_employee_fk FOREIGN KEY ( emp_no )
        REFERENCES employee ( emp_no );

ALTER TABLE job
    ADD CONSTRAINT job_quote_fk FOREIGN KEY ( quote_no )
        REFERENCES quote ( quote_no );
ALTER TABLE job
    ADD CONSTRAINT job_sched_emp_fk FOREIGN KEY ( sched_emp_no )
        REFERENCES employee ( emp_no );
ALTER TABLE job
    ADD CONSTRAINT job_driver_emp_fk FOREIGN KEY ( driver_emp_no )
        REFERENCES employee ( emp_no );
ALTER TABLE job
    ADD CONSTRAINT job_combination_fk FOREIGN KEY ( truck_vin, trailer_code )
        REFERENCES combination ( truck_vin, trailer_code );
