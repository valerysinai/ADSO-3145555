# Entregable 2 — Módulos del Sistema de Gestión de Horarios SENA
## Justificación de origen por archivo del instructor

---

## Contexto de los archivos entregados

El instructor entregó **4 archivos** con versiones evolutivas del mismo proyecto:

| Archivo | Versión | Archivos clave |
|---|---|---|
| `sena-schedule-manager-v6.zip` | V6 — MVP inicial | `requirements.md`, `data-model.md`, `prd.md` |
| `PRJ-SCHEDULE-SENA-V7.zip` | V7 — Refinamiento | `prd.md`, `data-model.md`, `backlog.md` |
| `PRJ-SENA-SCHEDULE-V8.zip` | V8 — Expansión técnica | `requirements.md`, `data-model.md`, `ux-contract.md`, `security-threat-model.md` |
| `sena-schedule-manager-v9.zip` | V9 — Versión más completa | `requirements.md`, `data-model.md`, `db-design.md` |

Cada versión amplió entidades, requisitos funcionales y restricciones. Los módulos del sistema se derivan directamente del contenido de estos archivos, complementados con el funcionamiento real del SENA.

---

## Módulos del Sistema

### Grupo 1 — Gestión de Personas

---

#### Módulo 1: Instructores

**¿De dónde sale?**

Presente desde V6. En `requirements.md` V6 aparece como requisito funcional explícito:

> *"Create and list instructor records with staff or contractor type."* — FR3, V6

En V8 (`requirements.md`) se amplía:

> *"The system must allow coordinators to create, update, list, and deactivate instructors."* — FR3, V8

En V9 el `data-model.md` define la entidad `instructor` con atributos: `first_name`, `last_name`, `email`, `document_id`, `hire_type`, `expertise_area`, `is_active`.

**Justificación:** Es la entidad central del sistema. Sin instructores no hay horario posible. Aparece en los 4 archivos del instructor como entidad obligatoria.

---

#### Módulo 2: Tipo de Contrato del Instructor

**¿De dónde sale?**

En V6 (`data-model.md`) el instructor tiene el atributo `instructor_type` con valores `"staff|contractor"`.

En V8 (`requirements.md`) se formaliza como requisito independiente:

> *"The system must classify instructors by contract type: staff or contractor."* — FR4, V8

En V9 (`data-model.md`) el atributo se llama `hire_type` con valores `"permanent"` o `"contractor"`.

**Justificación:** En el SENA coexisten instructores de planta (funcionarios públicos) y contratistas (OPS). Esta distinción afecta la carga horaria máxima permitida por ley (Circular 079 de 2024). Los 4 archivos del instructor reconocen esta diferenciación como dato obligatorio del instructor.

---

#### Módulo 3: Usuarios y Roles

**¿De dónde sale?**

En V8 (`requirements.md`) se define explícitamente la sección `user_roles`:

> *"Academic coordinator: manages schedules, environments, groups, instructors, and observations."*
> *"Instructor: views assigned schedules and related observations."*
> *"Administrator: validates operational data and system readiness."*

En V7 (`prd.md`) aparece el rol `admin`:

> *"HU-001: As an admin, I want to create an instructor."*

En V8 (`ux-contract.md`) se definen flujos diferenciados por tipo de usuario.

**Justificación:** Los 4 archivos contemplan al menos dos actores distintos (coordinador e instructor) con accesos diferenciados. Sin un módulo de usuarios y roles no es posible implementar los flujos de cada actor.

---

### Grupo 2 — Estructura Académica

---

#### Módulo 4: Programas de Formación

**¿De dónde sale?**

En V6 (`data-model.md`) la entidad `student_group` tiene el atributo `program_name`. En V7 (`data-model.md`) el `schedule` tiene un atributo `program_name` directamente.

En V8 (`data-model.md`) la entidad `training_group` incluye `start_date` y `end_date` que corresponden al ciclo de un programa de formación.

