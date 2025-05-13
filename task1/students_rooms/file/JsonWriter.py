import json


class JsonWriter:
    def __init__(self, filename):
        self.filename = filename

    def write(self, data):
        with open(self.filename, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        print(f"Results written to {self.filename.split('/')[-1]}")
