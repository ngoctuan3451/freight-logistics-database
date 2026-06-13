/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-brm-insert.sql

--Student ID: 35697601
--Student Name: Tuan Ngoc Chu

/*
Indicate if AI was used (Yes/No):
YES

If AI was used:
I used Claude (Anthropic) to help me draft the sample test data for the EMPLOYEE,
QUOTE and JOB tables in this Task 2 file only. I checked every row against the data
model and the Task 2 rules myself before keeping it.

Prompts I used:
1. "Here's my BRM schema and the data already loaded by brm-schema-insert.sql. Help me
    come up with 10 employees, 30 quotes and 20 jobs as test data, all in one transaction
    with hardcoded primary keys under 100 and dates between 1 May and 31 July 2026."
2. "Make sure it covers the Task 2 minimums - at least 2 managers, 2 dispatchers, 1 mechanic
    and 2 drivers; some customers with more than one quote; some quotes never turned into a
    job; and a mix of jobs costing the same as the quote and jobs costing a bit more or less."
3. "Only use truck/trailer pairs that already exist in COMBINATION, keep drop-off after
    pick-up, and only let drivers drive."
*/

-- All inserts below form a SINGLE transaction (one COMMIT at the very end), as this
-- script sets up the initial test state of the database. Primary keys are hardcoded
-- numeric values below 100 (no sequences are used in Task 2).

--------------------------------------
--INSERT INTO employee
--------------------------------------
-- 10 employees: roles Manager (B), Truck Dispatcher (T), Mechanic (M), Driver (D).
-- emp_no_manager builds the reporting line: the owner (emp 1) has no manager;
-- managers report to the owner; everyone else reports to a manager.
-- Licence numbers are only recorded for Drivers; contact numbers are unique.

-- emp 1 - Manager (B), business owner -> no manager (gives the 'No Manager' case in Task 5b)
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 1,
           'Robert',
           'King',
           '0411000001',
           null,
           'B',
           null );

-- emp 2 - Manager (B), Sarah Mitchell (required for Task 3) -> reports to owner
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 2,
           'Sarah',
           'Mitchell',
           '0411000002',
           null,
           'B',
           1 );

-- emp 3 - Truck Dispatcher (T) -> reports to Sarah Mitchell
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 3,
           'David',
           'Chen',
           '0411000003',
           null,
           'T',
           2 );

-- emp 4 - Truck Dispatcher (T) -> reports to owner
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 4,
           'Emily',
           'Watson',
           '0411000004',
           null,
           'T',
           1 );

-- emp 5 - Mechanic (M) -> reports to Sarah Mitchell
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 5,
           'James',
           'Carter',
           '0411000005',
           null,
           'M',
           2 );

-- emp 6 - Driver (D), Michael Johnson (required for Task 3) -> reports to Sarah Mitchell
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 6,
           'Michael',
           'Johnson',
           '0411000006',
           'DL00000006',
           'D',
           2 );

-- emp 7 - Driver (D) -> reports to owner
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 7,
           'Laura',
           'Smith',
           '0411000007',
           'DL00000007',
           'D',
           1 );

-- emp 8 - Driver (D) -> reports to owner
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 8,
           'Peter',
           'Nguyen',
           '0411000008',
           'DL00000008',
           'D',
           1 );

-- emp 9 - Truck Dispatcher (T) -> reports to owner
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 9,
           'Anna',
           'Lee',
           '0411000009',
           null,
           'T',
           1 );

-- emp 10 - Manager (B) -> reports to owner
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_licenceno,
    emp_role,
    emp_no_manager
) values ( 10,
           'Mark',
           'Taylor',
           '0411000010',
           null,
           'B',
           1 );

