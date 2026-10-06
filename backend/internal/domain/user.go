package domain

import "time"

type Role string

const (
	RoleAdmin      Role = "admin"
	RoleHR         Role = "hr"
	RoleManager    Role = "manager"
	RoleEmployee   Role = "employee"
	RoleAccounting Role = "accounting"
	RoleExecutive  Role = "executive"
)

type User struct {
	ID           uint      `gorm:"primaryKey" json:"id"`
	EmployeeCode string    `gorm:"uniqueIndex;size:50;not null" json:"employee_code"`
	Name         string    `gorm:"size:255;not null" json:"name"`
	Email        string    `gorm:"uniqueIndex;size:255;not null" json:"email"`
	PasswordHash string    `gorm:"not null" json:"-"`
	Role         Role      `gorm:"size:20;not null;default:employee" json:"role"`
	Department   string    `gorm:"size:100" json:"department"`
	Position     string    `gorm:"size:100" json:"position"`
	ManagerID    *uint     `gorm:"index" json:"manager_id"`
	IsActive     bool      `gorm:"default:true" json:"is_active"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type UserRepository interface {
	Create(u *User) error
	GetByID(id uint) (*User, error)
	GetByEmail(email string) (*User, error)
	List() ([]User, error)
	ListByManager(managerID uint) ([]User, error)
}
