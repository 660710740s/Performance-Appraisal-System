# Performance Evaluation - Backend (Go)

## เริ่มต้น
```bash
cp .env.example .env
go mod tidy          # สร้าง go.sum และดาวน์โหลด dependencies
export $(cat .env | xargs)
go run ./cmd
```
- Admin เริ่มต้น: ค่าจาก ADMIN_EMAIL / ADMIN_PASSWORD
- `AUTO_MIGRATE=true` ใช้ GORM สร้างตารางอัตโนมัติ (dev) / production ใช้ไฟล์ใน `migrations/` ผ่าน golang-migrate
