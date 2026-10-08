package domain

import "time"

const (
	CareerStatusPending  = "pending_approval"
	CareerStatusApproved = "approved"
	CareerStatusRejected = "rejected"

	TrainingStatusPlanned    = "planned"
	TrainingStatusInProgress = "in_progress"
	TrainingStatusCompleted  = "completed"
	TrainingStatusCancelled  = "cancelled"
)

// ข้อเสนอเลื่อนตำแหน่ง (ผูกกับแบบประเมินที่อนุมัติแล้ว 1 ใบ = 1 ข้อเสนอ)
// ไม่อัปเดตตำแหน่งของพนักงานอัตโนมัติ เป็นเพียงบันทึกการตัดสินใจ
type PromotionRequest struct {
	ID           uint       `gorm:"primaryKey" json:"id"`
	EvaluationID uint       `gorm:"not null;uniqueIndex:idx_promotion_evaluation" json:"evaluation_id"`
	CycleID      uint       `gorm:"not null;index" json:"cycle_id"`
	EmployeeID   uint       `gorm:"not null;index" json:"employee_id"`
	FromPosition string     `gorm:"size:100" json:"from_position"`
	ToPosition   string     `gorm:"size:100;not null" json:"to_position"`
	FromLevel    string     `gorm:"size:50" json:"from_level"`
	ToLevel      string     `gorm:"size:50" json:"to_level"`
	Status       string     `gorm:"size:20;not null;default:pending_approval" json:"status"`
	Note         string     `json:"note"`
	DecisionNote string     `json:"decision_note"`
	CreatedBy    uint       `gorm:"not null" json:"created_by"`
	DecidedBy    *uint      `json:"decided_by"`
	DecidedAt    *time.Time `json:"decided_at"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

// ข้อเสนอโอนย้ายแผนก (ผูกกับแบบประเมินที่อนุมัติแล้ว 1 ใบ = 1 ข้อเสนอ)
type TransferRequest struct {
	ID             uint       `gorm:"primaryKey" json:"id"`
	EvaluationID   uint       `gorm:"not null;uniqueIndex:idx_transfer_evaluation" json:"evaluation_id"`
	CycleID        uint       `gorm:"not null;index" json:"cycle_id"`
	EmployeeID     uint       `gorm:"not null;index" json:"employee_id"`
	FromDepartment string     `gorm:"size:100" json:"from_department"`
	ToDepartment   string     `gorm:"size:100;not null" json:"to_department"`
	EffectiveDate  *time.Time `json:"effective_date"`
	Status         string     `gorm:"size:20;not null;default:pending_approval" json:"status"`
	Note           string     `json:"note"`
	DecisionNote   string     `json:"decision_note"`
	CreatedBy      uint       `gorm:"not null" json:"created_by"`
	DecidedBy      *uint      `json:"decided_by"`
	DecidedAt      *time.Time `json:"decided_at"`
	CreatedAt      time.Time  `json:"created_at"`
	UpdatedAt      time.Time  `json:"updated_at"`
}

// แผนฝึกอบรมของพนักงาน (อ้างอิงแบบประเมิน แต่ 1 ใบมีได้หลายแผน)
type TrainingPlan struct {
	ID           uint       `gorm:"primaryKey" json:"id"`
	EvaluationID uint       `gorm:"not null;index" json:"evaluation_id"`
	EmployeeID   uint       `gorm:"not null;index" json:"employee_id"`
	Topic        string     `gorm:"size:255;not null" json:"topic"`
	Reason       string     `json:"reason"`
	StartDate    *time.Time `json:"start_date"`
	EndDate      *time.Time `json:"end_date"`
	Status       string     `gorm:"size:20;not null;default:planned" json:"status"`
	CreatedBy    uint       `gorm:"not null" json:"created_by"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}