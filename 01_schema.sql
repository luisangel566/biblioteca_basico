-- ============================================================
-- PROYECTO 1: SISTEMA DE BIBLIOTECA
-- Nivel: BÁSICO
-- Motor: Oracle Database 19c+
-- Conceptos: DDL, DML, JOINs, Constraints, Sequences
-- Autor: Luis Angel Tapias Madronero
-- ============================================================

-- Limpiar objetos si existen
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE prestamos CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE libros CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE socios CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE autores CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE categorias CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_autor';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_categoria';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_socio';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_libro';
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_prestamo';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ============================================================
-- SEQUENCES (equivalente a AUTO_INCREMENT en Oracle)
-- ============================================================
CREATE SEQUENCE seq_autor     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_categoria START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_socio     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_libro     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_prestamo  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ============================================================
-- TABLAS
-- ============================================================

CREATE TABLE autores (
    id_autor    NUMBER        DEFAULT seq_autor.NEXTVAL PRIMARY KEY,
    nombre      VARCHAR2(100) NOT NULL,
    apellido    VARCHAR2(100) NOT NULL,
    nacionalidad VARCHAR2(80),
    fecha_nac   DATE
);

CREATE TABLE categorias (
    id_categoria NUMBER        DEFAULT seq_categoria.NEXTVAL PRIMARY KEY,
    nombre       VARCHAR2(100) NOT NULL UNIQUE,
    descripcion  VARCHAR2(255)
);

CREATE TABLE libros (
    id_libro     NUMBER         DEFAULT seq_libro.NEXTVAL PRIMARY KEY,
    isbn         VARCHAR2(20)   NOT NULL UNIQUE,
    titulo       VARCHAR2(200)  NOT NULL,
    id_autor     NUMBER         NOT NULL,
    id_categoria NUMBER         NOT NULL,
    anio_pub     NUMBER(4),
    editorial    VARCHAR2(150),
    num_paginas  NUMBER(5),
    stock_total  NUMBER(5)      DEFAULT 1 NOT NULL,
    stock_disp   NUMBER(5)      DEFAULT 1 NOT NULL,
    CONSTRAINT fk_libro_autor     FOREIGN KEY (id_autor)     REFERENCES autores(id_autor),
    CONSTRAINT fk_libro_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CONSTRAINT chk_stock          CHECK (stock_disp >= 0 AND stock_disp <= stock_total)
);

CREATE TABLE socios (
    id_socio    NUMBER        DEFAULT seq_socio.NEXTVAL PRIMARY KEY,
    cedula      VARCHAR2(20)  NOT NULL UNIQUE,
    nombre      VARCHAR2(100) NOT NULL,
    apellido    VARCHAR2(100) NOT NULL,
    email       VARCHAR2(100),
    telefono    VARCHAR2(20),
    fecha_alta  DATE          DEFAULT SYSDATE NOT NULL,
    activo      NUMBER(1)     DEFAULT 1 NOT NULL,
    CONSTRAINT chk_activo CHECK (activo IN (0, 1))
);

CREATE TABLE prestamos (
    id_prestamo  NUMBER       DEFAULT seq_prestamo.NEXTVAL PRIMARY KEY,
    id_socio     NUMBER       NOT NULL,
    id_libro     NUMBER       NOT NULL,
    fecha_inicio DATE         DEFAULT SYSDATE NOT NULL,
    fecha_limite DATE         NOT NULL,
    fecha_devol  DATE,
    estado       VARCHAR2(15) DEFAULT 'ACTIVO' NOT NULL,
    -- ACTIVO | DEVUELTO | VENCIDO
    CONSTRAINT fk_prestamo_socio  FOREIGN KEY (id_socio) REFERENCES socios(id_socio),
    CONSTRAINT fk_prestamo_libro  FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    CONSTRAINT chk_estado_prest   CHECK (estado IN ('ACTIVO','DEVUELTO','VENCIDO')),
    CONSTRAINT chk_fecha_limite   CHECK (fecha_limite > fecha_inicio)
);

-- Índices para mejorar rendimiento en búsquedas frecuentes
CREATE INDEX idx_prestamos_socio  ON prestamos(id_socio);
CREATE INDEX idx_prestamos_libro  ON prestamos(id_libro);
CREATE INDEX idx_prestamos_estado ON prestamos(estado);
CREATE INDEX idx_libros_titulo    ON libros(titulo);

COMMIT;
