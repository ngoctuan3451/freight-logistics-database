/*
  Databases 2026 S1 Assignment 2
  --BigRig Mover schema and Initial Data
  --brm_schema_insert.sql

  Description:
  This file creates the BigRig Mover tables and populates several of the tables
  (those shown in purple on the supplied model).
  You should read this schema file carefully and be sure you understand the various data requirements.

  AI Acknowledgement:
  GitLab Duo Chat was used to generate the initial data for customer, truck, trailer and combination.
  The schema file for these four tables was provided to GitLab Duo Chat to assist the data generation.
  The generated data was then manually edited to suit the assignment task requirements.

Author: FIT Database Teaching Team
License: Copyright Monash University, unless otherwise stated. All Rights Reserved.
COPYRIGHT WARNING
Warning
This material is protected by copyright. For use within Monash University only. NOT FOR RESALE.
Do not remove this notice.

*/
SET ECHO ON

DROP TABLE combination CASCADE CONSTRAINTS PURGE;

DROP TABLE customer CASCADE CONSTRAINTS PURGE;

DROP TABLE trailer CASCADE CONSTRAINTS PURGE;

DROP TABLE truck CASCADE CONSTRAINTS PURGE;

--------------------------------------
--CREATE TABLE combination
--------------------------------------
CREATE TABLE combination (
    truck_vin    CHAR(17) NOT NULL,
    trailer_code CHAR(5) NOT NULL
);

COMMENT ON COLUMN combination.truck_vin IS
    'Vehicle Indentification Number (VIN)';

COMMENT ON COLUMN combination.trailer_code IS
    'Identifier for trailer';

ALTER TABLE combination ADD CONSTRAINT combination_pk PRIMARY KEY ( trailer_code,
                                                                    truck_vin );

--------------------------------------
--CREATE TABLE customer
--------------------------------------
CREATE TABLE customer (
    cust_no         NUMBER(4) NOT NULL,
    cust_gname      VARCHAR2(30),
    cust_fname      VARCHAR2(30),
    cust_bname      VARCHAR2(40),
    cust_contact_no CHAR(10) NOT NULL,
    cust_street     VARCHAR2(40) NOT NULL,
    cust_town       VARCHAR2(30) NOT NULL,
    cust_pcode      CHAR(4) NOT NULL
);

COMMENT ON COLUMN customer.cust_no IS
    'Identifier for customer';

COMMENT ON COLUMN customer.cust_gname IS
    'Customers given name';

COMMENT ON COLUMN customer.cust_fname IS
    'Customers family name';

COMMENT ON COLUMN customer.cust_bname IS
    'Business name of customer (if a business)';

COMMENT ON COLUMN customer.cust_contact_no IS
    'Customer contact number';

COMMENT ON COLUMN customer.cust_street IS
    'Customer street';

COMMENT ON COLUMN customer.cust_town IS
    'Customer town';

COMMENT ON COLUMN customer.cust_pcode IS
    'Customer postcode';

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( cust_no );

--------------------------------------
--CREATE TABLE trailer
--------------------------------------
CREATE TABLE trailer (
    trailer_code           CHAR(5) NOT NULL,
    trailer_purchase_cost  NUMBER(8,2) NOT NULL,
    trailer_date_purchased DATE NOT NULL
);

COMMENT ON COLUMN trailer.trailer_code IS
    'Identifier for trailer';

COMMENT ON COLUMN trailer.trailer_purchase_cost IS
    'Purchase cost for trailer';

COMMENT ON COLUMN trailer.trailer_date_purchased IS
    'Date trailer was purchased';

ALTER TABLE trailer ADD CONSTRAINT trailer_pk PRIMARY KEY ( trailer_code );

--------------------------------------
--CREATE TABLE truck
--------------------------------------
CREATE TABLE truck (
    truck_vin              CHAR(17) NOT NULL,
    truck_rego             CHAR(6) NOT NULL,
    truck_kms              NUMBER(6) NOT NULL,
    truck_last_service_kms NUMBER(6),
    truck_purchase_cost    NUMBER(8,2) NOT NULL,
    truck_date_purchased   DATE NOT NULL
);

