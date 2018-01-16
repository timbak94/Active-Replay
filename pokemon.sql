CREATE TABLE pokemons (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  trainer_id INTEGER,

  FOREIGN KEY(trainer_id) REFERENCES trainer(id)
);

CREATE TABLE trainers (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  gym_id INTEGER,

  FOREIGN KEY(gym_id) REFERENCES trainer(id)
);

CREATE TABLE gyms (
  id INTEGER PRIMARY KEY,
  town VARCHAR(255) NOT NULL
);

INSERT INTO
  gyms (id, town)
VALUES
  (1, "pewter city"), (2, "cerulean city"), (3, "App Academy");

INSERT INTO
  trainers (id, fname, lname, gym_id)
VALUES
  (1, "Brock", "The Rock Johnson", 1),
  (2, "Youngster", "Joey", 1),
  (3, "Misty", "Whose bike is stolen", 2),
  (4, "Professor", "Oak", NULL),
  (5, "David", "Webster", 3),
  (6, "Ommi", "Shimizu", 3),
  (7, "Matthew", "Haws", 3),
  (8, "Danny", "Catalano", 3),
  (9, "Patrick", "Kovach-Long", 3);


INSERT INTO
  pokemons (id, name, trainer_id)
VALUES
  (1, "Geodude", 1),
  (2, "Rattatta", 2),
  (3, "Psyduck", 3),
  (4, "Goldeen", 3),
  (5, "Stray Meowth", NULL),
  (6, "Tyranitar", 5),
  (7, "Scizor", 6),
  (8, "Chewbacca", 7),
  (9, "Alakazam", 8),
  (10, "Zapdos", 9),
  (11, "Garchomp", 5),
  (12, "Gengar", 6)
  ;
