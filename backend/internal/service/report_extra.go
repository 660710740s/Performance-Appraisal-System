package service

import (
	"sort"

	"performance/backend/internal/domain"
)

const (
	defaultPageSize = 100
	maxPageSize     = 500
)

func normalizePage(limit, offset int) (int, int) {
	if limit <= 0 {
		limit = defaultPageSize
	}
	if limit > maxPageSize {
		limit = maxPageSize
	}
	if offset < 0 {
		offset = 0
	}
	return limit, offset
}

// รายการแบบประเมินทั้งหมด (สำหรับ HR)
func (s *ReportService) EvaluationList(f domain.EvaluationFilter) ([]domain.EvaluationRow, error) {
	switch f.Status {
	case "", domain.EvalStatusDraft, domain.EvalStatusSubmitted, domain.EvalStatusApproved, domain.EvalStatusRejected:
	default:
		return nil, domain.ErrInvalidInput
	}
	switch f.Type {
	case "", domain.EvalTypeSelf, domain.EvalTypeSupervisor:
	default:
		return nil, domain.ErrInvalidInput
	}
	f.Limit, f.Offset = normalizePage(f.Limit, f.Offset)
	return s.reports.ListEvaluationRows(f)
}

// ประวัติการทำรายการ (สำหรับ HR)
func (s *ReportService) AuditLogs(f domain.AuditFilter) ([]domain.AuditLog, error) {
	f.Limit, f.Offset = normalizePage(f.Limit, f.Offset)
	return s.reports.ListAuditLogs(f)
}

// ---- รายงานประจำปี ----

type annualAgg struct {
	sum       float64
	n         int
	employees map[uint]bool
}

func addAnnual(m map[string]*annualAgg, dept string, e domain.Evaluation) {
	a := m[dept]
	if a == nil {
		a = &annualAgg{employees: map[uint]bool{}}
		m[dept] = a
	}
	a.sum += e.TotalScore
	a.n++
	a.employees[e.EmployeeID] = true
}

func annualScores(m map[string]*annualAgg) []domain.DepartmentScore {
	out := make([]domain.DepartmentScore, 0, len(m))
	for name, a := range m {
		out = append(out, domain.DepartmentScore{
			Department: name, EmployeeCount: len(a.employees), AvgScore: round2(a.sum / float64(a.n)),
		})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Department < out[j].Department })
	return out
}

// คะแนนเฉลี่ยแยกแผนกทั้งปี และแยกรายรอบ (นับเฉพาะแบบที่อนุมัติแล้ว)
// รอบที่นับเป็นของปีนี้ คือรอบที่วันเริ่มต้นอยู่ในปีนั้น
func (s *ReportService) Annual(year int) (*domain.AnnualReport, error) {
	if year < 2000 || year > 2100 {
		return nil, domain.ErrInvalidInput
	}
	cycles, err := s.evals.ListCycles()
	if err != nil {
		return nil, err
	}
	inYear := map[uint]domain.EvaluationCycle{}
	for _, c := range cycles {
		if c.StartDate.Year() == year {
			inYear[c.ID] = c
		}
	}

	users, err := s.reports.ListUsers()
	if err != nil {
		return nil, err
	}
	deptOf := make(map[uint]string, len(users))
	for _, u := range users {
		deptOf[u.ID] = u.Department
	}

	evals, err := s.reports.ListEvaluations(0)
	if err != nil {
		return nil, err
	}

	perCycle := map[uint]map[string]*annualAgg{}
	overall := map[string]*annualAgg{}
	for _, e := range evals {
		if e.Status != domain.EvalStatusApproved {
			continue
		}
		if _, ok := inYear[e.CycleID]; !ok {
			continue
		}
		dept := deptOf[e.EmployeeID]
		if dept == "" {
			dept = "ไม่ระบุ"
		}
		if perCycle[e.CycleID] == nil {
			perCycle[e.CycleID] = map[string]*annualAgg{}
		}
		addAnnual(perCycle[e.CycleID], dept, e)
		addAnnual(overall, dept, e)
	}

	ids := make([]uint, 0, len(inYear))
	for id := range inYear {
		ids = append(ids, id)
	}
	sort.Slice(ids, func(i, j int) bool { return ids[i] < ids[j] })

	cycleScores := make([]domain.AnnualCycleScores, 0, len(ids))
	for _, id := range ids {
		cycleScores = append(cycleScores, domain.AnnualCycleScores{
			CycleID: id, CycleName: inYear[id].Name, Departments: annualScores(perCycle[id]),
		})
	}
	return &domain.AnnualReport{Year: year, Cycles: cycleScores, Departments: annualScores(overall)}, nil
}