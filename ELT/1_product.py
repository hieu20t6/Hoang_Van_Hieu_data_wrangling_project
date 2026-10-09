import pandas as pd
from sqlalchemy import create_engine

data = pd.read_csv(r'D:\data_wrangling_project\product.csv')

data['ingestion_at'] = pd.Timestamp.now()

print(data.head())

engine = create_engine('postgresql+psycopg2://postgres:postgres@localhost:5432/e_wallet')
print("Connection to PostgreSQL database successfully!")

data.to_sql(
    name = 'product',
    con = engine,
    schema = 'bronze',
    if_exists = 'replace'
)
