-- GORM ใช้ชื่อตารางเอกพจน์ "bonus" สำหรับ struct Bonus
ALTER TABLE IF EXISTS bonuses RENAME TO bonus;
ALTER INDEX IF EXISTS idx_bonuses_evaluation_id RENAME TO idx_bonus_evaluation_id;
ALTER INDEX IF EXISTS idx_bonuses_cycle_id      RENAME TO idx_bonus_cycle_id;
ALTER INDEX IF EXISTS idx_bonuses_employee_id   RENAME TO idx_bonus_employee_id;