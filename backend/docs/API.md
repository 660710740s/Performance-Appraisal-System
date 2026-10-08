# API (prefix /api/v1)

## รูปแบบทั่วไป

- ส่งและรับเป็น JSON, วันที่เป็นรูปแบบ RFC 3339 เช่น `2026-01-01T00:00:00Z`
- ทุก endpoint ยกเว้น login ต้องส่ง header `Authorization: Bearer <token>`
- สำเร็จ: `{"data": ...}` (สถานะ 200, หรือ 201 เมื่อสร้างใหม่)
- ผิดพลาด: `{"error": "ข้อความ"}`

| สถานะ | ความหมาย |
|---|---|
| 400 | ข้อมูลที่ส่งมาไม่ถูกต้อง (ข้อความอาจเป็นข้อความดิบของ validator) |
| 401 | ไม่ได้ล็อกอินหรือ token ไม่ถูกต้อง |
| 403 | ไม่มีสิทธิ์ |
| 404 | ไม่พบข้อมูล |
| 409 | ขัดแย้ง เช่น สร้างซ้ำ หรือสถานะไม่เปิดให้ทำรายการนี้ |
| 500 | ข้อผิดพลาดภายในระบบ |

บทบาท (role): `hr`, `manager`, `employee`, `accounting`, `executive` (มี `admin` ใน DB แต่ route ปัจจุบันไม่ได้ใช้)

## Auth

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| POST | /auth/login | public | body `{"email","password"}` ได้ `data.token` |
| GET | /me | ทุกคน | ข้อมูลผู้ใช้ปัจจุบัน (รูปแบบเดียวกับตัวอย่างผู้ใช้ในหัวข้อผู้ใช้) |

## ผู้ใช้

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| POST | /users | hr | สร้างพนักงาน (สถานะ 201) |
| GET | /users | hr | รายชื่อพนักงานทั้งหมด |
| PUT | /users/:id | hr | แก้ไขข้อมูล (ไม่แก้รหัสผ่าน) |
| PATCH | /users/:id/deactivate | hr | ปิดใช้งาน |
| PATCH | /users/:id/activate | hr | เปิดใช้งาน |
| GET | /team | manager, hr | ลูกทีมของฉัน |

**POST /users** body

```json
{
  "employee_code": "E001",
  "name": "ชื่อ นามสกุล",
  "email": "someone@example.com",
  "password": "อย่างน้อย 8 ตัวอักษร",
  "role": "employee",
  "department": "พัฒนาซอฟต์แวร์",
  "position": "",
  "level": "junior",
  "manager_id": 4
}
```

- จำเป็น: `employee_code`, `name`, `email` (รูปแบบอีเมล), `password` (อย่างน้อย 8 ตัว), `role`
- `role` เป็นหนึ่งใน `hr`, `manager`, `employee`, `accounting`, `executive`
- ไม่จำเป็น: `department`, `position`, `level`, `manager_id` (ส่ง `null` หรือไม่ส่ง = ไม่มีหัวหน้า)

**PUT /users/:id** body เหมือนด้านบนแต่ไม่มี `password` และ `employee_code`, `name`, `email`, `role` จำเป็นต้องส่งทุกครั้ง

**ตัวอย่าง response ของผู้ใช้** (ใช้กับ `/me`, `/users`, `/team` และคำตอบของ POST/PUT/PATCH)

```json
{
  "id": 1, "employee_code": "HR001", "name": "...", "email": "hr@example.com",
  "role": "hr", "department": "...", "position": "...", "manager_id": null,
  "is_active": true, "created_at": "...", "updated_at": "...", "level": ""
}
```

ระบบไม่ส่งรหัสผ่านหรือ hash ออกมาในทุก endpoint

## รอบการประเมิน

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| GET | /cycles | ทุกคน | รายการรอบ (ใหม่ไปเก่าตามวันเริ่ม) |
| POST | /cycles | hr | body `{"name","start_date","end_date"}` สถานะเริ่มต้น `open` |
| PUT | /cycles/:id | hr | body `{"name","start_date","end_date","status"?}` `status` เป็น `open` หรือ `closed` |

