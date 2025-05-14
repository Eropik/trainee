class DatabaseInitializer:
    def __init__(self, db):
        self.db = db

    def initialize(self):
        ddl_script = """
        CREATE TABLE IF NOT EXISTS public.rooms
        (
            id serial PRIMARY KEY,
            name character varying(10) NOT NULL,
            check_in_time timestamp without time zone NOT NULL DEFAULT CURRENT_DATE
        );

        CREATE TABLE IF NOT EXISTS public.students
        (
            id serial PRIMARY KEY,
            birthday timestamp without time zone NOT NULL 
                CHECK (birthday < CURRENT_DATE AND birthday > DATE '1900-01-01'),
            name character varying(50) NOT NULL,
            sex character(1),
            room integer NOT NULL,
            check_out_time timestamp without time zone NOT NULL DEFAULT CURRENT_DATE,
            CONSTRAINT students_room_fkey FOREIGN KEY (room)
                REFERENCES public.rooms(id)
        );

        CREATE TABLE IF NOT EXISTS proceed_files (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL
        );
        """

        try:
            self.db.execute(ddl_script)
            print("Database initialized successfully")
        except Exception as e:
            print(f"Database initialization failed: {e}")
            raise
