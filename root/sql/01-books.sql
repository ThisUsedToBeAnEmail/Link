DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS book_authors CASCADE;

CREATE TABLE books (
    id              SERIAL PRIMARY KEY,
    title           TEXT,
    description		TEXT,
	cover_image		TEXT,
	rating          INTEGER,
    created         TIMESTAMP NOT NULL DEFAULT now(),
    updated         TIMESTAMP
);

CREATE TABLE authors (
    id              SERIAL PRIMARY KEY,
    first_name      TEXT,
    last_name       TEXT,
	thumbnail		TEXT
);

CREATE TABLE book_authors (
    book_id         INTEGER REFERENCES books(id) ON DELETE CASCADE ON UPDATE CASCADE,
    author_id       INTEGER REFERENCES authors(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (book_id, author_id)
);

INSERT INTO books (title, rating) VALUES ('CCSP SNRS Exam Certification Guide', 5);
INSERT INTO books (title, rating) VALUES ('TCP/IP Illustrated, Volume 1', 5);
INSERT INTO books (title, rating) VALUES ('Internetworking with TCP/IP Vol.1', 4);
INSERT INTO books (title, rating) VALUES ('Perl Cookbook', 5);
INSERT INTO books (title, rating) VALUES ('Designing with Web Standards', 5);
INSERT INTO authors (first_name, last_name) VALUES ('Greg', 'Bastien');
INSERT INTO authors (first_name, last_name) VALUES ('Sara', 'Nasseh');
INSERT INTO authors (first_name, last_name) VALUES ('Christian', 'Degu');
INSERT INTO authors (first_name, last_name) VALUES ('Richard', 'Stevens');
INSERT INTO authors (first_name, last_name) VALUES ('Douglas', 'Comer');
INSERT INTO authors (first_name, last_name) VALUES ('Tom', 'Christiansen');
INSERT INTO authors (first_name, last_name) VALUES ('Nathan', 'Torkington');
INSERT INTO authors (first_name, last_name) VALUES ('Jeffrey', 'Zeldman');
INSERT INTO book_authors VALUES (1, 1);
INSERT INTO book_authors VALUES (1, 2);
INSERT INTO book_authors VALUES (1, 3);
INSERT INTO book_authors VALUES (2, 1);
INSERT INTO book_authors VALUES (2, 4);
INSERT INTO book_authors VALUES (3, 5);
INSERT INTO book_authors VALUES (4, 6);
INSERT INTO book_authors VALUES (4, 7);
INSERT INTO book_authors VALUES (5, 8);
