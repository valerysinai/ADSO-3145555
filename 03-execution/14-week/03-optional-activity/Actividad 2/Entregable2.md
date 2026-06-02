# Módulos del Sistema de Gestión de Horarios SENA
**Entregable 2 — Listado de módulos y justificación de origen**

> Basado en los **4 archivos entregados por el instructor**:
> - `sena-schedule-manager-v6.zip` → V6 (versión base)
> - `PRJ-SCHEDULE-SENA-V7.zip` → V7 (ciclo de vida de proyecto)
> - `PRJ-SENA-SCHEDULE-V8.zip` → V8 (versión técnica más completa)
> - `sena-schedule-manager-v9.zip` → V9 (versión refinada final)

---

## Cómo se identificaron los módulos

Cada módulo se identificó cruzando **tres fuentes**:

1. **Archivos del instructor (V6→V9):** `requirements.md`, `data-model.md`, `db-design.md`, `ux-contract.md`, `prd.md`, `backlog.md`, `security-threat-model.md`.
2. **Propuesta visual del instructor:** imagen de 15 módulos con descripción de cada uno.
3. **Funcionamiento real del SENA:** estructura institucional (Decreto 249/2004), portal SOFIA Plus, diseño curricular oficial.

---

## Módulo 1 — Seguridad y Acceso
**Tablas:** `user`, `role`, `user_role`, `permission`, `session`

**¿Qué hace?**
Gestiona autenticación, roles, permisos por módulo, sesiones activas y trazabilidad básica de acceso para todos los actores del sistema.

**Justificación por archivo:**
- **V8 `requirements.md`** → `user_roles`: coordinador académico, instructor, administrador. Tres roles distintos con permisos diferentes.
- **V8 `requirements.md`** → `NFR8`: *"CORS must not be open by default"* — implica control de acceso a nivel de red y sesión.
- **V8 `ux-contract.md`** → pantallas explícitas: `LoginScreen`, `UnauthorizedScreen (403)`, `NotFoundScreen (404)`.
- **V8 `security-threat-model.md`** → controles de autenticación, manejo de sesiones, restricción de CORS.
- **V9 `security-threat-model.md`** → amplía controles de acceso y validación de tokens.
- **V6 `requirements.md`** → *"backend sanitizes internal errors, restricts CORS, declares timeouts and avoids client-side secret storage"*.
- **V7 `appsec-report.md`** → evidencia de controles OWASP aplicados al sistema.

---

## Módulo 2 — Estructura Institucional
**Tablas:** `regional`, `training_center`, `headquarter`

**¿Qué hace?**
Administra la jerarquía organizacional del SENA: regional → centro de formación → sede, para ubicar y gobernar la operación académica.

**Justificación por archivo:**
- **V8 `requirements.md`** → contexto: *"Internal scheduling product for **training center** operations"* — el sistema opera dentro de un centro de formación específico.
- **V8 `data-model.md`** → los instructores y ambientes pertenecen a un centro; sin esta jerarquía no es posible filtrar por sede.
- **V9 `data-model.md`** → `room.location` presupone una ubicación física dentro de una estructura institucional.
- **V6 `requirements.md`** → `classroom.location` (campo de ubicación del aula) apunta a una sede específica.
- **Contexto SENA:** Decreto 249 de 2004 define la estructura: Direcciones Regionales → Centros de Formación Profesional Integral → Sedes. Sin este módulo el sistema no puede escalar a múltiples centros.

---

## Módulo 3 — Catálogos Base
**Tablas:** `catalog_type`, `catalog_item`, `time_slot`

**¿Qué hace?**
Centraliza parámetros maestros del sistema: jornadas, estados, tipos de ambiente, modalidades y demás configuraciones reutilizables.

**Justificación por archivo:**
- **V8 `data-model.md`** → múltiples campos con `allowed_values` (status, type, hire_type) que en un sistema real se gestionan como catálogos configurables, no como valores fijos en código.
- **V7 `data-model.md`** → entidad `TimeSlot` explícita: `time_slot_id`, `day_of_week`, `start_time`, `end_time`. Es la primera vez que aparece como entidad independiente.
- **V7 `backlog.md`** → `HU-003: Create Time Slot` con criterio *"End > Start time"*.
- **V9 `data-model.md`** → `catalog_item` referenciado como entidad de configuración separada.
- **V8/V9 `db-design.md`** → colecciones de referencia para valores permitidos de estado, tipo y jornada.

---

## Módulo 4 — Líneas y Redes de Conocimiento
**Tablas:** `knowledge_network`, `tech_line`

