# API (prefix /api/v1)

| Method | Path | Role | คำอธิบาย |
|---|---|---|---|
| POST | /auth/login | public | รับ JWT |
| GET | /me | ทุกคน | ข้อมูลผู้ใช้ปัจจุบัน |
| POST/GET | /users | admin | สร้าง/ดูรายชื่อพนักงาน |
| GET | /team | manager, admin | ลูกทีมของฉัน |
| POST/GET | /cycles | POST=admin | รอบการประเมิน |
| POST/GET | /criteria | POST=admin | เกณฑ์ + น้ำหนักคะแนน |
| POST | /evaluations | manager, admin | สร้างแบบประเมิน (draft) |
| POST | /evaluations/:id/submit | manager, admin | ส่งผลประเมิน |
| GET | /evaluations/me | ทุกคน | ผลของฉัน (เฉพาะ submitted) |
| GET | /evaluations/given | manager, admin | ที่ฉันประเมิน |
| GET | /evaluations/:id | ตามสิทธิ์ | รายละเอียด |
