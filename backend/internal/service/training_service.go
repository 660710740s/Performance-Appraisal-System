package service

import (
	"strings"
	"time"

	"performance/backend/internal/domain"
)

type TrainingInput struct {
	EvaluationID uint // ใช้ตอนสร้างเท่านั้น
	Topic        string
	Reason       string
	StartDate    *time.Time
	EndDate      *time.Time
}

type TrainingService struct {
	plans domain.TrainingRepository
	evals domain.EvaluationRepository
	users domain.UserRepository
}

func NewTrainingService(plans domain.TrainingRepository, evals domain.EvaluationRepository, users domain.UserRepository) *TrainingService {
	return &TrainingService{plans: plans, evals: evals, users: users}
}

// hr จัดการได้ทุกคน, manager จัดการได้เฉพาะลูกทีมโดยตรง
func canManageTraining(by uint, role domain.Role, emp *domain.User) bool {
	switch role {
	case domain.RoleHR:
		return true
	case domain.RoleManager:
		return emp.ManagerID != nil && *emp.ManagerID == by
	}
	return false
}

func validTrainingInput(in TrainingInput) bool {
	if strings.TrimSpace(in.Topic) == "" {
		return false
	}
	if in.StartDate != nil && in.EndDate != nil && in.EndDate.Before(*in.StartDate) {
		return false
	}
	return true
}

var trainingTransitions = map[string][]string{
	domain.TrainingStatusPlanned:    {domain.TrainingStatusInProgress, domain.TrainingStatusCancelled},
	domain.TrainingStatusInProgress: {domain.TrainingStatusCompleted, domain.TrainingStatusCancelled},
}

func (s *TrainingService) Create(by uint, role domain.Role, in TrainingInput) (*domain.TrainingPlan, error) {
	if !validTrainingInput(in) {
		return nil, domain.ErrInvalidInput
	}
	e, err := s.evals.GetEvaluation(in.EvaluationID)
	if err != nil {
		return nil, err
	}
	if e.Type != domain.EvalTypeSupervisor || e.Status != domain.EvalStatusApproved {
		return nil, domain.ErrInvalidInput
	}
	emp, err := s.users.GetByID(e.EmployeeID)
	if err != nil {
		return nil, err
	}
	if !canManageTraining(by, role, emp) {
		return nil, domain.ErrForbidden
	}
	t := &domain.TrainingPlan{
		EvaluationID: e.ID, EmployeeID: e.EmployeeID,
		Topic: strings.TrimSpace(in.Topic), Reason: in.Reason,
		StartDate: in.StartDate, EndDate: in.EndDate,
		Status: domain.TrainingStatusPlanned, CreatedBy: by,
	}
	if err := s.plans.CreateTraining(t); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "create", Entity: "training", EntityID: t.ID,
	})
	return t, nil
}

// แก้หัวข้อ/เหตุผล/วันที่ ได้เฉพาะแผนที่ยังไม่จบ
func (s *TrainingService) Update(by uint, role domain.Role, id uint, in TrainingInput) (*domain.TrainingPlan, error) {
	if !validTrainingInput(in) {
		return nil, domain.ErrInvalidInput
	}
	t, err := s.plans.GetTraining(id)
	if err != nil {
		return nil, err
	}
	emp, err := s.users.GetByID(t.EmployeeID)
	if err != nil {
		return nil, err
	}
	if !canManageTraining(by, role, emp) {
		return nil, domain.ErrForbidden
	}
	if t.Status == domain.TrainingStatusCompleted || t.Status == domain.TrainingStatusCancelled {
		return nil, domain.ErrConflict
	}
	t.Topic, t.Reason = strings.TrimSpace(in.Topic), in.Reason
	t.StartDate, t.EndDate = in.StartDate, in.EndDate
	if err := s.plans.UpdateTraining(t); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "update", Entity: "training", EntityID: t.ID,
	})
	return t, nil
}

func (s *TrainingService) UpdateStatus(by uint, role domain.Role, id uint, status string) (*domain.TrainingPlan, error) {
	switch status {
	case domain.TrainingStatusPlanned, domain.TrainingStatusInProgress,
		domain.TrainingStatusCompleted, domain.TrainingStatusCancelled:
	default:
		return nil, domain.ErrInvalidInput
	}
	t, err := s.plans.GetTraining(id)
	if err != nil {
		return nil, err
	}
	emp, err := s.users.GetByID(t.EmployeeID)
	if err != nil {
		return nil, err
	}
	if !canManageTraining(by, role, emp) {
		return nil, domain.ErrForbidden
	}
	allowed := false
	for _, next := range trainingTransitions[t.Status] {
		if next == status {
			allowed = true
		}
	}
	if !allowed {
		return nil, domain.ErrConflict
	}
	t.Status = status
	if err := s.plans.UpdateTraining(t); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "update_status", Entity: "training", EntityID: t.ID,
	})
	return t, nil
}

// hr เห็นทั้งหมด, manager เห็นลูกทีมและตัวเอง, role อื่นเห็นเฉพาะของตัวเอง
func (s *TrainingService) List(by uint, role domain.Role, employeeID, evaluationID uint, status string) ([]domain.TrainingPlan, error) {
	switch status {
	case "", domain.TrainingStatusPlanned, domain.TrainingStatusInProgress,
		domain.TrainingStatusCompleted, domain.TrainingStatusCancelled:
	default:
		return nil, domain.ErrInvalidInput
	}
	var allowed []uint // nil = ไม่จำกัด
	switch role {
	case domain.RoleHR:
	case domain.RoleManager:
		reports, err := s.users.ListByManager(by)
		if err != nil {
			return nil, err
		}
		allowed = []uint{by}
		for _, u := range reports {
			allowed = append(allowed, u.ID)
		}
	default:
		allowed = []uint{by}
	}
	ids := allowed
	if employeeID > 0 {
		if allowed != nil {
			ok := false
			for _, id := range allowed {
				if id == employeeID {
					ok = true
				}
			}
			if !ok {
				return nil, domain.ErrForbidden
			}
		}
		ids = []uint{employeeID}
	}
	return s.plans.ListTraining(ids, evaluationID, status)
}
