-- เติมใบประเมิน เงินเดือน โบนัส (ข้อมูลจำลอง) รันซ้ำได้
DO $$
DECLARE
  hr_id bigint; acc_id bigint; c_old bigint; c_new bigint;
BEGIN
  SELECT id INTO hr_id  FROM users WHERE email = 'hr@example.com';
  SELECT id INTO acc_id FROM users WHERE email = 'accounting@example.com';
  SELECT id INTO c_old  FROM evaluation_cycles WHERE name = 'ครึ่งปีแรก 2026';
  SELECT id INTO c_new  FROM evaluation_cycles WHERE name = 'ครึ่งปีหลัง 2026';
  IF hr_id IS NULL OR acc_id IS NULL OR c_old IS NULL OR c_new IS NULL THEN
    RAISE EXCEPTION 'ไม่พบ hr/accounting หรือรอบประเมิน: รัน cmd/seed ก่อน';
  END IF;

  -- เงินเดือน
  INSERT INTO salary_records (employee_id, amount, effective_date, created_by, created_at)
  SELECT u.id, 20000 + ((u.id * 7919) % 60) * 1000, '2026-01-01', acc_id, now()
  FROM users u
  WHERE u.role = 'employee'
    AND NOT EXISTS (SELECT 1 FROM salary_records s WHERE s.employee_id = u.id);

  -- รอบก่อน: อนุมัติแล้ว (ฐานของโบนัส)
  INSERT INTO evaluations (cycle_id, employee_id, type, evaluator_id, status, total_score,
                           approved_by, submitted_at, approved_at, created_at, updated_at)
  SELECT c_old, u.id, 'supervisor', u.manager_id, 'approved', 50 + ((u.id * 37) % 51),
         hr_id, now() - interval '30 days', now() - interval '25 days', now(), now()
  FROM users u
  WHERE u.role = 'employee' AND u.manager_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM evaluations e
                    WHERE e.cycle_id = c_old AND e.employee_id = u.id AND e.type = 'supervisor');

  -- รอบปัจจุบัน: ส่งแล้ว รอ HR อนุมัติ
  INSERT INTO evaluations (cycle_id, employee_id, type, evaluator_id, status, total_score,
                           submitted_at, created_at, updated_at)
  SELECT c_new, u.id, 'supervisor', u.manager_id, 'submitted', 50 + ((u.id * 53) % 51),
         now() - interval '1 day', now(), now()
  FROM users u
  WHERE u.role = 'employee' AND u.manager_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM evaluations e
                    WHERE e.cycle_id = c_new AND e.employee_id = u.id AND e.type = 'supervisor');

  -- โบนัสรอผู้บริหารอนุมัติ (จากใบที่อนุมัติแล้ว)
  INSERT INTO bonus (evaluation_id, cycle_id, employee_id, base_salary, total_score,
                     suggested_amount, amount, status, created_by, created_at, updated_at)
  SELECT e.id, e.cycle_id, e.employee_id, s.amount, e.total_score,
         round(s.amount * e.total_score / 100), round(s.amount * e.total_score / 100),
         'pending_approval', hr_id, now(), now()
  FROM evaluations e
  JOIN salary_records s ON s.employee_id = e.employee_id
  WHERE e.cycle_id = c_old AND e.status = 'approved'
    AND NOT EXISTS (SELECT 1 FROM bonus b WHERE b.evaluation_id = e.id);
END $$;

SELECT 'evaluations' AS t, status, count(*) FROM evaluations GROUP BY status
UNION ALL SELECT 'bonus', status, count(*) FROM bonus GROUP BY status
UNION ALL SELECT 'salary_records', '-', count(*) FROM salary_records;
