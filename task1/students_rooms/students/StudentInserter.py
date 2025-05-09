from db.Postgresdb import Postgresdb
from file.JsonReader import JsonReader
from StudentWriter import StudentWriter
from StudentReader import StudentReader
import os
from dotenv import load_dotenv

load_dotenv()

FILE_PATH_STUDENTS = os.getenv("FILE_PATH_STUDENTS")

if __name__ == "__main__":
    db = Postgresdb()
    db.connect()

    reader = JsonReader(FILE_PATH_STUDENTS)
    data = reader.read()

    writer = StudentWriter(db)
    writer.insert_students(data)

    reader = StudentReader(db)
    reader.select_all_from_students()

    db.close()
