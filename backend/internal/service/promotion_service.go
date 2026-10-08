package service

import (
	"errors"
	"strings"
	"time"

	"performance/backend/internal/domain"
)

type CreatePromotionInput struct {
	EvaluationID uint
	ToPosition   string
	ToLevel      string
	Note         string
}

type PromotionService struct {
	promos domain.PromotionRepository
	evals  domain.EvaluationRepository
	users  domain.UserRepository
}

func NewPromotionService(promos domain.PromotionRepository, evals domain.EvaluationRepository, users domain.UserRepository) *PromotionService {
	return &PromotionService{promos: promos, evals: evals, users: users}
}

// HR เสนอเลื่อนตำแหน่ง ผูกกับแบบประเมิน supervisor ที่อนุมัติแล้ว
func (s *PromotionService) Create(by uint, in CreatePromotionInput) (*domain.PromotionRequest, error) {
	toPosition := strings.TrimSpace(in.ToPosition)
	if toPosition == "" {
		return nil, domain.ErrInvalidInput
	}
	e, err := s.evals.GetEvaluation(in.EvaluationID)
	if err != nil {
		return nil, err
	}
	if e.Type != domain.EvalTypeSupervisor || e.Status != domain.EvalStatusApproved {
		return nil, domain.ErrInvalidInput
	}
	if _, err := s.promos.GetPromotionByEvaluation(e.ID); err == nil {
		return nil, domain.ErrConflict
	} else if !errors.Is(err, domain.ErrNotFound) {
		return nil, err
	}
	emp, err := s.users.GetByID(e.EmployeeID)
	if err != nil {
		return nil, err
	}
	p := &domain.PromotionRequest{
		EvaluationID: e.ID, CycleID: e.CycleID, EmployeeID: e.EmployeeID,
		FromPosition: emp.Position, FromLevel: emp.Level,
		ToPosition: toPosition, ToLevel: strings.TrimSpace(in.ToLevel),
		Status: domain.CareerStatusPending, Note: in.Note, CreatedBy: by,
	}
	if err := s.promos.CreatePromotion(p); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "create", Entity: "promotion", EntityID: p.ID,
	})
	return p, nil
}

// executive อนุมัติ/ปฏิเสธ: ทำได้เฉพาะ pending และห้ามตัดสินข้อเสนอของตัวเอง
func (s *PromotionService) Decide(by, id uint, approve bool, note string) (*domain.PromotionRequest, error) {
	p, err := s.promos.GetPromotion(id)
	if err != nil {
		return nil, err
	}
	if p.EmployeeID == by {
		return nil, domain.ErrForbidden
	}
	if p.Status != domain.CareerStatusPending {
		return nil, domain.ErrConflict
	}
	now := time.Now()
	p.Status = domain.CareerStatusRejected
	action := "reject"
	if approve {
		p.Status = domain.CareerStatusApproved
		action = "approve"
	}
	p.DecidedBy, p.DecidedAt, p.DecisionNote = &by, &now, note
	if err := s.promos.UpdatePromotion(p); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: action, Entity: "promotion", EntityID: p.ID,
	})
	return p, nil
}

func (s *PromotionService) List(cycleID uint, status string) ([]domain.PromotionRequest, error) {
	switch status {
	case "", domain.CareerStatusPending, domain.CareerStatusApproved, domain.CareerStatusRejected:
	default:
		return nil, domain.ErrInvalidInput
	}
	return s.promos.ListPromotions(cycleID, status)
}
