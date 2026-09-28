package domain

import "time"

const (
	EvalStatusDraft     = "draft"
	EvalStatusSubmitted = "submitted"

	CycleStatusOpen   = "open"
	CycleStatusClosed = "closed"
)

// รอบการประเมิน เช่น "ครึ่งปีแรก 2026"
type EvaluationCycle struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Name      string    `gorm:"size:255;not null" json:"name"`
	StartDate time.Time `json:"start_date"`
	EndDate   time.Time `json:"end_date"`
	Status    string    `gorm:"size:20;default:open" json:"status"`
	CreatedAt time.Time `json:"created_at"`
}

// เกณฑ์การประเมิน พร้อมน้ำหนักคะแนน
type Criteria struct {
	ID          uint    `gorm:"primaryKey" json:"id"`
	Name        string  `gorm:"size:255;not null" json:"name"`
	Description string  `json:"description"`
	Weight      float64 `gorm:"not null;default:1" json:"weight"`
	IsActive    bool    `gorm:"default:true" json:"is_active"`
}

type Evaluation struct {
	ID          uint              `gorm:"primaryKey" json:"id"`
	CycleID     uint              `gorm:"not null;uniqueIndex:idx_cycle_employee" json:"cycle_id"`
	EmployeeID  uint              `gorm:"not null;uniqueIndex:idx_cycle_employee" json:"employee_id"`
	EvaluatorID uint              `gorm:"not null;index" json:"evaluator_id"`
	Status      string            `gorm:"size:20;default:draft" json:"status"`
	TotalScore  float64           `json:"total_score"`
	Comment     string            `json:"comment"`
	Scores      []EvaluationScore `gorm:"foreignKey:EvaluationID;constraint:OnDelete:CASCADE" json:"scores"`
	SubmittedAt *time.Time        `json:"submitted_at"`
	CreatedAt   time.Time         `json:"created_at"`
	UpdatedAt   time.Time         `json:"updated_at"`
}

type EvaluationScore struct {
	ID           uint   `gorm:"primaryKey" json:"id"`
	EvaluationID uint   `gorm:"not null;index" json:"evaluation_id"`
	CriteriaID   uint   `gorm:"not null" json:"criteria_id"`
	Score        int    `gorm:"not null" json:"score"` // 1-5
	Comment      string `json:"comment"`
}

type EvaluationRepository interface {
	CreateCycle(c *EvaluationCycle) error
	ListCycles() ([]EvaluationCycle, error)
	GetCycle(id uint) (*EvaluationCycle, error)

	CreateCriteria(c *Criteria) error
	ListCriteria() ([]Criteria, error)

	CreateEvaluation(e *Evaluation) error
	GetEvaluation(id uint) (*Evaluation, error)
	UpdateEvaluation(e *Evaluation) error
	ExistsFor(cycleID, employeeID uint) (bool, error)
	ListByEmployee(employeeID uint) ([]Evaluation, error)
	ListByEvaluator(evaluatorID uint) ([]Evaluation, error)
}
