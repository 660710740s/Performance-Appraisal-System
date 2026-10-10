CREATE TABLE IF NOT EXISTS departments (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS levels (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(50) NOT NULL UNIQUE,
    sort_order INT NOT NULL DEFAULT 0
);

-- ดึงค่าที่มีอยู่แล้วเข้ารายการหลัก
INSERT INTO departments (name)
SELECT DISTINCT TRIM(department) FROM users
WHERE department IS NOT NULL AND TRIM(department) <> ''
ON CONFLICT (name) DO NOTHING;

INSERT INTO departments (name)
SELECT DISTINCT TRIM(department) FROM criteria
WHERE department IS NOT NULL AND TRIM(department) <> ''
ON CONFLICT (name) DO NOTHING;

-- ระดับมาตรฐาน (เรียงตาม sort_order)
INSERT INTO levels (name, sort_order) VALUES
    ('junior', 1),
    ('senior', 2),
    ('lead', 3),
    ('manager', 4)
ON CONFLICT (name) DO UPDATE SET sort_order = EXCLUDED.sort_order;
