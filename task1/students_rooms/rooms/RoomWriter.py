class RoomWriter:
    def __init__(self, db):
        self.db = db

    def insert_rooms(self, rooms):
        for room in rooms:
            room_id = room["id"]
            name = room["name"]
            self.db.execute("INSERT INTO rooms(id,name) VALUES (%s,%s);", (room_id, name))