กติกา: แก้ได้เฉพาะรอบที่ยัง `open` (รอบที่ปิดแล้วได้ 409) และวันสิ้นสุดต้องหลังวันเริ่ม

## เกณฑ์การประเมิน

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| GET | /criteria | ทุกคน | `?employee_id=` ไม่ส่ง: hr เห็นทุกเกณฑ์ที่เปิดใช้งาน, คนอื่นเห็นเกณฑ์ของตัวเอง |
| POST | /criteria | hr, manager | body `{"name","description"?,"weight","rubric"?,"department"?,"level"?}` manager สร้างได้เฉพาะเกณฑ์ของแผนกตัวเอง |
| PUT | /criteria/:id | hr | body `{"name","description"?,"weight","is_active","rubric"?,"department"?,"level"?}` |

กติกา: `weight` ต้องมากกว่า 0 ถ้าแก้ weight, is_active, department หรือ level ได้เฉพาะเมื่อยังไม่มีแบบประเมินในระบบเลย (ไม่งั้น 409) เกณฑ์ที่ใช้กับพนักงานเลือกจากแผนกและระดับของพนักงานคนนั้น (ค่าว่าง = ใช้กับทุกคน)

## แบบประเมิน

สถานะ: `draft` → `submitted` → `approved` และ `rejected` (ถูกตีกลับ แก้แล้วส่งใหม่ได้)
ประเภท: `self` (ประเมินตนเอง) และ `supervisor` (หัวหน้าประเมิน)

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| POST | /evaluations | ทุกคน (ตรวจสิทธิ์ใน service) | สร้างแบบประเมิน (draft) |
| PUT | /evaluations/:id | ผู้ประเมินเจ้าของ | แก้ไข draft หรือแบบที่ถูกตีกลับ |
| POST | /evaluations/:id/submit | ผู้ประเมินเจ้าของ หรือ hr | ส่งผลประเมิน |
| POST | /evaluations/:id/approve | manager, hr | อนุมัติ |
| POST | /evaluations/:id/reject | manager, hr | ตีกลับ body `{"reason"}` (จำเป็น) |
| POST | /evaluations/:id/feedback | พนักงานเจ้าของผล | body `{"feedback"}` |
| GET | /evaluations/me | ทุกคน | ผลของฉัน เฉพาะ `submitted` และ `approved` |
| GET | /evaluations/given | ทุกคน | ที่ฉันเป็นผู้ประเมิน ทุกสถานะ (รวม self-evaluation ของตัวเอง) |
| GET | /evaluations/:id | ตามสิทธิ์ | รายละเอียด |

**POST /evaluations** body

```json
{
  "cycle_id": 3,
  "employee_id": 7,
  "type": "supervisor",
  "comment": "",
  "scores": [{"criteria_id": 1, "score": 4, "comment": ""}]
}
```

- `type` ไม่ส่ง = `supervisor`
- `scores` ต้องครบทุกเกณฑ์ของพนักงานคนนั้น ไม่ซ้ำ และ `score` เป็นจำนวนเต็ม 1 ถึง 5
- `total_score` ระบบคำนวณให้ตามน้ำหนัก
- ประเมินได้เฉพาะรอบที่ `open` (ไม่งั้น 400)
- สร้างซ้ำ (รอบ + พนักงาน + ประเภทเดียวกัน) ได้ 409

**ใครทำอะไรได้**
- `self`: ต้องประเมินตัวเองเท่านั้น (`employee_id` = ตัวเอง)
- `supervisor`: เฉพาะ manager และ hr, ห้ามประเมินตัวเอง, manager ประเมินได้เฉพาะลูกทีมโดยตรง
- อนุมัติและตีกลับ: manager (เฉพาะลูกทีมโดยตรง) และ hr, ห้ามตรวจแบบที่ตัวเองเป็นผู้ประเมินหรือเป็นเจ้าของ, ทำได้เฉพาะสถานะ `submitted`
- feedback: เฉพาะแบบ `supervisor` ที่เป็น `submitted` หรือ `approved`
- แก้ไขและส่ง: ได้เฉพาะ `draft` และ `rejected` และรอบต้องยัง `open`
- ดูรายละเอียด: hr ดูได้ทั้งหมด, ผู้ประเมินและเจ้าของดูได้ตามสิทธิ์, พนักงานเห็นผลตัวเองเมื่อ `submitted` ขึ้นไป (self-evaluation ของตัวเองเห็นได้ทุกสถานะ), manager เห็นของลูกทีมเมื่อ `submitted` ขึ้นไป

