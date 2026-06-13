-- =====================================================================
--  BigRig Movers (BRM) — Relational to JSON
--  04 · Builds one nested JSON document per customer (profile, stats and
--     an array of their quotes) directly from the relational tables.
--     Run after the schema and sample data are loaded.
-- =====================================================================

SET PAGESIZE 100
SET WRAP OFF
SET HEADING OFF

SELECT JSON_OBJECT(
           '_id'              VALUE c.cust_no,
           'customer_name'    VALUE TRIM(c.cust_gname || ' ' || c.cust_fname),
           'customer_business' VALUE NVL(c.cust_bname, '-'),
           'customer_address' VALUE c.cust_street || ', ' || c.cust_town || ', ' || c.cust_pcode,
           'customer_phone'   VALUE c.cust_contact_no,
           'customer_stats'   VALUE JSON_OBJECT(
               'number_of_quotes'     VALUE COUNT(q.quote_no),
               'number_of_jobs'       VALUE COUNT(j.job_no),
               'total_paid_jobcost'   VALUE NVL(TRIM(TO_CHAR(
                   SUM(CASE WHEN j.job_payment_made = 'Y' THEN NVL(j.job_cost, q.quote_cost) END), '$99,999.99')), '-'),
               'total_unpaid_jobcost' VALUE NVL(TRIM(TO_CHAR(
                   SUM(CASE WHEN j.job_payment_made = 'N' THEN NVL(j.job_cost, q.quote_cost) END), '$99,999.99')), '-')
           ),
           'quotes' VALUE JSON_ARRAYAGG(
               JSON_OBJECT(
                   'quote_no'        VALUE q.quote_no,
                   'prepared_on'     VALUE TO_CHAR(q.quote_prepared_date, 'dd-Mon-yyyy'),
                   'start_location'  VALUE q.quote_start_location,
                   'end_location'    VALUE q.quote_end_location,
                   'quote_cost'      VALUE TRIM(TO_CHAR(q.quote_cost, '$99,999.99')),
                   'assigned_to_job' VALUE CASE WHEN j.job_no IS NOT NULL THEN 'Y' ELSE 'N' END,
                   'job_cost'        VALUE CASE WHEN j.job_no IS NOT NULL
                                                THEN TRIM(TO_CHAR(NVL(j.job_cost, q.quote_cost), '$99,999.99'))
                                                ELSE '-' END
               )
           )
       FORMAT JSON)
FROM        customer c
JOIN        quote q ON c.cust_no = q.cust_no
LEFT JOIN   job   j ON q.quote_no = j.quote_no   -- keep quotes that never became jobs
GROUP BY    c.cust_no, c.cust_gname, c.cust_fname, c.cust_bname,
            c.cust_street, c.cust_town, c.cust_pcode, c.cust_contact_no
ORDER BY    c.cust_no;
