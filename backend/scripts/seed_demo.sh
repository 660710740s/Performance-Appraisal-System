#!/usr/bin/env bash
# ใช้: ./scripts/seed_demo.sh   (รันจากโฟลเดอร์ backend, ต้องเปิด DB ไว้แล้ว)
set -euo pipefail
cd "$(dirname "$0")/.."
export SEED_PASSWORD="${SEED_PASSWORD:-test12345}"
DB_NAME="$(grep -E '^DB_NAME=' .env | cut -d= -f2)"
docker exec eval_db psql -U postgres -tc "select 1 from pg_database where datname='${DB_NAME}'" | grep -q 1 \
  || docker exec eval_db psql -U postgres -c "CREATE DATABASE ${DB_NAME};"
go run ./cmd/seed
go run ./cmd/seedbulk
docker exec -i eval_db psql -U postgres -d "${DB_NAME}" -v ON_ERROR_STOP=1 < scripts/seed_demo.sql
echo "เสร็จแล้ว: ล็อกอิน hr@example.com / executive@example.com รหัส ${SEED_PASSWORD}"
