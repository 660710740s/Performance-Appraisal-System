package repository

import (
	"gorm.io/gorm"
	"performance/backend/internal/domain"
)

type transferRepository struct{ db *gorm.DB }

func NewTransferRepository(db *gorm.DB) domain.TransferRepository {
	return &transferRepository{db: db}
}

func (r *transferRepository) CreateTransfer(t *domain.TransferRequest) error {
	return mapErr(r.db.Create(t).Error)
}

func (r *transferRepository) GetTransfer(id uint) (*domain.TransferRequest, error) {
	var t domain.TransferRequest
	if err := r.db.First(&t, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &t, nil
}

func (r *transferRepository) GetTransferByEvaluation(evaluationID uint) (*domain.TransferRequest, error) {
	var t domain.TransferRequest
	if err := r.db.Where("evaluation_id = ?", evaluationID).First(&t).Error; err != nil {
		return nil, mapErr(err)
	}
	return &t, nil
}

func (r *transferRepository) UpdateTransfer(t *domain.TransferRequest) error {
	return r.db.Save(t).Error
}

func (r *transferRepository) ListTransfers(cycleID uint, status string) ([]domain.TransferRequest, error) {
	q := r.db.Order("id DESC")
	if cycleID > 0 {
		q = q.Where("cycle_id = ?", cycleID)
	}
	if status != "" {
		q = q.Where("status = ?", status)
	}
	out := []domain.TransferRequest{}
	err := q.Find(&out).Error
	return out, err
}
