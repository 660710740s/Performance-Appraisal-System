package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
)

// GET /employees/:id/evaluations
func (h *ReportHandler) EmployeeHistory(c *gin.Context) {
	id, ok := parseIDParam(c, "id")
	if !ok {
		return
	}
	out, err := h.svc.EmployeeHistory(middleware.UserID(c), middleware.UserRole(c), id)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}