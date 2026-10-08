package domain

import "time"

const (
	BonusStatusPending  = "pending_approval"
	BonusStatusApproved = "approved"
	BonusStatusRejected = "rejected"
)

// ประวัติเงินเดือน: 1 แถว = 1 การเปลี่ยนแปลง (มีวันที่มีผล)
type SalaryRecord struct {
	ID            uint      `gorm:"primaryKey" json:"id"`
	EmployeeID    uint      `gorm:"not null;uniqueIndex:idx_salary_emp_date" json:"employee_id"`
	Amount        float64   `gorm:"not null" json:"amount"`
	EffectiveDate time.Time `gorm:"not null;uniqueIndex:idx_salary_emp_date" json:"effective_date"`
	CreatedBy     uint      `gorm:"not null" json:"created_by"`
	CreatedAt     time.Time `json:"created_at"`
}

// โบนัส 1 รายการต่อ 1 ผลประเมิน (supervisor, approved)
type Bonus struct {
	ID              uint       `gorm:"primaryKey" json:"id"`
	EvaluationID    uint       `gorm:"not null;uniqueIndex" json:"evaluation_id"`
	CycleID         uint       `gorm:"not null;index" json:"cycle_id"`
	EmployeeID      uint       `gorm:"not null;index" json:"employee_id"`
	BaseSalary      float64    `json:"base_salary"`      // snapshot เงินเดือน ณ สิ้นรอบ
	TotalScore      float64    `json:"total_score"`      // snapshot คะแนน
	SuggestedAmount float64    `json:"suggested_amount"` // ยอดที่ระบบเสนอ
	Amount          float64    `json:"amount"`           // ยอดที่ Accounting ยืนยัน
	Status          string     `gorm:"size:20;default:pending_approval" json:"status"`
	Note            string     `json:"note"`          // หมายเหตุจาก Accounting
	DecisionNote    string     `json:"decision_note"` // หมายเหตุจาก Executive
	CreatedBy       uint       `gorm:"not null" json:"created_by"`
	DecidedBy       *uint      `json:"decided_by"`
	DecidedAt       *time.Time `json:"decided_at"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

// ผลลัพธ์ query รายการเงินเดือนปัจจุบัน (Amount เป็น nil ถ้ายังไม่เคยตั้ง)
type CurrentSalary struct {
	EmployeeID    uint       `json:"employee_id"`
	EmployeeName  string     `json:"employee_name"`
	Amount        *float64   `json:"amount"`
	EffectiveDate *time.Time `json:"effective_date"`
}

type AccountingRepository interface {
	CreateSalary(s *SalaryRecord) error
	SalaryAt(employeeID uint, at time.Time) (*SalaryRecord, error)
	ListSalaryHistory(employeeID uint) ([]SalaryRecord, error)
	ListCurrentSalaries() ([]CurrentSalary, error)

	CreateBonus(b *Bonus) error
	GetBonus(id uint) (*Bonus, error)
	GetBonusByEvaluation(evaluationID uint) (*Bonus, error)
	UpdateBonus(b *Bonus) error
	ListBonuses(cycleID uint, status string) ([]Bonus, error)
	ListApprovedWithoutBonus(cycleID uint) ([]Evaluation, error)
}
