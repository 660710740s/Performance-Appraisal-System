ALTER INDEX IF EXISTS idx_bonus_employee_id   RENAME TO idx_bonuses_employee_id;
ALTER INDEX IF EXISTS idx_bonus_cycle_id      RENAME TO idx_bonuses_cycle_id;
ALTER INDEX IF EXISTS idx_bonus_evaluation_id RENAME TO idx_bonuses_evaluation_id;
ALTER TABLE IF EXISTS bonus RENAME TO bonuses;