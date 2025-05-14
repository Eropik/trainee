from datetime import datetime


class StudentRepository:
    def __init__(self, db):
        self.db = db

    def truncate(self):
        self.db.execute("TRUNCATE students RESTART IDENTITY CASCADE")

    def insert(self, students):
        for student in students:
            self.db.execute("INSERT INTO students (birthday, name, sex, room, check_out_time)VALUES (%s, %s, %s, %s, %s)",
                            (datetime.fromisoformat(student["birthday"]),
                             student["name"],
                             student["sex"],
                             student["room"],
                             datetime.fromisoformat(student["check_out_time"])))
