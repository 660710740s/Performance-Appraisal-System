package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
	"performance/backend/internal/service"
)

type UserHandler struct{ users *service.UserService }

func NewUserHandler(u *service.UserService) *UserHandler { return &UserHandler{users: u} }

type createUserRequest struct {
	EmployeeCode string      `json:"employee_code" binding:"required"`
	Name         string      `json:"name" binding:"required"`
	Email        string      `json:"email" binding:"required,email"`
	Password     string      `json:"password" binding:"required,min=8"`
	Role         domain.Role `json:"role" binding:"required,oneof=admin hr manager employee accounting executive"`
	Department   string      `json:"department"`
	Position     string      `json:"position"`
	ManagerID    *uint       `json:"manager_id"`
}

func (h *UserHandler) Create(c *gin.Context) {
	var req createUserRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, err)
		return
	}
	u, err := h.users.Create(service.CreateUserInput{
		EmployeeCode: req.EmployeeCode, Name: req.Name, Email: req.Email, Password: req.Password,
		Role: req.Role, Department: req.Department, Position: req.Position, ManagerID: req.ManagerID,
	})
	if err != nil {
		response.Error(c, err)
		return
	}
	response.Created(c, u)
}

func (h *UserHandler) List(c *gin.Context) {
	users, err := h.users.List()
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, users)
}

// ลูกทีมของ manager ที่ล็อกอินอยู่
func (h *UserHandler) Team(c *gin.Context) {
	users, err := h.users.Team(middleware.UserID(c))
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, users)
}
