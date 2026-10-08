package domain

type TrainingRepository interface {
	CreateTraining(t *TrainingPlan) error
	GetTraining(id uint) (*TrainingPlan, error)
	UpdateTraining(t *TrainingPlan) error
	// employeeIDs == nil คือไม่จำกัดพนักงาน (ใช้กับ HR)
	ListTraining(employeeIDs []uint, evaluationID uint, status string) ([]TrainingPlan, error)
}
