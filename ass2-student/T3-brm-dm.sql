--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T3-brm-dm.sql

--Student ID: 35697601
--Student Name: Tuan Ngoc Chu

/*
    -- Submission Declaration - must not be removed - removal will result in no marks being awarded --
    In submitting this SQL script, I confirm that this is my own work without coding assistance from Generative AI
*/

--3(a)
drop sequence employee_seq;
create sequence employee_seq start with 300 increment by 5;

drop sequence quote_seq;
create sequence quote_seq start with 300 increment by 5;

drop sequence job_seq;
create sequence job_seq start with 300 increment by 5;

--3(b)
insert into employee (
    emp_no,
    emp_gname,
    emp_fname,
    emp_contact_no,
    emp_role,
    emp_no_manager
) values ( employee_seq.nextval, -- nextval used to get the next value from the employee_seq sequence, wont be hardcoded to ensure unique emp_no values
           'Aurello',
           'Brown',
           '0431952053',
           'T',
           (
               select emp_no
                 from employee
                where upper(emp_gname) = upper('Sarah') -- upper used to ensure case-insensitive matching
                  and upper(emp_fname) = upper('Mitchell')
           ) );

commit; 

--3(c)
insert into quote (
    quote_no,
    quote_prepared_date,
    quote_pref_start_date,
    quote_start_location,
    quote_end_location,
    quote_cost,
    cust_no,
    emp_no
) values ( quote_seq.nextval,
           to_date('17-May-2026','dd-Mon-yyyy'),
           to_date('25-May-2026','dd-Mon-yyyy'),
           '29 Kuranda Road, Adelaide SA 5030',
           '9 Albatros Drive, Mount Gambier SA 5270',
           1000,
           (
               select cust_no
                 from customer
                where upper(cust_gname) = upper('Victoria')
                  and upper(cust_fname) = upper('Ella')
                  and upper(cust_bname) = upper('Flintstone Store')
           ),
           (
               select emp_no
                 from employee
                where upper(emp_gname) = upper('Aurello')
                  and upper(emp_fname) = upper('Brown')
           ) );

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
) values ( job_seq.nextval,
           to_date('25-May-2026 09:00','dd-Mon-yyyy hh24:mi'),
           to_date('25-May-2026 09:00','dd-Mon-yyyy hh24:mi') + 5 / 24, -- Adding 5 hours to the pickup date and time to get the intended dropoff dt
           null,
           'Y',
           quote_seq.currval, -- currval used to get the current value of quote_seq sequence, which is the quote_no of the quote we just inserted above
           (
               select emp_no
                 from employee
                where upper(emp_gname) = upper('Aurello')
                  and upper(emp_fname) = upper('Brown')
           ),
           (
               select emp_no
                 from employee
                where upper(emp_gname) = upper('Michael')
                  and upper(emp_fname) = upper('Johnson')
           ),
           'TRL08',
           '1HGBH41JXMN109186' );

commit;

--3(d)
update job
   set job_cost = (
    select quote_cost
      from quote
     where quote_no = job.quote_no
) * 1.20,
       job_pickup_dt = to_date('25-May-2026 14:00','dd-Mon-yyyy hh24:mi'),
       job_intended_dropoff_dt = to_date('25-May-2026 14:00','dd-Mon-yyyy hh24:mi') +
       5 / 24
 where quote_no = (
    select q.quote_no
      from quote q
      join customer c
    on q.cust_no = c.cust_no
     where q.quote_prepared_date = to_date('17-May-2026','dd-Mon-yyyy')
       and upper(c.cust_gname) = upper('Victoria')
       and upper(c.cust_fname) = upper('Ella')
       and upper(c.cust_bname) = upper('Flintstone Store')
);

commit;
    
--3(e)
delete from job
 where quote_no = (
    select q.quote_no
      from quote q
      join customer c
    on q.cust_no = c.cust_no
     where q.quote_prepared_date = to_date('17-May-2026','dd-Mon-yyyy')
       and upper(c.cust_gname) = upper('Victoria')
       and upper(c.cust_fname) = upper('Ella')
       and upper(c.cust_bname) = upper('Flintstone Store')
);

commit;