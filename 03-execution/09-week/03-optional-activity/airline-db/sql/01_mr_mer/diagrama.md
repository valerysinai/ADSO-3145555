# Modelo Relacional (MR) y Modelo Entidad-Relación (MER)
## Base de Datos: Sistema de Aerolíneas

---

## 1. MODELO ENTIDAD-RELACIÓN (MER) — Descripción por módulos

### 📌 Módulo: Geografía y Referencia
```
[continent] 1 ──< [country] 1 ──< [state_province] 1 ──< [city] 1 ──< [district] 1 ──< [address]
[time_zone] 1 ──< [city]
[currency]  (tabla independiente de referencia)
```

### 📌 Módulo: Identidad / Personas
```
[person_type]    1 ──< [person]
[country]        1 ──< [person]  (nationality)
[person]         1 ──< [person_document]
[document_type]  1 ──< [person_document]
[country]        1 ──< [person_document] (issuing_country)
[person]         1 ──< [person_contact]
[contact_type]   1 ──< [person_contact]
```

### 📌 Módulo: Seguridad
```
[person]           1 ──1 [user_account]
[user_status]      1 ──< [user_account]
[user_account]     1 ──< [user_role]
[security_role]    1 ──< [user_role]
[security_role]    1 ──< [role_permission]
[security_permission] 1 ──< [role_permission]
```

### 📌 Módulo: Cliente y Lealtad
```
[airline]             1 ──< [customer]
[person]              1 ──< [customer]
[customer_category]   1 ──< [customer]
[airline]             1 ──< [loyalty_program]
[currency]            1 ──< [loyalty_program]
[loyalty_program]     1 ──< [loyalty_tier]
[customer]            1 ──< [loyalty_account]
[loyalty_program]     1 ──< [loyalty_account]
[loyalty_account]     1 ──< [loyalty_account_tier]
[loyalty_tier]        1 ──< [loyalty_account_tier]
[loyalty_account]     1 ──< [miles_transaction]
[loyalty_tier]        1 ──< [tier_benefit]
[benefit_type]        1 ──< [tier_benefit]
```

### 📌 Módulo: Aerolínea
```
[country]   1 ──< [airline]
```

### 📌 Módulo: Aeropuertos
```
[address]   1 ──< [airport]
[airport]   1 ──< [terminal]
[terminal]  1 ──< [boarding_gate]
[airport]   1 ──< [runway]
[airport]   1 ──< [airport_regulation]
```

### 📌 Módulo: Aeronaves
```
[aircraft_manufacturer] 1 ──< [aircraft_model]
[airline]               1 ──< [aircraft]
[aircraft_model]        1 ──< [aircraft]
[aircraft]              1 ──< [aircraft_cabin]
[cabin_class]           1 ──< [aircraft_cabin]
[aircraft_cabin]        1 ──< [aircraft_seat]
[aircraft]              1 ──< [maintenance_event]
[maintenance_type]      1 ──< [maintenance_event]
[maintenance_provider]  1 ──< [maintenance_event]
[address]               1 ──< [maintenance_provider]
```

### 📌 Módulo: Operaciones de Vuelo
```
[airline]         1 ──< [flight]
[aircraft]        1 ──< [flight]
[flight_status]   1 ──< [flight]
[flight]          1 ──< [flight_segment]
[airport]         1 ──< [flight_segment]  (origin)
[airport]         1 ──< [flight_segment]  (destination)
[flight_segment]  1 ──< [flight_delay]
[delay_reason_type] 1 ──< [flight_delay]
```

### 📌 Módulo: Ventas, Reservas y Tiquetes
```
[reservation_status]    1 ──< [reservation]
[sale_channel]          1 ──< [reservation]
[customer]              1 ──< [reservation]  (booked_by)
[reservation]           1 ──< [reservation_passenger]
[person]                1 ──< [reservation_passenger]
[reservation]           1 ──< [sale]
[currency]              1 ──< [sale]
[sale]                  1 ──< [ticket]
[reservation_passenger] 1 ──< [ticket]
[fare]                  1 ──< [ticket]
[ticket_status]         1 ──< [ticket]
[ticket]                1 ──< [ticket_segment]
[flight_segment]        1 ──< [ticket_segment]
[ticket_segment]        1 ──1 [seat_assignment]
[aircraft_seat]         1 ──< [seat_assignment]
[ticket_segment]        1 ──< [baggage]
[airline]               1 ──< [fare]
[airport]               1 ──< [fare]  (origin/destination)
[fare_class]            1 ──< [fare]
[currency]              1 ──< [fare]
[cabin_class]           1 ──< [fare_class]
```

