class FileRepository:
    def __init__(self, db):
        self.db = db

    def get_all_processed(self):
        self.db.execute("SELECT name FROM proceed_files")
        return {row[0] for row in self.db.fetch_all()}



    def add(self, filename):
        self.db.execute("INSERT INTO proceed_files (name) VALUES (%s)", (filename,))
