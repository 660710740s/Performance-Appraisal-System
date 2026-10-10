package service

import (
	"strings"
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

type UpdateEvaluationInput struct {
	Comment string
	Scores  []ScoreInput
}

type EvaluationService struct {
	evals domain.EvaluationRepository
	users domain.UserRepository
}

func NewEvaluationService(evals domain.EvaluationRepository, users domain.UserRepository) *EvaluationService {
	return &EvaluationService{evals: evals, users: users}
}

// รอบต้องเปิดอยู่ และวันนี้ต้องอยู่ในช่วงวันเริ่มถึงวันสิ้นสุด (นับถึงสิ้นวันของวันสิ้นสุด ตามเวลา UTC)
func cycleAcceptsEvaluation(c *domain.EvaluationCycle, now time.Time) bool {
	if c.Status != domain.CycleStatusOpen {
		return false
	}
	end := c.EndDate.UTC()
	endExclusive := time.Date(end.Year(), end.Month(), end.Day()+1, 0, 0, 0, 0, time.UTC)
	return !now.Before(c.StartDate) && now.Before(endExclusive)
}

// ---- Cycle / Criteria ----
func (s *EvaluationService) CreateCycle(userID uint, c *domain.EvaluationCycle) error {
	if !c.EndDate.After(c.StartDate) {
		return domain.ErrInvalidInput
	}
	c.Status = domain.CycleStatusOpen
	if err := s.evals.CreateCycle(c); err != nil {
		return err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: userID, Action: "create", Entity: "cycle", EntityID: c.ID, Detail: "สร้างรอบ " + c.Name,
	})
	return nil
}
func (s *EvaluationService) ListCycles() ([]domain.EvaluationCycle, error) {
	return s.evals.ListCycles()
}
func (s *EvaluationService) CreateCriteria(userID uint, role domain.Role, c *domain.Criteria) error {
	// หัวหน้าสร้างได้เฉพาะเกณฑ์ของแผนกตัวเอง
	if role == domain.RoleManager {
		u, err := s.users.GetByID(userID)
		if err != nil {
			return err
		}
		if u.Department == "" {
			return domain.ErrForbidden
		}
		c.Department = u.Department
	}
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

func (s *EvaluationService) UpdateCycle(userID, id uint, in UpdateCycleInput) (*domain.EvaluationCycle, error) {
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
	action := "update"
	if in.Status == domain.CycleStatusClosed {
		action = "close"
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: userID, Action: action, Entity: "cycle", EntityID: c.ID, Detail: c.Name,
	})
	return c, nil
}

type UpdateCriteriaInput struct {
	Name        string
	Description string
	Weight      float64
	IsActive    bool
	Rubric      *string // nil = ไม่เปลี่ยน
	Department  *string // nil = ไม่เปลี่ยน
	Level       *string // nil = ไม่เปลี่ยน
}