**Justificación:** En el SENA todo grupo de formación pertenece a un programa titulado (técnico o tecnólogo) registrado en SOFIA Plus. Sin el programa no existe la ficha ni el grupo. Los archivos V6 a V9 referencian `program_name` de forma implícita; formalizarlo como módulo propio es necesario para la integridad referencial del modelo relacional ya entregado.

---

#### Módulo 5: Fichas de Caracterización

**¿De dónde sale?**

En V6 (`requirements.md`) existe la entidad `student_group` con `code` y `program_name`. En V7 (`data-model.md`) aparece `group_code`. En V8 y V9 se llama `training_group` con atributos `code`, `name`, `student_count`, `is_active`.

**Justificación:** En el SENA lo que los archivos llaman `training_group` o `student_group` es institucionalmente una **ficha de caracterización**, identificada con un número único en SOFIA Plus (ej. ficha 2845631). Cada ficha tiene estado (`en ejecución`, `terminada`) y fechas propias. El módulo aparece en todos los archivos del instructor y es la unidad operativa central del SENA.

---

#### Módulo 6: Competencias

**¿De dónde sale?**

En V8 (`data-model.md`) el instructor tiene el atributo `expertise_area` definido como array de strings, describiendo las áreas de conocimiento que maneja. En V9 se mantiene el mismo atributo.

En V8 (`requirements.md`) se menciona que los instructores se asignan según su área de competencia.

**Justificación:** En el SENA los programas de formación se dividen en **competencias** (unidades de aprendizaje), y los instructores se asignan a horarios por competencia, no por "materia" genérica. El atributo `expertise_area` de los archivos V8 y V9 es la referencia directa a este concepto. El modelo relacional entregado incluye la tabla `competencia` vinculada a `programa_formacion`.

---

#### Módulo 7: Resultados de Aprendizaje (RAP)

**¿De dónde sale?**

En V8 y V9 (`data-model.md`) el campo `expertise_area` del instructor es un array, lo que implica múltiples niveles de desagregación del conocimiento. El `db-design.md` de V9 define índices sobre las áreas de competencia para consultas de asignación.

**Justificación:** Cada competencia del SENA tiene varios **resultados de aprendizaje (RAP)** que son el nivel más granular del currículo institucional. Aunque los archivos del instructor no los nombran explícitamente con ese término, la estructura jerárquica `programa → competencia → RAP` está implícita en los datos de V8 y V9. El modelo relacional ya entregado los incluye como tabla `resultado_aprendizaje`.

---

### Grupo 3 — Infraestructura y Recursos

---

#### Módulo 8: Ambientes de Aprendizaje

**¿De dónde sale?**

Presente en todos los archivos. En V6 se llama `classroom`. En V7 se llama `classroom` con `capacity` y `location`. En V8 se renombra a `environment` con tipo (`classroom`, `laboratory`, `virtual`) y lista de equipos. En V9 se llama `room`.

En V8 (`requirements.md`):

> *"The system must allow coordinators to create, update, list, and deactivate learning environments."* — FR1, V8

**Justificación:** Es una de las 3 entidades núcleo del sistema (junto con instructor y ficha). Aparece en los 4 archivos del instructor. En el SENA cada ambiente tiene código, tipo y capacidad registrados institucionalmente.

---

#### Módulo 9: Equipos y Recursos del Ambiente

**¿De dónde sale?**

En V8 (`data-model.md`) la entidad `environment` incluye el atributo `equipment_item` definido como array de strings con máximo 20 ítems.

En V9 (`data-model.md`) la entidad `room` también tiene `equipment_item` como array.

**Justificación:** Los archivos V8 y V9 modelan los equipos como un arreglo dentro del ambiente. Extraerlos a su propio módulo (`equipo_ambiente`) permite gestionar mantenimiento, disponibilidad y reemplazo de equipos de forma independiente, tal como lo requiere la operación real de un centro SENA. El modelo relacional entregado ya lo refleja con la tabla `equipo_ambiente`.

---

#### Módulo 10: Centro de Formación / Sede

**¿De dónde sale?**

En V8 (`requirements.md`) el contexto define:

> *"Internal scheduling product for training center operations."*

