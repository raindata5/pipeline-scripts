from pymongo import MongoClient
import csv
import boto3
import datetime
from datetime import timedelta
import configparser

parser = configparser.ConfigParser()
parser.read("pipeline.conf")
hostname = parser.get("mongodb_creds", "hostname")
username = parser.get("mongodb_creds", "username")
password = parser.get("mongodb_creds", "password")
database = parser.get("mongodb_creds", "database")
collection = parser.get("mongodb_creds", "collection")



client = MongoClient("mongodb+srv://" + username +":" + password + "@" + hostname + "/" + database
                + "?retryWrites=true&"
                + "w=majority&ssl=true&"
                + "ssl_cert_reqs=CERT_NONE")
# client = MongoClient("mongodb+srv://" + username +":" + password + "@" + hostname + "/" + database + "?retryWrites=true&w=majority")

db = client[database]
mongo_collection = db[collection]


# can make provisions to query a datetime value from my DW to 
# get all the values that were added after a particular time

startime = datetime.datetime.today() + timedelta(days=-1)
endtime = startime + timedelta(days=2)

mongo_query= {"$and":[{"event_timestamp": {"$gte": startime}}, {"event_timestamp": {"$lt": endtime}}]}

result_docs = mongo_collection.find(mongo_query, batch_size=1500)
result_docs

event_store = []

for doc in result_docs:
    eventid = str(doc.get("event_id", -1))
    event_timestamp = doc.get("event_timestamp", None)
    event_name = doc.get("event_name", None)

    current_event = []
    current_event.append(eventid)
    current_event.append(event_timestamp)
    current_event.append(event_name)

    event_store.append(current_event)

local_filename = "mongodb_extract.csv"

with open(local_filename, 'w') as fp:
    csv_w  =csv.writer(fp, delimiter='|')
    csv_w.writerows(event_store)

fp.close()

parser = configparser.ConfigParser()
parser.read("pipeline.conf")
access_key = parser.get("aws_boto_credentials","access_key")
secret_key = parser.get("aws_boto_credentials","secret_key")
bucket_name = parser.get("aws_boto_credentials","bucket_name")

s3 = boto3.client('s3',
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key)

s3_file = local_filename

s3.upload_file(local_filename, bucket_name, s3_file)