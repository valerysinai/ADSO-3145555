# Lawyer Manager — Estructura de Documentación

## Leyenda de cambios
- **`[nuevo]`** — archivo o carpeta que no existía y se añadió
- **`[renombrado]`** — existía pero con nombre incorrecto para este dominio
- **`[poblado]`** — existía vacío, ahora tiene contenido real

---

## Estructura

```
lawyer-manager-docs/
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── LICENSE
│
├── .github/
│   ├── pull_request_template.md
│   └── workflows/
│       ├── docs-lint.yml
│       └── links-check.yml
│
└── docs/
    ├── README.md
    │
    ├── 00-documentation-governance/
    │   ├── README.md
    │   ├── repository-purpose.md
    │   ├── documentation-rules.md
    │   ├── naming-conventions.md
    │   ├── folder-conventions.md
    │   ├── versioning-rules.md
    │   ├── review-process.md
    │   └── definition-of-done.md
    │
    ├── 01-project-context/
    │   ├── README.md
    │   ├── initial-context.md
    │   ├── problem-space.md
    │   ├── business-objectives.md
    │   ├── scope.md
    │   ├── out-of-scope.md
    │   ├── constraints.md
    │   ├── assumptions.md
    │   └── glossary.md
    │
    ├── 02-legal-domain/                        [renombrado]
    │   ├── README.md
    │   ├── domain-glossary.md
    │   ├── domain-concepts.md
    │   ├── actors.md
    │   ├── business-rules.md
    │   ├── domain-boundaries.md
    │   └── examples/
    │       ├── cliente.md                      [renombrado]
    │       ├── proceso.md                      [renombrado]
    │       ├── tarea.md                        [renombrado]
    │       ├── termino-judicial.md             [renombrado]
    │       ├── conflicto-intereses.md          [renombrado]
    │       └── workspace-tenant.md             [nuevo]
    │
    ├── 03-product-definition/
    │   ├── README.md
    │   ├── product-vision.md
    │   ├── mvp-definition.md
    │   ├── roadmap.md
    │   ├── user-personas.md
    │   ├── user-journeys.md
    │   ├── functional-requirements.md
    │   ├── non-functional-requirements.md
    │   └── acceptance-criteria.md
    │
    ├── 04-architecture/
    │   ├── README.md
    │   ├── architecture-principles.md
    │   ├── architecture-overview.md
    │   ├── architecture-decisions-summary.md
    │   ├── quality-attributes.md
    │   ├── integration-strategy.md
    │   ├── deployment-strategy.md
    │   ├── c4/
    │   │   ├── README.md
    │   │   ├── level-1-context.md
    │   │   ├── level-2-containers.md
    │   │   ├── level-3-components.md
    │   │   ├── level-4-code.md
    │   │   └── route-audit.md                 [nuevo]
    │   ├── adr/
    │   │   ├── README.md
    │   │   ├── proposed/
    │   │   │   ├── ADR-000-template.md
    │   │   │   └── ADR-001-route-naming.md    [nuevo]
    │   │   ├── accepted/
    │   │   ├── superseded/
    │   │   └── rejected/
    │   └── diagrams/
    │       ├── README.md
    │       ├── source/
    │       │   ├── plantuml/
    │       │   ├── mermaid/
    │       │   └── drawio/
    │       └── exported/
    │           ├── png/
    │           └── svg/
    │
    ├── 05-data-architecture/
    │   ├── README.md
    │   ├── conceptual-model.md
    │   ├── logical-model.md
    │   ├── relational-model.md
    │   ├── entity-catalog.md
    │   ├── data-dictionary.md
    │   ├── database-standards.md
    │   ├── migration-strategy.md
    │   └── diagrams/
    │       ├── erd.md
    │       └── mer.md
    │
    ├── 06-api-design/
    │   ├── README.md
    │   ├── api-standards.md
    │   ├── error-handling.md
    │   ├── pagination-filtering-sorting.md
    │   ├── authentication-authorization.md
    │   ├── versioning.md
    │   ├── route-migration.md                 [nuevo]
    │   └── contracts/
    │       ├── openapi/
    │       └── asyncapi/
    │
    ├── 07-security/
    │   ├── README.md
    │   ├── security-principles.md
    │   ├── identity-access-management.md
    │   ├── roles-permissions.md
    │   ├── tenant-model.md                    [nuevo]
    │   ├── threat-model.md
    │   ├── data-protection.md
    │   ├── auditability.md
    │   └── security-checklist.md
    │
    ├── 08-devops/
    │   ├── README.md
    │   ├── repository-strategy.md
    │   ├── branching-strategy.md
    │   ├── ci-cd-strategy.md
    │   ├── environments.md
    │   ├── docker-standards.md
    │   ├── deployment-checklist.md
    │   └── observability.md
    │
    ├── 09-quality-assurance/
    │   ├── README.md
    │   ├── testing-strategy.md
    │   ├── unit-testing.md
    │   ├── integration-testing.md
    │   ├── e2e-testing.md
    │   ├── performance-testing.md
    │   ├── accessibility-testing.md
    │   └── quality-gates.md
    │
    ├── 10-user-experience/
    │   ├── README.md
    │   ├── ux-principles.md
    │   ├── information-architecture.md
    │   ├── navigation-model.md
    │   ├── wireframes.md
    │   ├── design-system.md
    │   └── accessibility-guidelines.md
    │
    ├── 11-backlog/
    │   ├── README.md
    │   ├── epics/
    │   ├── features/
    │   ├── user-stories/
    │   │   └── HU-000-template.md
    │   ├── tasks/
    │   │   └── TASK-000-template.md
    │   └── traceability-matrix.md
    │
    ├── 12-microservices/
    │   ├── README.md
    │   ├── microservice-catalog.md
    │   ├── microservice-template/
    │   │   ├── README.md
    │   │   ├── service-context.md
    │   │   ├── service-responsibilities.md
    │   │   ├── service-boundaries.md
    │   │   ├── service-api.md
    │   │   ├── service-data-model.md
    │   │   ├── service-security.md
    │   │   ├── service-deployment.md
    │   │   ├── service-testing.md
    │   │   └── service-runbook.md
    │   └── services/                          [poblado]
    │       ├── README.md
    │       ├── dashboard/                     [nuevo]
    │       │   └── (mismos archivos del template)
    │       ├── cases/                         [nuevo]
    │       │   └── (mismos archivos del template)
    │       ├── tasks/                         [nuevo]
    │       │   └── (mismos archivos del template)
    │       ├── terms/                         [nuevo]
    │       │   └── (mismos archivos del template)
    │       ├── conflicts/                     [nuevo]
    │       │   └── (mismos archivos del template)
    │       ├── clients/                       [nuevo]
    │       │   └── (mismos archivos del template)
    │       └── security/                      [nuevo]
    │           └── (mismos archivos del template)
    │
    ├── 13-operations/
    │   ├── README.md
    │   ├── runbooks.md
    │   ├── incident-management.md
    │   ├── backup-restore.md
    │   ├── monitoring-alerting.md
    │   └── support-model.md
    │
    ├── 14-training-and-adoption/
    │   ├── README.md
    │   ├── user-manual.md
    │   ├── lawyer-guide.md                    [renombrado]
    │   ├── administrator-guide.md
    │   ├── onboarding.md
    │   └── faq.md
    │
    ├── 15-audit-and-compliance/               [nuevo]
    │   ├── README.md
    │   ├── audit-log-model.md
    │   ├── soft-delete-policy.md
    │   ├── data-retention.md
    │   └── compliance-checklist.md
    │
    └── 99-archive/
        ├── README.md
        ├── deprecated/
        └── legacy/
```

