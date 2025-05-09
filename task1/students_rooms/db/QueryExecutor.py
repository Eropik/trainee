import os
from dotenv import load_dotenv

from file.FileReader import FileReader

load_dotenv()

FILE_PATH_1_QUERY = os.getenv("FILE_PATH_1_QUERY")
FILE_PATH_2_QUERY = os.getenv("FILE_PATH_2_QUERY")
FILE_PATH_3_QUERY = os.getenv("FILE_PATH_3_QUERY")
FILE_PATH_4_QUERY = os.getenv("FILE_PATH_4_QUERY")


class QueryExecutor:
    def __init__(self, db):
        self.db = db

    def select_rooms_with_person_count(self):
        print("\ncount person in room (print only 5):")
        file_reader = FileReader(FILE_PATH_1_QUERY)
        self.db.execute(file_reader.read())
        rows = self.db.fetch_all()
        for row in rows:
            print(row)

    def select_rooms_with_min_avg_age(self):
        print("\n5 rooms with min average age:")
        file_reader = FileReader(FILE_PATH_2_QUERY)
        self.db.execute(file_reader.read())
        rows = self.db.fetch_all()
        for row in rows:
            print(row)

    def select_rooms_with_max_gape_year(self):
        print("\n5 rooms with max age gape:")
        file_reader = FileReader(FILE_PATH_3_QUERY)
        self.db.execute(file_reader.read())
        rows = self.db.fetch_all()
        for row in rows:
            print(row)

    def select_diff_sex_rooms(self):
        print("\nrooms, where living both sexes(print only 5):")
        file_reader = FileReader(FILE_PATH_4_QUERY)
        self.db.execute(file_reader.read())
        rows = self.db.fetch_all()
        for row in rows:
            print(row)
