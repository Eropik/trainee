class StudentReader:
    def __init__(self, db):
        self.db = db

    def select_all_from_students(self):
        self.db.execute("SELECT * FROM students;")
        rows = self.db.fetch_all()
        for row in rows:
            print(row)
