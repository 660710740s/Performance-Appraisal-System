package service

import (
	"golang.org/x/crypto/bcrypt"
	"performance/backend/internal/domain"
)

type CreateUserInput struct {
	EmployeeCode string
	Name         string
	Email        string
	Password     string
	Role         domain.Role
	Department   string
	Position     string
	ManagerID    *uint
}

type UserService struct{ users domain.UserRepository }

func NewUserService(users domain.UserRepository) *UserService {
	return &UserService{users: users}
}

func (s *UserService) Create(in CreateUserInput) (*domain.User, error) {
	if existing, _ := s.users.GetByEmail(in.Email); existing != nil {
		return nil, domain.ErrConflict
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(in.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	u := &domain.User{
		EmployeeCode: in.EmployeeCode, Name: in.Name, Email: in.Email,
		PasswordHash: string(hash), Role: in.Role, Department: in.Department,
		Position: in.Position, ManagerID: in.ManagerID, IsActive: true,
	}
	if err := s.users.Create(u); err != nil {
		return nil, err
	}
	return u, nil
}

func (s *UserService) GetByID(id uint) (*domain.User, error) { return s.users.GetByID(id) }
func (s *UserService) List() ([]domain.User, error)          { return s.users.List() }
func (s *UserService) Team(managerID uint) ([]domain.User, error) {
	return s.users.ListByManager(managerID)
}

type UpdateUserInput struct {
	EmployeeCode string
	Name         string
	Email        string
	Role         domain.Role
	Department   string
	Position     string
	ManagerID    *uint
}

func (s *UserService) Update(id uint, in UpdateUserInput) (*domain.User, error) {
	u, err := s.users.GetByID(id)
	if err != nil || u == nil {
		return nil, domain.ErrNotFound
	}
	// เช็กอีเมลซ้ำ เฉพาะตอนเปลี่ยนอีเมล
	if in.Email != u.Email {
		if existing, _ := s.users.GetByEmail(in.Email); existing != nil && existing.ID != id {
			return nil, domain.ErrConflict
		}
	}
	// กันตั้งตัวเองเป็นหัวหน้าตัวเอง
	if in.ManagerID != nil && *in.ManagerID == id {
		return nil, domain.ErrConflict
	}
	u.EmployeeCode = in.EmployeeCode
	u.Name = in.Name
	u.Email = in.Email
	u.Role = in.Role
	u.Department = in.Department
	u.Position = in.Position
	u.ManagerID = in.ManagerID
	if err := s.users.Update(u); err != nil {
		return nil, err
	}
	return u, nil
}

// SetActive เปิด/ปิดใช้งาน (soft delete) ห้าม HR ปิดตัวเอง
func (s *UserService) SetActive(actorID, id uint, active bool) (*domain.User, error) {
	if !active && actorID == id {
		return nil, domain.ErrConflict
	}
	u, err := s.users.GetByID(id)
	if err != nil || u == nil {
		return nil, domain.ErrNotFound
	}
	u.IsActive = active
	if err := s.users.Update(u); err != nil {
		return nil, err
	}
	return u, nil
}
