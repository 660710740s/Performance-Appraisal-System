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
	kpi   *KpiService
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
	c.Department = strings.TrimSpace(c.Department) // NEW
	c.Level = strings.TrimSpace(c.Level)           // NEW
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
	} else if err := s.validateDepartment(c.Department); err != nil { // NEW
		return err
	}
	if err := s.validateLevel(c.Level); err != nil { // NEW
		return err
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
		dept = strings.TrimSpace(*in.Department)           // แก้จาก dept = *in.Department
		if err := s.validateDepartment(dept); err != nil { // NEW
			return nil, err
		}
	}
	if in.Level != nil {
		level = strings.TrimSpace(*in.Level)
		if err := s.validateLevel(level); err != nil { // NEW
			return nil, err
		}
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
// เกณฑ์ auto ที่ข้อมูลงานพอ ระบบคำนวณให้เอง ที่เหลือต้องกรอกเอง
// strict=true (ตอนส่ง) ต้องมีคะแนนครบทุกข้อ / strict=false (ร่าง) เว้นข้อที่ยังไม่กรอกไว้ได้ (Score=0)
// ใช้ร่วมกันระหว่าง Create, UpdateDraft และ Submit
func (s *EvaluationService) buildScores(emp *domain.User, cycle *domain.EvaluationCycle, in []ScoreInput, strict bool) ([]domain.EvaluationScore, float64, error) {
	criteria, err := s.evals.ListCriteriaFor(emp.Department, emp.Level)
	if err != nil {
		return nil, 0, err
	}
	byID := make(map[uint]domain.Criteria, len(criteria))
	hasAuto := false
	for _, c := range criteria {
		byID[c.ID] = c
		if c.Source != "" && c.Source != domain.SourceManual {
			hasAuto = true
		}
	}

	// ตรวจ input: ต้องเป็นเกณฑ์ของพนักงาน ไม่ซ้ำ และคะแนน 0-5 (0 = ยังไม่ให้คะแนน)
	given := make(map[uint]ScoreInput, len(in))
	for _, sc := range in {
		if _, ok := byID[sc.CriteriaID]; !ok {
			return nil, 0, domain.ErrInvalidInput
		}
		if _, dup := given[sc.CriteriaID]; dup || sc.Score < 0 || sc.Score > 5 {
			return nil, 0, domain.ErrInvalidInput
		}
		given[sc.CriteriaID] = sc
	}

	var metrics map[string]KpiMetric
	if hasAuto && s.kpi != nil {
		if metrics, err = s.kpi.Compute(emp.ID, cycle, time.Now()); err != nil {
			return nil, 0, err
		}
	}

	var weighted, totalWeight float64
	scores := make([]domain.EvaluationScore, 0, len(criteria))
	for _, c := range criteria {
		row := domain.EvaluationScore{CriteriaID: c.ID, Weight: c.Weight, Source: domain.SourceManual}
		if m, ok := metrics[c.Source]; ok && m.Enough {
			row.Score, row.Source, row.Metric, row.Detail = m.Score, c.Source, m.Percent, m.Detail()
			if sc, has := given[c.ID]; has {
				row.Comment = sc.Comment // เก็บหมายเหตุได้ แต่คะแนนใช้ของระบบ
			}
		} else {
			sc, has := given[c.ID]
			if has {
				row.Comment = sc.Comment
			}
			if !has || sc.Score < 1 {
				if strict {
					return nil, 0, domain.ErrInvalidInput // ตอนส่ง ต้องมีคะแนนครบ
				}
				scores = append(scores, row) // ร่าง: ยังไม่ให้คะแนน (Score=0) ไม่นับในคะแนนรวม
				continue
			}
			row.Score = sc.Score
		}
		weighted += float64(row.Score) * c.Weight
		totalWeight += c.Weight
		scores = append(scores, row)
	}
	var total float64
	if totalWeight > 0 {
		total = round2(weighted / totalWeight)
	}
	return scores, total, nil
}

// แปลงคะแนนที่บันทึกไว้กลับเป็น input (ข้อ auto ไม่ส่งคะแนน ให้ระบบคำนวณใหม่)
func scoreInputsFrom(rows []domain.EvaluationScore) []ScoreInput {
	out := make([]ScoreInput, 0, len(rows))
	for _, r := range rows {
		in := ScoreInput{CriteriaID: r.CriteriaID, Comment: r.Comment}
		if r.Source == domain.SourceManual {
			in.Score = r.Score
		}
		out = append(out, in)
	}
	return out
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

	scores, total, err := s.buildScores(employee, cycle, in.Scores, false)
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
	scores, total, err := s.buildScores(emp, cycle, in.Scores, false)
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
	// คำนวณคะแนน auto ใหม่ตามข้อมูลงานล่าสุด และตรวจว่าให้คะแนนครบก่อนส่ง
	emp, err := s.users.GetByID(e.EmployeeID)
	if err != nil {
		return nil, err
	}
	scores, total, err := s.buildScores(emp, cycle, scoreInputsFrom(e.Scores), true)
	if err != nil {
		return nil, err
	}
	e.TotalScore = total
	if err := s.evals.UpdateEvaluationWithScores(e, scores); err != nil {
		return nil, err
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
	// ใบประเมินตนเองไม่ต้องรออนุมัติ: คะแนนไม่ถูกนำไปคิดโบนัส/เลื่อนตำแหน่ง/โอนย้าย/อบรม
	if e.Type == domain.EvalTypeSelf {
		e.Status = domain.EvalStatusApproved
		e.ApprovedAt = &now
		if err := s.evals.UpdateEvaluation(e); err != nil {
			return nil, err
		}
		s.evals.CreateAuditLog(&domain.AuditLog{
			UserID: evaluatorID, Action: "auto_approve", Entity: "evaluation", EntityID: e.ID,
			Detail: "ใบประเมินตนเองอนุมัติอัตโนมัติเมื่อส่ง",
		})
	}
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
func (s *EvaluationService) ListDepartments() ([]domain.Department, error) {
	return s.evals.ListDepartments()
}

func (s *EvaluationService) ListLevels() ([]domain.Level, error) {
	return s.evals.ListLevels()
}

// ค่าว่าง = ทุกแผนก/ทุกระดับ จึงผ่านเสมอ ถ้ามีค่าต้องอยู่ในรายการหลัก
func (s *EvaluationService) validateDepartment(name string) error {
	if name == "" {
		return nil
	}
	ok, err := s.evals.DepartmentExists(name)
	if err != nil {
		return err
	}
	if !ok {
		return domain.ErrInvalidInput
	}
	return nil
}

func (s *EvaluationService) validateLevel(name string) error {
	if name == "" {
		return nil
	}
	ok, err := s.evals.LevelExists(name)
	if err != nil {
		return err
	}
	if !ok {
		return domain.ErrInvalidInput
	}
	return nil
}
func (s *EvaluationService) ListPositions() ([]domain.Position, error) {
	return s.evals.ListPositions()
}

// ผลการอนุมัติรายใบ
type BulkApproveResult struct {
	ID     uint   `json:"id"`
	OK     bool   `json:"ok"`
	Reason string `json:"reason,omitempty"`
}

// อนุมัติหลายใบ: เรียก Approve เดิมทีละใบ (สิทธิ์/สถานะ/audit log ชุดเดิม)
// ใบที่ไม่ผ่านไม่ทำให้ใบอื่นล้ม และรายงานเหตุผลกลับไปรายใบ
func (s *EvaluationService) ApproveMany(ids []uint, approverID uint, role domain.Role) []BulkApproveResult {
	results := make([]BulkApproveResult, 0, len(ids))
	for _, id := range ids {
		if _, err := s.Approve(id, approverID, role); err != nil {
			results = append(results, BulkApproveResult{ID: id, OK: false, Reason: err.Error()})
			continue
		}
		results = append(results, BulkApproveResult{ID: id, OK: true})
	}
	return results
}