COMMENT ON COLUMN truck.truck_vin IS
    'Vehicle Indentification Number (VIN)';

COMMENT ON COLUMN truck.truck_rego IS
    'Truck registration number';

COMMENT ON COLUMN truck.truck_kms IS
    'Truck kilometres travelled';

COMMENT ON COLUMN truck.truck_last_service_kms IS
    'Truck kilometres at last service';

COMMENT ON COLUMN truck.truck_purchase_cost IS
    'Purchase cost of truck';

COMMENT ON COLUMN truck.truck_date_purchased IS
    'Date truck was purchased';

ALTER TABLE truck ADD CONSTRAINT truck_pk PRIMARY KEY ( truck_vin );

--------------------------------------
-- ALTER FK constraints
--------------------------------------
ALTER TABLE combination
    ADD CONSTRAINT trailer_combination_fk FOREIGN KEY ( trailer_code )
        REFERENCES trailer ( trailer_code );

ALTER TABLE combination
    ADD CONSTRAINT truck_combination_fk FOREIGN KEY ( truck_vin )
        REFERENCES truck ( truck_vin );

--------------------------------------
--INSERT INTO customer
--------------------------------------
-- Insert statements for customer table
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (1, 'Michael', 'Benjamin', 'FreshBox', '0478901017', '55 Lonsdale Street', 'Melbourne', '3008');

