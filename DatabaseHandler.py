import sqlite3
import pandas as pd
import os

from datetime import datetime

from DataSourceHandler import DataSourceHandler

class DatabaseHandler:
    def __init__(self) -> None:
        self.dsh = DataSourceHandler()

        self.database_path = "f1-stats.sqlite"
        if self.database_path not in os.listdir():
            print("databas not found, downloading zipped csvs")
            self.dsh.update_all_from_zip()
            print("building database from zips")
            self.build_database(backup=False)

        print("running queries")
        self.run_queries_folder()
        
    def build_database(self, backup=True):
        # back up old database
        if backup:
            timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
            backup_path = os.path.join("backups", f"{timestamp}.sqlite")
            os.rename(self.database_path, backup_path)

        # create new database
        with sqlite3.connect(self.database_path) as conn:
            for csv_file in os.listdir("csvs"):
                if csv_file[-4:] == ".csv":
                    pd.read_csv(f"csvs/{csv_file}").to_sql(csv_file[:-4], conn, index=False)
        
    def query(self, sql):
        with sqlite3.connect(self.database_path) as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            field_names = [d[0] for d in cursor.description]
            results = cursor.fetchall()
        
        df = pd.DataFrame(results, columns=field_names)
        return df
    
    def run_queries_folder(self):
        for sql_file in os.listdir("queries"):
            if sql_file[-4:] == ".sql":
                with open(f"queries/{sql_file}", "r") as f:
                    sql = f.read()
                    df = self.query(sql)
                    df.to_csv(f"queries/{sql_file[:-4]}.csv", index=False)


if __name__ == "__main__":
    dh = DatabaseHandler()
