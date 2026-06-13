-- =====================================================================
--  BigRig Movers (BRM) — Analytical queries
--  03 · Business questions answered against the schema.
--     Run after 01_create_schema.sql and 02_sample_data.sql.
-- =====================================================================


-- Q1. High-value customers
--     Customers with more than one quote AND an average quote cost above
--     the system-wide average. Useful for spotting accounts worth retaining.
SELECT  c.cust_no,
        NVL(c.cust_bname, TRIM(c.cust_gname || ' ' || c.cust_fname)) AS customer_name,
        COUNT(q.quote_no)                          AS num_quotes,
        TO_CHAR(AVG(q.quote_cost), '$99,999.99')   AS avg_quoted_cost
FROM        customer c
JOIN        quote    q ON q.cust_no = c.cust_no
GROUP BY    c.cust_no, c.cust_bname, c.cust_gname, c.cust_fname
HAVING      COUNT(q.quote_no) > 1
       AND  AVG(q.quote_cost) > ( SELECT AVG(quote_cost) FROM quote )
ORDER BY    AVG(q.quote_cost) DESC, c.cust_no;


-- Q2. Employee roster with reporting line
--     Each employee, their decoded role, who they report to, and (for
--     dispatchers) how many jobs they have scheduled.
SELECT  e.emp_no,
        TRIM(e.emp_gname || ' ' || e.emp_fname) AS emp_name,
        CASE e.emp_role
            WHEN 'B' THEN 'Manager'
            WHEN 'T' THEN 'Truck Dispatcher'
            WHEN 'M' THEN 'Mechanic'
            WHEN 'D' THEN 'Driver'
        END                                     AS role,
        NVL(TRIM(m.emp_gname || ' ' || m.emp_fname), 'No manager') AS reports_to,
        CASE WHEN e.emp_role = 'T'
             THEN ( SELECT COUNT(*) FROM job j WHERE j.sched_emp_no = e.emp_no )
             ELSE NULL
        END                                     AS jobs_scheduled
FROM        employee e
LEFT JOIN   employee m ON e.emp_no_manager = m.emp_no
ORDER BY    e.emp_no;


-- Q3. Truck-trailer combination utilisation
--     Jobs per combination and total quoted revenue, classified against
--     the average usage. LEFT JOINs keep combinations that were never used.
SELECT  cmb.truck_vin,
        cmb.trailer_code,
        COUNT(j.job_no)                                         AS num_jobs,
        NVL(TO_CHAR(SUM(q.quote_cost), '$99,999.99'), 'No jobs') AS total_quoted,
        CASE
            WHEN COUNT(j.job_no) = 0 THEN 'Never used'
            WHEN COUNT(j.job_no) > ( SELECT COUNT(*) / COUNT(DISTINCT truck_vin || trailer_code) FROM job )
                THEN 'High use'
            ELSE 'Standard use'
        END                                                     AS usage
FROM        combination cmb
LEFT JOIN   job   j ON j.truck_vin = cmb.truck_vin AND j.trailer_code = cmb.trailer_code
LEFT JOIN   quote q ON q.quote_no = j.quote_no
GROUP BY    cmb.truck_vin, cmb.trailer_code
ORDER BY    num_jobs DESC, cmb.truck_vin, cmb.trailer_code;