-- Customer with no cust_fname
INSERT INTO customer (cust_no, cust_gname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (2, 'James', 'J Wood and Gravel', '0412345001', '15 George Street', 'Sydney', '2000');

-- Customer with no cust_gname
INSERT INTO customer (cust_no, cust_fname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (3, 'Brook', 'Western Chocolatery', '0445678004', '23 Murray Street', 'Perth', '6000');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (4, 'Alexander', 'Noah', '0478901007', '56 Bourke Street', 'Melbourne', '3001');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (5, 'Jack', 'Ethan', '0434567013', '61 Ann Street', 'Brisbane', '4101');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (6, 'Sophie', 'Amelia', '0445678014', '29 Barrack Street', 'Perth', '6009');

INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (7, 'Kate', 'Evelyn', 'Miller Co.', '0489012018', '72 Cavill Avenue', 'Brisbane', '4217');

-- Customer with no cust_fname
INSERT INTO customer (cust_no, cust_gname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (8, 'Emma', 'Kreate Curtain', '0423456002', '42 Collins Street', 'Melbourne', '3000');

-- Customer with no cust_gname
INSERT INTO customer (cust_no, cust_fname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (9, 'William', 'Best Fruit and Veg', '0456789005', '67 King William Street', 'Adelaide', '5000');

-- Customer with no cust_gname and cust_bname
INSERT INTO customer (cust_no, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (10, 'Grace', '0401234010', '45 Rundle Mall', 'Adelaide', '5006');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (11, 'Rose', 'Isabella', '0489012008', '34 Adelaide Street', 'Brisbane', '4006');

INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (12, 'Robert', 'James', 'Wilson Confectionery', '0490123019', '38 Wellington Street', 'Perth', '6107');

-- Customer with no cust_fname
INSERT INTO customer (cust_no, cust_gname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (13, 'Oliver', 'Williams Co.', '0434567003', '88 Queen Street', 'Brisbane', '4000');

-- Customer with no cust_gname
INSERT INTO customer (cust_no,  cust_fname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (14, 'Price', 'Garcia Frozen', '0467890006', '101 Pitt Street', 'Sydney', '2010');

-- Customer with no cust_fname and cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (15, 'Thomas', '0490123009', '78 Hay Street', 'Perth', '6003');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (16, 'Henry', 'Lucas', '0412345011', '92 Oxford Street', 'Sydney', '2060');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (17, 'Lily', 'Charlotte', '0423456012', '18 Chapel Street', 'Melbourne', '3004');

INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_bname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (18, 'Victoria', 'Ella', 'Flintstone Store', '0401234020', '94 Henley Beach Road', 'Adelaide', '5095');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (19, 'Daniel', 'Mason', '0456789015', '83 Jetty Road', 'Adelaide', '5063');

-- Customer with no cust_bname
INSERT INTO customer (cust_no, cust_gname, cust_fname, cust_contact_no, cust_street, cust_town, cust_pcode) 
VALUES (20, 'Emily', 'Harper', '0467890016', '127 Parramatta Road', 'Sydney', '2150');


--------------------------------------
--INSERT INTO trailer
--------------------------------------
INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL01', 45000.00, TO_DATE('20-Mar-2022', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL02', 52000.00, TO_DATE('15-Aug-2021', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL03', 38000.00, TO_DATE('10-Feb-2020', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL04', 55000.00, TO_DATE('01-Jun-2023', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL05', 48000.00, TO_DATE('05-Dec-2021', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL06', 60000.00, TO_DATE('10-Mar-2024', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL07', 47000.00, TO_DATE('18-Oct-2022', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL08', 53000.00, TO_DATE('25-Feb-2023', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL09', 49500.00, TO_DATE('12-Jul-2022', 'dd-Mon-yyyy'));

INSERT INTO trailer (trailer_code, trailer_purchase_cost, trailer_date_purchased) 
VALUES ('TRL10', 42000.00, TO_DATE('20-Nov-2020', 'dd-Mon-yyyy'));


--------------------------------------
--INSERT INTO truck
--------------------------------------
INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('1HGBH41JXMN109186', 'ABC123', 45000, 40000, 125000.00, TO_DATE('15-Mar-2022', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('2FMDK3GC8BBA12345', 'DEF456', 78500, 75000, 135000.00, TO_DATE('22-Jul-2021', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('3VWFE21C04M000001', 'GHI789', 120000, 115000, 98000.00, TO_DATE('10-Jan-2020', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('4T1BF1FK5CU123456', 'JKL012', 12000, NULL, 145000.00, TO_DATE('18-May-2024', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('5FNRL5H40BB098765', 'MNO345', 95000, 90000, 115000.00, TO_DATE('03-Nov-2021', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('1FTFW1ET5DFC10112', 'PQR678', 8000, NULL, 155000.00, TO_DATE('28-Feb-2025', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('2C4RDGCG8ER123789', 'STU901', 67000, 65000, 128000.00, TO_DATE('12-Sep-2022', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('3GNKBERS5KS654321', 'VWX234', 88000, 82000, 142000.00, TO_DATE('20-Jan-2023', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('5XYKT3A69CG234567', 'YZA567', 11000, NULL, 138000.00, TO_DATE('07-Jun-2025', 'dd-Mon-yyyy'));

INSERT INTO truck (truck_vin, truck_rego, truck_kms, truck_last_service_kms, truck_purchase_cost, truck_date_purchased) 
VALUES ('1G1ZD5ST8LF098765', 'BCD890', 105000, 102000, 105000.00, TO_DATE('15-Oct-2020', 'dd-Mon-yyyy'));


--------------------------------------
--INSERT INTO combination
--------------------------------------
INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('1HGBH41JXMN109186', 'TRL01');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('2FMDK3GC8BBA12345', 'TRL02');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('3VWFE21C04M000001', 'TRL03');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('4T1BF1FK5CU123456', 'TRL04');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('5FNRL5H40BB098765', 'TRL05');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('1FTFW1ET5DFC10112', 'TRL06');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('2C4RDGCG8ER123789', 'TRL07');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('5XYKT3A69CG234567', 'TRL08');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('1HGBH41JXMN109186', 'TRL05');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('2FMDK3GC8BBA12345', 'TRL08');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('3VWFE21C04M000001', 'TRL01');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('4T1BF1FK5CU123456', 'TRL07');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('5FNRL5H40BB098765', 'TRL02');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('1FTFW1ET5DFC10112', 'TRL04');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('2C4RDGCG8ER123789', 'TRL03');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('5XYKT3A69CG234567', 'TRL06');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('1HGBH41JXMN109186', 'TRL08');

INSERT INTO combination (truck_vin, trailer_code) 
VALUES ('2FMDK3GC8BBA12345', 'TRL01');


COMMIT;

SET ECHO OFF
