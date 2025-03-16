import pandas as pd


YEARS = [2020, 2024]
POSITIONS = [1, 5]

with open("/Users/benjesty/projects/f1-stats/query_results/rolling_championship.csv", "r") as f:
    rc_full = pd.read_csv(f)

rc = []