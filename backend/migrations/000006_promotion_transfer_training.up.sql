-- เลื่อนตำแหน่ง (บันทึกการตัดสินใจ ไม่อัปเดตข้อมูลพนักงานอัตโนมัติ)
CREATE TABLE IF NOT EXISTS promotion_requests (
    id            BIGSERIAL PRIMARY KEY,
    evaluation_id BIGINT      NOT NULL REFERENCES evaluations(id),
    cycle_id      BIGINT      NOT NULL REFERENCES evaluation_cycles(id),
    employee_id   BIGINT      NOT NULL REFERENCES users(id),
    from_position VARCHAR(100),
    to_position   VARCHAR(100) NOT NULL,
    from_level    VARCHAR(50),
    to_level      VARCHAR(50),
    status        VARCHAR(20) NOT NULL DEFAULT 'pending_approval'
                  CHECK (status IN ('pending_approval', 'approved', 'rejected')),
    note          TEXT,
    decision_note TEXT,
    created_by    BIGINT      NOT NULL REFERENCES users(id),
    decided_by    BIGINT      REFERENCES users(id),
    decided_at    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_promotion_evaluation
    ON promotion_requests (evaluation_id);
CREATE INDEX IF NOT EXISTS idx_promotion_requests_cycle_id
    ON promotion_requests (cycle_id);
CREATE INDEX IF NOT EXISTS idx_promotion_requests_employee_id
    ON promotion_requests (employee_id);

-- โอนย้ายแผนก
CREATE TABLE IF NOT EXISTS transfer_requests (
    id              BIGSERIAL PRIMARY KEY,
    evaluation_id   BIGINT      NOT NULL REFERENCES evaluations(id),
    cycle_id        BIGINT      NOT NULL REFERENCES evaluation_cycles(id),
    employee_id     BIGINT      NOT NULL REFERENCES users(id),
    from_department VARCHAR(100),
    to_department   VARCHAR(100) NOT NULL,
    effective_date  TIMESTAMPTZ,
    status          VARCHAR(20) NOT NULL DEFAULT 'pending_approval'
                    CHECK (status IN ('pending_approval', 'approved', 'rejected')),
    note            TEXT,
    decision_note   TEXT,
    created_by      BIGINT      NOT NULL REFERENCES users(id),
    decided_by      BIGINT      REFERENCES users(id),
    decided_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_transfer_evaluation
    ON transfer_requests (evaluation_id);
CREATE INDEX IF NOT EXISTS idx_transfer_requests_cycle_id
    ON transfer_requests (cycle_id);
CREATE INDEX IF NOT EXISTS idx_transfer_requests_employee_id
    ON transfer_requests (employee_id);

-- แผนฝึกอบรม
CREATE TABLE IF NOT EXISTS training_plans (
    id            BIGSERIAL PRIMARY KEY,
    evaluation_id BIGINT      NOT NULL REFERENCES evaluations(id),
    employee_id   BIGINT      NOT NULL REFERENCES users(id),
    topic         VARCHAR(255) NOT NULL,
    reason        TEXT,
    start_date    TIMESTAMPTZ,
    end_date      TIMESTAMPTZ,
    status        VARCHAR(20) NOT NULL DEFAULT 'planned'
                  CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled')),
    created_by    BIGINT      NOT NULL REFERENCES users(id),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_training_plans_employee_id
    ON training_plans (employee_id);
CREATE INDEX IF NOT EXISTS idx_training_plans_evaluation_id
    ON training_plans (evaluation_id);
