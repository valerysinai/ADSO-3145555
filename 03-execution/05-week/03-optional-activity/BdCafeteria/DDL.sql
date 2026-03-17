--DDL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE type_document (
    id          UUID         DEFAULT uuid_generate_v4() PRIMARY KEY,
    code        VARCHAR(10)  NOT NULL UNIQUE,
    name        VARCHAR(60)  NOT NULL,
    description TEXT,
    created_at  TIMESTAMPTZ  DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT     DEFAULT 1
);

CREATE TABLE person (
    id               UUID         DEFAULT uuid_generate_v4() PRIMARY KEY,
    type_document_id UUID         NOT NULL REFERENCES type_document(id),
    document_number  VARCHAR(20)  NOT NULL UNIQUE,
    first_name       VARCHAR(80)  NOT NULL,
    last_name        VARCHAR(80)  NOT NULL,
    email            VARCHAR(120) NOT NULL UNIQUE,
    phone            VARCHAR(20),
    birth_date       DATE,
    created_at       TIMESTAMPTZ  DEFAULT NOW(),
    updated_at       TIMESTAMPTZ,
    deleted_at       TIMESTAMPTZ,
    created_by       UUID,
    updated_by       UUID,
    deleted_by       UUID,
    status           SMALLINT     DEFAULT 1
);

CREATE TABLE file (
    id          UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    person_id   UUID          NOT NULL REFERENCES person(id),
    file_name   VARCHAR(200)  NOT NULL,
    file_path   TEXT          NOT NULL,
    file_type   VARCHAR(50),
    file_size   BIGINT,
    created_at  TIMESTAMPTZ   DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT      DEFAULT 1
);

-- -----------------------------------------------------
-- MÓDULO 1: SEGURIDAD
-- -----------------------------------------------------

CREATE TABLE role (
    id          UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    name        VARCHAR(60) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT    DEFAULT 1
);

CREATE TABLE module (
    id          UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    name        VARCHAR(80) NOT NULL UNIQUE,
    icon        VARCHAR(50),
    order_index SMALLINT,
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT    DEFAULT 1
);

CREATE TABLE view (
    id          UUID         DEFAULT uuid_generate_v4() PRIMARY KEY,
    module_id   UUID         NOT NULL REFERENCES module(id),
    name        VARCHAR(80)  NOT NULL,
    route       VARCHAR(120),
    order_index SMALLINT,
    created_at  TIMESTAMPTZ  DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT     DEFAULT 1
);

CREATE TABLE "user" (
    id            UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    person_id     UUID        NOT NULL REFERENCES person(id),
    username      VARCHAR(60) NOT NULL UNIQUE,
    password_hash TEXT        NOT NULL,
    last_login    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ DEFAULT NOW(),
    updated_at    TIMESTAMPTZ,
    deleted_at    TIMESTAMPTZ,
    created_by    UUID,
    updated_by    UUID,
    deleted_by    UUID,
    status        SMALLINT    DEFAULT 1
);

CREATE TABLE user_role (
    id          UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id     UUID        NOT NULL REFERENCES "user"(id),
    role_id     UUID        NOT NULL REFERENCES role(id),
    assigned_at TIMESTAMPTZ DEFAULT NOW(),
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT    DEFAULT 1
);

CREATE TABLE role_module (
    id        UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    role_id   UUID        NOT NULL REFERENCES role(id),
    module_id UUID        NOT NULL REFERENCES module(id),
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT    DEFAULT 1
);

CREATE TABLE module_view (
    id         UUID    DEFAULT uuid_generate_v4() PRIMARY KEY,
    module_id  UUID    NOT NULL REFERENCES module(id),
    view_id    UUID    NOT NULL REFERENCES view(id),
    can_read   BOOLEAN DEFAULT FALSE,
    can_write  BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT    DEFAULT 1
);

-- -----------------------------------------------------
-- MÓDULO 3: INVENTARIO
-- -----------------------------------------------------

CREATE TABLE category (
    id          UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    name        VARCHAR(80) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT    DEFAULT 1
);

CREATE TABLE supplier (
    id           UUID         DEFAULT uuid_generate_v4() PRIMARY KEY,
    person_id    UUID         NOT NULL REFERENCES person(id),
    company_name VARCHAR(120) NOT NULL,
    address      TEXT,
    tax_id       VARCHAR(30)  UNIQUE,
    created_at   TIMESTAMPTZ  DEFAULT NOW(),
    updated_at   TIMESTAMPTZ,
    deleted_at   TIMESTAMPTZ,
    created_by   UUID,
    updated_by   UUID,
    deleted_by   UUID,
    status       SMALLINT     DEFAULT 1
);

CREATE TABLE product (
    id          UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    category_id UUID          NOT NULL REFERENCES category(id),
    supplier_id UUID          NOT NULL REFERENCES supplier(id),
    sku         VARCHAR(40)   NOT NULL UNIQUE,
    name        VARCHAR(120)  NOT NULL,
    description TEXT,
    unit_price  NUMERIC(10,2) NOT NULL,
    cost_price  NUMERIC(10,2),
    image_url   TEXT,
    created_at  TIMESTAMPTZ   DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT      DEFAULT 1
);

