class RoomWriter:
    def __init__(self, db):
        self.db = db

    def insert_rooms(self, rooms):
        for room in rooms:
            name = room["name"]
            self.db.execute("INSERT INTO rooms(name) VALUES (%s);", (name,))
