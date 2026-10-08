package handler

import (
	"github.com/gin-gonic/gin"
	"performance/backend/internal/domain"
	"performance/backend/internal/middleware"
)

func registerTrainingRoutes(authed *gin.RouterGroup, h *TrainingHandler) {
	mgr := middleware.RequireRoles(domain.RoleManager, domain.RoleHR)
	authed.GET("/training-plans", h.List) // ขอบเขตการเห็นตรวจใน service
	authed.POST("/training-plans", mgr, h.Create)
	authed.PUT("/training-plans/:id", mgr, h.Update)
	authed.PATCH("/training-plans/:id/status", mgr, h.UpdateStatus)
}
