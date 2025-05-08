from Postgresdb import Postgresdb
from JsonReader import JsonReader
from RoomWriter import RoomWriter
import os
from dotenv import load_dotenv

load_dotenv()

if __name__ == "__main__":
    db = Postgresdb()
    db.connect()

    reader = JsonReader(os.getenv("FILE_PATH"))
    data = reader.read()

    inserter = RoomWriter(db)
    inserter.insert_rooms(data)

    db.execute("SELECT * FROM rooms;")
    rows = db.fetch_all()
    for row in rows:
        print(row)

    db.close()