**¿Qué hace?**
Organiza las líneas tecnológicas y redes de conocimiento que agrupan y clasifican los programas de formación.

**Justificación por archivo:**
- **V8 `data-model.md`** → `instructor.expertise_area` es un array de áreas de conocimiento; en el SENA estas áreas corresponden a redes de conocimiento específicas.
- **V9 `data-model.md`** → `instructor.expertise_area` persiste y se usa para habilitar al instructor en competencias de una red de conocimiento.
- **V8 `requirements.md`** → `FR4`: clasificar instructores por tipo y área de expertise presupone una estructura de conocimiento formal.
- **Portal SOFIA Plus (SENA):** los programas de formación se estructuran bajo líneas tecnológicas (Tecnología de la Información, Industria, Agropecuaria, etc.) que agrupan redes de conocimiento. Sin este módulo no es posible filtrar la oferta académica.

---

## Módulo 5 — Oferta y Programas de Formación
**Tablas:** `training_program`

**¿Qué hace?**
Gestiona programas de formación en sus distintas modalidades (presencial, virtual, a distancia), niveles (técnico, tecnólogo, complementario) y versiones, con sus estados del ciclo de vida.

**Justificación por archivo:**
- **V6 `data-model.md`** → `student_group.program_name` — el grupo pertenece a un programa; ese programa debe existir como entidad propia.
- **V6 `requirements.md`** → *"Create and list student group records with code, **program name** and learner count"*.
- **V7 `prd.md`** → scope incluye gestión de schedules que están vinculados a programas de formación.
- **V7 `idea-refined.md`** → *"centralized scheduling system"* presupone programas sobre los cuales se programan los horarios.
- **V8 `requirements.md`** → contexto: *"training center operations"* — los centros ejecutan programas de formación.
- **Portal SOFIA Plus (SENA):** estados formales del programa: En análisis, En elaboración, Pendiente de aprobación, Aprobado, En ejecución, Activo, Inactivo, Suspendido. Sin programa no existe ficha.

---

## Módulo 6 — Programa Académico (Competencias y RAP)
**Tablas:** `competency`, `learning_outcome`

**¿Qué hace?**
Modela las competencias de cada programa y sus resultados de aprendizaje (RAP), que son la unidad mínima del currículo SENA y el criterio de asignación de instructores.

**Justificación por archivo:**
- **V8 `data-model.md`** → `instructor.expertise_area` apunta directamente a competencias específicas del SENA.
- **V8 `requirements.md`** → `FR4`: *"classify instructors... expertise area"* — la habilitación es por competencia, no por materia genérica.
- **V9 `data-model.md`** → `schedule_block` puede asociarse a una competencia específica (campo implícito en `expertise_area`).
- **V9 `ux-contract.md`** → flujo de creación de bloque de horario incluye selección de competencia orientada.
- **Diseño curricular oficial SENA:** todo programa se divide en competencias (unidades de aprendizaje), y cada competencia tiene Resultados de Aprendizaje (RAP). Los instructores se asignan por competencia y se certifican aprendices por RAP aprobados.

---

## Módulo 7 — Instructores
**Tablas:** `instructor`, `instructor_expertise`

**¿Qué hace?**
Administra instructores de planta y contratistas, sus perfiles completos, disponibilidad, habilitación por competencia y tipo de vinculación.

**Justificación por archivo:**
- **V6 `data-model.md`** → entidad `instructor` con: `document_number`, `full_name`, `email`, `instructor_type (staff|contractor)`.
- **V7 `data-model.md`** → `Instructor` con campo `max_hours_per_week` — carga horaria máxima según contrato.
- **V7 `backlog.md`** → `HU-001: Create Instructor` con criterio *"Email must be unique"*.
- **V8 `requirements.md`** → `FR3`: *"create, update, list, and deactivate instructors"* y `FR4`: *"classify instructors by contract type: staff or contractor"*.
- **V8 `data-model.md`** → entidad `instructor`: name, email, type, expertise_area.
- **V8 `ux-contract.md`** → pantallas `InstructorList` e `InstructorForm`, flujo `CRU4`.
- **V9 `data-model.md`** → versión más completa: `first_name`, `last_name`, `email`, `phone`, `document_id`, `hire_type`, `expertise_area`, `is_active`. Campos PII explícitos.
- **V9 `db-design.md`** → colección `instructor` con todos sus índices de búsqueda.

---

## Módulo 8 — Ambientes de Aprendizaje
**Tablas:** `environment`, `equipment`

**¿Qué hace?**
Gestiona ambientes de formación (aulas, laboratorios, talleres, virtuales), sus recursos físicos, capacidad y disponibilidad real por franja horaria y sede.

