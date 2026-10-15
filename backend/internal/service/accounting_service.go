package service

import (
	"errors"
	"math"
	"time"

	"performance/backend/internal/domain"
)

type SetSalaryInput struct {
	EmployeeID    uint
	Amount        float64
	EffectiveDate time.Time
}

type BonusCandidate struct {
	EvaluationID    uint     `json:"evaluation_id"`
	CycleID         uint     `json:"cycle_id"`
	EmployeeID      uint     `json:"employee_id"`
	TotalScore      float64  `json:"total_score"`
	BaseSalary      *float64 `json:"base_salary"`      // nil = ยังไม่มีเงินเดือนในระบบ
	SuggestedAmount *float64 `json:"suggested_amount"` // nil = คำนวณไม่ได้
	Eligible        bool     `json:"eligible"`         // NEW: เสนอโบนัสได้ (ผ่านเกณฑ์และมีเงินเดือน)
	Reason          string   `json:"reason,omitempty"` // NEW: เหตุผลที่เสนอไม่ได้
}

// NEW: ผลการเสนอโบนัสแบบกลุ่ม
type BulkCreateSkip struct {
	EvaluationID uint   `json:"evaluation_id"`
	EmployeeID   uint   `json:"employee_id"`
	Reason       string `json:"reason"`
}

type BulkCreateResult struct {
	Created     int              `json:"created"`      // จำนวนที่เสนอสำเร็จ
	TotalAmount float64          `json:"total_amount"` // ยอดรวมที่เสนอ
	Skipped     []BulkCreateSkip `json:"skipped"`      // ที่ข้ามไป พร้อมเหตุผล
}

type AccountingService struct {
	acc   domain.AccountingRepository
	evals domain.EvaluationRepository
	users domain.UserRepository
}

func NewAccountingService(acc domain.AccountingRepository, evals domain.EvaluationRepository, users domain.UserRepository) *AccountingService {
	return &AccountingService{acc: acc, evals: evals, users: users}
}

// กติกาคำนวณโบนัส: คะแนนรวม -> กี่เท่าของเงินเดือน (แก้ตาม requirements ได้ที่นี่ที่เดียว)
func bonusMultiplier(score float64) float64 {
	switch {
	case score >= 4.5:
		return 2.0
	case score >= 4.0:
		return 1.5
	case score >= 3.0:
		return 1.0
	case score >= 2.0:
		return 0.5
	default:
		return 0
	}
}

func round2(v float64) float64 { return math.Round(v*100) / 100 }

// ---- Salary ----
func (s *AccountingService) SetSalary(by uint, in SetSalaryInput) (*domain.SalaryRecord, error) {
	if in.Amount <= 0 {
		return nil, domain.ErrInvalidInput
	}
	if _, err := s.users.GetByID(in.EmployeeID); err != nil {
		return nil, err
	}
	rec := &domain.SalaryRecord{
		EmployeeID: in.EmployeeID, Amount: in.Amount, EffectiveDate: in.EffectiveDate, CreatedBy: by,
	}
	if err := s.acc.CreateSalary(rec); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "set_salary", Entity: "salary", EntityID: rec.ID,
	})
	return rec, nil
}

func (s *AccountingService) SalaryHistory(employeeID uint) ([]domain.SalaryRecord, error) {
	return s.acc.ListSalaryHistory(employeeID)
}

func (s *AccountingService) ListCurrentSalaries() ([]domain.CurrentSalary, error) {
	return s.acc.ListCurrentSalaries()
}

// ---- Bonus ----
// คืน (เงินเดือน ณ สิ้นรอบ, ยอดที่เสนอ)
func (s *AccountingService) suggest(e *domain.Evaluation) (float64, float64, error) {
	cycle, err := s.evals.GetCycle(e.CycleID)
	if err != nil {
		return 0, 0, err
	}
	sal, err := s.acc.SalaryAt(e.EmployeeID, cycle.EndDate)
	if err != nil {
		return 0, 0, err
	}
	return sal.Amount, round2(sal.Amount * bonusMultiplier(e.TotalScore)), nil
}

