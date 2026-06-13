-- =====================================================================
--  BigRig Movers (BRM) — Sample data
--  02 · A small synthetic dataset to demonstrate the schema and queries.
--     Run after 01_create_schema.sql.
-- =====================================================================

SET DEFINE OFF;

-- TRUCK ---------------------------------------------------------------
INSERT INTO truck VALUES ('1HGCM82633A000001', 'TRK001', 120000, 118000, 180000.00, DATE '2021-03-15');
INSERT INTO truck VALUES ('1HGCM82633A000002', 'TRK002',  90000,  88000, 210000.00, DATE '2022-06-01');
INSERT INTO truck VALUES ('1HGCM82633A000003', 'TRK003',  60000,   NULL, 195000.00, DATE '2023-01-20');
INSERT INTO truck VALUES ('1HGCM82633A000004', 'TRK004',  30000,   NULL, 230000.00, DATE '2024-02-10');

-- TRAILER -------------------------------------------------------------
INSERT INTO trailer VALUES ('REF08', 45000.00, DATE '2021-04-01');
INSERT INTO trailer VALUES ('FLT12', 38000.00, DATE '2022-07-15');
INSERT INTO trailer VALUES ('CUR05', 52000.00, DATE '2023-03-10');

-- CUSTOMER ------------------------------------------------------------
INSERT INTO customer VALUES (1, 'Alice',  'Tran',   'FreshBox',        '0400111222', '55 Lonsdale Street', 'Melbourne', '3000');
INSERT INTO customer VALUES (2, 'Ben',    'Carter',  NULL,             '0400333444', '15 George Street',   'Sydney',    '2000');
INSERT INTO customer VALUES (3, 'Chloe',  'Smith',  'Smith Co',        '0400555666', '88 Queen Street',    'Brisbane',  '4000');
INSERT INTO customer VALUES (4, 'Daniel', 'Lee',     NULL,             '0400777888', '42 Collins Street',  'Melbourne', '3000');
INSERT INTO customer VALUES (5, 'Eva',    'Martin', 'Martin Freight',  '0400999000', '67 King William St', 'Adelaide',  '5000');
INSERT INTO customer VALUES (6, 'Frank',  'Owens',   NULL,             '0400121212', '23 Murray Street',   'Perth',     '6000');

-- EMPLOYEE (managers first so the self-reference resolves) -------------
INSERT INTO employee VALUES (10, 'Olivia', 'Boss',     '0411000010', NULL,        'B', NULL);  -- business owner
INSERT INTO employee VALUES (11, 'Marcus', 'Hill',     '0411000011', NULL,        'B', 10);    -- manager
INSERT INTO employee VALUES (12, 'Dan',    'Webb',     '0411000012', NULL,        'T', 11);    -- dispatcher
INSERT INTO employee VALUES (13, 'Dora',   'Knight',   '0411000013', NULL,        'T', 11);    -- dispatcher
INSERT INTO employee VALUES (14, 'Mike',   'Reyes',    '0411000014', NULL,        'M', 11);    -- mechanic
INSERT INTO employee VALUES (15, 'Dave',   'Nguyen',   '0411000015', 'DL1234567', 'D', 11);    -- driver
INSERT INTO employee VALUES (16, 'Diana',  'Foster',   '0411000016', 'DL7654321', 'D', 11);    -- driver

-- COMBINATION (valid truck + trailer pairings) ------------------------
INSERT INTO combination VALUES ('1HGCM82633A000001', 'REF08');
INSERT INTO combination VALUES ('1HGCM82633A000001', 'FLT12');
INSERT INTO combination VALUES ('1HGCM82633A000002', 'FLT12');
INSERT INTO combination VALUES ('1HGCM82633A000002', 'CUR05');
INSERT INTO combination VALUES ('1HGCM82633A000003', 'REF08');  -- exists but never used in a job

-- QUOTE (cust_no, dispatcher emp_no) ----------------------------------
INSERT INTO quote VALUES (1, DATE '2026-05-02', DATE '2026-05-06', 'Melbourne VIC', 'Geelong VIC',   1200.00, 1, 12);
INSERT INTO quote VALUES (2, DATE '2026-05-05', DATE '2026-05-10', 'Melbourne VIC', 'Ballarat VIC',  1800.00, 1, 12);
INSERT INTO quote VALUES (3, DATE '2026-05-08', DATE '2026-05-13', 'Sydney NSW',    'Newcastle NSW',  900.00, 2, 13);
INSERT INTO quote VALUES (4, DATE '2026-05-11', DATE '2026-05-16', 'Brisbane QLD',  'Sydney NSW',    3200.00, 3, 12);
INSERT INTO quote VALUES (5, DATE '2026-05-14', DATE '2026-05-19', 'Brisbane QLD',  'Cairns QLD',    2800.00, 3, 13);
INSERT INTO quote VALUES (6, DATE '2026-05-17', DATE '2026-05-22', 'Melbourne VIC', 'Mildura VIC',   1100.00, 4, 12);
INSERT INTO quote VALUES (7, DATE '2026-05-20', DATE '2026-05-25', 'Adelaide SA',   'Perth WA',      4500.00, 5, 13);
INSERT INTO quote VALUES (8, DATE '2026-05-23', DATE '2026-05-28', 'Adelaide SA',   'Sydney NSW',    3900.00, 5, 12);

-- JOB (scheduled quotes; combo = truck_vin + trailer_code) ------------
INSERT INTO job VALUES (1, TO_DATE('2026-05-06 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2026-05-06 14:00','YYYY-MM-DD HH24:MI'), NULL,    'Y', 1, 12, 15, 'REF08', '1HGCM82633A000001');
INSERT INTO job VALUES (2, TO_DATE('2026-05-16 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2026-05-17 17:00','YYYY-MM-DD HH24:MI'), 3300.00, 'N', 4, 12, 15, 'REF08', '1HGCM82633A000001');
INSERT INTO job VALUES (3, TO_DATE('2026-05-19 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2026-05-20 18:00','YYYY-MM-DD HH24:MI'), NULL,    'Y', 5, 13, 16, 'FLT12', '1HGCM82633A000002');
INSERT INTO job VALUES (4, TO_DATE('2026-05-25 06:00','YYYY-MM-DD HH24:MI'), TO_DATE('2026-05-27 20:00','YYYY-MM-DD HH24:MI'), 4650.00, 'N', 7, 13, 16, 'CUR05', '1HGCM82633A000002');
INSERT INTO job VALUES (5, TO_DATE('2026-05-10 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2026-05-10 15:00','YYYY-MM-DD HH24:MI'), NULL,    'Y', 2, 12, 15, 'FLT12', '1HGCM82633A000001');

COMMIT;
