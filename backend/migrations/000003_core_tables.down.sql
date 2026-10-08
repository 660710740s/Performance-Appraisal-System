DROP TABLE IF EXISTS bonuses;
DROP TABLE IF EXISTS salary_records;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS evaluation_scores;
DROP TABLE IF EXISTS evaluations;
DROP TABLE IF EXISTS criteria;
DROP TABLE IF EXISTS evaluation_cycles;

DROP INDEX IF EXISTS idx_users_manager_id;
ALTER TABLE users DROP COLUMN IF EXISTS level;
ALTER TABLE users DROP COLUMN IF EXISTS position;
ALTER TABLE users DROP COLUMN IF EXISTS department;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_name = 'users' AND column_name = 'name')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns
                       WHERE table_name = 'users' AND column_name = 'full_name') THEN
        ALTER TABLE users RENAME COLUMN name TO full_name;
    END IF;
END $$;