from db.Postgresdb import Postgresdb
from db.QueryExecutor import QueryExecutor


if __name__ == "__main__":
    db = Postgresdb()
    db.connect()

    qe = QueryExecutor(db)

    qe.select_rooms_with_person_count()
    qe.select_rooms_with_min_avg_age()
    qe.select_rooms_with_max_gape_year()
    qe.select_diff_sex_rooms()

    db.close()
