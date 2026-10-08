package repository

import (
	"gorm.io/gorm"
	"performance/backend/internal/domain"
)

type trainingRepository struct{ db *gorm.DB }

func NewTrainingRepository(db *gorm.DB) domain.TrainingRepository {
	return &trainingRepository{db: db}
}

func (r *trainingRepository) CreateTraining(t *domain.TrainingPlan) error {
	return mapErr(r.db.Create(t).Error)
}

func (r *trainingRepository) GetTraining(id uint) (*domain.TrainingPlan, error) {
	var t domain.TrainingPlan
	if err := r.db.First(&t, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &t, nil
}

func (r *trainingRepository) UpdateTraining(t *domain.TrainingPlan) error {
	return r.db.Save(t).Error
}

func (r *trainingRepository) ListTraining(employeeIDs []uint, evaluationID uint, status string) ([]domain.TrainingPlan, error) {
	q := r.db.Order("id DESC")
	if employeeIDs != nil {
		q = q.Where("employee_id IN ?", employeeIDs)
	}
	if evaluationID > 0 {
		q = q.Where("evaluation_id = ?", evaluationID)
	}
	if status != "" {
		q = q.Where("status = ?", status)
	}
	out := []domain.TrainingPlan{}
	err := q.Find(&out).Error
	return out, err
}