**Justificación por archivo:**
- **V6 `data-model.md`** → entidad `classroom` con: `code`, `name`, `location`, `capacity`. Primera aparición.
- **V7 `data-model.md`** → entidad `Classroom` con `location` — ubicación física del ambiente.
- **V7 `backlog.md`** → `HU-002: Create Classroom` con criterio *"Capacity > 0"*.
- **V8 `requirements.md`** → `FR1`: *"create, update, list, and deactivate learning environments"*.
- **V8 `data-model.md`** → entidad `environment` con: `name`, `capacity`, `type`, `equipment_item` (array de equipos).
- **V8 `ux-contract.md`** → pantallas `EnvironmentList` y `EnvironmentForm`, flujo `CRU1`.
- **V8 `query_patterns`** → *"Find Available Environments"* — índice en capacity + time range para verificar disponibilidad.
- **V9 `data-model.md`** → entidad `room` con: `name`, `capacity`, `location`, `equipment_item`, `is_active`.
- **Tabla `equipment`:** El campo `equipment_item` array en V8/V9 se normaliza a tabla propia para gestionar mantenimiento y estado de cada equipo.

---

## Módulo 9 — Fichas y Franjas Horarias
**Tablas:** `training_group` + `time_slot` (del Módulo 3)

**¿Qué hace?**
Controla las fichas de caracterización (grupos de formación), sus jornadas asignadas, bloques horarios y vigencias de programación.

**Justificación por archivo:**
- **V6 `data-model.md`** → entidad `student_group` con: `code`, `program_name`, `learner_count`.
- **V6 `requirements.md`** → *"Create and list student group records with code, program name and learner count"*.
- **V7 `data-model.md`** → `Schedule.group_code` — el horario referencia un código de grupo.
- **V8 `requirements.md`** → `FR2`: *"create, update, list, and deactivate training groups"* y `US2`: *"organize students into distinct cohorts for scheduling"*.
- **V8 `data-model.md`** → entidad `training_group`: name, student_count, start_date, end_date.
- **V9 `data-model.md`** → entidad `training_group` con campo `code` (número institucional de ficha).
- **Portal SOFIA Plus (SENA):** en el SENA un grupo de formación se llama **ficha de caracterización** con número único (ej. 2845631), estados de ejecución y fechas de vigencia. El campo `code`/`ficha_number` del V9 corresponde exactamente a esto.

---

## Módulo 10 — Aprendices
**Tablas:** `learner`, `enrollment`

**¿Qué hace?**
Gestiona perfiles de aprendices, su matrícula en fichas de formación, historial básico y relación con la programación académica.

**Justificación por archivo:**
- **V6 `data-model.md`** → `student_group.learner_count` presupone aprendices registrados en el sistema.
- **V6 `requirements.md`** → *"student group records with learner count"* — los estudiantes son actores presentes desde la versión inicial.
- **V8 `data-model.md`** → `training_group.student_count` requiere que exista una entidad aprendiz para que el conteo sea real y no manual.
- **V8 `requirements.md`** → `US2`: *"organize **students** into distinct cohorts"*.
- **V9 `data-model.md`** → `training_group.student_count` persiste como campo numérico, lo que implica una fuente de datos de aprendices.
- **Portal SOFIA Plus (SENA):** los aprendices se matriculan en fichas a través del sistema; sin este módulo no es posible cruzar disponibilidad de ambiente con el número real de aprendices inscritos.

---

## Módulo 11 — Motor de Horarios
**Tablas:** `schedule_block`

**¿Qué hace?**
Registra asignaciones entre ficha, instructor y ambiente, validando cruces de tiempo y ocupación. Es la tabla central del sistema.

