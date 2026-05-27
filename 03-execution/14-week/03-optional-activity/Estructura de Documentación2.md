# Plantilla de Documentación — Reutilizable para Cualquier Proyecto
 
> Uso: copiar esta estructura al inicio de cualquier proyecto y adaptar solo las secciones marcadas con `[ADAPTAR]`  
> El resto de carpetas y archivos aplican sin cambios para cualquier sistema de software
 
---
 
## Leyenda
- **`[ADAPTAR]`** — cambiar nombre o contenido según el proyecto
- **`[OPCIONAL]`** — incluir solo si el proyecto lo requiere
- **`[FIJO]`** — no cambiar, aplica igual para cualquier proyecto
---
 
## Por qué cada categoría
 
### `[FIJO]` — no se toca en ningún proyecto
 
Estas secciones cubren preguntas que todo proyecto de software debe responder, sin importar el negocio: ¿cómo se documenta este repo? ¿cuál es el problema que resuelve? ¿qué se va a construir? ¿cómo está arquitecturado? ¿cómo son los datos? ¿cómo es la API? ¿cómo se asegura? ¿cómo se despliega? ¿cómo se prueba? ¿cómo se usa? Estas preguntas no cambian entre un sistema jurídico, un e-commerce o una app de salud. La estructura interna de cada carpeta tampoco cambia porque los documentos que la componen (`architecture-overview.md`, `testing-strategy.md`, `roles-permissions.md`, etc.) son universales — solo cambia el contenido que se escribe dentro de ellos.
 
Tocar estas carpetas o renombrarlas rompe la reutilización de la plantilla: el próximo desarrollador que llegue al proyecto ya no reconocerá dónde está cada cosa.
 
---
 
### `[ADAPTAR]` — la forma es fija, el nombre o contenido cambia
 
Estas secciones tienen una estructura interna que aplica para cualquier proyecto, pero su nombre o sus archivos internos dependen del negocio específico.
 
El caso más claro es `02-{dominio}-domain/`. Todo proyecto tiene un dominio de negocio con sus propios conceptos, actores y reglas — pero la forma de documentarlo (glosario, actores, reglas de negocio, ejemplos de entidades) es siempre la misma. Solo cambia de qué hablan esos documentos: en un sistema jurídico hablan de expedientes y abogados, en un e-commerce hablan de productos y pedidos, en un sistema de salud hablan de pacientes y diagnósticos.
 
Lo mismo pasa con `12-microservices/services/` — el template de cada módulo es idéntico para cualquier proyecto, pero los módulos que se crean dentro de `services/` dependen de lo que el sistema tenga implementado. Y con `{rol-principal}-guide.md` en capacitación — siempre existe una guía para el usuario principal, pero ese usuario es un abogado, un docente, un operador o un cliente según el proyecto.
 
---
 
### `[OPCIONAL]` — solo se incluye si el proyecto lo necesita
 
Estas secciones responden a necesidades específicas que no todos los proyectos tienen. Incluirlas cuando no aplican genera carpetas vacías que confunden al equipo y dan la impresión de que falta trabajo por hacer.
 
**`15-audit-and-compliance/`** aplica cuando el sistema maneja datos sensibles con obligaciones legales: información jurídica, datos médicos, datos financieros, información de menores. En esos contextos no basta con tener seguridad — hay que documentar qué se borra, cómo se borra, quién lo hizo y por cuánto tiempo se conserva el registro. Un MVP interno o una herramienta de gestión simple no necesita esto.
 
**`16-multi-tenant/`** aplica cuando el sistema sirve a múltiples organizaciones que comparten la misma infraestructura pero con datos completamente aislados entre sí. El riesgo de que los datos de una organización sean visibles para otra es crítico y necesita documentación propia. Un sistema de uso interno con un solo cliente no lo necesita.
 
**`17-integrations/`** aplica cuando el sistema se conecta con servicios externos que no controla el equipo: pasarelas de pago, APIs de terceros, sistemas ERP, servicios de notificación. Cada integración tiene su propio contrato, sus propios errores posibles y sus propias pruebas. Un sistema completamente autónomo sin dependencias externas no necesita esta sección.
 
---
 
## Estructura
 
