package domain

import "time"

const (
	TaskStatusTodo = "todo"
	TaskStatusDone = "done"

	SourceManual         = "manual"
	SourceAutoCompletion = "auto_completion"
	SourceAutoOnTime     = "auto_ontime"
	SourceAutoQuality    = "auto_quality"
)

// งานของพนักงาน (ข้อมูลตั้งต้นสำหรับคำนวณ KPI อัตโนมัติ)
type Task struct {
	ID          uint       `gorm:"primaryKey" json:"id"`
	EmployeeID  uint       `gorm:"not null;index:idx_task_emp_due" json:"employee_id"`
	Title       string     `gorm:"size:255;not null" json:"title"`
	DueDate     time.Time  `gorm:"not null;index:idx_task_emp_due" json:"due_date"`
	CompletedAt *time.Time `json:"completed_at"`
	Status      string     `gorm:"size:20;not null;default:todo" json:"status"`
	Reviewed    bool       `gorm:"not null;default:false" json:"reviewed"`
	Revisions   int        `gorm:"not null;default:0" json:"revisions"`
	CreatedAt   time.Time  `json:"created_at"`
}

type TaskRepository interface {
	CreateTask(t *Task) error
	CreateTasks(ts []Task) error
	ListTasksDueBetween(employeeID uint, from, to time.Time) ([]Task, error)
}