**Justificación por archivo:**
- **V6 `data-model.md`** → entidad `schedule` con: `classroom_id`, `student_group_id`, `instructor_id`, `day`, `start_time`, `end_time`, `status`.
- **V6 `requirements.md`** → *"Create and list schedule records linked to classroom, student group and instructor"* y *"Validate schedule day, start time and end time before persistence"*.
- **V7 `data-model.md`** → entidad `Schedule` con FK a `instructor_id`, `classroom_id`, `time_slot_id`. Introduce la relación con `TimeSlot`.
- **V7 `prd.md`** → *"The system MUST prevent double-booking an instructor"* y *"MUST prevent double-booking a classroom"*.
- **V7 `backlog.md`** → `HU-004: Assign Schedule` con criterio *"Blocks if conflict exists"*.
- **V7 `prd.md`** → `EPC-2 / FEA-2.1`: *"Schedule Assignment — assign an instructor to a classroom and time slot"*.
- **V8 `requirements.md`** → `FR5`: *"create and update schedules linking environment, training group, instructor, day, time range, and notes"* y `FR6`: *"prevent obviously invalid schedules"*.
- **V8 `data-model.md`** → entidad `schedule` con query_patterns: *"Get Instructor Schedules"*, *"Find Available Environments"*, *"Get Group Schedule Overview"* — índices compuestos.
- **V8 `ux-contract.md`** → pantallas `ScheduleList` y `ScheduleForm`, flujo `CRU2`, regla de negocio de solapamiento.
- **V9 `data-model.md`** → entidad `schedule_block` con `is_cancelled` para filtrado rápido e índices de detección de conflictos.
- **V9 `db-design.md`** → índices compuestos: `[room_id, start_time, end_time]`, `[training_group_id, start_time, end_time]`, `[instructor_id, start_time, end_time]`.

---

## Módulo 12 — Observaciones e Incidencias
**Tablas:** `observation`

**¿Qué hace?**
Permite registrar novedades, conflictos, bloqueos, reprogramaciones y seguimiento de situaciones especiales ligadas a un horario, instructor o ambiente.

**Justificación por archivo:**
- **V6 `data-model.md`** → entidad `observation` con: `schedule_id`, `note`, `created_at`.
- **V6 `requirements.md`** → *"Create and list observations linked to a schedule"*.
- **V7 `data-model.md`** → entidad `Observation` con: `schedule_id`, `content`, `type`, `created_by`.
- **V7 `prd.md`** → *"The system MUST allow recording observations for a schedule entry"*.
- **V7 `backlog.md`** → `HU-005: Add Observation` — *"Can add note to schedule"*.
- **V8 `requirements.md`** → `FR7`: *"allow observations to be registered and associated with a schedule, instructor, or operational context"*.
- **V8 `data-model.md`** → entidad `observation` con relación polimórfica: `reference_type` (schedule|instructor) + `reference_id`. Query pattern: *"List Observations for Instructor/Schedule"*.
- **V8 `ux-contract.md`** → pantallas `ObservationList` y `ObservationForm`, flujo `CRU5`.
- **V9 `data-model.md`** → campo `severity`: info | warning | critical — permite clasificar la gravedad de la novedad.
- **V9 `db-design.md`** → índice `[schedule_block_id]` para recuperación rápida de observaciones por bloque.

---

## Módulo 13 — Proyectos Formativos
**Tablas:** `formative_project`, `project_milestone`, `project_instructor`

**¿Qué hace?**
Gestiona proyectos formativos de programas técnicos y tecnólogos, su trazabilidad, hitos de avance, revisión e investigación aplicada.

**Justificación por archivo:**
- **V8 `requirements.md`** → contexto: gestión de `training_groups` que en programas titulados SENA siempre están vinculados a un proyecto formativo activo.
- **V8 `data-model.md`** → `training_group` con `start_date` y `end_date` — fechas que enmarcan la ejecución del proyecto formativo.
- **V9 `data-model.md`** → `training_group` tiene `status` (en_ejecucion | terminada) que corresponde al ciclo del proyecto formativo.
- **V7 `prd.md`** → scope incluye gestión de grupos que en SENA ejecutan proyectos formativos.
- **Imagen del instructor:** módulo 13 descrito explícitamente como *"Gestiona proyectos formativos de técnicos y tecnólogos, su trazabilidad, hitos, revisión y posible enfoque de investigación"*.
- **Estructura curricular SENA:** los programas titulados (técnico y tecnólogo) tienen proyectos formativos como estrategia pedagógica obligatoria definida en el diseño curricular. Sin proyecto no se pueden certificar competencias.

---

## Módulo 14 — Coordinación y Evaluación
**Tablas:** `evaluation_session`, `evaluation_result`

**¿Qué hace?**
Permite que coordinación asigne horas o espacios para revisar y calificar proyectos formativos sin afectar otros espacios académicos del Motor de Horarios.

**Justificación por archivo:**
- **V8 `requirements.md`** → rol *"Academic coordinator: manages schedules, environments, groups, instructors"* — incluye coordinar evaluaciones.
- **V8 `ux-contract.md`** → pantalla `Dashboard (Academic Coordinator)`: *"Vista general de estadísticas y accesos directos"* — incluye acceso a sesiones de evaluación.
- **V8 `requirements.md`** → `FR5`: el sistema permite asignar ambientes con notas descriptivas; las evaluaciones son un caso específico de sesión con ambiente reservado.
- **V9 `ux-contract.md`** → flujo crítico: *"Deshabilitar entidad con advertencia de bloques futuros afectados"* — implica sesiones de evaluación programadas.
- **Imagen del instructor:** módulo 14 descrito como *"Permite que coordinación asigne horas o espacios para revisar y calificar proyectos sin afectar otros espacios académicos"*.
- **Lógica SENA:** las evaluaciones de proyectos formativos requieren un ambiente y franja horaria exclusiva, separada del horario de formación regular, para evitar conflictos con el Motor de Horarios (Módulo 11).

