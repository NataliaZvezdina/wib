CREATE TABLE IF NOT EXISTS users (
	user_id SERIAL PRIMARY KEY,
	age INT
);

CREATE TABLE IF NOT EXISTS items (
	item_id SERIAL PRIMARY KEY,
	price NUMERIC(5, 2)
);

CREATE TABLE IF NOT EXISTS purchases (
    purchase_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    date DATE,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (item_id) REFERENCES items (item_id)
);