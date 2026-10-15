
-- ข้อมูลเงินเดือนสมมุติสำหรับทดสอบ KPI/Bonus
-- เพิ่มเฉพาะพนักงานที่ยังไม่มีประวัติเงินเดือน
-- ใช้บัญชี Accounting ที่มีอยู่เป็นผู้บันทึก

WITH accounting_user AS (
    SELECT id
    FROM users
    WHERE role = 'accounting'
    ORDER BY id
    LIMIT 1
),
missing_salaries AS (
    SELECT
        u.id AS employee_id,
        (25000 + ((ROW_NUMBER() OVER (ORDER BY u.id) - 1) % 6) * 3000)::numeric AS amount
    FROM users u
    WHERE u.is_active = TRUE
      AND u.role = 'employee'
      AND NOT EXISTS (
          SELECT 1
          FROM salary_records s
          WHERE s.employee_id = u.id
      )
)
INSERT INTO salary_records (
    employee_id,
    amount,
    effective_date,
    created_by,
    created_at
)
SELECT
    m.employee_id,
    m.amount,
    TIMESTAMPTZ '2026-01-01 00:00:00+00',
    a.id,
    NOW()
FROM missing_salaries m
CROSS JOIN accounting_user a
ON CONFLICT (employee_id, effective_date) DO NOTHING;

SELECT
    u.employee_code,
    u.name,
    s.amount,
    s.effective_date
FROM users u
JOIN salary_records s ON s.employee_id = u.id
WHERE u.role = 'employee'
ORDER BY u.id, s.effective_date DESC;
