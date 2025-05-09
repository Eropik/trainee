from datetime import datetime


class StudentWriter:
    def __init__(self, db):
        self.db = db

    def insert_students(self, students):
        for student in students:
            student_id = student["id"]
            name = student["name"]
            room = student["room"]
            birthday = datetime.fromisoformat(student["birthday"]).date()

            sex = student["sex"]
            self.db.execute(
                "INSERT INTO students(id,birthday, name, sex, room) VALUES (%s,%s, %s, %s, %s);",
                (student_id,birthday, name, sex, room)
            )