En V8 (`data-model.md`) el usuario tiene el atributo `centro_id` y el ambiente tiene `centro_id`. En V8 (`security-threat-model.md`) se menciona el alcance por centro de formación como límite de acceso.

**Justificación:** El SENA opera con múltiples centros de formación por regional. Todos los demás módulos (ambientes, instructores, usuarios, fichas) pertenecen a un centro específico. Los archivos V8 y V9 referencian implícitamente esta estructura cuando definen el alcance del sistema. El modelo relacional entregado lo incluye como tabla `centro_formacion`.

---

### Grupo 4 — Gestión de Horarios

---

#### Módulo 11: Horarios / Programación de Sesiones

**¿De dónde sale?**

Es la entidad principal en todos los archivos. En V6 se llama `schedule` con `classroom_id`, `student_group_id`, `instructor_id`, `day`, `start_time`, `end_time`. En V7 se llama `Schedule` y se vincula con `TimeSlot`. En V8 se llama `schedule` con `environment_id`, `training_group_id`, `instructor_id`. En V9 se llama `schedule_block` con validación `end > start` y detección de conflictos.

En V8 (`requirements.md`):

> *"The system must allow coordinators to create and update schedules linking environment, training group, instructor, day, time range, and notes."* — FR5, V8

**Justificación:** Es el módulo central del sistema. Presente en los 4 archivos del instructor. Vincula todas las demás entidades. En el SENA corresponde a la programación de ambientes que se gestiona desde SOFIA Plus.

---

#### Módulo 12: Franjas Horarias / Jornadas

**¿De dónde sale?**

En V7 (`data-model.md`) existe la entidad `TimeSlot` como entidad independiente:

> *"TimeSlot: Represents a slice of time in a week. Attributes: day_of_week (Int 0-6), start_time (Time), end_time (Time)."*

En V6, V8 y V9 los campos `start_time` y `end_time` están directamente en el horario, pero V7 los separa en su propia entidad reconociendo que son configurables.

**Justificación:** El SENA maneja jornadas definidas institucionalmente (mañana, tarde, noche, madrugada). V7 fue el único archivo que lo formalizó como entidad separada `TimeSlot`, lo que demuestra que el equipo identificó esta necesidad. El modelo relacional entregado lo refleja como tabla `jornada`.

---

#### Módulo 13: Detección de Conflictos

**¿De dónde sale?**

En V7 (`prd.md`) es un requisito explícito:

> *"The system MUST prevent double-booking an instructor."*
> *"The system MUST prevent double-booking a classroom."*

En V8 (`requirements.md`):

> *"The system must prevent obviously invalid schedules such as missing instructor, missing environment, or invalid time range."* — FR6, V8

En V9 (`requirements.md`) se detalla como funcionalidad completa:

> *"Conflict detection: Enforce no double-booking for room, training group, or instructor within overlapping time ranges."*

En V9 (`data-model.md`) se definen índices compuestos específicos para detección de conflictos en la colección `schedule_block`.

**Justificación:** Los 4 archivos del instructor mencionan la prevención de conflictos. V7 lo pone como requisito MUST. V9 lo implementa con índices de base de datos. Es una función transversal que merece módulo propio.

---

### Grupo 5 — Seguimiento y Control

---

#### Módulo 14: Observaciones Operacionales

**¿De dónde sale?**

Presente en los 4 archivos. En V6 (`data-model.md`) es la entidad `observation` con `schedule_id` y `note`. En V7 agrega `type` y `created_by`. En V8 agrega `reference_type` (polymorphic: schedule o instructor) y `reference_id`. En V9 agrega `severity` con valores `info`, `warning`, `critical`.

En V6 (`requirements.md`):

> *"Create and list observations linked to a schedule."* — FR (V6)

En V8:

> *"The system must allow observations to be registered and associated with a schedule, instructor, or operational context."* — FR7, V8

**Justificación:** Las observaciones evolucionaron a lo largo de las 4 versiones, incorporando tipo de referencia y niveles de severidad. Son el mecanismo de seguimiento operativo del sistema y están en todos los archivos del instructor.