**ตัวอย่าง response (เฉพาะ field หลัก)**

```json
{
  "id": 1, "cycle_id": 3, "employee_id": 7, "type": "supervisor",
  "evaluator_id": 4, "status": "approved", "total_score": 5,
  "comment": "", "employee_feedback": "",
  "approved_by": 1, "submitted_at": "...", "approved_at": "...",
  "scores": [{"id": 6, "evaluation_id": 1, "criteria_id": 1, "score": 5, "comment": ""}]
}
```

## รายงาน (hr, executive)

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| GET | /reports/summary | hr, executive | สรุปคะแนนเฉลี่ยแผนก ความคืบหน้าแต่ละรอบ และยอดโบนัสตามสถานะ `?cycle_id=` ไม่ส่ง = ทุกรอบ |
| GET | /executive/summary | executive | ข้อมูลเดียวกับ /reports/summary |
| GET | /reports/evaluations | hr | รายการแบบประเมินทั้งหมดพร้อมชื่อ `?cycle_id=&status=&type=&department=&limit=&offset=` |
| GET | /reports/annual | hr, executive | `?year=2026` (ไม่ส่ง = ปีปัจจุบัน) คะแนนเฉลี่ยแยกแผนก รายรอบและรวมทั้งปี |
| GET | /audit-logs | hr | `?entity=&entity_id=&user_id=&limit=&offset=` ใหม่ไปเก่า |

หมายเหตุ
- `limit` เริ่มต้น 100 สูงสุด 500, `offset` เริ่มต้น 0
- `status` ที่ใช้กรอง: `draft`, `submitted`, `approved`, `rejected` และ `type`: `self`, `supervisor` ค่าอื่นได้ 400
- รายงานประจำปีนับเฉพาะแบบ `supervisor` ที่ `approved` และนับรอบที่วันเริ่มอยู่ในปีนั้น รอบที่ไม่มีแบบอนุมัติจะอยู่ในผลโดย `departments` เป็นอาเรย์ว่าง
- audit log ส่งแค่ `user_id` ไม่มีชื่อผู้ใช้
- `year` ต้องอยู่ระหว่าง 2000 ถึง 2100

ตัวอย่าง `/reports/evaluations` (หนึ่งแถว)

```json
{"id":1,"cycle_id":3,"cycle_name":"...","employee_id":7,"employee_name":"...",
 "department":"...","level":"junior","type":"supervisor","evaluator_id":4,
 "evaluator_name":"...","status":"approved","total_score":5,
 "submitted_at":"...","approved_at":"..."}
```

## การเงินและโบนัส

ทุก endpoint ในกลุ่ม `/accounting` ใช้ได้เฉพาะ role `accounting` ส่วน `/executive/bonuses` ใช้ได้เฉพาะ `executive`
สถานะโบนัส: `pending_approval`, `approved`, `rejected`

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| GET | /accounting/salaries | accounting | เงินเดือนปัจจุบันของพนักงานแต่ละคน |
| GET | /accounting/salaries/:employee_id/history | accounting | ประวัติเงินเดือนของพนักงานคนนั้น |
| POST | /accounting/salaries | accounting | body `{"employee_id","amount","effective_date"}` `amount` ต้องมากกว่า 0 |
| GET | /accounting/bonus-candidates | accounting | `?cycle_id=` (จำเป็น ไม่ส่งได้ 400) แบบประเมินที่อนุมัติแล้วและยังไม่มีโบนัส |
| GET | /accounting/bonuses | accounting | รายการโบนัส `?cycle_id=&status=` ไม่ส่ง = ทั้งหมด |
| POST | /accounting/bonuses | accounting | body `{"evaluation_id","amount"?,"note"?}` ไม่ส่ง `amount` = ใช้ยอดที่ระบบเสนอ (201) |
| PUT | /accounting/bonuses/:id | accounting | body `{"amount","note"?}` `amount` จำเป็นและต้องไม่ติดลบ |
| GET | /executive/bonuses | executive | รายการโบนัส `?cycle_id=&status=` |
| POST | /executive/bonuses/:id/approve | executive | body `{"note"?}` |
| POST | /executive/bonuses/:id/reject | executive | body `{"note"?}` |

