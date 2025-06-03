import os
from dotenv import load_dotenv
import psycopg2

FOLDER = 'customer'
TEMPLATE_FILE = 'automatic_table.sql'

# Load environment variables from .env file
load_dotenv()

# Read your SQL template
with open(TEMPLATE_FILE) as f:
    sql_template = f.read()

# Get variables from environment
conn = psycopg2.connect(
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT")
)
cur = conn.cursor()

# Iterate through CSVs
for filename in os.listdir(FOLDER):
    if filename.endswith('.csv'):
        table_name = os.path.splitext(filename)[0].lower()
        csv_path = f"/customer/{filename}"

        # Create SQL for this file
        sql = sql_template.format(table_name=table_name, csv_path=csv_path.replace("\\", "/"))

        print(f"Importing {filename} into table {table_name}...")
        try:
            cur.execute(sql)
            conn.commit()
            print(f"✅ Imported {filename}")
        except Exception as e:
            conn.rollback()
            print(f"❌ Failed to import {filename}: {e}")

cur.close()
conn.close()