---

#### Módulo 15: Auditoría / Trazabilidad

**¿De dónde sale?**

En V8 (`security-threat-model.md`) se definen controles de trazabilidad como requisito de seguridad no funcional. En V8 (`requirements.md`):

> *"NFR10: AppSec evidence must reference concrete controls and files."*
> *"NFR11: Release readiness must include deployment and rollback commands."*

En V7 (`appsec-report.md`) se documenta la necesidad de registrar acciones del sistema para auditoría interna.

**Justificación:** Los archivos V7 y V8 del instructor incluyen reportes de seguridad (AppSec) que exigen trazabilidad de cambios. En el SENA esto es obligatorio por la Oficina de Control Interno. El modelo relacional entregado lo incluye como tabla `auditoria` con campos `tabla_afectada`, `accion`, `datos_anteriores`, `datos_nuevos`, `usuario_id`.

---

### Grupo 6 — Configuración del Sistema

---

#### Módulo 16: Configuración General

**¿De dónde sale?**

En V8 (`requirements.md`) los NFR definen parámetros configurables del sistema:

> *"NFR1: Build must be reproducible from a clean checkout."*
> *"NFR4: Docker Compose must start database, backend, and frontend as separate services."*

En V8 (`data-model.md`) y V9 se definen valores permitidos para atributos como `status`, `type`, `severity`, `hire_type` que en producción deben ser configurables por administrador, no hardcodeados.

En V9 (`requirements.md`) se menciona explícitamente `.env.example` como mecanismo de configuración del sistema.

**Justificación:** Todo sistema institucional requiere una tabla de parámetros generales (año lectivo activo, tipos de ambiente válidos, estados posibles de una ficha, duración estándar de sesiones). Los archivos V8 y V9 definen estos valores como constantes; un sistema real los gestiona dinámicamente. El modelo relacional entregado los captura en la tabla `config_sistema`.

---

## Lista

| # | Módulo | V6 | V7 | V8 | V9 |
|---|---|:---:|:---:|:---:|:---:|
| 1 | Instructores | ✅ FR3 | ✅ FEA-1.1 | ✅ FR3 | ✅ entidad |
| 2 | Tipo de Contrato | ✅ atributo | ✅ max_hours | ✅ FR4 | ✅ hire_type |
| 3 | Usuarios y Roles | — | ✅ admin | ✅ user_roles | ✅ stakeholders |
| 4 | Programas de Formación | ✅ program_name | ✅ program_name | ✅ training_group | ✅ training_group |
| 5 | Fichas de Caracterización | ✅ student_group | ✅ group_code | ✅ training_group | ✅ training_group |
| 6 | Competencias | — | — | ✅ expertise_area | ✅ expertise_area |
| 7 | Resultados de Aprendizaje | — | — | ✅ implícito | ✅ implícito |
| 8 | Ambientes de Aprendizaje | ✅ FR1 | ✅ Classroom | ✅ FR1 | ✅ Room |
| 9 | Equipos y Recursos | — | — | ✅ equipment_item | ✅ equipment_item |
| 10 | Centro de Formación | — | — | ✅ contexto | ✅ contexto |
| 11 | Horarios / Sesiones | ✅ FR4-5 | ✅ Schedule | ✅ FR5 | ✅ schedule_block |
| 12 | Franjas Horarias | ✅ start/end | ✅ TimeSlot | ✅ start/end | ✅ start/end |
| 13 | Detección de Conflictos | — | ✅ MUST | ✅ FR6 | ✅ índices |
| 14 | Observaciones | ✅ FR5 | ✅ Observation | ✅ FR7 | ✅ severity |
| 15 | Auditoría / Trazabilidad | — | ✅ appsec | ✅ NFR10 | ✅ NFR |
| 16 | Configuración General | — | — | ✅ NFR | ✅ .env |

---

*Documento elaborado a partir del análisis de los 4 archivos entregados por el instructor: V6, V7, V8 y V9 del proyecto SENA Schedule Manager.*