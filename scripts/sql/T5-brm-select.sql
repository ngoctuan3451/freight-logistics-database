--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T5-brm-select.sql

--Student ID: 35697601
--Student Name: Tuan Ngoc Chu

/*
    -- Submission Declaration - must not be removed - removal will result in no marks being awarded --
    In submitting this SQL script, I confirm that this is my own work without coding assistance from Generative AI
*/

/* (a) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
select c.cust_no,
       nvl(
           c.cust_bname,
           trim(c.cust_gname
                || ' ' || c.cust_fname) --trim used to remove extra spaces in case cust_bname is null and we have to concatenate cust_gname and cust_fname
       ) as customer_name,
       count(q.quote_no) as num_quotes,
       to_char(
           avg(q.quote_cost),
           '$99,999.99'
       ) as avg_quoted_cost
  from customer c
  join quote q
on c.cust_no = q.cust_no
 group by c.cust_no,
          c.cust_bname,
          c.cust_gname,
          c.cust_fname
having count(q.quote_no) > 1
   and avg(q.quote_cost) > (
    select avg(quote_cost)
      from quote
) -- Ensure that we only include customers with more than 1 quote and an average quote cost higher than the average quote cost of all quotes in the system
 order by avg(q.quote_cost) desc,
          c.cust_no;


/* (b) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
select e1.emp_no,
       trim(e1.emp_gname
            || ' ' || e1.emp_fname) as emp_name,
        -- Decode the employee role code to its full description for better readability
       case e1.emp_role
           when 'B' then
               'Manager'
           when 'T' then
               'Truck Dispatcher'
           when 'M' then
               'Mechanic'
           when 'D' then
               'Driver'
       end as emp_role_full,
       -- trim used to concatenate manager's given and family name, and handle nulls by returning 'No Manager' if emp_no_manager is null
       nvl(
           trim(e2.emp_gname
                || ' ' || e2.emp_fname),
           'No Manager'
       ) as manager_name,
       -- For truck dispatchers, count the number of jobs they have dispatched by checking how many jobs have their emp_no as sched_emp_no. For other roles, this will be null.
       case
           when e1.emp_role = 'T' then
               (
                   select count(*)
                     from job j
                    where j.sched_emp_no = e1.emp_no
               )
           else
               null
       end as jobs_dispatched
  from employee e1
  left outer join employee e2
on e1.emp_no_manager = e2.emp_no
 order by e1.emp_no;


/* (c) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
select c.truck_vin,
        -- rpad used to format truck_rego and trailer_code to ensure proper alignment in the output
       rpad(
           t.truck_rego,
           10,
           ' '
       ) as truck_rego,
       rpad(
           c.trailer_code,
           12,
           ' '
       ) as trailer_code,
       lpad(
           to_char(
               tr.trailer_purchase_cost,
               '$99,999.99'
           ),
           21,
           ' '
       ) as trailer_purchase_cost,
       count(j.job_no) as num_jobs,
       lpad(
           nvl(
               to_char(
                   sum(q.quote_cost),
                   '$99,999.99'
               ),
               'No jobs'
           ), -- If there are no jobs for this truck and trailer combination, display 'No jobs' instead of a cost
           17,
           ' '
       ) as total_quoted_cost,
       -- Determine the usage category of the truck and trailer combination based on the number of jobs they have been used in compared to the average usage across all combinations
       case
           when count(j.job_no) = 0 then
               'Never Used'
           when count(j.job_no) > (
               select count(*) / count(distinct truck_vin || trailer_code) -- Calculate the average number of jobs per truck-trailer combination
                 from job
           )                   then
               'High Use'
           else
               'Standard Use'
       end as usage
  from combination c
  join truck t
on c.truck_vin = t.truck_vin
  join trailer tr
on c.trailer_code = tr.trailer_code
  left outer join job j -- Left outer join with job to include truck-trailer combinations that have never been used in a job
on c.truck_vin = j.truck_vin
   and c.trailer_code = j.trailer_code
  left outer join quote q
on j.quote_no = q.quote_no
 group by c.truck_vin,
          t.truck_rego,
          c.trailer_code,
          tr.trailer_purchase_cost
 order by count(j.job_no) desc,
          c.truck_vin,
          c.trailer_code;