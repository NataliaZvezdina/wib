from datetime import datetime, date
from sqlalchemy import create_engine, MetaData
from faker import Faker
import os
import sys


user = os.environ['POSTGRES_USER']
password = os.environ['POSTGRES_PASSWORD']
db = os.environ['POSTGRES_DB']

engine = create_engine(f"postgresql://{user}:{password}@postgres_db:5432/{db}")
metadata = MetaData()
faker = Faker()

with engine.connect() as conn:
    metadata.reflect(conn)

users = metadata.tables["users"]
items = metadata.tables["items"]
purchases = metadata.tables["purchases"]


class GenerateData:
    def __init__(self):
        """
        Define command line argument.
        """
        self.num_records = int(sys.argv[1])

    def create_data(self):
        """
        Using the faker library, generate data and execute DML.
        """
        with engine.begin() as conn:
            for _ in range(self.num_records):
                insert_stmt_users = users.insert().values(age=faker.random_int(18, 50))
                insert_stmt_items = items.insert().values(price=faker.random_int(1, 10000) / 100.0)
                conn.execute(insert_stmt_users)
                conn.execute(insert_stmt_items)

            for _ in range(self.num_records * 2):
                insert_stmt_purchases = purchases.insert().values(
                    user_id=faker.random_int(1, self.num_records),
                    item_id=faker.random_int(1, self.num_records),
                    date=faker.date_between_dates(
                        date_start=date(year=2020, month=1, day=1), date_end=datetime.today()
                    )
                )
                conn.execute(insert_stmt_purchases)


if __name__ == "__main__":
    generate_data = GenerateData()
    generate_data.create_data()
