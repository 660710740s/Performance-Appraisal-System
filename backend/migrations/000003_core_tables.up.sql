-- ===== 1) ปรับตาราง users ให้ตรงกับ struct User =====
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_name = 'users' AND column_name = 'full_name')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns
                       WHERE table_name = 'users' AND column_name = 'name') THEN
        ALTER TABLE users RENAME COLUMN full_name TO name;
    END IF;
END $$;

ALTER TABLE users ALTER COLUMN employee_code TYPE VARCHAR(50);
ALTER TABLE users ALTER COLUMN name          TYPE VARCHAR(255);
ALTER TABLE users ALTER COLUMN email         TYPE VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS department VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS position   VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS level      VARCHAR(50);
CREATE INDEX IF NOT EXISTS idx_users_manager_id ON users (manager_id);

-- ===== 2) รอบการประเมิน =====
CREATE TABLE IF NOT EXISTS evaluation_cycles (
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    start_date TIMESTAMPTZ,
    end_date   TIMESTAMPTZ,
    status     VARCHAR(20)  NOT NULL DEFAULT 'open'
               CHECK (status IN ('open', 'closed')),
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ===== 3) เกณฑ์การประเมิน =====
CREATE TABLE IF NOT EXISTS criteria (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255)     NOT NULL,
    description TEXT,
    weight      DOUBLE PRECISION NOT NULL DEFAULT 1 CHECK (weight > 0),
    is_active   BOOLEAN          NOT NULL DEFAULT TRUE,
    rubric      TEXT,
    department  VARCHAR(100),
    level       VARCHAR(50)
);
CREATE INDEX IF NOT EXISTS idx_criteria_department ON criteria (department);

-- ===== 4) แบบประเมิน =====
CREATE TABLE IF NOT EXISTS evaluations (
    id                BIGSERIAL PRIMARY KEY,
    cycle_id          BIGINT NOT NULL REFERENCES evaluation_cycles(id),
    employee_id       BIGINT NOT NULL REFERENCES users(id),
    type              VARCHAR(20) NOT NULL DEFAULT 'supervisor'
                      CHECK (type IN ('self', 'supervisor')),
    evaluator_id      BIGINT NOT NULL REFERENCES users(id),
    status            VARCHAR(20) NOT NULL DEFAULT 'draft'
                      CHECK (status IN ('draft', 'submitted', 'approved', 'rejected')),
    total_score       DOUBLE PRECISION NOT NULL DEFAULT 0,
    comment           TEXT,
    employee_feedback TEXT,
    approved_by       BIGINT REFERENCES users(id),
    submitted_at      TIMESTAMPTZ,
    approved_at       TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- กันประเมินซ้ำที่ระดับฐานข้อมูล (ตรงกับ uniqueIndex ใน struct)
CREATE UNIQUE INDEX IF NOT EXISTS idx_cycle_employee_type
    ON evaluations (cycle_id, employee_id, type);
CREATE INDEX IF NOT EXISTS idx_evaluations_evaluator_id ON evaluations (evaluator_id);

CREATE TABLE IF NOT EXISTS evaluation_scores (
    id            BIGSERIAL PRIMARY KEY,
    evaluation_id BIGINT  NOT NULL REFERENCES evaluations(id) ON DELETE CASCADE,
    criteria_id   BIGINT  NOT NULL REFERENCES criteria(id),
    score         INTEGER NOT NULL CHECK (score BETWEEN 1 AND 5),
    comment       TEXT
);
CREATE INDEX IF NOT EXISTS idx_evaluation_scores_evaluation_id ON evaluation_scores (evaluation_id);

-- ===== 5) Audit log =====
CREATE TABLE IF NOT EXISTS audit_logs (
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT      NOT NULL REFERENCES users(id),
    action     VARCHAR(50) NOT NULL,
    entity     VARCHAR(50) NOT NULL,
    entity_id  BIGINT,
    detail     TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id   ON audit_logs (user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity_id ON audit_logs (entity_id);

-- ===== 6) เงินเดือนและโบนัส =====
CREATE TABLE IF NOT EXISTS salary_records (
    id             BIGSERIAL PRIMARY KEY,
    employee_id    BIGINT           NOT NULL REFERENCES users(id),
    amount         DOUBLE PRECISION NOT NULL,
    effective_date TIMESTAMPTZ      NOT NULL,
    created_by     BIGINT           NOT NULL REFERENCES users(id),
    created_at     TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_salary_emp_date
    ON salary_records (employee_id, effective_date);

CREATE TABLE IF NOT EXISTS bonuses (
    id               BIGSERIAL PRIMARY KEY,
    evaluation_id    BIGINT NOT NULL REFERENCES evaluations(id),
    cycle_id         BIGINT NOT NULL REFERENCES evaluation_cycles(id),
    employee_id      BIGINT NOT NULL REFERENCES users(id),
    base_salary      DOUBLE PRECISION,
    total_score      DOUBLE PRECISION,
    suggested_amount DOUBLE PRECISION,
    amount           DOUBLE PRECISION,
    status           VARCHAR(20) NOT NULL DEFAULT 'pending_approval'
                     CHECK (status IN ('pending_approval', 'approved', 'rejected')),
    note             TEXT,
    decision_note    TEXT,
    created_by       BIGINT NOT NULL REFERENCES users(id),
    decided_by       BIGINT REFERENCES users(id),
    decided_at       TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_bonuses_evaluation_id ON bonuses (evaluation_id);
CREATE INDEX IF NOT EXISTS idx_bonuses_cycle_id    ON bonuses (cycle_id);
CREATE INDEX IF NOT EXISTS idx_bonuses_employee_id ON bonuses (employee_id);