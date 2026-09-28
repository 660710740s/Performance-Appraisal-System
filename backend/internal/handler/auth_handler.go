package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type AuthHandler struct {
	auth  *service.AuthService
	users *service.UserService
}

func NewAuthHandler(a *service.AuthService, u *service.UserService) *AuthHandler {
	return &AuthHandler{auth: a, users: u}
}

type loginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req loginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	token, user, err := h.auth.Login(req.Email, req.Password)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, gin.H{"token": token, "user": user})
}

func (h *AuthHandler) Me(c *gin.Context) {
	u, err := h.users.GetByID(middleware.UserID(c))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, u)
}