--------------------------------------
--INSERT INTO quote
--------------------------------------
-- 30 quotes prepared by dispatchers (emp 3, 4, 9) for existing customers (cust_no 1-20
-- loaded by brm-schema-insert.sql). All dates fall within 01-May-2026 .. 31-Jul-2026 and
-- the preferred start date is on/after the prepared date.
-- Customers 1 and 8 (both Melbourne) each have >=2 quotes -> guarantees Task 6c output.

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 1,
           to_date('02-May-2026','dd-Mon-yyyy'),
           to_date('06-May-2026','dd-Mon-yyyy'),
           '55 Lonsdale Street, Melbourne VIC 3008',
           '12 Malop Street, Geelong VIC 3220',
           1200.00,
           1,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 2,
           to_date('05-May-2026','dd-Mon-yyyy'),
           to_date('10-May-2026','dd-Mon-yyyy'),
           '55 Lonsdale Street, Melbourne VIC 3008',
           '18 Sturt Street, Ballarat VIC 3350',
           1500.00,
           1,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 3,
           to_date('20-Jun-2026','dd-Mon-yyyy'),
           to_date('25-Jun-2026','dd-Mon-yyyy'),
           '55 Lonsdale Street, Melbourne VIC 3008',
           '5 Pall Mall, Bendigo VIC 3550',
           1800.00,
           1,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 4,
           to_date('03-May-2026','dd-Mon-yyyy'),
           to_date('08-May-2026','dd-Mon-yyyy'),
           '42 Collins Street, Melbourne VIC 3000',
           '15 George Street, Sydney NSW 2000',
           3200.00,
           8,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 5,
           to_date('18-Jun-2026','dd-Mon-yyyy'),
           to_date('22-Jun-2026','dd-Mon-yyyy'),
           '42 Collins Street, Melbourne VIC 3000',
           '67 King William Street, Adelaide SA 5000',
           2800.00,
           8,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 6,
           to_date('04-May-2026','dd-Mon-yyyy'),
           to_date('09-May-2026','dd-Mon-yyyy'),
           '67 King William Street, Adelaide SA 5000',
           '12 Hay Street, Perth WA 6000',
           4500.00,
           9,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 7,
           to_date('10-May-2026','dd-Mon-yyyy'),
           to_date('15-May-2026','dd-Mon-yyyy'),
           '67 King William Street, Adelaide SA 5000',
           '90 Bourke Street, Melbourne VIC 3000',
           2200.00,
           9,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 8,
           to_date('12-Jul-2026','dd-Mon-yyyy'),
           to_date('16-Jul-2026','dd-Mon-yyyy'),
           '67 King William Street, Adelaide SA 5000',
           '15 George Street, Sydney NSW 2000',
           3800.00,
           9,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 9,
           to_date('06-May-2026','dd-Mon-yyyy'),
           to_date('11-May-2026','dd-Mon-yyyy'),
           '78 Hay Street, Perth WA 6003',
           '67 King William Street, Adelaide SA 5000',
           2600.00,
           15,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 10,
           to_date('15-Jun-2026','dd-Mon-yyyy'),
           to_date('20-Jun-2026','dd-Mon-yyyy'),
           '78 Hay Street, Perth WA 6003',
           '90 Bourke Street, Melbourne VIC 3000',
           5200.00,
           15,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 11,
           to_date('07-May-2026','dd-Mon-yyyy'),
           to_date('12-May-2026','dd-Mon-yyyy'),
           '127 Parramatta Road, Sydney NSW 2150',
           '88 Queen Street, Brisbane QLD 4000',
           1400.00,
           20,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 12,
           to_date('09-Jul-2026','dd-Mon-yyyy'),
           to_date('13-Jul-2026','dd-Mon-yyyy'),
           '127 Parramatta Road, Sydney NSW 2150',
           '1 London Circuit, Canberra ACT 2601',
           900.00,
           20,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 13,
           to_date('08-May-2026','dd-Mon-yyyy'),
           to_date('13-May-2026','dd-Mon-yyyy'),
           '15 George Street, Sydney NSW 2000',
           '90 Bourke Street, Melbourne VIC 3000',
           3100.00,
           2,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 14,
           to_date('11-May-2026','dd-Mon-yyyy'),
           to_date('16-May-2026','dd-Mon-yyyy'),
           '56 Bourke Street, Melbourne VIC 3001',
           '67 King William Street, Adelaide SA 5000',
           2700.00,
           4,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 15,
           to_date('13-May-2026','dd-Mon-yyyy'),
           to_date('18-May-2026','dd-Mon-yyyy'),
           '61 Ann Street, Brisbane QLD 4101',
           '15 George Street, Sydney NSW 2000',
           1600.00,
           5,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 16,
           to_date('14-May-2026','dd-Mon-yyyy'),
           to_date('19-May-2026','dd-Mon-yyyy'),
           '72 Cavill Avenue, Brisbane QLD 4217',
           '1 Cavill Mall, Gold Coast QLD 4217',
           800.00,
           7,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 17,
           to_date('16-May-2026','dd-Mon-yyyy'),
           to_date('21-May-2026','dd-Mon-yyyy'),
           '45 Rundle Mall, Adelaide SA 5006',
           '9 Albatros Drive, Mount Gambier SA 5270',
           1100.00,
           10,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 18,
           to_date('19-May-2026','dd-Mon-yyyy'),
           to_date('24-May-2026','dd-Mon-yyyy'),
           '34 Adelaide Street, Brisbane QLD 4006',
           '8 Ruthven Street, Toowoomba QLD 4350',
           950.00,
           11,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 19,
           to_date('21-May-2026','dd-Mon-yyyy'),
           to_date('26-May-2026','dd-Mon-yyyy'),
           '38 Wellington Street, Perth WA 6107',
           '12 Hannan Street, Kalgoorlie WA 6430',
           3400.00,
           12,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 20,
           to_date('23-May-2026','dd-Mon-yyyy'),
           to_date('28-May-2026','dd-Mon-yyyy'),
           '88 Queen Street, Brisbane QLD 4000',
           '50 Spence Street, Cairns QLD 4870',
           4800.00,
           13,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 21,
           to_date('25-May-2026','dd-Mon-yyyy'),
           to_date('30-May-2026','dd-Mon-yyyy'),
           '101 Pitt Street, Sydney NSW 2010',
           '1 Hunter Street, Newcastle NSW 2300',
           700.00,
           14,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 22,
           to_date('27-May-2026','dd-Mon-yyyy'),
           to_date('01-Jun-2026','dd-Mon-yyyy'),
           '92 Oxford Street, Sydney NSW 2060',
           '200 Crown Street, Wollongong NSW 2500',
           1300.00,
           16,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 23,
           to_date('29-May-2026','dd-Mon-yyyy'),
           to_date('03-Jun-2026','dd-Mon-yyyy'),
           '83 Jetty Road, Adelaide SA 5063',
           '20 Forsyth Street, Whyalla SA 5600',
           2100.00,
           19,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 24,
           to_date('02-Jun-2026','dd-Mon-yyyy'),
           to_date('07-Jun-2026','dd-Mon-yyyy'),
           '23 Murray Street, Perth WA 6000',
           '20 Victoria Street, Bunbury WA 6230',
           1700.00,
           3,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 25,
           to_date('05-Jun-2026','dd-Mon-yyyy'),
           to_date('10-Jun-2026','dd-Mon-yyyy'),
           '29 Barrack Street, Perth WA 6009',
           '7 Marine Terrace, Geraldton WA 6530',
           2900.00,
           6,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 26,
           to_date('08-Jun-2026','dd-Mon-yyyy'),
           to_date('13-Jun-2026','dd-Mon-yyyy'),
           '18 Chapel Street, Melbourne VIC 3004',
           '100 Wyndham Street, Shepparton VIC 3630',
           1000.00,
           17,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 27,
           to_date('10-Jun-2026','dd-Mon-yyyy'),
           to_date('15-Jun-2026','dd-Mon-yyyy'),
           '15 George Street, Sydney NSW 2000',
           '230 Macquarie Street, Dubbo NSW 2830',
           1900.00,
           2,
           3 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 28,
           to_date('12-Jun-2026','dd-Mon-yyyy'),
           to_date('17-Jun-2026','dd-Mon-yyyy'),
           '61 Ann Street, Brisbane QLD 4101',
           '40 East Street, Rockhampton QLD 4700',
           3600.00,
           5,
           4 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 29,
           to_date('14-Jun-2026','dd-Mon-yyyy'),
           to_date('19-Jun-2026','dd-Mon-yyyy'),
           '56 Bourke Street, Melbourne VIC 3001',
           '74 Langtree Avenue, Mildura VIC 3500',
           2400.00,
           4,
           9 );

insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( 30,
           to_date('16-Jun-2026','dd-Mon-yyyy'),
           to_date('21-Jun-2026','dd-Mon-yyyy'),
           '72 Cavill Avenue, Brisbane QLD 4217',
           '60 Flinders Street, Townsville QLD 4810',
           5100.00,
           7,
           3 );

--------------------------------------
--INSERT INTO job
--------------------------------------
-- 20 jobs created from 20 of the 30 quotes (quotes 12, 21, 22, 23, 25-30 are left without a
-- job -> satisfies "at least 2 quotes never placed as a job"). Each job uses a truck/trailer
-- pair that already exists in COMBINATION. Pairs for jobs 1-10 reuse 5 combinations twice
-- ('High Use'), jobs 11-20 use further distinct combinations once ('Standard Use'); some
-- combinations are never used ('Never Used'). Drivers are Driver-role employees only (6/7/8),
-- and each job is scheduled by a Truck Dispatcher (3/4/9).
-- job_cost is recorded ONLY when it differs from the quote cost; when the actual cost equals
-- the quote cost, job_cost is left NULL (no revised costing is stored).

-- Job 1 (quote 1): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 1,
           to_date('06-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('06-May-2026 15:00','dd-Mon-yyyy hh24:mi'),
           null,
           'Y',
           1,
           3,
           6,
           'TRL01',
           '1HGBH41JXMN109186' );