**รูปแบบข้อมูล**

เงินเดือนปัจจุบัน (`/accounting/salaries`) แต่ละแถว

```json
{"employee_id": 7, "employee_name": "...", "amount": 30000, "effective_date": "2026-01-01T00:00:00Z"}
```

`amount` และ `effective_date` เป็น `null` ถ้ายังไม่เคยตั้งเงินเดือน

ประวัติเงินเดือน (`/accounting/salaries/:employee_id/history`) แต่ละแถว

```json
{"id": 1, "employee_id": 7, "amount": 30000, "effective_date": "...", "created_by": 3, "created_at": "..."}
```

โบนัส

```json
{
  "id": 1, "evaluation_id": 1, "cycle_id": 3, "employee_id": 7,
  "base_salary": 30000, "total_score": 5, "suggested_amount": 60000, "amount": 60000,
  "status": "pending_approval", "note": "", "decision_note": "",
  "created_by": 3, "decided_by": null, "decided_at": null,
  "created_at": "...", "updated_at": "..."
}
```

- `suggested_amount` คือยอดที่ระบบเสนอจากเงินเดือนและคะแนน, `amount` คือยอดที่ accounting ยืนยัน
- `base_salary` และ `total_score` เป็นค่า ณ เวลาที่สร้างโบนัส

รูปแบบ response ของ `/accounting/bonus-candidates` ยังไม่ตรวจ (ดูจากโค้ด repository ว่าเป็นแบบประเมินที่อนุมัติแล้ว แต่ไม่ทราบว่า service เพิ่มข้อมูลอะไรอีก)

กติกา
- ตั้งเงินเดือนซ้ำพนักงานและวันที่มีผลเดิม ควรได้ 409
- สร้างโบนัสซ้ำสำหรับแบบประเมินใบเดิม, อนุมัติซ้ำ และแก้ยอดหลังอนุมัติ ได้ 409
- accounting อนุมัติโบนัสเองไม่ได้ (403)

## เลื่อนตำแหน่ง

HR เสนอ executive อนุมัติหรือปฏิเสธ ผูกกับแบบประเมินแบบ `supervisor` ที่ `approved` 1 ใบต่อ 1 ข้อเสนอ
สถานะ: `pending_approval`, `approved`, `rejected`

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| GET | /hr/promotions | hr | รายการข้อเสนอ `?cycle_id=&status=` ไม่ส่ง = ทั้งหมด |
| POST | /hr/promotions | hr | เสนอเลื่อนตำแหน่ง (201) |
| GET | /executive/promotions | executive | รายการข้อเสนอ `?cycle_id=&status=` |
| POST | /executive/promotions/:id/approve | executive | body `{"note"?}` |
| POST | /executive/promotions/:id/reject | executive | body `{"note"?}` |

**POST /hr/promotions** body

```json
{"evaluation_id": 1, "to_position": "Senior Developer", "to_level": "senior", "note": ""}
```

- จำเป็น: `evaluation_id`, `to_position` (ไม่เกิน 100 ตัวอักษร) ส่วน `to_level` (ไม่เกิน 50) และ `note` ไม่จำเป็น
- ระบบจดตำแหน่งและระดับปัจจุบันของพนักงานเป็น `from_position`, `from_level` ให้เอง

ตัวอย่าง response

