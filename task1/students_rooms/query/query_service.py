class QueryService:
    def __init__(self, db):
        self.db = db

    def execute_query_from_file(self, filepath: str):
        with open(filepath, "r", encoding="utf-8") as file:
            query = file.read()
            self.db.execute(query)
            return self.db.fetch_all()
