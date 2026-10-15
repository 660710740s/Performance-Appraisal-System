package service

import "time"

// ผลคำนวณคะแนน auto ล่วงหน้า (ไม่บันทึกอะไร) ให้หน้าประเมินรู้ว่าข้อไหนระบบคำนวณได้
type KpiPreviewItem struct {
	Source  string  `json:"source"`
	Enough  bool    `json:"enough"`
	Score   int     `json:"score"`
	Percent float64 `json:"percent"`
	Detail  string  `json:"detail"`
}

func (s *EvaluationService) KpiPreview(userID, cycleID uint) ([]KpiPreviewItem, error) {
	if s.kpi == nil {
		return []KpiPreviewItem{}, nil
	}
	cycle, err := s.evals.GetCycle(cycleID)
	if err != nil {
		return nil, err
	}
	metrics, err := s.kpi.Compute(userID, cycle, time.Now())
	if err != nil {
		return nil, err
	}
	out := make([]KpiPreviewItem, 0, len(metrics))
	for src, m := range metrics {
		out = append(out, KpiPreviewItem{
			Source: src, Enough: m.Enough, Score: int(m.Score),
			Percent: float64(m.Percent), Detail: m.Detail(),
		})
	}
	return out, nil
}