// NEW: เสนอโบนัสได้หรือไม่ ถ้าไม่ได้คืนเหตุผล
// minScore = คะแนนขั้นต่ำที่ HR กำหนดเพิ่ม (nil = ใช้เกณฑ์ใน bonusMultiplier อย่างเดียว)
func eligibility(c *BonusCandidate, minScore *float64) (bool, string) {
	switch {
	case c.SuggestedAmount == nil:
		return false, "ยังไม่ตั้งเงินเดือน"
	case minScore != nil && c.TotalScore < *minScore:
		return false, "คะแนนต่ำกว่าเกณฑ์ขั้นต่ำที่กำหนด"
	case bonusMultiplier(c.TotalScore) == 0:
		return false, "คะแนนต่ำกว่าเกณฑ์ที่ได้รับโบนัส"
	}
	return true, ""
}

// signature เดิม ผู้เรียกเดิมไม่ต้องแก้
func (s *AccountingService) Candidates(cycleID uint) ([]BonusCandidate, error) {
	return s.CandidatesWithMinScore(cycleID, nil)
}

// NEW: รายชื่อที่อนุมัติแล้วและยังไม่ได้เสนอ พร้อมบอกว่าใครผ่านเกณฑ์ (Eligible) ใครไม่ผ่านเพราะอะไร
func (s *AccountingService) CandidatesWithMinScore(cycleID uint, minScore *float64) ([]BonusCandidate, error) {
	if minScore != nil && (*minScore < 1 || *minScore > 5) { // คะแนนประเมินมีค่า 1-5
		return nil, domain.ErrInvalidInput
	}
	list, err := s.acc.ListApprovedWithoutBonus(cycleID)
	if err != nil {
		return nil, err
	}
	out := make([]BonusCandidate, 0, len(list))
	for i := range list {
		e := &list[i]
		c := BonusCandidate{EvaluationID: e.ID, CycleID: e.CycleID, EmployeeID: e.EmployeeID, TotalScore: e.TotalScore}
		base, sug, err := s.suggest(e)
		if err == nil {
			c.BaseSalary, c.SuggestedAmount = &base, &sug
		} else if !errors.Is(err, domain.ErrNotFound) {
			return nil, err
		}
		c.Eligible, c.Reason = eligibility(&c, minScore)
		out = append(out, c)
	}
	return out, nil
}

func (s *AccountingService) CreateBonus(by, evaluationID uint, amount *float64, note string) (*domain.Bonus, error) {
	e, err := s.evals.GetEvaluation(evaluationID)
	if err != nil {
		return nil, err
	}
	if e.Type != domain.EvalTypeSupervisor || e.Status != domain.EvalStatusApproved {
		return nil, domain.ErrInvalidInput
	}
	if _, err := s.acc.GetBonusByEvaluation(evaluationID); err == nil {
		return nil, domain.ErrConflict
	} else if !errors.Is(err, domain.ErrNotFound) {
		return nil, err
	}

	base, suggested, err := s.suggest(e)
	if err != nil {
		if errors.Is(err, domain.ErrNotFound) {
			return nil, domain.ErrInvalidInput // ยังไม่มีเงินเดือนของพนักงานคนนี้
		}
		return nil, err
	}
	final := suggested
	if amount != nil {
		if *amount < 0 {
			return nil, domain.ErrInvalidInput
		}
		final = round2(*amount)
	}
	b := &domain.Bonus{
		EvaluationID: e.ID, CycleID: e.CycleID, EmployeeID: e.EmployeeID,
		BaseSalary: base, TotalScore: e.TotalScore, SuggestedAmount: suggested, Amount: final,
		Status: domain.BonusStatusPending, Note: note, CreatedBy: by,
	}
	if err := s.acc.CreateBonus(b); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "create", Entity: "bonus", EntityID: b.ID,
	})
	return b, nil
}