```json
{
  "id": 1, "evaluation_id": 1, "cycle_id": 3, "employee_id": 7,
  "from_position": "Software Engineer", "to_position": "Senior Developer",
  "from_level": "junior", "to_level": "senior",
  "status": "pending_approval", "note": "", "decision_note": "",
  "created_by": 1, "decided_by": null, "decided_at": null,
  "created_at": "...", "updated_at": "..."
}
```

กติกา (ทดสอบแล้ว ยกเว้นข้อสุดท้าย)
- เสนอซ้ำสำหรับแบบประเมินใบเดิม ได้ 409, แบบประเมินไม่มี ได้ 404, ไม่ส่ง `to_position` ได้ 400
- ตัดสินได้เฉพาะ `pending_approval` ตัดสินซ้ำหรือกลับคำตัดสิน ได้ 409
- การอนุมัติ **ไม่แก้** ตำแหน่งหรือระดับในข้อมูลพนักงาน เป็นแค่บันทึกการตัดสินใจ
- executive ตัดสินข้อเสนอที่ตัวเองเป็นผู้ถูกเสนอไม่ได้ (403) (ยังไม่ได้ทดสอบ)

## โอนย้ายแผนก

HR เสนอ executive อนุมัติหรือปฏิเสธ ผูกกับแบบประเมินแบบ `supervisor` ที่ `approved` 1 ใบต่อ 1 ข้อเสนอ
สถานะ: `pending_approval`, `approved`, `rejected`

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| GET | /hr/transfers | hr | รายการข้อเสนอ `?cycle_id=&status=` ไม่ส่ง = ทั้งหมด |
| POST | /hr/transfers | hr | เสนอโอนย้าย (201) |
| GET | /executive/transfers | executive | รายการข้อเสนอ `?cycle_id=&status=` |
| POST | /executive/transfers/:id/approve | executive | body `{"note"?}` |
| POST | /executive/transfers/:id/reject | executive | body `{"note"?}` |

**POST /hr/transfers** body

```json
{"evaluation_id": 1, "to_department": "การตลาด", "effective_date": "2026-11-01T00:00:00Z", "note": ""}
```

- จำเป็น: `evaluation_id`, `to_department` (ไม่เกิน 100 ตัวอักษร) ส่วน `effective_date` (RFC 3339) และ `note` ไม่จำเป็น
- ระบบจดแผนกปัจจุบันของพนักงานเป็น `from_department` ให้เอง

ตัวอย่าง response

```json
{
  "id": 1, "evaluation_id": 1, "cycle_id": 3, "employee_id": 7,
  "from_department": "พัฒนาซอฟต์แวร์", "to_department": "การตลาด",
  "effective_date": "2026-11-01T00:00:00Z",
  "status": "pending_approval", "note": "", "decision_note": "",
  "created_by": 1, "decided_by": null, "decided_at": null,
  "created_at": "...", "updated_at": "..."
}
```

กติกา (ทดสอบแล้ว ยกเว้นที่ระบุ)
- เสนอซ้ำสำหรับแบบประเมินใบเดิม ได้ 409, แบบประเมินไม่มี ได้ 404, ไม่ส่ง `to_department` ได้ 400
- ตัดสินได้เฉพาะ `pending_approval` ตัดสินซ้ำหรือกลับคำตัดสิน ได้ 409
- การอนุมัติ **ไม่แก้** แผนกในข้อมูลพนักงาน เป็นแค่บันทึกการตัดสินใจ
- โอนไปแผนกเดิม ได้ 400 (ยังรอผลทดสอบ)
- executive ตัดสินข้อเสนอที่ตัวเองเป็นผู้ถูกเสนอไม่ได้ (403) (ยังไม่ได้ทดสอบ)

## ยังไม่มี API

โอนย้ายและแผนฝึกอบรม มีตารางในฐานข้อมูลแล้ว (`transfer_requests`, `training_plans`) แต่ยังไม่มี endpoint

## บัญชีทดสอบ (จาก `go run ./cmd/seed`)

hr@, executive@, accounting@, manager1-2@, employee1-6@ (โดเมน example.com) รหัสผ่านคือค่า `SEED_PASSWORD` ที่ตั้งตอนรัน seed