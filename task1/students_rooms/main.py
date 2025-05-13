import os
from dotenv import load_dotenv
from db.Postgresdb import Postgresdb
from file.JsonWriter import JsonWriter
from query.QueryResTransformer import QueryResTransformer
from query.QueryService import QueryService
from query.QueryWriterJson import convert_result
from repository.StudentsRepository import StudentRepository
from repository.RoomRepository import RoomRepository
from repository.FileRepository import FileRepository
from service.FileService import FileProcessingService
from dir_spectator.DirWatcher import DirectoryWatcher

load_dotenv()

if __name__ == "__main__":
    queries = {
        "Person count in y_rooms": os.getenv("FILE_PATH_1_QUERY"),
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

    service = FileProcessingService(db, student_repo, room_repo, file_repo)
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