---

## Explicación de cambios

### Renombrados

**`02-sena-domain/` → `02-legal-domain/`**
La estructura base usaba el nombre `sena-domain` pensado para un sistema educativo. El proyecto real es Lawyer Manager, un software jurídico, por lo que el dominio corresponde a conceptos legales como expedientes, procesos y términos judiciales, no a fichas o aprendices del SENA.

**`examples/` (archivos internos)**
Los archivos `aprendiz.md`, `instructor.md`, `ficha.md`, etc. se reemplazaron por ejemplos del dominio jurídico real: `cliente.md`, `proceso.md`, `tarea.md`, `termino-judicial.md` y `conflicto-intereses.md`. Cada uno representa una entidad concreta que maneja la app.

**`instructor-guide.md` → `lawyer-guide.md`**
En este sistema no existen instructores. El actor principal que opera el despacho es el abogado, por lo que la guía de usuario debe reflejar ese rol.

---

### Nuevos

**`02-legal-domain/examples/workspace-tenant.md`**
Documenta con un ejemplo concreto cómo funciona el aislamiento por despacho (tenant). La app usa multi-tenant desde el login (campo workspace), y cualquier desarrollador nuevo necesita entender ese concepto antes de tocar el código.

**`04-architecture/c4/route-audit.md`**
Recoge los hallazgos del PDF de auditoría del 2026-05-25: rutas en español, operaciones CRUD faltantes y URLs de más de 500 caracteres. Sin este archivo, la auditoría queda como un documento suelto sin trazabilidad dentro de la arquitectura.

**`04-architecture/adr/proposed/ADR-001-route-naming.md`**
Registra la decisión formal de usar rutas en inglés (`app/cases` en lugar de `app/procesos`). Los ADR documentan el *por qué* de las decisiones para que el equipo no las revierta sin entender el contexto.

**`06-api-design/route-migration.md`**
Contiene el plan de migración de rutas de español a inglés con redirects 302 durante 3 meses, el listado de rutas afectadas y los criterios de aceptación. Es un documento operativo que no encajaba en ninguna carpeta existente.

**`07-security/tenant-model.md`**
Define cómo se aíslan los datos entre despachos (tenants). En un sistema jurídico, que los datos de un despacho sean accesibles desde otro es una falla legal, no solo técnica. Este documento no existía y es crítico antes de salir a producción.

**`15-audit-and-compliance/`**
Sección completamente nueva. El PDF marcó como crítico que `app/procesos` no tiene operación DELETE y recomendó soft-delete con auditoría. En el dominio jurídico no se pueden borrar expedientes sin dejar rastro — hay obligaciones legales de retención y trazabilidad que van más allá de DevOps o seguridad, y por eso necesitan su propia sección.

- `audit-log-model.md` — qué se registra, quién y cuándo
- `soft-delete-policy.md` — política de borrado lógico con campo `deleted_at`
- `data-retention.md` — cuánto tiempo deben vivir los expedientes
- `compliance-checklist.md` — requisitos legales del dominio jurídico colombiano

**`12-microservices/services/` (módulos)**
Los 7 módulos reales visibles en la app se documentaron individualmente: `dashboard`, `cases`, `tasks`, `terms`, `conflicts`, `clients` y `security`. Cada uno usa el mismo template del instructor.

---

### Poblado

**`12-microservices/services/`**
En la estructura base esta carpeta solo tenía un `.gitkeep`. Como los módulos del sistema ya están identificados e implementados, dejarla vacía era una deuda de documentación innecesaria. Se pobló con los 7 módulos reales de la app.