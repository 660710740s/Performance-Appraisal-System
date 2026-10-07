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

func (s *AccountingService) Candidates(cycleID uint) ([]BonusCandidate, error) {
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