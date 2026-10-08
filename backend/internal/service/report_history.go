package service

import "performance/backend/internal/domain"

// ประวัติผลประเมินของพนักงานหนึ่งคนข้ามรอบ
// - hr: ดูได้ทุกคน ทุกสถานะ
// - manager: ดูของตัวเองและลูกทีมโดยตรง เฉพาะที่ส่งแล้วหรืออนุมัติแล้ว
// - role อื่น: ดูได้เฉพาะของตัวเอง เฉพาะที่ส่งแล้วหรืออนุมัติแล้ว
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
	default:
		if viewerID != emp.ID {
			return nil, domain.ErrForbidden
		}
	}
	return s.reports.ListEmployeeEvaluationRows(employeeID, statuses)
}