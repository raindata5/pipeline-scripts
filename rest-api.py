import requests
import json
import csv
import boto3
import configparser

lat = 42.36
lon = 71.05
params = {"lat": lat, "lon": lon}

api_response = requests.get("http://api.open-notify.org/iss-pass.json", params=params)

print(api_response.content)

data = json.loads(api_response.content)

data.keys()


all_passes = []
for row in data['response']:
    current_pass = []
    # coordinate information so it can accompany rest of data on each line
    current_pass.append(lat)
    current_pass.append(lon)

    current_pass.append(row['duration'])
    current_pass.append(row['risetime'])
    
    all_passes.append(current_pass)

len(all_passes)

filename = 'iss_data.csv'

with open(filename, 'w') as fp:
    csvw = csv.writer(fp, delimiter='|')
    csvw.writerows(all_passes)

fp.close()


parser = configparser.ConfigParser()
parser.read("pipeline.conf")
access_key = parser.get("aws_boto_credentials","access_key")
secret_key = parser.get("aws_boto_credentials","secret_key")
bucket_name = parser.get("aws_boto_credentials","bucket_name")

s3 = boto3.client('s3',
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key)

s3_file = filename

s3.upload_file(filename, bucket_name, s3_file)

# secondary method for data
# import pandas as pd

# relational_file = pd.json_normalize(data, 'response', [['request','latitude'],['request','longitude']])
# relational_file.to_records('lists')
# relational_file.to_csv('iss_data2.csv', header=False)
# relational_file.to_csv('iss_data3.csv', header=False, sep="|")