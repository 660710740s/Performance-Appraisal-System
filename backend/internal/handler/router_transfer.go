package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func registerTransferRoutes(authed *gin.RouterGroup, t *TransferHandler) {
	// HR เสนอโอนย้าย
	hr := authed.Group("/hr/transfers", middleware.RequireRoles(domain.RoleHR))
	hr.GET("", t.List)
	hr.POST("", t.Create)

	// Executive อนุมัติ
	exec := authed.Group("/executive/transfers", middleware.RequireRoles(domain.RoleExecutive))
	exec.GET("", t.List)
	exec.POST("/:id/approve", t.Approve)
	exec.POST("/:id/reject", t.Reject)
}
