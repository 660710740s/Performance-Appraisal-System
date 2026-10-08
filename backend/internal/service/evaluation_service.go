package service

import (
	"time"

	"performance/backend/internal/domain"
)

type ScoreInput struct {
	CriteriaID uint
	Score      int
	Comment    string
}

type CreateEvaluationInput struct {
	CycleID    uint
	EmployeeID uint
	Type       string
	Comment    string
	Scores     []ScoreInput
}

type EvaluationService struct {
	evals domain.EvaluationRepository
	users domain.UserRepository
}

func NewEvaluationService(evals domain.EvaluationRepository, users domain.UserRepository) *EvaluationService {
	return &EvaluationService{evals: evals, users: users}
}

// ---- Cycle / Criteria ----
func (s *EvaluationService) CreateCycle(c *domain.EvaluationCycle) error {
	c.Status = domain.CycleStatusOpen
	return s.evals.CreateCycle(c)
}
func (s *EvaluationService) ListCycles() ([]domain.EvaluationCycle, error) {
	return s.evals.ListCycles()
}
func (s *EvaluationService) CreateCriteria(c *domain.Criteria) error {
	c.IsActive = true
	return s.evals.CreateCriteria(c)
}
func (s *EvaluationService) ListCriteria() ([]domain.Criteria, error) {
	return s.evals.ListCriteria()
}

type UpdateCycleInput struct {
	Name      string
	StartDate time.Time
	EndDate   time.Time
	Status    string // ว่าง = ไม่เปลี่ยนสถานะ
}

func (s *EvaluationService) UpdateCycle(id uint, in UpdateCycleInput) (*domain.EvaluationCycle, error) {
	c, err := s.evals.GetCycle(id)
	if err != nil {
		return nil, err
	}
	if c.Status != domain.CycleStatusOpen {
		return nil, domain.ErrConflict // รอบปิดแล้ว ห้ามแก้
	}
	if !in.EndDate.After(in.StartDate) {
		return nil, domain.ErrInvalidInput
	}
	c.Name = in.Name
	c.StartDate = in.StartDate
	c.EndDate = in.EndDate
	if in.Status != "" {
		c.Status = in.Status
	}
	if err := s.evals.UpdateCycle(c); err != nil {
		return nil, err
	}
	return c, nil
}

type UpdateCriteriaInput struct {
	Name        string
	Description string
	Weight      float64
	IsActive    bool
}

func (s *EvaluationService) UpdateCriteria(id uint, in UpdateCriteriaInput) (*domain.Criteria, error) {
	c, err := s.evals.GetCriteria(id)
	if err != nil {
		return nil, err
	}
	// แก้น้ำหนัก/สถานะได้เฉพาะตอนยังไม่มีแบบประเมินในระบบ
	if in.Weight != c.Weight || in.IsActive != c.IsActive {
		n, err := s.evals.CountEvaluations()
		if err != nil {
			return nil, err
		}
		if n > 0 {
			return nil, domain.ErrConflict
		}
	}
	c.Name = in.Name
	c.Description = in.Description
	c.Weight = in.Weight
	c.IsActive = in.IsActive
	if err := s.evals.UpdateCriteria(c); err != nil {
		return nil, err
	}
	return c, nil
}