-- Job 2 (quote 2): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 2,
           to_date('10-May-2026 08:00','dd-Mon-yyyy hh24:mi'),
           to_date('10-May-2026 16:00','dd-Mon-yyyy hh24:mi'),
           1600.00,
           'Y',
           2,
           4,
           7,
           'TRL01',
           '1HGBH41JXMN109186' );

-- Job 3 (quote 3): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 3,
           to_date('25-Jun-2026 07:00','dd-Mon-yyyy hh24:mi'),
           to_date('26-Jun-2026 10:00','dd-Mon-yyyy hh24:mi'),
           null,
           'N',
           3,
           9,
           8,
           'TRL02',
           '2FMDK3GC8BBA12345' );

-- Job 4 (quote 4): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 4,
           to_date('08-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('09-May-2026 12:00','dd-Mon-yyyy hh24:mi'),
           3100.00,
           'Y',
           4,
           3,
           6,
           'TRL02',
           '2FMDK3GC8BBA12345' );

-- Job 5 (quote 5): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 5,
           to_date('22-Jun-2026 06:00','dd-Mon-yyyy hh24:mi'),
           to_date('23-Jun-2026 09:00','dd-Mon-yyyy hh24:mi'),
           null,
           'Y',
           5,
           4,
           7,
           'TRL03',
           '3VWFE21C04M000001' );

-- Job 6 (quote 6): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 6,
           to_date('09-May-2026 08:00','dd-Mon-yyyy hh24:mi'),
           to_date('10-May-2026 14:00','dd-Mon-yyyy hh24:mi'),
           4650.00,
           'N',
           6,
           9,
           8,
           'TRL03',
           '3VWFE21C04M000001' );

-- Job 7 (quote 7): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 7,
           to_date('15-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('15-May-2026 18:00','dd-Mon-yyyy hh24:mi'),
           null,
           'Y',
           7,
           3,
           6,
           'TRL04',
           '4T1BF1FK5CU123456' );

-- Job 8 (quote 8): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 8,
           to_date('16-Jul-2026 07:00','dd-Mon-yyyy hh24:mi'),
           to_date('17-Jul-2026 15:00','dd-Mon-yyyy hh24:mi'),
           3700.00,
           'Y',
           8,
           4,
           7,
           'TRL04',
           '4T1BF1FK5CU123456' );

