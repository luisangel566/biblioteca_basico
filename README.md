biblioteca-sql-oracle
Sistema de gestión de biblioteca para control de libros, socios y préstamos. Proyecto de nivel **básico** del portafolio SQL.
# 📚 Sistema de Biblioteca — Oracle SQL (Básico)

Sistema de gestión de biblioteca para control de libros, socios y préstamos. Proyecto de nivel **básico** del portafolio SQL.

## 🎯 Conceptos demostrados
- DDL: `CREATE TABLE`, `CREATE SEQUENCE`, `CREATE INDEX`
- Constraints: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `NOT NULL`
- DML: `SELECT`, `INSERT`, `UPDATE`, `DELETE`
- JOINs: `INNER JOIN`, `LEFT JOIN`
- Agrupaciones: `GROUP BY`, `ORDER BY`, `COUNT`
- Subconsultas con `NOT IN`
- Sintaxis Oracle: `SEQUENCE`, `SYSDATE`, `VARCHAR2`, `NUMBER`

## 🗂️ Estructura
```
01-biblioteca-basico/
├── sql/
│   ├── 01_schema.sql         → Tablas, sequences e índices
│   └── 02_datos_consultas.sql → Datos de prueba y consultas SELECT
└── README.md
```

## 🧱 Tablas
| Tabla | Descripción |
|-------|-------------|
| `autores` | Autores de libros |
| `categorias` | Géneros/categorías literarias |
| `libros` | Catálogo con control de stock |
| `socios` | Miembros de la biblioteca |
| `prestamos` | Registro de préstamos activos y devueltos |

## 🚀 Ejecución en Oracle SQL Developer
```sql
@01_schema.sql
@02_datos_consultas.sql
```

## 👨‍💻 Autor
**Luis Angel Tapias Madronero** — Ingeniero de Sistemas | Bogotá, Colombia  
🔗 [github.c
om/luisangel566](https://github.com/luisangel566)
