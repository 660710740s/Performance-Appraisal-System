package repository

import (
	"time"

	"gorm.io/gorm"

	"performance/backend/internal/domain"
)

type taskRepository struct{ db *gorm.DB }

func NewTaskRepository(db *gorm.DB) domain.TaskRepository { return &taskRepository{db: db} }

func (r *taskRepository) CreateTask(t *domain.Task) error { return r.db.Create(t).Error }

func (r *taskRepository) CreateTasks(ts []domain.Task) error {
	if len(ts) == 0 {
		return nil
	}
	return r.db.CreateInBatches(&ts, 200).Error
}

func (r *taskRepository) ListTasksDueBetween(employeeID uint, from, to time.Time) ([]domain.Task, error) {
	var out []domain.Task
	err := r.db.Where("employee_id = ? AND due_date >= ? AND due_date < ?", employeeID, from, to).
		Order("due_date, id").Find(&out).Error
	return out, err
}
func (r *taskRepository) ListTasksDueBetweenForEmployees(ids []uint, from, to time.Time) ([]domain.Task, error) {
	var out []domain.Task
	if len(ids) == 0 {
		return out, nil
	}
	err := r.db.Where("employee_id IN ? AND due_date >= ? AND due_date < ?", ids, from, to).
		Order("employee_id, due_date, id").Find(&out).Error
	return out, err
}
