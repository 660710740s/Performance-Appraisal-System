CREATE TABLE users (
    id            BIGSERIAL PRIMARY KEY,
    employee_code VARCHAR(20)  NOT NULL UNIQUE,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL DEFAULT 'employee'
                  CHECK (role IN ('admin', 'hr', 'manager', 'employee')),
    manager_id    BIGINT REFERENCES users(id),
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);