// NEW: เสนอโบนัสให้ทุกคนที่ผ่านเกณฑ์ในรอบนั้นทีเดียว ด้วยยอดที่ระบบเสนอ
// เรียก CreateBonus รายคน จึงได้กติกาตรวจสอบและ audit log รายคนเหมือนเดิม
// คนที่เสนอไม่ได้จะถูกข้ามพร้อมเหตุผล ไม่ทำให้ทั้งชุดล้ม
// ถ้าเกิด error ของระบบกลางทาง รายการที่สร้างไปแล้วคงอยู่ และกดซ้ำได้ (คนที่เสนอแล้วจะไม่อยู่ในรายชื่ออีก)
func (s *AccountingService) CreateBonusesBulk(by, cycleID uint, minScore *float64, note string) (*BulkCreateResult, error) {
	cands, err := s.CandidatesWithMinScore(cycleID, minScore)
	if err != nil {
		return nil, err
	}
	res := &BulkCreateResult{Skipped: []BulkCreateSkip{}}
	for i := range cands {
		c := &cands[i]
		skip := func(reason string) {
			res.Skipped = append(res.Skipped, BulkCreateSkip{EvaluationID: c.EvaluationID, EmployeeID: c.EmployeeID, Reason: reason})
		}
		if !c.Eligible {
			skip(c.Reason)
			continue
		}
		b, err := s.CreateBonus(by, c.EvaluationID, nil, note)
		if err != nil {
			switch {
			case errors.Is(err, domain.ErrConflict):
				skip("ถูกเสนอไปแล้ว")
				continue
			case errors.Is(err, domain.ErrInvalidInput), errors.Is(err, domain.ErrNotFound):
				skip("เสนอไม่ได้")
				continue
			}
			return nil, err
		}
		res.Created++
		res.TotalAmount += b.Amount
	}
	res.TotalAmount = round2(res.TotalAmount)
	return res, nil
}

// แก้ยอด: ทำได้เฉพาะ pending หรือ rejected แล้วส่งกลับไปรออนุมัติใหม่
func (s *AccountingService) UpdateBonus(by, id uint, amount float64, note string) (*domain.Bonus, error) {
	b, err := s.acc.GetBonus(id)
	if err != nil {
		return nil, err
	}
	if b.Status == domain.BonusStatusApproved {
		return nil, domain.ErrConflict
	}
	if amount < 0 {
		return nil, domain.ErrInvalidInput
	}
	b.Amount = round2(amount)
	b.Note = note
	b.Status = domain.BonusStatusPending
	b.DecidedBy, b.DecidedAt, b.DecisionNote = nil, nil, ""
	if err := s.acc.UpdateBonus(b); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: "update", Entity: "bonus", EntityID: b.ID,
	})
	return b, nil
}

func (s *AccountingService) Decide(by, id uint, approve bool, note string) (*domain.Bonus, error) {
	b, err := s.acc.GetBonus(id)
	if err != nil {
		return nil, err
	}
	if b.Status != domain.BonusStatusPending {
		return nil, domain.ErrConflict
	}
	now := time.Now()
	b.Status = domain.BonusStatusRejected
	action := "reject"
	if approve {
		b.Status = domain.BonusStatusApproved
		action = "approve"
	}
	b.DecidedBy, b.DecidedAt, b.DecisionNote = &by, &now, note
	if err := s.acc.UpdateBonus(b); err != nil {
		return nil, err
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: by, Action: action, Entity: "bonus", EntityID: b.ID,
	})
	return b, nil
}

func (s *AccountingService) ListBonuses(cycleID uint, status string) ([]domain.Bonus, error) {
	return s.acc.ListBonuses(cycleID, status)
}

// อนุมัติโบนัสหลายรายการ: เรียก Decide เดิมทีละรายการ (สถานะ/audit log ชุดเดิม)
// รายการที่ไม่ผ่านไม่ทำให้รายการอื่นล้ม และรายงานเหตุผลกลับไปรายรายการ
// (ของเดิมในโปรเจกต์ คงไว้ตามเดิม — BulkApproveResult ประกาศอยู่ที่อื่นแล้ว)
func (s *AccountingService) ApproveManyBonuses(by uint, ids []uint, note string) []BulkApproveResult {
	results := make([]BulkApproveResult, 0, len(ids))
	for _, id := range ids {
		if _, err := s.Decide(by, id, true, note); err != nil {
			results = append(results, BulkApproveResult{ID: id, OK: false, Reason: err.Error()})
			continue
		}
		results = append(results, BulkApproveResult{ID: id, OK: true})
	}
	return results
}

// PayBonus บันทึกการจ่ายเฉพาะโบนัสที่ผู้บริหารอนุมัติแล้ว
func (s *AccountingService) PayBonus(
	by, id uint,
	note string,
) (*domain.Bonus, error) {
	now := time.Now()

	updated, err := s.acc.MarkBonusPaid(id, by, now, note)
	if err != nil {
		return nil, err
	}
	if !updated {
		return nil, domain.ErrNotFound
	}

	return s.acc.GetBonus(id)
}
