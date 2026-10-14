package service

import "performance/backend/internal/domain"

// ประวัติผลประเมินของพนักงานหนึ่งคนข้ามรอบ
//   - hr: ดูได้ทุกคน ทุกสถานะ
//   - manager: ดูของตัวเองและลูกทีมโดยตรง เฉพาะที่ส่งแล้วหรืออนุมัติแล้ว
//   - role อื่น: ดูได้เฉพาะของตัวเอง เฉพาะที่ส่งแล้วหรืออนุมัติแล้ว
//   - hr: ดูได้ทุกสถานะ
//   - manager: ดูของตัวเองและลูกทีมโดยตรง เฉพาะที่ส่งแล้วหรืออนุมัติแล้ว
//     และเห็นร่าง/แบบที่ถูกตีกลับของแบบ supervisor ที่ตัวเองเป็นผู้ประเมินด้วย
//   - role อื่น: ดูได้เฉพาะของตัวเอง เฉพาะที่ส่งแล้วหรืออนุมัติแล้ว
func (s *ReportService) EmployeeHistory(viewerID uint, role domain.Role, employeeID uint) ([]domain.EvaluationRow, error) {
	emp, err := s.reports.GetUserByID(employeeID)
	if err != nil {
		return nil, err // ErrNotFound ถ้าไม่มีพนักงานคนนี้
	}

	statuses := []string{domain.EvalStatusSubmitted, domain.EvalStatusApproved}
	switch role {
	case domain.RoleHR:
		statuses = nil
	case domain.RoleManager:
		isDirectReport := emp.ManagerID != nil && *emp.ManagerID == viewerID
		if viewerID != emp.ID && !isDirectReport {
			return nil, domain.ErrForbidden
		}
		if isDirectReport {
			all, err := s.reports.ListEmployeeEvaluationRows(employeeID, nil)
			if err != nil {
				return nil, err
			}
			out := make([]domain.EvaluationRow, 0, len(all))
			for _, r := range all {
				published := r.Status == domain.EvalStatusSubmitted || r.Status == domain.EvalStatusApproved
				ownSupervisorForm := r.Type == string(domain.EvalTypeSupervisor) && r.EvaluatorID == viewerID
				if published || ownSupervisorForm {
					out = append(out, r)
				}
			}
			return out, nil
		}
	default:
		if viewerID != emp.ID {
			return nil, domain.ErrForbidden
		}
	}
	return s.reports.ListEmployeeEvaluationRows(employeeID, statuses)
}
