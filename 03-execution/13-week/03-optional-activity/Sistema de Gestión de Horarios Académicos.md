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

