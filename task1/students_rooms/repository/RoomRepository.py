from datetime import datetime


class RoomRepository:
    def __init__(self, db):
        self.db = db

    def truncate(self):
        self.db.execute("TRUNCATE rooms RESTART IDENTITY CASCADE")

    def insert(self, rooms):
        for room in rooms:
            self.db.execute("INSERT INTO rooms (name, check_in_time) VALUES (%s, %s)",
                            (room["name"], datetime.fromisoformat(room["check_in_time"])))
