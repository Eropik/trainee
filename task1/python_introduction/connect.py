import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_PORT = int(os.getenv("DB_PORT"))

try:
    connection = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        port=DB_PORT
    )
    print("connected")
    cursor = connection.cursor()
    cursor.execute("INSERT INTO rooms(name) VALUES('room2');")
    connection.commit()
    cursor.execute('SELECT * FROM rooms;')
    rows = cursor.fetchall()
    connection.commit()
    connection.close()
    for row in rows:
        print(row)
except Exception as e:
    print("error:", e)