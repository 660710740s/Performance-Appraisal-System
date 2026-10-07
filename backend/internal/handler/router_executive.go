package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

// คนทำ Executive/Report: แทนที่ notImplemented ด้วย handler จริงในไฟล์นี้
func registerExecutiveRoutes(authed *gin.RouterGroup) {
	exec := authed.Group("/executive", middleware.RequireRoles(domain.RoleExecutive))
	exec.GET("/summary", notImplemented)

	authed.GET("/reports/summary",
		middleware.RequireRoles(domain.RoleHR, domain.RoleExecutive), notImplemented)
}