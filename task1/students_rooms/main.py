import os
from dotenv import load_dotenv
from db.postgres_db import Postgresdb
from file.json_writer import JsonWriter
from query.query_res_transformer import QueryResTransformer
from query.query_service import QueryService
from query.query_res_transformer import convert_result
from repository.students_repository import StudentRepository
from repository.room_repository import RoomRepository
from repository.file_repository import FileRepository
from dir_spectator.directory_watcher import DirectoryWatcher
from service.model_service import ModelService

load_dotenv()

if __name__ == "__main__":
    queries = {
        "Person count in rooms": os.getenv("FILE_PATH_1_QUERY"),
        "Rooms with min average age": os.getenv("FILE_PATH_2_QUERY"),
        "Rooms with max age gap": os.getenv("FILE_PATH_3_QUERY"),
        "Rooms with both sexes": os.getenv("FILE_PATH_4_QUERY"),
    }
    output_file = os.getenv("QUERY_RES_DATA")

    db = Postgresdb()
    db.connect()

    student_repo = StudentRepository(db)
    room_repo = RoomRepository(db)
    file_repo = FileRepository(db)

    service = ModelService(db, student_repo, room_repo, file_repo)
    watcher = DirectoryWatcher(os.getenv("DATA_DIR"), service, file_repo)

    watcher.watch()

    query_service = QueryService(db)
    transformer = QueryResTransformer(queries)
    writer = JsonWriter(output_file)

    raw_results = {}
    for label, path in queries.items():
        result = query_service.execute_query_from_file(path)
        raw_results[label] = [convert_result(row) for row in result]

    structured = transformer.transform(raw_results)
    writer.write(structured)

    db.close()