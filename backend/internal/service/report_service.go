package service

import (
	"sort"

	"performance/backend/internal/domain"
)

type ReportService struct {
	reports domain.ReportRepository
	evals   domain.EvaluationRepository
	acc     domain.AccountingRepository
}

func NewReportService(reports domain.ReportRepository, evals domain.EvaluationRepository, acc domain.AccountingRepository) *ReportService {
	return &ReportService{reports: reports, evals: evals, acc: acc}
}

func (s *ReportService) Summary(cycleID uint) (*domain.Summary, error) {
	// รอบ
	cycles, err := s.evals.ListCycles()
	if err != nil {
		return nil, err
	}
	if cycleID > 0 {
		if _, err := s.evals.GetCycle(cycleID); err != nil {
			return nil, err // ErrNotFound ถ้าไม่มีรอบนี้
		}
	}

	users, err := s.reports.ListUsers()
	if err != nil {
		return nil, err
	}
	userByID := make(map[uint]domain.User, len(users))
	totalPeople := 0
	for _, u := range users {
		userByID[u.ID] = u
		if u.IsActive && u.Role == domain.RoleEmployee {
			totalPeople++
		}
	}

	evals, err := s.reports.ListEvaluations(cycleID)
	if err != nil {
		return nil, err
	}

	// 1) คะแนนเฉลี่ยแยกแผนก (approved เท่านั้น)
	type agg struct {
		sum   float64
		count int
	}
	byDept := map[string]*agg{}
	for _, e := range evals {
		if e.Status != domain.EvalStatusApproved {
			continue
		}
		dept := userByID[e.EmployeeID].Department
		if dept == "" {
			dept = "ไม่ระบุ"
		}
		if byDept[dept] == nil {
			byDept[dept] = &agg{}
		}
		byDept[dept].sum += e.TotalScore
		byDept[dept].count++
	}
	departments := make([]domain.DepartmentScore, 0, len(byDept))
	for name, a := range byDept {
		departments = append(departments, domain.DepartmentScore{
			Department: name, EmployeeCount: a.count, AvgScore: round2(a.sum / float64(a.count)),
		})
	}
	sort.Slice(departments, func(i, j int) bool { return departments[i].Department < departments[j].Department })

	// 2) ความคืบหน้าต่อรอบ
	progressByCycle := map[uint]*domain.CycleProgress{}
	for _, c := range cycles {
		if cycleID > 0 && c.ID != cycleID {
			continue
		}
		progressByCycle[c.ID] = &domain.CycleProgress{CycleID: c.ID, CycleName: c.Name, TotalPeople: totalPeople}
	}
	for _, e := range evals {
		p := progressByCycle[e.CycleID]
		if p == nil {
			continue
		}
		switch e.Status {
		case domain.EvalStatusDraft:
			p.Draft++
		case domain.EvalStatusSubmitted:
			p.Submitted++
		case domain.EvalStatusApproved:
			p.Approved++
		}
	}
	progress := make([]domain.CycleProgress, 0, len(progressByCycle))
	for _, p := range progressByCycle {
		started := p.Draft + p.Submitted + p.Approved
		if p.TotalPeople > started {
			p.NotStarted = p.TotalPeople - started
		}
		progress = append(progress, *p)
	}
	sort.Slice(progress, func(i, j int) bool { return progress[i].CycleID < progress[j].CycleID })

	// 3) โบนัสแยกตามสถานะ (ครบทั้ง 3 สถานะเสมอ)
	bonuses, err := s.acc.ListBonuses(cycleID, "")
	if err != nil {
		return nil, err
	}
	stats := map[string]*domain.BonusStat{
		domain.BonusStatusPending:  {Status: domain.BonusStatusPending},
		domain.BonusStatusApproved: {Status: domain.BonusStatusApproved},
		domain.BonusStatusRejected: {Status: domain.BonusStatusRejected},
	}
	for _, b := range bonuses {
		if st := stats[b.Status]; st != nil {
			st.Count++
			st.TotalAmount = round2(st.TotalAmount + b.Amount)
		}
	}
	bonusStats := []domain.BonusStat{
		*stats[domain.BonusStatusPending],
		*stats[domain.BonusStatusApproved],
		*stats[domain.BonusStatusRejected],
	}

	return &domain.Summary{
		CycleID: cycleID, Departments: departments, Progress: progress, Bonuses: bonusStats,
	}, nil
}