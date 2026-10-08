package domain

import "time"

type DepartmentScore struct {
	Department    string  `json:"department"`
	EmployeeCount int     `json:"employee_count"`
	AvgScore      float64 `json:"avg_score"`
}

type CycleProgress struct {
	CycleID     uint   `json:"cycle_id"`
	CycleName   string `json:"cycle_name"`
	TotalPeople int    `json:"total_people"` // พนักงานที่ต้องถูกประเมิน (employee ที่ active)
	NotStarted  int    `json:"not_started"`
	Draft       int    `json:"draft"`
	Submitted   int    `json:"submitted"`
	Approved    int    `json:"approved"`
}

type BonusStat struct {
	Status      string  `json:"status"`
	Count       int     `json:"count"`
	TotalAmount float64 `json:"total_amount"`
}

type Summary struct {
	CycleID     uint              `json:"cycle_id"` // 0 = ทุกรอบ
	Departments []DepartmentScore `json:"departments"`
	Progress    []CycleProgress   `json:"progress"`
	Bonuses     []BonusStat       `json:"bonuses"`
}

// ---- รายงานประจำปี ----

type AnnualCycleScores struct {
	CycleID     uint              `json:"cycle_id"`
	CycleName   string            `json:"cycle_name"`
	Departments []DepartmentScore `json:"departments"`
}

type AnnualReport struct {
	Year        int                 `json:"year"`
	Cycles      []AnnualCycleScores `json:"cycles"`      // แยกรายรอบ
	Departments []DepartmentScore   `json:"departments"` // รวมทั้งปี
}

// ---- รายการแบบประเมินสำหรับ HR ----

type EvaluationFilter struct {
	CycleID    uint
	Status     string
	Type       string
	Department string
	Limit      int
	Offset     int
}

type EvaluationRow struct {
	ID            uint       `json:"id"`
	CycleID       uint       `json:"cycle_id"`
	CycleName     string     `json:"cycle_name"`
	EmployeeID    uint       `json:"employee_id"`
	EmployeeName  string     `json:"employee_name"`
	Department    string     `json:"department"`
	Level         string     `json:"level"`
	Type          string     `json:"type"`
	EvaluatorID   uint       `json:"evaluator_id"`
	EvaluatorName string     `json:"evaluator_name"`
	Status        string     `json:"status"`
	TotalScore    float64    `json:"total_score"`
	SubmittedAt   *time.Time `json:"submitted_at"`
	ApprovedAt    *time.Time `json:"approved_at"`
}

// ---- Audit log ----

type AuditFilter struct {
	Entity   string
	EntityID uint
	UserID   uint
	Limit    int
	Offset   int
}

type ReportRepository interface {
	ListEvaluations(cycleID uint) ([]Evaluation, error)
	ListUsers() ([]User, error)
	ListEvaluationRows(f EvaluationFilter) ([]EvaluationRow, error)
	ListAuditLogs(f AuditFilter) ([]AuditLog, error)
}