### 📌 Módulo: Embarque
```
[ticket_segment]  1 ──1 [check_in]
[check_in_status] 1 ──< [check_in]
[boarding_group]  1 ──< [check_in]
[user_account]    1 ──< [check_in]
[check_in]        1 ──1 [boarding_pass]
[boarding_pass]   1 ──< [boarding_validation]
[boarding_gate]   1 ──< [boarding_validation]
[user_account]    1 ──< [boarding_validation]
```

### 📌 Módulo: Pagos
```
[sale]            1 ──< [payment]
[payment_status]  1 ──< [payment]
[payment_method]  1 ──< [payment]
[currency]        1 ──< [payment]
[payment]         1 ──< [payment_transaction]
[payment]         1 ──< [refund]
```

### 📌 Módulo: Facturación
```
[sale]            1 ──< [invoice]
[invoice_status]  1 ──< [invoice]
[currency]        1 ──< [invoice]
[invoice]         1 ──< [invoice_line]
[tax]             1 ──< [invoice_line]
[currency]        1 ──< [exchange_rate]  (from/to)
```

---

## 2. MODELO RELACIONAL (MR) — Tablas con claves

> Notación: **PK** = Primary Key | **FK** = Foreign Key | **UQ** = Unique

### Geografía
| Tabla | PK | FKs principales |
|---|---|---|
| continent | continent_id | — |
| country | country_id | FK continent_id |
| state_province | state_province_id | FK country_id |
| city | city_id | FK state_province_id, FK time_zone_id |
| district | district_id | FK city_id |
| address | address_id | FK district_id |
| time_zone | time_zone_id | — |
| currency | currency_id | — |

### Identidad
| Tabla | PK | FKs principales |
|---|---|---|
| person_type | person_type_id | — |
| document_type | document_type_id | — |
| contact_type | contact_type_id | — |
| person | person_id | FK person_type_id, FK nationality_country_id |
| person_document | person_document_id | FK person_id, FK document_type_id, FK issuing_country_id |
| person_contact | person_contact_id | FK person_id, FK contact_type_id |

### Seguridad
| Tabla | PK | FKs principales |
|---|---|---|
| user_status | user_status_id | — |
| security_role | security_role_id | — |
| security_permission | security_permission_id | — |
| user_account | user_account_id | FK person_id, FK user_status_id |
| user_role | user_role_id | FK user_account_id, FK security_role_id |
| role_permission | role_permission_id | FK security_role_id, FK security_permission_id |

### Cliente y Lealtad
| Tabla | PK | FKs principales |
|---|---|---|
| customer_category | customer_category_id | — |
| benefit_type | benefit_type_id | — |
| customer | customer_id | FK airline_id, FK person_id, FK customer_category_id |
| loyalty_program | loyalty_program_id | FK airline_id, FK currency_id |
| loyalty_tier | loyalty_tier_id | FK loyalty_program_id |
| loyalty_account | loyalty_account_id | FK customer_id, FK loyalty_program_id |
| loyalty_account_tier | loyalty_account_tier_id | FK loyalty_account_id, FK loyalty_tier_id |
| miles_transaction | miles_transaction_id | FK loyalty_account_id |
| tier_benefit | tier_benefit_id | FK loyalty_tier_id, FK benefit_type_id |

### Aerolínea y Aeropuertos
| Tabla | PK | FKs principales |
|---|---|---|
| airline | airline_id | FK home_country_id |
| airport | airport_id | FK address_id |
| terminal | terminal_id | FK airport_id |
| boarding_gate | boarding_gate_id | FK terminal_id |
| runway | runway_id | FK airport_id |
| airport_regulation | airport_regulation_id | FK airport_id |

### Aeronaves
| Tabla | PK | FKs principales |
|---|---|---|
| aircraft_manufacturer | aircraft_manufacturer_id | — |
| aircraft_model | aircraft_model_id | FK aircraft_manufacturer_id |
| cabin_class | cabin_class_id | — |
| aircraft | aircraft_id | FK airline_id, FK aircraft_model_id |
| aircraft_cabin | aircraft_cabin_id | FK aircraft_id, FK cabin_class_id |
| aircraft_seat | aircraft_seat_id | FK aircraft_cabin_id |
| maintenance_provider | maintenance_provider_id | FK address_id |
| maintenance_type | maintenance_type_id | — |
| maintenance_event | maintenance_event_id | FK aircraft_id, FK maintenance_type_id, FK maintenance_provider_id |

