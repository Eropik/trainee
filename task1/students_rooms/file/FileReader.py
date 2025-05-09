class FileReader:
    def __init__(self, filepath):
        self.filepath = filepath

    def read(self):
        with open(self.filepath, "r") as file:
            return file.read()
