package main

import (
	"log"
	"os"
	"time"

	"performance/backend/configs"
	"performance/backend/internal/domain"
	"performance/backend/internal/repository"
	"performance/backend/internal/service"
)

type seedUser struct {
	Code, Name, Email string
	Role              domain.Role
	Dept, Position    string
	Level             string
	ManagerEmail      string // ว่าง = ไม่มีหัวหน้า
}

func su(code, name, email string, role domain.Role, dept, position, level, mgr string) seedUser {
	return seedUser{Code: code, Name: name, Email: email, Role: role, Dept: dept, Position: position, Level: level, ManagerEmail: mgr}
}

type seedCriteria struct {
	Name, Desc, Rubric, Dept, Level string
	Weight                          float64
}

func main() {
	password := os.Getenv("SEED_PASSWORD")
	if len(password) < 8 {
		log.Fatal("ตั้ง SEED_PASSWORD (อย่างน้อย 8 ตัวอักษร) ก่อนรัน เช่น SEED_PASSWORD='...' go run ./cmd/seed")
	}

	cfg := configs.Load()
	db, err := repository.NewDB(cfg.DSN())
	if err != nil {
		log.Fatalf("cannot connect to database: %v", err)
	}
	sqlDB, _ := db.DB()
	defer sqlDB.Close()

	userRepo := repository.NewUserRepository(db)
	evalRepo := repository.NewEvaluationRepository(db)
	userSvc := service.NewUserService(userRepo)

	// ---- Users (หัวหน้าต้องอยู่ก่อนลูกทีมในลิสต์) ----
	users := []seedUser{
		su("HR001", "สมหญิง ใจดี", "hr@example.com", domain.RoleHR, "ทรัพยากรบุคคล", "HR Manager", "", ""),
		su("EX001", "วิชัย มั่นคง", "executive@example.com", domain.RoleExecutive, "บริหาร", "ผู้อำนวยการ", "", ""),
		su("AC001", "นภา บัญชีดี", "accounting@example.com", domain.RoleAccounting, "บัญชี", "นักบัญชีอาวุโส", "", ""),
		su("MG001", "สมชาย หัวหน้า", "manager1@example.com", domain.RoleManager, "พัฒนาซอฟต์แวร์", "Engineering Manager", "", ""),
		su("MG002", "ปราณี นำทีม", "manager2@example.com", domain.RoleManager, "การตลาด", "Marketing Manager", "", ""),
		su("EM001", "อนุชา ขยันงาน", "employee1@example.com", domain.RoleEmployee, "พัฒนาซอฟต์แวร์", "Software Engineer", "senior", "manager1@example.com"),
		su("EM002", "กัญญา เรียนรู้", "employee2@example.com", domain.RoleEmployee, "พัฒนาซอฟต์แวร์", "Software Engineer", "junior", "manager1@example.com"),
		su("EM003", "ธนา ตั้งใจ", "employee3@example.com", domain.RoleEmployee, "พัฒนาซอฟต์แวร์", "QA Engineer", "junior", "manager1@example.com"),
		su("EM004", "พิมพ์ใจ สร้างสรรค์", "employee4@example.com", domain.RoleEmployee, "การตลาด", "Content Marketer", "senior", "manager2@example.com"),
		su("EM005", "ศิริพร ประสานงาน", "employee5@example.com", domain.RoleEmployee, "การตลาด", "Marketing Executive", "junior", "manager2@example.com"),
		su("EM006", "ณัฐพล พัฒนา", "employee6@example.com", domain.RoleEmployee, "การตลาด", "Graphic Designer", "junior", "manager2@example.com"),
	}

	idByEmail := map[string]uint{}
	for _, u := range users {
		if existing, _ := userRepo.GetByEmail(u.Email); existing != nil {
			idByEmail[u.Email] = existing.ID
			if existing.EmployeeCode == u.Code && u.Level != "" && existing.Level != u.Level {
				existing.Level = u.Level
				if err := userRepo.Update(existing); err != nil {
					log.Fatalf("update level %s: %v", u.Email, err)
				}
				log.Printf("set level (%s): %s", u.Level, u.Email)
			} else {
				log.Printf("skip user (exists): %s", u.Email)
			}
			continue
		}
		var managerID *uint
		if u.ManagerEmail != "" {
			id, ok := idByEmail[u.ManagerEmail]
			if !ok {
				log.Fatalf("manager not found for %s: %s", u.Email, u.ManagerEmail)
			}
			managerID = &id
		}
		created, err := userSvc.Create(service.CreateUserInput{
			EmployeeCode: u.Code, Name: u.Name, Email: u.Email, Password: password,
			Role: u.Role, Department: u.Dept, Position: u.Position, Level: u.Level, ManagerID: managerID,
		})
		if err != nil {
			log.Fatalf("create user %s: %v", u.Email, err)
		}
		idByEmail[u.Email] = created.ID
		log.Printf("created user: %s (id=%d)", u.Email, created.ID)
	}

	// ---- Cycles (สร้างเฉพาะเมื่อยังไม่มีรอบใดเลย) ----
	existingCycles, err := evalRepo.ListCycles()
	if err != nil {
		log.Fatal(err)
	}
	if len(existingCycles) == 0 {
		cycles := []domain.EvaluationCycle{
			{Name: "ครึ่งปีหลัง 2025", StartDate: time.Date(2025, 7, 1, 0, 0, 0, 0, time.UTC), EndDate: time.Date(2025, 12, 31, 0, 0, 0, 0, time.UTC), Status: domain.CycleStatusClosed},
			{Name: "ครึ่งปีแรก 2026", StartDate: time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC), EndDate: time.Date(2026, 6, 30, 0, 0, 0, 0, time.UTC), Status: domain.CycleStatusClosed},
			{Name: "ครึ่งปีหลัง 2026", StartDate: time.Date(2026, 7, 1, 0, 0, 0, 0, time.UTC), EndDate: time.Date(2026, 12, 31, 0, 0, 0, 0, time.UTC), Status: domain.CycleStatusOpen},
		}
		for i := range cycles {
			if err := evalRepo.CreateCycle(&cycles[i]); err != nil {
				log.Fatalf("create cycle: %v", err)
			}
			log.Printf("created cycle: %s", cycles[i].Name)
		}
	} else {
		log.Println("skip cycles (already exist)")
	}

	// ---- Criteria (เกณฑ์กลาง + ตามแผนก + ตามระดับ) ----
	existingCriteria, err := evalRepo.ListCriteria()
	if err != nil {
		log.Fatal(err)
	}
	have := map[string]bool{}
	for _, c := range existingCriteria {
		have[c.Name+"|"+c.Department+"|"+c.Level] = true
	}

	criteria := []seedCriteria{
		// เกณฑ์กลาง ใช้กับทุกแผนก (รวม 45)
		{"ความรับผิดชอบ", "ส่งมอบงานตรงเวลาและรับผิดชอบต่อหน้าที่",
			"5 = ส่งตรงเวลาทุกงานและรับงานเพิ่มเอง, 3 = ส่งล่าช้าเป็นบางครั้ง, 1 = ส่งล่าช้าบ่อยหรือต้องตามงานตลอด", "", "", 20},
		{"การทำงานเป็นทีม", "ร่วมมือ สื่อสาร และสนับสนุนเพื่อนร่วมงาน",
			"5 = ช่วยทีมสำเร็จอย่างสม่ำเสมอ, 3 = ร่วมมือตามที่ได้รับมอบหมาย, 1 = ทำงานแยกจากทีมหรือเกิดความขัดแย้งบ่อย", "", "", 15},
		{"การพัฒนาตนเอง", "เรียนรู้ทักษะใหม่และปรับปรุงการทำงานอย่างต่อเนื่อง",
			"5 = พัฒนาทักษะใหม่และนำมาใช้งานได้จริงหลายครั้ง, 3 = เรียนรู้ตามที่งานต้องการ, 1 = ไม่มีการพัฒนาในรอบนี้", "", "", 10},

		// แผนกพัฒนาซอฟต์แวร์ (รวม 55)
		{"คุณภาพโค้ดและการทดสอบ", "ความถูกต้องและความน่าเชื่อถือของงานที่ส่งมอบ",
			"5 = ไม่พบบั๊กหลังส่งมอบและมีการทดสอบครบ, 3 = พบบั๊กเล็กน้อยแก้ได้ทัน, 1 = พบบั๊กบ่อยกระทบงานอื่น", "พัฒนาซอฟต์แวร์", "", 30},
		{"การส่งมอบตามสเปก", "ฟีเจอร์ครบตามข้อกำหนดที่ตกลงไว้",
			"5 = ครบทุกข้อและเกินสเปก, 3 = ครบข้อหลัก ขาดข้อรองบางส่วน, 1 = ขาดข้อหลักหรือแก้ไขซ้ำหลายรอบ", "พัฒนาซอฟต์แวร์", "", 25},

		// แผนกการตลาด (รวม 55)
		{"ผลลัพธ์แคมเปญ", "ผลลัพธ์เทียบกับเป้าหมายของแคมเปญ",
			"5 = เกินเป้าหมายตั้งแต่ 10% ขึ้นไป, 3 = ได้ตามเป้าหมาย, 1 = ต่ำกว่าเป้าหมายมาก", "การตลาด", "", 30},
		{"ความคิดสร้างสรรค์", "เสนอแนวคิดใหม่ที่นำไปใช้ได้จริง",
			"5 = เสนอแนวคิดที่ถูกนำไปใช้หลายครั้ง, 3 = มีแนวคิดใหม่เป็นบางครั้ง, 1 = ทำตามแบบเดิมเท่านั้น", "การตลาด", "", 25},

		// เกณฑ์เฉพาะระดับ senior ทุกแผนก
		{"การเป็นพี่เลี้ยง", "ให้คำปรึกษาและช่วยพัฒนาเพื่อนร่วมงานรุ่นน้อง",
			"5 = พี่เลี้ยงให้น้องทำงานเองได้หลายคน, 3 = ตอบคำถามเมื่อถูกขอ, 1 = ไม่ช่วยเหลือน้อง", "", "senior", 10},
	}
	for _, c := range criteria {
		if have[c.Name+"|"+c.Dept+"|"+c.Level] {
			log.Printf("skip criteria (exists): %s", c.Name)
			continue
		}
		row := domain.Criteria{Name: c.Name, Description: c.Desc, Rubric: c.Rubric, Department: c.Dept, Level: c.Level, Weight: c.Weight, IsActive: true}
		if err := evalRepo.CreateCriteria(&row); err != nil {
			log.Fatalf("create criteria %s: %v", c.Name, err)
		}
		log.Printf("created criteria: %s (แผนก=%q ระดับ=%q)", c.Name, c.Dept, c.Level)
	}

	log.Println("seed เสร็จสิ้น | บัญชีทดสอบ: hr@ / executive@ / accounting@ / manager1-2@ / employee1-6@ (example.com)")
}
