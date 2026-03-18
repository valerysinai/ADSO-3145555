--liquibase formatted sql

--changeset valery:003-1
INSERT INTO usuarios (nombre, email) VALUES
('Ana Torres', 'ana@email.com'),
('Carlos Ruiz', 'carlos@email.com');

--changeset valery:003-2
INSERT INTO productos (nombre, precio, stock) VALUES
('Laptop', 3500.00, 10),
('Mouse', 80.00, 50);