import json


class JsonReader:
    def __init__(self, filepath):
        self.filepath = filepath

    def read(self):
        with open(self.filepath) as file:
            return json.load(file)
