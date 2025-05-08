from abc import ABC, abstractmethod


class Interfacedb(ABC):
    @abstractmethod
    def connect(self): pass

    @abstractmethod
    def execute(self, query: str): pass

    @abstractmethod
    def fetch_all(self): pass

    @abstractmethod
    def close(self): pass

