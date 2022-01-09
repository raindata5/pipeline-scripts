import psycopg2
import os
import sys
import requests
import json
import configparser

from validator import db_conn, log_end_result, send_slack_notification
webhook_url='https://hooks.slack.com/services/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'


def test_duplicates(database_conn_func, args=[], slack_url=webhook_url):
    
    results = []
    args = args[1:]
    for row in args:
        database_conn = database_conn_func()
        cursor = database_conn.cursor()

        sql_file = open(row,'r')
        cursor.execute(sql_file.read())

        record = cursor.fetchone()
        res = record[0]
        if res > 0:
            results.append(1)
            log_end_result(result=False, script_1=row, script_2=None, comp_operator=None, db_conn=database_conn)
            send_slack_notification(result=False,script_1=row, script_2=None, comp_operator=None, webhook_url=slack_url)
        else: 
            log_end_result(result=True, script_1=row, script_2=None, comp_operator=None, db_conn=database_conn)
            send_slack_notification(result=True,script_1=row, script_2=None, comp_operator=None, webhook_url=slack_url)
            results.append(0)

    if 1 in results:
        return False
    elif 1 not in results:
        return True

if __name__ == "__main__":
    if len(sys.argv) == 2 and (sys.argv[1] == '-h' or '--help'):
        print("Usage: python validator.py"
            + " script1.sql script2.sql + script(N).sql... "
            
            )
        exit(0)

    if len(sys.argv) < 2:
        print("Usage: python validator_dups.py"
            + " script1.sql script2.sql + script(N).sql... "
            )
        exit(-1)
    
    result_of_tests = test_duplicates(database_conn_func=db_conn, args=list(sys.argv))
    conn = db_conn()
    cursor = conn.cursor()
    cursor.execute(" TRUNCATe stateabbreviations ")
    conn.commit()
    conn.close()

    if result_of_tests == True:
        print('sigue')
        exit(0)
        
    else: 
        print('no sigas')
        exit(-1)
    