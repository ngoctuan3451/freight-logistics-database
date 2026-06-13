/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-brm-json.sql

--Student ID: 35697601
--Student Name: Tuan Ngoc Chu

/*
    -- Submission Declaration - must not be removed - removal will result in no marks being awarded --
    In submitting this SQL script, I confirm that this is my own work without coding assistance from Generative AI
*/

   SET PAGESIZE 100
SET WRAP OFF
SET HEADING OFF

-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
select
    json_object(
        '_id' value c.cust_no,
                'customer_name' value trim(c.cust_gname
                                           || ' ' || c.cust_fname),
                'customer_business' value nvl(
            c.cust_bname,
            '-'
        ), -- If the customer does not have a business name, display '-' instead of null
                'customer_address' value c.cust_street
                                              || ', '
                                              || c.cust_town
                                              || ', ' || c.cust_pcode,
                'customer_phone' value c.cust_contact_no,
                'customer_stats' value
            json_object(
                'number_of_quotes' value count(q.quote_no),
                        'number_of_jobs' value count(j.job_no),
                        'total_paid_jobcost' value nvl(
                    trim(to_char(
                        sum(
                            case
                                when j.job_payment_made = 'Y' then
                                    nvl(
                                        j.job_cost,
                                        q.quote_cost
                                    )-- If the job cost is null, use the quote cost as a fallback for calculating totals
                            end
                        ), -- Sum the costs of paid and unpaid jobs separately to get total paid and unpaid job costs for the customer
                        '$99,999.99'
                    )),
                    '-'
                ),
                        'total_unpaid_jobcost' value nvl(
                    trim(to_char(
                        sum(
                            case
                                when j.job_payment_made = 'N' then
                                    nvl(
                                        j.job_cost,
                                        q.quote_cost
                                    )
                            end
                        ),
                        '$99,999.99'
                    )),
                    '-'
                )
            ),
                'quotes' value json_arrayagg(  -- Aggregate the customer's quotes into a JSON array
            json_object(
                'quote_no' value q.quote_no,
                        'quote_prepared_on' value to_char(
                    q.quote_prepared_date,
                    'dd-Mon-yyyy'
                ),
                        'preferred_start_date' value to_char(
                    q.quote_pref_start_date,
                    'dd-Mon-yyyy'
                ),
                        'start_location' value q.quote_start_location,
                        'end_location' value q.quote_end_location,
                        'quote_cost' value 
                    trim(to_char(
                        q.quote_cost,
                        '$99,999.99'
                    )
                ),
                        'assigned_to_job' value(
                    case
                        -- left outer join with job makes j.job_no null for quotes that are not assigned to a job
                        when j.job_no is not null then
                            'Y'
                        else
                            'N'
                    end
                ),
                        'job_cost' value
                    case
                        when j.job_no is not null then
                            trim(to_char(
                                nvl(
                                    j.job_cost,
                                    q.quote_cost
                                ),
                                '$99,999.99'
                            ))
                        else
                            '-'
                    end
            )
        )
    format json)
    || ','
  from customer c
  join quote q
on c.cust_no = q.cust_no
  left outer join job j  -- We want to keep all quotes in the output regardless of whether they are assigned to a job or not
on q.quote_no = j.quote_no
 group by c.cust_no,
          c.cust_gname,
          c.cust_fname,
          c.cust_bname,
          c.cust_street,
          c.cust_town,
          c.cust_pcode,
          c.cust_contact_no
 order by c.cust_no;