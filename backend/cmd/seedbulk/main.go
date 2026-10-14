package main

import (
	"fmt"
	"log"
	"math/rand"
	"os"
	"strconv"
	"time"

	"performance/backend/configs"
	"performance/backend/internal/domain"
	"performance/backend/internal/repository"
	"performance/backend/internal/service"
)

// ข้อมูลจำลองสำหรับทดสอบระบบเมื่อมีพนักงานหลายร้อยคน (ไม่ใช่ข้อมูลจริง)
// อีเมลขึ้นต้นด้วย bulk. เพื่อแยกออกจากข้อมูลอื่นและลบได้ง่าย
const perTeam = 20

type tier struct{ done, late, rev int } // เปอร์เซ็นต์โอกาสที่งานเสร็จ / ส่งช้า / ต้องแก้

var tiers = []tier{{98, 10, 10}, {85, 20, 25}, {65, 35, 45}}

var (
	softwarePositions  = []string{"Software Engineer", "QA Engineer"}
	marketingPositions = []string{"Content Marketer", "Marketing Executive", "Graphic Designer"}
)

func teamDept(team int) (dept, mgrPosition string, positions []string) {
	if team%10 >= 7 {
		return "การตลาด", "Marketing Manager", marketingPositions
	}
	return "พัฒนาซอฟต์แวร์", "Engineering Manager", softwarePositions
}

func levelFor(e int) string {
	switch {
	case e%10 <= 5:
		return "junior"
	case e%10 <= 8:
		return "senior"
	}
	return "lead"
}

func genTasks(empID uint, e int, start time.Time) []domain.Task {
	r := rand.New(rand.NewSource(int64(e)))
	p := r.Intn(100)
	t := tiers[2]
	if p < 30 {
		t = tiers[0]
	} else if p < 75 {
		t = tiers[1]
	}
	n := 15 + r.Intn(11)
	if e%25 == 0 {
		n = 2 // ทดสอบกรณีข้อมูลงานไม่พอ (ต่ำกว่า 3 งาน)
	}
	tasks := make([]domain.Task, 0, n)
	for i := 0; i < n; i++ {
		due := start.AddDate(0, 0, i*4)
		task := domain.Task{
			EmployeeID: empID,
			Title:      fmt.Sprintf("งานที่ %d (ข้อมูลจำลอง)", i+1),
			DueDate:    due,
			Status:     domain.TaskStatusTodo,
		}
		if r.Intn(100) < t.done {
			done := due.Add(10 * time.Hour)
			if r.Intn(100) < t.late {
				done = due.AddDate(0, 0, 2).Add(10 * time.Hour)
			}
			task.Status, task.CompletedAt, task.Reviewed = domain.TaskStatusDone, &done, true
			if r.Intn(100) < t.rev {
				task.Revisions = 1 + r.Intn(2)
			}
		}
		tasks = append(tasks, task)
	}
	return tasks
}

func main() {
	password := os.Getenv("SEED_PASSWORD")
	if len(password) < 8 {
		log.Fatal("ตั้ง SEED_PASSWORD (อย่างน้อย 8 ตัวอักษร) ก่อนรัน")
	}
	total := 300
	if v := os.Getenv("BULK_EMPLOYEES"); v != "" {
		n, err := strconv.Atoi(v)
		if err != nil || n < 1 || n > 5000 {
			log.Fatal("BULK_EMPLOYEES ต้องเป็นตัวเลข 1-5000")
		}
		total = n
	}

	cfg := configs.Load()
	db, err := repository.NewDB(cfg.DSN())
	if err != nil {
		log.Fatalf("cannot connect to database: %v", err)
	}
	sqlDB, _ := db.DB()
	defer sqlDB.Close()

	userRepo := repository.NewUserRepository(db)
	taskRepo := repository.NewTaskRepository(db)
	userSvc := service.NewUserService(userRepo)

	ict := time.FixedZone("ICT", 7*3600)
	start := time.Date(2026, 7, 6, 0, 0, 0, 0, ict)
	teams := (total + perTeam - 1) / perTeam

	// หัวหน้าทีม
	mgrIDs := make([]uint, teams+1)
	for m := 1; m <= teams; m++ {
		email := fmt.Sprintf("bulk.mgr%02d@example.com", m)
		if ex, _ := userRepo.GetByEmail(email); ex != nil {
			mgrIDs[m] = ex.ID
			continue
		}
		dept, pos, _ := teamDept(m)
		created, err := userSvc.Create(service.CreateUserInput{
			EmployeeCode: fmt.Sprintf("BM%02d", m), Name: fmt.Sprintf("หัวหน้าทดสอบ %02d", m),
			Email: email, Password: password, Role: domain.RoleManager,
			Department: dept, Position: pos,
		})
		if err != nil {
			log.Fatalf("create manager %s: %v", email, err)
		}
		mgrIDs[m] = created.ID
	}

	// พนักงานและงานจำลอง
	createdUsers, createdTasks := 0, 0
	for e := 1; e <= total; e++ {
		team := (e-1)/perTeam + 1
		dept, _, positions := teamDept(team)
		email := fmt.Sprintf("bulk.emp%04d@example.com", e)

		var empID uint
		if ex, _ := userRepo.GetByEmail(email); ex != nil {
			empID = ex.ID
		} else {
			mid := mgrIDs[team]
			created, err := userSvc.Create(service.CreateUserInput{
				EmployeeCode: fmt.Sprintf("BE%04d", e), Name: fmt.Sprintf("พนักงานทดสอบ %04d", e),
				Email: email, Password: password, Role: domain.RoleEmployee,
				Department: dept, Position: positions[e%len(positions)], Level: levelFor(e),
				ManagerID: &mid,
			})
			if err != nil {
				log.Fatalf("create employee %s: %v", email, err)
			}
			empID = created.ID
			createdUsers++
		}

		var n int64
		db.Model(&domain.Task{}).Where("employee_id = ?", empID).Count(&n)
		if n > 0 {
			continue
		}
		tasks := genTasks(empID, e, start)
		if err := taskRepo.CreateTasks(tasks); err != nil {
			log.Fatalf("create tasks %s: %v", email, err)
		}
		createdTasks += len(tasks)
		if e%50 == 0 {
			log.Printf("progress: %d/%d", e, total)
		}
	}
	log.Printf("bulk seed เสร็จสิ้น: ผู้ใช้ใหม่ %d คน, งานใหม่ %d รายการ (ข้อมูลจำลอง)", createdUsers, createdTasks)
}