// ---- Evaluation ----
func (s *EvaluationService) Create(evaluatorID uint, role domain.Role, in CreateEvaluationInput) (*domain.Evaluation, error) {
	cycle, err := s.evals.GetCycle(in.CycleID)
	if err != nil {
		return nil, err
	}
	if cycle.Status != domain.CycleStatusOpen {
		return nil, domain.ErrInvalidInput
	}

	employee, err := s.users.GetByID(in.EmployeeID)
	if err != nil {
		return nil, err
	}

	evalType := in.Type
	if evalType == "" {
		evalType = domain.EvalTypeSupervisor
	}

	if evalType == domain.EvalTypeSelf {
		// self-evaluation: ต้องประเมินตัวเองเท่านั้น
		if evaluatorID != in.EmployeeID {
			return nil, domain.ErrForbidden
		}
	} else {
		// supervisor-evaluation: ห้ามประเมินตัวเอง, manager ประเมินได้เฉพาะลูกทีมของตัวเอง
		if evaluatorID == in.EmployeeID {
			return nil, domain.ErrForbidden
		}
		if role == domain.RoleManager && (employee.ManagerID == nil || *employee.ManagerID != evaluatorID) {
			return nil, domain.ErrForbidden
		}
	}

	if exists, err := s.evals.ExistsFor(in.CycleID, in.EmployeeID, evalType); err != nil {
		return nil, err
	} else if exists {
		return nil, domain.ErrConflict
	}

	criteria, err := s.evals.ListCriteria()
	if err != nil {
		return nil, err
	}
	weights := make(map[uint]float64, len(criteria))
	for _, c := range criteria {
		weights[c.ID] = c.Weight
	}
	if len(in.Scores) != len(criteria) {
		return nil, domain.ErrInvalidInput // ต้องให้คะแนนครบทุกเกณฑ์
	}

	var weighted, totalWeight float64
	scores := make([]domain.EvaluationScore, 0, len(in.Scores))
	seen := map[uint]bool{}
	for _, sc := range in.Scores {
		w, ok := weights[sc.CriteriaID]
		if !ok || seen[sc.CriteriaID] || sc.Score < 1 || sc.Score > 5 {
			return nil, domain.ErrInvalidInput
		}
		seen[sc.CriteriaID] = true
		weighted += float64(sc.Score) * w
		totalWeight += w
		scores = append(scores, domain.EvaluationScore{CriteriaID: sc.CriteriaID, Score: sc.Score, Comment: sc.Comment})
	}

	e := &domain.Evaluation{
		CycleID: in.CycleID, EmployeeID: in.EmployeeID, EvaluatorID: evaluatorID, Type: evalType,
		Status: domain.EvalStatusDraft, Comment: in.Comment, Scores: scores,
	}
	if totalWeight > 0 {
		e.TotalScore = weighted / totalWeight
	}
	if err := s.evals.CreateEvaluation(e); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: evaluatorID, Action: "create", Entity: "evaluation", EntityID: e.ID,
		Detail: "สร้างแบบประเมิน type=" + evalType,
	})
	return e, nil
}

func (s *EvaluationService) Submit(id, evaluatorID uint, role domain.Role) (*domain.Evaluation, error) {
	e, err := s.evals.GetEvaluation(id)
	if err != nil {
		return nil, err
	}
	if role != domain.RoleHR && e.EvaluatorID != evaluatorID {
		return nil, domain.ErrForbidden
	}
	if e.Status != domain.EvalStatusDraft {
		return nil, domain.ErrConflict
	}
	now := time.Now()
	e.Status = domain.EvalStatusSubmitted
	e.SubmittedAt = &now
	if err := s.evals.UpdateEvaluation(e); err != nil {
		return nil, err
	}
	return e, nil
}

func (s *EvaluationService) Approve(id, approverID uint, role domain.Role) (*domain.Evaluation, error) {
	e, err := s.evals.GetEvaluation(id)
	if err != nil {
		return nil, err
	}
	if role != domain.RoleHR && role != domain.RoleManager {
		return nil, domain.ErrForbidden
	}
	if role == domain.RoleManager {
		emp, err := s.users.GetByID(e.EmployeeID)
		if err != nil {
			return nil, err
		}
		if emp.ManagerID == nil || *emp.ManagerID != approverID {
			return nil, domain.ErrForbidden
		}
	}
	if e.Status != domain.EvalStatusSubmitted {
		return nil, domain.ErrConflict
	}
	now := time.Now()
	e.Status = domain.EvalStatusApproved
	e.ApprovedAt = &now
	e.ApprovedBy = &approverID
	if err := s.evals.UpdateEvaluation(e); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: approverID, Action: "approve", Entity: "evaluation", EntityID: e.ID,
	})
	return e, nil
}

func (s *EvaluationService) AddFeedback(id, employeeID uint, feedback string) (*domain.Evaluation, error) {
	e, err := s.evals.GetEvaluation(id)
	if err != nil {
		return nil, err
	}
	if e.EmployeeID != employeeID {
		return nil, domain.ErrForbidden
	}
	e.EmployeeFeedback = feedback
	if err := s.evals.UpdateEvaluation(e); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: employeeID, Action: "feedback", Entity: "evaluation", EntityID: e.ID,
	})
	return e, nil
}

func (s *EvaluationService) Get(id, userID uint, role domain.Role) (*domain.Evaluation, error) {
	e, err := s.evals.GetEvaluation(id)
	if err != nil {
		return nil, err
	}
	switch role {
	case domain.RoleHR:
	case domain.RoleManager:
		if e.EvaluatorID != userID && e.EmployeeID != userID {
			return nil, domain.ErrForbidden
		}
	default:
		if e.EmployeeID != userID || (e.Status != domain.EvalStatusSubmitted && e.Status != domain.EvalStatusApproved) {
			return nil, domain.ErrForbidden
		}
	}
	return e, nil
}

func (s *EvaluationService) ListMine(employeeID uint) ([]domain.Evaluation, error) {
	return s.evals.ListByEmployee(employeeID)
}

func (s *EvaluationService) ListGiven(evaluatorID uint) ([]domain.Evaluation, error) {
	return s.evals.ListByEvaluator(evaluatorID)
}
