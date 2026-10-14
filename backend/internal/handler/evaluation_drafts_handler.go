package handler

import (
	"github.com/gin-gonic/gin"

	"performance/backend/internal/middleware"
	"performance/backend/internal/pkg/response"
)

// POST /cycles/:id/generate-drafts (HR) สร้างร่างแบบประเมินให้ทุกคนในรอบ
func (h *EvaluationHandler) GenerateDrafts(c *gin.Context) {
	id, ok := parseIDParam(c, "id")
	if !ok {
		return
	}
	out, err := h.svc.GenerateDrafts(middleware.UserID(c), id)
	if err != nil {
		response.Error(c, err)
		return
	}
	response.OK(c, out)
}
