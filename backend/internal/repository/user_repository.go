package repository

import (
	"gorm.io/gorm"
	"performance/backend/internal/domain"
)

type userRepository struct{ db *gorm.DB }

func NewUserRepository(db *gorm.DB) domain.UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) Create(u *domain.User) error {
	return r.db.Create(u).Error
}

func (r *userRepository) GetByID(id uint) (*domain.User, error) {
	var u domain.User
	if err := r.db.First(&u, id).Error; err != nil {
		return nil, mapErr(err)
	}
	return &u, nil
}

func (r *userRepository) GetByEmail(email string) (*domain.User, error) {
	var u domain.User
	if err := r.db.Where("email = ?", email).First(&u).Error; err != nil {
		return nil, mapErr(err)
	}
	return &u, nil
}

func (r *userRepository) List() ([]domain.User, error) {
	var users []domain.User
	err := r.db.Order("id").Find(&users).Error
	return users, err
}

func (r *userRepository) ListByManager(managerID uint) ([]domain.User, error) {
	var users []domain.User
	err := r.db.Where("manager_id = ?", managerID).Order("id").Find(&users).Error
	return users, err
}

func (r *userRepository) Update(u *domain.User) error {
	return r.db.Save(u).Error
}
