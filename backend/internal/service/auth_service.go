package service

import (
	"time"

	"golang.org/x/crypto/bcrypt"
	"performance/backend/internal/domain"
	"performance/backend/internal/pkg/jwtutil"
)

type AuthService struct {
	users  domain.UserRepository
	secret string
	ttl    time.Duration
}

func NewAuthService(users domain.UserRepository, secret string, ttl time.Duration) *AuthService {
	return &AuthService{users: users, secret: secret, ttl: ttl}
}

func (s *AuthService) Login(email, password string) (string, *domain.User, error) {
	u, err := s.users.GetByEmail(email)
	if err != nil {
		return "", nil, domain.ErrUnauthorized
	}
	if !u.IsActive || bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(password)) != nil {
		return "", nil, domain.ErrUnauthorized
	}
	token, err := jwtutil.Generate(s.secret, u.ID, string(u.Role), s.ttl)
	if err != nil {
		return "", nil, err
	}
	return token, u, nil
}
