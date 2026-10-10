package domain

import "time"

const (
	EvalStatusDraft     = "draft"
	EvalStatusSubmitted = "submitted"
	EvalStatusApproved  = "approved"
	EvalStatusRejected  = "rejected" // ถูกตีกลับให้แก้ไข

	EvalTypeSelf       = "self"
	EvalTypeSupervisor = "supervisor"

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
	Rubric      string  `gorm:"type:text" json:"rubric"`
	Department  string  `gorm:"size:100;index" json:"department"`
	Level       string  `gorm:"size:50" json:"level"`
}

// รายการหลักสำหรับ dropdown
type Department struct {
	ID   uint   `gorm:"primaryKey" json:"id"`
	Name string `gorm:"size:100;not null;uniqueIndex" json:"name"`
}

type Level struct {
	ID        uint   `gorm:"primaryKey" json:"id"`
	Name      string `gorm:"size:50;not null;uniqueIndex" json:"name"`
	SortOrder int    `gorm:"not null;default:0" json:"sort_order"`
}

type Evaluation struct {
	ID               uint              `gorm:"primaryKey" json:"id"`
	CycleID          uint              `gorm:"not null;uniqueIndex:idx_cycle_employee_type" json:"cycle_id"`
	EmployeeID       uint              `gorm:"not null;uniqueIndex:idx_cycle_employee_type" json:"employee_id"`
	Type             string            `gorm:"size:20;not null;default:supervisor;uniqueIndex:idx_cycle_employee_type" json:"type"`
	EvaluatorID      uint              `gorm:"not null;index" json:"evaluator_id"`
	Status           string            `gorm:"size:20;default:draft" json:"status"`
	TotalScore       float64           `json:"total_score"`
	Comment          string            `json:"comment"`
	EmployeeFeedback string            `json:"employee_feedback"`
	ApprovedBy       *uint             `json:"approved_by"`
	Scores           []EvaluationScore `gorm:"foreignKey:EvaluationID;constraint:OnDelete:CASCADE" json:"scores"`
	SubmittedAt      *time.Time        `json:"submitted_at"`
	ApprovedAt       *time.Time        `json:"approved_at"`
	CreatedAt        time.Time         `json:"created_at"`
	UpdatedAt        time.Time         `json:"updated_at"`
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
	UpdateCycle(c *EvaluationCycle) error

	CreateCriteria(c *Criteria) error
	ListCriteria() ([]Criteria, error)
	ListCriteriaFor(department, level string) ([]Criteria, error)
	ListPositions() ([]Position, error)
	PositionExists(name string) (bool, error)
	GetCriteria(id uint) (*Criteria, error)
	UpdateCriteria(c *Criteria) error

	// ใน type EvaluationRepository interface { ... } เพิ่ม
	ListDepartments() ([]Department, error)
	ListLevels() ([]Level, error)
	DepartmentExists(name string) (bool, error)
	LevelExists(name string) (bool, error)

	CreateEvaluation(e *Evaluation) error
	GetEvaluation(id uint) (*Evaluation, error)
	UpdateEvaluation(e *Evaluation) error
	// แก้ไขแบบประเมินพร้อมแทนที่คะแนนทั้งชุด (ทำใน transaction เดียว)
	UpdateEvaluationWithScores(e *Evaluation, scores []EvaluationScore) error
	ExistsFor(cycleID, employeeID uint, evalType string) (bool, error)
	ListByEmployee(employeeID uint) ([]Evaluation, error)
	ListByEvaluator(evaluatorID uint) ([]Evaluation, error)
	CountEvaluations() (int64, error)

	CreateAuditLog(a *AuditLog) error
}

type AuditLog struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	UserID    uint      `gorm:"not null;index" json:"user_id"`
	Action    string    `gorm:"size:50;not null" json:"action"`
	Entity    string    `gorm:"size:50;not null" json:"entity"`
	EntityID  uint      `gorm:"index" json:"entity_id"`
	Detail    string    `json:"detail"`
	CreatedAt time.Time `json:"created_at"`
}
type Position struct {
	ID   uint   `gorm:"primaryKey" json:"id"`
	Name string `gorm:"size:100;not null;uniqueIndex" json:"name"`
}
