import boto3
import configparser
import psycopg2

parser = configparser.ConfigParser()
parser.read('pipeline.conf')
dbname = parser.get('aws_creds','database')
user = parser.get('aws_creds','username')
password = parser.get('aws_creds','password')
host = parser.get('aws_creds','host')
port = parser.get('aws_creds','port')


rs_conn = psycopg2.connect('dbname=' + dbname
   + ' user='+user
    +' password='+password
    +' host='+host
    +' port='+port)

parser = configparser.ConfigParser()
parser.read('pipeline.conf')
account_id = parser.get('aws_boto_credentials','account_id')
iam_role = parser.get('aws_creds','iam_role')
bucket_name = parser.get('aws_boto_credentials','bucket_name')


#COPY cmd will be run to load file into rds
file_path = 's3://raindata-datapipeline/order_extract.csv'
role_string = 'arn:aws:iam::330488315383:role/redshiftloadrole'

sql= "COPY a_schema.a_table FROM 's3://raindata-datapipeline/order_extract.csv' iam_role redshiftloadrole"

# creating cursor to exe the copy cmd
cur = rs_conn.cursor()
cur.execute(sql,(file_path,role_string))
cur.close()

rs_conn.commit()
rs_conn.close()
print('success')
