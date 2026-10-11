CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    age INTEGER NOT NULL
);

INSERT INTO users (username, age)
VALUES
    ('JJ', 24),
    ('Ana', 28),
    ('Miguel', 35)
ON CONFLICT (username) DO NOTHING;