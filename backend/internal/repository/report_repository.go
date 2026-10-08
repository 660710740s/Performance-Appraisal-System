package repository

import (
	"gorm.io/gorm"
	"performance/backend/internal/domain"
)

type reportRepository struct{ db *gorm.DB }

func NewReportRepository(db *gorm.DB) domain.ReportRepository {
	return &reportRepository{db: db}
}

func (r *reportRepository) ListEvaluations(cycleID uint) ([]domain.Evaluation, error) {
	q := r.db.Model(&domain.Evaluation{}).Where("type = ?", domain.EvalTypeSupervisor)
	if cycleID > 0 {
		q = q.Where("cycle_id = ?", cycleID)
	}
	var out []domain.Evaluation
	err := q.Find(&out).Error
	return out, err
}

func (r *reportRepository) ListUsers() ([]domain.User, error) {
	var out []domain.User
	err := r.db.Find(&out).Error
	return out, err
}
