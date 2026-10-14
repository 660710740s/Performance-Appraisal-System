package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func registerAccountingRoutes(authed *gin.RouterGroup, h *AccountingHandler) {
	// เงินเดือน: Accounting เหมือนเดิม
	g := authed.Group("/accounting", middleware.RequireRoles(domain.RoleAccounting))
	g.GET("/salaries", h.ListCurrentSalaries)
	g.GET("/salaries/:employee_id/history", h.SalaryHistory)
	g.POST("/salaries", h.SetSalary)

	// โบนัส: HR เสนอ/แก้ยอด, Accounting + Executive ดูรายการได้
	bonus := authed.Group("/accounting")
	bonus.GET("/bonuses",
		middleware.RequireRoles(domain.RoleHR, domain.RoleAccounting, domain.RoleExecutive), h.ListBonuses)
	bonus.GET("/bonus-candidates",
		middleware.RequireRoles(domain.RoleHR), h.Candidates)
	bonus.POST("/bonuses",
		middleware.RequireRoles(domain.RoleHR), h.CreateBonus)
	bonus.PUT("/bonuses/:id",
		middleware.RequireRoles(domain.RoleHR), h.UpdateBonus)

	bonus.POST("/bonuses/bulk",
		middleware.RequireRoles(domain.RoleHR), h.CreateBonusesBulk)

	// Executive อนุมัติโบนัส (เหมือนเดิม)
	exec := authed.Group("/executive/bonuses", middleware.RequireRoles(domain.RoleExecutive))
	exec.GET("", h.ListBonuses)
	exec.POST("/:id/approve", h.Approve)
	exec.POST("/approve-bulk", h.ApproveBulk)
	exec.POST("/:id/reject", h.Reject)
}
