package service

import (
	"fmt"
	"time"

	"performance/backend/internal/domain"
)

// ต้องมีงานในตัวหารอย่างน้อยเท่านี้ ถึงจะคำนวณอัตโนมัติ (น้อยกว่านี้ให้หัวหน้าให้คะแนนเอง)
const kpiMinSample = 3

var kpiZone = time.FixedZone("ICT", 7*3600)

type KpiMetric struct {
	Source  string
	Percent float64
	Num     int
	Den     int
	Score   int  // 1-5
	Enough  bool // ข้อมูลพอสำหรับคำนวณอัตโนมัติ
}

func (m KpiMetric) Detail() string {
	return fmt.Sprintf("%d/%d งาน (%.1f%%)", m.Num, m.Den, m.Percent)
}

// กติกาแปลง % เป็นคะแนน 1-5 (แก้ได้ที่นี่ที่เดียว)
func percentToScore(p float64) int {
	switch {
	case p >= 90:
		return 5
	case p >= 80:
		return 4
	case p >= 70:
		return 3
	case p >= 60:
		return 2
	}
	return 1
}

// เวลาสิ้นสุดของวันกำหนดส่ง (เวลาไทย) ส่งก่อนเวลานี้ถือว่าตรงเวลา
func dueDayEnd(t time.Time) time.Time {
	l := t.In(kpiZone)
	return time.Date(l.Year(), l.Month(), l.Day()+1, 0, 0, 0, 0, kpiZone)
}

type KpiService struct {
	tasks domain.TaskRepository
}

func NewKpiService(tasks domain.TaskRepository) *KpiService { return &KpiService{tasks: tasks} }

func newMetric(source string, num, den int) KpiMetric {
	m := KpiMetric{Source: source, Num: num, Den: den, Enough: den >= kpiMinSample}
	if den > 0 {
		m.Percent = round2(float64(num) / float64(den) * 100)
	}
	m.Score = percentToScore(m.Percent)
	return m
}

// คำนวณ KPI ของพนักงานในช่วงของรอบ (นับเฉพาะงานที่กำหนดส่งอยู่ในรอบ)
func (s *KpiService) Compute(employeeID uint, cycle *domain.EvaluationCycle, now time.Time) (map[string]KpiMetric, error) {
	tasks, err := s.tasks.ListTasksDueBetween(employeeID, cycle.StartDate, dueDayEnd(cycle.EndDate))
	if err != nil {
		return nil, err
	}
	return calcKpi(tasks, now), nil
}

// ฟังก์ชันล้วนๆ ทดสอบง่าย
func calcKpi(tasks []domain.Task, now time.Time) map[string]KpiMetric {
	var due, done, onTime, reviewed, firstPass int
	for _, t := range tasks {
		finished := t.Status == domain.TaskStatusDone && t.CompletedAt != nil
		// "ครบกำหนด" = เลยวันกำหนดส่งแล้ว หรือทำเสร็จแล้ว
		if !finished && dueDayEnd(t.DueDate).After(now) {
			continue
		}
		due++
		if !finished {
			continue
		}
		done++
		if t.CompletedAt.Before(dueDayEnd(t.DueDate)) {
			onTime++
		}
		if t.Reviewed {
			reviewed++
			if t.Revisions == 0 {
				firstPass++
			}
		}
	}
	return map[string]KpiMetric{
		domain.SourceAutoCompletion: newMetric(domain.SourceAutoCompletion, done, due),
		domain.SourceAutoOnTime:     newMetric(domain.SourceAutoOnTime, onTime, done),
		domain.SourceAutoQuality:    newMetric(domain.SourceAutoQuality, firstPass, reviewed),
	}
}

// ผูก KpiService เข้ากับ EvaluationService (ไม่ผูก = เกณฑ์ auto ต้องกรอกเอง)
func (s *EvaluationService) WithKpi(k *KpiService) *EvaluationService {
	s.kpi = k
	return s
}
