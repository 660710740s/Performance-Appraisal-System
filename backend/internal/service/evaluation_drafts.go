package service

import (
	"errors"
	"time"

	"performance/backend/internal/domain"
)

// สรุปผลการสร้างร่างทั้งรอบ
type DraftGenSummary struct {
	Created                   int    `json:"created"`
	AlreadyExists             int    `json:"already_exists"`
	SkippedNoManager          int    `json:"skipped_no_manager"`
	SkippedManagerNotEligible int    `json:"skipped_manager_not_eligible"`
	Failed                    int    `json:"failed"`
	FirstError                string `json:"first_error,omitempty"`
}

// สร้างร่างแบบประเมิน supervisor ให้พนักงานทุกคนในรอบที่ยังเปิด
// ร่างมีคะแนน auto ที่คำนวณจากข้อมูลงาน ส่วนข้อ manual ยังเป็น 0 จนกว่าหัวหน้าจะกรอก
// รันซ้ำได้ปลอดภัย คนที่มีแบบอยู่แล้วจะถูกข้าม
func (s *EvaluationService) GenerateDrafts(actorID, cycleID uint) (*DraftGenSummary, error) {
	cycle, err := s.evals.GetCycle(cycleID)
	if err != nil {
		return nil, err
	}
	if !cycleAcceptsEvaluation(cycle, time.Now()) {
		return nil, domain.ErrInvalidInput
	}
	all, err := s.users.List()
	if err != nil {
		return nil, err
	}
	byID := make(map[uint]domain.User, len(all))
	for _, u := range all {
		byID[u.ID] = u
	}

	sum := &DraftGenSummary{}
	for _, u := range all {
		if !u.IsActive || (u.Role != domain.RoleEmployee && u.Role != domain.RoleManager) {
			continue
		}
		if u.ManagerID == nil {
			sum.SkippedNoManager++
			continue
		}
		mgr, ok := byID[*u.ManagerID]
		if !ok || !mgr.IsActive || (mgr.Role != domain.RoleManager && mgr.Role != domain.RoleHR) {
			sum.SkippedManagerNotEligible++
			continue
		}
		_, err := s.Create(mgr.ID, mgr.Role, CreateEvaluationInput{
			CycleID:    cycleID,
			EmployeeID: u.ID,
			Type:       domain.EvalTypeSupervisor,
		})
		switch {
		case err == nil:
			sum.Created++
		case errors.Is(err, domain.ErrConflict):
			sum.AlreadyExists++
		default:
			sum.Failed++
			if sum.FirstError == "" {
				sum.FirstError = err.Error()
			}
		}
	}
	s.evals.CreateAuditLog(&domain.AuditLog{
		UserID: actorID, Action: "generate_drafts", Entity: "cycle", EntityID: cycleID,
	})
	return sum, nil
}
