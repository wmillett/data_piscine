import os
import csv
from dotenv import load_dotenv
import psycopg2

FOLDER = 'item'
TEMPLATE_FILE = 'items_table.sql'

# Load environment variables from .env file
load_dotenv()

# Read your SQL template for creating the table
with open(TEMPLATE_FILE, 'r') as f:
    create_table_sql = f.read().split("COPY")[0]  # Extract only the CREATE TABLE part

# Connect to the database
conn = psycopg2.connect(
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT")
)
cur = conn.cursor()

# Create the table
try:
    # Ensure the table name is correctly formatted in the SQL command
    formatted_sql = create_table_sql
    print(f"Executing SQL: {formatted_sql}")  # Debugging line
    cur.execute(formatted_sql)
    conn.commit()
    print("Created table items")
except Exception as e:
    print(f"Failed to create table items: {e}")
    conn.rollback()

# Read the CSV file and insert data
try:
    csv_filename = 'item.csv'
    csv_path = os.path.join(FOLDER, csv_filename)

    with open(csv_path, 'r') as csvfile:
        csv_reader = csv.reader(csvfile)
        headers = next(csv_reader)  # Skip the header row
        for row in csv_reader:
            # Replace empty strings with None
            row = [None if value == '' else value for value in row]
            # Create a parameterized query for inserting data
            placeholders = ', '.join(['%s'] * len(row))
            insert_sql = f"INSERT INTO items VALUES ({placeholders})"
            cur.execute(insert_sql, row)
    conn.commit()
    print(f"✅ Imported {csv_filename}")
except Exception as e:
    print(f"❌ Failed to import {csv_filename}: {e}")
    conn.rollback()

cur.close()
conn.close()
