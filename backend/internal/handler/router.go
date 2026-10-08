package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func SetupRouter(jwtSecret string, auth *AuthHandler, user *UserHandler, eval *EvaluationHandler, acc *AccountingHandler, rpt *ReportHandler, promo *PromotionHandler) *gin.Engine {
	r := gin.Default()
	r.Use(middleware.CORS())

	r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })

	api := r.Group("/api/v1")
	api.POST("/auth/login", auth.Login)

	authed := api.Group("")
	authed.Use(middleware.Auth(jwtSecret))
	{
		authed.GET("/me", auth.Me)

		// users
		authed.POST("/users", middleware.RequireRoles(domain.RoleHR), user.Create)
		authed.GET("/users", middleware.RequireRoles(domain.RoleHR), user.List)
		authed.PUT("/users/:id", middleware.RequireRoles(domain.RoleHR), user.Update)
		authed.PATCH("/users/:id/deactivate", middleware.RequireRoles(domain.RoleHR), user.Deactivate)
		authed.PATCH("/users/:id/activate", middleware.RequireRoles(domain.RoleHR), user.Activate)
		authed.GET("/team", middleware.RequireRoles(domain.RoleManager, domain.RoleHR), user.Team)

		// cycles & criteria
		authed.GET("/cycles", eval.ListCycles)
		authed.POST("/cycles", middleware.RequireRoles(domain.RoleHR), eval.CreateCycle)
		authed.PUT("/cycles/:id", middleware.RequireRoles(domain.RoleHR), eval.UpdateCycle)
		authed.GET("/criteria", eval.ListCriteria)
		authed.POST("/criteria", middleware.RequireRoles(domain.RoleHR, domain.RoleManager), eval.CreateCriteria)
		authed.PUT("/criteria/:id", middleware.RequireRoles(domain.RoleHR), eval.UpdateCriteria)

		// evaluations
		mgr := middleware.RequireRoles(domain.RoleManager, domain.RoleHR)
		authed.POST("/evaluations", eval.Create)
		authed.GET("/evaluations/me", eval.ListMine)
		authed.GET("/evaluations/given", eval.ListGiven) // ไม่จำกัดบทบาท: พนักงานต้องเห็น self-evaluation ที่ตัวเองสร้าง
		authed.GET("/evaluations/:id", eval.Get)
		authed.PUT("/evaluations/:id", eval.UpdateDraft)
		authed.POST("/evaluations/:id/submit", eval.Submit)
		authed.POST("/evaluations/:id/approve", mgr, eval.Approve)
		authed.POST("/evaluations/:id/reject", mgr, eval.Reject)
		authed.POST("/evaluations/:id/feedback", eval.AddFeedback)

		// reports & audit
		hr := middleware.RequireRoles(domain.RoleHR)
		authed.GET("/reports/evaluations", hr, rpt.ListEvaluations)
		authed.GET("/audit-logs", hr, rpt.AuditLogs)
		authed.GET("/reports/annual", middleware.RequireRoles(domain.RoleHR, domain.RoleExecutive), rpt.Annual)
		authed.GET("/employees/:id/evaluations", rpt.EmployeeHistory) // สิทธิ์ตรวจใน service

		// role-specific route groups
		registerAccountingRoutes(authed, acc)
		registerExecutiveRoutes(authed, rpt)
		registerCareerRoutes(authed, promo)
	}
	return r
}
