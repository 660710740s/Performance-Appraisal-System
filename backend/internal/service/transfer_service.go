package service

import (
	"errors"
	"strings"
	"time"

	"performance/backend/internal/domain"
)

type CreateTransferInput struct {
	EvaluationID  uint
	ToDepartment  string
	EffectiveDate *time.Time
	Note          string
}

type TransferService struct {
	transfers domain.TransferRepository
	evals     domain.EvaluationRepository
	users     domain.UserRepository
}

func NewTransferService(transfers domain.TransferRepository, evals domain.EvaluationRepository, users domain.UserRepository) *TransferService {
	return &TransferService{transfers: transfers, evals: evals, users: users}
}

// HR เสนอโอนย้ายแผนก ผูกกับแบบประเมิน supervisor ที่อนุมัติแล้ว
func (s *TransferService) Create(by uint, in CreateTransferInput) (*domain.TransferRequest, error) {
	toDept := strings.TrimSpace(in.ToDepartment)
	if toDept == "" {
		return nil, domain.ErrInvalidInput
	}
	// แผนกปลายทางต้องอยู่ในรายการหลัก
	deptOK, err := s.evals.DepartmentExists(toDept)
	if err != nil {
		return nil, err
	}
	if !deptOK {
		return nil, domain.ErrInvalidInput
	}
	e, err := s.evals.GetEvaluation(in.EvaluationID)
	if err != nil {
		return nil, err
	}
	if e.Type != domain.EvalTypeSupervisor || e.Status != domain.EvalStatusApproved {
		return nil, domain.ErrInvalidInput
	}
	if _, err := s.transfers.GetTransferByEvaluation(e.ID); err == nil {
		return nil, domain.ErrConflict
	} else if !errors.Is(err, domain.ErrNotFound) {
		return nil, err
	}
	emp, err := s.users.GetByID(e.EmployeeID)
	if err != nil {
		return nil, err
	}
	if emp.Department == toDept {
		return nil, domain.ErrInvalidInput // โอนไปแผนกเดิม
	}
	t := &domain.TransferRequest{
		EvaluationID: e.ID, CycleID: e.CycleID, EmployeeID: e.EmployeeID,
		FromDepartment: emp.Department, ToDepartment: toDept,
		EffectiveDate: in.EffectiveDate,
		Status:        domain.CareerStatusPending, Note: in.Note, CreatedBy: by,
	}
	if err := s.transfers.CreateTransfer(t); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "create", Entity: "transfer", EntityID: t.ID,
	})
	return t, nil
}

// executive อนุมัติ/ปฏิเสธ: ทำได้เฉพาะ pending และห้ามตัดสินข้อเสนอของตัวเอง
func (s *TransferService) Decide(by, id uint, approve bool, note string) (*domain.TransferRequest, error) {
	t, err := s.transfers.GetTransfer(id)
	if err != nil {
		return nil, err
	}
	if t.EmployeeID == by {
		return nil, domain.ErrForbidden
	}
	if t.Status != domain.CareerStatusPending {
		return nil, domain.ErrConflict
	}
	now := time.Now()
	t.Status = domain.CareerStatusRejected
	action := "reject"
	if approve {
		t.Status = domain.CareerStatusApproved
		action = "approve"
	}
	t.DecidedBy, t.DecidedAt, t.DecisionNote = &by, &now, note
	if err := s.transfers.UpdateTransfer(t); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: action, Entity: "transfer", EntityID: t.ID,
	})
	return t, nil
}

func (s *TransferService) List(cycleID uint, status string) ([]domain.TransferRequest, error) {
	switch status {
	case "", domain.CareerStatusPending, domain.CareerStatusApproved, domain.CareerStatusRejected:
	default:
		return nil, domain.ErrInvalidInput
	}
	return s.transfers.ListTransfers(cycleID, status)
}
