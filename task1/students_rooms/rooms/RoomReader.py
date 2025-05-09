class RoomReader:
    def __init__(self, db):
        self.db = db

    def select_all_rooms(self):
        self.db.execute("SELECT * FROM rooms;")
        rows = self.db.fetch_all()
        for row in rows:
            print(row)
