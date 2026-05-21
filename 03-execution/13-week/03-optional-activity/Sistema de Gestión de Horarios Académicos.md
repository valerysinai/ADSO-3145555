# Sistema de Gestión de Horarios Académicos — Estructura de Carpetas C4

> Proyecto: Sistema de Gestión de Horarios Académicos 
> Proyecto planteado: 2026-05-18
> Realizado: 2026-05-20

---

## Contexto C4

El modelo C4 organiza la arquitectura en cuatro niveles de abstracción:

| Nivel | Nombre | Qué describe |
|-------|--------|--------------|
| C1 | System Context | Quién usa el sistema y con qué interactúa |
| C2 | Container | Las aplicaciones/servicios que componen el sistema |
| C3 | Component | Los módulos internos de cada contenedor |
| C4 | Code | La estructura de código: clases, carpetas, patrones |


Este documento se enfoca en **C4 (Code)**, mostrando la organización de carpetas en cuatro variantes de arquitectura. Estas carpetas es un planteamiento según las indicaciones de el instructor Jesús Ariel.

---

## C4.1 — Old Project (Organización original)

Estructura legacy donde cada dominio tiene sus propias capas como carpetas directas. Simple pero difícil de escalar.

```
PRJ-EDU-HORARIOS/
│
├── Security/
│   ├── Entity/
│   │   └── SecurityEntity.cs          # Modelo de datos de seguridad (usuario, rol, permiso)
│   ├── IRepository/
│   │   └── ISecurityRepository.cs     # Contrato de acceso a datos
│   ├── IService/
│   │   └── ISecurityService.cs        # Contrato de lógica de negocio
│   ├── Service/
│   │   └── SecurityService.cs         # Implementación de lógica de negocio
│   ├── Controller/
│   │   └── SecurityController.cs      # Endpoints REST (login, refresh, logout)
│   ├── DTO/
│   │   └── SecurityDTO.cs             # Objetos de transferencia (request/response)
│   ├── IDTO/
│   │   └── ISecurityDTO.cs            # Contratos de los DTOs
│   └── Utils/
│       └── JWT.cs                     # Generación y validación de tokens JWT
│
├── Inventory/
│   ├── Entity/
│   │   └── InventoryEntity.cs
│   ├── IRepository/
│   │   └── IInventoryRepository.cs
│   ├── IService/
│   │   └── IInventoryService.cs
│   ├── Service/
│   │   └── InventoryService.cs
│   ├── Controller/
│   │   └── InventoryController.cs
│   ├── DTO/
│   │   └── InventoryDTO.cs
│   ├── IDTO/
│   │   └── IInventoryDTO.cs
│   └── Utils/
│       └── ProccessInventory.cs       # Lógica de procesamiento de inventario
│
└── Shared/
    └── JWT.cs                         # Utilidades compartidas entre módulos
```

**Cuándo usarla:** proyectos pequeños, equipos de 1-2 personas, MVPs iniciales.  
**Problema:** cuando crece el proyecto, las carpetas por tipo (`Entity/`, `Service/`) mezclan contextos de diferentes dominios.

---

## C4.2 — By Module (Organización por módulo funcional)
 
Cada módulo es autónomo. Todos sus archivos (entidad, servicio, controller, etc.) viven juntos bajo su carpeta de módulo.
 
```
PRJ-EDU-HORARIOS/
│
├── SecurityModule/
│   ├── Entity/
│   │   └── SecurityEntity.cs
│   ├── IRepository/
│   │   └── ISecurityRepository.cs
│   ├── IService/
│   │   └── ISecurityService.cs
│   ├── Service/
│   │   └── SecurityService.cs
│   ├── Controller/
│   │   └── SecurityController.cs
│   ├── DTO/
│   │   └── SecurityDTO.cs
│   ├── IDTO/
│   │   └── ISecurityDTO.cs
│   └── Utils/
│       └── JWT.cs
│
├── InventoryModule/
│   ├── Entity/
│   │   └── InventoryEntity.cs
│   ├── IRepository/
│   │   └── IInventoryRepository.cs
│   ├── IService/
│   │   └── IInventoryService.cs
│   ├── Service/
│   │   └── InventoryService.cs
│   ├── Controller/
│   │   └── InventoryController.cs
│   ├── DTO/
│   │   └── InventoryDTO.cs
│   ├── IDTO/
│   │   └── IInventoryDTO.cs
│   └── Utils/
│       └── ProccessInventory.cs
│
└── ScheduleModule/                    # Módulo core del proyecto horarios
    ├── Entity/
    │   └── ScheduleEntity.cs          # Bloque horario (instructor + ambiente + franja)
    ├── IRepository/
    │   └── IScheduleRepository.cs
    ├── IService/
    │   └── IScheduleService.cs
    ├── Service/
    │   └── ScheduleService.cs         # Motor de validación de cruces (triple restricción)
    ├── Controller/
    │   └── ScheduleController.cs
    ├── DTO/
    │   └── ScheduleDTO.cs
    ├── IDTO/
    │   └── IScheduleDTO.cs
    └── Utils/
        └── ConflictValidator.cs       # Lógica de detección de conflictos de horario
```
 
