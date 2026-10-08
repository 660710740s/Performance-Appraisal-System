package repository

import "performance/backend/internal/domain"

func (r *reportRepository) ListEvaluationRows(f domain.EvaluationFilter) ([]domain.EvaluationRow, error) {
	q := r.db.Table("evaluations AS e").
		Select(`e.id, e.cycle_id, c.name AS cycle_name,
			e.employee_id, emp.name AS employee_name,
			COALESCE(emp.department, '') AS department, COALESCE(emp.level, '') AS level,
			e.type, e.evaluator_id, ev.name AS evaluator_name,
			e.status, e.total_score, e.submitted_at, e.approved_at`).
		Joins("JOIN evaluation_cycles c ON c.id = e.cycle_id").
		Joins("JOIN users emp ON emp.id = e.employee_id").
		Joins("JOIN users ev ON ev.id = e.evaluator_id")
	if f.CycleID > 0 {
		q = q.Where("e.cycle_id = ?", f.CycleID)
	}
	if f.Status != "" {
		q = q.Where("e.status = ?", f.Status)
	}
	if f.Type != "" {
		q = q.Where("e.type = ?", f.Type)
	}
	if f.Department != "" {
		q = q.Where("emp.department = ?", f.Department)
	}
	out := []domain.EvaluationRow{}
	err := q.Order("e.id DESC").Limit(f.Limit).Offset(f.Offset).Scan(&out).Error
	return out, err
}

func (r *reportRepository) ListAuditLogs(f domain.AuditFilter) ([]domain.AuditLog, error) {
	q := r.db.Model(&domain.AuditLog{})
	if f.Entity != "" {
		q = q.Where("entity = ?", f.Entity)
	}
	if f.EntityID > 0 {
		q = q.Where("entity_id = ?", f.EntityID)
	}
	if f.UserID > 0 {
		q = q.Where("user_id = ?", f.UserID)
	}
	out := []domain.AuditLog{}
	err := q.Order("id DESC").Limit(f.Limit).Offset(f.Offset).Find(&out).Error
	return out, err
}