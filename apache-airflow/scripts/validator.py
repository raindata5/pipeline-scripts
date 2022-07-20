import psycopg2
import os
import sys
import requests
import json
import configparser
# needs sql error handling
def db_conn():
    
    parser = configparser.ConfigParser()
    parser.read("/mnt/c/Users/Ron/git-repos/pipeline-scripts/pipeline.conf")
    dbname = parser.get("postgres_dwh", "database")
    user = parser.get("postgres_dwh", "username")
    password = parser.get("postgres_dwh", "password")
    host = parser.get("postgres_dwh", "host")
    port = parser.get("postgres_dwh", "port")

    ps_conn = psycopg2.connect(dbname=dbname, user=user, password=password, host= host, port=port)
    return ps_conn

# needs sql error handling
def commit_test(database_conn, sql_script_1, sql_script_2, comparison_operator):
    cursor = database_conn.cursor()
    sql_file = open(sql_script_1,'r')
    cursor.execute(sql_file.read())


    record = cursor.fetchone()
    res_1 = record[0]

    database_conn.commit()
    cursor.close()

    # 2nd file
    cursor = database_conn.cursor()
    sql_file = open(sql_script_2,'r')
    cursor.execute(sql_file.read())


    record = cursor.fetchone()
    res_2 = record[0]

    database_conn.commit()
    cursor.close()

    print("result 1 = " + str(res_1))
    print("result 2 = " + str(res_2))

    # compare values based on the comp_operator
    if comparison_operator == "equals":
        return res_1 == res_2
    elif comparison_operator == "greater_equals":
        return res_1 >= res_2
    elif comparison_operator == "greater":
        return res_1 > res_2
    elif comparison_operator == "less_equals":
        return res_1 <= res_2
    elif comparison_operator == "less":
        return res_1 < res_2
    elif comparison_operator == "not_equal":
        return res_1 != res_2

    return False

def send_slack_notification(result, script_1, script_2, comp_operator, webhook_url):
    try:
        if result:
            message = {"text": f"tested {script_1} {comp_operator} {script_2} and the result was a PASS"}
        else:
            message = {"text": f"tested {script_1} {comp_operator} {script_2} and the result was a FAILURE"}
        res = requests.request(method="POST",url=webhook_url, data=json.dumps(message), headers={'Content-Type': 'application/json'})
        if res != 200 :
            print(res)
            print(res.status_code)
            return False
    except Exception as e:
        print("sending of slack message failed")
        print(e)


def log_end_result(result, script_1, script_2, comp_operator, db_conn):
    load_query = """INSERT INTO validation_run_history(
                    script_1,
                    script_2,
                    comp_operator,
                    test_result,
                    test_run_at)
                VALUES(%s, %s, %s, %s,
                    current_timestamp);"""
    cursor = db_conn.cursor()
    cursor.execute(load_query, (script_1, script_2, comp_operator, result,))
    db_conn.commit()
    cursor.close()
    db_conn.close()
    return "logged"






if __name__ == "__main__":
    if len(sys.argv) == 2 and (sys.argv[1] == '-h' or '--help'):
        print("Usage: python validator.py"
            + " script1.sql script2.sql "
            + "comparison_operator"
            + "severity_level")
        print("Valid comparison_operator values:")
        print("equals")
        print("greater_equals")
        print("greater")
        print("less_equals")
        print("less")
        print("not_equal")
        exit(0)

    if len(sys.argv) != 5:
        print("Usage: python validator.py"
            + "script1.sql script2.sql "
            + "comparison_operator"
            + "severity_level")
        exit(-1)

    script_1 = sys.argv[1]
    script_2 = sys.argv[2]
    comp_operator = sys.argv[3]
    sev = sys.argv[4]
    conn = db_conn()

    test_result = commit_test(conn, script_1, script_2, comparison_operator=comp_operator)
    log_end_result(test_result,script_1=script_1, script_2=script_2, comp_operator=comp_operator, db_conn=conn)

    print("Result of test: " + str(test_result))
    webhook_url='https://hooks.slack.com/services/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'
    if test_result == True:
        send_slack_notification(result=test_result, script_1=script_1, script_2 = script_2, comp_operator=comp_operator, webhook_url=webhook_url)
        exit(0)
       
    else:
        send_slack_notification(result=test_result, script_1=script_1, script_2 = script_2, comp_operator=comp_operator, webhook_url=webhook_url)
        if sev == "halt":
            exit(-1)
        if sev == "warn":
            exit(0)