-- Job 9 (quote 9): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 9,
           to_date('11-May-2026 08:00','dd-Mon-yyyy hh24:mi'),
           to_date('12-May-2026 10:00','dd-Mon-yyyy hh24:mi'),
           null,
           'N',
           9,
           9,
           8,
           'TRL05',
           '5FNRL5H40BB098765' );

-- Job 10 (quote 10): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 10,
           to_date('20-Jun-2026 06:00','dd-Mon-yyyy hh24:mi'),
           to_date('21-Jun-2026 16:00','dd-Mon-yyyy hh24:mi'),
           5400.00,
           'Y',
           10,
           3,
           6,
           'TRL05',
           '5FNRL5H40BB098765' );

-- Job 11 (quote 11): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 11,
           to_date('12-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('12-May-2026 17:00','dd-Mon-yyyy hh24:mi'),
           null,
           'Y',
           11,
           4,
           7,
           'TRL06',
           '1FTFW1ET5DFC10112' );

-- Job 12 (quote 13): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 12,
           to_date('13-May-2026 08:00','dd-Mon-yyyy hh24:mi'),
           to_date('14-May-2026 12:00','dd-Mon-yyyy hh24:mi'),
           3000.00,
           'Y',
           13,
           9,
           8,
           'TRL07',
           '2C4RDGCG8ER123789' );

-- Job 13 (quote 14): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 13,
           to_date('16-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('16-May-2026 19:00','dd-Mon-yyyy hh24:mi'),
           2800.00,
           'N',
           14,
           3,
           6,
           'TRL08',
           '5XYKT3A69CG234567' );

-- Job 14 (quote 15): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 14,
           to_date('18-May-2026 07:00','dd-Mon-yyyy hh24:mi'),
           to_date('18-May-2026 16:00','dd-Mon-yyyy hh24:mi'),
           null,
           'Y',
           15,
           4,
           7,
           'TRL08',
           '2FMDK3GC8BBA12345' );

-- Job 15 (quote 16): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 15,
           to_date('19-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('19-May-2026 15:00','dd-Mon-yyyy hh24:mi'),
           850.00,
           'Y',
           16,
           9,
           8,
           'TRL01',
           '3VWFE21C04M000001' );

-- Job 16 (quote 17): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 16,
           to_date('21-May-2026 08:00','dd-Mon-yyyy hh24:mi'),
           to_date('22-May-2026 11:00','dd-Mon-yyyy hh24:mi'),
           null,
           'N',
           17,
           3,
           6,
           'TRL07',
           '4T1BF1FK5CU123456' );

-- Job 17 (quote 18): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 17,
           to_date('24-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('24-May-2026 14:00','dd-Mon-yyyy hh24:mi'),
           900.00,
           'Y',
           18,
           4,
           7,
           'TRL02',
           '5FNRL5H40BB098765' );

-- Job 18 (quote 19): cost equals quote -> job_cost NULL
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 18,
           to_date('26-May-2026 07:00','dd-Mon-yyyy hh24:mi'),
           to_date('27-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           null,
           'Y',
           19,
           9,
           8,
           'TRL04',
           '1FTFW1ET5DFC10112' );

-- Job 19 (quote 20): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 19,
           to_date('28-May-2026 08:00','dd-Mon-yyyy hh24:mi'),
           to_date('28-May-2026 18:00','dd-Mon-yyyy hh24:mi'),
           4950.00,
           'Y',
           20,
           3,
           6,
           'TRL04',
           '4T1BF1FK5CU123456' );

-- Job 20 (quote 24): revised cost differs from quote
insert into job (
    job_no,
    job_pickup_dt,
    job_intended_dropoff_dt,
    job_cost,
    job_payment_made,
    quote_no,
    sched_emp_no,
    driver_emp_no,
    trailer_code,
    truck_vin
) values ( 20,
           to_date('07-Jun-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('08-Jun-2026 12:00','dd-Mon-yyyy hh24:mi'),
           1750.00,
           'N',
           24,
           4,
           7,
           'TRL03',
           '2C4RDGCG8ER123789' );

-- End of the single transaction - commit all test data together.
commit;