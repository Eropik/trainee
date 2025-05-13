from file.JsonReader import JsonReader

class FileProcessingService:
    def __init__(self, db, student_repo, room_repo, file_repo):
        self.db = db
        self.student_repo = student_repo
        self.room_repo = room_repo
        self.file_repo = file_repo

    def process(self, filename, filepath):
        reader = JsonReader(filepath)
        data = reader.read()

        try:
            table_type = filename.split('_')[0]

            if table_type == "rooms":
                self.room_repo.truncate()
                self.room_repo.insert(data)
            elif table_type == "students":
                self.student_repo.truncate()
                self.student_repo.insert(data)

            self.file_repo.add(filename)
            print(f"Successfully processed {filename}")
        except Exception as e:
            print(f"Failed to process {filename}: {str(e)}")
            raise