---

## Módulo 15 — Notificaciones y Trazabilidad
**Tablas:** `notification`, `change_history`, `audit_log`

**¿Qué hace?**
Comunica eventos relevantes del sistema a los usuarios y conserva historial completo de cambios, revisiones y decisiones para auditoría y control interno.

**Justificación por archivo:**
- **V8 `db-design.md`** → `migration_strategy` incluye una colección `db_migrations` para rastrear cambios — principio de trazabilidad a nivel de datos.
- **V8 `requirements.md`** → `NFR9`: *"Error responses must not leak raw internal errors"* — requiere logging controlado.
- **V8 `requirements.md`** → `NFR10`: *"AppSec evidence must reference concrete controls and files"* — auditoría obligatoria.
- **V8 `security-threat-model.md`** → controles de trazabilidad de acciones como parte del modelo de seguridad.
- **V9 `security-threat-model.md`** → amplía controles de auditoría y registro de cambios.
- **V7 `appsec-report.md`** → evidencia de controles OWASP que requieren registro de acciones del sistema.
- **V9 `db-design.md`** → `backup_recovery`: *"Los logs de operaciones serán monitoreados para detectar anomalías y facilitar la recuperación a un punto en el tiempo"*.
- **Imagen del instructor:** módulo 15 descrito como *"Comunica eventos relevantes y conserva historial de cambios, revisiones y decisiones del sistema"*.
- **Estructura SENA:** la Oficina de Control Interno del SENA requiere trazabilidad de todas las acciones sobre datos académicos (Ley 87 de 1993).

---

## Tabla Resumen

| # | Módulo | Tablas | Fuente principal en archivos | Complemento SENA |
|---|--------|--------|------------------------------|------------------|
| 1 | Seguridad y Acceso | user, role, user_role, permission, session | user_roles V8, NFR8, security V8/V9, LoginScreen UX | Control de acceso por rol |
| 2 | Estructura Institucional | regional, training_center, headquarter | Contexto "training center" V8, location V6/V9 | Decreto 249/2004 |
| 3 | Catálogos Base | catalog_type, catalog_item, time_slot | allowed_values V8, TimeSlot V7, HU-003 V7 | Jornadas y parámetros configurables |
| 4 | Líneas y Redes | knowledge_network, tech_line | expertise_area V8/V9, FR4 V8 | SOFIA Plus — líneas tecnológicas |
| 5 | Oferta y Programas | training_program | program_name V6, scope V7, contexto V8 | SOFIA Plus — estados del programa |
| 6 | Programa Académico | competency, learning_outcome | expertise_area V8, schedule→competency V9 | Diseño curricular SENA — RAP |
| 7 | Instructores | instructor, instructor_expertise | Entidad instructor V6/V7/V8/V9, FR3/FR4/US3 V8 | Planta y contratistas SENA |
| 8 | Ambientes | environment, equipment | Entidad classroom/environment/room V6-V9, FR1/US1 V8 | Ambientes de aprendizaje |
| 9 | Fichas y Franjas | training_group | student_group V6, training_group V8, code V9, FR2 V8 | Fichas SOFIA Plus |
| 10 | Aprendices | learner, enrollment | learner_count V6, student_count V8/V9, US2 V8 | Matrícula SOFIA Plus |
| 11 | Motor de Horarios | schedule_block | schedule V6/V7/V8, schedule_block V9, FR5/FR6 V8 | Programación académica central |
| 12 | Observaciones | observation | observation V6/V7/V8/V9, FR7/US5 V8, severity V9 | Novedades operacionales |
| 13 | Proyectos Formativos | formative_project, project_milestone, project_instructor | training_group context V8/V9, imagen instructor | Proyectos formativos titulados |
| 14 | Coordinación y Evaluación | evaluation_session, evaluation_result | Dashboard V8, FR5 sesiones, imagen instructor | Evaluación de proyectos |
| 15 | Notificaciones y Trazabilidad | notification, change_history, audit_log | audit_log V8, appsec V7, NFR9/NFR10 V8, security V9 | Control Interno SENA |