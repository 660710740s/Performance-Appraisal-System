package repository

import (
	"gorm.io/gorm"
	"performance/backend/internal/domain"
)

type promotionRepository struct{ db *gorm.DB }

func NewPromotionRepository(db *gorm.DB) domain.PromotionRepository {
	return &promotionRepository{db: db}
}

func (r *promotionRepository) CreatePromotion(p *domain.PromotionRequest) error {
	return mapErr(r.db.Create(p).Error)
}

func (r *promotionRepository) GetPromotion(id uint) (*domain.PromotionRequest, error) {
	var p domain.PromotionRequest
	if err := r.db.First(&p, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &p, nil
}

func (r *promotionRepository) GetPromotionByEvaluation(evaluationID uint) (*domain.PromotionRequest, error) {
	var p domain.PromotionRequest
	if err := r.db.Where("evaluation_id = ?", evaluationID).First(&p).Error; err != nil {
		return nil, mapErr(err)
	}
	return &p, nil
}

func (r *promotionRepository) UpdatePromotion(p *domain.PromotionRequest) error {
	return r.db.Save(p).Error
}

func (r *promotionRepository) ListPromotions(cycleID uint, status string) ([]domain.PromotionRequest, error) {
	q := r.db.Order("id DESC")
	if cycleID > 0 {
		q = q.Where("cycle_id = ?", cycleID)
	}
	if status != "" {
		q = q.Where("status = ?", status)
	}
	out := []domain.PromotionRequest{}
	err := q.Find(&out).Error
	return out, err
}