```
{nombre-proyecto}-docs/                        [ADAPTAR] nombre del proyecto
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
    ├── 00-documentation-governance/           [FIJO]
    │   ├── README.md
    │   ├── repository-purpose.md
    │   ├── documentation-rules.md
    │   ├── naming-conventions.md
    │   ├── folder-conventions.md
    │   ├── versioning-rules.md
    │   ├── review-process.md
    │   └── definition-of-done.md
    │
    ├── 01-project-context/                    [FIJO]
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
    ├── 02-{dominio}-domain/                   [ADAPTAR] ej: legal, ecommerce, health, education
    │   ├── README.md
    │   ├── domain-glossary.md
    │   ├── domain-concepts.md
    │   ├── actors.md
    │   ├── business-rules.md
    │   ├── domain-boundaries.md
    │   └── examples/
    │       └── {entidad}.md                   [ADAPTAR] una por entidad principal del dominio
    │
    ├── 03-product-definition/                 [FIJO]
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
    ├── 04-architecture/                       [FIJO]
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
    │   │   └── level-4-code.md
    │   ├── adr/
    │   │   ├── README.md
    │   │   ├── proposed/
    │   │   │   └── ADR-000-template.md
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
    ├── 05-data-architecture/                  [FIJO]
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
    ├── 06-api-design/                         [FIJO]
    │   ├── README.md
    │   ├── api-standards.md
    │   ├── error-handling.md
    │   ├── pagination-filtering-sorting.md
    │   ├── authentication-authorization.md
    │   ├── versioning.md
    │   └── contracts/
    │       ├── openapi/
    │       └── asyncapi/
    │
    ├── 07-security/                           [FIJO]
    │   ├── README.md
    │   ├── security-principles.md
    │   ├── identity-access-management.md
    │   ├── roles-permissions.md
    │   ├── threat-model.md
    │   ├── data-protection.md
    │   ├── auditability.md
    │   └── security-checklist.md
    │
    ├── 08-devops/                             [FIJO]
    │   ├── README.md
    │   ├── repository-strategy.md
    │   ├── branching-strategy.md
    │   ├── ci-cd-strategy.md
    │   ├── environments.md
    │   ├── docker-standards.md
    │   ├── deployment-checklist.md
    │   └── observability.md
    │
    ├── 09-quality-assurance/                  [FIJO]
    │   ├── README.md
    │   ├── testing-strategy.md
    │   ├── unit-testing.md
    │   ├── integration-testing.md
    │   ├── e2e-testing.md
    │   ├── performance-testing.md
    │   ├── accessibility-testing.md
    │   └── quality-gates.md
    │
    ├── 10-user-experience/                    [FIJO]
    │   ├── README.md
    │   ├── ux-principles.md
    │   ├── information-architecture.md
    │   ├── navigation-model.md
    │   ├── wireframes.md
    │   ├── design-system.md
    │   └── accessibility-guidelines.md
    │
    ├── 11-backlog/                            [FIJO]
    │   ├── README.md
    │   ├── epics/
    │   ├── features/
    │   ├── user-stories/
    │   │   └── HU-000-template.md
    │   ├── tasks/
    │   │   └── TASK-000-template.md
    │   └── traceability-matrix.md
    │
    ├── 12-microservices/                      [FIJO estructura, ADAPTAR servicios]
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
    │   └── services/
    │       └── {nombre-modulo}/               [ADAPTAR] uno por módulo real del sistema
    │           ├── service-context.md
    │           ├── service-responsibilities.md
    │           ├── service-boundaries.md
    │           ├── service-api.md
    │           ├── service-data-model.md
    │           ├── service-security.md
    │           ├── service-deployment.md
    │           ├── service-testing.md
    │           └── service-runbook.md
    │
    ├── 13-operations/                         [FIJO]
    │   ├── README.md
    │   ├── runbooks.md
    │   ├── incident-management.md
    │   ├── backup-restore.md
    │   ├── monitoring-alerting.md
    │   └── support-model.md
    │
    ├── 14-training-and-adoption/              [FIJO estructura, ADAPTAR guías por rol]
    │   ├── README.md
    │   ├── user-manual.md
    │   ├── {rol-principal}-guide.md           [ADAPTAR] ej: lawyer, teacher, operator
    │   ├── administrator-guide.md
    │   ├── onboarding.md
    │   └── faq.md
    │
    ├── 15-audit-and-compliance/               [OPCIONAL] sistemas con datos sensibles
    │   ├── README.md
    │   ├── audit-log-model.md
    │   ├── soft-delete-policy.md
    │   ├── data-retention.md
    │   └── compliance-checklist.md
    │
    ├── 16-multi-tenant/                       [OPCIONAL] sistemas con múltiples organizaciones
    │   ├── README.md
    │   ├── tenant-model.md
    │   ├── tenant-isolation-strategy.md
    │   └── tenant-onboarding.md
    │
    ├── 17-integrations/                       [OPCIONAL] sistemas con integraciones externas
    │   ├── README.md
    │   └── {sistema-externo}/
    │       ├── integration-context.md
    │       ├── integration-contract.md
    │       └── integration-testing.md
    │
    └── 99-archive/                            [FIJO]
        ├── README.md
        ├── deprecated/
        └── legacy/
```