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

func (r *evaluationRepository) ExistsFor(cycleID, employeeID uint, evalType string) (bool, error) {
	var count int64
	err := r.db.Model(&domain.Evaluation{}).
		Where("cycle_id = ? AND employee_id = ? AND type = ?", cycleID, employeeID, evalType).
		Count(&count).Error
	return count > 0, err
}

func (r *evaluationRepository) CreateAuditLog(a *domain.AuditLog) error {
	return r.db.Create(a).Error
}

func (r *evaluationRepository) ListByEmployee(employeeID uint) ([]domain.Evaluation, error) {
	var out []domain.Evaluation
	err := r.db.Preload("Scores").
		Where("employee_id = ? AND status IN ?", employeeID, []string{domain.EvalStatusSubmitted, domain.EvalStatusApproved}).
		Order("id desc").Find(&out).Error
	return out, err
}

func (r *evaluationRepository) ListByEvaluator(evaluatorID uint) ([]domain.Evaluation, error) {
	var out []domain.Evaluation
	err := r.db.Preload("Scores").Where("evaluator_id = ?", evaluatorID).Order("id desc").Find(&out).Error
	return out, err
}
func (r *evaluationRepository) UpdateCycle(c *domain.EvaluationCycle) error {
	return r.db.Save(c).Error
}

func (r *evaluationRepository) GetCriteria(id uint) (*domain.Criteria, error) {
	var c domain.Criteria
	if err := r.db.First(&c, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &c, nil
}

func (r *evaluationRepository) UpdateCriteria(c *domain.Criteria) error {
	return r.db.Save(c).Error
}

func (r *evaluationRepository) CountEvaluations() (int64, error) {
	var n int64
	err := r.db.Model(&domain.Evaluation{}).Count(&n).Error
	return n, err
}

func (r *evaluationRepository) ListCriteriaFor(department, level string) ([]domain.Criteria, error) {
	var out []domain.Criteria
	err := r.db.Where("is_active = ?", true).
		Where("COALESCE(department, '') IN ('', ?)", department).
		Where("COALESCE(level, '') IN ('', ?)", level).
		Order("id").Find(&out).Error
	return out, err
}
