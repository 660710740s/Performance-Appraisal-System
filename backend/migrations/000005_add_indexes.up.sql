CREATE INDEX IF NOT EXISTS idx_evaluations_employee_status
    ON evaluations (employee_id, status);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity
    ON audit_logs (entity, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at
    ON audit_logs (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_bonus_status
    ON bonus (status);
