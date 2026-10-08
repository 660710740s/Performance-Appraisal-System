package domain

type PromotionRepository interface {
	CreatePromotion(p *PromotionRequest) error
	GetPromotion(id uint) (*PromotionRequest, error)
	GetPromotionByEvaluation(evaluationID uint) (*PromotionRequest, error)
	UpdatePromotion(p *PromotionRequest) error
	ListPromotions(cycleID uint, status string) ([]PromotionRequest, error)
}
