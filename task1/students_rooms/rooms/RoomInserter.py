from db.Postgresdb import Postgresdb
from file.JsonReader import JsonReader
from RoomReader import RoomReader
from RoomWriter import RoomWriter
import os
from dotenv import load_dotenv

load_dotenv()

FILE_PATH_ROOMS = os.getenv("FILE_PATH_ROOMS")

if __name__ == "__main__":
    db = Postgresdb()
    db.connect()

    reader = JsonReader(FILE_PATH_ROOMS)
    data = reader.read()

    writer = RoomWriter(db)
    writer.insert_rooms(data)

    reader = RoomReader(db)
    reader.select_all_rooms()


    db.close()
