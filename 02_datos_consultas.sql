-- ============================================================
-- DATOS DE PRUEBA Y CONSULTAS - BIBLIOTECA
-- ============================================================

-- Categorías
INSERT INTO categorias (nombre, descripcion) VALUES ('Novela',       'Obras de ficción literaria');
INSERT INTO categorias (nombre, descripcion) VALUES ('Tecnología',   'Libros de programación e informática');
INSERT INTO categorias (nombre, descripcion) VALUES ('Historia',     'Historia universal y colombiana');
INSERT INTO categorias (nombre, descripcion) VALUES ('Ciencia',      'Ciencias naturales y exactas');
INSERT INTO categorias (nombre, descripcion) VALUES ('Filosofía',    'Pensamiento filosófico occidental y oriental');

-- Autores
INSERT INTO autores (nombre, apellido, nacionalidad) VALUES ('Gabriel', 'García Márquez', 'Colombiana');
INSERT INTO autores (nombre, apellido, nacionalidad) VALUES ('Jorge',   'Isaacs',         'Colombiana');
INSERT INTO autores (nombre, apellido, nacionalidad) VALUES ('Robert',  'Martin',         'Estadounidense');
INSERT INTO autores (nombre, apellido, nacionalidad) VALUES ('Donald',  'Knuth',          'Estadounidense');
INSERT INTO autores (nombre, apellido, nacionalidad) VALUES ('Yuval',   'Harari',         'Israelí');

-- Libros
INSERT INTO libros (isbn, titulo, id_autor, id_categoria, anio_pub, editorial, stock_total, stock_disp)
VALUES ('978-958-04-0193-5', 'Cien años de soledad',     1, 1, 1967, 'Sudamericana', 3, 3);
INSERT INTO libros (isbn, titulo, id_autor, id_categoria, anio_pub, editorial, stock_total, stock_disp)
VALUES ('978-958-04-1234-5', 'María',                    2, 1, 1867, 'El Áncora',    2, 2);
INSERT INTO libros (isbn, titulo, id_autor, id_categoria, anio_pub, editorial, stock_total, stock_disp)
VALUES ('978-013-468-599-1', 'Clean Code',               3, 2, 2008, 'Prentice Hall',4, 4);
INSERT INTO libros (isbn, titulo, id_autor, id_categoria, anio_pub, editorial, stock_total, stock_disp)
VALUES ('978-020-133-596-5', 'The Art of Programming',   4, 2, 1968, 'Addison-Wesley',2, 2);
INSERT INTO libros (isbn, titulo, id_autor, id_categoria, anio_pub, editorial, stock_total, stock_disp)
VALUES ('978-958-00-1234-1', 'Sapiens',                  5, 3, 2011, 'Debate',       3, 3);

-- Socios
INSERT INTO socios (cedula, nombre, apellido, email, telefono)
VALUES ('1023456789', 'Andrés',   'Martínez', 'andres.m@email.com',   '3101234567');
INSERT INTO socios (cedula, nombre, apellido, email, telefono)
VALUES ('1034567890', 'Catalina', 'Ríos',     'catalina.r@email.com', '3112345678');
INSERT INTO socios (cedula, nombre, apellido, email, telefono)
VALUES ('1045678901', 'Felipe',   'Torres',   'felipe.t@email.com',   '3123456789');
INSERT INTO socios (cedula, nombre, apellido, email, telefono)
VALUES ('1056789012', 'Valentina','Cruz',     'vale.c@email.com',     '3134567890');

-- Préstamos
INSERT INTO prestamos (id_socio, id_libro, fecha_limite)
VALUES (1, 1, SYSDATE + 15);
INSERT INTO prestamos (id_socio, id_libro, fecha_limite)
VALUES (2, 3, SYSDATE + 15);
INSERT INTO prestamos (id_socio, id_libro, fecha_limite, fecha_devol, estado)
VALUES (3, 2, SYSDATE - 5, SYSDATE - 2, 'DEVUELTO');
INSERT INTO prestamos (id_socio, id_libro, fecha_limite)
VALUES (4, 5, SYSDATE + 10);

-- Actualizar stock disponible tras préstamos activos
UPDATE libros SET stock_disp = stock_disp - 1 WHERE id_libro IN (1, 3, 5);

COMMIT;

-- ============================================================
-- CONSULTAS CLAVE (DML - SELECT)
-- ============================================================

-- 1. Lista completa de libros con autor y categoría
SELECT
    l.isbn,
    l.titulo,
    a.nombre || ' ' || a.apellido AS autor,
    c.nombre                       AS categoria,
    l.anio_pub,
    l.stock_disp || '/' || l.stock_total AS disponibilidad
FROM libros l
INNER JOIN autores    a ON l.id_autor     = a.id_autor
INNER JOIN categorias c ON l.id_categoria = c.id_categoria
ORDER BY l.titulo;

-- 2. Préstamos activos con datos del socio y libro
SELECT
    p.id_prestamo,
    s.nombre || ' ' || s.apellido AS socio,
    l.titulo,
    p.fecha_inicio,
    p.fecha_limite,
    p.fecha_limite - SYSDATE       AS dias_restantes
FROM prestamos p
INNER JOIN socios s ON p.id_socio = s.id_socio
INNER JOIN libros l ON p.id_libro = l.id_libro
WHERE p.estado = 'ACTIVO'
ORDER BY p.fecha_limite;

-- 3. Libros más prestados
SELECT
    l.titulo,
    a.nombre || ' ' || a.apellido AS autor,
    COUNT(p.id_prestamo)           AS total_prestamos
FROM libros l
INNER JOIN autores   a ON l.id_autor = a.id_autor
LEFT  JOIN prestamos p ON l.id_libro = p.id_libro
GROUP BY l.titulo, a.nombre, a.apellido
ORDER BY total_prestamos DESC;

-- 4. Socios con préstamos vencidos
SELECT
    s.cedula,
    s.nombre || ' ' || s.apellido AS socio,
    s.email,
    COUNT(p.id_prestamo)           AS prestamos_vencidos
FROM socios s
INNER JOIN prestamos p ON s.id_socio = p.id_socio
WHERE p.estado = 'ACTIVO'
  AND p.fecha_limite < SYSDATE
GROUP BY s.cedula, s.nombre, s.apellido, s.email
ORDER BY prestamos_vencidos DESC;

-- 5. Libros sin préstamos (nunca prestados)
SELECT l.titulo, a.nombre || ' ' || a.apellido AS autor
FROM libros l
INNER JOIN autores a ON l.id_autor = a.id_autor
WHERE l.id_libro NOT IN (SELECT DISTINCT id_libro FROM prestamos);

-- 6. UPDATE - Registrar devolución
UPDATE prestamos
SET fecha_devol = SYSDATE, estado = 'DEVUELTO'
WHERE id_prestamo = 1;

UPDATE libros SET stock_disp = stock_disp + 1 WHERE id_libro = 1;

COMMIT;
