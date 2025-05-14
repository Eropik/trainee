import os
from datetime import datetime


class DirectoryWatcher:
    def __init__(self, watch_dir, model_service, file_repo):
        self.watch_dir = watch_dir
        self.model_service = model_service
        self.file_repo = file_repo

    def watch(self):
        processed_files = self.file_repo.get_all_processed()

        for filename in os.listdir(self.watch_dir):
            if filename.endswith(".json") and filename not in processed_files:
                path = os.path.join(self.watch_dir, filename)
                try:
                    date_str = filename.split('_')[1].replace('.json', '')
                    datetime.strptime(date_str, '%d.%m.%Y')
                    self.model_service.process(filename, path)
                except Exception as e:
                    print(f"Skipping {filename}: {str(e)}")
