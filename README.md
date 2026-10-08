# Performance Appraisal System

ระบบประเมินผลการปฏิบัติงานของพนักงาน (Backend: Go + PostgreSQL)

เอกสาร API ทั้งหมดอยู่ที่ [`backend/docs/API.md`](backend/docs/API.md)

## เริ่มต้น

```bash
# 1) เปิดฐานข้อมูล
docker compose up -d db

# 2) ตั้งค่า environment
cd backend
cp env.example .env
# แก้ค่าใน .env ให้ตรงกับเครื่อง (อย่า commit ไฟล์ .env)

# 3) โหลดค่าและรันเซิร์ฟเวอร์
go mod tidy
export $(cat .env | xargs)
go run ./cmd
```

## ฐานข้อมูล

- ค่าเริ่มต้น `AUTO_MIGRATE` ไม่ตั้ง = เซิร์ฟเวอร์สร้างตารางเองด้วย GORM (สำหรับ dev)
- ตั้ง `AUTO_MIGRATE=false` เพื่อข้ามขั้นนั้น เมื่อใช้ไฟล์ใน `backend/migrations/` ผ่าน [golang-migrate](https://github.com/golang-migrate/migrate) (แนะนำสำหรับ production)

```bash
cd backend
migrate -path migrations \
  -database "postgres://USER:PASSWORD@HOST:5432/DB_NAME?sslmode=disable" up
```

ย้อนกลับทั้งหมดใช้ `down -all` (ฐานข้อมูลที่มีผู้ใช้ role `hr` อยู่จะย้อน migration 000002 ไม่ผ่าน ให้ทดสอบบนฐานข้อมูลเปล่า)

## ข้อมูลทดสอบ

```bash
cd backend
DB_HOST=localhost DB_PORT=5432 DB_USER=postgres DB_PASSWORD=postgres DB_NAME=appraisal_test \
SEED_PASSWORD='ตั้งรหัสผ่านทดสอบ' go run ./cmd/seed
```

สร้างบัญชี hr@, executive@, accounting@, manager1-2@, employee1-6@ (โดเมน `example.com`) ใช้รหัสผ่านตาม `SEED_PASSWORD` **ใช้เฉพาะเครื่อง dev ห้ามนำไปใช้บน production**