CREATE TABLE inventory (
    id           UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    product_id   UUID          NOT NULL UNIQUE REFERENCES product(id),
    quantity     NUMERIC(10,3) DEFAULT 0,
    min_stock    NUMERIC(10,3),
    location     VARCHAR(80),
    last_restock TIMESTAMPTZ,
    created_at   TIMESTAMPTZ   DEFAULT NOW(),
    updated_at   TIMESTAMPTZ,
    deleted_at   TIMESTAMPTZ,
    created_by   UUID,
    updated_by   UUID,
    deleted_by   UUID,
    status       SMALLINT      DEFAULT 1
);

-- MÓDULO 4: VENTAS

CREATE TABLE customer (
    id             UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    person_id      UUID        NOT NULL REFERENCES person(id),
    loyalty_points INTEGER     DEFAULT 0,
    notes          TEXT,
    created_at     TIMESTAMPTZ DEFAULT NOW(),
    updated_at     TIMESTAMPTZ,
    deleted_at     TIMESTAMPTZ,
    created_by     UUID,
    updated_by     UUID,
    deleted_by     UUID,
    status         SMALLINT    DEFAULT 1
);

CREATE TABLE method_payment (
    id                 UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    name               VARCHAR(60) NOT NULL UNIQUE,
    description        TEXT,
    requires_reference BOOLEAN     DEFAULT FALSE,
    created_at         TIMESTAMPTZ DEFAULT NOW(),
    updated_at         TIMESTAMPTZ,
    deleted_at         TIMESTAMPTZ,
    created_by         UUID,
    updated_by         UUID,
    deleted_by         UUID,
    status             SMALLINT    DEFAULT 1
);

CREATE TABLE "order" (
    id           UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    customer_id  UUID          NOT NULL REFERENCES customer(id),
    user_id      UUID          NOT NULL REFERENCES "user"(id),
    order_date   TIMESTAMPTZ   DEFAULT NOW(),
    total_amount NUMERIC(12,2) NOT NULL,
    order_type   VARCHAR(20),
    notes        TEXT,
    created_at   TIMESTAMPTZ   DEFAULT NOW(),
    updated_at   TIMESTAMPTZ,
    deleted_at   TIMESTAMPTZ,
    created_by   UUID,
    updated_by   UUID,
    deleted_by   UUID,
    status       SMALLINT      DEFAULT 1
);

CREATE TABLE order_item (
    id         UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_id   UUID          NOT NULL REFERENCES "order"(id),
    product_id UUID          NOT NULL REFERENCES product(id),
    quantity   NUMERIC(8,3)  NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    subtotal   NUMERIC(12,2) NOT NULL,
    notes      TEXT,
    created_at  TIMESTAMPTZ  DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT     DEFAULT 1
);

-- -----------------------------------------------------
-- MÓDULO 5: FACTURACIÓN
-- -----------------------------------------------------

CREATE TABLE invoice (
    id             UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_id       UUID          NOT NULL REFERENCES "order"(id),
    customer_id    UUID          NOT NULL REFERENCES customer(id),
    invoice_number VARCHAR(30)   NOT NULL UNIQUE,
    issue_date     TIMESTAMPTZ   DEFAULT NOW(),
    subtotal       NUMERIC(12,2) NOT NULL,
    tax_amount     NUMERIC(12,2) NOT NULL,
    total_amount   NUMERIC(12,2) NOT NULL,
    due_date       DATE,
    created_at     TIMESTAMPTZ   DEFAULT NOW(),
    updated_at     TIMESTAMPTZ,
    deleted_at     TIMESTAMPTZ,
    created_by     UUID,
    updated_by     UUID,
    deleted_by     UUID,
    status         SMALLINT      DEFAULT 1
);

CREATE TABLE invoice_item (
    id         UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    invoice_id UUID          NOT NULL REFERENCES invoice(id),
    product_id UUID          NOT NULL REFERENCES product(id),
    quantity   NUMERIC(8,3)  NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    tax_rate   NUMERIC(5,2)  DEFAULT 0,
    subtotal   NUMERIC(12,2) NOT NULL,
    created_at  TIMESTAMPTZ  DEFAULT NOW(),
    updated_at  TIMESTAMPTZ,
    deleted_at  TIMESTAMPTZ,
    created_by  UUID,
    updated_by  UUID,
    deleted_by  UUID,
    status      SMALLINT     DEFAULT 1
);

CREATE TABLE payment (
    id                UUID          DEFAULT uuid_generate_v4() PRIMARY KEY,
    invoice_id        UUID          NOT NULL REFERENCES invoice(id),
    method_payment_id UUID          NOT NULL REFERENCES method_payment(id),
    amount            NUMERIC(12,2) NOT NULL,
    payment_date      TIMESTAMPTZ   DEFAULT NOW(),
    reference         VARCHAR(80),
    notes             TEXT,
    created_at        TIMESTAMPTZ   DEFAULT NOW(),
    updated_at        TIMESTAMPTZ,
    deleted_at        TIMESTAMPTZ,
    created_by        UUID,
    updated_by        UUID,
    deleted_by        UUID,
    status            SMALLINT      DEFAULT 1
);