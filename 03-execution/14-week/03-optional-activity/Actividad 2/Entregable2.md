# Módulos reales del sistema — basados en cómo funciona el SENA

Los archivos del proyecto (V6 a V9) tienen el núcleo técnico, pero tus compañeros tienen razón: un sistema completo de gestión de horarios del SENA implica más entidades porque así opera institucionalmente.

Aquí están los 16 módulos justificados:

---

# Grupo 1 — Gestión de personas

## 1. Módulo de Instructores

Gestiona los datos básicos del instructor.

Sale del FR3 de los archivos y de cómo el SENA distingue instructores de planta (funcionarios públicos de carrera) vs. contratistas (vinculados por OPS u orden de prestación de servicios).

---

## 2. Módulo de Tipo de Contrato del Instructor

En el SENA existen al menos 3 tipos:

- Planta
- Contrato de prestación de servicios (OPS)
- Contrato de aprendizaje como monitor

Esto afecta la carga horaria máxima permitida por ley.

Sale del FR4 ("staff" vs "contractor") y de la normativa interna del SENA (Circular 079 de 2024).

---

## 3. Módulo de Usuarios y Roles

Roles principales:

- Coordinador académico
- Instructor
- Subdirector
- Administrador del sistema

Sale del campo `user_roles` del `requirements.md V8` y de la estructura organizacional del SENA:

`subdirector de centro → coordinadores → instructores`

---

# Grupo 2 — Estructura académica

## 4. Módulo de Programas de Formación

El SENA tiene:

- Programas titulados (técnico, tecnólogo)
- Programas complementarios

Cada programa tiene:

- Código
- Nombre
- Nivel
- Versión

Sale del sistema SOFIA Plus — sin un programa no existe ninguna ficha ni grupo.

Es la entidad raíz de todo.

---

## 5. Módulo de Fichas de Caracterización

En el SENA, un "grupo de formación" no es simplemente un grupo: es una **ficha**.

Cada ficha tiene:

- Número único (ej. ficha `2845631`)
- Programa asociado
- Fecha de inicio
- Fecha de finalización
- Estado:
  - En ejecución
  - Terminada
  - Suspendida
  - Etc.

Lo que en los archivos llaman `training_group`, en el SENA se llama **ficha**.

Sale directamente del portal SOFIA Plus:

> "gestión de fichas, programación de ambientes, actualizar vigencia y dedicación de instructores"

---

## 6. Módulo de Competencias

Cada programa de formación se divide en competencias (unidades de aprendizaje).

Cada competencia tiene resultados de aprendizaje.

Los instructores se asignan a horarios por competencia, no por "materia".

Sale del diseño curricular del SENA y del `data-model.md`, donde `expertise_area` del instructor hace referencia a esto.

---

## 7. Módulo de Resultados de Aprendizaje (RAP)

Cada competencia tiene varios resultados de aprendizaje.

Son el nivel más granular del currículo SENA.

Se mencionan en el portal SOFIA Plus y en la estructura curricular oficial del SENA.

---

# Grupo 3 — Infraestructura y recursos

## 8. Módulo de Ambientes de Aprendizaje

Incluye:

- Aulas
- Laboratorios
- Talleres
- Ambientes virtuales

Sale del FR1 y de la entidad `environment` en todos los archivos.

En el SENA cada ambiente tiene:

- Código
- Tipo específico

Ejemplos:

- Aula
- Laboratorio de sistemas
- Taller metalmecánica

---

## 9. Módulo de Equipos y Recursos del Ambiente

Los ambientes tienen equipos registrados, por ejemplo:

- Computadores
- Tornos
- Simuladores

Esto sale del campo `equipment_item` del `data-model.md V8`.

En un sistema completo merece su propia tabla para gestionar:

- Mantenimiento
- Disponibilidad
- Inventario

---

## 10. Módulo de Centro de Formación / Sede

El SENA tiene múltiples centros por regional.

Ejemplos:

- Centro de Gestión de Mercados
- Centro Industrial

Un sistema de horarios real debe saber a qué centro pertenece:

- Cada ambiente
- Cada instructor

Sale de la estructura organizacional del SENA:

`Direcciones Regionales → Centros de Formación`

---

# Grupo 4 — Gestión de horarios

## 11. Módulo de Horarios / Programación de Sesiones

Es la tabla central del sistema.

Vincula:

- Instructor
- Ficha
- Competencia
- Ambiente
- Franja horaria

Es el `schedule` de los archivos, pero enriquecido con competencia y ficha.

Sale de:

- FR5
- FR6
- SOFIA Plus:
  > "programación de ambientes, actualizar vigencia y dedicación de instructores"

---

## 12. Módulo de Franjas Horarias / Jornadas

El SENA maneja jornadas como:

- Mañana (`6:00am - 12:00m`)
- Tarde (`12:00m - 6:00pm`)
- Noche (`6:00pm - 10:00pm`)
- Madrugada

Las franjas son configurables por centro.

Sin esto no se puede hacer una programación real.

---

## 13. Módulo de Detección de Conflictos

Verifica:

- Que un instructor no esté en dos lugares al mismo tiempo
- Que un ambiente no esté doble asignado
- Que la carga horaria del instructor no supere su contrato

Sale de:

- FR6:
  > "prevenir horarios inválidos"

- PRD V7:
  > "The system MUST prevent double-booking"

---

# Grupo 5 — Seguimiento y control

## 14. Módulo de Observaciones Operacionales

Gestiona novedades ligadas a:

- Horarios
- Instructores
- Ambientes

Ejemplos:

- Inasistencias
- Cambios de ambiente
- Cancelaciones

Sale del FR7 y de la entidad `observation` presente en todos los archivos.

---

## 15. Módulo de Auditoría / Trazabilidad

Registra:

- Quién hizo un cambio
- Qué cambio realizó
- Cuándo lo hizo

En el SENA esto es obligatorio por control interno.

Sale de:

- NFR de los archivos (calidad, appsec)
- Estructura del SENA:
  - Oficina de Control Interno

---