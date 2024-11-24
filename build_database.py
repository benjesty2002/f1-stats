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
    backup_path = os.path.join(__directory__, "old_databases", f"{database_name}-{timestamp}.sqlite")
    os.rename(database_path, backup_path)

# create new database
conn = sqlite3.connect(database_path)

# load data into database
for csv_dir in ["csvs", "additional_tables"]:
    for csv_file in os.listdir(csv_dir):
        if csv_file.endswith(".csv"):
            pandas.read_csv(f"{csv_dir}/{csv_file}").to_sql(csv_file[:-4], conn, index=False)

# run build statements
cursor = conn.cursor()
for sql_file in os.listdir("build_statements"):
    if sql_file.endswith(".sql"):
        print(f"building {sql_file}")
        with open(f"build_statements/{sql_file}", "r") as f:
            sql = f.read()
            for sql_part in sql.split(";"):
                cursor.execute(sql_part)

# run queries
# cursor = conn.cursor()
for sql_file in os.listdir("queries"):
    if sql_file.endswith(".sql"):
        print(f"running query {sql_file}")
        with open(f"queries/{sql_file}", "r") as f:
            sql = f.read()
            cursor.execute(sql)
            field_names = [d[0] for d in cursor.description]
            results = cursor.fetchall()
            df = pandas.DataFrame(results, columns=field_names)
            df.to_csv(f"queries/{sql_file[:-4]}.csv", index=False)

            # save query to table
            table_name = f"query_{sql_file[:-4]}".replace("-", "_")
            cursor.execute(f"CREATE TABLE {table_name} AS {sql};")


# close connection to database
conn.close()
