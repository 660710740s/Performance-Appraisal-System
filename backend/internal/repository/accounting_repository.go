package repository

import (
	"errors"
	"time"

	"gorm.io/gorm"
	"performance/backend/internal/domain"
)

type accountingRepository struct{ db *gorm.DB }

func NewAccountingRepository(db *gorm.DB) domain.AccountingRepository {
	return &accountingRepository{db: db}
}

func accMapErr(err error) error {
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.ErrNotFound
	}
	return err
}

func (r *accountingRepository) CreateSalary(s *domain.SalaryRecord) error {
	return r.db.Create(s).Error
}

// เงินเดือนที่มีผล ณ วันที่ at
func (r *accountingRepository) SalaryAt(employeeID uint, at time.Time) (*domain.SalaryRecord, error) {
	var s domain.SalaryRecord
	err := r.db.Where("employee_id = ? AND effective_date <= ?", employeeID, at).
		Order("effective_date DESC").First(&s).Error
	if err != nil {
		return nil, accMapErr(err)
	}
	return &s, nil
}

func (r *accountingRepository) ListSalaryHistory(employeeID uint) ([]domain.SalaryRecord, error) {
	var out []domain.SalaryRecord
	err := r.db.Where("employee_id = ?", employeeID).Order("effective_date DESC").Find(&out).Error
	return out, err
}

func (r *accountingRepository) ListCurrentSalaries() ([]domain.CurrentSalary, error) {
	var out []domain.CurrentSalary
	err := r.db.Raw(`
		SELECT u.id AS employee_id, u.name AS employee_name, s.amount AS amount, s.effective_date AS effective_date
		FROM users u
		LEFT JOIN salary_records s
		  ON s.employee_id = u.id
		 AND s.effective_date = (
		       SELECT MAX(effective_date) FROM salary_records
		       WHERE employee_id = u.id AND effective_date <= ?)
		WHERE u.is_active = ?
		ORDER BY u.id`, time.Now(), true).Scan(&out).Error
	return out, err
}

func (r *accountingRepository) CreateBonus(b *domain.Bonus) error {
	return r.db.Create(b).Error
}

func (r *accountingRepository) GetBonus(id uint) (*domain.Bonus, error) {
	var b domain.Bonus
	if err := r.db.First(&b, id).Error; err != nil {
		return nil, accMapErr(err)
	}
	return &b, nil
}

func (r *accountingRepository) GetBonusByEvaluation(evaluationID uint) (*domain.Bonus, error) {
	var b domain.Bonus
	if err := r.db.Where("evaluation_id = ?", evaluationID).First(&b).Error; err != nil {
		return nil, accMapErr(err)
	}
	return &b, nil
}

func (r *accountingRepository) UpdateBonus(b *domain.Bonus) error {
	return r.db.Save(b).Error
}

func (r *accountingRepository) ListBonuses(cycleID uint, status string) ([]domain.Bonus, error) {
	q := r.db.Order("id DESC")
	if cycleID > 0 {
		q = q.Where("cycle_id = ?", cycleID)
	}
	if status != "" {
		q = q.Where("status = ?", status)
	}
	var out []domain.Bonus
	err := q.Find(&out).Error
	return out, err
}

func (r *accountingRepository) ListApprovedWithoutBonus(cycleID uint) ([]domain.Evaluation, error) {
	var out []domain.Evaluation
	sub := r.db.Model(&domain.Bonus{}).Select("evaluation_id")
	err := r.db.Where("cycle_id = ? AND type = ? AND status = ?",
		cycleID, domain.EvalTypeSupervisor, domain.EvalStatusApproved).
		Where("id NOT IN (?)", sub).
		Order("id").Find(&out).Error
	return out, err
}