**Cuándo usarla:** equipos medianos, cuando cada módulo puede asignarse a un desarrollador diferente.  
**Ventaja:** alta cohesión por módulo, bajo acoplamiento entre módulos.
 
---
 
## C4.3 — DDD (Domain Driven Design → TDD)
 
Organización por capas de responsabilidad dentro de cada dominio. El dominio es el núcleo; infraestructura y presentación dependen de él, nunca al revés. Los tests viven en su propia capa y acompañan cada servicio de dominio.
 
```
PRJ-EDU-HORARIOS/
│
├── Domain/                            # Núcleo puro: reglas de negocio, sin dependencias externas
│   │
│   ├── Security/
│   │   ├── Entities/
│   │   │   └── SecurityEntity.cs      # Agregado raíz del dominio de seguridad
│   │   ├── ValueObjects/
│   │   │   └── Credentials.cs         # Objeto de valor: email + contraseña hasheada
│   │   ├── Interfaces/
│   │   │   └── ISecurityRepository.cs # Puerto de salida (no conoce la BD)
│   │   └── Services/
│   │       └── SecurityDomainService.cs # Reglas: validar token, expiración, roles
│   │
│   ├── Inventory/
│   │   ├── Entities/
│   │   │   └── InventoryEntity.cs
│   │   ├── Interfaces/
│   │   │   └── IInventoryRepository.cs
│   │   └── Services/
│   │       └── InventoryDomainService.cs
│   │
│   └── Schedule/                      # Dominio principal del sistema
│       ├── Entities/
│       │   ├── ScheduleBlock.cs       # Agregado: instructor + ambiente + TimeSlot
│       │   ├── Instructor.cs          # Entidad: datos y disponibilidad del instructor
│       │   └── Environment.cs         # Entidad: salón/laboratorio y su capacidad
│       ├── ValueObjects/
│       │   └── TimeSlot.cs            # Objeto de valor: día + hora inicio + hora fin
│       ├── Interfaces/
│       │   └── IScheduleRepository.cs
│       └── Services/
│           └── ConflictValidatorService.cs # Regla core: previene cruces (triple restricción)
│
├── Application/                       # Casos de uso: orquesta el dominio
│   │
│   ├── Security/
│   │   ├── IService/
│   │   │   └── ISecurityService.cs
│   │   ├── Service/
│   │   │   └── SecurityService.cs     # Caso de uso: login, logout, refresh token
│   │   ├── DTO/
│   │   │   └── SecurityDTO.cs
│   │   ├── IDTO/
│   │   │   └── ISecurityDTO.cs
│   │   └── Utils/
│   │       └── JWT.cs                 # Generación y validación de JWT
│   │
│   ├── Inventory/
│   │   ├── IService/
│   │   │   └── IInventoryService.cs
│   │   ├── Service/
│   │   │   └── InventoryService.cs
│   │   ├── DTO/
│   │   │   └── InventoryDTO.cs
│   │   ├── IDTO/
│   │   │   └── IInventoryDTO.cs
│   │   └── Utils/
│   │       └── ProccessInventory.cs
│   │
│   └── Schedule/
│       ├── IService/
│       │   └── IScheduleService.cs
│       ├── Service/
│       │   └── ScheduleService.cs     # Caso de uso: crear bloque, buscar disponibilidad
│       ├── DTO/
│       │   └── ScheduleDTO.cs         # Request/Response de franjas horarias
│       └── IDTO/
│           └── IScheduleDTO.cs
│
├── Infrastructure/                    # Adaptadores: BD, APIs externas, archivos
│   ├── Security/
│   │   └── Repositories/
│   │       └── SecurityRepository.cs  # Implementa ISecurityRepository con EF Core / ADO
│   ├── Inventory/
│   │   └── Repositories/
│   │       └── InventoryRepository.cs
│   ├── Schedule/
│   │   └── Repositories/
│   │       └── ScheduleRepository.cs  # Queries SQL de disponibilidad y validación
│   └── Persistence/
│       └── AppDbContext.cs            # Contexto EF Core, mapeos, migraciones
│
├── Presentation/                      # API: recibe HTTP, delega a Application
│   ├── Security/
│   │   └── Controllers/
│   │       └── SecurityController.cs
│   ├── Inventory/
│   │   └── Controllers/
│   │       └── InventoryController.cs
│   └── Schedule/
│       └── Controllers/
│           └── ScheduleController.cs  # Endpoints: POST /horarios, GET /disponibilidad
│
└── Tests/                             # TDD: un test por servicio de dominio y aplicación
    ├── Domain/
    │   ├── Security/
    │   │   └── SecurityDomainService.Tests.cs
    │   ├── Inventory/
    │   │   └── InventoryDomainService.Tests.cs
    │   └── Schedule/
    │       └── ConflictValidator.Tests.cs   # Tests del motor de cruces (caso bloqueante)
    ├── Application/
    │   ├── Security/
    │   │   └── SecurityService.Tests.cs
    │   ├── Inventory/
    │   │   └── InventoryService.Tests.cs
    │   └── Schedule/
    │       └── ScheduleService.Tests.cs     # Tests de casos de uso de horarios
    └── Infrastructure/
        └── Schedule/
            └── ScheduleRepository.Tests.cs  # Tests de integración con BD
```
 
