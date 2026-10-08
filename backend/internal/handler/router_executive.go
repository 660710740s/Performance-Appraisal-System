package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func registerExecutiveRoutes(authed *gin.RouterGroup, h *ReportHandler) {
	exec := authed.Group("/executive", middleware.RequireRoles(domain.RoleExecutive))
	exec.GET("/summary", h.Summary)

	authed.GET("/reports/summary",
		middleware.RequireRoles(domain.RoleHR, domain.RoleExecutive), h.Summary)
}
