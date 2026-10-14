package main

import (
	"fmt"
	"log"
	"time"

	"gorm.io/gorm"

	"performance/backend/internal/domain"
)

// ข้อมูลจำลองสำหรับสาธิต KPI อัตโนมัติ (ไม่ใช่ข้อมูลจริง)
type kpiProfile struct {
	email            string
	n                int
	skipMod, skipRes int // งานที่ยังไม่เสร็จ: i%mod == res
	lateMod, lateRes int // งานที่ส่งล่าช้า
	revMod, revRes   int // งานที่ต้องแก้
}

func kpiHit(i, mod, res int) bool { return mod > 0 && i%mod == res }

func seedKpi(db *gorm.DB, users domain.UserRepository, evals domain.EvaluationRepository) {
	// 1) ปิดเกณฑ์ซอฟต์แวร์เดิมที่ซ้ำกับ KPI (ส่งมอบ/คุณภาพ)
	if err := db.Model(&domain.Criteria{}).
		Where("department = ? AND name IN ?", "พัฒนาซอฟต์แวร์",
			[]string{"คุณภาพโค้ดและการทดสอบ", "การส่งมอบตามสเปก"}).
		Update("is_active", false).Error; err != nil {
		log.Fatalf("kpi: ปิดเกณฑ์เดิม: %v", err)
	}

	// 2) เพิ่มเกณฑ์ auto 3 ข้อ
	existing, err := evals.ListCriteria()
	if err != nil {
		log.Fatal(err)
	}
	have := map[string]bool{}
	for _, c := range existing {
		have[c.Name+"|"+c.Department] = true
	}
	autos := []domain.Criteria{
		{Name: "ความสำเร็จของงาน (อัตโนมัติ)", Description: "งานที่ทำสำเร็จ ÷ งานที่ครบกำหนดในรอบ",
			Rubric: "5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)",
			Weight: 30, Source: domain.SourceAutoCompletion},
		{Name: "ส่งงานตรงเวลา (อัตโนมัติ)", Description: "งานที่ส่งตรงเวลา ÷ งานที่สำเร็จ",
			Rubric: "5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)",
			Weight: 25, Source: domain.SourceAutoOnTime},
		{Name: "คุณภาพงานผ่านตรวจครั้งแรก (อัตโนมัติ)", Description: "งานที่ผ่านตรวจครั้งแรก ÷ งานที่ตรวจแล้ว",
			Rubric: "5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)",
			Weight: 20, Source: domain.SourceAutoQuality},
	}
	for i := range autos {
		c := autos[i]
		c.Department, c.IsActive = "พัฒนาซอฟต์แวร์", true
		if have[c.Name+"|"+c.Department] {
			log.Printf("kpi skip criteria (exists): %s", c.Name)
			continue
		}
		if err := evals.CreateCriteria(&c); err != nil {
			log.Fatalf("kpi criteria %s: %v", c.Name, err)
		}
		log.Printf("kpi created criteria: %s", c.Name)
	}

	// 3) งานจำลองของ employee1-3 ในรอบ ครึ่งปีหลัง 2026 (ผลโดยประมาณ: คนที่ 1 ดีมาก, 2 กลางๆ, 3 ต่ำ)
	profiles := []kpiProfile{
		{"employee1@example.com", 20, 0, 0, 10, 9, 10, 4},
		{"employee2@example.com", 20, 5, 4, 6, 2, 4, 1},
		{"employee3@example.com", 18, 3, 2, 4, 1, 2, 0},
	}
	ict := time.FixedZone("ICT", 7*3600)
	start := time.Date(2026, 7, 6, 0, 0, 0, 0, ict)

	for _, p := range profiles {
		u, err := users.GetByEmail(p.email)
		if err != nil || u == nil {
			log.Fatalf("kpi: ไม่พบผู้ใช้ %s (รัน seed ปกติก่อน)", p.email)
		}
		var n int64
		db.Model(&domain.Task{}).Where("employee_id = ?", u.ID).Count(&n)
		if n > 0 {
			log.Printf("kpi skip tasks (exists): %s", p.email)
			continue
		}
		tasks := make([]domain.Task, 0, p.n)
		for i := 0; i < p.n; i++ {
			due := start.AddDate(0, 0, i*4)
			t := domain.Task{
				EmployeeID: u.ID, Title: fmt.Sprintf("งานที่ %d (ข้อมูลจำลอง)", i+1),
				DueDate: due, Status: domain.TaskStatusTodo,
			}
			if !kpiHit(i, p.skipMod, p.skipRes) {
				done := due.Add(10 * time.Hour) // ตรงเวลา: เสร็จภายในวันกำหนดส่ง
				if kpiHit(i, p.lateMod, p.lateRes) {
					done = due.AddDate(0, 0, 2).Add(10 * time.Hour) // ล่าช้า 2 วัน
				}
				t.Status, t.CompletedAt, t.Reviewed = domain.TaskStatusDone, &done, true
				if kpiHit(i, p.revMod, p.revRes) {
					t.Revisions = 1 + i%2
				}
			}
			tasks = append(tasks, t)
		}
		if err := db.CreateInBatches(&tasks, 100).Error; err != nil {
			log.Fatalf("kpi tasks %s: %v", p.email, err)
		}
		log.Printf("kpi created %d tasks: %s", len(tasks), p.email)
	}
	log.Println("kpi seed เสร็จสิ้น (ข้อมูลจำลอง)")
}
