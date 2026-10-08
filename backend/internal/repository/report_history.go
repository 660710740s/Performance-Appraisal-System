package repository

import "performance/backend/internal/domain"

func (r *reportRepository) GetUserByID(id uint) (*domain.User, error) {
	var u domain.User
	if err := r.db.First(&u, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &u, nil
}

// แบบประเมินทุกรอบของพนักงานหนึ่งคน เรียงจากรอบเก่าไปใหม่
func (r *reportRepository) ListEmployeeEvaluationRows(employeeID uint, statuses []string) ([]domain.EvaluationRow, error) {
	q := r.db.Table("evaluations AS e").
		Select(`e.id, e.cycle_id, c.name AS cycle_name,
			e.employee_id, emp.name AS employee_name,
			COALESCE(emp.department, '') AS department, COALESCE(emp.level, '') AS level,
			e.type, e.evaluator_id, ev.name AS evaluator_name,
			e.status, e.total_score, e.submitted_at, e.approved_at`).
		Joins("JOIN evaluation_cycles c ON c.id = e.cycle_id").
		Joins("JOIN users emp ON emp.id = e.employee_id").
		Joins("JOIN users ev ON ev.id = e.evaluator_id").
		Where("e.employee_id = ?", employeeID)
	if len(statuses) > 0 {
		q = q.Where("e.status IN ?", statuses)
	}
	out := []domain.EvaluationRow{}
	err := q.Order("c.start_date ASC, e.id ASC").Scan(&out).Error
	return out, err
}