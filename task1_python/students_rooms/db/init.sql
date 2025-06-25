CREATE TABLE IF NOT EXISTS rooms
(
    id serial PRIMARY KEY,
    name character varying(10) NOT NULL,
    check_in_time timestamp without time zone NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS students
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