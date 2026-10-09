import pandas as pd
from sqlalchemy import create_engine

data = pd.read_csv(r'D:\data_wrangling_project\transactions.csv')

duplicated_rows = data[data.duplicated(keep=False)]
print(duplicated_rows)