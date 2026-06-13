--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T1-brm-schema.sql

--Student ID: 35697601
--Student Name: Tuan Ngoc Chu

/*
    -- Submission Declaration - must not be removed - removal will result in no marks being awarded --
    In submitting this SQL script, I confirm that this is my own work without coding assistance from Generative AI
*/


/* drop table statements - do not remove*/

drop table employee cascade constraints purge;

drop table job cascade constraints purge;

drop table quote cascade constraints purge;

-- Task 1 Add Create table statements for the Missing TABLES below
-- Ensure all column comments, and constraints (other than FK's)
-- are included. FK constraints are to be added at the end of this script

-- EMPLOYEE
create table employee (
    emp_no         number(3) not null,
    emp_gname      varchar2(30),
    emp_fname      varchar2(30),
    emp_contact_no char(10) not null,
    emp_licenceno  varchar2(11),
    emp_role       char(1) not null,
    emp_no_manager number(3)  -- null allowed for managers who do not have a manager like the CEO or top manager
);

comment on column employee.emp_no is
    'Employee Number';
comment on column employee.emp_gname is
    'Employee Given Name';
comment on column employee.emp_fname is
    'Employee Family Name';
comment on column employee.emp_contact_no is
    'Employee Contact Number';
comment on column employee.emp_licenceno is
    'Employee Licence Number (only for drivers)';
comment on column employee.emp_role is
    'Employee role - Manager (B), Truck Dispatcher (T), 
Mechanic (M), or Driver (D)';
comment on column employee.emp_no_manager is
    'Employee number of the manager of this employee';

alter table employee add constraint employee_pk primary key ( emp_no );
alter table employee
    add constraint ck_employee_emp_role
        check ( emp_role in ( 'B',
                              'T',
                              'M',
                              'D' ) );
alter table employee add constraint uq_emp_contact_no unique ( emp_contact_no );
alter table employee add constraint uq_emp_licenceno unique ( emp_licenceno );

-- JOB
create table job (
    job_no                  number(5) not null,
    job_pickup_dt           date not null,
    job_intended_dropoff_dt date not null,
    job_cost                number(6,2),
    job_payment_made        char(1) not null,
    quote_no                number(5) not null,
    sched_emp_no            number(3) not null,
    driver_emp_no           number(3) not null,
    trailer_code            char(5) not null,
    truck_vin               char(17) not null
);

comment on column job.job_no is
    'Job Number';
comment on column job.job_pickup_dt is
    'Job scheduled pickup date and time';
comment on column job.job_intended_dropoff_dt is
    'Job intended dropoff date and time';
comment on column job.job_cost is
    'The actual job cost (if different from the quote cost)';
comment on column job.job_payment_made is
    'Flag to note whether the job has been paid (Y or N)';
comment on column job.quote_no is
    'Quote number for the job';
comment on column job.sched_emp_no is
    'Employee number of the truck dispatcher who scheduled the job';
comment on column job.driver_emp_no is
    'Employee number of the driver assigned to the job';
comment on column job.trailer_code is
    'Identifier for trailer assigned to the job';
comment on column job.truck_vin is
    'Vehicle Identification Number of truck assigned to the job';

alter table job add constraint job_pk primary key ( job_no );
alter table job
    add constraint ck_job_job_payment_made check ( job_payment_made in ( 'Y',
                                                                         'N' ) );
alter table job add constraint uq_job_quote_no unique ( quote_no );

alter table job add constraint ck_job_intended_dropoff_dt check ( job_intended_dropoff_dt > job_pickup_dt
);  -- Ensure that the intended dropoff date and time is after the pickup date and time



-- QUOTE
create table quote (
    quote_no              number(5) not null,
    quote_prepared_date   date not null,
    quote_pref_start_date date not null,
    quote_start_location  varchar2(50) not null,
    quote_end_location    varchar2(60) not null,
    quote_cost            number(6,2) not null,
    cust_no               number(4) not null,
    emp_no                number(3) not null
);

comment on column quote.quote_no is
    'Quote Number';
comment on column quote.quote_prepared_date is
    'Date the quote was prepared';
comment on column quote.quote_pref_start_date is
    'Preferred start date for the job';
comment on column quote.quote_start_location is
    'The start location for the quote';
comment on column quote.quote_end_location is
    'The end location (destination) for the quote';
comment on column quote.quote_cost is
    'The quoted cost';
comment on column quote.cust_no is
    'Identifier for customer who requested the quote';
comment on column quote.emp_no is
    'Employee number of the truck dispatcher who prepared the quote';

alter table quote add constraint quote_pk primary key ( quote_no );


-- Add all missing FK Constraints below here
alter table employee
    add constraint employee_manager_employee_fk foreign key ( emp_no_manager )
        references employee ( emp_no );

alter table job
    add constraint quote_job_fk foreign key ( quote_no )
        references quote ( quote_no );
alter table job
    add constraint sched_emp_no_job_fk foreign key ( sched_emp_no )
        references employee ( emp_no );
alter table job
    add constraint driver_emp_no_job_fk foreign key ( driver_emp_no )
        references employee ( emp_no );
alter table job
    add constraint combination_job_fk
        foreign key ( trailer_code,
                      truck_vin )
            references combination ( trailer_code,
                                     truck_vin ); -- Ensure that the trailer and truck assigned to a job is a valid combination

alter table quote
    add constraint cust_quote_fk foreign key ( cust_no )
        references customer ( cust_no );
alter table quote
    add constraint emp_quote_fk foreign key ( emp_no )
        references employee ( emp_no );