**Cuándo usarla:** sistemas complejos con reglas de negocio ricas, equipos grandes, cuando el dominio cambia frecuentemente.  
**Clave DDD aplicada al proyecto:** el `ConflictValidatorService` vive en `Domain/Schedule/Services/` porque la regla de la triple restricción (instructor + ambiente + franja) es pura lógica de negocio, sin depender de ninguna base de datos.  
**Clave TDD:** los tests de `ConflictValidator` se escriben **antes** de implementar el servicio.
 
---
 
## C4.4 — MVC (Model View Controller)
 
Organización clásica web por tipo de archivo. Adecuada para aplicaciones con vistas renderizadas en servidor.
 
```
PRJ-EDU-HORARIOS/
│
├── Models/                            # Representan los datos y reglas del negocio
│   ├── Security/
│   │   ├── SecurityEntity.cs          # Modelo de usuario/rol
│   │   ├── SecurityDTO.cs
│   │   └── ISecurityDTO.cs
│   ├── Inventory/
│   │   ├── InventoryEntity.cs
│   │   ├── InventoryDTO.cs
│   │   └── IInventoryDTO.cs
│   └── Schedule/
│       ├── ScheduleEntity.cs          # Modelo de bloque horario
│       ├── ScheduleDTO.cs
│       └── IScheduleDTO.cs
│
├── Views/                             # Plantillas de interfaz de usuario
│   ├── Security/
│   │   ├── Login.cshtml
│   │   └── Profile.cshtml
│   ├── Inventory/
│   │   ├── Index.cshtml
│   │   └── Detail.cshtml
│   └── Schedule/
│       ├── Index.cshtml               # Vista principal de horarios
│       ├── Availability.cshtml        # Buscador de disponibilidad en tiempo real
│       └── Report.cshtml              # Reporte de carga horaria por instructor
│
├── Controllers/                       # Reciben peticiones, coordinan Model y View
│   ├── SecurityController.cs
│   ├── InventoryController.cs
│   └── ScheduleController.cs
│
├── Services/                          # Lógica de negocio separada del controller
│   ├── ISecurityService.cs
│   ├── SecurityService.cs
│   ├── IInventoryService.cs
│   ├── InventoryService.cs
│   ├── IScheduleService.cs
│   └── ScheduleService.cs
│
├── Repositories/                      # Acceso a datos
│   ├── ISecurityRepository.cs
│   ├── SecurityRepository.cs
│   ├── IInventoryRepository.cs
│   ├── InventoryRepository.cs
│   ├── IScheduleRepository.cs
│   └── ScheduleRepository.cs
│
└── Utils/                             # Utilidades transversales
    ├── JWT.cs                         # Manejo de tokens de autenticación
    ├── ConflictValidator.cs           # Validación de cruces de horario
    └── ProccessInventory.cs           # Procesamiento de inventario
```
 
**Cuándo usarla:** aplicaciones web tradicionales con vistas en servidor (Razor, MVC clásico), equipos familiarizados con el patrón.  
**Limitación:** a medida que crece, `Controllers/` y `Services/` se llenan de archivos sin distinción de dominio.