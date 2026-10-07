package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

// คนทำ Accounting: แทนที่ notImplemented ด้วย handler จริงในไฟล์นี้
func registerAccountingRoutes(authed *gin.RouterGroup) {
	g := authed.Group("/accounting", middleware.RequireRoles(domain.RoleAccounting))
	g.GET("/salaries", notImplemented)
	g.POST("/salaries", notImplemented)
	g.GET("/bonuses", notImplemented)
	g.POST("/bonuses", notImplemented)
}