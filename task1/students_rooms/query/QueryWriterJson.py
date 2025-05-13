import os
import json
from decimal import Decimal
from dotenv import load_dotenv
from db.Postgresdb import Postgresdb
from query import QueryService

load_dotenv()

queries = {
    "Person count in y_rooms": os.getenv("FILE_PATH_1_QUERY"),
    "Rooms with min average age": os.getenv("FILE_PATH_2_QUERY"),
    "Rooms with max age gap": os.getenv("FILE_PATH_3_QUERY"),
    "Rooms with both sexes": os.getenv("FILE_PATH_4_QUERY"),
}
file_name = os.getenv("FILE_QUERY_RESULT_NAME")


def convert_result(row):
    return [float(v) if isinstance(v, Decimal) else v for v in row]


def transform_results(raw_results):
    return [
        {
            list(queries.keys())[0]: [
                {"name": name, "count": count}
                for name, count in raw_results[list(queries.keys())[0]]
            ]
        },
        {
            list(queries.keys())[1]: [
                {"name": name, "avg_age": float(age)}
                for name, age in raw_results[list(queries.keys())[1]]
            ]
        },
        {
            list(queries.keys())[2]: [
                {"name": name, "age_gap": float(gap)}
                for name, gap in raw_results[list(queries.keys())[2]]
            ]
        },
        {
            list(queries.keys())[3]: [
                {"name": name}
                for (name,) in raw_results["Rooms with both sexes"]
            ]
        }
    ]


if __name__ == "__main__":
    db = Postgresdb()
    db.connect()

    service = QueryService(db)

    query_results = {}
    for label, path in queries.items():
        rows = service.execute_query_from_file(path)
        query_results[label] = [convert_result(row) for row in rows]

    db.close()

    structured_output = transform_results(query_results)

    with open(file_name, "w", encoding="utf-8") as f:
        json.dump(structured_output, f, ensure_ascii=False, indent=4)

    print(f"Results written to {(file_name.split('/'))[-1]}")


class QueryWriterJson:
    def __init__(self, service):
        self.service = service

    def print_query_result(self, label, filepath):
        print(f"\n{label}:")
        rows = self.service.execute_query_from_file(filepath)
        for row in rows:
            print(row)