### Vuelos
| Tabla | PK | FKs principales |
|---|---|---|
| flight_status | flight_status_id | — |
| delay_reason_type | delay_reason_type_id | — |
| flight | flight_id | FK airline_id, FK aircraft_id, FK flight_status_id |
| flight_segment | flight_segment_id | FK flight_id, FK origin_airport_id, FK destination_airport_id |
| flight_delay | flight_delay_id | FK flight_segment_id, FK delay_reason_type_id |

### Ventas y Tiquetes
| Tabla | PK | FKs principales |
|---|---|---|
| reservation_status | reservation_status_id | — |
| sale_channel | sale_channel_id | — |
| fare_class | fare_class_id | FK cabin_class_id |
| fare | fare_id | FK airline_id, FK origin_airport_id, FK destination_airport_id, FK fare_class_id, FK currency_id |
| ticket_status | ticket_status_id | — |
| reservation | reservation_id | FK booked_by_customer_id, FK reservation_status_id, FK sale_channel_id |
| reservation_passenger | reservation_passenger_id | FK reservation_id, FK person_id |
| sale | sale_id | FK reservation_id, FK currency_id |
| ticket | ticket_id | FK sale_id, FK reservation_passenger_id, FK fare_id, FK ticket_status_id |
| ticket_segment | ticket_segment_id | FK ticket_id, FK flight_segment_id |
| seat_assignment | seat_assignment_id | FK ticket_segment_id, FK flight_segment_id, FK aircraft_seat_id |
| baggage | baggage_id | FK ticket_segment_id |

### Embarque
| Tabla | PK | FKs principales |
|---|---|---|
| boarding_group | boarding_group_id | — |
| check_in_status | check_in_status_id | — |
| check_in | check_in_id | FK ticket_segment_id, FK check_in_status_id, FK boarding_group_id |
| boarding_pass | boarding_pass_id | FK check_in_id |
| boarding_validation | boarding_validation_id | FK boarding_pass_id, FK boarding_gate_id |

### Pagos y Facturación
| Tabla | PK | FKs principales |
|---|---|---|
| payment_status | payment_status_id | — |
| payment_method | payment_method_id | — |
| payment | payment_id | FK sale_id, FK payment_status_id, FK payment_method_id, FK currency_id |
| payment_transaction | payment_transaction_id | FK payment_id |
| refund | refund_id | FK payment_id |
| tax | tax_id | — |
| exchange_rate | exchange_rate_id | FK from_currency_id, FK to_currency_id |
| invoice_status | invoice_status_id | — |
| invoice | invoice_id | FK sale_id, FK invoice_status_id, FK currency_id |
| invoice_line | invoice_line_id | FK invoice_id, FK tax_id |

---

## 3. CARDINALIDADES CLAVE

| Relación | Cardinalidad | Descripción |
|---|---|---|
| continent → country | 1:N | Un continente tiene muchos países |
| country → state_province | 1:N | Un país tiene muchos estados/dptos |
| person → user_account | 1:1 | Una persona tiene máximo una cuenta |
| person → person_document | 1:N | Una persona puede tener varios documentos |
| airline → aircraft | 1:N | Una aerolínea opera muchas aeronaves |
| flight → flight_segment | 1:N | Un vuelo tiene uno o más segmentos (escalas) |
| ticket → ticket_segment | 1:N | Un tiquete cubre uno o más segmentos |
| ticket_segment → seat_assignment | 1:1 | Un segmento tiene un solo asiento asignado |
| ticket_segment → check_in | 1:1 | Un segmento tiene un solo check-in |
| check_in → boarding_pass | 1:1 | Un check-in genera un solo pase de abordar |
| sale → payment | 1:N | Una venta puede tener varios pagos |
| payment → refund | 1:N | Un pago puede generar varios reembolsos |
| invoice → invoice_line | 1:N | Una factura tiene varias líneas |

---

## 4. ENTIDADES DÉBILES Y TABLAS PUENTE

| Tabla | Tipo | Justificación |
|---|---|---|
| ticket_segment | Tabla puente | Relaciona ticket ↔ flight_segment (itinerarios con escalas) |
| user_role | Tabla puente | Relaciona user_account ↔ security_role (N:M) |
| role_permission | Tabla puente | Relaciona security_role ↔ security_permission (N:M) |
| tier_benefit | Tabla puente | Relaciona loyalty_tier ↔ benefit_type (N:M) |
| loyalty_account_tier | Historial | Historial de niveles asignados a una cuenta loyalty |
| seat_assignment | Entidad débil | Depende de ticket_segment + flight_segment |