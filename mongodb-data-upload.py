from pymongo import MongoClient
import datetime
import configparser

# client = MongoClient('<your updated connection string>')
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
# db = client.test
# creating db called gettingStarted
db = client.gettingStarted

#creating a collection called events
events = db.events

event_1 = {
  "event_id": 1,
  "event_timestamp": datetime.datetime.today(),
  "event_name": "signup"
}

event_2 = {
  "event_id": 2,
  "event_timestamp": datetime.datetime.today(),
  "event_name": "pageview"
}

event_3 = {
  "event_id": 3,
  "event_timestamp": datetime.datetime.today(),
  "event_name": "login"
}


events.insert_one(event_1)
events.insert_one(event_2)
events.insert_one(event_3)