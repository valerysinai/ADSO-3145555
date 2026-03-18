# Liquibase — Conceptos Claves

## ¿Qué es Liquibase?

Liquibase es una herramienta de **control de versiones para bases de datos**. Su propósito es gestionar y rastrear los cambios en el esquema de una base de datos de forma ordenada, reproducible y colaborativa, de la misma manera en que Git gestiona el código fuente.


## ¿En qué se basa?

Liquibase se basa en tres conceptos centrales:

### 1. Changelog
Es el archivo raíz que Liquibase lee al arrancar. Funciona como un índice: referencia todos los archivos de cambios (changesets) que deben aplicarse a la base de datos. Puede estar escrito en **YAML, XML, JSON o SQL**.

```yaml
# db-changelog-master.yaml
databaseChangeLog:
  - includeAll:
      path: db/changelog/changes/
```

### 2. Changeset
Es la unidad mínima de cambio. Cada changeset representa una operación concreta sobre la base de datos: crear una tabla, agregar una columna, insertar datos de referencia, etc.

Cada changeset se identifica de forma única con dos atributos obligatorios:
- `id` — identificador del cambio (puede ser un número o texto)
- `author` — quién lo creó

```yaml
databaseChangeLog:
  - changeSet:
      id: 1
      author: juan
      changes:
        - createTable:
            tableName: usuarios
            columns:
              - column:
                  name: id
                  type: BIGINT
                  autoIncrement: true
                  constraints:
                    primaryKey: true
              - column:
                  name: nombre
                  type: VARCHAR(100)
                  constraints:
                    nullable: false
              - column:
                  name: email
                  type: VARCHAR(150)
```

### 3. DATABASECHANGELOG (tabla de seguimiento)
Cuando Liquibase se ejecuta por primera vez, crea automáticamente dos tablas en la base de datos:

- **`DATABASECHANGELOG`** — registra cada changeset que ya fue aplicado, junto con su `id`, `author`, fecha de ejecución y un hash MD5 del contenido.
- **`DATABASECHANGELOGLOCK`** — evita que dos instancias ejecuten migraciones al mismo tiempo (útil en entornos con múltiples servidores).

---

## ¿Cómo funciona el flujo de ejecución?

Cada vez que la aplicación arranca, Liquibase sigue este proceso:

```
Arranque de Spring Boot
        ↓
Lee db-changelog-master.yaml
        ↓
Para cada changeset encontrado:
  ¿Ya está en DATABASECHANGELOG?
    → Sí: lo ignora
    → No: lo ejecuta y lo registra
        ↓
Base de datos actualizada y sincronizada
```

Esto garantiza que cada changeset se aplica **una sola vez**, sin importar cuántas veces se reinicie la aplicación o en cuántos ambientes se despliegue (desarrollo, QA, producción).

---

## Regla fundamental

> **Un changeset que ya fue ejecutado no debe modificarse.**

Si Liquibase detecta que el contenido de un changeset cambió (el hash MD5 no coincide), lanzará un error y detendrá el arranque. La manera correcta de modificar algo ya aplicado es **crear un nuevo changeset** que realice el ajuste.

---

## Integración con Spring Boot

En un proyecto Spring Boot con Maven, Liquibase se activa automáticamente si está en el classpath. Solo se necesita configurar el datasource y la ruta al changelog en `application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/mi_base
spring.datasource.username=root
spring.datasource.password=1234
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.liquibase.change-log=classpath:db/changelog/db-changelog-master.yaml
```

Y las dependencias en `pom.xml`:

```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-core</artifactId>
</dependency>

<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>
```

---

## Buenas prácticas

- Nombrar los archivos de changeset con un prefijo de versión para mantener orden: `v1.0.0__crear_tabla_usuarios.yaml`
- Un changeset por operación lógica (no mezclar la creación de dos tablas en uno solo)
- Nunca editar un changeset ya ejecutado; siempre agregar uno nuevo
- Incluir los archivos de changelog en el control de versiones (Git) junto al código

---

## Resumen

| Concepto | Qué es |
|---|---|
| Changelog | Archivo raíz que organiza los changesets |
| Changeset | Una operación de cambio sobre la BD (id + author) |
| DATABASECHANGELOG | Tabla interna que registra lo ya ejecutado |
| Ejecución | Solo aplica changesets nuevos, ignora los ya registrados |