func (s *EvaluationService) UpdateCriteria(id uint, in UpdateCriteriaInput) (*domain.Criteria, error) {
	c, err := s.evals.GetCriteria(id)
	if err != nil {
		return nil, err
	}
	dept, level := c.Department, c.Level
	if in.Department != nil {
		dept = *in.Department
	}
	if in.Level != nil {
		level = *in.Level
	}
	// แก้น้ำหนัก/สถานะ/แผนก/ระดับได้เฉพาะตอนยังไม่มีแบบประเมินในระบบ
	if in.Weight != c.Weight || in.IsActive != c.IsActive || dept != c.Department || level != c.Level {
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
	c.Department = dept
	c.Level = level
	if in.Rubric != nil {
		c.Rubric = *in.Rubric
	}
	if err := s.evals.UpdateCriteria(c); err != nil {
		return nil, err
	}
	return c, nil
}

// ---- Evaluation ----

// ตรวจคะแนนให้ครบตามเกณฑ์ของพนักงาน แล้วคำนวณคะแนนรวมถ่วงน้ำหนัก
// ใช้ร่วมกันระหว่าง Create และ UpdateDraft
func (s *EvaluationService) buildScores(emp *domain.User, in []ScoreInput) ([]domain.EvaluationScore, float64, error) {
	criteria, err := s.evals.ListCriteriaFor(emp.Department, emp.Level)
	if err != nil {
		return nil, 0, err
	}
	weights := make(map[uint]float64, len(criteria))
	for _, c := range criteria {
		weights[c.ID] = c.Weight
	}
	if len(in) != len(criteria) {
		return nil, 0, domain.ErrInvalidInput // ต้องให้คะแนนครบทุกเกณฑ์
	}

	var weighted, totalWeight float64
	scores := make([]domain.EvaluationScore, 0, len(in))
	seen := map[uint]bool{}
	for _, sc := range in {
		w, ok := weights[sc.CriteriaID]
		if !ok || seen[sc.CriteriaID] || sc.Score < 1 || sc.Score > 5 {
			return nil, 0, domain.ErrInvalidInput
		}
		seen[sc.CriteriaID] = true
		weighted += float64(sc.Score) * w
		totalWeight += w
		scores = append(scores, domain.EvaluationScore{CriteriaID: sc.CriteriaID, Score: sc.Score, Comment: sc.Comment})
	}
	var total float64
	if totalWeight > 0 {
		total = weighted / totalWeight
	}
	return scores, total, nil
}

func (s *EvaluationService) Create(evaluatorID uint, role domain.Role, in CreateEvaluationInput) (*domain.Evaluation, error) {
	cycle, err := s.evals.GetCycle(in.CycleID)
	if err != nil {
		return nil, err
	}
	if !cycleAcceptsEvaluation(cycle, time.Now()) {
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
		// supervisor-evaluation: เฉพาะ manager/HR เท่านั้น
		if role != domain.RoleManager && role != domain.RoleHR {
			return nil, domain.ErrForbidden
		}
		// ห้ามประเมินตัวเอง, manager ประเมินได้เฉพาะลูกทีมของตัวเอง
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

	scores, total, err := s.buildScores(employee, in.Scores)
	if err != nil {
		return nil, err
	}

	e := &domain.Evaluation{
		CycleID: in.CycleID, EmployeeID: in.EmployeeID, EvaluatorID: evaluatorID, Type: evalType,
		Status: domain.EvalStatusDraft, Comment: in.Comment, Scores: scores, TotalScore: total,
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

// แก้ไขแบบประเมินที่ยังเป็น draft หรือถูกตีกลับ (เฉพาะผู้ประเมินเจ้าของ)
func (s *EvaluationService) UpdateDraft(id, userID uint, in UpdateEvaluationInput) (*domain.Evaluation, error) {
	e, err := s.evals.GetEvaluation(id)
	if err != nil {
		return nil, err
	}
	if e.EvaluatorID != userID {
		return nil, domain.ErrForbidden
	}
	if e.Status != domain.EvalStatusDraft && e.Status != domain.EvalStatusRejected {
		return nil, domain.ErrConflict
	}
	cycle, err := s.evals.GetCycle(e.CycleID)
	if err != nil {
		return nil, err
	}
	if !cycleAcceptsEvaluation(cycle, time.Now()) {
		return nil, domain.ErrInvalidInput
	}
	emp, err := s.users.GetByID(e.EmployeeID)
	if err != nil {
		return nil, err
	}
	scores, total, err := s.buildScores(emp, in.Scores)
	if err != nil {
		return nil, err
	}
	e.Comment = in.Comment
	e.TotalScore = total
	if err := s.evals.UpdateEvaluationWithScores(e, scores); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: userID, Action: "update", Entity: "evaluation", EntityID: e.ID,
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
	// ส่งได้เฉพาะ draft หรือแบบที่ถูกตีกลับมาแก้แล้ว
	if e.Status != domain.EvalStatusDraft && e.Status != domain.EvalStatusRejected {
		return nil, domain.ErrConflict
	}
	cycle, err := s.evals.GetCycle(e.CycleID)
	if err != nil {
		return nil, err
	}
	if !cycleAcceptsEvaluation(cycle, time.Now()) {
		return nil, domain.ErrInvalidInput
	}
	now := time.Now()
	e.Status = domain.EvalStatusSubmitted
	e.SubmittedAt = &now
	if err := s.evals.UpdateEvaluation(e); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: evaluatorID, Action: "submit", Entity: "evaluation", EntityID: e.ID,
	})
	return e, nil
}

// ตรวจสิทธิ์ผู้อนุมัติ/ตีกลับ: HR หรือหัวหน้าโดยตรงของพนักงาน
// และห้ามตรวจแบบประเมินที่ตัวเองเป็นผู้ประเมินหรือเป็นเจ้าของ
func (s *EvaluationService) checkReviewer(e *domain.Evaluation, reviewerID uint, role domain.Role) error {
	if role != domain.RoleHR && role != domain.RoleManager {
		return domain.ErrForbidden
	}
	if reviewerID == e.EvaluatorID || reviewerID == e.EmployeeID {
		return domain.ErrForbidden
	}
	if role == domain.RoleManager {
		emp, err := s.users.GetByID(e.EmployeeID)
		if err != nil {
			return err
		}
		if emp.ManagerID == nil || *emp.ManagerID != reviewerID {
			return domain.ErrForbidden
		}
	}
	return nil
}

func (s *EvaluationService) Approve(id, approverID uint, role domain.Role) (*domain.Evaluation, error) {
	e, err := s.evals.GetEvaluation(id)
	if err != nil {
		return nil, err
	}
	if err := s.checkReviewer(e, approverID, role); err != nil {
		return nil, err
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

// ตีกลับให้ผู้ประเมินแก้ไข ต้องระบุเหตุผล (เก็บใน audit log)
func (s *EvaluationService) Reject(id, reviewerID uint, role domain.Role, reason string) (*domain.Evaluation, error) {
	if strings.TrimSpace(reason) == "" {
		return nil, domain.ErrInvalidInput
	}
	e, err := s.evals.GetEvaluation(id)
	if err != nil {
		return nil, err
	}
	if err := s.checkReviewer(e, reviewerID, role); err != nil {
		return nil, err
	}
	if e.Status != domain.EvalStatusSubmitted {
		return nil, domain.ErrConflict
	}
	e.Status = domain.EvalStatusRejected
	e.SubmittedAt = nil
	if err := s.evals.UpdateEvaluation(e); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: reviewerID, Action: "reject", Entity: "evaluation", EntityID: e.ID, Detail: reason,
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
	// feedback ใช้กับผลประเมินของหัวหน้าที่ส่งแล้วหรืออนุมัติแล้วเท่านั้น
	if e.Type != domain.EvalTypeSupervisor ||
		(e.Status != domain.EvalStatusSubmitted && e.Status != domain.EvalStatusApproved) {
		return nil, domain.ErrConflict
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
	visible := e.Status == domain.EvalStatusSubmitted || e.Status == domain.EvalStatusApproved
	switch role {
	case domain.RoleHR:
	case domain.RoleManager:
		if e.EvaluatorID != userID && e.EmployeeID != userID {
			// หัวหน้าโดยตรงดูแบบของลูกทีมได้เมื่อส่งแล้ว (รวม self-evaluation ที่ต้องอนุมัติ)
			emp, err := s.users.GetByID(e.EmployeeID)
			if err != nil {
				return nil, err
			}
			if emp.ManagerID == nil || *emp.ManagerID != userID || !visible {
				return nil, domain.ErrForbidden
			}
		}
	default:
		// พนักงานดูของตัวเองได้เมื่อส่งแล้ว และดู self-evaluation ที่ตัวเองสร้างได้ทุกสถานะ
		ownSelf := e.EvaluatorID == userID && e.Type == domain.EvalTypeSelf
		if e.EmployeeID != userID || !(ownSelf || visible) {
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

// เกณฑ์ที่ใช้กับพนักงานคนหนึ่ง (employeeID = 0 คือไม่ระบุ)
// HR ไม่ระบุ = เห็นทุกเกณฑ์, คนอื่นไม่ระบุ = เกณฑ์ของตัวเอง
func (s *EvaluationService) ListCriteriaForUser(userID uint, role domain.Role, employeeID uint) ([]domain.Criteria, error) {
	if employeeID == 0 {
		if role == domain.RoleHR {
			return s.evals.ListCriteria()
		}
		employeeID = userID
	}
	emp, err := s.users.GetByID(employeeID)
	if err != nil {
		return nil, err
	}
	switch {
	case role == domain.RoleHR:
	case emp.ID == userID:
	case role == domain.RoleManager && emp.ManagerID != nil && *emp.ManagerID == userID:
	default:
		return nil, domain.ErrForbidden
	}
	return s.evals.ListCriteriaFor(emp.Department, emp.Level)
}