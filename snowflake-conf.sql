
CREATE or replace STORAGE INTEGRATION s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::330488315383:role/snowflake-role'
STORAGE_ALLOWED_LOCATIONS = ('s3://raindata-datapipeline/');
  
DESC INTEGRATION s3_int
  
GRANT CREATE STAGE ON SCHEMA public TO ROLE ACCOUNTADMIN;
GRANT USAGE ON INTEGRATION s3_int TO ROLE ACCOUNTADMIN;



CREATE or REPLACE FILE FORMAT pipe_csv_format
  TYPE = 'csv'
  FIELD_DELIMITER = '|';


CREATE or replace STAGE my_s3_stage
  STORAGE_INTEGRATION = s3_int
  URL = 's3://raindata-datapipeline/'
  FILE_FORMAT = pipe_csv_format;
  
LIST @my_s3_stage;

COPY INTO DESTINATION_TABLE (SourceKey,OrderStatus, LastUpdated)
  FROM @my_s3_stage/order_extract.csv
  
  
  CREATE or replace STAGE my_s3_stage2
  CREDENTIALS=(AWS_KEY_ID='' AWS_SECRET_KEY='')
  URL = 's3://raindata-datapipeline/'
  FILE_FORMAT = pipe_csv_format;
  
USE SCHEMA demo_db.public; 

create table destination_table
(
    OrderID INT autoincrement start 1 increment 1 ,
    SourceKey INT not null,
    OrderStatus VARCHAR(30) not null,
    LastUpdated TIMESTAMP not null,
    constraint primarykey_orders primary key (OrderID) not enforced
    
) ;

COPY INTO DESTINATION_TABLE (SourceKey,OrderStatus, LastUpdated)
  FROM @my_s3_stage2/order_extract.csv



select * from DESTINATION_TABLE
Truncate DESTINATION_TABLE



-- CREATE TABLE #Orders (
--   OrderId int,
--   OrderStatus varchar(30),
--   OrderDate date,
--   CustomerId int,
--   OrderTotal numeric
-- );

-- INSERT INTO #Orders
--   VALUES(1,'Shipped','2020-06-09',100,50.05);
-- INSERT INTO #Orders
--   VALUES(2,'Shipped','2020-07-11',101,57.45);
-- INSERT INTO #Orders
--   VALUES(3,'Shipped','2020-07-12',102,135.99);
-- INSERT INTO #Orders
--   VALUES(4,'Shipped','2020-07-12',100,43.00);


-- CREATE TABLE #Customers
-- (
--   CustomerId int,
--   CustomerName varchar(20),
--   CustomerCountry varchar(10)
-- );

-- INSERT INTO #Customers VALUES(100,'Jane','USA');
-- INSERT INTO #Customers VALUES(101,'Bob','UK');
-- INSERT INTO #Customers VALUES(102,'Miles','UK');

-- DROP TABLE #Customers
-- DROP TABLE #Orders