from decimal import Decimal


def convert_result(row):
    return [float(v) if isinstance(v, Decimal) else v for v in row]


class QueryResTransformer:
    def __init__(self, queries):
        self.queries = queries

    def transform(self, raw_results):
        return [
            {
                list(self.queries.keys())[0]: [
                    {"name": name, "count": count}
                    for name, count in raw_results[list(self.queries.keys())[0]]
                ]
            },
            {
                list(self.queries.keys())[1]: [
                    {"name": name, "avg_age": float(age)}
                    for name, age in raw_results[list(self.queries.keys())[1]]
                ]
            },
            {
                list(self.queries.keys())[2]: [
                    {"name": name, "age_gap": float(gap)}
                    for name, gap in raw_results[list(self.queries.keys())[2]]
                ]
            },
            {
                list(self.queries.keys())[3]: [
                    {"name": name}
                    for (name,) in raw_results[list(self.queries.keys())[3]]
                ]
            },
        ]
