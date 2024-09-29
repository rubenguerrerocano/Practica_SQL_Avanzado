DROP TABLE IF EXISTS bootcamp_lesson;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS lesson;
DROP TABLE IF EXISTS bootcamp;
DROP TABLE IF EXISTS customer;


CREATE TABLE bootcamp (
    bootcamp_id SERIAL PRIMARY KEY,
    bootcamp_des VARCHAR(100) NOT NULL,
    edition INT NOT NULL,
    price FLOAT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    git_repository VARCHAR(200) NOT NULL,
    discord_link VARCHAR(200)
);

ALTER TABLE bootcamp
ALTER COLUMN discord_link SET NOT NULL;


CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nif VARCHAR(15) NOT NULL,
    phone_number INT NOT NULL,
    bootcamp_id INT NOT NULL,
    CONSTRAINT fk_bootcamp FOREIGN KEY (bootcamp_id) REFERENCES bootcamp (bootcamp_id)
);

CREATE TABLE professor (
    professor_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number INT NOT NULL
);



CREATE TABLE lesson (
    lesson_id SERIAL PRIMARY KEY,
    lesson_des VARCHAR(200) NOT NULL,
    professor_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT fk_professor FOREIGN KEY (professor_id) REFERENCES professor (professor_id)
);



CREATE TABLE bootcamp_lesson (
    bootcamp_lesson_id SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL,
    lesson_id INT NOT NULL,
    CONSTRAINT fk_bootcamp_lesson FOREIGN KEY (bootcamp_id) REFERENCES bootcamp (bootcamp_id),
    CONSTRAINT fk_lesson FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id)
);

INSERT INTO bootcamp (bootcamp_des, edition, price, start_date, end_date, git_repository, discord_link) VALUES
('BIG DATA',14,7500, DATE '2024-05-31', DATE '2025-04-01', 'www.github.com/Keepcoding/BigData', 'www.discord.com/Keepcoding/BigData'),
('IA',2,9500, DATE '2024-07-31', DATE '2025-05-01', 'www.github.com/Keepcoding/IA', 'www.discord.com/Keepcoding/IA'),
('FULL STACK',23,7500, DATE '2024-05-31', DATE '2025-02-01', 'www.github.com/Keepcoding/FullStack', 'www.discord.com/Keepcoding/FullStack'),
('MARKETING',8,5000, DATE '2024-05-31', DATE '2024-12-01', 'www.github.com/Keepcoding/Marketing', 'www.discord.com/Keepcoding/Marketing'),
('JAVA',19,6500, DATE '2024-10-31', DATE '2025-07-01', 'www.github.com/Keepcoding/Java', 'www.discord.com/Keepcoding/Java');


INSERT INTO customer (name, surname, email, nif, phone_number, bootcamp_id) VALUES
('PEPE','PEPON', 'PEPEPEPON@GMAIL.COM', '12345678A', 123456789, 1),
('MARTA','MARTINEZ', 'LAMARTUCA@GMAIL.COM', '12345678B', 234567891, 2),
('LORENA','SIERRA', 'LORENAGUADARRAMA@GMAIL.COM', '12345678C', 345678912, 3),
('CARLOS','CALVO', 'ELPELON@GMAIL.COM', '12345678D', 456789123, 4),
('SANDRA','ESPEJO', 'SANDRAMIRROR@GMAIL.COM', '12345678E', 567891234, 5);


INSERT INTO professor (name, surname, email,phone_number) VALUES
('ALEX','LOPEZ', 'APTOATODOS@GMAIL.COM', 225544887),
('RAMON','MON', 'MON@GMAIL.COM', 999666333),
('PEDRO','RIA', 'PEDROELDELAIA@GMAIL.COM', 147258369),
('CARLA','BRAVO', 'CARLABRAVO@GMAIL.COM', 963852741),
('SANDRA','NAVARRO', 'LAJEFA@GMAIL.COM', 369852147);

INSERT INTO lesson (lesson_des, professor_id, start_date,end_date) VALUES
('SQL AVANZADO',1, DATE '2024-09-06', DATE '2024-09-20'),
('INFORMATICA 101',2, DATE '2024-05-31', DATE '2024-06-10'),
('GOOGLE CLOUD',3, DATE '2024-05-31', DATE '2024-06-07'),
('INTRODUCCION A JAVA',4, DATE '2024-03-31', DATE '2024-04-12'),
('BIG DATA TOUR',5, DATE '2024-09-02', DATE '2024-09-02');

INSERT INTO bootcamp_lesson (bootcamp_id, lesson_id) VALUES
(1,1),
(1,5),
(2,1),
(2,5),
(3,2),
(1,3),
(2,3),
(3,4),
(3,3),
(4,2),
(3,4);