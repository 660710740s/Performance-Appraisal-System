package domain

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

type ReportRepository interface {
	ListEvaluations(cycleID uint) ([]Evaluation, error)
	ListUsers() ([]User, error)
}
