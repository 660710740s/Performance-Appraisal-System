package repository

import (
	"gorm.io/gorm"
	"performance/backend/internal/domain"
)

type evaluationRepository struct{ db *gorm.DB }

func NewEvaluationRepository(db *gorm.DB) domain.EvaluationRepository {
	return &evaluationRepository{db: db}
}

func (r *evaluationRepository) CreateCycle(c *domain.EvaluationCycle) error {
	return r.db.Create(c).Error
}

func (r *evaluationRepository) ListCycles() ([]domain.EvaluationCycle, error) {
	var out []domain.EvaluationCycle
	err := r.db.Order("start_date desc").Find(&out).Error
	return out, err
}

func (r *evaluationRepository) GetCycle(id uint) (*domain.EvaluationCycle, error) {
	var c domain.EvaluationCycle
	if err := r.db.First(&c, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &c, nil
}

func (r *evaluationRepository) CreateCriteria(c *domain.Criteria) error {
	return r.db.Create(c).Error
}

func (r *evaluationRepository) ListCriteria() ([]domain.Criteria, error) {
	var out []domain.Criteria
	err := r.db.Where("is_active = ?", true).Order("id").Find(&out).Error
	return out, err
}

func (r *evaluationRepository) CreateEvaluation(e *domain.Evaluation) error {
	return r.db.Create(e).Error // สร้าง Scores ให้อัตโนมัติ
}

func (r *evaluationRepository) GetEvaluation(id uint) (*domain.Evaluation, error) {
	var e domain.Evaluation
	if err := r.db.Preload("Scores").First(&e, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &e, nil
}

func (r *evaluationRepository) UpdateEvaluation(e *domain.Evaluation) error {
	return r.db.Omit("Scores").Save(e).Error
}

func (r *evaluationRepository) ExistsFor(cycleID, employeeID uint) (bool, error) {
	var count int64
	err := r.db.Model(&domain.Evaluation{}).
		Where("cycle_id = ? AND employee_id = ?", cycleID, employeeID).
		Count(&count).Error
	return count > 0, err
}

func (r *evaluationRepository) ListByEmployee(employeeID uint) ([]domain.Evaluation, error) {
	var out []domain.Evaluation
	err := r.db.Preload("Scores").
		Where("employee_id = ? AND status = ?", employeeID, domain.EvalStatusSubmitted).
		Order("id desc").Find(&out).Error
	return out, err
}

func (r *evaluationRepository) ListByEvaluator(evaluatorID uint) ([]domain.Evaluation, error) {
	var out []domain.Evaluation
	err := r.db.Preload("Scores").Where("evaluator_id = ?", evaluatorID).Order("id desc").Find(&out).Error
	return out, err
}
