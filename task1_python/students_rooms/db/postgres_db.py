import os
from dotenv import load_dotenv
import psycopg2
from db.interface_db import DatabaseInterface

load_dotenv()


class PostgresConnector(DatabaseInterface):
    def __init__(self):
        self.connection = None
        self.cursor = None

    def connect(self):
        self.connection = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            port=int(os.getenv("DB_PORT"))
        )
        self.cursor = self.connection.cursor()
        print("Connected")

    def close(self):
        self.cursor.close()
        self.connection.close()
        print("Conn closed")

    def execute(self, query: str, params=None):
        self.cursor.execute(query, params)

    def fetch_all(self):
        return self.cursor.fetchall()
