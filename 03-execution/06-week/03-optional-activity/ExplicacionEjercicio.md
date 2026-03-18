# Proyecto Liquibase

Liquibase es una herramienta para versionar cambios en la base de datos de forma ordenada y controlada, similar a como Git versiona el código.

## Archivos del proyecto

| Archivo | Para qué sirve |
|---|---|
| `liquibase.properties` | Configuración de conexión a la BD y ruta del changelog maestro |
| `db.changelog-master.xml` | Archivo principal que enlaza todos los changesets en orden |
| `001-init-database.xml` | Crea la estructura base inicial |
| `002-add-tables.xml` | Crea las tablas `usuarios` y `productos` |
| `003-seed-data.xml` | Inserta datos iniciales en las tablas |
| `sql/` | Versiones en SQL puro de los mismos cambios |

## ¿Cómo funciona?

Cada vez que se ejecuta, Liquibase revisa la tabla interna `DATABASECHANGELOG` y solo aplica los changesets que aún no se han ejecutado. Esto garantiza que los cambios se apliquen una sola vez y en el orden correcto, sin importar el entorno.

## Verificación rápida

```sql
USE mi_base;
SHOW TABLES;
SELECT * FROM DATABASECHANGELOG;
```