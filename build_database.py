import sqlite3
import pandas
import sys
import os

from datetime import datetime

__directory__ = os.path.dirname(__file__)
database_name = "f1-stats"
database_path = os.path.join(__directory__, f"{database_name}.sqlite")

# back up old database
if os.path.exists(database_path):
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup_path = os.path.join(__directory__, f"{database_name}-{timestamp}.sqlite")
    os.rename(database_path, backup_path)

# create new database
conn = sqlite3.connect(database_path)

# load data into database
for csv_file in os.listdir("csvs"):
    if csv_file[-4:] == ".csv":
        pandas.read_csv(f"csvs/{csv_file}").to_sql(csv_file[:-4], conn, index=False)

# run queries
cursor = conn.cursor()
for sql_file in os.listdir("queries"):
    if sql_file[-4:] == ".sql":
        with open(f"queries/{sql_file}", "r") as f:
            sql = f.read()
            cursor.execute(sql)
            field_names = [d[0] for d in cursor.description]
            results = cursor.fetchall()
            df = pandas.DataFrame(results, columns=field_names)
            df.to_csv(f"queries/{sql_file[:-4]}.csv", index=False)

# close connection to database
conn.close()
