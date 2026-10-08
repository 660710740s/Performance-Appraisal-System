package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func registerCareerRoutes(authed *gin.RouterGroup, p *PromotionHandler) {
	// HR เสนอเลื่อนตำแหน่ง
	hr := authed.Group("/hr/promotions", middleware.RequireRoles(domain.RoleHR))
	hr.GET("", p.List)
	hr.POST("", p.Create)

	// Executive อนุมัติ
	exec := authed.Group("/executive/promotions", middleware.RequireRoles(domain.RoleExecutive))
	exec.GET("", p.List)
	exec.POST("/:id/approve", p.Approve)
	exec.POST("/:id/reject", p.Reject)
}
