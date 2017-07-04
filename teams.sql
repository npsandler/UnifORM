CREATE TABLE players (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  team_id INTEGER,

  FOREIGN KEY(team_id) REFERENCES team(id)
);

CREATE TABLE teams (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  nation_id INTEGER,

  FOREIGN KEY(nation_id) REFERENCES team(id)
);

CREATE TABLE nations (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  nations (id, name)
VALUES
  (1, "United States"), (2, "England");

INSERT INTO
  teams (id, name, nation_id)
VALUES
  (1, "Sabres", 1),
  (2, "Red Wings", 1),
  (3, "Lions", 2),
  (4, "Yankees", 2);

INSERT INTO
  players (id, name, team_id)
VALUES
  (1, "Mark", 1),
  (2, "Robert", 2),
  (3, "Evan", 3),
  (4, "Nathaniel", 3),
  (5, "Ethan", 2);
