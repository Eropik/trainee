class QueryService:
    def __init__(self, db):
        self.db = db

    def execute_query_from_file1(self, filepath: str):
        with open(filepath, "r", encoding="utf-8") as file:
            query = file.read()
            self.db.execute(query)
            res = self.db.execute("select * from proceed_files")
            for row in res:
                print(row)
            return self.db.fetch_all()

    def execute_query_from_file(self, filepath: str):
        with open(filepath, "r", encoding="utf-8") as file:
            query = file.read()
            self.db.execute(query)
            res = self.db.fetch_all()  # Now properly gets results

            if not res:  # Handle empty results
                print(f"Query from {filepath} returned no data")
                return []

            return res
