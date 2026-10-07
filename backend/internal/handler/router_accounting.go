package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func registerAccountingRoutes(authed *gin.RouterGroup, h *AccountingHandler) {
	g := authed.Group("/accounting", middleware.RequireRoles(domain.RoleAccounting))
	g.GET("/salaries", h.ListCurrentSalaries)
	g.GET("/salaries/:employee_id/history", h.SalaryHistory)
	g.POST("/salaries", h.SetSalary)
	g.GET("/bonus-candidates", h.Candidates)
	g.GET("/bonuses", h.ListBonuses)
	g.POST("/bonuses", h.CreateBonus)
	g.PUT("/bonuses/:id", h.UpdateBonus)

	// Executive อนุมัติโบนัส
	exec := authed.Group("/executive/bonuses", middleware.RequireRoles(domain.RoleExecutive))
	exec.GET("", h.ListBonuses)
	exec.POST("/:id/approve", h.Approve)
	exec.POST("/:id/reject", h.Reject)
}